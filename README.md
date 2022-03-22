## MATH 2740 (Mathematics of Data Science)

On the [GitHub version](https://github.com/julien-arino/math2740-of-data-science/) of the site, you have access to all the files.

### Slides

<ul>
{% for html in site.static_files %}
  {% if html.path contains 'slides' %}
    {% if html.path contains 'MATH2740' %}
      {% if html.path contains 'html' %}
        <li><a href="slides/{{ html.path }}">{{ html.basename }}</a></li>
      {% endif %}
    {% endif %}
  {% endif %}
{% endfor %}
{% for pdf in site.static_files %}
  {% if pdf.path contains 'slides' %}
    {% if pdf.path contains 'MATH2740' %}
      {% if pdf.path contains 'pdf' %}
        {% unless pdf.path contains 'LightBoard' %}
          <li><a href="slides/{{ pdf.path }}">{{ pdf.basename }}</a></li>
        {% endunless %}
      {% endif %}
    {% endif %}
  {% endif %}
{% endfor %}
</ul>
