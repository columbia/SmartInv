1 pragma solidity ^0.4.24;
2 
3 // SafeMath library
4 library SafeMath {
5   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
6 		uint256 c = _a + _b;
7 		assert(c >= _a);
8 		return c;
9 	}
10 
11 	function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
12 		assert(_a >= _b);
13 		return _a - _b;
14 	}
15 
16 	function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
17     if (_a == 0) {
18      return 0;
19     }
20 		uint256 c = _a * _b;
21 		assert(c / _a == _b);
22 		return c;
23 	}
24 
25   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
26 		return _a / _b;
27 	}
28 }
29 
30 // Contract must have an owner
31 contract Ownable {
32   address public owner;
33 
34   constructor() public {
35     owner = msg.sender;
36   }
37 
38   modifier onlyOwner() {
39     require(msg.sender == owner, "onlyOwner wrong");
40     _;
41   }
42 
43   function setOwner(address _owner) onlyOwner public {
44     owner = _owner;
45   }
46 }
47 
48 interface WTAGameBook {
49   function getPlayerIdByAddress(address _addr) external view returns (uint256);
50   function getPlayerAddressById(uint256 _id) external view returns (address);
51   function getPlayerRefById(uint256 _id) external view returns (uint256);
52   function getGameIdByAddress(address _addr) external view returns (uint256);
53   function getGameAddressById(uint256 _id) external view returns (address);
54   function isAdmin(address _addr) external view returns (bool);
55 }
56 
57 interface WTAGameRun {
58   function getCurrentRoundStartTime() external view returns (uint256);
59   function getCurrentRoundEndTime() external view returns (uint256);
60   function getCurrentRoundWinner() external view returns (uint256);
61 }
62 
63 interface ERC20Token {
64   function transfer(address _to, uint256 _value) external returns (bool);
65   function balanceOf(address _addr) external view returns (uint256);
66   function decimals() external view returns (uint8);
67 }
68 
69 // The WTA Token Pool that stores and handles token information
70 contract WTATokenPool is Ownable {
71   using SafeMath for uint256;
72 
73   uint256 constant private DAY_IN_SECONDS = 86400;
74   string public name = "WTATokenPool V0.5";
75   string public version = "0.5";
76 
77   // various token related stuff
78   struct TokenInfo {
79     ERC20Token token;
80     address addr;
81     uint8 decimals;
82     address payaddr;
83     uint256 bought;
84     uint256 safed;
85     uint256 potted;
86     uint256 price;
87     uint256 buypercent;
88     uint256 potpercent;
89     uint256 lockperiod;
90     uint256 tid;
91     bool active;
92   }
93 
94   // Player's time-locked safe to store tokens
95   struct PlayerSafe {
96     mapping (uint256 => uint256) lockValue;
97     mapping (uint256 => uint256) lockTime;
98     uint256 locks;
99     uint256 withdraws;
100     uint256 withdrawn;
101   }
102 
103   uint256 public tokenNum = 0;
104   mapping (uint256 => TokenInfo) public tokenPool;
105   mapping (address => bool) public tokenInPool;
106 
107   mapping (uint256 => mapping(uint256 => PlayerSafe)) public playerSafes;
108   WTAGameBook public gamebook;
109 
110   event TokenBought(uint256 _tid, uint256 _pid, uint256 _amount);
111   event TokenLocked(uint256 _tid, uint256 _pid, uint256 _amount, uint256 _locktime);
112   event TokenFundPaid(uint256 _tid, address indexed _paddr, uint256 _value);
113   event TokenPotFunded(uint256 _tid, uint256 _amount);
114   event TokenPotWon(uint256 _tid, uint256 _pid, uint256 _amount);
115   event TokenWithdrawn(uint256 _tid, uint256 _pid, uint256 _amount);
116 
117   event InactiveTokenEmptied(uint256 _tid, address indexed _addr, uint256 _amount);
118   event WrongTokenEmptied(address indexed _token, address indexed _addr, uint256 _amount);
119   event WrongEtherEmptied(address indexed _addr, uint256 _amount);
120 
121   // initial tokens
122   // IMPORTANT: price needs to be in Wei per 1 unit of token
123   // IMPORTANT: percent needs to be in %
124   // _tokenAddress: list of token addresses need to be added to the pool at contract creation
125   // _payAddress: list of token owner addresses which receives the payments
126   // _price: list of token prices
127   // _buypercent: list of how much token needs to be allocated to players relative to the listed buying price, in percentage form, for example 200 means 200%
128   // _potpercent: list of how much token needs to be allocated to the pot relative to the listed buying price, in percentage form, for example 40 means 40%
129   // _lockperiod: list of timelock periods for tokens allocated to the players before they can withdraw them, in seconds
130   // _gamebook: the address of the GameBook contract
131   constructor(address[] _tokenAddress, address[] _payAddress, uint256[] _price, uint256[] _buypercent, uint256[] _potpercent, uint256[] _lockperiod, address _gamebook) public {
132     require((_tokenAddress.length == _payAddress.length) && (_payAddress.length == _price.length) && (_price.length == _buypercent.length) && (_buypercent.length == _potpercent.length), "TokenPool constructor wrong");
133     tokenNum = _tokenAddress.length;
134     for (uint256 i = 0; i < tokenNum; i++) {
135       tokenPool[i].token = ERC20Token(_tokenAddress[i]);
136       tokenPool[i].addr = _tokenAddress[i];
137       tokenPool[i].decimals = tokenPool[i].token.decimals();
138       tokenPool[i].payaddr = _payAddress[i];
139       tokenPool[i].bought = 0;
140       tokenPool[i].safed = 0;
141       tokenPool[i].potted = 0;
142       tokenPool[i].price = _price[i];
143       tokenPool[i].buypercent = _buypercent[i];
144       tokenPool[i].potpercent = _potpercent[i];
145       tokenPool[i].lockperiod = _lockperiod[i];
146       tokenPool[i].tid = i;
147       tokenPool[i].active = true;
148       tokenInPool[_tokenAddress[i]] = true;
149     }
150     gamebook = WTAGameBook(_gamebook);
151   }
152 
153   modifier isAdmin() {
154     require(gamebook.isAdmin(msg.sender), "isAdmin wrong");
155     _;
156   }
157 
158   modifier isGame() {
159     require(gamebook.getGameIdByAddress(msg.sender) > 0, "isGame wrong");
160     _;
161   }
162 
163   modifier isPaid() {
164     // paymnent must be greater than 1GWei and less than 100k ETH
165     require((msg.value > 1000000000) && (msg.value < 100000000000000000000000), "isPaid wrong");
166     _;
167   }
168 
169   // admins may set a token to be active or inactive in the games
170   function setTokenActive(uint256 _tid, bool _active) isAdmin public {
171     require(_tid < tokenNum, "setTokenActive wrong");
172     tokenPool[_tid].active = _active;
173   }
174 
175   // IMPORTANT: price needs to be in Wei per 1 unit of token
176   // admins may add new tokens into the pool
177   function addToken(address _tokenAddress, address _payAddress, uint256 _price, uint256 _buypercent, uint256 _potpercent, uint256 _lockperiod) isAdmin public {
178     tokenPool[tokenNum].token = ERC20Token(_tokenAddress);
179     tokenPool[tokenNum].addr = _tokenAddress;
180     tokenPool[tokenNum].decimals = tokenPool[tokenNum].token.decimals();
181     tokenPool[tokenNum].payaddr = _payAddress;
182     tokenPool[tokenNum].bought = 0;
183     tokenPool[tokenNum].safed = 0;
184     tokenPool[tokenNum].potted = 0;
185     tokenPool[tokenNum].price = _price;
186     tokenPool[tokenNum].buypercent = _buypercent;
187     tokenPool[tokenNum].potpercent = _potpercent;
188     tokenPool[tokenNum].lockperiod = _lockperiod;
189     tokenPool[tokenNum].tid = tokenNum;
190     tokenPool[tokenNum].active = true;
191     tokenInPool[_tokenAddress] = true;
192     tokenNum++;
193   }
194 
195   function tokenBalance(uint256 _tid) public view returns (uint256 _balance) {
196     return tokenPool[_tid].token.balanceOf(address(this)).sub(tokenPool[_tid].safed).sub(tokenPool[_tid].potted);
197   }
198 
199   function tokenBuyable(uint256 _tid, uint256 _eth) public view returns (bool _buyable) {
200     if (!tokenPool[_tid].active) return false;
201     uint256 buyAmount = (_eth).mul(tokenPool[_tid].buypercent).div(100).mul(uint256(10)**tokenPool[_tid].decimals).div(tokenPool[_tid].price);
202     uint256 potAmount = (_eth).mul(tokenPool[_tid].potpercent).div(100).mul(uint256(10)**tokenPool[_tid].decimals).div(tokenPool[_tid].price);
203     return (tokenPool[_tid].token.balanceOf(address(this)).sub(tokenPool[_tid].safed).sub(tokenPool[_tid].potted) > (buyAmount + potAmount));
204   }
205 
206   // Handles the buying of Tokens
207   function buyToken(uint256 _tid, uint256 _pid) isGame isPaid public payable {
208     require(gamebook.getPlayerAddressById(_pid) != address(0x0), "buyToken need valid player");
209     require(_tid < tokenNum, "buyToken need valid token");
210     require(tokenPool[_tid].active, "buyToken need active token");
211 
212     uint256 buyAmount = (msg.value).mul(tokenPool[_tid].buypercent).div(100).mul(uint256(10)**tokenPool[_tid].decimals).div(tokenPool[_tid].price);
213     uint256 potAmount = (msg.value).mul(tokenPool[_tid].potpercent).div(100).mul(uint256(10)**tokenPool[_tid].decimals).div(tokenPool[_tid].price);
214     require(tokenPool[_tid].token.balanceOf(address(this)).sub(tokenPool[_tid].safed).sub(tokenPool[_tid].potted) > (buyAmount + potAmount), "buyToken need more balance");
215 
216     tokenPool[_tid].bought = tokenPool[_tid].bought.add(buyAmount);
217     tokenPool[_tid].safed = tokenPool[_tid].safed.add(buyAmount);
218     tokenPool[_tid].potted = tokenPool[_tid].potted.add(potAmount);
219 
220     emit TokenBought(_tid, _pid, buyAmount);
221     emit TokenPotFunded(_tid, potAmount);
222 
223     uint256 lockStartTime = WTAGameRun(msg.sender).getCurrentRoundStartTime();
224     tokenSafeLock(_tid, _pid, buyAmount, lockStartTime);
225 
226     tokenPool[_tid].payaddr.transfer(msg.value);
227 
228     emit TokenFundPaid(_tid, tokenPool[_tid].payaddr, msg.value);
229   }
230 
231   // handling the Pot Winning
232   function winPot(uint256[] _tids) isGame public {
233     require(now > WTAGameRun(msg.sender).getCurrentRoundEndTime(), "winPot need round end");
234     uint256 lockStartTime = WTAGameRun(msg.sender).getCurrentRoundStartTime();
235     uint256 winnerId = WTAGameRun(msg.sender).getCurrentRoundWinner();
236     require(gamebook.getPlayerAddressById(winnerId) != address(0x0), "winPot need valid player");
237     for (uint256 i = 0; i< _tids.length; i++) {
238       uint256 tid = _tids[i];
239       if (tokenPool[tid].active) {
240         uint256 potAmount = tokenPool[tid].potted;
241         tokenPool[tid].potted = 0;
242         tokenPool[tid].safed = tokenPool[tid].safed.add(potAmount);
243 
244         tokenSafeLock(tid, winnerId, potAmount, lockStartTime);
245 
246         emit TokenPotWon(tid, winnerId, potAmount);
247       }
248     }
249   }
250 
251   // lock the Tokens allocated to players with a timelock
252   function tokenSafeLock(uint256 _tid, uint256 _pid, uint256 _amount, uint256 _start) private {
253     uint256 lockTime = _start + tokenPool[_tid].lockperiod;
254     uint256 lockNum = playerSafes[_pid][_tid].locks;
255     uint256 withdrawNum = playerSafes[_pid][_tid].withdraws;
256 
257     if (lockNum > 0 && lockNum > withdrawNum) {
258       if (playerSafes[_pid][_tid].lockTime[lockNum-1] == lockTime) {
259         playerSafes[_pid][_tid].lockValue[lockNum-1] = playerSafes[_pid][_tid].lockValue[lockNum-1].add(_amount);
260       } else {
261         playerSafes[_pid][_tid].lockTime[lockNum] = lockTime;
262         playerSafes[_pid][_tid].lockValue[lockNum] = _amount;
263         playerSafes[_pid][_tid].locks++;
264       }
265     } else {
266       playerSafes[_pid][_tid].lockTime[lockNum] = lockTime;
267       playerSafes[_pid][_tid].lockValue[lockNum] = _amount;
268       playerSafes[_pid][_tid].locks++;
269     }
270 
271     emit TokenLocked(_tid, _pid, _amount, lockTime);
272   }
273 
274   // show a player's allocated tokens
275   function showPlayerSafeByAddress(address _addr, uint256 _tid) public view returns (uint256 _locked, uint256 _unlocked, uint256 _withdrawable) {
276     uint256 pid = gamebook.getPlayerIdByAddress(_addr);
277     require(pid > 0, "showPlayerSafeByAddress wrong");
278     return showPlayerSafeById(pid, _tid);
279   }
280 
281   function showPlayerSafeById(uint256 _pid, uint256 _tid) public view returns (uint256 _locked, uint256 _unlocked, uint256 _withdrawable) {
282     require(gamebook.getPlayerAddressById(_pid) != address(0x0), "showPlayerSafeById need valid player");
283     require(_tid < tokenNum, "showPlayerSafeById need valid token");
284     uint256 locked = 0;
285     uint256 unlocked = 0;
286     uint256 withdrawable = 0;
287     uint256 withdraws = playerSafes[_pid][_tid].withdraws;
288     uint256 locks = playerSafes[_pid][_tid].locks;
289     uint256 count = 0;
290     for (uint256 i = withdraws; i < locks; i++) {
291       if (playerSafes[_pid][_tid].lockTime[i] < now) {
292         unlocked = unlocked.add(playerSafes[_pid][_tid].lockValue[i]);
293         if (count < 50) withdrawable = withdrawable.add(playerSafes[_pid][_tid].lockValue[i]);
294       } else {
295         locked = locked.add(playerSafes[_pid][_tid].lockValue[i]);
296       }
297       count++;
298     }
299     return (locked, unlocked, withdrawable);
300   }
301 
302   // player may withdraw tokens after the timelock period
303   function withdraw(uint256 _tid) public {
304     require(_tid < tokenNum, "withdraw need valid token");
305     uint256 pid = gamebook.getPlayerIdByAddress(msg.sender);
306     require(pid > 0, "withdraw need valid player");
307     uint256 withdrawable = 0;
308     uint256 i = playerSafes[pid][_tid].withdraws;
309     uint256 count = 0;
310     uint256 locks = playerSafes[pid][_tid].locks;
311     for (; (i < locks) && (count < 50); i++) {
312       if (playerSafes[pid][_tid].lockTime[i] < now) {
313         withdrawable = withdrawable.add(playerSafes[pid][_tid].lockValue[i]);
314         playerSafes[pid][_tid].withdraws = i + 1;
315       } else {
316         break;
317       }
318       count++;
319     }
320 
321     assert((tokenPool[_tid].token.balanceOf(address(this)) >= withdrawable) && (tokenPool[_tid].safed >= withdrawable));
322     tokenPool[_tid].safed = tokenPool[_tid].safed.sub(withdrawable);
323     playerSafes[pid][_tid].withdrawn = playerSafes[pid][_tid].withdrawn.add(withdrawable);
324     require(tokenPool[_tid].token.transfer(msg.sender, withdrawable), "withdraw transfer wrong");
325 
326     emit TokenWithdrawn(_tid, pid, withdrawable);
327   }
328 
329   // Safety measures
330   function () public payable {
331     revert();
332   }
333 
334   function emptyInactiveToken(uint256 _tid) isAdmin public {
335     require(_tid < tokenNum, "emptyInactiveToken need valid token");
336     require(tokenPool[_tid].active == false, "emptyInactiveToken need token inactive");
337     uint256 amount = tokenPool[_tid].token.balanceOf(address(this)).sub(tokenPool[_tid].safed);
338     tokenPool[_tid].potted = 0;
339     require(tokenPool[_tid].token.transfer(msg.sender, amount), "emptyInactiveToken transfer wrong");
340 
341     emit InactiveTokenEmptied(_tid, msg.sender, amount);
342   }
343 
344   function emptyWrongToken(address _addr) isAdmin public {
345     require(tokenInPool[_addr] == false, "emptyWrongToken need wrong token");
346     ERC20Token wrongToken = ERC20Token(_addr);
347     uint256 amount = wrongToken.balanceOf(address(this));
348     require(amount > 0, "emptyWrongToken need more balance");
349     require(wrongToken.transfer(msg.sender, amount), "emptyWrongToken transfer wrong");
350 
351     emit WrongTokenEmptied(_addr, msg.sender, amount);
352   }
353 
354   function emptyWrongEther() isAdmin public {
355     // require all tokens to be inactive before emptying ether
356     for (uint256 i=0; i < tokenNum; i++) {
357       require(tokenPool[i].active == false, "emptyWrongEther need all tokens inactive");
358     }
359     uint256 amount = address(this).balance;
360     require(amount > 0, "emptyWrongEther need more balance");
361     msg.sender.transfer(amount);
362 
363     emit WrongEtherEmptied(msg.sender, amount);
364   }
365 
366 }