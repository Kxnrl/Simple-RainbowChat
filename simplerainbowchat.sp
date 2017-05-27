#include <sdktools>

ConVar g_cvarName;
ConVar g_cvarMesasge;

int g_flagName;
int g_flagMessage;

public Plugin myinfo = 
{
	name		= "Simple Rainbow Chat",
	author		= "Kyle",
	description	= "Rainbow chat",
	version		= "1.0",
	url			= "http://steamcommunity.com/id/_xQy_/"
};


public void OnPluginStart()
{
	g_cvarName = CreateConVar("src_name_flag", "b", "Set flag for vip must have to get access to rainbow chat name feature", FCVAR_NOTIFY);
	g_cvarMesasge = CreateConVar("src_message_flag", "b", "Set flag for vip must have to get access to rainbow chat messge feature", FCVAR_NOTIFY);

	HookConVarChange(g_cvarName, HookConVar);
	HookConVarChange(g_cvarMesasge, HookConVar);
	
	AutoExecConfig(true);
}

public void OnConfigsExecuted()
{
	char m_szFlags[32];
	
	GetConVarString(g_cvarName, m_szFlags, 32);
	g_flagName = ReadFlagString(m_szFlags);
	
	GetConVarString(g_cvarMesasge, m_szFlags, 32);
	g_flagMessage = ReadFlagString(m_szFlags);
}

public void HookConVar(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if(convar == g_cvarName)
		g_flagName = ReadFlagString(newValue)
	if(convar == g_cvarMesasge)
		g_flagMessage = ReadFlagString(newValue)
}

public Action CP_OnChatMessage(int& client, ArrayList recipients, char[] flagstring, char[] name, char[] message, bool &processcolors, bool &removecolors)
{
	Action result = Plugin_Continue;

	if(g_flagName == 0 || GetUserFlagBits(client) & g_flagName)
	{
		char newname[128];
		String_Rainbow(name, newname, 256);
		strcopy(name, 256, newname);
		result = Plugin_Changed;
	}
	
	if(g_flagMessage == 0 || GetUserFlagBits(client) & g_flagMessage)
	{
		char newmsg[256];
		String_Rainbow(message, newmsg, 256);
		strcopy(message, 256, newmsg);
		result = Plugin_Changed;
	}
	
	return result;
}

void String_Rainbow(const char[] input, char[] output, int maxLen)
{
	int bytes, buffs;
	int size = strlen(input)+1;
	char[] copy = new char [size];
	char color[2];

	for(int x = 0; x < size; ++x)
	{
		if(input[x] == '\0')
			break;
		
		if(buffs == 2)
		{
			RandomColor(color);
			strcopy(copy, size, input);
			copy[x+1] = '\0';
			bytes += StrCat(output, maxLen, color);
			bytes += StrCat(output, maxLen, copy[x-buffs]);
			buffs = 0;
			continue;
		}

		if(!IsChar(input[x]))
		{
			buffs++;
			continue;
		}

		RandomColor(color);
		strcopy(copy, size, input);
		copy[x+1] = '\0';
		bytes += StrCat(output, maxLen, color);
		bytes += StrCat(output, maxLen, copy[x]);
	}

	output[++bytes] = '\0';
}

bool IsChar(char c)
{
	if(0 <= c <= 126)
		return true;
	
	return false;
}

void RandomColor(char color[2])
{
	switch(GetRandomInt(1, 16))
	{
		case  1: strcopy(color, 2, "\x01");
		case  2: strcopy(color, 2, "\x02");
		case  3: strcopy(color, 2, "\x03");
		case  4: strcopy(color, 2, "\x03");
		case  5: strcopy(color, 2, "\x04");
		case  6: strcopy(color, 2, "\x05");
		case  7: strcopy(color, 2, "\x06");
		case  8: strcopy(color, 2, "\x07");
		case  9: strcopy(color, 2, "\x08");
		case 10: strcopy(color, 2, "\x09");
		case 11: strcopy(color, 2, "\x10");
		case 12: strcopy(color, 2, "\x0A");
		case 13: strcopy(color, 2, "\x0B");
		case 14: strcopy(color, 2, "\x0C");
		case 15: strcopy(color, 2, "\x0E");
		case 16: strcopy(color, 2, "\x0F");
	}
}