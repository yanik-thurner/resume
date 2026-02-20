#import "2024_colors.typ": *
#import "../../src/svg.typ": svg as predefined_svg, svg_text
#import "../../src/containers.typ": two-side-aligned-container, inline-stack
#import "../../src/typst-util.typ": weight_int
#import "../../src/common-elements.typ": shell-block, shell-line

/****##############################################################################################################****\
|***##################################################### DATA #####################################################***|
\****##############################################################################################################****/
#let generate_template_data(
  language: "en",
  user_name: "example-user",
  profile_picture_path: "path/to/profile/picture",
  repository_name: "example-repo",
  repository_visibility: "Public",
  nr_watches: 1,
  nr_forks: 1,
  nr_stars: 1,
  nr_branches: 1,
  nr_tags: 1,
  commit_message: "message of last commit",
  commit_hash: "ffffff",
  commit_date: "today",
  commit_count: 1,
  read_me_message: "fixed typos",
  contributors_images: (),
) = {
  return (
  user_name: user_name, 
  profile_picture_path: profile_picture_path,
  repository_name: repository_name, 
  repository_visibility: repository_visibility,
  nr_watches: nr_watches,
  nr_forks: nr_forks,
  nr_stars: nr_stars,
  nr_branches: nr_branches,
  nr_tags: nr_tags,
  commit_message: commit_message,
  commit_hash: commit_hash,
  commit_date: commit_date,
  commit_count: commit_count,
  read_me_message: read_me_message,
  contributors_images: contributors_images
);
}


