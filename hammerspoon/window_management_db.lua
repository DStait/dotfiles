function connectWinManagementDB()
    local dbPath = os.getenv('HOME') .. "/.config/hammerspoon.sqlite"
    return hs.sqlite3.open(dbPath)
end

function createWinManagementDB()
  local statement = [[
    CREATE TABLE IF NOT EXISTS WINDOW_MANAGEMENT(
      WINDOW_ID      INT    PRIMARY KEY NOT NULL,
      H         REAL     NOT NULL,
      W         REAL     NOT NULL,
      X         REAL     NOT NULL,
      Y         REAL     NOT NULL
    );
  ]]

  local db = connectWinManagementDB()
  db:execute(statement)
  db:close()
end

function insertOldLoc(w)
  local currentLoc = w:frame()

  local db = connectWinManagementDB()
  local statement = "INSERT INTO WINDOW_MANAGEMENT (WINDOW_ID,H,W,X,Y) VALUES (" .. 
    w:id()        .. "," ..
    currentLoc._h .. "," ..
    currentLoc._w .. "," ..
    currentLoc._x .. "," ..
    currentLoc._y ..
    ");"

  db:execute(statement)
  db:close()
end

function getOldLoc(w)
  local windowID, X, Y, W, H
  local db = connectWinManagementDB()
  local deleteStatement = "DELETE FROM WINDOW_MANAGEMENT WHERE WINDOW_ID = " .. w:id() .. ";"
  local findStatement = "SELECT * from WINDOW_MANAGEMENT WHERE WINDOW_ID = " .. w:id() .. ";"
  for row in db:nrows(findStatement) do
    windowID = row.WINDOW_ID
    X = row.X
    Y = row.Y
    W = row.W
    H = row.H
    break
  end

  db:execute(deleteStatement)
  db:close()
  return windowID, X, Y, W, H
end