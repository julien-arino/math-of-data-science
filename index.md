## MATH 2740 (Mathematics of Data Science)

This GitHub repo contains material related to the University of Manitoba course MATH 2740, Mathematics of Data Science and reflects the organisation of the course when I ([Julien Arino](https://julien-arino.github.io/)) teach it.

Here, you will find the publicly available information: code, slides and some general information. All other information (syllabus, assignments, marks) is available through UM Learn.

### This GitHub repo

On the [GitHub version](https://github.com/julien-arino/math-of-data-science/) of the page, you have access to all the files. You can also download the entire repository by clicking the buttons on the left. (You can also of course clone this repo, but you will need to do that from the GitHub version of the site.)

Feel free to use the material in these slides or in the folders. If you find this useful, I will be happy to know.

### Slides
<ul>
{% for file in site.static_files %}
  {% if file.path contains 'SLIDES' %}
    {% if file.path contains 'math-2740' %}
      {% if file.path contains 'html' %}
        <li><a href="https://julien-arino.github.io/math-of-data-science/SLIDES/{{ file.basename }}.html">{{ file.basename }}</a></li>
      {% endif %}
      {% if file.path contains 'pdf' %}
        {% unless file.path contains 'LightBoard' %}
          <li><a href="https://julien-arino.github.io/math-of-data-science/SLIDES/{{ file.basename }}.pdf">{{ file.basename }}</a></li>
        {% endunless %}
      {% endif %}
    {% endif %}
  {% endif %}
{% endfor %}
</ul>


### Lecture notes

Some lecture notes are available [here](lecture-notes/MATH2740.pdf). Beware: these are not complete!

### Videos

The videos for the course are available on YouTube as a [playlist](https://youtube.com/playlist?list=PLfRaznSpWo2vQAn1jVyueTuAiryDaxkH3). Note that the videos are far from perfect.. the slides and the videos will be reworked prior to the next instance of the course (although the latter will hopefully be taught in person).

### Additional slides and videos

The following slides and videos are part of a set of "vignettes" about R (see [here](https://julien-arino.github.io/R-for-modellers/)). They are required reading/watching for the course as they explain some mechanisms that your R assignments will need to use.

- [Installing and loading packages](https://julien-arino.github.io/R-for-modellers/SLIDES/vignette-03-installing-using-packages.html) ([video](https://youtu.be/WPYHU2G7U7Q))