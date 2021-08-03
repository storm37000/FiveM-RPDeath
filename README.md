<h1>Goal:</h1>
  Prevent automatic respawn to allow medical units to respond to a scene. This script will **NOT** override default respawn points (handled by mapmanager).

<h2>Installation instructions: </h2>
<ol>
  <li>Drag the RPDeath folder into your server's resource folder. ex (fx-server/resources)</li>
  <li>Edit your server.cfg file located in the main folder. ex (fx-server/)</li>
  <li>Add the following code: <b>start RPDeath</b> under the other similar options. Example below.<br/>
	start mapmanager<br/>
	start chat<br/>
	start spawnmanager<br/>
	start hardcap<br/>
	start rconlog<br/>
	start fivem-map-skater<br/>
  start RPDeath</li>
  <li>All done, restart your server and the mod should automatically start.</li>
</ol>

<h2>Requires:</h2>
  <b>start spawnmanager</b>

<h2>Usage Commands:</h2>

  <h3>Respawn Command:</h3>
    <b>/respawn</b> : Will respawn you at one of the existing respawn points.

  <h3>Revive Command:</h3>
    <b>/revive</b> : Will revive you at your current spot. Must be dead.<br/>
    <b>/revive *id*</b> : Will revive the player ID at their current location.  Player must be dead.  This requires granting the ace "reviveothers".

  <h3>Toggle Command:</h3>
    <b>/toggleDeath</b> : Upon dying you will automatically respawn at one of the existing respawn points.
