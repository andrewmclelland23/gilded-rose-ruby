require 'gilded_rose'

describe GildedRose do

  subject(:gilded_rose) { described_class }

  describe "#update_sell_in" do

    it 'should reduce sell_in by 1' do
      item = Item.new("foo", 5, 5)
      gilded_rose.new([item]).update_sell_in(item)
      expect(item.sell_in).to eq 4
    end
  end

  describe "#update_quality_standard" do

    context "sell_in > 1, quality > 0" do
      it 'should reduce quality by 1' do
        item = Item.new("foo", 2, 5)
        gilded_rose.new([item]).update_quality_standard(item)
        expect(item.quality).to eq 4
      end
    end
    context "sell_in < 1, quality > 0" do
      it 'should reduce quality by 2' do
        item = Item.new("foo", 0, 5)
        gilded_rose.new([item]).update_quality_standard(item)
        expect(item.quality).to eq 3
        item = Item.new("foo", -1, 5)
        gilded_rose.new([item]).update_quality_standard(item)
        expect(item.quality).to eq 3
      end
    end
    context "quality = 0" do
      it 'should not reduce quality' do
        item = Item.new("foo", 0, 0)
        gilded_rose.new([item]).update_quality_standard(item)
        expect(item.quality).to eq 0
      end
    end
  end

  describe "#update_quality_non_standard" do
    context "Aged Brie item" do
      context "sell_in > 0, quality < 50" do
        it 'should increase quality by 1' do
          item = Item.new("Aged Brie", 5, 5)
          gilded_rose.new([item]).update_quality_non_standard(item)
          expect(item.quality).to eq 6
        end
      end
      context "sell_in < 1, quality < 49" do
        it 'should increase quality by 2' do
          item = Item.new("Aged Brie", 0, 48)
          gilded_rose.new([item]).update_quality_non_standard(item)
          expect(item.quality).to eq 50
          item = Item.new("Aged Brie", -1, 48)
          gilded_rose.new([item]).update_quality_non_standard(item)
          expect(item.quality).to eq 50
        end
      end
      context "quality = 50" do
        it 'should not change quality' do
          item = Item.new("Aged Brie", 5, 50)
          gilded_rose.new([item]).update_quality_non_standard(item)
          expect(item.quality).to eq 50
        end
      end
      context "quality = 49, sell_in < 1" do
        it 'should add 1 to quality (not 2) due to max possible being 50' do
          item = Item.new("Aged Brie", 0, 49)
          gilded_rose.new([item]).update_quality_non_standard(item)
          expect(item.quality).to eq 50
        end
      end
    end

    context "Backstage passes" do
      context "sell_in > 10, quality < 50" do
        it 'should increase quality by 1' do
          item = Item.new("Backstage passes to a TAFKAL80ETC concert", 11, 5)
          gilded_rose.new(item).update_quality_non_standard(item)
          expect(item.quality).to eq 6
        end
      end
      context "5 < sell_in < 10, quality < 49" do
        it 'should increase quality by 2' do
          item = Item.new("Backstage passes to a TAFKAL80ETC concert", 9, 5)
          gilded_rose.new(item).update_quality_non_standard(item)
          expect(item.quality).to eq 7
          item = Item.new("Backstage passes to a TAFKAL80ETC concert", 6, 5)
          gilded_rose.new(item).update_quality_non_standard(item)
          expect(item.quality).to eq 7
        end
      end
      context "0 < sell_in <= 5, quality < 49" do
        it 'should increase quality by 3' do
          item = Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 5)
          gilded_rose.new(item).update_quality_non_standard(item)
          expect(item.quality).to eq 8
          item = Item.new("Backstage passes to a TAFKAL80ETC concert", 1, 5)
          gilded_rose.new(item).update_quality_non_standard(item)
          expect(item.quality).to eq 8
        end
      end
      context "sell_in = 0" do
        it 'should reduce quality to 0' do
          item = Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 5)
          gilded_rose.new(item).update_quality_non_standard(item)
          expect(item.quality).to eq 0
        end
      end
    end
  end

  describe '#update_items' do

    before(:each) do
      stub_const("GildedRose::STATIC_ITEMS", ["static item"])
      stub_const("GildedRose::NON_STANDARD_ITEMS", ["non standard item"])
    end

    context 'only item in items is included in STATIC_ITEMS' do
      it 'should not call any of the update methods on static item' do
        items = [Item.new("static item", 5, 5)]
        gr = gilded_rose.new(items)
        expect(gr).to_not receive :update_quality_standard
        expect(gr).to_not receive :update_quality_non_standard
        expect(gr).to_not receive :update_sell_in
        gr.update_items
      end
    end
    context 'only item in items is included in NON_STANDARD_ITEMS' do
      it 'should call update_sell_in and update_quality_non_standard' do
        items = [Item.new("non standard item", 5, 5)]
        gr = gilded_rose.new(items)
        expect(gr).to_not receive :update_quality_standard
        expect(gr).to receive :update_quality_non_standard
        expect(gr).to receive :update_sell_in
        gr.update_items
      end
    end
    context 'only item in items is standard item' do
      it 'should call update_sell_in and update_quality_standard' do
        items = [Item.new("standard item", 5, 5)]
        gr = gilded_rose.new(items)
        expect(gr).to receive :update_quality_standard
        expect(gr).to_not receive :update_quality_non_standard
        expect(gr).to receive :update_sell_in
        gr.update_items
      end
    end
  end
end
