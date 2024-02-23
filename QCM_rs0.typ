$/*Les fonctions furent écrites par M. Poquet*/$

#import "lib.typ": rect-box, finalize-atomic-boxes, mm-pos

#let case(phrase, largeur, hauteur) = {
	grid(
		columns : 2,
		column-gutter: 3mm,
		phrase,
		[#box(rect-box("b0", largeur, hauteur))]
	)
}

#let suite_cases(phrase, nbr, largeur, hauteur) = {
	let l = ()
	for i in range(nbr) {
		l.push([#box(rect-box("b0", largeur, hauteur))])
	}
	
	let g = grid(columns: l.len(),column-gutter:1.5mm, ..l)
	grid(columns: 2, gutter:3mm, phrase, g)
}

#let grid_num(nbr) = {
	let l = ()
	for a in range(0,nbr) {
		let lg = ()
		for b in range(0, 10) {
			lg.push([#case([#b], 5mm, 5mm)])
		}
		l.push(grid(columns:10, rows:1, gutter:10mm, ..lg))
	}
	return grid(rows:nbr, gutter:3mm, ..l)
}

#let champ_identifiant(nbr, grille) = {
	let l = ()
	l.push([#case("Prénom", 2cm, 0.5cm)])
	l.push([#case("Nom", 2cm, 0.5cm)])
	if (grille) {
		  l.push([#grid_num(nbr)])
	} else {
		l.push([#suite_cases("Numéro étudiant", nbr, 3mm, 5mm)])
	}
	grid(columns: l.len(), column-gutter:5mm, ..l)
}

#let question(numb, sub-numb, sub-sub-numb, title) = {
	if (sub-sub-numb > 0) {
		numbering("1.1.a)", numb, sub-numb, sub-sub-numb)
	} else {
		numbering("1.1)", numb, sub-numb)
	}
	[ #title]
}

#let question_zone(numb, sub-numb, sub-sub-numb, title, white_zone) = {
	question(numb, sub-numb, sub-sub-numb, title)
	if (white_zone > 0pt) {
		linebreak()
		let id = [#numb] + "." + [#sub-numb] + "." + [#sub-sub-numb]
		rect-box(id, 100%, white_zone)
	}
}

#let mcq_simple(numb, sub-numb, sub-sub-numb, title, cases, vertical) = {
	set par(justify: true)
	set text(10pt, weight: "regular")
	question(numb, sub-numb, sub-sub-numb, title)
	linebreak()
	
	let id = [#numb] + "." + [#sub-numb] + "." + [#sub-sub-numb]
	let cc = 0
	let l = ()
	let col = ()
	
	for (case) in cases {
		let id-box = id + "." + [#cc]
		l.push([#box(rect-box(id-box, 2mm, 2mm)) #case])
		if (vertical) {col.push(16pt)} else {col.push(1fr)}
		cc = cc + 1
	}
	if (vertical) {grid(rows: col, ..l)} else {grid(columns: col, ..l)}
}

#let right_wrong(numb, sub-numb, sub-sub-numb, title, assertions) = {
	set par(justify: true)
	set text(10pt, weight: "regular")
	question(numb, sub-numb, sub-sub-numb, title)
	
	let id = [#numb] + "." + [#sub-numb] + "." + [#sub-sub-numb]
	let cc = 0
	let grille = ()
	
	for (a) in assertions {
		let id-box = id + "." + [#cc]
		grille.push([#a])
		grille.push([Vrai #box(rect-box(id-box + "r", 2mm, 2mm))])
		grille.push([Faux #box(rect-box(id-box + "w", 2mm, 2mm))])
		cc = cc + 1
	}
	/*grille.flatten()*/
	grid(columns: (2fr, 1fr, 1fr), gutter: 6pt, ..grille)
}

#let mcq_grid(numb, sub-numb, sub-sub-numb, title, questions, answers) = {
	set par(justify: true)
	question(numb, sub-numb, sub-sub-numb, title)
	set text(10pt, weight: "regular")
	
	let id = [#numb] + "." + [#sub-numb] + "." + [#sub-sub-numb]
	let cc = 0
	let col = ()
	let row = ()
	let grille = ()
	col.push(2fr)
	row.push(auto)
	grille.push("")
	
	for (r) in answers {
		col.push(1fr)
		grille.push([#r])
	}
	for (q) in questions {
		let ccc = 0
		row.push(auto)
		grille.push([#q])
		for (r) in answers {
			let id-box = id + "." + [#cc] + "." + [#ccc]
			grille.push([#box(rect-box(id-box, 2mm, 2mm))])
			ccc = ccc + 1
		}
		cc = cc + 1
	}
	grid(columns: col, rows: row, gutter: 6pt, ..grille)
}

#let table_parse(numb, sub-numb, sub-sub-numb, title, col, row, content) = {
	let id = [#numb] + "." + [#sub-numb]
	let col_align = ()
	let row_align = ()
	let titre = ()
	let cases = ()
	let global_col_align = ()
	let global_row_align = ()
	let cc = 0 /*content counter*/
	col_align.push(auto)
	row_align.push(auto)
	/*let tall(body) = style(styles => measure(body, styles).width)
	tall("why styles parameter")*/
	
	/*if horiz != "" and vertic != "" {
		titre.push("")
	}
	if horiz != "" {
		global_row_align.push(15pt)
		titre.push(rect(height: 15pt, width: (100%), [#horiz]))
	}
	if vertic != "" {
		global_col_align.push(15pt)
		titre.push(rotate(270deg, origin: center, rect(height: 15pt, width: tall(vertic), [#vertic])))
	}*/
	
	cases.push("")
	for (c) in col {
		col_align.push(1fr)
		cases.push([#c])
	}
	for (r) in row {
		row_align.push(auto)
		cases.push([#r])
		for c in col {
			if (cc < content.len()) and (content.at(cc) != "") {
				cases.push(content.at(cc))
			} else {
				let idea = id + "." + [#cc]
				cases.push(rect-box(idea, auto, auto))
			}
			cc = cc + 1
		}
	}
	global_row_align.push(auto)
	global_col_align.push(auto)
	
	question(numb, sub-numb, sub-sub-numb, title)
	table(
		columns: global_col_align,
		rows: global_row_align,
		inset: 0pt,
		align: horizon + center,
		..titre,
		table(
			columns: col_align,
			rows: row_align,
			inset: 8pt,
			gutter: (2pt, 0pt),
			align: (col, row) =>
			if row == 0 { center }
			else if col == 0 { left }
			else { center },
			..cases
		)
	)
}

#let table_column(numb, sub-numb, sub-sub-numb, title, col, taille, horiz: false, reverse: false) = {
	let id = [#numb] + "." + [#sub-numb]
	let col_align = ()
	/*let titre = ()*/
	let cases = ()
	let cc = 0
	
	if (horiz) {
		for (c) in col {
			col_align.push(auto)
			cases.push([#c])
			let idea = id + "." + [#cc]
			cases.push(rect-box(idea, auto, auto))
			cc = cc + 1
		}
	} else {
		for (c) in col {
			col_align.push(1fr)
			cases.push([#c])
		}
		for (c) in col {
			let idea = id + "." + [#cc]
			cases.push(rect-box(idea, auto, auto))
			cc = cc + 1
		}
	}
	
	question(numb, sub-numb, sub-sub-numb, title)
	table(
		columns: if (horiz) {(auto, 1fr)} else {col_align},
		rows: if (horiz) {taille} else {(auto, taille)},
		row-gutter: if (horiz) {0pt} else {2pt},
		column-gutter: if (horiz) {2pt} else {0pt},
		inset: 8pt,
		align: horizon + center,
		/*..titre,*/
		..cases
	)
}
