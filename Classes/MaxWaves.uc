class MaxWaves extends KFMutator
			Config(MaxWaves);
var config int MaxWave;
var config int INIVersion;
var config bool bConfigFileFound;

var bool bGameEnded;
var int CurrentINIVersion;
var KFGameInfo_Endless KFGI_E;

	function PostBeginPlay()
		{
			super.PostBeginPlay();
			ConfigCheck();
			if (MaxWave > 254 || MaxWave < 0)
				MaxWave = 254;
			SetTimer(5, true, nameof(CheckMyKFGI));
			`log("MaxWaves: The Maximum Amount of Endless Waves is: " $ MyKFGI.MyKFGRI.WaveMax);
		}

		function bool CheckMyKFGI()
		{
			if (MyKFGI.MyKFGRI != None)
			{
				MyKFGI.MyKFGRI.WaveMax = MaxWave;
				Cleartimer(nameof(CheckMyKFGI));
				return true;
			}
		}

		function ScoreKill(Controller Killer, Controller Killed)
		{
			if (bGameEnded)
				return;
			if (MyKFGI.AIAliveCount <= 1)
				CheckEndGame(PlayerController(Killer).RealViewTarget,"Exceeding Custom Wave");
		}


	function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
	{
		if (MyKFGI.MyKFGRI.WaveNum < MaxWave)
		{
			`log("MaxWaves: " $ MyKFGI.MyKFGRI.WaveNum $ " didn't exceed MaxWave of " $ MyKFGI.MyKFGRI.WaveMax);
			return false;
		}
		else if (MyKFGI.MyKFGRI.WaveNum >= MaxWave && MyKFGI.MyKFGRI.WaveMax != 0)
		{
			`log("44Ending Game");
			bGameEnded = true;
			KFGameInfo_Survival(MyKFGI).EndOfMatch(true);
			KillAllZeds();
			return true;
		}
	
	}



	function KillAllZeds()
	{
		local  KFPawn_Monster AIP;
		foreach WorldInfo.AllPawns(class'KFPawn_Monster', AIP)
		{
			if (AIP.Health > 0)
			{
				AIP.Died(none, none, AIP.Location);
			}
		}
	}

function ConfigCheck()
	{
		if (bConfigFileFound == false || INIVersion < CurrentINIVersion)
		{
			bConfigFileFound = true;
			INIVersion = CurrentINIVersion;
			MaxWave = 254;
			saveconfig();
			`log("MaxWaves:- Config Saved Succesfully!");
		}
		else if (bConfigFileFound ==  true)
		{
			`log("MaxWaves:- Config File Found!");			
		}
	}

	defaultproperties
	{
		CurrentINIVersion = 1.0
	}