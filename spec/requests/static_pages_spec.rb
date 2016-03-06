require 'spec_helper'
require "rails_helper"


describe "Static pages" do

  let(:base_title) {"My first Rails app"}

  describe "Home page" do

    it "should have the content 'Sample App'" do
      visit root_path
      expect(page).to have_content('Sample App')
    end

    it "should have the title 'Home'" do
      visit root_path
      expect(page).to have_title("#{base_title}")
    end
  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit help_path
      expect(page).to have_content('Help')
    end

    it "should have the title 'Help'" do
      visit help_path
      expect(page).to have_title("#{base_title} | Help")
    end
  end

  describe "About page" do

    it "should have the content 'About Us'" do
      visit about_path
      expect(page).to have_content('About Us')
    end

    it "should have the title 'About Us'" do
      visit about_path
      expect(page).to have_title("#{base_title} | About Us")
    end
  end

  describe "Contact page" do

    it "should have the content 'About Us'" do
      visit contact_path
      expect(page).to have_content('Contact Us')
    end

    it "should have the title 'Contact Us'" do
      visit contact_path
      expect(page).to have_title("#{base_title} | Contact Us")
    end
  end

end