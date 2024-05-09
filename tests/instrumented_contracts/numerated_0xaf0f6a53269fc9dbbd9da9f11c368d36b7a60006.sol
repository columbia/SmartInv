1 //last compiled with soljson-v0.3.5-2016-07-21-6610add
2 
3 contract Etheropt {
4 
5   struct Position {
6     mapping(uint => int) positions;
7     int cash;
8     bool expired;
9     bool hasPosition;
10   }
11   uint public expiration;
12   string public underlying;
13   uint public margin;
14   uint public realityID;
15   bytes32 public factHash;
16   address public ethAddr;
17   mapping(uint => int) options;
18   uint public numOptions;
19   bool public expired;
20   mapping(address => Position) positions;
21   uint public numPositions;
22   uint public numPositionsExpired;
23   struct Account {
24     address user;
25     int capital;
26   }
27   mapping(bytes32 => int) orderFills; //keeps track of cumulative order fills
28   struct MarketMaker {
29     address user;
30     string server;
31   }
32   mapping(uint => MarketMaker) marketMakers; //starts at 1
33   uint public numMarketMakers = 0;
34   mapping(address => uint) marketMakerIDs;
35   mapping(uint => Account) accounts;
36   uint public numAccounts;
37   mapping(address => uint) accountIDs; //starts at 1
38 
39   //events
40   event Deposit(address indexed user, uint amount, int balance); //balance is balance after deposit
41   event Withdraw(address indexed user, uint amount, int balance); //balance is balance after withdraw
42   event NewMarketMaker(address indexed user, string server);
43   event Expire(address indexed caller, address indexed user); //user is the account that was expired
44   event OrderMatchFailure(address indexed matchUser, int matchSize, address indexed orderUser, int orderSize, uint optionID, uint price);
45   event OrderMatch(address indexed matchUser, int matchSize, address indexed orderUser, int orderSize, uint optionID, uint price);
46 
47   function Etheropt(uint expiration_, string underlying_, uint margin_, uint realityID_, bytes32 factHash_, address ethAddr_, int[] strikes_) {
48     expiration = expiration_;
49     underlying = underlying_;
50     margin = margin_;
51     realityID = realityID_;
52     factHash = factHash_;
53     ethAddr = ethAddr_;
54     for (uint i=0; i < strikes_.length; i++) {
55       if (numOptions<20) {
56         uint optionID = numOptions++;
57         options[optionID] = strikes_[i];
58       }
59     }
60   }
61 
62   function getAccountID(address user) constant returns(uint) {
63     return accountIDs[user];
64   }
65 
66   function getAccount(uint accountID) constant returns(address) {
67     return accounts[accountID].user;
68   }
69 
70   function addFunds() {
71     if (accountIDs[msg.sender]>0) {
72       accounts[accountIDs[msg.sender]].capital += int(msg.value);
73     } else {
74       uint accountID = ++numAccounts;
75       accounts[accountID].user = msg.sender;
76       accounts[accountID].capital += int(msg.value);
77       accountIDs[msg.sender] = accountID;
78     }
79     Deposit(msg.sender, msg.value, accounts[accountIDs[msg.sender]].capital);
80   }
81 
82   function withdrawFunds(uint amount) {
83     if (accountIDs[msg.sender]>0) {
84       if (int(amount)<=getFunds(msg.sender, true) && int(amount)>0) {
85         accounts[accountIDs[msg.sender]].capital -= int(amount);
86         msg.sender.call.value(amount)();
87         Withdraw(msg.sender, amount, accounts[accountIDs[msg.sender]].capital);
88       }
89     }
90   }
91 
92   function getFunds(address user, bool onlyAvailable) constant returns(int) {
93     if (accountIDs[user]>0) {
94       if (onlyAvailable == false) {
95         return accounts[accountIDs[user]].capital;
96       } else {
97         return accounts[accountIDs[user]].capital + getMaxLossAfterTrade(user, 0, 0, 0);
98       }
99     } else {
100       return 0;
101     }
102   }
103 
104   function getFundsAndAvailable(address user) constant returns(int, int) {
105     return (getFunds(user, false), getFunds(user, true));
106   }
107 
108   function marketMaker(string server) {
109     if (msg.value>0) throw;
110     if (marketMakerIDs[msg.sender]>0) {
111       marketMakers[marketMakerIDs[msg.sender]].server = server;
112     } else {
113       int funds = getFunds(marketMakers[i].user, false);
114       uint marketMakerID = 0;
115       if (numMarketMakers<6) {
116         marketMakerID = ++numMarketMakers;
117       } else {
118         for (uint i=2; i<=numMarketMakers; i++) {
119           if (getFunds(marketMakers[i].user, false)<=funds && (marketMakerID==0 || getFunds(marketMakers[i].user, false)<getFunds(marketMakers[marketMakerID].user, false))) {
120             marketMakerID = i;
121           }
122         }
123       }
124       if (marketMakerID>0) {
125         marketMakerIDs[marketMakers[marketMakerID].user] = 0;
126         marketMakers[marketMakerID].user = msg.sender;
127         marketMakers[marketMakerID].server = server;
128         marketMakerIDs[msg.sender] = marketMakerID;
129         NewMarketMaker(msg.sender, server);
130       } else {
131         throw;
132       }
133     }
134   }
135 
136   function getMarketMakers() constant returns(string, string, string, string, string, string) {
137     string[] memory servers = new string[](6);
138     for (uint i=1; i<=numMarketMakers; i++) {
139       servers[i-1] = marketMakers[i].server;
140     }
141     return (servers[0], servers[1], servers[2], servers[3], servers[4], servers[5]);
142   }
143 
144   function getMarketMakerFunds() constant returns(int, int, int, int, int, int) {
145     int[] memory funds = new int[](6);
146     for (uint i=1; i<=numMarketMakers; i++) {
147       funds[i-1] = getFunds(marketMakers[i].user, false);
148     }
149     return (funds[0], funds[1], funds[2], funds[3], funds[4], funds[5]);
150   }
151 
152   function getOptionChain() constant returns (uint, string, uint, uint, bytes32, address) {
153     return (expiration, underlying, margin, realityID, factHash, ethAddr);
154   }
155 
156   function getMarket(address user) constant returns(uint[], int[], int[], int[]) {
157     uint[] memory optionIDs = new uint[](20);
158     int[] memory strikes_ = new int[](20);
159     int[] memory positions_ = new int[](20);
160     int[] memory cashes = new int[](20);
161     uint z = 0;
162     if (expired == false) {
163       for (uint optionID=0; optionID<numOptions; optionID++) {
164         optionIDs[z] = optionID;
165         strikes_[z] = options[optionID];
166         positions_[z] = positions[user].positions[optionID];
167         cashes[z] = positions[user].cash;
168         z++;
169       }
170     }
171     return (optionIDs, strikes_, positions_, cashes);
172   }
173 
174   function expire(uint accountID, uint8 v, bytes32 r, bytes32 s, bytes32 value) {
175     if (expired == false) {
176       if (ecrecover(sha3(factHash, value), v, r, s) == ethAddr) {
177         uint lastAccount = numAccounts;
178         if (accountID==0) {
179           accountID = 1;
180         } else {
181           lastAccount = accountID;
182         }
183         for (accountID=accountID; accountID<=lastAccount; accountID++) {
184           if (positions[accounts[accountID].user].expired == false) {
185             int result = positions[accounts[accountID].user].cash / 1000000000000000000;
186             for (uint optionID=0; optionID<numOptions; optionID++) {
187               int moneyness = getMoneyness(options[optionID], uint(value), margin);
188               result += moneyness * positions[accounts[accountID].user].positions[optionID] / 1000000000000000000;
189             }
190             positions[accounts[accountID].user].expired = true;
191             uint amountToSend = uint(accounts[accountID].capital + result);
192             accounts[accountID].capital = 0;
193             if (positions[accounts[accountID].user].hasPosition==true) {
194               numPositionsExpired++;
195             }
196             accounts[accountID].user.call.value(amountToSend)();
197             Expire(msg.sender, accounts[accountID].user);
198           }
199         }
200         if (numPositionsExpired == numPositions) {
201           expired = true;
202         }
203       }
204     }
205   }
206 
207   function getMoneyness(int strike, uint settlement, uint margin) constant returns(int) {
208     if (strike>=0) { //call
209       if (settlement>uint(strike)) {
210         if (settlement-uint(strike)<margin) {
211           return int(settlement-uint(strike));
212         } else {
213           return int(margin);
214         }
215       } else {
216         return 0;
217       }
218     } else { //put
219       if (settlement<uint(-strike)) {
220         if (uint(-strike)-settlement<margin) {
221           return int(uint(-strike)-settlement);
222         } else {
223           return int(margin);
224         }
225       } else {
226         return 0;
227       }
228     }
229   }
230 
231   function orderMatchTest(uint optionID, uint price, int size, uint orderID, uint blockExpires, address addr, address sender, uint value, int matchSize) constant returns(bool) {
232     if (block.number<=blockExpires && ((size>0 && matchSize<0 && orderFills[sha3(optionID, price, size, orderID, blockExpires)]-matchSize<=size) || (size<0 && matchSize>0 && orderFills[sha3(optionID, price, size, orderID, blockExpires)]-matchSize>=size)) && getFunds(addr, false)+getMaxLossAfterTrade(addr, optionID, -matchSize, matchSize * int(price))>0 && getFunds(sender, false)+int(value)+getMaxLossAfterTrade(sender, optionID, matchSize, -matchSize * int(price))>0) {
233       return true;
234     }
235     return false;
236   }
237 
238   function orderMatch(uint optionID, uint price, int size, uint orderID, uint blockExpires, address addr, uint8 v, bytes32 r, bytes32 s, int matchSize) {
239     addFunds();
240     bytes32 hash = sha256(optionID, price, size, orderID, blockExpires);
241     if (ecrecover(hash, v, r, s) == addr && block.number<=blockExpires && ((size>0 && matchSize<0 && orderFills[hash]-matchSize<=size) || (size<0 && matchSize>0 && orderFills[hash]-matchSize>=size)) && getFunds(addr, false)+getMaxLossAfterTrade(addr, optionID, -matchSize, matchSize * int(price))>0 && getFunds(msg.sender, false)+getMaxLossAfterTrade(msg.sender, optionID, matchSize, -matchSize * int(price))>0) {
242       if (positions[msg.sender].hasPosition == false) {
243         positions[msg.sender].hasPosition = true;
244         numPositions++;
245       }
246       if (positions[addr].hasPosition == false) {
247         positions[addr].hasPosition = true;
248         numPositions++;
249       }
250       positions[msg.sender].positions[optionID] += matchSize;
251       positions[msg.sender].cash -= matchSize * int(price);
252       positions[addr].positions[optionID] -= matchSize;
253       positions[addr].cash += matchSize * int(price);
254       orderFills[hash] -= matchSize;
255       OrderMatch(msg.sender, matchSize, addr, size, optionID, price);
256     } else {
257       OrderMatchFailure(msg.sender, matchSize, addr, size, optionID, price);
258     }
259   }
260 
261   function getMaxLossAfterTrade(address user, uint optionID, int positionChange, int cashChange) constant returns(int) {
262     bool maxLossInitialized = false;
263     int maxLoss = 0;
264     if (positions[user].expired == false && numOptions>0) {
265       for (uint s=0; s<numOptions; s++) {
266         int pnl = positions[user].cash / 1000000000000000000;
267         pnl += cashChange / 1000000000000000000;
268         uint settlement = 0;
269         if (options[s]<0) {
270           settlement = uint(-options[s]);
271         } else {
272           settlement = uint(options[s]);
273         }
274         pnl += moneySumAtSettlement(user, optionID, positionChange, settlement);
275         if (pnl<maxLoss || maxLossInitialized==false) {
276           maxLossInitialized = true;
277           maxLoss = pnl;
278         }
279         pnl = positions[user].cash / 1000000000000000000;
280         pnl += cashChange / 1000000000000000000;
281         settlement = 0;
282         if (options[s]<0) {
283           if (uint(-options[s])>margin) {
284             settlement = uint(-options[s])-margin;
285           } else {
286             settlement = 0;
287           }
288         } else {
289           settlement = uint(options[s])+margin;
290         }
291         pnl += moneySumAtSettlement(user, optionID, positionChange, settlement);
292         if (pnl<maxLoss) {
293           maxLoss = pnl;
294         }
295       }
296     }
297     return maxLoss;
298   }
299 
300   function moneySumAtSettlement(address user, uint optionID, int positionChange, uint settlement) internal returns(int) {
301     int pnl = 0;
302     for (uint j=0; j<numOptions; j++) {
303       pnl += positions[user].positions[j] * getMoneyness(options[j], settlement, margin) / 1000000000000000000;
304       if (j==optionID) {
305         pnl += positionChange * getMoneyness(options[j], settlement, margin) / 1000000000000000000;
306       }
307     }
308     return pnl;
309   }
310 
311   function min(uint a, uint b) constant returns(uint) {
312     if (a<b) {
313       return a;
314     } else {
315       return b;
316     }
317   }
318 }