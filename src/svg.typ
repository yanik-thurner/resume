#import "typst-util.typ": weight_int;

#let REGEX_COLOR = "([a-zA-Z]*|(#[a-fA-F0-9]{6}))";
#let REGEX_FILL_ATTRIBUTE = "fill=\"" + REGEX_COLOR + "\"";

#let svg(path, fill: black, width: 10pt) = {
  let file_content = read(path);
  let fill_attribute = "fill=\"" + fill.to-hex() + "\"";
  let regex_fill = regex(REGEX_FILL_ATTRIBUTE);
  
  if file_content.contains(regex_fill){
    file_content = file_content.replace(regex_fill, fill_attribute);
  }
  else{
    file_content = file_content.replace("<svg", "<svg " + fill_attribute);
  }

  image.decode(file_content, width: width)
}


#let svg_text(content, size: none, fill: none, weight: none, hidden_text: none) = context {
  let font_size = if size == none { text.size } else { size };
  let font_weight = if weight == none { weight_int(text.weight) } else { weight_int(weight) };
  let font_color = repr(if fill == none { text.fill } else { fill }).replace("rgb(\"", "").replace("\")", "");

  let hidden_text = if hidden_text == none { none } else { text(hidden_text, size: font_size, fill: rgb(0, 0, 0, 0)) };
  let text_content = text(str(content), size: font_size, weight: font_weight);
  let text_font_size = measure(text_content);

  let svg_width = text_font_size.width;
  let svg_height = font_size*1.2;
  let svg_start = "<svg version='1.1' xmlns='http://www.w3.org/2000/svg' width='" + repr(svg_width) + "' height='" + repr(svg_height) +"' >";
  let svg_content = "<text dominant-baseline='hanging' fill='" + font_color + "' font-weight='" + repr(font_weight) +"' font-size='" + repr(font_size) + "' textLength='" + repr(svg_width) + "'>" + str(content) + "</text>";
  let svg_end = "</svg>";

  box(fill: none)[#grid( 
    columns: (svg_width, 0pt, 0pt),
    align: (top, top, top),
    hide(text_content),
    place(dx: -svg_width, hidden_text),
    place(dx: -svg_width, dy: -20%, image.decode(svg_start + svg_content + svg_end, width: svg_width, height: svg_height)),
   
  )];
}
