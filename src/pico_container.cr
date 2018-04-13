require "./pico_container/*"

module PicoContainer
  FIELDS = [] of Nil
  CONTAINER_OPTIONS = {} of Nil => Nil

  macro included
    # it seems crystal behavior has changed, not we want to do it in include???
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
  end
end

macro inject(*args)
  {% PicoContainer::FIELDS << {t: @type, deps: args} %}
end
