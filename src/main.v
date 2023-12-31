module main

import ui
import os
import gx

const (
	win_width   = 520
	win_height  = 570
	nr_cols     = 4
	cell_height = 25
	cell_width  = 100
	table_width = cell_width * nr_cols
	slider_min = 0
	slider_max = 255
	slider_val = (slider_max + slider_min) / 2
)

struct Mail {
	to string
	subject string
	body string
}

struct User {
	username string
	password string
	from string
	server string
	port i64
	ssl bool
}

[heap]
struct State {
mut:
	to string
	subject string
	body string
	mail      []Mail
	username string
	password string
	from string
	server string
	port string
	ssl bool
	user []User
	window     &ui.Window = unsafe { nil }
	is_error   bool
	is_error_register bool
	rgb_rectangle  &ui.Rectangle = unsafe { nil }
}

fn main() {
	mut logo := os.resource_abs_path(os.join_path('./assets/', 'MailerAddict.png'))
	$if android {
		logo = 'MailerAddict.png'
	}
	mut app := &State{}

	app.rgb_rectangle = ui.rectangle(
		id: 'rgb_rect'
		border: true
		color: gx.Color{
			r: slider_val
			g: slider_val
			b: slider_val
		}
	)

	window := ui.window(
		width: win_width
		height: win_height
		title: 'Mailer Addict'
		children: [
			ui.row(
				margin: ui.Margin{10, 10, 10, 10}
				widths: [500.0, ui.stretch]
				spacing: 30
				children: [
					ui.column(
						spacing: 13
						children: [
							ui.label(
						        text: 'Send mail'
					        ),
							ui.textbox(
								max_len: 50
								width: 200
								placeholder: 'To'
								text: &app.to
								is_focused: true
								is_error: &app.is_error
							),
							ui.textbox(
								max_len: 70
								width: 200
								placeholder: 'Subject'
								text: &app.subject
								is_error: &app.is_error
							),
							ui.textbox(
								max_len: 1000
								width: 200
								height: 400
								placeholder: 'Body'
								text: &app.body
								is_error: &app.is_error
							),
							ui.row(
								spacing: 65
								widths: ui.compact
								children: [
									ui.button(
										text: 'Send mail'
										on_click: app.btn_add_click
									),
									ui.button(
										text: '?'
										on_click: btn_help_click
									),
								]
							),
							ui.picture(
								width: 100
								height: 100
								path: logo
							),
							ui.row(
								spacing: 65
								widths: ui.compact
								children: [
							if os.is_readable("./src/data.db") {
								ui.label(
									text: 'Modify Profile'
								 )
							} else {
								ui.label(
								text: 'Register (before mailing)'
								)
							}
							ui.button(
									text: 'View profile'
									on_click: btn_profile_click
								),
							  ]
							)
							ui.textbox(
								max_len: 50
								width: 200
								placeholder: 'Username'
								text: &app.username
								is_error: &app.is_error_register
							),
							ui.textbox(
								max_len: 100
								width: 200
								placeholder: 'Password'
								text: &app.password
								is_error: &app.is_error_register
								is_password: true
							),
							ui.textbox(
								max_len: 50
								width: 200
								placeholder: 'From'
								text: &app.from
								is_error: &app.is_error_register
							),
							ui.textbox(
								max_len: 50
								width: 200
								placeholder: 'Server'
								text: &app.server
								is_error: &app.is_error_register
							),
							ui.textbox(
								max_len: 50
								width: 200
								placeholder: 'Port'
								is_numeric: true
								text: &app.port
								is_error: &app.is_error_register
							),
							ui.checkbox(
								checked: true
								text: 'Is SSL ?'
							),
							ui.button(
								text: 'Register'
								on_click: app.btn_create_click
							),
						]
					),
					ui.column(
						alignments: ui.HorizontalAlignments{
							center: [
								0,
							]
							right: [
								1,
							]
						}
						widths: [
							ui.stretch,
							ui.compact,
						]
						heights: [
							ui.stretch,
							100.0,
						]
					),
				]
			),
		]
	)
	app.window = window
	ui.run(window)
}