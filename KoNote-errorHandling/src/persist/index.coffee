# Copyright (c) Konode. All rights reserved.
# This source code is subject to the terms of the Mozilla Public License, v. 2.0
# that can be found in the LICENSE file or at: http://mozilla.org/MPL/2.0

# Provides access to persistent data storage.
# Any reading/writing of data should be done using this module.

Imm = require 'immutable'

{buildDataDirectory} = require './setup'
Lock = require './lock'
Session = require './session'
Users = require './users'
{IOError, CustomError, ObjectNotFoundError, TimestampFormat, generateId} = require './utils'

module.exports = {
	buildDataDirectory
	generateId
	CustomError
	IOError
	ObjectNotFoundError
	TimestampFormat
	Lock
	Session
	Users
}