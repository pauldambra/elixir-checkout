defmodule CheckoutTest do
  use ExUnit.Case
  doctest Checkout

  # Item   Unit      Special
  #          Price     Price
  #   --------------------------
  #     A     50       3 for 130
  #     B     30       2 for 45
  #     C     20
  #     D     15

  setup do
    scans = [
      %{items: [:A], total: 50},
      %{items: [:B], total: 30},
      %{items: [:C], total: 20},
      %{items: [:D], total: 15},
      %{items: [:A, :A], total: 100},
      %{items: [:B, :B], total: 45},
      %{items: [:A, :B], total: 80},
      %{items: [:A, :A, :A], total: 130},
      %{items: [:A, :A, :A, :A, :A], total: 230},
      %{items: [:A, :A, :A, :B, :B], total: 175},
    ]
    {:ok, data: scans}
  end

  test "scanning an item adds it to the basket" do
    checkout = Checkout.scan %Checkout{}, :A
    assert checkout.basket == %{A: 1, B: 0, C: 0, D: 0}
  end

  test "totalling a checkout can give a result" do
    checkout = Checkout.scan %Checkout{}, :A
    assert Checkout.total(checkout) == 50
  end

  test "scanning a basket gives expected total cost", %{data: scans} do
    Enum.each(scans,
              fn(scan) ->
                total = Enum.reduce(
                        scan.items,
                        %Checkout{},
                        fn(item, chkot) -> Checkout.scan(chkot, item) end
                      )
                      |> Checkout.total
                assert total == scan.total
              end
    )
  end
end
