# resume
A resume in the style of a GitHub repository.

![example image](https://github.com/yanik-thurner/resume/blob/main/images/example.png?raw=true)

For now I won't publish the class file, at least until I get my first job, in case of the unlikely event that we apply for the same one. So this repo should just demonstrate that I can do LaTeX and built the CV myself. Here is a little bit of documentation.

The usage is simple, since most of the technical stuff is inside the class file. The following commands are relevant:
- Setting the important variables:
    - \\title{repository\_name}: The name of the repository that is displayed.
    - \\author{author\_name}: Surprise, its the name of the author. It is used in the repo path on top of the page.
    - \\profilepicture{image\_path}: Path to the profile picture of the GitHub user. It's displayed on top of the page and in the header of the latest commit.
    - \\portrait{image\_path}: path to the headshot that is displayed in the right column.
    - \\website{website_link}{website_name}: The link to a website, which is displayed under the portrait.
- \\maketitle: Creates the black GitHub menu on top of the site, as well as the space below containing the repository name and action buttons.
- \\makebody{left\_column}{right_\column}: Builds the main body with two columns, a bigger left one for the files and the README and a smaller right one for the portrait and other infos.
- \\filetable{header}{file\_entries}: Builds the file table. I used it for the most important information like name and contact data. 
- \\filetableHeader{profile\_picture}{commit\_author}{commit\_text}{commit\_test\_symbol}{commit\_hash}{commit\_time}{commit\_count}: Like on GitHub, this displays the latest commit. I used it to display my latest finished degree.
- \\filetableEntry{icon\_path}{file\_name}{commit\_text}{commit\_time}: A single row in the filetable.
- \\readmebox{content}: Builds the README box.
- \\sectionLeft{heading}{content}: A wrapper for sections in the README box.
- \\sectionRight{heading}{content}: A wrapper for sections below the portrait.
- sortedBubbles Environment: An environment to automatically sort the entries alphabetically. This way the list can easily extended without having to think about the order.
- \\sBubble{content}[link]: A skill bubble that is automatically sorted based on the content. Optionally a link can be added, which makes the bubble clickable in a PDF.
- \\progressbar{name}{selected\_value}{max\_value}[color]: Automatically generates a progress bar that has *max\_value* segments, of which *selected\_value* are filled. Optionally a color could be passed, otherwise a random color is generated.

The GitHub trademark, logo and site design are property of GitHub, Inc.
The icons are freely available on Icons8, an awesome site: https://icons8.com/