/****##############################################################################################################****\
|***################################################### ELEMENTS ###################################################***|
\****##############################################################################################################****/
/*~~ ELEMENTS - COMMON ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#let svg(file, fill: color_font_mid, width: 2.5mm) = {
  show: predefined_svg("/styles/github/icons/" + file + ".svg", fill: fill, width: width)
}

#let default-border = color_borders + 0.05em;

#let user-image(profile_picture, size: 15pt) = {
  let image_content = image(profile_picture, width: size, height: size);
  let border = circle(width: size, height: size, stroke: default-border)[];

  show: box(
    width: size, 
    height: size,
    align(horizon, 
      // hide weird clipping rastarization
      stack(dir: ttb,
        box(width: size, height: size, radius: 100%, clip: true)[#image_content],
        place(dy: -size, border)
      )
    )
  )
}

#let number-bubble(number, size: 8pt) = {
  show: box(
    fill: color_number_bubble, 
    radius: 50%, 
    outset: 22%, 
    inset: (left: 0.1em, right: 0.1em), 
    height: size,
    align(center + horizon, 
      svg_text(number, size: size, weight: 600)
    )
  )
}

#let button(
  icon_name: none,
  description: none, 
  counter: none, 
  fill: none, 
  icon_size: 1em,
  icon_color: color_font_mid, 
  font_size: none,
  font_color: none, 
  font_weight: none, 
  stroke_size: 0.06em, 
  stroke_color: color_borders, 
  height: 1.9em, 
  inset: (left: 7%, right: 7%, top: 10%, bottom: 10%), 
  drop_down: false, 
  drop_down_separation: false,
) = context {
  let box_fill = if fill == none { box.fill } else { fill };
  let font_color = if font_color == none { text.fill } else { font_color };
  let font_size = if font_size == none { text.size } else { font_size };
  let font_weight = if font_weight == none { weight_int(text.weight) } else { weight_int(font_weight) };

  let drop_down_separation_element = line(
    start: (0em, 0em), 
    length: if height == auto { 100% } else { height },
    angle: 90deg,
    stroke: default-border
  );

  let drop_down_element = svg("drop-down", fill: icon_color, width: 1.1em);

  let elements = ();
  if icon_name != none { elements.push(svg(icon_name, fill: icon_color, width: icon_size)) }
  if description != none { elements.push(svg_text(str(description), weight: font_weight, fill: font_color, size: font_size)) }
  if counter != none { elements.push(number-bubble(counter, size: font_size)) }
  if drop_down and drop_down_separation {
    elements.push(h(8pt));
    elements.push(drop_down_separation_element);
  }
  if drop_down {elements.push(drop_down_element) }

  show: box(
    height: height,
    width: auto,
    fill: box_fill,
    stroke: stroke_size + stroke_color,
    radius: 1mm,
    inset: inset,
    align(horizon,
      stack(dir: ltr, spacing: 2%, ..elements)
    )
  )
}

/*~~ ELEMENTS - FIRST-PAGE TOP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#let visibility-tag(visibility, size: 7.5pt) = {
  let visibility_text = svg_text(size: size, fill: color_font_mid, weight: 600, visibility);

  show: box(
    stroke: default-border,
    inset: (top: 25%, bottom: 25%, left: 15%, right: 15%),
    radius: 50%,
    visibility_text
  )
}

#let body-title-button(icon_name: none, description: none, counter: none, drop_down_separation: false) = {
  show: button(
    icon_name: icon_name, 
    icon_size: 8pt, 
    description: description, 
    fill: color_header_background,
    font_size: 7pt, 
    font_color: color_font_dark,
    font_weight: 700, 
    height: 1.4em, 
    counter: counter, 
    drop_down: true, 
    drop_down_separation: drop_down_separation
  );
}

/*~~ ELEMENTS - FIRST-PAGE MAIN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#let file-table-entry(icon_name: "file", file_name: "file.txt", commit_message: "fixed bug", commit_link: none, commit_date: "just now") = {
  let commit_content = text(fill: color_font_mid, weight: 400, str(commit_message));
  return (
    box(baseline: -0.3em)[#svg(icon_name, width: 1.1em, fill: color_font_mid)],
    text(fill: color_font_dark, weight: 400, str(file_name)),
    if (commit_link == none) { commit_content } else { link(commit_link, commit_content)},
    text(fill: color_font_mid, weight: 400, str(commit_date)), table.hline()
  );
}

#let job-as-shell(personal_data: (:), job) = {
  let output = ();
  let lang = "sh";

  for position in job.positions{
  output.push(shell-line(prompt: "> ", lang: lang, "[ {'" + position.from + "'..'" + position.to + "'} = '" + position.title + "' ]"));
}
  if job.keys().contains("skills") and job.skills.len() > 0 {
  output.push(shell-line(prompt: "# ", lang: lang, "Common Skills: `" + job.skills.join("|").replace(" ", "_") + "`"));
}
  for responsibility in job.responsibilities {
  output.push(shell-line(prompt: "~ ", lang: lang, "'" + responsibility.initiative + "':`" + responsibility.technologies.sorted().join("|").replace(" ", "_") + "`"));
  for task in responsibility.tasks {
  output.push(shell-line(prompt: "+ ", lang: none, indentation_level:2, task)); 
}
}
  let user = lower(personal_data.names.first_names.at(0));
  let host = lower(job.company.replace(" ", "-"));
  let dir = "~";
  let command = "more ./employment_details.txt";
  let user_colors = (fg: color_font_dark, bg: blue.lighten(85%));
  let host_colors = (fg: rgb(job.color_fg), bg: rgb(job.color_bg));
  let dir_colors = user_colors;
  let command_colors = (fg: color_font_dark, bg: color_header_background);
  let url = if job.keys().contains("link") { job.link } else { none };

  show: shell-block(user: "", host: host, dir: dir, command: command, url: job.link, lang: "bash", fill: color_header_background, user_colors: user_colors, host_colors: host_colors, dir_colors: dir_colors, command_colors: command_colors, output);
}

#let project-as-shell(personal_data: (:), project) = {
  let output = (); 
  let lang = "sh";

  output.push(shell-line(lang: "txt", project.description));

  if project.keys().contains("technologies") and project.technologies.len() > 0 {
  output.push(shell-line(prompt: "# ", lang: lang, "Tech: `" + project.technologies.join("|").replace(" ", "_") + "`"));
}

  let user = lower(personal_data.names.first_names.at(0));
  let public_project = if project.keys().contains("link") and project.link != none { true } else { false };
  let host = if public_project { "github" } else { "private" };
  let host_colors = (fg: white, bg: if public_project { green } else { red });
  let dir = lower(project.name);
  let command = "more ./project_details.txt";
  let user_colors = (fg: color_font_dark, bg: blue.lighten(85%));
  let dir_colors = user_colors;
  let command_colors = (fg: color_font_dark, bg: color_header_background);

  show: shell-block(user: "", host: host, dir: dir, command: command, url: project.link, lang: "bash", fill: color_header_background, user_colors: user_colors, host_colors: host_colors, dir_colors: dir_colors, command_colors: command_colors, output);
}

/*~~ ELEMENTS - FIRST-PAGE SIDE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#let user-portrait(portrait_picture) = {
  show: stack(dir: ttb,
    v(0.6em), // spacing to get in line with file box
    box(
      stroke: default-border,
      image(portrait_picture)
    )
  )
}

#let topic-bubble(content) = {
  let bubble_content = text(content, size: 0.8em, weight: 500, fill: color_topic_bubble_fg);

  show: box(
    fill: color_topic_bubble_bg,
    radius: 50%,
    inset: 0.4em,
    align(
      center+horizon,
      bubble_content
    )
  )
}

#let education-entry(education_history_entry: (:)) = {
  set par(leading: 0.3em, justify: false, spacing: 0.3em)
  set text(size: 0.8em)
  text(weight: 700, fill: color_font_dark, education_history_entry.program)
  linebreak()
  text(weight: 500, education_history_entry.degree + " @ " + education_history_entry.institution)
  linebreak()
  text(weight: 500, education_history_entry.from + "-" + education_history_entry.to)
}

#let certification-entry(certification_entry) = {
  set par(leading: 0.3em, justify: false, spacing: 0.3em)
  set text(size: 0.8em)
  text(weight: 700, fill: color_font_dark, certification_entry.name + " - " + certification_entry.level)
  linebreak()
  set text(weight: 500)
  text(weight: 500, certification_entry.description)
}

/*~~ ELEMENTS - HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#let header-searchbar = {
  let search_bar_text = stack(dir: ltr, spacing: 0.5em,
    svg_text("Type", size: 6pt, weight: 500),
    box(width: 1.8mm, height: 2.6mm, stroke: default-border, radius: 0.6mm, inset: (left: 30%), baseline: 20%)[#svg_text("/", size: 6pt)],
    svg_text("to search", size: 6pt, weight: 500)
  );

  show: box(
    stroke: 0.09em + color_borders,
    inset: 1.25mm,
    radius: 1mm,
    align(horizon + left,
      stack(dir: ltr, spacing: 0.3em,
        box[#svg("search")],
        box(width: 5cm, baseline: 10%, search_bar_text)
      )
    )
  )
}

#let header-button(icon_name: none, drop_down: false, inset: 1.25mm) = {
  show: button(
    icon_name: icon_name, 
    height: auto,
    fill: color_header_background,
    stroke_size: 0.2mm,
    inset: inset,
    drop_down: drop_down
  )
};

#let header-tab(icon, title, selected: false) = context {
  let title_text = svg_text(title, fill: color_font_dark, weight: 400);
  let tab_stroke = none;
  let title_text_width = measure(title_text).width;

  // after `measure` so it doesn't change tab width, even with bold font
  if selected {
    title_text = svg_text(title, fill: color_font_dark, weight: 600);
    tab_stroke = (bottom: color_tab_highlight);
  }

  show: box(
    height: 1.5em,
    inset: (left: 0.56em, right: 0.51em),
    stroke: tab_stroke,
    align(top,
      grid(
        columns: (auto, title_text_width),
        align: (top + left, bottom + right),
        inset: ((:), (bottom: 0.21em)),
        gutter: 0.85em,
        svg(icon),
        block(width: 100pt, title_text)
      )
    )
  )
}

/****##############################################################################################################****\
|***################################################### CONTAINER ##################################################***|
\****##############################################################################################################****/

