1 contract Etheropt {
2 
3   struct Option {
4     int strike;
5   }
6   struct Position {
7     mapping(uint => int) positions;
8     int cash;
9     bool expired;
10     bool hasPosition;
11   }
12   struct OptionChain {
13     uint expiration;
14     string underlying;
15     uint margin;
16     uint realityID;
17     bytes32 factHash;
18     address ethAddr;
19     mapping(uint => Option) options;
20     uint numOptions;
21     bool expired;
22     mapping(address => Position) positions;
23     uint numPositions;
24     uint numPositionsExpired;
25   }
26   mapping(uint => OptionChain) optionChains;
27   uint numOptionChains;
28   struct Account {
29     address user;
30     int capital;
31   }
32   mapping(bytes32 => int) orderFills; //keeps track of cumulative order fills
33   struct MarketMaker {
34     address user;
35     string server;
36   }
37   mapping(uint => MarketMaker) marketMakers; //starts at 1
38   uint public numMarketMakers = 0;
39   mapping(address => uint) marketMakerIDs;
40   mapping(uint => Account) accounts;
41   uint public numAccounts;
42   mapping(address => uint) accountIDs; //starts at 1
43 
44   function Market() {
45   }
46 
47   function getAccountID(address user) constant returns(uint) {
48     return accountIDs[user];
49   }
50 
51   function getAccount(uint accountID) constant returns(address) {
52     return accounts[accountID].user;
53   }
54 
55   function addFunds() {
56     if (accountIDs[msg.sender]>0) {
57       accounts[accountIDs[msg.sender]].capital += int(msg.value);
58     } else {
59       uint accountID = ++numAccounts;
60       accounts[accountID].user = msg.sender;
61       accounts[accountID].capital += int(msg.value);
62       accountIDs[msg.sender] = accountID;
63     }
64   }
65 
66   function withdrawFunds(uint amount) {
67     if (accountIDs[msg.sender]>0) {
68       if (int(amount)<=getFunds(msg.sender, true) && int(amount)>0) {
69         accounts[accountIDs[msg.sender]].capital -= int(amount);
70         msg.sender.send(amount);
71       }
72     }
73   }
74 
75   function getFunds(address user, bool onlyAvailable) constant returns(int) {
76     if (accountIDs[user]>0) {
77       if (onlyAvailable == false) {
78         return accounts[accountIDs[user]].capital;
79       } else {
80         return accounts[accountIDs[user]].capital + getMaxLossAfterTrade(user, 0, 0, 0, 0);
81       }
82     } else {
83       return 0;
84     }
85   }
86 
87   function getFundsAndAvailable(address user) constant returns(int, int) {
88     return (getFunds(user, false), getFunds(user, true));
89   }
90 
91   function marketMaker(string server) {
92     if (msg.value>0) throw;
93     if (marketMakerIDs[msg.sender]>0) {
94       marketMakers[marketMakerIDs[msg.sender]].server = server;
95     } else {
96       int funds = getFunds(marketMakers[i].user, false);
97       uint marketMakerID = 0;
98       if (numMarketMakers<6) {
99         marketMakerID = ++numMarketMakers;
100       } else {
101         for (uint i=2; i<=numMarketMakers; i++) {
102           if (getFunds(marketMakers[i].user, false)<=funds && (marketMakerID==0 || getFunds(marketMakers[i].user, false)<getFunds(marketMakers[marketMakerID].user, false))) {
103             marketMakerID = i;
104           }
105         }
106       }
107       if (marketMakerID>0) {
108         marketMakerIDs[marketMakers[marketMakerID].user] = 0;
109         marketMakers[marketMakerID].user = msg.sender;
110         marketMakers[marketMakerID].server = server;
111         marketMakerIDs[msg.sender] = marketMakerID;
112       } else {
113         throw;
114       }
115     }
116   }
117 
118   function getMarketMakers() constant returns(string, string, string, string, string, string) {
119     string[] memory servers = new string[](6);
120     for (uint i=1; i<=numMarketMakers; i++) {
121       servers[i-1] = marketMakers[i].server;
122     }
123     return (servers[0], servers[1], servers[2], servers[3], servers[4], servers[5]);
124   }
125 
126   function getMarketMakerFunds() constant returns(int, int, int, int, int, int) {
127     int[] memory funds = new int[](6);
128     for (uint i=1; i<=numMarketMakers; i++) {
129       funds[i-1] = getFunds(marketMakers[i].user, false);
130     }
131     return (funds[0], funds[1], funds[2], funds[3], funds[4], funds[5]);
132   }
133 
134   function getOptionChain(uint optionChainID) constant returns (uint, string, uint, uint, bytes32, address) {
135     return (optionChains[optionChainID].expiration, optionChains[optionChainID].underlying, optionChains[optionChainID].margin, optionChains[optionChainID].realityID, optionChains[optionChainID].factHash, optionChains[optionChainID].ethAddr);
136   }
137 
138   function getMarket(address user) constant returns(uint[], int[], int[], int[]) {
139     uint[] memory optionIDs = new uint[](60);
140     int[] memory strikes = new int[](60);
141     int[] memory positions = new int[](60);
142     int[] memory cashes = new int[](60);
143     uint z = 0;
144     for (int optionChainID=int(numOptionChains)-1; optionChainID>=0 && z<60; optionChainID--) {
145       if (optionChains[uint(optionChainID)].expired == false) {
146         for (uint optionID=0; optionID<optionChains[uint(optionChainID)].numOptions; optionID++) {
147           optionIDs[z] = uint(optionChainID)*1000 + optionID;
148           strikes[z] = optionChains[uint(optionChainID)].options[optionID].strike;
149           positions[z] = optionChains[uint(optionChainID)].positions[user].positions[optionID];
150           cashes[z] = optionChains[uint(optionChainID)].positions[user].cash;
151           z++;
152         }
153       }
154     }
155     return (optionIDs, strikes, positions, cashes);
156   }
157 
158   function expire(uint accountID, uint optionChainID, uint8 v, bytes32 r, bytes32 s, bytes32 value) {
159     if (optionChains[optionChainID].expired == false) {
160       if (ecrecover(sha3(optionChains[optionChainID].factHash, value), v, r, s) == optionChains[optionChainID].ethAddr) {
161         uint lastAccount = numAccounts;
162         if (accountID==0) {
163           accountID = 1;
164         } else {
165           lastAccount = accountID;
166         }
167         for (accountID=accountID; accountID<=lastAccount; accountID++) {
168           if (optionChains[optionChainID].positions[accounts[accountID].user].expired == false) {
169             int result = optionChains[optionChainID].positions[accounts[accountID].user].cash / 1000000000000000000;
170             for (uint optionID=0; optionID<optionChains[optionChainID].numOptions; optionID++) {
171               int moneyness = getMoneyness(optionChains[optionChainID].options[optionID].strike, uint(value), optionChains[optionChainID].margin);
172               result += moneyness * optionChains[optionChainID].positions[accounts[accountID].user].positions[optionID] / 1000000000000000000;
173             }
174             accounts[accountID].capital = accounts[accountID].capital + result;
175             optionChains[optionChainID].positions[accounts[accountID].user].expired = true;
176             optionChains[optionChainID].numPositionsExpired++;
177           }
178         }
179         if (optionChains[optionChainID].numPositionsExpired == optionChains[optionChainID].numPositions) {
180           optionChains[optionChainID].expired = true;
181         }
182       }
183     }
184   }
185 
186   function getMoneyness(int strike, uint settlement, uint margin) constant returns(int) {
187     if (strike>=0) { //call
188       if (settlement>uint(strike)) {
189         if (settlement-uint(strike)<margin) {
190           return int(settlement-uint(strike));
191         } else {
192           return int(margin);
193         }
194       } else {
195         return 0;
196       }
197     } else { //put
198       if (settlement<uint(-strike)) {
199         if (uint(-strike)-settlement<margin) {
200           return int(uint(-strike)-settlement);
201         } else {
202           return int(margin);
203         }
204       } else {
205         return 0;
206       }
207     }
208   }
209 
210   function addOptionChain(uint expiration, string underlying, uint margin, uint realityID, bytes32 factHash, address ethAddr, int[] strikes) {
211     uint optionChainID = 6;
212     if (numOptionChains<6) {
213       optionChainID = numOptionChains++;
214     } else {
215       for (uint i=0; i < numOptionChains && optionChainID>=6; i++) {
216         if (optionChains[i].expired==true || optionChains[i].numPositions==0 || optionChains[i].numOptions==0) {
217           optionChainID = i;
218         }
219       }
220     }
221     if (optionChainID<6) {
222       delete optionChains[optionChainID];
223       optionChains[optionChainID].expiration = expiration;
224       optionChains[optionChainID].underlying = underlying;
225       optionChains[optionChainID].margin = margin;
226       optionChains[optionChainID].realityID = realityID;
227       optionChains[optionChainID].factHash = factHash;
228       optionChains[optionChainID].ethAddr = ethAddr;
229       for (i=0; i < strikes.length; i++) {
230         if (optionChains[optionChainID].numOptions<10) {
231           uint optionID = optionChains[optionChainID].numOptions++;
232           Option option = optionChains[optionChainID].options[i];
233           option.strike = strikes[i];
234           optionChains[optionChainID].options[i] = option;
235         }
236       }
237     }
238   }
239 
240   function orderMatchTest(uint optionChainID, uint optionID, uint price, int size, uint orderID, uint blockExpires, address addr, address sender, int matchSize) constant returns(bool) {
241     if (block.number<=blockExpires && ((size>0 && matchSize<0 && orderFills[sha3(optionChainID, optionID, price, size, orderID, blockExpires)]-matchSize<=size) || (size<0 && matchSize>0 && orderFills[sha3(optionChainID, optionID, price, size, orderID, blockExpires)]-matchSize>=size)) && getFunds(addr, false)+getMaxLossAfterTrade(addr, optionChainID, optionID, -matchSize, matchSize * int(price))>0 && getFunds(sender, false)+getMaxLossAfterTrade(sender, optionChainID, optionID, matchSize, -matchSize * int(price))>0) {
242       return true;
243     }
244     return false;
245   }
246 
247   function orderMatch(uint optionChainID, uint optionID, uint price, int size, uint orderID, uint blockExpires, address addr, uint8 v, bytes32 r, bytes32 s, int matchSize) {
248     bytes32 hash = sha256(optionChainID, optionID, price, size, orderID, blockExpires);
249     if (ecrecover(hash, v, r, s) == addr && block.number<=blockExpires && ((size>0 && matchSize<0 && orderFills[hash]-matchSize<=size) || (size<0 && matchSize>0 && orderFills[hash]-matchSize>=size)) && getFunds(addr, false)+getMaxLossAfterTrade(addr, optionChainID, optionID, -matchSize, matchSize * int(price))>0 && getFunds(msg.sender, false)+getMaxLossAfterTrade(msg.sender, optionChainID, optionID, matchSize, -matchSize * int(price))>0) {
250       if (optionChains[optionChainID].positions[msg.sender].hasPosition == false) {
251         optionChains[optionChainID].positions[msg.sender].hasPosition = true;
252         optionChains[optionChainID].numPositions++;
253       }
254       if (optionChains[optionChainID].positions[addr].hasPosition == false) {
255         optionChains[optionChainID].positions[addr].hasPosition = true;
256         optionChains[optionChainID].numPositions++;
257       }
258       optionChains[optionChainID].positions[msg.sender].positions[optionID] += matchSize;
259       optionChains[optionChainID].positions[msg.sender].cash -= matchSize * int(price);
260       optionChains[optionChainID].positions[addr].positions[optionID] -= matchSize;
261       optionChains[optionChainID].positions[addr].cash += matchSize * int(price);
262       orderFills[hash] -= matchSize;
263     }
264   }
265 
266   function getMaxLossAfterTrade(address user, uint optionChainID, uint optionID, int positionChange, int cashChange) constant returns(int) {
267     int totalMaxLoss = 0;
268     for (uint i=0; i<numOptionChains; i++) {
269       if (optionChains[i].positions[user].expired == false && optionChains[i].numOptions>0) {
270         bool maxLossInitialized = false;
271         int maxLoss = 0;
272         for (uint s=0; s<optionChains[i].numOptions; s++) {
273           int pnl = optionChains[i].positions[user].cash / 1000000000000000000;
274           if (i==optionChainID) {
275             pnl += cashChange / 1000000000000000000;
276           }
277           uint settlement = 0;
278           if (optionChains[i].options[s].strike<0) {
279             settlement = uint(-optionChains[i].options[s].strike);
280           } else {
281             settlement = uint(optionChains[i].options[s].strike);
282           }
283           pnl += moneySumAtSettlement(user, optionChainID, optionID, positionChange, i, settlement);
284           if (pnl<maxLoss || maxLossInitialized==false) {
285             maxLossInitialized = true;
286             maxLoss = pnl;
287           }
288           pnl = optionChains[i].positions[user].cash / 1000000000000000000;
289           if (i==optionChainID) {
290             pnl += cashChange / 1000000000000000000;
291           }
292           settlement = 0;
293           if (optionChains[i].options[s].strike<0) {
294             if (uint(-optionChains[i].options[s].strike)>optionChains[i].margin) {
295               settlement = uint(-optionChains[i].options[s].strike)-optionChains[i].margin;
296             } else {
297               settlement = 0;
298             }
299           } else {
300             settlement = uint(optionChains[i].options[s].strike)+optionChains[i].margin;
301           }
302           pnl += moneySumAtSettlement(user, optionChainID, optionID, positionChange, i, settlement);
303           if (pnl<maxLoss) {
304             maxLoss = pnl;
305           }
306         }
307         totalMaxLoss += maxLoss;
308       }
309     }
310     return totalMaxLoss;
311   }
312 
313   function moneySumAtSettlement(address user, uint optionChainID, uint optionID, int positionChange, uint i, uint settlement) internal returns(int) {
314     int pnl = 0;
315     for (uint j=0; j<optionChains[i].numOptions; j++) {
316       pnl += optionChains[i].positions[user].positions[j] * getMoneyness(optionChains[i].options[j].strike, settlement, optionChains[i].margin) / 1000000000000000000;
317       if (i==optionChainID && j==optionID) {
318         pnl += positionChange * getMoneyness(optionChains[i].options[j].strike, settlement, optionChains[i].margin) / 1000000000000000000;
319       }
320     }
321     return pnl;
322   }
323 
324   function min(uint a, uint b) constant returns(uint) {
325     if (a<b) {
326       return a;
327     } else {
328       return b;
329     }
330   }
331 }