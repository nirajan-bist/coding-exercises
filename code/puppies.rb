#!/usr/bin/env ruby

require 'nokogiri'

# The Puppies class provides methods to parse HTML files and extract URLs of puppies
# that are labeled as "Female - Baby". It works by scanning a directory for linked
# HTML pages, parsing each page, and collecting relevant links.
#
# Constants:
# - DIRECTORY: The directory path where the HTML files are stored.
#
# Class Methods:
# - .parse: Parses all linked HTML pages and returns an array of href strings for
#   puppies labeled as "Female - Baby".
# - .find_linked_pages: Finds and returns an array of file paths to linked HTML
#   pages referenced in the main 'paws.html' file.
class Puppies
  DIRECTORY = ::File.join(::File.dirname(__FILE__), '../data')

  # Parses linked HTML pages to extract URLs of puppies that are labeled as "Female - Baby".
  # @return [Array<String>] an array of href strings for "Female - Baby" puppies.
  def self.parse
    puppies = []
    links = find_linked_pages

    links.each do |link|
      doc = Nokogiri::HTML(File.read(link))
      doc.css('#dogs .dog a').each do |a|
        if a.text.include?('Female - Baby')
          href = a['href']
          puppies << href
        end
      end
    end

    return puppies
  end

  # Find all linked pages in the paws.html file.
  # @return [String] Array of file paths to linked pages.
  def self.find_linked_pages
    index_file_path = ::File.join(DIRECTORY, 'paws.html')
    doc = Nokogiri::HTML(File.read(index_file_path))
    links = []

    # Find all pagination links
    doc.css('nav.pagination a.page-link').each do |a|
      href = a['href']
      next unless href && href.end_with?('.html')

      full_path = ::File.join(DIRECTORY, href)
      links << full_path if ::File.exist?(full_path)
    end

    return links.uniq
  end

end