/*~~ CONTAINER - HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#let header-title-bar(template_data: (:)) = {

  let left_side = (
    header-button(icon_name: "menu"), 
    box[#svg("logo", fill: color_logo, width: 5mm)], 
    box[#text(template_data.user_name)#h(0.55em)#text("/")#h(0.55em)#text(template_data.repository_name, weight: 600, fill: color_font_dark)],
  );
  let right_side = (
    header-searchbar, 
    h(2mm), 
    box(width: 0.15mm, height: 3.3mm, fill: color_borders),
    h(2mm), 
    header-button(icon_name: "add", drop_down: true, inset: (top: 1.25mm, bottom: 1.25mm, left: 1.25mm, right: 2mm),), 
    header-button(icon_name: "issues"), 
    header-button(icon_name: "pull-request"), 
    header-button(icon_name: "notifications"), 
    user-image(template_data.profile_picture_path),
  );

  show: two-side-aligned-container(left_elements: left_side, right_elements: right_side, left_spacing: 2%, right_spacing: 2%, inset: 0.7em)
}

#let header-repo-navigation() = {
  block(
    width: 100%, height: 2em, inset: (left: 1em, top: 0em),
  )[
    #stack(
      dir: ltr, inline-stack(
        dir: ltr, spacing: 0.53em, 
        header-tab("code", "Code", selected: true), 
        //header-tab("issues", "Issues"), // might confuse HR people more than necessary lol
        header-tab("pull-request", "Pull requests"), 
        header-tab("actions", "Actions"), 
        header-tab("projects", "Projects"), 
        header-tab("book", "Wiki"), 
        header-tab("security", "Security"), 
        header-tab("insights", "Insights"),
      ),
    )
  ]
}

/*~~ CONTAINER - FIRST-PAGE TOP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#let body-title-bar(template_data: (:)) = {
  let left_side = (
    box[#user-image(template_data.profile_picture_path, size: 16pt)], 
    box[#svg_text(size: 13pt, fill: color_font_dark,  weight: 600, template_data.repository_name)],
    visibility-tag(template_data.repository_visibility, size: 7pt),
  );
  let right_side = (
    body-title-button(icon_name: "eye", description: "Watch", counter: template_data.nr_watches, drop_down_separation: false), 
    body-title-button(icon_name: "fork", description: "Fork", counter: template_data.nr_forks, drop_down_separation: true), 
    body-title-button(icon_name: "star", description: "Star", counter: template_data.nr_stars, drop_down_separation: true), 
  );
  show: two-side-aligned-container(left_elements: left_side, right_elements: right_side, left_spacing: 2%, right_spacing: 2%, height: 3.2%, stroke: (bottom: default-border))
}

/*~~ CONTAINER - FIRST-PAGE MAIN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#let body-repo-navigation(number_branches: 0, number_tags: 0) = {
  set text(size: 0.8em);
  let left_side = (
    button(icon_name: "branch", height: 1.7em, description: "main", fill: color_header_background, font_color: color_font_dark, font_size: 0.9em, font_weight: 600, drop_down: true),
    box[#box[#svg("branch")] #svg_text(fill: color_font_dark, weight:600, number_branches) #svg_text("Branches")],
    box[#box[#svg("tag")] #svg_text(fill: color_font_dark, weight:600, number_tags) #svg_text("Tags")]
  );
  let right_side = (
    button(description: "Go to file", height: 1.7em, inset: (top: 7%, bottom: 7%, left: 15%, right: 15%), fill: color_header_background, font_size: 0.9em, font_weight: 600, font_color: color_font_dark ),
    button(icon_name: "add", height: 1.7em, inset: (top: 7%, bottom: 7%, left: 20%, right: 20%), fill: color_header_background ),
    button(icon_name: "code", height: 1.7em, icon_color: color_code_button_fg, description: "Code", fill: color_code_button_bg, font_color: color_code_button_fg, font_size: 0.9em, stroke_color: color_code_button_bg, drop_down: true ),
  );
  show: two-side-aligned-container(left_elements: left_side, right_elements: right_side, left_spacing: 2%, right_spacing: 2%, )
}

#let file-table-header(template_data: (:)) = {
  let left_side = (
    user-image(template_data.profile_picture_path),
    text(fill: color_font_dark, template_data.user_name),
    text(fill: color_font_mid, weight: 400, template_data.commit_message)
  );

  let right_side = (
    text(fill: color_font_mid, weight: 400, size: 0.9em, str(template_data.commit_hash) + " · " + str(template_data.commit_date)),
    h(0.9em),
    svg("history", width: 1.1em),
    text(fill: color_font_dark, size: 0.8em, str(template_data.commit_count))
  );

  show: two-side-aligned-container(left_elements: left_side, right_elements: right_side, left_spacing: 0.4em, right_spacing: 0.4em)
}

#let major-titled-section(title: "title", ..content) = {
  let content_array = content.pos();

  if title != none {
    let title_text = text(title, size: 1.4em, weight: 600, fill: color_font_dark);
    content_array.insert(0, title_text);
    content_array.insert(1, line(length: 100%, stroke: default-border))
  }

  show: stack(dir: ttb, spacing: 0.5em, ..content_array);
}

#let major-titled-sections(..sections) = {
  let sections_array = ()

  for (i, section) in sections.pos().enumerate() {
    sections_array.push(section)
  }

  show: stack(dir: ttb, spacing: 1em, ..sections_array)
}

#let file-table(template_data: (:), personal_data: (:)) = {
  set text(size: 0.9em);
  set table.hline(stroke: default-border)
  let header_cell = table.cell(colspan: 4, fill: color_header_background, inset: (left: 0.8em, right: 1em), file-table-header(template_data: template_data));

  show: box(stroke: default-border, radius: 1mm, clip: true,
    table(
      columns: (3%, 17%, 60%, 20%),
      rows: 2.2em,
      align: (left+horizon, left + horizon, left + horizon, right + horizon),
      stroke: (none),
      inset: (left: 1em, right: 1em),
      header_cell,
      table.hline(), 
      ..file-table-entry(file_name: "name.txt", commit_message: str(personal_data.names.values().flatten().join(" "))),
      ..file-table-entry(file_name: "birthdate.txt", commit_message: str(personal_data.birthdate)),
      ..file-table-entry(file_name: "phone.txt", commit_message: str(personal_data.phone), commit_link: "tel:" + personal_data.phone.replace(" ", "")),
      ..file-table-entry(file_name: "mail.txt", commit_message: str(personal_data.mail), commit_link: "mailto:" + personal_data.mail),
      ..file-table-entry(file_name: "README.md", commit_message: str(template_data.read_me_message)),
    )
  )
}

#let readme-box(personal_data: (:), employment_data: (:), project_data: ()) = context {
  let readme_logo = stack(
    dir: ltr,
    spacing: 0.3em,
    box(
      baseline: 15%,
      svg(width: 1.0em, "book")
    ),
    text(fill: color_font_dark, size: 0.9em, "README")
  );

  let box_header = align(left + horizon,
    box(height: 2em, readme_logo)
  );

  let box_content = major-titled-sections(
        major-titled-section(title: "Professional Experience", ..employment_data.history.map(job-as-shell.with(personal_data: personal_data))),
        major-titled-section(title: "Projects", ..project_data.map(project-as-shell.with(personal_data: personal_data)))
  );

  show: box(stroke: default-border, radius: 1mm, width: 100%)[
    #set table.hline(stroke: default-border)
    #table(columns: (100%), rows: (auto, auto), align: top + left, stroke: none, inset: 1%, 
      table.header(box_header),
      table.hline(),
      box_content
    )
  ]
}

/*~~ CONTAINER - FIRST-PAGE SIDE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#let topic-bubble-container(sort-alphabetically: true, content) = {
  set par(leading: 0.2em, justify: false, spacing: 0.2em)
  set text(size: 0.8em)

  show: align(top + left,
    box()[
      #for word in content {
        topic-bubble(word)
        h(1pt)
      }
    ]
  )
}

#let minor-titled-section(title: "title", counter: none, ..content) = {
  let content_array = content.pos()

  if title != none {
    let title_elements = ();
    let title_text = text(title, size: 1em, weight: 600, fill: color_font_dark);
    title_elements.push(title_text);

    if counter != none {
      let title_counter = number-bubble(counter);
      title_elements.push(title_counter);
    }

    let title_bar = stack(dir: ltr, spacing: 0.5em, ..title_elements);
    content_array.insert(0, title_bar);
  }

  show: stack(dir: ttb, spacing: 0.8em, ..content_array)
}

#let minor-titled-sections(..sections) = {
  let sections_array = ()

  for (i, section) in sections.pos().enumerate() {
    sections_array.push(section)
    if i != sections.pos().len() - 1 {
      sections_array.push(line(length: 100%, stroke: default-border))
    }
  }

  show: stack(dir: ttb, spacing: 1em, ..sections_array)
}


#let education-container(education_history: (:)) = {
  //let sorted_history = education_history.sorted(key: it => (it.from, it.to));
  let entries = ();
  for entry in education_history {
    entries.push(education-entry(education_history_entry: entry));
  }

  stack(dir: ttb, spacing: 0.6em, ..entries)
}

#let contributors-container(contributors_images) = {
  for image in contributors_images {
    user-image(image, size: 4em)
  }
}

#let certificate-container(certification_data) = {
  let entries = ();

  for entry in certification_data {
    entries.push(certification-entry(entry));
  }

  stack(dir: ttb, spacing: 0.6em, ..entries)
}

/****##############################################################################################################****\
|***################################################### AREAS ###################################################***|
\****##############################################################################################################****/
/*~~ AREA - HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#let header-area(template_data) = {
  set text(0.7em);
  let header_area_content = stack(
    dir: ttb,
    // USER & REPO-NAME, SEARCH BAR
    header-title-bar(template_data: template_data),
    // REPOSITORY TABS (Code, Pull Requests, etc.)
    header-repo-navigation(),
    box(width: 100%, height: 0.1em, fill: color_borders)
  );

  show: box(
    width: 100%,
    fill: color_header_background,
    inset: 0em,
    header_area_content
  )
}

/*~~ AREA - FIRST-PAGE TOP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

/*~~ AREA - FIRST-PAGE MAIN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#let first-page-main-area(template_data: (:), personal_data: (:), employment_data: (:), project_data: (), education_data: (:)) = {
  set text(weight: 600)

  show: stack(dir: ttb, spacing: 8pt,
    body-repo-navigation(number_branches: template_data.nr_branches, number_tags: template_data.nr_tags),
    file-table(template_data: template_data, personal_data: personal_data),
    readme-box(personal_data: personal_data, employment_data: employment_data, project_data: project_data)
  )
}

/*~~ AREA - FIRST-PAGE SIDE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#let first-page-side-area(template_data: (:), personal_data: (:), education_data: (:), certification_data: (:)) = {
  let website_link = link("https://" + personal_data.website)[#box(height: 1.0em, align(left + horizon)[#stack(dir: ltr, spacing: 0.3em, svg("link", width: 0.8em ), text(personal_data.website, size: 0.8em, fill: color_link, weight: 600))])];

show:box(
  inset: (top: 0.4em),
    minor-titled-sections(
      minor-titled-section(title: "About", user-portrait(personal_data.portrait), website_link),
      minor-titled-section(title: "Skills", topic-bubble-container(personal_data.skills)),
      minor-titled-section(title: "Education", education-container(education_history: education_data.history)),
      minor-titled-section(title: "Contributors", counter: template_data.contributors_images.len(), contributors-container(template_data.contributors_images)),
      minor-titled-section(title: "Certificates", counter: certification_data.len(), certificate-container(certification_data))
    )
  )
}

/*~~ AREA - SECOND-PAGE MAIN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

/*~~ AREA - SECOND-PAGE SIDE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/


/****##############################################################################################################****\
|***#################################################### PAGES #####################################################***|
\****##############################################################################################################****/
#let first-page(template_data: (:), personal_data: (:), employment_data: (:), project_data: (:), education_data: (:), certification_data: (:), ..content) = {
  let top_content = body-title-bar(template_data: template_data);
  let main_content = first-page-main-area(template_data: template_data, personal_data: personal_data, employment_data: employment_data, project_data: project_data, education_data: education_data);
  let side_content = first-page-side-area(template_data: template_data, personal_data: personal_data, education_data: education_data, certification_data: certification_data);

  let center_content = grid(
    columns: (77.5%, 1fr),
    column-gutter: 1.5%,
    align: (top + center, top + left),
    main_content,
    side_content 
  );

  let page_content = stack(
    dir: ttb,
    spacing: 1em,
    top_content,
    center_content
  );

  show: page(box(inset: (left: 1.6%, right: 1.6%), page_content))
}

/****##############################################################################################################****\
|***################################################### DOCUMENT ###################################################***|
\****##############################################################################################################****/
#let resume(template_data: (:), personal_data: (:), employment_data: (:), project_data: (:), education_data: (:), certification_data: (:)) = context {
  set page("a4", margin: (top: 4em, bottom: 0%, left: 0%, right: 0%), header-ascent: 0%, header: header-area(template_data))
  set text(font: "Noto Sans", fill: color_font_mid, size: 10pt)

  // don't make raw text smaller than normal one.
  show raw: it => {
    set text(size: 1.2em); it
  }

  first-page(template_data: template_data, personal_data: personal_data, employment_data: employment_data, project_data: project_data, education_data: education_data, certification_data: certification_data)
}
