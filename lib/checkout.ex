defmodule Checkout do

  defstruct [
    basket: %{A: 0, B: 0, C: 0, D: 0}
  ]

  def scan(checkout, code) do
    new_value = checkout.basket[code] + 1
    %{checkout | basket: Map.put(checkout.basket, code, new_value)}
  end

  def total(checkout) do
    Enum.reduce(checkout.basket, 0, fn(basket_item, acc) ->
      {sku, quantity} = basket_item
      acc + get_price(sku, quantity)
    end)
  end

  def calculate_discount(discount, discountMultiple, quantity),
    do: trunc(quantity / discountMultiple) * discount

  defp discount_for(:A, quantity), do: calculate_discount(20.00, 3, quantity)
  defp discount_for(:B, quantity), do: calculate_discount(15.00, 2, quantity)
  defp discount_for(_, _),  do:  0.00

  defp price_of(sku), do: %{A: 50, B: 30, C: 20, D: 15}[sku]
  defp get_price(sku, quantity),
    do: price_of(sku) * quantity - discount_for(sku, quantity)
end
