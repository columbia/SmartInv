1 pragma solidity ^0.4.7;
2 contract MobaBase {
3     address public owner = 0x0;
4     bool public isLock = false;
5     constructor ()  public  {
6         owner = msg.sender;
7     }
8     
9     event transferToOwnerEvent(uint256 price);
10     
11     modifier onlyOwner {
12         require(msg.sender == owner,"only owner can call this function");
13         _;
14     }
15     
16     modifier notLock {
17         require(isLock == false,"contract current is lock status");
18         _;
19     }
20     
21     modifier msgSendFilter() {
22         address addr = msg.sender;
23         uint size;
24         assembly { size := extcodesize(addr) }
25         require(size <= 0,"address must is not contract");
26         require(msg.sender == tx.origin, "msg.sender must equipt tx.origin");
27         _;
28     }
29     
30     function transferOwnership(address newOwner) onlyOwner public {
31         if (newOwner != address(0)) {
32             owner = newOwner;
33         }
34     }
35     
36     function transferToOwner()    
37     onlyOwner 
38     msgSendFilter 
39     public {
40         uint256 totalBalace = address(this).balance;
41         owner.transfer(totalBalace);
42         emit transferToOwnerEvent(totalBalace);
43     }
44     
45     function updateLock(bool b) onlyOwner public {
46         
47         require(isLock != b," updateLock new status == old status");
48         isLock = b;
49     }
50     
51    
52 }
53 
54 contract IConfigData {
55    function getPrice() public view returns (uint256);
56    function getWinRate(uint8 winCount) public pure returns (uint);
57    function getOverRate(uint8 winCount) public pure returns (uint);
58    function getPumpRate() public view returns(uint8);
59    function getRandom(bytes32 param) public returns (bytes32);
60    function GetAddressByName(bytes32 name) public view returns (address);
61    function getInviteRate() public view returns (uint);
62    function loseHandler(address addr,uint8 wincount) public ;
63 }
64 
65 contract BRBasketballControl is MobaBase {
66     
67     Winner public mWinner;
68     bytes32 mRandomValue;
69 
70     uint gameIndex;
71     IConfigData public mConfig;
72     IConfigData public mNewConfig;
73    
74     constructor(address config) public {
75         mConfig = IConfigData(config);
76         startNewGame();
77     }
78     event pkEvent(address winAddr,address pkAddr,bytes32 pkInviteName,uint winRate,uint overRate,uint curWinRate,uint curOverRate,bool pkIsWin,uint256 price);
79     event gameOverEvent(uint gameIndex,address winAddr,uint256 price,uint256 totalBalace);
80     struct Winner {
81         uint8 num;
82         uint8 winCount;
83         address addr;
84     }
85     
86     function updateConfig(address newAddr)
87     onlyOwner 
88     public{
89         mNewConfig = IConfigData(newAddr);
90   
91     }
92     
93     function PK(uint8 num,bytes32 name) 
94     notLock
95     msgSendFilter
96     public payable {
97         
98         require(msg.value == mConfig.getPrice(),"msg.value is error");
99         require(msg.sender != mWinner.addr,"msg.sender != winner");
100         uint winRate  = mConfig.getWinRate(mWinner.winCount);
101 
102         uint curWinRate ; uint curOverRate;
103         (curWinRate,curOverRate) = getRandom(100);
104         
105   
106                 
107         inviteHandler(name);
108         address oldWinAddr = mWinner.addr;
109         if(mWinner.addr == address(0) ) {
110             mWinner = Winner(num,0,msg.sender);
111         }
112         else if( winRate < curWinRate ) {
113             mWinner = Winner(num,1,msg.sender);
114         }
115         else{
116             mWinner.winCount = mWinner.winCount + 1;
117         }
118         uint overRate = mConfig.getOverRate(mWinner.winCount);
119         emit pkEvent(mWinner.addr,msg.sender,name, winRate, overRate, curWinRate, curOverRate,msg.sender == mWinner.addr, mConfig.getPrice());
120         if(oldWinAddr != address(0) && curOverRate < overRate  ) {
121         
122           require(mWinner.addr != address(0),"Winner.addr is null");
123           
124           uint pumpRate = mConfig.getPumpRate();
125           uint totalBalace = address(this).balance;
126           uint giveToOwn   = totalBalace * pumpRate / 100;
127           uint giveToActor = totalBalace - giveToOwn;
128           owner.transfer(giveToOwn);
129           mWinner.addr.transfer(giveToActor);
130             
131          emit gameOverEvent(gameIndex, mWinner.addr,mConfig.getPrice(),giveToActor);
132           startNewGame();
133         }
134     }
135     
136     function startNewGame() private {
137         
138         gameIndex++;
139         mWinner = Winner(0,1,address(0));
140         if(mNewConfig != address(0) && mNewConfig != mConfig){
141             mConfig = mNewConfig;
142         }
143     }
144     
145     function inviteHandler(bytes32 inviteName) private {
146         
147         if(mConfig == address(0)) {
148           return ;
149         }
150         address inviteAddr = mConfig.GetAddressByName(inviteName);
151         if(inviteAddr != address(0)) {
152            uint giveToEth   = msg.value * mConfig.getInviteRate() / 100;
153            inviteAddr.transfer(giveToEth);
154         }
155     }
156     function getRandom(uint maxNum) private returns(uint,uint) {
157      
158         bytes32 curRandom = keccak256(abi.encodePacked(msg.sender,mRandomValue));
159         curRandom = mConfig.getRandom(curRandom);
160         curRandom = keccak256(abi.encodePacked(msg.sender,mRandomValue));
161         uint value1 = (uint(curRandom) % maxNum);
162         
163         curRandom  = keccak256(abi.encodePacked(msg.sender,curRandom,value1));
164         uint value2 = (uint(curRandom) % maxNum);
165         mRandomValue = curRandom;
166         return (value1,value2);
167     }
168     
169     function getGameInfo() public view returns (uint index,uint price,uint256 balace, 
170                                           uint winNum,uint winCount,address WinAddr,uint winRate,uint winOverRate,
171                                           uint pkOverRate
172                                           ){
173         uint curbalace    = address(this).balance;
174         uint winnernum   = mWinner.num;
175         uint winnercount = mWinner.winCount;
176         address winneraddr  = mWinner.addr;
177         uint curWinRate  = mConfig.getWinRate(mWinner.winCount);
178         uint curOverRate = mConfig.getOverRate(mWinner.winCount);
179         uint curPkOverRate= mConfig.getOverRate(1);
180         return (gameIndex, mConfig.getPrice(), curbalace,
181                 winnernum,winnercount,winneraddr,curWinRate,curOverRate,
182                 curPkOverRate);
183     }
184 }