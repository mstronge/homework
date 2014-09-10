class Resource < ActiveRecord::Base
  
  has_and_belongs_to_many :lessons

  VALID_HTTP_REGEX = /\A(http)/i

  attr_accessible :attachment, :attachment_cache, :tag, :link
  mount_uploader :attachment, ResourceUploader

  before_validation :set_tag_and_valid_name
 
  validates :link, format: { with: VALID_HTTP_REGEX }, allow_blank: true
  validates :attachment, presence: true, if: :link_blank?
  validates :tag, presence: true
  validates :name, presence: true, :uniqueness  => { :case_sensitive => false }

  scope :equal_param, ->(hash){ where(hash.reject{|k,v| v.blank? || k =~ /^(date)/ }) }

  protected
    
    def set_tag_and_valid_name
      if !attachment.file.nil?
        
        self.name = attachment.file.original_filename if self.name.blank?

        if /(pdf)$/i =~ attachment.content_type
          self.tag = 'pdf' 
        elsif /(jpg|jpeg|gif|png)$/i =~ attachment.content_type 
          self.tag = 'image'
        elsif /(mp3|ogg|wav|flac)$/i =~ attachment.content_type 
          self.tag = 'audio'
        elsif /(mp4|mp2|mpeg|vob|ogv|mk|flv)$/i =~ attachment.content_type 
          self.tag = 'video'
        elsif 
          self.tag = 'other'
        end
      
        self.link = nil
      end
      
      if !link.blank?
        self.tag = 'linkk' 
        self.name = link if self.name.blank?
      end

      check = Resource.equal_param(name: self.name).first
      check_id = check.present? ? check.id : nil
      errors.add(:name," the name resources not unique") if check_id.present? && check_id != self.id

    end

    def link_blank?
      link.blank?
    end

end
