class CustomerSerializer < Fars2::ObjectSerializer
  attributes :email, :name, :city, :street_name, :building_number, :zip_code,
             :credit_card_number, :credit_card_expiry_date, :credit_card_type,
             :created_at, :updated_at

  def created_at
    object.created_at.strftime('%FT%T%:z')
  end

  def updated_at
    object.updated_at.strftime('%FT%T%:z')
  end
end
