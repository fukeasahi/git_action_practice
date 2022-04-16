require 'rails_helper'

describe '投稿のテスト' do
  let(:book){create(:book, title: "hoge", body: "hoge")}
  describe 'トップ画面(top_path)のテスト' do
    before do
      visit  top_path
    end
    context '表示の確認' do
      it 'トップ画面(top_path)に「ここはTopページです」が表示されているか' do
        expect(page).to have_content "ここはTopページです" 
      end
      it 'top_pathが"/top"であるか' do
        expect(current_path).to eq("/top") 
      end
    end
  end

  describe "投稿画面(new_list_path)のテスト" do
    before do
      visit new_book_path
    end
    context '表示の確認' do
      it 'new_list_pathが"/lists/new"であるか' do
        expect(current_path).to eq("/book/new")
      end
      it '投稿ボタンが表示されているか' do
        expect(page).to have_button "投稿" 
      end
    end
    context '投稿処理のテスト' do
      it '投稿後のリダイレクト先は正しいか' do
          fill_in "book[title]", with: Faker::Lorem.characters(number:5)
          fill_in "book[body]",  with: Faker::Lorem.characters(number:10)
          click_button "投稿"
          expect(page).to have_current_path book_path(Book.last) 
      end
    end
  end

  describe "投稿一覧のテスト" do
    before do
      visit books_path
    end
    context '表示の確認' do
      it '投稿されたものが表示されているか' do
       expect(page).to have_content book.title
       expect(page).to have_link    book.title
      end
    end
  end

  describe "詳細画面のテスト" do
    before do
     visit book_path(book)
    end
    context '表示の確認' do
      it '削除リンクが存在しているか' do
        expect(page).to have_link "削除" 
      end
      it '編集リンクが存在しているか' do
        expect(page).to have_link "削除" 
      end
    end
    context 'リンクの遷移先の確認' do
      it '編集の遷移先は編集画面か' do
        edit_link = find_all("a")[3]  
        edit_link.click
        expect(page).to have_current_path edit_book_path(book) 
      end
    end
    context 'list削除のテスト' do
      it 'listの削除' do
        expect{book.destroy}.to change{Book.count}.by(-1)
      end
    end
  end

  describe '編集画面のテスト' do
    before do
      visit edit_book_path(book)
    end
    context '表示の確認' do
      it '編集前のタイトルと本文がフォームに表示(セット)されている' do
        expect(page).to have_field "book[title]", with: book.title
        expect(page).to have_field "book[body]",  with: book.body
      end
      it '保存ボタンが表示される' do
        expect(page).to have_button "保存" 
      end
    end
    context '更新処理に関するテスト' do
      it '更新後のリダイレクト先は正しいか' do
        fill_in "book[title]", with: Faker::Lorem.characters(number: 10)
        fill_in "book[body]",  with: Faker::Lorem.characters(number: 30)
        click_button "更新"
        expect(page).to have_button book_path(book) 
      end
    end
  end
end