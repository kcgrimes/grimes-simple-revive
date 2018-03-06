class G_Revive_Dialog
{
	idd=-1;
	movingenable=false;
	onLoad = "_this call G_fnc_Dialog_Rescuer_Text; _this call G_fnc_Dialog_Downs_Text;";
	
	class controls 
	{
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by Grimes [3rd ID], v1.063, #Sihigi)
		////////////////////////////////////////////////////////
		class G_Near_Rescuers: RscText
		{
			idc = 1001;
			text = "";
			font = TahomaB;
			sizeEx = 0.03;
			style = 528;
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 0.55 * safezoneW;
			h = 0.15 * safezoneH;
			colorBackground[] = {0,0,0,1};
			lineSpacing = 1;
		};
		class G_Downs_Remaining: RscText
		{
			idc = 1002;
			text = "";
			font = TahomaB;
			sizeEx = 0.03;
			style = 528;
			x = 0.5 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 0.55 * safezoneW;
			h = 0.15 * safezoneH;
			colorBackground[] = {0,0,0,1};
			lineSpacing = 1;
		};
		class G_Frame_Bottom: RscText
		{
			idc = 1003;
			text = "\n\nYou are Unconscious and awaiting revive.\nPress Escape to give up."; //--- ToDo: Localize;
			font = TahomaB;
			sizeEx = 0.04;
			style = 530;
			x = 0 * safezoneW + safezoneX;
			y = 0.85 * safezoneH + safezoneY;
			w = 1 * safezoneW;
			h = 0.15 * safezoneH;
			colorBackground[] = {0,0,0,1};
			lineSpacing = 1;
		};
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT END
		////////////////////////////////////////////////////////
	};
};

/* #Dimibe
$[
	1.063,
	["G_Revive_Dialog",[[0,0,1,1],0.025,0.04,"GUI_GRID"],0,0,0],
	[1000,"G_Frame_Top",[1,"",["0 * safezoneW + safezoneX","0 * safezoneH + safezoneY","1 * safezoneW","0.14 * safezoneH"],[-1,-1,-1,-1],[0,0,0,0.2],[-1,-1,-1,-1],"","-1"],[]],
	[1001,"G_Frame_Bottom",[1,"You are Unconscious and awaiting revive. Press Escape to respawn.",["0 * safezoneW + safezoneX","0.86 * safezoneH + safezoneY","1 * safezoneW","0.14 * safezoneH"],[-1,-1,-1,-1],[0,0,0,1],[-1,-1,-1,-1],"","-1"],[]],
	[1002,"G_Near_Rescuers",[1,"",["0.05 * safezoneW + safezoneX","0 * safezoneH + safezoneY","0.183333 * safezoneW","0.131949 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1003,"",[1,"",["0.76 * safezoneW + safezoneX","0 * safezoneH + safezoneY","0.183333 * safezoneW","0.131949 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/