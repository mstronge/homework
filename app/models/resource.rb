class Resource < ActiveRecord::Base
  
  VALID_HTTP_REGEX = /\A(http:\/\/)/i

  attr_accessible :attachment, :attachment_cache, :tag, :link
  mount_uploader :attachment, ResourceUploader

  before_validation :set_tag
 
  validates :link, format: { with: VALID_HTTP_REGEX }, allow_blank: true
  validates :attachment, presence: true, if: :link_blank?
  validates :tag, presence: true

  protected
    
    def set_tag

      if !attachment.file.nil?
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

      self.tag = 'link' if !link.blank?
 
    end

    def link_blank?
      link.blank?
    end

end
