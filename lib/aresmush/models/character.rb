module AresMUSH
  class Character
    include ObjectModel

    key :password_hash, String
    key :roles, Array
        
    belongs_to :room, :class_name => 'AresMUSH::Room'

    def change_password(raw_password)
      @password_hash = Character.hash_password(raw_password)
    end

    def compare_password(entered_password)
      hash = BCrypt::Password.new(@password_hash)
      hash == entered_password
    end
    
    def has_role?(name)
      self.roles.include?(name)
    end

    def has_any_role?(names)
      if (!names.respond_to?(:any?))
        has_role?(names)
      else
        names.any? { |n| self.roles.include?(n) }
      end
    end

    def self.exists?(name)
      existing_char = Character.find_by_name(name)
      return !existing_char.nil?
    end

    def self.hash_password(password)
      BCrypt::Password.create(password)
    end
  end
end
    