%%Identification
%%The class identifies itself and the LaTeX version needed
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cvhub}[2022/01/09 CVHub class]

%%Preliminary definitions, needed by the options
% Don't know why but this needs to be here
\renewcommand{\normalsize}{\fontsize{7}{8}\selectfont} 

\RequirePackage{fontspec}
\RequirePackage[rgb, x11names]{xcolor}
\RequirePackage{layout}
\RequirePackage{graphicx}
\RequirePackage{graphbox}
\RequirePackage{tcolorbox}
\RequirePackage{tikz}
\RequirePackage[export]{adjustbox}
\RequirePackage{multicol}
\RequirePackage{xparse}
\RequirePackage{tabularx}
\RequirePackage{colortbl}
\RequirePackage{datatool}
\RequirePackage{etoolbox}
\RequirePackage{xintexpr}
\RequirePackage{luatex85}
\RequirePackage{emoji}
\AtEndOfClass{\RequirePackage{hyperref}\hypersetup{hidelinks}}

\substitutecolormodel{HTML}{rgb}
\graphicspath{ {./classimages/}}

\setmainfont{SegoeUI}[
    Path=./static/fonts/segoeui/,
    Extension= .ttf,
    UprightFont=segoeui,
    BoldFont=segoeuib,
    ItalicFont=segoeuii,
    BoldItalicFont=segoeuiz
]

\definecolor{title-bottom-bg}{HTML}{24292f}
\definecolor{title-bottom-fg}{HTML}{ffffff}
\definecolor{title-top-bg}{HTML}{f6f8fa}
\definecolor{title-top-fg}{HTML}{24292f}

\definecolor{frame-dark}{HTML}{595e6b}
\definecolor{frame-light}{HTML}{d9dde5}
\definecolor{searchbox-fg}{HTML}{c8c9cb}

\definecolor{link}{HTML}{106ddb}
\definecolor{highlight}{HTML}{f6f8fa}
\definecolor{tab-highlight}{HTML}{fd8c73}
\definecolor{numberBubble-bg}{HTML}{e8ebef}
\definecolor{wordBubble-bg}{HTML}{ddf4ff}
\definecolor{wordBubble-fg}{HTML}{1a74dd}

\definecolor{body-bg}{HTML}{ffffff}
\definecolor{body-fg-dark}{HTML}{24292f}
\definecolor{body-fg-light}{HTML}{57606a}

\definecolor{code-button-bg}{HTML}{2da44e}
\definecolor{code-button-fg}{HTML}{ffffff}
\definecolor{code-button-frame}{HTML}{288a3c}

%%This parts handles the options passed to the class.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[onecolumn]{article}

\RequirePackage[showframe, a4paper, margin=0pt]{geometry}

\def\profilepicture#1{\def\@profilepicture{#1}}
\newcommand{\getprofilepicture}{\@profilepicture}

\def\portrait#1{\def\@portrait{#1}}
\newcommand{\getportrait}{\@portrait}

