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
      {% for field in FIELDS %}
         def create(t : {{field[:t]}}.class){% if field[:t].type_vars.size > 0 %} forall {{field[:t].type_vars.first}} {% end %}
           # Generic classes can't be assigned to instance variables:
           # can't infer the type of instance variable '@__temp_49'
           {% if  field[:t].type_vars.size == 0 %}@%name{field} ||= {% end %} \
           {{field[:t]}}.new(
             {% for deps in field[:deps]%}create({{deps}}),
             {% end %}
           )
         end
      {% end %}
    {% end %}
  end
end

macro inject(*args)
  {% PicoContainer::FIELDS << {t: @type, deps: args} %}
end
