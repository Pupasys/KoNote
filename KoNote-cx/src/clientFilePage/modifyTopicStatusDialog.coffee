# Copyright (c) Konode. All rights reserved.
# This source code is subject to the terms of the Mozilla Public License, v. 2.0
# that can be found in the LICENSE file or at: http://mozilla.org/MPL/2.0

# Dialog to change the status of a section within the client's chx (default/deactivated/completed)
# TODO: Consolidate with ModifySectionStatusDialog and modifyTargetStatusDialog

Persist = require '../persist'


load = (win) ->
	Bootbox = win.bootbox
	React = win.React
	R = React.DOM

	CrashHandler = require('../crashHandler').load(win)
	Dialog = require('../dialog').load(win)


	ModifyTopicStatusDialog = React.createFactory React.createClass
		mixins: [React.addons.PureRenderMixin]

		getInitialState: -> {
			statusReason: ''
		}

		render: ->
			Dialog({
				ref: 'dialog'
				title: @props.title
				onClose: @props.onClose
			},
				R.div({className: 'modifyTopicStatusDialog'},
					R.div({className: 'alert alert-warning'}, @props.message)
					R.div({className: 'form-group'},
						R.label({}, @props.reasonLabel),
						R.textarea({
							className: 'form-control'
							style: {minWidth: 350, minHeight: 100}
							ref: 'statusReasonField'
							onChange: @_updateStatusReason
							value: @state.statusReason
							placeholder: "Please specify a reason..."
							autoFocus: true
						})
					)
					R.div({className: 'btn-toolbar'},
						R.button({
							className: 'btn btn-default'
							onClick: @props.onCancel
						}, "Cancel")
						R.button({
							className: 'btn btn-primary'
							onClick: @_submit
							disabled: not @state.statusReason
						}, "Confirm")
					)
				)
			)

		_updateStatusReason: (event) ->
			@setState {statusReason: event.target.value}

		_submit: ->
			@refs.dialog.setIsLoading true

			topic = @props.data

			revisedCHxTopic = topic
			.set('status', @props.newStatus)
			.set('statusReason', @state.statusReason)

			ActiveSession.persist.chxTopics.createRevision revisedCHxTopic, (err, updatedCHxTopic) =>
				@refs.dialog.setIsLoading(false) if @refs.dialog?

				if err
					if err instanceof Persist.IOError
						Bootbox.alert """
							An error occurred.  Please check your network connection and try again.
						"""
						console.error err
						return

					CrashHandler.handle err
					return

				# Persist will trigger an event to update the UI
				@props.onSuccess()


	return ModifyTopicStatusDialog

module.exports = {load}
