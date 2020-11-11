class PodcastPolicy < ApplicationPolicy
    def update?
      user_is_owner? || user_admin? || minimal_admin?
    end

    def new?
        true
    end

    def create?
        !user_is_banned?
    end
    
    def delete_confirm?
        update?
    end
    
    def destroy?
        update?
    end
    
    def preview?
        true
    end

    def permitted_attributes
        %i[
        android_url image itunes_url main_color_hex overcast_url pattern_image
        slug soundcloud_url twitter_username website_url title feed_url description]
    end

    private

    def user_is_owner?
        if record.instance_of?(Podcast)
          record.user_id == user.id
        else
          record.pluck(:user_id).uniq == [user.id]
        end
    end
end