## MATH 2740 (Mathematics of Data Science)

On the [GitHub version](https://github.com/julien-arino/math2740-of-data-science/) of the page, you have access to all the files. You can also download the entire repository by clicking the buttons on the left. (You can also of course clone this repo, but you will need to do that from the GitHub version of the site.)

### Slides

<ul>
{% for file in site.static_files %}
  {% if file.path contains 'slides' %}
    {% if file.path contains 'MATH2740' %}
      {% if file.path contains 'html' %}
        <li><a href="https://julien-arino.github.io/math2740-of-data-science/slides/{{ file.basename }}.html">{{ file.basename }}</a></li>
      {% endif %}
      {% if file.path contains 'pdf' %}
        {% unless file.path contains 'LightBoard' %}
          <li><a href="https://julien-arino.github.io/math2740-of-data-science/slides/{{ file.basename }}.pdf">{{ file.basename }}</a></li>
        {% endunless %}
      {% endif %}
    {% endif %}
  {% endif %}
{% endfor %}
</ul>

Feel free to use the material in these slides or in the folders. If you find this useful, I will be happy to know.

### Videos

The videos for the course are available on YouTube as a [playlist](https://youtube.com/playlist?list=PLfRaznSpWo2vQAn1jVyueTuAiryDaxkH3). Note that the videos are far from perfect.. the slides and the videos will be reworked prior to the next instance of the course (although the latter will hopefully be taught in person).