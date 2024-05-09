1 pragma solidity ^0.5.7;
2 /*
3 https://WhoWillRuleWesteros.flybet.online/
4 */
5 contract WhoWillRuleWesterosAtTheEnd {
6     
7     uint8 public constant Withdraw = 0;
8     uint8 public constant firstHero = 1;
9     uint8 public constant lastHero = 49;
10     uint8 public constant ArraySize = lastHero + 1;
11 /*
12 EuronGreyjoy = 1;
13 CerseiLannister = 2;
14 LordVarys = 3;
15 JorahMormont = 4;
16 BericDondarrion = 5;
17 Melisandre = 6;
18 JaimeLannister = 7;
19 TheHound = 8;
20 DaenerysTargaryen = 9;
21 GreyWorm = 10;
22 TheonGreyjoy = 11;
23 TyrionLannister = 12;
24 PodrickPayne = 14;
25 BrienneOfTarth = 15;
26 BronnOfTheBlackwater = 16;
27 AryaStark = 17;
28 JonSnow = 18;
29 Gendry = 19;
30 BranStark = 20;
31 Gilly = 21;
32 SamwellTarly = 22;
33 SansaStark = 13;
34 YaraGreyjoy = 23;
35 Any Child of Cersei = 24;
36 EddisonTollett = 25;
37 EdmureTully = 26;
38 GregorClegane = 27;
39 HotPie = 28;
40 LyannaMormont = 29;
41 Child of Jon Snow & Daenerys Targaryen = 30;
42 RobinArryn = 31;
43 DavosSeaworth = 32;
44 YohnRoyce = 33;
45 Missandei = 34;
46 TheNightKing = 35;
47 TormundGiantsbane = 36;
48 DaarioNaharis = 37;
49 JaqunH’ghar = 38;
50 Catelyn Stark = 39;
51 Ed Sheeran = 40;
52 Ellaria Sand = 41;
53 Hodor = 42;
54 Illyrio Mopatis = 43;
55 Meera Reed = 44;
56 Ned Stark = 45;
57 Petyr Baelish = 46;
58 Qyburn = 47;
59 Stannis Baratheon = 48;
60 The Children Of The Forest = 49;
61 */
62     mapping(address => bool) sith;
63     mapping(address => uint256[ArraySize]) public bets;
64     uint256[ArraySize] public betAmount;
65     uint256[ArraySize] public playerCount;
66     uint256 public resultWin = 0;
67     uint256 public winRatio;
68     uint256 constant minBet = 0.001 ether;
69     uint256 constant RR = 100000000000000;
70     uint256 sithCount;
71     uint256 public likeDAPP;
72     bool public endBetting = false;
73     bool public startPayment = false;
74     bool public onPause = false;
75     address payable Martin;
76     address payable George;
77     
78     event Bet(address indexed _who, uint8 _hero, uint256 amount);
79     
80     modifier onlySiths {
81         require(sith[msg.sender] == true);
82         _;
83     }
84 
85     constructor(address payable _M, address payable _G) public {
86         Martin = _M;
87         George = _G;
88         sith[msg.sender] = true;
89         sithCount++;
90     }
91 
92     function like() external {
93         likeDAPP++;
94     }
95 
96     function dislike() external {
97         if (likeDAPP > 0) {
98             likeDAPP--;
99         }
100     }
101     
102     function getLikes() external view returns (uint256) {
103         return likeDAPP;
104     }
105 
106     function setBet(uint8 _hero) external payable {
107         require(onPause == false);
108         require(msg.value >= minBet);
109         require(endBetting == false);
110         require(_hero >= firstHero || _hero <= lastHero);
111         if (bets[msg.sender][_hero] == 0) {
112             playerCount[_hero]++;
113         }
114         bets[msg.sender][_hero] += msg.value;
115         betAmount[_hero] += msg.value;
116         emit Bet(msg.sender, _hero, msg.value);
117 
118     }
119 
120     function getProfit(address payable _winer) external {
121         require(startPayment == true);
122         if (resultWin == Withdraw) {
123             uint256 retValue;
124             for(uint256 i = firstHero; i <= lastHero; i++) {
125                 uint256 bet = bets[_winer][i];
126                 if (bet > 0) {
127                     bets[_winer][i] = 0;
128                     retValue += bet;
129                 }
130             }
131             if (retValue > 0) {
132                 _winer.transfer(retValue); 
133             }
134             return;
135         } else {
136             uint256 winersBet = bets[_winer][resultWin];
137             require(winersBet > 0);
138             bets[_winer][resultWin] = 0;
139             playerCount[resultWin]--;
140             _winer.transfer(winersBet + winersBet * winRatio / RR);
141         }
142     }
143 
144     function getStatistics() external view returns (uint256[2 * ArraySize] memory) {
145         uint256[2 * ArraySize] memory output;
146         for(uint256 i = firstHero; i <= lastHero; i++) {
147             output[i] = betAmount[i];
148             output[i + ArraySize] = playerCount[i];
149         }
150         return output;
151     }
152 
153     function getPlayerStatistics(address _player) external view returns (uint256[ArraySize] memory) {
154         uint256[ArraySize] memory output;
155         for(uint256 i = firstHero; i <= lastHero; i++) {
156             output[i] = bets[_player][i];
157         }
158         return output;
159     }
160     
161     function endBetPeriod() external onlySiths {
162         endBetting = true;
163     }
164 
165     function setResult(uint32 _result) external onlySiths {
166         require(_result >=  firstHero || _result <= lastHero);
167         require(startPayment == false);
168         if (betAmount[_result] == 0) {
169             startWithdraw();
170             return;
171         }
172         uint256 donation = (address(this).balance - betAmount[_result]) / 10;
173         Martin.transfer(donation / 2);
174         George.transfer(donation / 2);
175         uint256 totalBets = (address(this).balance - betAmount[_result]);
176         winRatio = totalBets * RR / betAmount[_result];
177         resultWin = _result;
178         startPayment = true;
179         if (endBetting != true) {
180             endBetting = true;
181         }
182     }
183 
184     function startWithdraw() public onlySiths {
185         require(startPayment == false);
186         startPayment = true;
187         if (endBetting != true) {
188             endBetting = true;
189         }
190         if (resultWin != Withdraw) {
191             resultWin = Withdraw;
192         }
193     }
194 
195     function pauseOn() external onlySiths {
196         onPause = true;
197     }
198 
199     function pauseOff() external onlySiths {
200         onPause = false;
201     }
202 
203     function clearBlockchain() external {
204         require(startPayment && endBetting);
205         if (resultWin == Withdraw) {
206             require(address(this).balance < minBet);
207             selfdestruct(msg.sender);
208         } else {
209             require(playerCount[resultWin] == 0);
210             selfdestruct(msg.sender);
211         }
212     }
213 
214     function addSith(address _sith) external onlySiths {
215         sith[_sith] = true;
216         sithCount++;
217     }
218 
219     function delSith(address _sith) external onlySiths {
220         require(sithCount >= 2);
221         sith[_sith] = false;
222         sithCount--;
223     }
224 }