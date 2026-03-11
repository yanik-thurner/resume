#import "../../src/common-elements.typ": fix-width-text, hexagon, triangle

#let generate_template_data(
  language: "en",
  ) = {
  return (
    language: language,
  );
}

#let localization = (
  "contact-title": ("en": "Contact", "de": "Kontakt"),
  "education-title": ("en": "Education", "de": "Ausbildung"),
  "skills-title": ("en": "Skills", "de": "Kenntnisse"),
  "certification-title": ("en": "Certifications", "de": "Zertifizierungen"),
  "profile-title": ("en": "Profile", "de": "Profil"),
  "employment-title": ("en": "Work Experience", "de": "Berufserfahrung"),
  "project-title": ("en": "Projects", "de": "Projekte"),
)

#let titled-section(title: "title", icon: "", title_spacing: 0.9em, ..content) = {
  let title_text = text(size: 2em, weight: 400, title);
  stack(dir: ttb, title_text, v(title_spacing), ..content)
}

#let left-side(template_data: (:), personal_data: (:), education_data: (:), certification_data: (:)) = {
  let lang = template_data.language;
  let foreground_color = color.rgb("f8f9f9");
  let background_color = color.rgb("21606a");
  set text(fill: foreground_color)
  set par(leading: 2mm, justify: false)

  let image_box = {
    let gradient = 7%;

    show: stack(dir:ttb,
      image(personal_data.portrait),
      polygon(
        fill: background_color,
        (0%, 0% + 1pt),
        (0%, - gradient),
        (100%, 0% + 1pt),
      ),
    )
  };


  let contact-section(personal_data) = {
    show: stack(dir: ttb,
      spacing: 0.9em,
      link("mailto:" + personal_data.mail)[#text(personal_data.mail)],
      link("https://" + personal_data.website)[#text(personal_data.website)],
      link("tel:" + personal_data.phone.replace(" ", ""))[#text(personal_data.phone)],
      text(personal_data.location),
    );
  };

  let education-section(education_data) = {
    let entries_array = ();

    for entry in education_data.history {
      let entry_text = stack(dir: ttb, spacing: 0.5em,
        text(weight: 500, entry.program),
        text(entry.degree + " @ " + entry.institution),
        text(entry.from + " - " + entry.to)
      );
      entries_array.push(entry_text);
    }

    show: stack(dir: ttb,
      spacing: 0.9em,
      ..entries_array
    );
  };

  let skill-section(personal_data) = {
    let entries_array = ();
    let skills = personal_data.skills.sorted()

    for (i, entry) in skills.enumerate() {
      let text_array = ();
      text_array.push(text(entry));
      if (i + 1) <  skills.len(){
        text_array.push(text(" · "));
      }
      box(fill: none, stack(dir: ltr, ..text_array))
    }
  };

  let certification-section(certification_data) = {
    let entries_array = ();
    for entry in certification_data {
      let entry_container = box()[
        #text(weight: 500, entry.name)
        #text(entry.level + " - " + entry.description)
      ];
      entries_array.push(entry_container);
    }

    show: stack(dir:ttb, spacing: 0.9em, ..entries_array);
  };

  let data_box = box(inset: (top: 1em, rest: 2em),
    stack(
      dir: ttb,
      spacing: 2em,
      titled-section(title: localization.at("contact-title").at(lang), contact-section(personal_data)),
      titled-section(title: localization.at("education-title").at(lang), education-section(education_data)),
      titled-section(title: localization.at("skills-title").at(lang), skill-section(personal_data)),
      titled-section(title: localization.at("certification-title").at(lang), certification-section(certification_data)),
    )
  );
  
  show: box(
    fill: background_color,
    width: 100%,
    height: 100%
  )[
    #stack(dir:ttb,
      image_box,
      data_box
    )
  ]

}

#let right-side(template_data: (:), personal_data: (:), employment_data: (:), project_data: (:), education_data: (:), certification_data: (:)) = {
  let background_color = white;
  let foreground_color = black.lighten(30%);
  let SPACING_SECTIONS = 5mm;
  let lang = template_data.language;

  set text(fill: foreground_color);

  let name-box(names, role) = context {
    let SPACING_NAMES = 0.3mm;
    let OFFSET_MIDDLE_NAME = 0.1mm;
    let OFFSET_YT_ALIGNMENT = -0.2em;
    let OFFSET_ROLE = 4mm;
    let OFFSET_LINE = 2mm;
    let SIZE_LINE = 0.5mm;

    let first-names-function(first_name) = { return text(size: 4em, weight: 700, first_name) };
    let last-names-function(last_name) = { return first-names-function(last_name) };

    let first_names = stack(dir: ltr, spacing: 0.3em, h(OFFSET_YT_ALIGNMENT), ..names.first_names.map(first-names-function));
    let last_names = stack(dir: ltr, spacing: 0.3em, ..names.last_names.map(last-names-function));

    let middle_names_width = calc.max(measure(first_names).width, measure(last_names).width);
    let middle-names-function(middle_names) = { return fix-width-text(target_width: middle_names_width, baseline: OFFSET_MIDDLE_NAME, weight: 200, middle_names) };
    let middle_names = stack(dir: ltr, spacing: 0.3em, middle-names-function(names.middle_names.join(" ")));
    
    show: stack(dir: ttb, spacing: OFFSET_ROLE,
      box(
        stroke: (left: SIZE_LINE + foreground_color),
        inset: (left: OFFSET_LINE, top: 0mm),
        stack(
          dir: ttb,
          spacing: 0.3em,
          first_names,
          //middle_names,
          last_names,
      )),
      fix-width-text(target_width: OFFSET_LINE + middle_names_width, weight: 200, role)
    );
  };

  let profile-box(motto) = {
    let SPACING_LINES = 2mm;
    set par(leading: SPACING_LINES, justify: false)
    show: text(motto)
  }

  let employment-box(employment_data) = {
    let entries_array = ();
    let line_distance = 1em;
    let SPACING_COMPANIES = 5mm;
    let SPACING_RESPONSIBILITIES = 3mm;
    let SPACING_TASKS = 2mm;
    let SIZE_TASK_MARKER = 1mm;
    let SIZE_COMPANY_MARKER = 2mm;
    let SIZE_LINE = 0.5mm;

    for entry in employment_data.history {
      let company_start = entry.positions.last().from;
      let company_end = entry.positions.first().to;
      let company_circle = place(dx: -line_distance - SIZE_COMPANY_MARKER, dy: -SIZE_COMPANY_MARKER, circle(radius: SIZE_COMPANY_MARKER, fill: background_color, stroke: SIZE_LINE + foreground_color));

      let position_containers = ();
      for position in entry.positions {
        let position_container = align(horizon + left, 
          stack(dir: ltr,
            box(width: 10em,
            text(size: 1em, position.from + " - " + position.to)),
            h(1em),
            text(weight: 500, position.title)
          )
        );
        position_containers.push(position_container);
      }
      
      let responsibilities_containers = ();
      for responsibility in entry.responsibilities {
        let tech_string = responsibility.technologies.join(" | ");
        let tasks_containers = ();
        for task in responsibility.tasks {
          let task_marker = box(baseline: SIZE_TASK_MARKER/2, triangle(side_length: SIZE_TASK_MARKER, fill: foreground_color))
          tasks_containers.push(align(horizon, stack(dir: ltr, spacing: 1mm, task_marker, text(task))));

        }

        let responsibility_container = stack(
          dir: ttb,
          spacing: SPACING_TASKS,
          text(weight: 500, responsibility.initiative),
          text(weight: 500, tech_string),
          ..tasks_containers
        );
        responsibilities_containers.push(responsibility_container)
      }

      let entry_container = stack(dir: ttb, spacing: SPACING_RESPONSIBILITIES, 
        align(horizon + left, stack(dir: ltr, company_circle, text(size: 1.5em, weight: 500, entry.company))),
        ..position_containers,
        ..responsibilities_containers,
      );

      entries_array.push(entry_container);
    }

    show: box(
      stroke: (left: SIZE_LINE + foreground_color),
      inset: (left: line_distance),
      stack(
        dir: ttb,
        spacing: SPACING_COMPANIES,
        ..entries_array
    ));
  }

  let project-box(project_data) = {
    let entries_array = ();
    let line_distance = 1em;
    let SPACING_PROJECTS = 4mm;
    let SPACING_DESCRIPTIONS = 1.8mm;
    set par(leading: 1mm, justify: false)

    for entry in project_data {
      let tech_string = entry.technologies.join(" | ");
      let name_box = text(size: 1.2em, weight: 500, entry.name);
      let project_entry = stack(dir: ttb, spacing: SPACING_DESCRIPTIONS,
        if entry.link != none {link(entry.link, name_box)} else { name_box },  
        text(entry.description), 
        text(weight: 500, tech_string)
      );
      entries_array.push(project_entry);
    }

    show: box(
      stack(
        dir: ttb,
        spacing: SPACING_PROJECTS,
        ..entries_array
    ));
  }

  show: box(
    fill: background_color,
    width: 100%,
    height: 100%,
    inset: 8mm,
  )[
    #stack(
      dir: ttb,
      spacing: SPACING_SECTIONS,
      name-box(personal_data.names, personal_data.role),
      v(3%),
      titled-section(title: localization.at("profile-title").at(lang), profile-box(personal_data.motto)),
      titled-section(title: localization.at("employment-title").at(lang), employment-box(employment_data)),
      titled-section(title: localization.at("project-title").at(lang), project-box(project_data)),
    )
  ];
}

#let first-page(template_data: (:), personal_data: (:), employment_data: (:), project_data: (:), education_data: (:), certification_data: (:)) = {
  show: grid(
    columns: (30%, 1fr),
    left-side(template_data: template_data, personal_data: personal_data, education_data: education_data, certification_data: certification_data),
    right-side(template_data: template_data, personal_data: personal_data, employment_data: employment_data, project_data: project_data),
  )
}

#let resume(template_data: (:), personal_data: (:), employment_data: (:), project_data: (:), education_data: (:), certification_data: (:)) = context {
  set page("a4", margin: 0pt)
  set text(font: "Onest", fill: gray, size: 9pt, weight: 300)

  first-page(template_data: template_data, personal_data: personal_data, employment_data: employment_data, project_data: project_data, education_data: education_data, certification_data: certification_data)
}
