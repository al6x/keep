#!/usr/bin/env nim r
import base, ftext/parse, std/os

# Model --------------------------------------------------------------------------------------------
import keep/model, keep/model/load

let parsers = DocFileParsers()
parsers["ft"] = (path, sid) => Doc.read(path, sid = sid)

db = Db.init
block:
  let notes_dir = current_source_path().parent_dir.parent_dir
  let space = Space.init(id = "notes")
  db.spaces[space.id] = space
  add_dir db, space, parsers, notes_dir

# UI -----------------------------------------------------------------------------------------------
import mono/[core, http], ext/async
import keep/ui/support, keep/ui/pages/app_view, keep/ui/palette as _

palette = Palette.init

run_http_server(
  () => AppView(),
  port         = 8080,
  asset_paths  = app_view_asset_paths(),
  sync_process = build_db_process_cb(db)
)