#pragma semicolon 1

//////////////////////////////
//		DEFINITIONS			//
//////////////////////////////

#define PLUGIN_NAME "Store - VIP Credits"
#define PLUGIN_AUTHOR "Cronick"
#define PLUGIN_DESCRIPTION "Extra credit for VIPs."
#define PLUGIN_VERSION "1.0"
#define PLUGIN_URL ""

//////////////////////////////
//			INCLUDES		//
//////////////////////////////

#include <sourcemod>

#include <store>
#include <zephstocks>

//////////////////////////////////
//		GLOBAL VARIABLES		//
//////////////////////////////////

new g_cvarCreditTimer = -1;
new g_cvarCreditAmountActive = -1;
new g_cvarCreditAmountInactive = -1;
new g_cvarRequiredFlag = -1;

new Handle:g_hTimer = INVALID_HANDLE;

//////////////////////////////////
//		PLUGIN DEFINITION		//
//////////////////////////////////

public Plugin:myinfo = 
{
	name = PLUGIN_NAME,
	author = PLUGIN_AUTHOR,
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = PLUGIN_URL
};

//////////////////////////////
//		PLUGIN FORWARDS		//
//////////////////////////////

public OnPluginStart()
{
	// Register ConVars
	g_cvarCreditTimer = RegisterConVar("sm_store_vip_credits_credit_interval", "60", "Interval in seconds to give out credits", TYPE_FLOAT);
	g_cvarCreditAmountActive = RegisterConVar("sm_store_vip_credits_credit_amount_active", "2", "Number of credits to give out for active players", TYPE_INT);
	g_cvarCreditAmountInactive = RegisterConVar("sm_store_vip_credits_credit_amount_inactive", "2", "Number of credits to give out for inactive players (spectators)", TYPE_INT);
	g_cvarRequiredFlag = RegisterConVar("sm_store_vip_credits_required_flag", "p", "Flag to access the !store menu", TYPE_FLAG);

	AutoExecConfig();

	g_cvarChatTag = RegisterConVar("sm_store_chat_tag", "[Store] ", "The chat tag to use for displaying messages.", TYPE_STRING);
}

public OnConfigsExecuted()
{
	if(g_hTimer == INVALID_HANDLE)
		g_hTimer = CreateTimer(g_eCvars[g_cvarCreditTimer][aCache], Timer_CreditTimer);
}

public Action:Timer_CreditTimer(Handle:timer, any:userid)
{
	LoopIngamePlayers(client)
	{
		if(!(GetUserFlagBits(client) & g_eCvars[g_cvarRequiredFlag][aCache]))
			continue;

		decl m_iCredits;

		if(2<=GetClientTeam(client)<=3)
			m_iCredits = g_eCvars[g_cvarCreditAmountActive][aCache];
		else
			m_iCredits = g_eCvars[g_cvarCreditAmountInactive][aCache];

		if(m_iCredits)
		{
			Store_SetClientCredits(client, Store_GetClientCredits(client) + m_iCredits);
			Chat(client, "You earned %d extra credits.", m_iCredits);
		}
	}

	g_hTimer = CreateTimer(g_eCvars[g_cvarCreditTimer][aCache], Timer_CreditTimer);

	return Plugin_Continue;
}