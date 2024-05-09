1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     uint256 c = _a * _b;
21     require(c / _a == _b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     require(_b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     require(_b <= _a);
42     uint256 c = _a - _b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     uint256 c = _a + _b;
52     require(c >= _a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73   address public owner;
74 
75 
76   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78 
79   /**
80    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81    * account.
82    */
83   constructor() public {
84     owner = msg.sender;
85   }
86 
87 
88   /**
89    * @dev Throws if called by any account other than the owner.
90    */
91   modifier onlyOwner() {
92     require(msg.sender == owner);
93     _;
94   }
95 
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address newOwner) onlyOwner public {
102     require(newOwner != address(0));
103     emit OwnershipTransferred(owner, newOwner);
104     owner = newOwner;
105   }
106 }
107 
108 interface token { 
109   function transfer(address, uint) external returns (bool);
110   function transferFrom(address, address, uint) external returns (bool); 
111   function allowance(address, address) external constant returns (uint256);
112   function balanceOf(address) external constant returns (uint256);
113 }
114 
115 /** LOGIC DESCRIPTION
116  * 11% fees in and out for ETH
117  * 11% fees in and out for NOVA
118  *
119  * ETH fees split: 
120  * 6% to nova holders
121  * 4% to eth holders
122  * 1% to fixed address
123  * 
124  * NOVA fees split: 
125  * 6% to nova holders
126  * 4% to eth holders
127  * 1% airdrop to a random address based on their nova shares
128  * rules: 
129  * - you need to have both nova and eth to get dividends
130  */
131 
132 contract NovaBox is Ownable {
133   
134   using SafeMath for uint;
135   token tokenReward;
136 
137   
138   constructor() public {
139     tokenReward = token(0x72FBc0fc1446f5AcCC1B083F0852a7ef70a8ec9f);
140   }
141 
142   event AirDrop(address to, uint amount, uint randomTicket);
143   event DividendsTransferred(address to, uint ethAmount, uint novaAmount);
144 
145 
146   // ether contributions
147   mapping (address => uint) public contributionsEth;
148   // token contributions
149   mapping (address => uint) public contributionsToken;
150 
151   // investors list who have deposited BOTH ether and token
152   mapping (address => uint) public indexes;
153   mapping (uint => address) public addresses;
154   uint256 public lastIndex = 0;
155 
156   mapping (address => bool) public addedToList;
157   uint _totalTokens = 0;
158   uint _totalWei = 0;
159 
160   uint pointMultiplier = 1e18;
161 
162   mapping (address => uint) public last6EthDivPoints;
163   uint public total6EthDivPoints = 0;
164   // uint public unclaimed6EthDivPoints = 0;
165 
166   mapping (address => uint) public last4EthDivPoints;
167   uint public total4EthDivPoints = 0;
168   // uint public unclaimed4EthDivPoints = 0;
169 
170   mapping (address => uint) public last6TokenDivPoints;
171   uint public total6TokenDivPoints = 0;
172   // uint public unclaimed6TokenDivPoints = 0;
173 
174   mapping (address => uint) public last4TokenDivPoints;
175   uint public total4TokenDivPoints = 0;
176   // uint public unclaimed4TokenDivPoints = 0;
177 
178   function ethDivsOwing(address _addr) public view returns (uint) {
179     return eth4DivsOwing(_addr).add(eth6DivsOwing(_addr));
180   }
181 
182   function eth6DivsOwing(address _addr) public view returns (uint) {
183     if (!addedToList[_addr]) return 0;
184     uint newEth6DivPoints = total6EthDivPoints.sub(last6EthDivPoints[_addr]);
185 
186     return contributionsToken[_addr].mul(newEth6DivPoints).div(pointMultiplier);
187   }
188 
189   function eth4DivsOwing(address _addr) public view returns (uint) {
190     if (!addedToList[_addr]) return 0;
191     uint newEth4DivPoints = total4EthDivPoints.sub(last4EthDivPoints[_addr]);
192     return contributionsEth[_addr].mul(newEth4DivPoints).div(pointMultiplier);
193   }
194 
195   function tokenDivsOwing(address _addr) public view returns (uint) {
196     return token4DivsOwing(_addr).add(token6DivsOwing(_addr));    
197   }
198 
199   function token6DivsOwing(address _addr) public view returns (uint) {
200     if (!addedToList[_addr]) return 0;
201     uint newToken6DivPoints = total6TokenDivPoints.sub(last6TokenDivPoints[_addr]);
202     return contributionsToken[_addr].mul(newToken6DivPoints).div(pointMultiplier);
203   }
204 
205   function token4DivsOwing(address _addr) public view returns (uint) {
206     if (!addedToList[_addr]) return 0;
207 
208     uint newToken4DivPoints = total4TokenDivPoints.sub(last4TokenDivPoints[_addr]);
209     return contributionsEth[_addr].mul(newToken4DivPoints).div(pointMultiplier);
210   }
211 
212   function updateAccount(address account) private {
213     uint owingEth6 = eth6DivsOwing(account);
214     uint owingEth4 = eth4DivsOwing(account);
215     uint owingEth = owingEth4.add(owingEth6);
216 
217     uint owingToken6 = token6DivsOwing(account);
218     uint owingToken4 = token4DivsOwing(account);
219     uint owingToken = owingToken4.add(owingToken6);
220 
221     if (owingEth > 0) {
222       // send ether dividends to account
223       account.transfer(owingEth);
224     }
225 
226     if (owingToken > 0) {
227       // send token dividends to account
228       tokenReward.transfer(account, owingToken);
229     }
230 
231     last6EthDivPoints[account] = total6EthDivPoints;
232     last4EthDivPoints[account] = total4EthDivPoints;
233     last6TokenDivPoints[account] = total6TokenDivPoints;
234     last4TokenDivPoints[account] = total4TokenDivPoints;
235 
236     emit DividendsTransferred(account, owingEth, owingToken);
237 
238   }
239 
240 
241 
242   function addToList(address sender) private {
243     addedToList[sender] = true;
244     // if the sender is not in the list
245     if (indexes[sender] == 0) {
246       _totalTokens = _totalTokens.add(contributionsToken[sender]);
247       _totalWei = _totalWei.add(contributionsEth[sender]);
248 
249       // add the sender to the list
250       lastIndex++;
251       addresses[lastIndex] = sender;
252       indexes[sender] = lastIndex;
253     }
254   }
255   function removeFromList(address sender) private {
256     addedToList[sender] = false;
257     // if the sender is in temp eth list 
258     if (indexes[sender] > 0) {
259       _totalTokens = _totalTokens.sub(contributionsToken[sender]);
260       _totalWei = _totalWei.sub(contributionsEth[sender]);
261 
262       // remove the sender from temp eth list
263       addresses[indexes[sender]] = addresses[lastIndex];
264       indexes[addresses[lastIndex]] = indexes[sender];
265       indexes[sender] = 0;
266       delete addresses[lastIndex];
267       lastIndex--;
268     }
269   }
270 
271   // desposit ether
272   function () payable public {
273     address sender = msg.sender;
274     // size of code at target address
275     uint codeLength;
276 
277     // get the length of code at the sender address
278     assembly {
279       codeLength := extcodesize(sender)
280     }
281 
282     // don't allow contracts to deposit ether
283     require(codeLength == 0);
284     
285     uint weiAmount = msg.value;
286     
287 
288     updateAccount(sender);
289 
290     // number of ether sent must be greater than 0
291     require(weiAmount > 0);
292 
293     uint _89percent = weiAmount.mul(89).div(100);
294     uint _6percent = weiAmount.mul(6).div(100);
295     uint _4percent = weiAmount.mul(4).div(100);
296     uint _1percent = weiAmount.mul(1).div(100);
297 
298 
299     
300 
301 
302     distributeEth(
303       _6percent, // to nova investors
304       _4percent  // to eth investors
305     ); 
306     //1% goes to REX Investors
307     owner.transfer(_1percent);
308 
309     contributionsEth[sender] = contributionsEth[sender].add(_89percent);
310     // if the sender is in list
311     if (indexes[sender]>0) {
312       // increase _totalWei
313       _totalWei = _totalWei.add(_89percent);
314     }
315 
316     // if the sender has also deposited tokens, add sender to list
317     if (contributionsToken[sender]>0) addToList(sender);
318   }
319 
320   // withdraw ether
321   function withdrawEth(uint amount) public {
322     address sender = msg.sender;
323     require(amount>0 && contributionsEth[sender] >= amount);
324 
325     updateAccount(sender);
326 
327     uint _89percent = amount.mul(89).div(100);
328     uint _6percent = amount.mul(6).div(100);
329     uint _4percent = amount.mul(4).div(100);
330     uint _1percent = amount.mul(1).div(100);
331 
332     contributionsEth[sender] = contributionsEth[sender].sub(amount);
333     // if sender is in list
334     if (indexes[sender]>0) {
335       // decrease total wei
336       _totalWei = _totalWei.sub(amount);
337     }
338 
339     // if the sender has withdrawn all their eth
340       // remove the sender from list
341     if (contributionsEth[sender] == 0) removeFromList(sender);
342 
343     sender.transfer(_89percent);
344     distributeEth(
345       _6percent, // to nova investors
346       _4percent  // to eth investors
347     );
348     owner.transfer(_1percent);  //1% goes to REX Investors
349   }
350 
351   // deposit tokens
352   function depositTokens(address randomAddr, uint randomTicket) public {
353     updateAccount(msg.sender);
354     
355 
356     address sender = msg.sender;
357     uint amount = tokenReward.allowance(sender, address(this));
358     
359     // number of allowed tokens must be greater than 0
360     // if it is then transfer the allowed tokens from sender to the contract
361     // if not transferred then throw
362     require(amount>0 && tokenReward.transferFrom(sender, address(this), amount));
363 
364 
365     uint _89percent = amount.mul(89).div(100);
366     uint _6percent = amount.mul(6).div(100);
367     uint _4percent = amount.mul(4).div(100);
368     uint _1percent = amount.mul(1).div(100);
369     
370     
371 
372     distributeTokens(
373       _6percent, // to nova investors
374       _4percent  // to eth investors
375       );
376     tokenReward.transfer(randomAddr, _1percent);
377     // 1% for Airdrop
378     emit AirDrop(randomAddr, _1percent, randomTicket);
379 
380     contributionsToken[sender] = contributionsToken[sender].add(_89percent);
381 
382     // if sender is in list
383     if (indexes[sender]>0) {
384       // increase totaltokens
385       _totalTokens = _totalTokens.add(_89percent);
386     }
387 
388     // if the sender has also contributed ether add sender to list
389     if (contributionsEth[sender]>0) addToList(sender);
390   }
391 
392   // withdraw tokens
393   function withdrawTokens(uint amount, address randomAddr, uint randomTicket) public {
394     address sender = msg.sender;
395     updateAccount(sender);
396     // requested amount must be greater than 0 and 
397     // the sender must have contributed tokens no less than `amount`
398     require(amount>0 && contributionsToken[sender]>=amount);
399 
400     uint _89percent = amount.mul(89).div(100);
401     uint _6percent = amount.mul(6).div(100);
402     uint _4percent = amount.mul(4).div(100);
403     uint _1percent = amount.mul(1).div(100);
404 
405     contributionsToken[sender] = contributionsToken[sender].sub(amount);
406     // if sender is in list
407     if (indexes[sender]>0) {
408       // decrease total tokens
409       _totalTokens = _totalTokens.sub(amount);
410     }
411 
412     // if sender withdrawn all their tokens, remove them from list
413     if (contributionsToken[sender] == 0) removeFromList(sender);
414 
415     tokenReward.transfer(sender, _89percent);
416     distributeTokens(
417       _6percent, // to nova investors
418       _4percent  // to eth investors
419     );
420     // airdropToRandom(_1percent);  
421     tokenReward.transfer(randomAddr, _1percent);
422     emit AirDrop(randomAddr, _1percent, randomTicket);
423   }
424 
425   function distributeTokens(uint _6percent, uint _4percent) private {
426     uint totalTokens = getTotalTokens();
427     uint totalWei = getTotalWei();
428 
429     if (totalWei == 0 || totalTokens == 0) return; 
430 
431     total4TokenDivPoints = total4TokenDivPoints.add(_4percent.mul(pointMultiplier).div(totalWei));
432     // unclaimed4TokenDivPoints = unclaimed4TokenDivPoints.add(_4percent);
433 
434     total6TokenDivPoints = total6TokenDivPoints.add(_6percent.mul(pointMultiplier).div(totalTokens));
435     // unclaimed6TokenDivPoints = unclaimed6TokenDivPoints.add(_6percent);
436     
437   }
438 
439   function distributeEth(uint _6percent, uint _4percent) private {
440     uint totalTokens = getTotalTokens();
441     uint totalWei = getTotalWei();
442 
443     if (totalWei ==0 || totalTokens == 0) return;
444 
445     total4EthDivPoints = total4EthDivPoints.add(_4percent.mul(pointMultiplier).div(totalWei));
446     // unclaimed4EthDivPoints += _4percent;
447 
448     total6EthDivPoints = total6EthDivPoints.add(_6percent.mul(pointMultiplier).div(totalTokens));
449     // unclaimed6EthDivPoints += _6percent;
450 
451   }
452 
453 
454   // get sum of tokens contributed by the ether investors
455   function getTotalTokens() public view returns (uint) {
456     return _totalTokens;
457   }
458 
459   // get the sum of wei contributed by the token investors
460   function getTotalWei() public view returns (uint) {
461     return _totalWei;
462   }
463 
464   function withdrawDivs() public {
465     updateAccount(msg.sender);
466   }
467 
468 
469   // get the list of investors
470   function getList() public view returns (address[], uint[]) {
471     address[] memory _addrs = new address[](lastIndex);
472     uint[] memory _contributions = new uint[](lastIndex);
473 
474     for (uint i = 1; i <= lastIndex; i++) {
475       _addrs[i-1] = addresses[i];
476       _contributions[i-1] = contributionsToken[addresses[i]];
477     }
478     return (_addrs, _contributions);
479   }
480 
481 }