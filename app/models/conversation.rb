# == Schema Information
# Schema version: 20090216032013
#
# Table name: conversations
#
#  id :integer(4)      not null, primary key
#

class Conversation < ApplicationRecord
  has_many :messages, -> { order("created_at DESC") }

  # current now, only offer will be as this field
  # if you use other object stored as this(for example req), please update this comment
  belongs_to :talkable, polymorphic: true

  # only will be used for the payment of an offer
  # actually, this is a transact which is a subclass of exchange
  belongs_to :exchange


end
