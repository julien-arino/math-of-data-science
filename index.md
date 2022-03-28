## MATH 2740 (Mathematics of Data Science)

On the [GitHub version](https://github.com/julien-arino/math2740-of-data-science/) of the page, you have access to all the files. You can also download the entire repository by clicking the buttons on the left. (You can also of course clone this repo, but you will need to do that from the GitHub version of the site.)

### Slides

<ul>
{% for html in site.static_files %}
  {% if html.path contains 'slides' %}
    {% if html.path contains 'MATH2740' %}
      {% if html.path contains 'html' %}
        <li><a href="https://julien-arino.github.io/math2740-of-data-science/slides/{{ html.basename }}.html">{{ html.basename }}</a></li>
      {% endif %}
    {% endif %}
  {% endif %}
{% endfor %}
{% for pdf in site.static_files %}
  {% if pdf.path contains 'slides' %}
    {% if pdf.path contains 'MATH2740' %}
      {% if pdf.path contains 'pdf' %}
        {% unless pdf.path contains 'LightBoard' %}
          <li><a href="https://julien-arino.github.io/math2740-of-data-science/slides/{{ pdf.basename }}.pdf">{{ pdf.basename }}</a></li>
        {% endunless %}
      {% endif %}
    {% endif %}
  {% endif %}
{% endfor %}
</ul>

Feel free to use the material in these slides or in the folders. If you find this useful, I will be happy to know.
