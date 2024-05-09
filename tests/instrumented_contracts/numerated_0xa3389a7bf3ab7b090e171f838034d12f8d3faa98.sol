1 pragma solidity ^0.5.7;
2 
3 contract WhoWillDieFirstInGoTs8 {
4     
5     uint8 public constant Withdraw = 0;
6     uint8 public constant firstHero = 1;
7     uint8 public constant lastHero = 38;
8     uint8 public constant ArraySize = lastHero + 1;
9 /*
10 EuronGreyjoy = 1;
11 CerseiLannister = 2;
12 LordVarys = 3;
13 JorahMormont = 4;
14 BericDondarrion = 5;
15 Melisandre = 6;
16 JaimeLannister = 7;
17 TheHound = 8;
18 DaenerysTargaryen = 9;
19 GreyWorm = 10;
20 TheonGreyjoy = 11;
21 TyrionLannister = 12;
22 PodrickPayne = 14;
23 BrienneOfTarth = 15;
24 BronnOfTheBlackwater = 16;
25 AryaStark = 17;
26 JonSnow = 18;
27 Gendry = 19;
28 BranStark = 20;
29 Gilly = 21;
30 SamwellTarly = 22;
31 SansaStark = 13;
32 YaraGreyjoy = 23;
33 Drogon = 24;
34 EddisonTollett = 25;
35 EdmureTully = 26;
36 GregorClegane = 27;
37 HotPie = 28;
38 LyannaMormont = 29;
39 Rhaegal = 30;
40 RobinArryn = 31;
41 DavosSeaworth = 32;
42 YohnRoyce = 33;
43 Missandei = 34;
44 TheNightKing = 35;
45 TormundGiantsbane = 36;
46 DaarioNaharis = 37;
47 JaqunH’ghar = 38;
48 */
49     mapping(address => bool) sith;
50     mapping(address => uint256[ArraySize]) public bets;
51     uint256[ArraySize] public betAmount;
52     uint256[ArraySize] public playerCount;
53     uint256 public resultWin = 0;
54     uint256 public winRatio;
55     uint256 constant minBet = 0.001 ether;
56     uint256 constant RR = 100000000000000;
57     uint256 sithCount;
58     uint256 public likeDAPP;
59     bool public endBetting = false;
60     bool public startPayment = false;
61     bool public onPause = false;
62     address payable Martin;
63     address payable George;
64     
65     event Bet(address indexed _who, uint8 _hero, uint256 amount);
66     
67     modifier onlySiths {
68         require(sith[msg.sender] == true);
69         _;
70     }
71 
72     constructor(address payable _M, address payable _G) public {
73         Martin = _M;
74         George = _G;
75         sith[msg.sender] = true;
76         sithCount++;
77     }
78 
79     function like() external {
80         likeDAPP++;
81     }
82 
83     function dislike() external {
84         if (likeDAPP > 0) {
85             likeDAPP--;
86         }
87     }
88 
89     function setBet(uint8 _hero) external payable {
90         require(onPause == false);
91         require(msg.value >= minBet);
92         require(endBetting == false);
93         require(_hero >= firstHero || _hero <= lastHero);
94         if (bets[msg.sender][_hero] == 0) {
95             playerCount[_hero]++;
96         }
97         bets[msg.sender][_hero] += msg.value;
98         betAmount[_hero] += msg.value;
99         emit Bet(msg.sender, _hero, msg.value);
100 
101     }
102 
103     function getProfit(address payable _winer) external {
104         require(startPayment == true);
105         if (resultWin == Withdraw) {
106             uint256 retValue;
107             for(uint256 i = firstHero; i <= lastHero; i++) {
108                 uint256 bet = bets[_winer][i];
109                 if (bet > 0) {
110                     bets[_winer][i] = 0;
111                     retValue += bet;
112                 }
113             }
114             if (retValue > 0) {
115                 _winer.transfer(retValue); 
116             }
117             return;
118         } else {
119             uint256 winersBet = bets[_winer][resultWin];
120             require(winersBet > 0);
121             bets[_winer][resultWin] = 0;
122             playerCount[resultWin]--;
123             _winer.transfer(winersBet + winersBet * winRatio / RR);
124         }
125     }
126 
127     function getStatistics() external view returns (uint256[2 * ArraySize] memory) {
128         uint256[2 * ArraySize] memory output;
129         for(uint256 i = firstHero; i <= lastHero; i++) {
130             output[i] = betAmount[i];
131             output[i + ArraySize] = playerCount[i];
132         }
133         return output;
134     }
135 
136     function getPlayerStatistics(address _player) external view returns (uint256[ArraySize] memory) {
137         uint256[ArraySize] memory output;
138         for(uint256 i = firstHero; i <= lastHero; i++) {
139             output[i] = bets[_player][i];
140         }
141         return output;
142     }
143     
144     function endBetPeriod() external onlySiths {
145         endBetting = true;
146     }
147 
148     function setResult(uint32 _result) external onlySiths {
149         require(_result >=  firstHero || _result <= lastHero);
150         require(startPayment == false);
151         if (betAmount[_result] == 0) {
152             startWithdraw();
153             return;
154         }
155         uint256 donation = (address(this).balance - betAmount[_result]) / 10;
156         Martin.transfer(donation / 2);
157         George.transfer(donation / 2);
158         uint256 totalBets = (address(this).balance - betAmount[_result]);
159         winRatio = totalBets * RR / betAmount[_result];
160         resultWin = _result;
161         startPayment = true;
162         if (endBetting != true) {
163             endBetting = true;
164         }
165     }
166 
167     function startWithdraw() public onlySiths {
168         require(startPayment == false);
169         startPayment = true;
170         if (endBetting != true) {
171             endBetting = true;
172         }
173         if (resultWin != Withdraw) {
174             resultWin = Withdraw;
175         }
176     }
177 
178     function pauseOn() external onlySiths {
179         onPause = true;
180     }
181 
182     function pauseOff() external onlySiths {
183         onPause = false;
184     }
185 
186     function clearBlockchain() external {
187         require(startPayment && endBetting);
188         if (resultWin == Withdraw) {
189             require(address(this).balance < minBet);
190             selfdestruct(msg.sender);
191         } else {
192             require(playerCount[resultWin] == 0);
193             selfdestruct(msg.sender);
194         }
195     }
196 
197     function addSith(address _sith) external onlySiths {
198         sith[_sith] = true;
199         sithCount++;
200     }
201 
202     function delSith(address _sith) external onlySiths {
203         require(sithCount >= 2);
204         sith[_sith] = false;
205         sithCount--;
206     }
207 }