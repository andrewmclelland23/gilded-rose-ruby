require 'gilded_rose'

describe GildedRose do

  describe "#update_sell_in" do

    context "normal item" do
      it 'should reduce sell_in by 1' do
        item = Item.new("foo", 5, 5)
        GildedRose.new([item]).update_sell_in(item)
        expect(item.sell_in).to eq 4
      end
    end

    context "Sulfuras special item" do
      it 'should not change sell_in' do
        item = Item.new("Sulfuras, Hand of Ragnaros", 5, 5)
        GildedRose.new([item]).update_sell_in(item)
        expect(item.sell_in).to eq 5
      end
    end
  end

  describe "#update_items" do

    context "normal item" do
      context "sell_in > 0, quality > 0" do
        it 'should reduce quality by 1' do
          items = [Item.new("foo", 5, 5)]
          GildedRose.new(items).update_items
          expect(items[0].quality).to eq 4
        end
      end
      context "sell_in = 0, quality > 0" do
        it 'should reduce quality by 2' do
          items = [Item.new("foo", 0, 5)]
          GildedRose.new(items).update_items
          expect(items[0].quality).to eq 3
        end
      end
      context "quality = 0" do
        it 'should not reduce quality' do
          items = [Item.new("foo", 5, 0)]
          GildedRose.new(items).update_items
          expect(items[0].quality).to eq 0
        end
      end
      context "sell_in = 0, quality = 1" do
        it 'should reduce quality by 1' do
          items = [Item.new("foo", 0, 1)]
          GildedRose.new(items).update_items
          expect(items[0].quality).to eq 0
        end
      end
    end

    context "Aged Brie item" do
      context "sell_in > 0, quality < 50" do
        it 'should increase quality by 1' do
          items = [Item.new("Aged Brie", 5, 5)]
          GildedRose.new(items).update_items
          expect(items[0].quality).to eq 6
        end
      end
      context "sell_in < 1, quality < 49" do
        it 'should increase quality by 2' do
          items = [Item.new("Aged Brie", 0, 5)]
          GildedRose.new(items).update_items
          expect(items[0].quality).to eq 7
        end
      end
      context "quality = 50" do
        it 'should not change quality' do
          items = [Item.new("Aged Brie", 5, 50)]
          GildedRose.new(items).update_items
          expect(items[0].quality).to eq 50
        end
      end
    end

    context "Backstage passes" do
      context "sell_in > 10, quality < 50" do
        it 'should increase quality by 1' do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 11, 5)]
          GildedRose.new(items).update_items
          expect(items[0].quality).to eq 6
        end
      end
      context "5 < sell_in <= 10, quality < 49" do
        it 'should increase quality by 2' do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 5)]
          GildedRose.new(items).update_items
          expect(items[0].quality).to eq 7
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 6, 5)]
          GildedRose.new(items).update_items
          expect(items[0].quality).to eq 7
        end
      end
      context "0 < sell_in <= 5, quality < 49" do
        it 'should increase quality by 3' do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 5)]
          GildedRose.new(items).update_items
          expect(items[0].quality).to eq 8
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 1, 5)]
          GildedRose.new(items).update_items
          expect(items[0].quality).to eq 8
        end
      end
      context "sell_in = 0" do
        it 'should reduce quality to 0' do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 5)]
          GildedRose.new(items).update_items
          expect(items[0].quality).to eq 0
        end
      end
    end

    context "Sulfuras item" do
      context "sell_in > 0, quality < 50" do
        it 'should not change quality' do
          items = [Item.new("Sulfuras, Hand of Ragnaros", 5, 5)]
          GildedRose.new(items).update_items
          expect(items[0].quality).to eq 5
        end
      end
      context "sell_in < 1, quality < 49" do
        it 'should not change quality' do
          items = [Item.new("Sulfuras, Hand of Ragnaros", 0, 5)]
          GildedRose.new(items).update_items
          expect(items[0].quality).to eq 5
        end
      end
      context "quality = 50" do
        it 'should not change quality' do
          items = [Item.new("Sulfuras, Hand of Ragnaros", 5, 50)]
          GildedRose.new(items).update_items
          expect(items[0].quality).to eq 50
        end
      end
    end
  end
end
