# ////////////////////// Migration Series //////////////////////

module.exports = {
	run: (dataDir, userName, password, cb) ->
		console.log "No migrations to run for v1.9.0"
		cb()
}