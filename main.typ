
#let styles = ( "github2024": "./styles/github/2024.typ", "classic1": "./styles/classic/classic1.typ" );
#let language = "en";
#let style = "classic1";



#let data = yaml("data-" + language + ".yml");
#let template(style: "style") = {
  if style == "classic1" {
    import ("./styles/classic/classic1.typ"): resume, generate_template_data
    let template_data = generate_template_data(
      language: language
    );
    show: resume(
      template_data: template_data,
      personal_data: data.personal,
      employment_data: data.employment,
      project_data: data.projects,
      education_data: data.education,
      certification_data: data.certification
    )
  }
  else if style == "github2024" {
    import ("./styles/github/2024.typ"): resume, generate_template_data
    let template_data = generate_template_data(
      language: language,
      user_name: lower(data.personal.names.first_names.first() + "-" + data.personal.names.last_names.first()),
      profile_picture_path: "/images/pp.jpg",
      repository_name: "resume",
      repository_visibility: "Private",
      nr_watches: "3.1k",
      nr_forks: 415,
      nr_stars: 926,
      nr_branches: 5,
      nr_tags: 35,
      commit_message: "Software Engineer & Sys Admin",
      commit_hash: "51cc0d3",
      commit_date: "today",
      commit_count: "1 Commit",
      read_me_message: "fixed bug where resume was boring",
      contributors_images: (
        "/images/knopf.jpg",
      )

    )
    show: resume(
      template_data: template_data,
      personal_data: data.personal,
      employment_data: data.employment,
      project_data: data.projects,
      education_data: data.education,
      certification_data: data.certification,
    )
  }
  else {
    text("style \"" + style + "\" not found!")
  }
}

#template(style: style)



