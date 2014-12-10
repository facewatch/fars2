describe Fars2::ObjectSerializer do
  let(:product) { create(:product) }

  it "serializes object" do
    expect(product.serialize).to eq({ product: { isbn: product.isbn, product_name: product.product_name, price: product.price } }.to_json)
  end
end
