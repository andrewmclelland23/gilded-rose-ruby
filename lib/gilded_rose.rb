require_relative 'item'

class GildedRose

  NON_STANDARD_ITEMS = ["Aged Brie", "Backstage passes to a TAFKAL80ETC concert"]
  STATIC_ITEMS = ["Sulfuras, Hand of Ragnaros"]

  def initialize(items)
    @items = items
  end

  def update_items
    @items.each do |item|
      next if STATIC_ITEMS.include? item.name

      update_sell_in(item)
      if NON_STANDARD_ITEMS.include? item.name
        update_quality_non_standard(item)
      else
        update_quality_standard(item)
      end
    end
  end

  def update_quality_standard(item)
    quality_change = item.sell_in < 1 ? 2 : 1
    item.quality -= quality_change
    item.quality = 0 if item.quality < 0
  end

  def update_quality_non_standard(item)
    item.quality = item.quality + 1
    if item.name == "Backstage passes to a TAFKAL80ETC concert"
      if item.sell_in <= 10
        item.quality = item.quality + 1
      end
      if item.sell_in <= 5
        item.quality = item.quality + 1
      end
      if item.sell_in <= 0
        item.quality = 0
      end
    else
      item.quality = item.quality + 1 if item.sell_in < 1
    end
    item.quality = 50 if item.quality > 50
  end

    def update_sell_in(item)
      item.sell_in -= 1
    end
end
