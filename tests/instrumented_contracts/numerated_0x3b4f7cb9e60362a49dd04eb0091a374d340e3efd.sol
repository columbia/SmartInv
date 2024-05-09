1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two unsigned integers, reverts on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two unsigned integers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
70 
71 pragma solidity ^0.5.2;
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 interface IERC20 {
78     function transfer(address to, uint256 value) external returns (bool);
79 
80     function approve(address spender, uint256 value) external returns (bool);
81 
82     function transferFrom(address from, address to, uint256 value) external returns (bool);
83 
84     function totalSupply() external view returns (uint256);
85 
86     function balanceOf(address who) external view returns (uint256);
87 
88     function allowance(address owner, address spender) external view returns (uint256);
89 
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity ^0.5.2;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
106  * Originally based on code by FirstBlood:
107  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  *
109  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
110  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
111  * compliant implementations may not do it.
112  */
113 contract ERC20 {
114     using SafeMath for uint256;
115 
116     mapping (address => uint256) private _balances;
117 
118     mapping (address => mapping (address => uint256)) private _allowed;
119 
120     uint256 private _totalSupply;
121 
122     event Transfer(address indexed from, address indexed to, uint256 value);
123 
124     event Approval(address indexed owner, address indexed spender, uint256 value);
125 
126     /**
127      * @dev Total number of tokens in existence
128      */
129     function totalSupply() public view returns (uint256) {
130         return _totalSupply;
131     }
132 
133     /**
134      * @dev Gets the balance of the specified address.
135      * @param owner The address to query the balance of.
136      * @return An uint256 representing the amount owned by the passed address.
137      */
138     function balanceOf(address owner) public view returns (uint256) {
139         return _balances[owner];
140     }
141 
142     /**
143      * @dev Function to check the amount of tokens that an owner allowed to a spender.
144      * @param owner address The address which owns the funds.
145      * @param spender address The address which will spend the funds.
146      * @return A uint256 specifying the amount of tokens still available for the spender.
147      */
148     function allowance(address owner, address spender) public view returns (uint256) {
149         return _allowed[owner][spender];
150     }
151 
152     /**
153      * @dev Transfer token for a specified address
154      * @param to The address to transfer to.
155      * @param value The amount to be transferred.
156      */
157     function transfer(address to, uint256 value) public returns (bool) {
158         _transfer(msg.sender, to, value);
159         return true;
160     }
161 
162     /**
163      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164      * Beware that changing an allowance with this method brings the risk that someone may use both the old
165      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168      * @param spender The address which will spend the funds.
169      * @param value The amount of tokens to be spent.
170      */
171     function approve(address spender, uint256 value) public returns (bool) {
172         _approve(msg.sender, spender, value);
173         return true;
174     }
175 
176     /**
177      * @dev Transfer tokens from one address to another.
178      * Note that while this function emits an Approval event, this is not required as per the specification,
179      * and other compliant implementations may not emit the event.
180      * @param from address The address which you want to send tokens from
181      * @param to address The address which you want to transfer to
182      * @param value uint256 the amount of tokens to be transferred
183      */
184     function transferFrom(address from, address to, uint256 value) public returns (bool) {
185         _transfer(from, to, value);
186         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
187         return true;
188     }
189 
190     /**
191      * @dev Transfer token for a specified addresses
192      * @param from The address to transfer from.
193      * @param to The address to transfer to.
194      * @param value The amount to be transferred.
195      */
196     function _transfer(address from, address to, uint256 value) internal {
197         require(to != address(0));
198 
199         _balances[from] = _balances[from].sub(value);
200         _balances[to] = _balances[to].add(value);
201         emit Transfer(from, to, value);
202     }
203 
204     /**
205      * @dev Internal function that mints an amount of the token and assigns it to
206      * an account. This encapsulates the modification of balances such that the
207      * proper events are emitted.
208      * @param account The account that will receive the created tokens.
209      * @param value The amount that will be created.
210      */
211     function mint(address account, uint256 value) internal {
212         require(account != address(0));
213 
214         _totalSupply = _totalSupply.add(value);
215         _balances[account] = _balances[account].add(value);
216         emit Transfer(address(0), account, value);
217     }
218 
219     /**
220      * @dev Approve an address to spend another addresses' tokens.
221      * @param owner The address that owns the tokens.
222      * @param spender The address that will spend the tokens.
223      * @param value The number of tokens that can be spent.
224      */
225     function _approve(address owner, address spender, uint256 value) internal {
226         require(spender != address(0));
227         require(owner != address(0));
228 
229         _allowed[owner][spender] = value;
230         emit Approval(owner, spender, value);
231     }
232 
233     function _burn(address account, uint256 value) internal {
234         require(account != address(0));
235 
236         _totalSupply = _totalSupply.sub(value);
237         _balances[account] = _balances[account].sub(value);
238         emit Transfer(account, address(0), value);
239     }
240 }
241 
242 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol
243 
244 pragma solidity ^0.5.2;
245 
246 
247 /**
248  * @title Capped token
249  * @dev Mintable token with a token cap.
250  */
251 contract ERC20Capped is ERC20 {
252     uint256 private _cap;
253 
254     constructor (uint256 cap) public {
255         require(cap > 0);
256         _cap = cap;
257     }
258 
259     /**
260      * @return the cap for the token minting.
261      */
262     function cap() public view returns (uint256) {
263         return _cap;
264     }
265 
266     function _mint(address account, uint256 value) internal {
267         require(totalSupply().add(value) <= _cap);
268         super.mint(account, value);
269     }
270 }
271 
272 // File: contracts/ITAMToken.sol
273 
274 pragma solidity ^0.5.2;
275 
276 
277 
278 
279 contract ITAMToken is ERC20Capped {
280     string public name = "ITAM";
281     string public symbol = "ITAM";
282     uint8 public decimals = 18;
283     uint256 constant TOTAL_CAP = 2500000000 ether;
284 
285     address public firstMaster;
286     address public secondMaster;
287     address public thirdMaster;
288     mapping(address => mapping(address => bool)) public decidedOwner;
289     
290     address public owner;
291     address public gameMaster;
292     mapping(address => bool) public blackLists;
293 
294     uint8 public unlockCount = 0;
295     address public strategicSaleAddress;
296     uint[] public strategicSaleReleaseCaps = [15000000 ether, 15000000 ether, 15000000 ether, 
297                                               15000000 ether, 15000000 ether, 15000000 ether,
298                                               15000000 ether, 22500000 ether, 22500000 ether];
299 
300     address public privateSaleAddress;
301     uint[] public privateSaleReleaseCaps = [97500000 ether, 97500000 ether, 97500000 ether,
302                                             97500000 ether, 130000000 ether, 130000000 ether];
303 
304     address public publicSaleAddress;
305     uint public publicSaleReleaseCap = 200000000 ether;
306 
307     address public teamAddress;
308     uint[] public teamReleaseCaps = [0, 0, 0, 0, 0, 0,
309                                      12500000 ether, 12500000 ether, 12500000 ether,
310                                      12500000 ether, 12500000 ether, 12500000 ether,
311                                      12500000 ether, 12500000 ether, 12500000 ether,
312                                      12500000 ether, 12500000 ether, 12500000 ether,
313                                      12500000 ether, 12500000 ether, 12500000 ether,
314                                      12500000 ether, 12500000 ether, 12500000 ether,
315                                      12500000 ether, 12500000 ether];
316 
317     address public advisorAddress;
318     uint[] public advisorReleaseCaps = [0, 0, 0, 25000000 ether, 0, 25000000 ether,
319                                         0, 25000000 ether, 0, 25000000 ether, 0, 25000000 ether];
320     
321     address public marketingAddress;
322     uint[] public marketingReleaseCaps = [100000000 ether, 25000000 ether, 25000000 ether,
323                                           25000000 ether, 25000000 ether, 25000000 ether,
324                                           25000000 ether, 25000000 ether, 25000000 ether,
325                                           25000000 ether, 25000000 ether, 25000000 ether];
326     
327     address public ecoAddress;
328     uint[] public ecoReleaseCaps = [50000000 ether, 50000000 ether, 50000000 ether,
329                                     50000000 ether, 50000000 ether, 50000000 ether,
330                                     50000000 ether, 50000000 ether, 50000000 ether,
331                                     50000000 ether, 50000000 ether, 50000000 ether,
332                                     50000000 ether, 50000000 ether, 50000000 ether];
333     address payable public inAppAddress;
334 
335     ERC20 erc20;
336 
337     // appId => itemId => tokenAddress => amount
338     mapping(uint64 => mapping(uint64 => mapping(address => uint256))) items;
339 
340     event Unlock(uint8 unlockCount);
341     event WithdrawEther(address indexed _to, uint256 amount);
342     event PurchaseItemOnEther(address indexed _spender, uint64 appId, uint64 itemId, uint256 amount);
343     event PurchaseItemOnITAM(address indexed _spender, uint64 appId, uint64 itemId, uint256 amount);
344     event PurchaseItemOnERC20(address indexed _spender, address indexed _tokenAddress, uint64 appId, uint64 itemId, uint256 amount);
345     event SetItem(uint64 appId);
346     event ChangeOwner(address _owner);
347 
348     constructor(address _firstMaster, address _secondMaster, address _thirdMaster,
349                 address _owner, address _gameMaster, address _strategicSaleAddress,
350                 address _privateSaleAddress, address _publicSaleAddress, address _teamAddress,
351                 address _advisorAddress, address _marketingAddress, address _ecoAddress, address payable _inAppAddress) public ERC20Capped(TOTAL_CAP) {
352         firstMaster = _firstMaster;
353         secondMaster = _secondMaster;
354         thirdMaster = _thirdMaster;
355         owner = _owner;
356         gameMaster = _gameMaster;
357         strategicSaleAddress = _strategicSaleAddress;
358         privateSaleAddress = _privateSaleAddress;
359         publicSaleAddress = _publicSaleAddress;
360         teamAddress = _teamAddress;
361         advisorAddress = _advisorAddress;
362         marketingAddress = _marketingAddress;
363         ecoAddress = _ecoAddress;
364         inAppAddress = _inAppAddress;
365     }
366 
367     modifier onlyOwner {
368         require(msg.sender == owner);
369         _;
370     }
371     
372     modifier onlyGameMaster {
373         require(msg.sender == gameMaster);
374         _;
375     }
376     
377     modifier onlyMaster {
378         require(msg.sender == firstMaster || msg.sender == secondMaster || msg.sender == thirdMaster);
379         _;
380     }
381     
382     function setGameMaster(address _gameMaster) public onlyOwner {
383         gameMaster = _gameMaster;
384     }
385 
386     function transfer(address _to, uint256 _value) public onlyNotBlackList returns (bool)  {
387         return super.transfer(_to, _value);
388     }
389 
390     function transferFrom(address _from, address _to, uint256 _value) public onlyNotBlackList returns (bool) {
391         return super.transferFrom(_from, _to, _value);
392     }
393 
394     function approve(address spender, uint256 value) public onlyNotBlackList returns (bool) {
395         return super.approve(spender, value);
396     }
397 
398     function burn(uint256 value) public onlyOwner {
399         super._burn(msg.sender, value);
400     }
401 
402     function unlock() public onlyOwner returns (bool) {
403         uint8 _unlockCount = unlockCount;
404 
405         if(strategicSaleReleaseCaps.length > _unlockCount) {
406             super._mint(strategicSaleAddress, strategicSaleReleaseCaps[_unlockCount]);
407         }
408 
409         if(privateSaleReleaseCaps.length > _unlockCount) {
410             super._mint(privateSaleAddress, privateSaleReleaseCaps[_unlockCount]);
411         }
412 
413         if(_unlockCount == 0) {
414             super._mint(publicSaleAddress, publicSaleReleaseCap);
415         }
416 
417         if(teamReleaseCaps.length > _unlockCount) {
418             super._mint(teamAddress, teamReleaseCaps[_unlockCount]);
419         }
420 
421         if(advisorReleaseCaps.length > _unlockCount) {
422             super._mint(advisorAddress, advisorReleaseCaps[_unlockCount]);
423         }
424 
425         if(marketingReleaseCaps.length > _unlockCount) {
426             super._mint(marketingAddress, marketingReleaseCaps[_unlockCount]);
427         }
428 
429         if(ecoReleaseCaps.length > _unlockCount) {
430             super._mint(ecoAddress, ecoReleaseCaps[_unlockCount]);
431         }
432 
433         unlockCount++;
434         return true;
435     }
436 
437     function setAddresses(address _strategicSaleAddress, address _privateSaleAddress, address _publicSaleAddress, address _teamAddress, address _advisorAddress, address _marketingAddress, address _ecoAddress,
438                           address payable _inAppAddress) public onlyOwner {
439         strategicSaleAddress = _strategicSaleAddress;
440         privateSaleAddress = _privateSaleAddress;
441         publicSaleAddress = _publicSaleAddress;
442         teamAddress = _teamAddress;
443         advisorAddress = _advisorAddress;
444         marketingAddress = _marketingAddress;
445         ecoAddress = _ecoAddress;
446         inAppAddress = _inAppAddress;
447     }
448     
449     function changeOwner(address _owner) public onlyMaster {
450         decidedOwner[msg.sender][_owner] = true;
451         
452         uint16 decidedCount = 0;
453         if (decidedOwner[firstMaster][_owner] == true) {
454             decidedCount += 1;
455         }
456         if (decidedOwner[secondMaster][_owner] == true)  {
457             decidedCount += 1;
458         }
459         if (decidedOwner[thirdMaster][_owner] == true) {
460             decidedCount += 1;
461         }
462         
463         if (decidedCount >= 2) {
464             owner = _owner;
465             emit ChangeOwner(_owner);
466         }
467     }
468     
469     function addToBlackList(address _to) public onlyOwner {
470         require(!blackLists[_to], "already blacklist");
471         blackLists[_to] = true;
472     }
473     
474     function removeFromBlackList(address _to) public onlyOwner {
475         require(blackLists[_to], "cannot found this address from blacklist");
476         blackLists[_to] = false;
477     }
478 
479     modifier onlyNotBlackList {
480         require(!blackLists[msg.sender], "sender cannot call this contract");
481         _;
482     }
483     
484     // can accept ether
485     function() payable external {
486         
487     }
488 
489     function withdrawEther(uint256 amount) public onlyOwner {
490         inAppAddress.transfer(amount);
491         emit WithdrawEther(inAppAddress, amount);
492     }
493 
494     function createOrUpdateItem(uint64 appId, uint64[] memory itemIds, address[] memory tokenAddresses, uint256[] memory values) public onlyGameMaster returns(bool) {
495         uint itemLength = itemIds.length;
496         require(itemLength == tokenAddresses.length && tokenAddresses.length == values.length);
497         
498         uint64 itemId;
499         address tokenAddress;
500         uint256 value;
501         for(uint16 i = 0; i < itemLength; i++) {
502             itemId = itemIds[i];
503             tokenAddress = tokenAddresses[i];
504             value = values[i];
505 
506             items[appId][itemId][tokenAddress] = value;
507         }
508         
509         emit SetItem(appId);
510         return true;
511     }
512     
513     function _getItemAmount(uint64 appId, uint64 itemId, address tokenAddress) private view returns(uint256) {
514         uint256 itemAmount = items[appId][itemId][tokenAddress];
515         require(itemAmount > 0, "invalid item id");
516         return itemAmount;
517     }
518 
519     function purchaseItemOnERC20(address payable tokenAddress, uint64 appId, uint64 itemId) external onlyNotBlackList returns(bool) {
520         uint256 itemAmount = _getItemAmount(appId, itemId, tokenAddress);
521 
522         erc20 = ERC20(tokenAddress);
523         require(erc20.transferFrom(msg.sender, inAppAddress, itemAmount), "failed transferFrom");
524 
525         emit PurchaseItemOnERC20(msg.sender, tokenAddress, appId, itemId, itemAmount);
526         return true;
527     }
528 
529     function purchaseItemOnITAM(uint64 appId, uint64 itemId) external onlyNotBlackList returns(bool) {
530         uint256 itemAmount = _getItemAmount(appId, itemId, address(this));
531 
532         transfer(inAppAddress, itemAmount);
533         
534         emit PurchaseItemOnITAM(msg.sender, appId, itemId, itemAmount);
535         return true;
536     }
537 
538     function purchaseItemOnEther(uint64 appId, uint64 itemId) external payable onlyNotBlackList returns(bool) {
539         uint256 itemAmount = _getItemAmount(appId, itemId, address(0));
540         require(itemAmount == msg.value, "wrong quantity");
541         
542         emit PurchaseItemOnEther(msg.sender, appId, itemId, msg.value);
543         return true;
544     }
545 }