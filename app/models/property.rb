# frozen_string_literal: true

class Property < ApplicationRecord
  belongs_to :commune
  has_many :photos, as: :photoable, dependent: :destroy

  validates :price, numericality: { greater_than: 0 }
  validates :photos, length: { minimum: 1, message: 'Debe tener al menos una foto' }
  validates :commune, :address, presence: true
  validate :address_does_not_contain_contact_info

  private

  def address_does_not_contain_contact_info
    email_pattern = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b/
    url_pattern = %r{\b(?:https?|ftp)://\S+\b|\b\d{3}[-.\s]?\d{3}[-.\s]?\d{4}\b}
    # Formats +56 XXX-XXX-XXX, +56 9 XXXX-XXXX, XXX-XXX-XXX
    phone_number_patterns = [
      /\b(?:\+?56)?(?:[2-9])?\d{3}[-\s]?\d{3}[-\s]?\d{3}\b/,
      /\b(?:\+?56)?(?:9)\s?\d{4}[-\s]?\d{4}\b/,
      /\b(?:[2-9])?\d{3}[-\s]?\d{3}[-\s]?\d{3}\b/
    ]
    return unless address.present? && (address =~ email_pattern || address =~ url_pattern || phone_number_patterns.any? { |pattern| address =~ pattern })

    errors.add(:address, 'No debe contener información de contacto (correo electrónico, URL, número de teléfono)')
  end
end