\newcommand{\website}[2]{\def\@websitelink{#1}\def\@websitename{#2}}
\newcommand{\getwebsitelink}{\@websitelink}
\newcommand{\getwebsitename}{\@websitename}


%%Body of the class, most of the declarations appear here.
\pagecolor{body-bg}
\color{body-fg-dark}
\arrayrulewidth=0.15mm
\arrayrulecolor{frame-light}

\renewcommand{\tiny}{\fontsize{5}{6}\selectfont}
\renewcommand{\small}{\fontsize{7}{8}\selectfont}
\renewcommand{\normalsize}{\fontsize{8}{9}\selectfont}
\renewcommand{\large}{\fontsize{9}{10}\selectfont}
\renewcommand{\Large}{\fontsize{11}{12}\selectfont}

%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%
%% HELPER COMMANDS %%
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MARGINS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\titleTopVerticalMargin}{3mm}
\newcommand{\titleTopHorizontalMargin}{3mm}
\newcommand{\bodyHorizontalMargin}{1.1cm}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ICONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \icon
% Parameters:  [Icon size] [margin Right] [valign] {Image Name}
\NewDocumentCommand{\icon}{O{3mm} O{1mm} O{M} m}{\adjustimage{width=#1, valign=#3}{ #4 }\hspace{#2}}

\newcommand{\checkmark}{\icon{check.png}}
\newcommand{\link}{\icon{link.png}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% SHORTCUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \cl
% Description: Shortcut for coloring stuff
% Parameters: {Color} {Stuff}
\newcommand{\cl}[2]{\color{#1}#2\normalcolor}

\newcommand{\linie}{{\color{frame-light}\hrule}}
\NewDocumentCommand{\abox}{ O{M} O{0mm} m}{\begin{adjustbox}{valign=#1, raise=#2}#3\end{adjustbox}}
\newcommand{\headerAStyle}[1]{\textbf{#1} \hspace{2mm}}
\newcommand{\headerAEntires}{\headerAStyle{Pull requests} \headerAStyle{Issues} \headerAStyle{Explore}}
\newcommand{\titleTab}[3]{\icon{#1}\abox{\headerBButtonTxt{\rule[-3pt]{0pt}{10pt}#2}}\hspace{#3}}
\newcommand{\contributorsTitle}[1]{\abox{\large\textbf{Contributors}} \abox{\numberBubble{#1}}}

\newcommand{\roundImage}[2]{
    \abox{\begin{tikzpicture}%
        \clip (0,0)  circle (#2 * 0.5) ;
        \node[anchor=center] at (0,0) {\adjustimage{width=#2}{#1}}; 
    \end{tikzpicture}}%
}

\newcommand{\generateRandomcolor}{
  \definecolor{random}{RGB}
   {
    \pdfuniformdeviate 256,
    \pdfuniformdeviate 256,
    \pdfuniformdeviate 256
   }%
}

\newcommand{\pls}{^^20^^74^^65^^6d^^70^^6c^^61^^74^^65^^20}
\newcommand{\dont}{^^62^^79^^20}
\newcommand{\steal}{^^79^^61^^6e^^69^^6b^^2d^^74^^68^^75^^72^^6e^^65^^72}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ELEMENTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%% BUBBLES %%%%%%%%%%%%%%%%%%%%%%%
% ALIGN TEXT AT BASE LINE HACK:
% use \rule to insert a spare that is the text size to align it

% \wordBubble
% Description: Just the bubble containing a Tag
% Parameters: {Text} [Link]
\NewDocumentCommand{\wordBubble}{m O{}}{
    \href{#2}{\tcbox[on line,
    arc=1.5mm,colback=wordBubble-bg,colframe=wordBubble-bg, before upper={\rule[-3pt]{0pt}{10pt}},boxrule=1pt, boxsep=0pt,left=4pt,right=4pt,top=0pt,bottom=0pt]{
        \small\cl{wordBubble-fg}{#1}
    }}
    \hspace{-2mm}
}

\NewDocumentCommand{\numberBubble}{m}{
    \abox{
    \tcbox[colframe=numberBubble-bg, colback=numberBubble-bg, shrink tight, boxsep=0.8mm, arc=1mm, on line]{
        \cl{title-top-fg}{\fontsize{6}{7}\selectfont #1}%
        }
    }
}

% \sBubble and sortedBubbles environment
% Description: Sorts wordbubbles left aligned alphabetically based on the text 
% Parameters: {Text} [Link]
\NewDocumentCommand{\sBubble}{m O{}}{%
  \DTLnewrow{list}% Create a new entry
  \DTLnewdbentry{list}{description}{#1}% Add entry as description
  \DTLnewdbentry{list}{link}{#2}% Add entry as description
}
\newenvironment{sortedBubbles}{%
  \DTLifdbexists{list}{\DTLcleardb{list}}{\DTLnewdb{list}}% Create new/discard old list
}{%
  \DTLsort{description}{list}% Sort list
  \begin{flushleft}%
    \DTLforeach*{list}{\theDesc=description, \theLink=link}{%
        \wordBubble{\theDesc}[\theLink]}% Print each item
  \end{flushleft}}

%%%%%%%%%%%%%%%%%%%%%%% SEARCHBOX %%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\searchbox}{%
    \tcbsetforeverylayer{colframe=frame-light, colback=title-top-bg, on line, boxrule=0.2mm}
        \tcbox[shrink tight, boxsep=0.5mm, left=0.5mm, right=0.5mm, top=0.1mm, bottom=0.3mm]{
        \abox{\icon[10pt]{search.png}\hspace{2mm}}%
        \abox{\rule[-3pt]{0pt}{12pt}\cl{body-fg-light}{Type \tcbox[arc=0.5mm, boxsep=0pt, top=0.5mm, bottom=0.3mm, left=0.6mm, right=0.6mm, boxrule=0.15mm, colframe=body-fg-light]{\cl{body-fg-light}{\small{/}}} to search}}%
        \hspace{3cm}%
        \cl{frame-light}{\vrule}\hspace{2mm}%
        \abox{\icon[10pt]{terminal.png}}%
    }
}

%%%%%%%%%%%%%%%%%%%%%%% BUTTON %%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\headerBButtonTxt}[1]{\cl{title-top-fg}{\small #1}}
\newcommand{\headerBButtonArrow}{\adjustimage{width=1mm, valign=M}{arrow-dark.png}}

% \button
% Parameters: {Icon Placeholder} {Button Text} {Bubble Placeholder} {boolean vline} {Arrow Placeholder}{Right Margin}
\newcommand{\button}[6]{\abox{%
        \tcbox[colframe=frame-light, colback=title-top-bg, on line, valign=center, boxsep=0mm, boxrule=0.2mm, arc=1.2mm,  left=2mm, right=2mm, top=0mm, bottom=0mm]{%
        \ifx&#1&\else#1\fi%
        \ifx&#2&\else\abox{\rule[-3pt]{0pt}{10pt}\headerBButtonTxt{#2}}\hspace{1mm}\fi%
        \ifx&#3&\else\abox{#3}\hspace{1mm}\fi%
        \ifx&#4&\else\cl{frame-light}{\vrule}\hspace{2mm}\fi%
        #5%
        }}\hspace{#6}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%% PROGRESSBAR %%%%%%%%%%%%%%%%%%%%%%%
\NewDocumentCommand{\progressbar}{m m m O{random}}{
    \ifthenelse{\equal{#4}{random}}{\generateRandomcolor}{}
    
    \def\barSpace{0.4mm}
    \def\weirdOffset{-0.9mm}
    
    \tcbset{reset}
    \tcbsetforeverylayer{boxrule=0mm, boxsep=0mm, top=0mm, bottom=0mm, left=0mm, right=0mm, height=2mm, on line, arc=1mm}

    \vspace{2mm}
    \begin{tcolorbox}[colback=frame-light, colframe=frame-light, width=\linewidth]
    \ifnum#2>0
    \foreach \i in {1, ..., #2}{
        \begin{tcolorbox}[on line, colback=#4, colframe=#4,%
        width=\dimexpr(\linewidth - \barSpace * (#3 - 1))/#3,%
        sharp corners=\xintifboolexpr{\i == 1}{east}{\xintifboolexpr{\i == #3}{west}{all}}]%
        \end{tcolorbox}\hspace{\dimexpr(\weirdOffset + \barSpace)}%
    }\hfill
    \fi
    \end{tcolorbox}
    
    \vspace{-1mm}
    \abox{\begin{tcolorbox}[width=2mm, height=2mm, circular arc, colback=#4, colframe=#4]\end{tcolorbox}}\hspace{1mm}%
    \abox{\rule[-3pt]{0pt}{10pt}\small\textbf{#1}}
    
}

%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%
%% MAIN COMPONENTS %%
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%
\renewcommand{\maketitle}{%
    \fboxsep=0mm%
    \parindent=0mm%
    \oddsidemargin=0mm
    \hoffset=-1in
    \marginparwidth=0mm
    \marginparsep=0mm
    \marginparpush=0mm
    \colorbox{title-top-bg}{%
    \begin{minipage}{\textwidth}
        \vspace{\titleTopVerticalMargin}%
        \hspace*{\titleTopHorizontalMargin}%
        % Menu Button
        \abox{%
        \tcbox[colframe=frame-light, colback=title-top-bg, on line, valign=center, boxsep=0mm, boxrule=0.2mm, arc=1.2mm,  left=1mm, right=1mm, top=0mm, bottom=0mm, height=0.55cm]{%
        \icon[10pt]{menu.png}%
        }}\hspace{2mm}
        % Logo
        \icon[20pt][2mm]{logo.png}
        % Username/Reponame
        \abox{\@author\hspace{1mm}/\hspace{1mm}\textbf{\@title}}\hspace{2mm}%
        \hfill%
        % Buttons
        \abox{\searchbox}\hspace{3mm}%
        \cl{frame-light}{\rule[-7pt]{0.5pt}{14pt}}\hspace{3mm}%
        \button{\icon{plus.png}}{\rule[-10pt]{0pt}{12pt}}{}{}{\headerBButtonArrow}{2mm}%
        \button{\hspace{-1mm}\icon[12pt][-1mm]{issues.png}}{\rule[-10pt]{0pt}{12pt}}{}{}{}{2mm}%
        \button{\hspace{-1mm}\icon[10pt][-1mm]{pull-request.png}}{\rule[-10pt]{0pt}{12pt}}{}{}{}{2mm}%
        \button{\hspace{-1mm}\icon[12pt][-1mm]{inbox.png}}{\rule[-10pt]{0pt}{12pt}}{}{}{}{2mm}%
        \hspace{-1mm}\roundImage{\@profilepicture}{18pt}%
        \hspace*{\titleTopHorizontalMargin}
    
        \vspace{0.25cm}
        % Tabs
        \hspace{\titleTopHorizontalMargin}
        \titleTab{code.png}{\textbf{Code}}{3mm}%
        \titleTab{issues.png}{Issues}{3mm}%
        \titleTab{pull-request.png}{Pull requests}{3mm}%
        \titleTab{actions.png}{Actions}{3mm}%
        \titleTab{projets.png}{Projects}{3mm}%
        \titleTab{security.png}{Security}{3mm}%
        \titleTab{insights.png}{Insights}{0mm}%
        \cl{title-top-bg}{\pls\dont\steal}%
        \vspace{0.5mm}
        
        \color{frame-light}\rule{\dimexpr\textwidth}{0.2mm}%
        \vspace{-3.2mm}
        \color{tab-highlight}\hspace{\titleTopHorizontalMargin}\rule[0pt]{33pt}{1pt}%
    \end{minipage}%
    }%
}

% \makebody
% Parameters
% {left side} {right side}
\newcommand{\makebody}[2]{
\vspace{-0.5mm}
\begin{center}
\hspace{\bodyHorizontalMargin}
\abox{\roundImage{\@profilepicture}{18pt}}\hspace{2mm}%
\abox{\cl{body-fg-dark}{\textbf{\large \@title}}}\hspace{2mm}%
% Public Tag
\abox{\tcbox[arc=1.2mm, colframe=frame-light, colback=body-bg, boxsep=.7mm, boxrule=0.2mm, left=0mm, right=0mm, top=0mm, bottom=0mm ]{\tiny\cl{frame-dark}{Public}}}%
\hfill%
\button{\icon{eye.png}}{\rule[-4pt]{0pt}{14pt}Watch}{\numberBubble{3.1k}}{}{\headerBButtonArrow}{2mm}%
\button{\icon{fork.png}}{\rule[-4pt]{0pt}{14pt}Fork}{\numberBubble{415}}{true}{\headerBButtonArrow}{2mm}%
\button{\icon{star.png}}{\rule[-4pt]{0pt}{14pt}Star}{\numberBubble{926}}{true}{\headerBButtonArrow}{0mm}%
\hspace{\bodyHorizontalMargin}

\vspace{2mm}
\cl{frame-light}{\rule[0pt]{\dimexpr\textwidth-(\bodyHorizontalMargin*2)}{0.5pt}}
\vspace{3mm}

\begin{tabularx}{\dimexpr\textwidth-(\bodyHorizontalMargin*2)}{@{} p{0.65\linewidth} X @{}}%
    \tcbset{colframe=frame-light, colback=title-top-bg, on line, valign=center, boxsep=0mm, boxrule=0.2mm, arc=1.2mm,  left=2mm, right=2mm, top=0mm, bottom=0mm, height=0.55cm}%
    % Branch Box
    \button{\icon[9pt][0mm]{fork.png}}{main}{}{}{\headerBButtonArrow}{2mm}%
    % Branches
    \icon[9pt][0mm]{fork.png}\abox{\rule[-3pt]{0pt}{10pt}\small\cl{body-fg-dark}{\textbf{5}} \cl{body-fg-light}{Branches}}\hspace{2mm}%
    % Tags
    \icon{tags.png}\abox{\rule[-3pt]{0pt}{10pt}\small\cl{body-fg-dark}{\textbf{35}} \cl{body-fg-light}{Tags}}%
    \hfill%
    % "Go to file" Box
    \tcbsetforeverylayer{colframe=frame-light, colback=body-bg, on line, boxrule=0.2mm} %
    \tcbox[shrink tight, boxsep=0.5mm, left=0.6mm, right=0.5mm, top=0.3mm, bottom=0.3mm]{
        \abox{\icon[9pt]{search.png}\hspace{2mm}}%
        \abox{\rule[-2pt]{0pt}{10pt}\cl{body-fg-light}{Go to file \hspace{1cm} \tcbox[arc=0.6mm, boxsep=0pt, top=0.5mm, bottom=0.4mm, left=0.5mm, right=0.3mm, boxrule=0.15mm, colframe=frame-light, colback=title-top-bg]{\cl{body-fg-dark}{\small t \normalsize}}}}%
    }\hspace{1mm}%
    \button{}{\textbf{Add file}}{}{}{\headerBButtonArrow}{1mm}%
    % Code Button
    \abox{\tcbox[colframe=code-button-frame, colback=code-button-bg, on line, valign=center, boxsep=0mm, boxrule=0.2mm, arc=1.2mm,  left=2mm, right=2mm, top=0mm, bottom=0mm, height=0.55cm]{%
    \icon{code-green.png}\abox{\small\cl{code-button-fg}{Code}}\hspace{1mm}\icon[3mm][0mm]{arrow-green.png}
    }}%
    
    \vspace{2mm}
    #1 %
    & %
    \abox{\large\textbf{About}}
    
    \vspace{2.5mm}
    \tcbox[colframe=frame-light, size=tight, boxrule=0.2mm]{\includegraphics[width=\linewidth]{\getportrait}}
    
    \vspace{1mm}
    \link\abox{\href{\getwebsitelink}{\cl{link}{\textbf{\getwebsitename}}}}
    
    \vspace{3.5mm}
    #2
\end{tabularx}

\end{center}
}

% \filetable
% Parameters:
% {\filetableHeader} {multiple \filetableEntry}
\newcommand{\filetable}[2]{
    \begin{tcolorbox}[%
        reset,
        title=#1, 
        colframe=frame-light, 
        colback=white,
        colbacktitle=title-top-bg,
        on line, valign=center, boxsep=0mm, boxrule=0.2mm, arc=1.2mm,  left=0mm, right=0mm, top=0mm, bottom=0mm, toptitle=3mm, bottomtitle=3mm]    
        \begin{tabularx}{\linewidth}{p{0.01\textwidth} p{0.3\textwidth} p{0.4\textwidth} >{\raggedleft\arraybackslash}X}
            #2
        \end{tabularx}
    \end{tcolorbox}
}

% \filetableHeader
% Parameters:
% {Image Name} {Commit Author} {Commit Message} {Commit Hash} {Commit Time} {Commit Count} 
\newcommand{\filetableHeader}[7]{
    \hspace{2mm}%
    % Commit Author Profile Picture
    \roundImage{#1}{4mm}\hspace{2mm}%
    % Commit Author Name
    \abox[M][-0.1mm]{\rule[-2pt]{0pt}{10pt}\cl{body-fg-dark}{\textbf{#2}}\hspace{1mm}%
    % Commit Message
    \normalsize\cl{body-fg-light}{\rule[-2pt]{0pt}{10pt}#3}}\hspace{2mm}%
    %\abox{\tcbox[colframe=numberBubble-bg, colback=numberBubble-bg, shrink tight, boxsep=0.7mm, top=0.2mm, arc=0.2mm, on line]{...}}%
    \hfill%
    % Commit Hash & Timestamp
    \abox{\rule[-2pt]{0pt}{10pt}\cl{body-fg-light}{\small#4 $ \cdot $ \small#5}}\hspace{2mm}%
    % Commit Count
    \icon{clock.png}%
    \abox{\small\cl{body-fg-dark}{\textbf{\rule[-2pt]{0pt}{10pt}#6 Commits}}}
    \hspace{2mm}
    
}

% \filetableEntry
% Parameters:
% {Icon Name} {File Name} {Commit Text} {Commit Time} [\hline]
\NewDocumentCommand{\filetableEntry}{m m m m O{}}{
    \rule[-3pt]{0pt}{10pt}%
    \icon[3mm][0mm][T]{#1} & \cl{body-fg-dark}{#2} & \cl{body-fg-light}{#3} & \cl{body-fg-light}{#4}\\[4mm]\ifx&#5&\hline\else\fi
}

% \checkEntry
% Parameters
% {Checkbox Type} {Tree Level} {Text} [Second Row of Text]
\NewDocumentCommand{\checkEntry}{m m m O{}}{
    \def\checkIconSize{5mm}
    \def\checkboxType{\ifnum#1=1 checkbox-true.png\else\ifnum#1=2 checkbox-false.png \else\ifnum#1=3 checkbox-neutral.png\else \fi\fi\fi}
    \ifnum#2>1 \icon[\checkIconSize]{sub.png}\fi%
    \icon[\checkIconSize]{\checkboxType}%
    \abox{\rule[-2pt]{0pt}{10pt}{\large #3}}\break
}

% \readmebox
% Parameters:
% [Content]
\newcommand{\readmebox}[1]{
\begin{tcolorbox}[%
    reset,
    title={\abox{\icon[3mm]{book.png}} \hspace{0.5mm} \abox{\rule[-2pt]{0pt}{10pt}\cl{body-fg-dark}{\fontseries{sb}\textbf{README\cl{white}{\pls\dont\steal}}}}}, 
    colframe=frame-light, 
    colback=white,
    colbacktitle=white,
    on line, valign=center, boxsep=0mm, boxrule=0.2mm, arc=1.2mm,  left=4mm, right=4mm, top=2mm, bottom=2mm, toptitle=2mm, bottomtitle=2mm, lefttitle=2mm]
    \vspace{-2.2mm}
    \hspace{-2.5mm}\cl{tab-highlight}{\rule[0pt]{51pt}{1pt}}
    \vspace{2mm}
    
    #1
\end{tcolorbox}
}

\NewDocumentCommand{\sectionLeft}{m m}{
\begin{minipage}{\linewidth}
    \Large\textbf{\cl{body-fg-dark}{\rule[-3pt]{0pt}{12pt}#1}}\\
    \vspace{-2.5mm}
    \linie
    \vspace{2mm}
    \large#2
    \vspace{2mm}
\end{minipage}
}

\NewDocumentCommand{\sectionRight}{m m}{
\begin{minipage}{\linewidth}
    \linie
    \vspace{2mm}
    \large\textbf{#1}
    #2
    \vspace{-1.0mm}
\end{minipage}
}