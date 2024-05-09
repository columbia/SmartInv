1 pragma solidity ^0.4.11;
2 
3 /**
4  * WELCOME: http://cryptobeton.com/
5  * Cryptobeton is a multi-functional platform for working with SmartContract, allowing you to make bets, watch matches and news from the world of cybersport. Staying with us you will be next to the tournaments on CS GO, DOTA2, LOL
6  */
7 contract CryptoBetOn {
8 
9     struct Gamer {
10         address wallet;
11         uint amount;
12     }
13 
14     struct Match {
15         bool bets;
16         uint number;
17         uint winPotA;
18         uint winPotB;
19         uint winPotD;
20         Gamer[] gamersA;
21         Gamer[] gamersD;
22         Gamer[] gamersB;
23     }
24 
25     uint16 constant MATCH_COUNT_LIMIT = 512;
26     uint8 constant HOUSE_EDGE_TOP_BAR = 12;
27     uint8 constant HOUSE_EDGE_BOTTOM_BAR = 1;
28 
29     uint8 constant TX_N01 = 1; // "TX_N01. Not found match by id";
30     uint8 constant TX_N02 = 2; // "TX_N02. Thanks, brother!";
31     uint8 constant TX_N03 = 3; // "TX_N03. The number of matches should not exceed the limit";
32     uint8 constant TX_N04 = 4; // "TX_N04. The percentage of the fee should not exceed the limits";
33     uint8 constant TX_N16 = 16; // "TX_N16. Non-standard situation: We did not receive fees"
34     uint8 constant TX_N17 = 17; // "TX_N17. Abnormal situation: Failed to return some bets back"
35     uint8 constant TX_N18 = 18; // "TX_N18. Abnormal situation: Failed to return some bets back"
36     uint8 constant TX_N19 = 19; // "TX_N19. Match with id already exists";
37 
38     // Fee is 4 percent of win amount
39     uint8 private houseEdge = 3;
40     uint constant JACKPOT_FEE = 1;
41     uint jackpotAmount = 0;
42     address private owner;
43     uint16 matchCount = 0;
44     mapping (uint => Match) matchesMap;
45 
46     modifier onlyowner {
47         require(msg.sender == owner);
48         _;
49     }
50 
51     modifier hasmatch(uint _matchId) {
52         var m = matchesMap[_matchId];
53         if (m.number != 0) {
54             _;
55         } else {
56             TxMessage(_matchId, TX_N01, 0);
57         }
58      }
59 
60     function CryptoBetOn() payable {
61         owner = msg.sender;
62     }
63 
64     event TxMessage(uint _matchId,
65                     uint8 _code,
66                     uint _value);
67 
68     event MatchAdded(uint _matchId,
69                      uint8 _houseEdge,
70                      uint16 _matchCount);
71 
72     event MatchGetted(uint _matchId,
73                       bool _bets,
74                       uint _number,
75                       uint _winPotA,
76                       uint _winPotB);
77 
78     event MatchPayoff(uint _matchId,
79                        uint _winPot,
80                        uint _collectedFees,
81                        uint _jackpotAmount);
82 
83     event MatchAborted(uint _matchId);
84 
85     event BetAccepted(uint _matchId,
86                       uint8 _betState,
87                       address _wallet,
88                       uint _amount,
89                       uint _blockNumber);
90 
91 
92     event CashSaved(uint _amount);
93 
94     event JackpotPayoff(uint _matchId, uint _amount, address _wallet);
95 
96     function() payable {
97         if (msg.value > 0) {
98             TxMessage(0, TX_N02, msg.value);
99         }
100     }
101 
102     function setHouseEdge(uint8 _houseEdge) onlyowner {
103         if (houseEdge < HOUSE_EDGE_BOTTOM_BAR || _houseEdge > HOUSE_EDGE_TOP_BAR) {
104             TxMessage(0, TX_N04, _houseEdge);
105             return;
106         }
107         houseEdge = _houseEdge;
108     }
109 
110     function getHouseEdge() constant returns(uint8) {
111         return houseEdge;
112     }
113 
114     function getOwner() constant returns(address) {
115         return owner;
116     }
117 
118     function getBalance() constant returns (uint) {
119         return this.balance;
120     }
121 
122     function getJackpotAmount() constant returns(uint) {
123         return jackpotAmount;
124     }
125 
126     function getMatchCount() constant returns(uint16) {
127         return matchCount;
128     }
129 
130     function addNewMatch(uint _matchId) private returns(bool) {
131         var m = matchesMap[_matchId];
132         if (m.number != 0) {
133             return true;
134         }
135         if (_matchId == 0) {
136             TxMessage(_matchId, TX_N19, m.number);
137             return false;
138         }
139         if (matchCount >= MATCH_COUNT_LIMIT) {
140             TxMessage(_matchId, TX_N03, matchCount);
141             return false;
142         }
143         matchesMap[_matchId].bets = true;
144         matchesMap[_matchId].number = block.number;
145         matchCount += 1;
146         MatchAdded(_matchId,
147                    houseEdge,
148                    matchCount);
149         return true;
150     }
151 
152     function getMatch(uint _matchId) hasmatch(_matchId) {
153         var m = matchesMap[_matchId];
154         MatchGetted(_matchId,
155                     m.bets,
156                     m.number,
157                     m.winPotA,
158                     m.winPotB);
159     }
160 
161     function betsOff(uint _matchId) onlyowner hasmatch(_matchId) returns (bool) {
162         matchesMap[_matchId].bets = false;
163         return true;
164     }
165 
166     function cashBack(Gamer[] gamers) private returns(uint) {
167         uint amount = 0;
168         for (uint index = 0; index < gamers.length; index++) {
169             if (!gamers[index].wallet.send(gamers[index].amount)) {
170                 amount += gamers[index].amount;
171             }
172         }
173         return amount;
174     }
175 
176     function abortMatch(uint _matchId) onlyowner hasmatch(_matchId) {
177         var m = matchesMap[_matchId]; // TODO whether the data is copied or it is the reference to storage
178         cashBack(m.gamersA);
179         cashBack(m.gamersB);
180         cashBack(m.gamersD);
181         clearMatch(_matchId);
182         MatchAborted(_matchId);
183     }
184 
185     function eraseMatch(uint _matchId) onlyowner hasmatch(_matchId) {
186         clearMatch(_matchId);
187         MatchAborted(_matchId);
188     }
189 
190     function payoutJackpot(uint _matchId, Gamer[] gamers) onlyowner private {
191         uint tmpAmount = 0;
192         address jackpotWinner = 0;
193         uint tmpJackpotAmount = jackpotAmount;
194         jackpotAmount = 0;
195         for (uint pos = 0; pos < gamers.length; pos += 1) {
196             if (gamers[pos].amount > tmpAmount) {
197                 tmpAmount = gamers[pos].amount;
198                 jackpotWinner = gamers[pos].wallet;
199             }
200         }
201         if (jackpotWinner != 0 && jackpotWinner.send(tmpJackpotAmount)) {
202             JackpotPayoff(_matchId, tmpJackpotAmount, jackpotWinner);
203         }
204     }
205 
206     function checkMatchToBeAborted(uint _matchId, uint8 _winner) private returns(bool) {
207         var m = matchesMap[_matchId];
208         if (m.number == 0 || m.bets) {
209             return true;
210         }
211         if ((m.winPotA == 0 && _winner == 0) || (m.winPotD == 0 && _winner == 1) || (m.winPotB == 0 && _winner == 2)) {
212             return true;
213         }
214         if ((m.winPotA == 0 && m.winPotB == 0) || (m.winPotA == 0 && m.winPotD == 0) || (m.winPotB == 0 && m.winPotD == 0)) {
215             return true;
216         }
217         return false;
218     }
219 
220     function payoutMatch(uint _matchId, uint8 _winner, bool _jackpot) onlyowner {
221         // cash back if need abort
222         if (checkMatchToBeAborted(_matchId, _winner)) {
223             abortMatch(_matchId);
224             return;
225         }
226         var m = matchesMap[_matchId];
227         var gamers = m.gamersA;
228         uint winPot = m.winPotA;
229         uint losePot_ = m.winPotB + m.winPotD;
230         if (_winner == 2) {
231             gamers = m.gamersB;
232             winPot = m.winPotB;
233             losePot_ = m.winPotA + m.winPotD;
234         } else if (_winner == 1) {
235             gamers = m.gamersD;
236             winPot = m.winPotD;
237             losePot_ = m.winPotA + m.winPotB;
238         }
239         uint fallbackAmount = 0;
240         uint collectedFees = (losePot_ * houseEdge) / uint(100);
241         uint jackpotFees = (losePot_ * JACKPOT_FEE) / uint(100);
242         uint losePot = losePot_ - collectedFees - jackpotFees;
243         for (uint index = 0; index < gamers.length; index += 1) {
244             uint winAmount = gamers[index].amount + ((gamers[index].amount * losePot) / winPot);
245             if (!gamers[index].wallet.send(winAmount)) {
246                 fallbackAmount += winAmount;
247             }
248         }
249         jackpotAmount += jackpotFees;
250         if (_jackpot) {
251             payoutJackpot(_matchId, gamers);
252         }
253         // pay housecut & reset for next bet
254         if (collectedFees > 0) {
255             if (!owner.send(collectedFees)) {
256                 TxMessage(_matchId, TX_N16, collectedFees);
257                    // There is a manual way of withdrawing money!
258             }
259         }
260         if (fallbackAmount > 0) {
261             if (owner.send(fallbackAmount)) {
262                 TxMessage(_matchId, TX_N17, fallbackAmount);
263             } else {
264                 TxMessage(_matchId, TX_N18, fallbackAmount);
265             }
266         }
267         clearMatch(_matchId);
268         MatchPayoff(_matchId,
269                     losePot,
270                     collectedFees, 
271                     jackpotAmount);
272     }
273 
274     function clearMatch(uint _matchId) private hasmatch(_matchId) {
275         delete matchesMap[_matchId].gamersA;
276         delete matchesMap[_matchId].gamersB;
277         delete matchesMap[_matchId].gamersD;
278         delete matchesMap[_matchId];
279         matchCount--;
280     }
281 
282     function acceptBet(uint _matchId, uint8 _betState) payable {
283         var m = matchesMap[_matchId];
284         if (m.number == 0 ) {
285             require(addNewMatch(_matchId));
286             m = matchesMap[_matchId];
287         }
288         require(m.bets);
289         require(msg.value >= 10 finney); //  && msg.value <= 100 ether
290         if (_betState == 0) {
291             var gamerA = m.gamersA[m.gamersA.length++];
292             gamerA.wallet = msg.sender;
293             gamerA.amount = msg.value;
294             m.winPotA += msg.value;
295         } else if (_betState == 2) {
296             var gamerB = m.gamersB[m.gamersB.length++];
297             gamerB.wallet = msg.sender;
298             gamerB.amount = msg.value;
299             m.winPotB += msg.value;
300         } else if (_betState == 1) {
301             var gamerD = m.gamersD[m.gamersD.length++];
302             gamerD.wallet = msg.sender;
303             gamerD.amount = msg.value;
304             m.winPotD += msg.value;
305         }
306         BetAccepted(_matchId,
307                     _betState,
308                     msg.sender,
309                     msg.value,
310                     block.number);
311     }
312 
313     function saveCash(address _receiver, uint _amount) onlyowner {
314          require(matchCount == 0);
315          require(_amount > 0);
316          require(this.balance > _amount);
317          // send cash
318          if (_receiver.send(_amount)) {
319              // confirm
320              CashSaved(_amount);
321          }
322      }
323 
324     function killContract () onlyowner {
325         require(matchCount == 0);
326         // transfer amount to wallet address
327         selfdestruct(owner);
328     }
329 }