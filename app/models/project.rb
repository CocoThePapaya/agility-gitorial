class Project < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    city :string
    timestamps
  end

  has_attached_file :report

  has_many :stories, :dependent => :destroy, :accessible => true, :include => [:tasks => :story]

  children :stories, :memberships

  has_many :memberships, :class_name => "ProjectMembership", :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user

  belongs_to :owner, :class_name => "User", :creator => true

  has_many :contributor_memberships, :class_name => "ProjectMembership", :scope => :contributor
  has_many :contributors, :through => :contributor_memberships, :source => :user

  belongs_to :country
  belongs_to :region, :conditions => Proc.new {"regions.country_id = #{country_id || 0}"}

  # permission helper
  def accepts_changes_from?(user)
    user.administrator? || user == owner || user.in?(contributors)
  end

  # --- Permissions --- #

  def create_permitted?
    owner_is? acting_user
  end

  def update_permitted?
    accepts_changes_from?(acting_user) && !owner_changed?
  end

  def destroy_permitted?
    acting_user.administrator? || owner_is?(acting_user)
  end

  def view_permitted?(field)
    acting_user.administrator? || acting_user == owner || acting_user.in?(members)
  end

end
