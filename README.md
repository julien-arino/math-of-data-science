## MATH 2740 (Mathematics of Data Science)

On the [GitHub version](https://github.com/julien-arino/math2740-of-data-science/) of the site, you have access to all the files.

<ul>
{% for pdf in site.static_files %}
  {% if pdf.path contains 'slides' %}
    {% if pdf.path contains 'MATH2740' %}
      {% if pdf.path contains 'pdf' %}
        <li><a href="{{ pdf.path }}">{{ pdf.basename }}</a></li>
      {% endif %}
    {% endif %}
  {% endif %}
{% endfor %}
</ul>
