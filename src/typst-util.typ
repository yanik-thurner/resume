#let weights = (
"thin": 100,
"extralight": 200,
"light": 300,
"regular": 400,
"medium": 500,
"semibold": 600,
"bold": 700,
"extrabold": 800,
"black": 900,
);

#let weight_int(weight) = {
    if type(weight) == int {
        return weight;
    }
    if type(weight) == str and weights.keys().contains(str(weight)) {
        return weights.at(weight);
    }
    return none;
}

#let loop_array(a, size: 0, default_value: none) = {
  let i = 0;
  while a.len() < size {
    let next_element = if i > size { default_value } else { a.at(i) };
    a.push(next_element);
    let i = if i <= size { i + 1 } else { 0 };
  }
  return a;
}

#let insert_measurement_block(width: 100%, height: 100%) = {
  place(block(width: width, height: height, fill: none)[
    #set block(width: 0pt, height: 0pt, fill: none)
    #place(top + left)[#block()<measuring-mark-top-left>]
    #place(top + right)[#block()<measuring-mark-top-right>]
    #place(bottom + left)[#block()<measuring-mark-bottom-left>]
  ])
}

#let measure_relative() = context {
  let get(mark) = query(selector(mark).before(here()));
  let pos(query_result) = { query_result.last().location().position() };
  if (get(<measuring-mark-top-left>).len() > 0){
    let top_left = pos(get(<measuring-mark-top-left>));
    let top_right = pos(get(<measuring-mark-top-right>));
    let bottom_left = pos(get(<measuring-mark-bottom-left>));
    return (width: top_right.x - top_left.x, height: bottom_left.y - top_left.y);
  }
  else{
    panic("No measuerement marks found")
  }
}

