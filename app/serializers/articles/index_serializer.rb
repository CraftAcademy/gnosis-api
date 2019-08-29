class Articles::IndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :date, :city

  def date
    day = self.object.created_at.strftime("%d").to_i.ordinalize    
    month_and_year = self.object.created_at.strftime("%B, %Y")

    return "#{day} of #{month_and_year}"
  end
end
