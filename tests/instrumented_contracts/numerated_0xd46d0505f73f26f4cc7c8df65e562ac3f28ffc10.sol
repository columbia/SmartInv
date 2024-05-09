1 pragma solidity^0.4.24;library SafeMath{function mul(uint256 a,uint256 b)
2 internal
3 pure
4 returns(uint256 c)
5 {if(a==0){return 0;}
6 c=a*b;require(c/a==b,"SafeMath mul failed");return c;}
7 function div(uint256 a,uint256 b)internal pure returns(uint256){uint256 c=a/b;return c;}
8 function sub(uint256 a,uint256 b)
9 internal
10 pure
11 returns(uint256)
12 {require(b<=a,"SafeMath sub failed");return a-b;}
13 function add(uint256 a,uint256 b)
14 internal
15 pure
16 returns(uint256 c)
17 {c=a+b;require(c>=a,"SafeMath add failed");return c;}
18 function sqrt(uint256 x)
19 internal
20 pure
21 returns(uint256 y)
22 {uint256 z=((add(x,1))/2);y=x;while(z<y)
23 {y=z;z=((add((x/z),z))/2);}}
24 function sq(uint256 x)
25 internal
26 pure
27 returns(uint256)
28 {return(mul(x,x));}
29 function pwr(uint256 x,uint256 y)
30 internal
31 pure
32 returns(uint256)
33 {if(x==0)
34 return(0);else if(y==0)
35 return(1);else
36 {uint256 z=x;for(uint256 i=1;i<y;i++)
37 z=mul(z,x);return(z);}}}
38 library NameFilter{function nameFilter(string _input)
39 internal
40 pure
41 returns(bytes32)
42 {bytes memory _temp=bytes(_input);uint256 _length=_temp.length;require(_length<=32&&_length>0,"string must be between 1 and 32 characters");require(_temp[0]!=0x20&&_temp[_length-1]!=0x20,"string cannot start or end with space");if(_temp[0]==0x30)
43 {require(_temp[1]!=0x78,"string cannot start with 0x");require(_temp[1]!=0x58,"string cannot start with 0X");}
44 bool _hasNonNumber;for(uint256 i=0;i<_length;i++)
45 {if(_temp[i]>0x40&&_temp[i]<0x5b)
46 {_temp[i]=byte(uint(_temp[i])+32);if(_hasNonNumber==false)
47 _hasNonNumber=true;}else{require
48 (_temp[i]==0x20||(_temp[i]>0x60&&_temp[i]<0x7b)||(_temp[i]>0x2f&&_temp[i]<0x3a),"string contains invalid characters");if(_temp[i]==0x20)
49 require(_temp[i+1]!=0x20,"string cannot contain consecutive spaces");if(_hasNonNumber==false&&(_temp[i]<0x30||_temp[i]>0x39))
50 _hasNonNumber=true;}}
51 require(_hasNonNumber==true,"string cannot be only numbers");bytes32 _ret;assembly{_ret:=mload(add(_temp,32))}
52 return(_ret);}}
53 contract ProtectEarth{using SafeMath for*;using NameFilter for*;struct Player{address addr;bytes32 name;uint8 level;uint256 recCount;uint256 laffID;uint256 commanderID;uint256 captainID;uint256 win;uint256 enableVault;uint256 affVault;uint256 achievement;uint256 keys;}
54 struct Performance{uint value;uint start;uint end;uint fenzi;uint fenmu;}
55 struct CurrDayPerformance{uint value;uint start;}
56 struct EventReturns{address playerAddress;uint256 playerID;uint256 ethIn;uint256 keysBought;uint256 affiliateID;uint256 commanderID;uint256 captainID;uint256 airAmount;uint256 potAmount;uint256 timeStamp;}
57 event onNewName
58 (uint256 indexed playerID,address indexed playerAddress,bytes32 indexed playerName,bool isNewPlayer,uint256 affiliateID,address affiliateAddress,bytes32 affiliateName,uint256 amountPaid,uint256 timeStamp);event onWithdraw(uint indexed pID,address pAddress,bytes32 pName,uint ethOut,uint timeStamp);event onLevelUp
59 (uint256 indexed playerID,address indexed playerAddress,bytes32 indexed playerName,uint256 timeStamp);event airePotOpen
60 (uint256 indexed playerID,address indexed playerAddress,bytes32 indexed playerName,uint256 amount,uint256 timeStamp);event onNewPlayer
61 (uint256 indexed playerID,address indexed playerAddress,bytes32 indexed playerName,uint256 affiliateID,uint256 commanderID,uint256 captainID,uint256 timeStamp);event onEndTx
62 (address indexed playerAddress,uint256 indexed playerID,uint256 ethIn,uint256 keysBought,uint256 affiliateID,uint256 commanderID,uint256 captainID,uint256 airAmount,uint256 potAmount,uint256 timeStamp);uint256 constant private captionPrice=15 ether;uint256 constant private leaderPrice=5 ether;uint256 constant private price=1 ether;uint256 constant private unLockPrice=1 ether;uint constant private cap2capRate=2;uint constant private captainRate=5;uint constant private comm2commRate=5;uint constant private firstLevel=8;uint constant private secondLevel=5;uint constant private potRate=60;uint constant private airDropRate=1;uint256 public airDropPot_;uint16 public openWeek=0;uint256 public gameStart;bool public activated_=false;uint256 public totalEth_;uint256 public pot_;uint public constant rebatePeriod_=1 days;uint16 public rebateOneFenzi_=1;uint16 public rebateOneFenmu_=1000;uint16 public rebateTwoFenzi_=2;uint16 public rebateTwoFenmu_=1000;mapping(uint=>Performance[])public rebateOne_;mapping(uint=>Performance[])public rebateTwo_;mapping(address=>uint256)public pIDxAddr_;mapping(uint256=>Player)public plyr_;uint256 public pID_;mapping(uint=>CurrDayPerformance)public plyrCurrDayPerformance_;uint constant private oneDay_=1 days;uint constant private oneWeek_=1 weeks;uint constant private upCaptainRec_=20;uint constant private upCommanderRec_=5;address comWallet;address agentWallet;address devWallet;address bossHeWallet;address middleWallet;constructor()public{comWallet=0x1a072ec061A9972F420E39b08Ee5ECA5949b0991;agentWallet=0xd5644D6ceF13055c1767Ec56e9fd8A78BABd1C77;devWallet=0x1624f4586db8ad39e90982532f99be16a1ae8f4b;bossHeWallet=0x5e62Ad58D850Bf7f920e30384B7e96fdAdb14DE2;middleWallet=0xf6136dBAe3cC2D8f61d007778375Fb12eA9e9273;plyr_[1].addr=0x53c48e40f8714114422999f462b1a319f70f2589;plyr_[1].name="system";pIDxAddr_[0x53c48e40f8714114422999f462b1a319f70f2589]=1;plyr_[1].level=1;plyr_[2].addr=0x0cd27acc77b4ad5a5e9f3b14a186c42ef57f9c25;plyr_[2].name="commander";pIDxAddr_[0x0cd27acc77b4ad5a5e9f3b14a186c42ef57f9c25]=2;plyr_[2].level=2;plyr_[3].addr=0x73df22e445ea9f337117d01be04e98c8ece526e5;plyr_[3].name="captain";pIDxAddr_[0x73df22e445ea9f337117d01be04e98c8ece526e5]=3;plyr_[3].level=3;pID_=3;}
63 function getPlayerByAddr(address _addr)public view
64 returns(uint256,bytes32,uint8,uint256,uint256){uint256 _pID=pIDxAddr_[_addr];if(_pID==0)return(0,"",0,0,0);return(_pID,plyr_[_pID].name,plyr_[_pID].level,plyr_[_pID].recCount,plyr_[_pID].keys);}
65 function getStastiticsByAddr(address _addr)public view
66 returns(uint256,uint256,uint256,uint,uint){uint256 _pID=pIDxAddr_[_addr];if(_pID==0)return(0,0,0,0,0);uint256 totalCaptain;uint256 totalCommander;uint256 totalSoldier;for(uint256 i=1;i<=pID_;i++){if(plyr_[_pID].level==3){if(plyr_[i].level==3&&plyr_[i].captainID==_pID){totalCaptain++;}
67 if(plyr_[i].level==2&&plyr_[i].captainID==_pID){totalCommander++;}
68 if(plyr_[i].level==1&&plyr_[i].captainID==_pID){totalSoldier++;}}
69 if(plyr_[_pID].level==2){if(plyr_[i].level==2&&plyr_[i].commanderID==_pID){totalCommander++;}
70 if(plyr_[i].level==1&&plyr_[i].commanderID==_pID){totalSoldier++;}}}
71 uint currDayPerf=plyrCurrDayPerformance_[_pID].value;if(isNewDay(_pID)){currDayPerf=0;}
72 return(totalCaptain,totalCommander,totalSoldier,currDayPerf,plyr_[_pID].achievement);}
73 function getVaults(address _addr)public view
74 returns(uint,uint,uint,uint){uint256 _pID=pIDxAddr_[_addr];if(_pID==0)return(0,0,0,1 ether);(uint enaOneRebate,uint totalOneRebate)=calRebateAll(rebateOne_[_pID]);(uint enaTwoRebate,uint totalTwoRebate)=calRebateAll(rebateTwo_[_pID]);return(plyr_[_pID].win,plyr_[_pID].affVault,(plyr_[_pID].enableVault).add(enaOneRebate).add(enaTwoRebate),totalOneRebate.add(totalTwoRebate).sub(enaOneRebate).sub(enaTwoRebate));}
75 function withdraw()public isActivated()isHuman(){uint256 _pID=pIDxAddr_[msg.sender];uint enaOneRebate=calRebateUpdate(rebateOne_[_pID]);uint enaTwoRebate=calRebateUpdate(rebateTwo_[_pID]);uint _earning=(plyr_[_pID].enableVault).add(enaOneRebate).add(enaTwoRebate).add(plyr_[_pID].affVault).add(plyr_[_pID].win);if(_earning>0){(plyr_[_pID].addr).transfer(_earning);plyr_[_pID].enableVault=0;plyr_[_pID].affVault=0;plyr_[_pID].win=0;}
76 emit onWithdraw(_pID,plyr_[_pID].addr,plyr_[_pID].name,_earning,now);}
77 function reload(uint _eth)public isActivated()isHuman(){uint256 _pID=pIDxAddr_[msg.sender];uint enaOneRebate=calRebateUpdate(rebateOne_[_pID]);uint enaTwoRebate=calRebateUpdate(rebateTwo_[_pID]);plyr_[_pID].enableVault=(plyr_[_pID].enableVault).add(enaOneRebate).add(enaTwoRebate);require(((plyr_[_pID].enableVault).add(plyr_[_pID].affVault).add(plyr_[_pID].win))>=_eth,"your balance not enough");if(plyr_[_pID].enableVault>=_eth){plyr_[_pID].enableVault=(plyr_[_pID].enableVault).sub(_eth);}
78 else if((plyr_[_pID].enableVault).add(plyr_[_pID].affVault)>=_eth){plyr_[_pID].affVault=(plyr_[_pID].enableVault).add(plyr_[_pID].affVault).sub(_eth);plyr_[_pID].enableVault=0;}
79 else{plyr_[_pID].win=(plyr_[_pID].enableVault).add(plyr_[_pID].affVault).add(plyr_[_pID].win).sub(_eth);plyr_[_pID].affVault=0;plyr_[_pID].enableVault=0;}
80 EventReturns memory _eventData_;_eventData_.playerID=_pID;_eventData_.playerAddress=msg.sender;_eventData_.affiliateID=plyr_[_pID].laffID;_eventData_.commanderID=plyr_[_pID].commanderID;_eventData_.captainID=plyr_[_pID].captainID;_eventData_.ethIn=_eth;buycore(_pID,_eventData_,false,_eth);}
81 function calRebateUpdate(Performance[]storage _ps)private returns(uint){uint _now=now;uint totalEna;for(uint i=0;i<_ps.length;i++){if(_ps[i].end>_ps[i].start){if(_now>_ps[i].end)_now=_ps[i].end;uint _one=(_now-_ps[i].start)/rebatePeriod_;totalEna=totalEna.add(_one.mul((_ps[i].value).mul(_ps[i].fenzi)/_ps[i].fenmu));if(_now>=_ps[i].end){_ps[i].end=0;}
82 else{_ps[i].start=_ps[i].start+(_one*rebatePeriod_);}}}
83 pot_=pot_.sub(totalEna);return(totalEna);}
84 function calRebateAll(Performance[]memory _ps)private view returns(uint,uint){uint _now=now;uint totalEna;uint total;for(uint i=0;i<_ps.length;i++){if(_ps[i].end>_ps[i].start){if(_now>_ps[i].end)_now=_ps[i].end;uint _one=(_now-_ps[i].start)/rebatePeriod_;totalEna=totalEna.add(_one.mul((_ps[i].value).mul(_ps[i].fenzi)/_ps[i].fenmu));uint _td=(_ps[i].end-_ps[i].start)/rebatePeriod_;total=total.add(_td.mul((_ps[i].value).mul(_ps[i].fenzi)/_ps[i].fenmu));}}
85 return(totalEna,total);}
86 function airdrop()
87 private
88 view
89 returns(uint256)
90 {uint256 seed=uint256(keccak256(abi.encodePacked((block.timestamp).add
91 (block.difficulty).add
92 ((uint256(keccak256(abi.encodePacked(block.coinbase))))/(now)).add
93 (block.gaslimit).add
94 ((uint256(keccak256(abi.encodePacked(msg.sender))))/(now)).add
95 (block.number))));return seed%pID_+1;}
96 function isNewWeek()
97 public
98 view
99 returns(bool)
100 {if((now-gameStart-(openWeek*oneWeek_))>oneWeek_){return true;}else{return false;}}
101 function endWeek()private{uint256 win=airDropPot_/2;uint256 plyId=airdrop();plyr_[plyId].win=(plyr_[plyId].win).add(win);airDropPot_=airDropPot_.sub(win);openWeek++;emit airePotOpen
102 (plyId,plyr_[plyId].addr,plyr_[plyId].name,win,now);}
103 function airDropTime()public view returns(uint256){return(gameStart+(openWeek+1)*oneWeek_);}
104 function levelUp(uint leveType)
105 public
106 isActivated()
107 isHuman()
108 payable
109 {uint256 value=msg.value;uint256 pId=pIDxAddr_[msg.sender];require(leveType==1||leveType==2,"leveType error");if(leveType==1){require(plyr_[pId].level==1,"your must be a soldier");require(value>=leaderPrice,"your must paid enough money");require(plyr_[pId].recCount>=upCommanderRec_,"you need more soldiers");plyr_[pId].level=2;}
110 else{require(plyr_[pId].level==2,"your must be a commander");require(value>=captionPrice,"your must paid enough money");require(plyr_[pId].recCount>=upCaptainRec_,"you need more soldiers");plyr_[pId].level=3;}
111 distributeLevelUp(value);emit onLevelUp
112 (pId,msg.sender,plyr_[pId].name,now);}
113 function distributeLevelUp(uint256 eth)
114 private
115 {uint256 tempEth=eth/100;devWallet.transfer(tempEth.mul(2));bossHeWallet.transfer(tempEth.mul(20));middleWallet.transfer(tempEth.mul(3));agentWallet.transfer(eth.sub(tempEth.mul(25)));}
116 function activate()
117 public
118 onlyDevs()
119 {require(activated_==false,"game already activated");activated_=true;gameStart=now;}
120 function registerXaddr(uint256 affCode,string _nameString)
121 private
122 {bytes32 _name=NameFilter.nameFilter(_nameString);address _addr=msg.sender;uint256 _pID=pIDxAddr_[_addr];plyr_[_pID].name=_name;plyr_[_pID].level=1;if(affCode>=4&&affCode<=pID_&&_pID!=affCode){plyr_[_pID].laffID=affCode;if(plyr_[affCode].level==1){plyr_[_pID].commanderID=plyr_[affCode].commanderID;plyr_[_pID].captainID=plyr_[affCode].captainID;}
123 if(plyr_[affCode].level==2){plyr_[_pID].commanderID=affCode;plyr_[_pID].captainID=plyr_[affCode].captainID;}
124 if(plyr_[affCode].level==3){plyr_[_pID].commanderID=affCode;plyr_[_pID].captainID=affCode;}}else{plyr_[_pID].laffID=1;plyr_[_pID].commanderID=2;plyr_[_pID].captainID=3;}
125 plyr_[plyr_[_pID].laffID].recCount+=1;emit onNewPlayer(_pID,_addr,_name,affCode,plyr_[_pID].commanderID,plyr_[_pID].captainID,now);}
126 function buyXaddr(uint256 _affCode,string _name)
127 public
128 isActivated()
129 isHuman()
130 payable
131 {EventReturns memory _eventData_;uint256 _pID=pIDxAddr_[msg.sender];bool isNewPlyr=false;if(_pID==0)
132 {require(msg.value>=unLockPrice,"you must pay 1 eth to unlock your account");pID_++;pIDxAddr_[msg.sender]=pID_;plyr_[pID_].addr=msg.sender;_pID=pID_;registerXaddr(_affCode,_name);isNewPlyr=true;}
133 _eventData_.playerID=_pID;_eventData_.playerAddress=msg.sender;_eventData_.affiliateID=plyr_[_pID].laffID;_eventData_.commanderID=plyr_[_pID].commanderID;_eventData_.captainID=plyr_[_pID].captainID;_eventData_.ethIn=msg.value;buycore(_pID,_eventData_,isNewPlyr,msg.value);}
134 function buycore(uint256 _pID,EventReturns memory _eventData_,bool isNewPlyr,uint _eth)
135 private
136 {uint256 _keys=_eth.mul(1000000000000000000)/price;plyr_[_pID].keys=(plyr_[_pID].keys).add(_keys);totalEth_=_eth.add(totalEth_);pot_=pot_.add(_eth.mul(potRate)/100);airDropPot_=(distributeAirepot(_eth)).add(airDropPot_);uint256 residual=distribute(_pID,_eth,isNewPlyr);uint256 _com=_eth.sub(_eth.mul(90)/100).add(residual);comWallet.transfer(_com);if(isNewWeek()){endWeek();}
137 _eventData_.keysBought=_keys;_eventData_.airAmount=airDropPot_;_eventData_.potAmount=pot_;emit onEndTx(_eventData_.playerAddress,_eventData_.playerID,_eventData_.ethIn,_eventData_.keysBought,_eventData_.affiliateID,_eventData_.commanderID,_eventData_.captainID,_eventData_.airAmount,_eventData_.potAmount,now);}
138 function distributeAirepot(uint256 eth)
139 private returns(uint256 airpot)
140 {airpot=eth.mul(airDropRate)/100;devWallet.transfer(airpot);middleWallet.transfer(airpot);bossHeWallet.transfer(airpot.mul(2));}
141 function distribute(uint256 _pID,uint256 _eth,bool isNewPlyr)
142 private returns(uint256 residual)
143 {uint calDays=1*rebateTwoFenmu_/rebateTwoFenzi_*rebatePeriod_;if(isNewPlyr){rebateTwo_[_pID].push(Performance(_eth.mul(5)+1 ether,now,now+calDays,rebateTwoFenzi_,rebateTwoFenmu_));}else{rebateTwo_[_pID].push(Performance(_eth.mul(5),now,now+calDays,rebateTwoFenzi_,rebateTwoFenmu_));}
144 uint256 _affFee1=_eth.mul(firstLevel)/100;uint256 _affFee2=_eth.mul(secondLevel)/100;uint256 _affID=plyr_[_pID].laffID;uint256 _commanderID=plyr_[_pID].commanderID;uint256 _captainID=plyr_[_pID].captainID;plyr_[_affID].affVault=_affFee1.add(plyr_[_affID].affVault);if(_affID==1){residual=residual.add(_affFee2);}else{plyr_[plyr_[_affID].laffID].affVault=_affFee2.add(plyr_[plyr_[_affID].laffID].affVault);}
145 calDays=1*rebateOneFenmu_/rebateOneFenzi_*rebatePeriod_;rebateOne_[_commanderID].push(Performance(_eth,now,now+calDays,rebateOneFenzi_,rebateOneFenmu_));if(_commanderID==2){residual=residual.add((_eth.mul(comm2commRate)/100));}else{plyr_[plyr_[_commanderID].commanderID].enableVault=(_eth.mul(comm2commRate)/100).add(plyr_[plyr_[_commanderID].commanderID].enableVault);}
146 plyr_[_captainID].enableVault=(_eth.mul(captainRate)/100).add(plyr_[_captainID].enableVault);if(_captainID==3){residual=residual.add((_eth.mul(cap2capRate)/100));}else{plyr_[plyr_[_captainID].captainID].enableVault=(_eth.mul(cap2capRate)/100).add(plyr_[plyr_[_captainID].captainID].enableVault);}
147 uint _now=now;if(isNewDay(_affID)){plyrCurrDayPerformance_[_pID].value=0;plyrCurrDayPerformance_[_pID].start=_now;}
148 plyrCurrDayPerformance_[_affID].value=_eth.add(plyrCurrDayPerformance_[_affID].value);plyr_[_affID].achievement=_eth.add(plyr_[_affID].achievement);if(isNewDay(_commanderID)){plyrCurrDayPerformance_[_commanderID].value=0;plyrCurrDayPerformance_[_commanderID].start=_now;}
149 plyrCurrDayPerformance_[_commanderID].value=_eth.add(plyrCurrDayPerformance_[_commanderID].value);plyr_[_commanderID].achievement=_eth.add(plyr_[_commanderID].achievement);if(isNewDay(_captainID)){plyrCurrDayPerformance_[_captainID].value=0;plyrCurrDayPerformance_[_captainID].start=_now;}
150 plyrCurrDayPerformance_[_captainID].value=_eth.add(plyrCurrDayPerformance_[_captainID].value);plyr_[_captainID].achievement=_eth.add(plyr_[_captainID].achievement);}
151 function isNewDay(uint pID)
152 private
153 view
154 returns(bool)
155 {if((now/oneDay_)!=plyrCurrDayPerformance_[pID].start/oneDay_){return true;}else{return false;}}
156 modifier isActivated(){require(activated_==true,"its not ready yet.  check ?eta in discord");_;}
157 modifier onlyDevs(){require(msg.sender==0xE003d8A487ef29668d034f73F3155E78247b89cb,"only team just can activate");_;}
158 modifier isHuman(){address _addr=msg.sender;require(_addr==tx.origin);uint256 _codeLength;assembly{_codeLength:=extcodesize(_addr)}
159 require(_codeLength==0,"sorry humans only");_;}
160 function recharge()public isActivated()onlyDevs()payable{pot_=pot_.add(msg.value);}
161 function potWithdraw(address _addr,uint _eth)public isActivated()onlyDevs(){require(pot_>=_eth,"contract balance not enough");pot_=pot_.sub(_eth);_addr.transfer(_eth);}
162 function airWithdraw(address _addr,uint _eth)public isActivated()onlyDevs(){require(airDropPot_>=_eth,"contract balance not enough");airDropPot_=airDropPot_.sub(_eth);_addr.transfer(_eth);}
163 function setrebateOneRate(uint16 fenzi,uint16 fenmu)public isActivated()onlyDevs(){require(fenzi>=1&&fenmu>=1,"param error");rebateOneFenzi_=fenzi;rebateOneFenmu_=fenmu;}
164 function setrebateTwoRate(uint16 fenzi,uint16 fenmu)public isActivated()onlyDevs(){require(fenzi>=1&&fenmu>=1,"param error");rebateTwoFenzi_=fenzi;rebateTwoFenmu_=fenmu;}}