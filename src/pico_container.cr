require "./pico_container/*"

module PicoContainer
  FIELDS = [] of Nil
  CONTAINER_OPTIONS = {} of Nil => Nil

  macro included
    \{%
      CONTAINER_OPTIONS[:initialized] = true
    %}
  end

  macro finished
    # Don't finalize the container until we include it in a class
    # this allows us to inject an interface and configure the
    # specific class in the final container
    {% if CONTAINER_OPTIONS[:initialized] %}
      \{% for field in FIELDS %}
         def create(t : \{{field[:t]}}.class)
           \{% for deps in field[:deps]%}
              # namespace separator "::" is not valid in variable names
              _\{{deps.resolve.name.downcase.tr("::", "_")}} = create(\{{deps}})
           \{% end %}

           @\{{field[:t].name.downcase.tr("::", "_")}} ||= \{{field[:t]}}.new(
             \{% for deps in field[:deps]%}
                _\{{deps.resolve.name.downcase.tr("::", "_")}},
           \{% end %}
           )
         end
      \{% end %}
    {% end %}
  end
end

macro inject(*args)
  {% PicoContainer::FIELDS << {t: @type, deps: args} %}
end
