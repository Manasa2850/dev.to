# send notifications about the new endorsement

module Notifications
  module NewEndorsement
    class Send
      include PushNotif

      def initialize(endorsement)
        @endorsement = endorsement
      end

      delegate :user_data, :endorsement_data, to: Notifications

      def self.call(*args)
        new(*args).call
      end

      def call
        json_data = {
          user: user_data(endorsement.user),
          endorsement: endorsement_data(endorsement)
        }

        targets = []
        user_id = current_user.id

        Notification.create(
          user_id: user_id,
          notifiable_id: endorsement.id,
          notifiable_type: endorsement.class.name,
          action: nil,
          json_data: json_data,
        )

        targets << "user-notifications-#{user_id}" if User.find_by(id: user_id)

        # Sends the push notification to Pusher Beams channels. Batch is in place to respect Pusher 100 channel limit.
        targets.each_slice(100) { |batch| send_push_notifications(batch) }
      end

      private

      attr_reader :endorsement

      def push_notification_payload
        title = "@#{endorsement.user.username}"
        subtitle = "re: #{endorsement.last.title.strip}"
        data_payload = { url: URL.url("/notifications/endorsements") }
        {
          apns: {
            aps: {
              alert: {
                title: title,
                subtitle: subtitle,
                body: CGI.unescapeHTML(endorsement.content.strip)
              }
            },
            data: data_payload
          },
          fcm: {
            notification: {
              title: title,
              body: subtitle
            },
            data: data_payload
          }
        }
      end
    end
  end
end
