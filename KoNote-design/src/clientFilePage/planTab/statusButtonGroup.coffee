# Copyright (c) Konode. All rights reserved.
# This source code is subject to the terms of the Mozilla Public License, v. 2.0
# that can be found in the LICENSE file or at: http://mozilla.org/MPL/2.0

# Presentational component for plan section or target status buttons

Term = require '../../term'


load = (win) ->
	$ = win.jQuery
	React = win.React
	R = React.DOM

	WithTooltip = require('../../withTooltip').load(win)
	OpenDialogLink = require('../../openDialogLink').load(win)

	{FaIcon} = require('../../utils').load(win)

	# TODO this component is way too configurable
	# should probably be a few smaller reusable components instead?

	StatusButtonGroup = ({
		planElementType, data, parentData, isExisting, status,
		dangerMessage, onRemove, dialog
	}) ->
		R.div({className: 'statusButtonGroup'},
			# Will show remove (x) button for an empty section, rare case
			if not isExisting and onRemove?
				R.div({
					className: "statusButton #{className}"
					onClick: onRemove
				},
					FaIcon(icon)
				)

			else

				if status is 'default'
					[
						StatusButton({
							key: 'deactivate'
							className: 'deactivate'
							tooltip: 'Deactivate'
							icon: 'times'
							dialog
							title: "Deactivate #{planElementType}"
							dangerMessage
							message: """
								This will remove the #{planElementType.toLowerCase()} from the #{Term 'client'}
								#{Term 'plan'}, and future #{Term 'progress notes'}.
								It may be re-activated again later.
							"""
							reasonLabel: "Reason for deactivation:"
							newStatus: 'deactivated'
							data, parentData
						})
						StatusButton({
							key: 'complete'
							className: 'complete'
							tooltip: 'Complete'
							icon: 'check'
							dialog
							title: "Mark #{planElementType} as Completed"
							dangerMessage
							message: """
								This will mark the #{planElementType.toLowerCase()} as 'completed'. This often
								means that the desired outcome has been reached.
							"""
							reasonLabel: "Reason for completed:"
							newStatus: 'completed'
							data, parentData
						})
					]

				else
					StatusButton({
						className: 'reactivate'
						tooltip: "Re-activate #{planElementType}"
						icon: 'sign-in'
						dialog
						title: "Re-activate #{planElementType}"
						dangerMessage
						message: """
							This will re-activate the #{planElementType.toLowerCase()} so it appears in the #{Term 'client'}
							#{Term 'plan'}, and future #{Term 'progress notes'}.
						"""
						newStatus: 'default'
						reasonLabel: "Reason for re-activation:"
						data, parentData

					})

		)

	StatusButton = ({
		className, tooltip, icon, onClick, dialog, title, dangerMessage, message,
		newStatus, data, parentData, reasonLabel
	}) ->
		WithTooltip({
			title: tooltip
			placement: 'top'
			container: 'body'
		},
			OpenDialogLink({
				className: "statusButton #{className}"
				dialog
				newStatus
				data, parentData
				title
				dangerMessage
				message
				reasonLabel
			},
				FaIcon(icon)
			)
		)


	return StatusButtonGroup


module.exports = {load}
