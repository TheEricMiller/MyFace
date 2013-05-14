class Document < ActiveRecord::Base
  attr_accessible :attachment, :remove_attachment
  
  has_attached_file :attachment,
  path: ":attachment/:basename__:param.:extension"

  validates_attachment :attachment,
  size: { :in => 0..5.megabytes },
  content_type: { :content_type => [
  					'image/jpeg', 
  					'image/jpg', 
  					'image/png', 
  					'text/plain', 
  					'audio/mpeg', 
  					'application/pdf',
  					'application/zip'
  				]}


  attr_accessor :remove_attachment

  before_save :perform_attachment_removal
  def perform_attachment_removal
  	if remove_attachment == '1' && !attachment.dirty?
  		self.attachment = nil
  	end
  end

end
