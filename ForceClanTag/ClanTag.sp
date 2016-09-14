#include <sourcemod> 
#include <cstrike>

public Plugin:myinfo = 
{
    name = "Force Clan Tag",
    author = "Cronick",
    description = "Force Clan Tag",
}


public OnPluginStart() 
{  
    HookEvent("player_team", Event); 
    HookEvent("player_spawn", Event); 
} 

public Action:Event(Handle:event, String:name[], bool:dontBroadcast) 
{ 
    new client = GetClientOfUserId(GetEventInt(event, "userid")); 
    HandleTag(client); 
} 

public OnClientPostAdminCheck(client) 
{ 
	HandleTag(client);
} 

HandleTag(client) 
{ 
  if (client > 0) 
  { 
	CS_SetClientClanTag(client, "### Change Me ###"); 
  }
}

public OnClientSettingsChanged(client)
{ 
    CreateTimer(0.2, ResetTag, client);
} 

public Action:ResetTag(Handle:timer, any:client)
{
    HandleTag(client);
}