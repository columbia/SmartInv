1 pragma solidity ^0.4.18;
2 
3 
4 interface token {
5     function transfer(address receiver, uint amount) public;
6 }
7 
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a==0) {
11             return 0;
12         }
13         uint c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a / b;
19         return c;
20     }
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract GameTable {
33     using SafeMath for uint;
34 
35     struct Player {
36         address addr;
37         uint amount;
38         uint profit;
39     }
40 
41     struct Option {
42         uint optionid;
43         bytes32 optionName;
44         bytes32 optionImage;
45         uint amount;
46         uint numPlayers;
47         mapping (uint => Player) players;
48         mapping (address => uint) playeramounts;
49     }
50 
51     struct Game {
52         address gameManager;
53         bytes32 gameName;
54         uint numOptions;
55         uint amount;
56         uint balance;
57         uint winner;
58         uint startTime;
59         uint endTime;
60         uint openTime;
61         uint runingStatus;
62         mapping (uint => Option) options;
63     }
64 
65     address owner;
66     uint numGames;
67     mapping (uint => Game) games;
68     address gameDeveloper = 0x18d91206b297359e8aed91810a86D6bFF0AF3462;
69     //0x18d91206b297359e8aed91810a86d6bff0af3462
70     
71     function GameTable() public { 
72         owner = msg.sender;
73         numGames=0;
74     }
75     
76     function kill() public {
77        if (owner == msg.sender) { 
78           selfdestruct(owner);
79        }
80     }
81 
82     function newGame(bytes32 name, uint startDuration, uint endDuration, uint openDuration)  public returns (uint) {
83         if(startDuration < 1 || openDuration>888888888888 || endDuration<startDuration || openDuration<startDuration || openDuration<endDuration || owner != msg.sender) revert();
84         address manager =  msg.sender;
85         uint startTime = now + startDuration * 1 minutes;
86         uint endTime = now + endDuration * 1 minutes;
87         uint openTime = now + openDuration * 1 minutes;
88         games[numGames] = Game(manager, name, 0, 0, 0, 0, startTime, endTime, openTime, 0);
89         numGames = numGames+1; 
90         return (numGames-1);
91     }
92 
93     function getGameNum() public constant returns(uint) {return numGames;}
94 
95     function getGameInfo (uint gameinx) public constant returns(bytes32 _gamename,uint _numoptions,uint _amount,uint _startTime,uint _endTime,uint _openTime,uint _runingStatus) {
96         _gamename = games[gameinx].gameName;
97         _numoptions = games[gameinx].numOptions;
98         _amount = games[gameinx].amount;
99         _startTime = games[gameinx].startTime;
100         _endTime = games[gameinx].endTime;
101         _openTime = games[gameinx].openTime;
102         _runingStatus = games[gameinx].runingStatus;
103     }
104     
105 
106     function newOption(uint gameinx, uint optionid, bytes32 name, bytes32 optionimage)  public returns (uint) {
107         if (owner != msg.sender) revert();
108         if (gameinx > numGames) revert();
109         if (now >= games[gameinx].startTime) revert();
110         if (games[gameinx].runingStatus == 0){
111             games[gameinx].runingStatus = 1;
112         }
113         games[gameinx].numOptions = games[gameinx].numOptions+1;
114         games[gameinx].options[games[gameinx].numOptions-1] = Option(optionid, name, optionimage, 0, 0);
115         return games[gameinx].numOptions-1;
116     }
117 
118 
119     function getGameWinner (uint gameinx) public constant returns(uint) {return games[gameinx].winner;}
120     function getOptionInfo (uint gameinx, uint optioninx) public constant returns(uint _gameinx, uint _optionid, uint _optioninx,bytes32 _optionname,bytes32 _optionimage,uint _numplayers, uint _amount, uint _playeramount) {
121         _gameinx = gameinx;
122         _optioninx = optioninx;
123         _optionid = games[gameinx].options[optioninx].optionid;
124         _optionname = games[gameinx].options[optioninx].optionName;
125         _optionimage = games[gameinx].options[optioninx].optionImage;
126         _numplayers = games[gameinx].options[optioninx].numPlayers;
127         _amount = games[gameinx].options[optioninx].amount;
128         _playeramount = games[gameinx].options[optioninx].playeramounts[msg.sender];
129     }
130 
131     function getPlayerPlayInfo (uint gameinx, uint optioninx, uint playerinx) public constant returns(address _addr, uint _amount, uint _profit) {
132         if(msg.sender != owner) revert();
133         _addr = games[gameinx].options[optioninx].players[playerinx].addr;
134         _amount = games[gameinx].options[optioninx].players[playerinx].amount;
135         _profit = games[gameinx].options[optioninx].players[playerinx].profit;
136     }
137 
138     function getPlayerAmount (uint gameinx, uint optioninx, address addr) public constant returns(uint) {
139         if(msg.sender != owner) revert();
140         return games[gameinx].options[optioninx].playeramounts[addr];
141     }
142 
143   
144     function contribute(uint gameinx,uint optioninx)  public payable {
145         if ((gameinx<0)||(gameinx>999999999999999999999999999999999999)||(optioninx<0)) revert();
146         if (optioninx >= games[gameinx].numOptions) revert();
147         if (now <= games[gameinx].startTime) revert();
148         if (now >= games[gameinx].endTime) revert();
149         //1000000000000000000=1eth
150         //5000000000000000  = 0.005 ETH
151         if (msg.value<5000000000000000 || msg.value>1000000000000000000000000000) revert();
152         if (games[gameinx].amount > 99999999999999999999999999999999999999999999999999999999) revert();
153 
154         games[gameinx].options[optioninx].players[games[gameinx].options[optioninx].numPlayers++] = Player({addr: msg.sender, amount: msg.value, profit:0});
155         games[gameinx].options[optioninx].amount = games[gameinx].options[optioninx].amount.add(msg.value);
156         games[gameinx].options[optioninx].playeramounts[msg.sender] = games[gameinx].options[optioninx].playeramounts[msg.sender].add(msg.value);
157         games[gameinx].amount = games[gameinx].amount.add(msg.value);
158     }
159 
160     function setWinner(uint gameinx,bytes32 gameName, uint optioninx, uint optionid, bytes32 optionName) public returns(bool res) {
161         if (owner != msg.sender) revert();
162         if ((now <= games[gameinx].openTime)||(games[gameinx].runingStatus>1)) revert();
163         if (gameName != games[gameinx].gameName) revert();
164         if (games[gameinx].options[optioninx].optionName != optionName) revert();
165         if (games[gameinx].options[optioninx].optionid != optionid) revert();
166 
167         games[gameinx].winner = optioninx;
168         games[gameinx].runingStatus = 2;
169         safeWithdrawal(gameinx);
170         return true;
171     }
172 
173     function safeWithdrawal(uint gameid) private {
174         
175         if ((gameid<0)||(gameid>999999999999999999999999999999999999)) revert();
176         if (now <= games[gameid].openTime) revert();
177         if (games[gameid].runingStatus != 2) revert();
178 
179         uint winnerID = games[gameid].winner;
180         if (winnerID >0 && winnerID < 9999) {
181             
182             games[gameid].runingStatus = 3;
183             uint totalWinpool = games[gameid].options[winnerID].amount;
184             totalWinpool = games[gameid].amount.sub(totalWinpool);
185             //Calculate Fee
186             uint fee = totalWinpool.mul(15);
187             fee = fee.div(1000);
188             uint reward=totalWinpool.sub(fee);
189             //1000000000000000000=1eth
190             if(games[gameid].options[winnerID].amount<100000000000){
191                 gameDeveloper.transfer(reward);
192             }
193             else{
194                 uint ratio = reward.mul(100);
195                 ratio = ratio.div(games[gameid].options[winnerID].amount); //safe????
196                 uint totalReturn = 0;
197                 for(uint i = 0; i < games[gameid].options[winnerID].numPlayers; i++) {
198                     uint returnWinAmount = games[gameid].options[winnerID].players[i].amount.mul(ratio);
199                     returnWinAmount = returnWinAmount.div(100);
200                     returnWinAmount = games[gameid].options[winnerID].players[i].amount.add(returnWinAmount);
201                     games[gameid].options[winnerID].players[i].addr.transfer(returnWinAmount);
202                     games[gameid].options[winnerID].players[i].profit = returnWinAmount;
203                     totalReturn = totalReturn.add(returnWinAmount);
204                 }  
205                 uint totalFee = games[gameid].amount.sub(totalReturn);
206                 gameDeveloper.transfer(totalFee);
207             }
208         }
209     } 
210 
211 }