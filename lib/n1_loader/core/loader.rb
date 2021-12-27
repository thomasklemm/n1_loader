# frozen_string_literal: true

module N1Loader
  # Loader that performs the loading.
  #
  # Subclasses must define +perform+ method that accepts single argument
  # and returns hash where key is the element and value is what we want to load.
  class Loader
    def initialize(elements)
      @elements = elements
    end

    def for(element)
      if loaded.empty? && elements.any?
        raise NotFilled, "Nothing was preloaded, perhaps you forgot to use fulfill method"
      end
      raise NotLoaded, "The data was not preloaded for the given element" unless loaded.key?(element)

      loaded[element]
    end

    private

    attr_reader :elements

    def perform(_elements)
      raise NotImplemented, "Subclasses have to implement the method"
    end

    def fulfill(element, value)
      @loaded[element] = value
    end

    def loaded
      return @loaded if @loaded

      @loaded = {}.compare_by_identity

      if elements.size == 1 && respond_to?(:single)
        fulfill(elements.first, single(elements.first))
      elsif elements.any?
        perform(elements)
      end

      @loaded
    end
  end
end