1 /**
2  * @title MINISWAP TOKEN
3  */
4 
5 pragma solidity 0.5.16;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46     address public owner;
47     event OwnershipTransferred(
48         address indexed previousOwner,
49         address indexed newOwner
50     );
51 
52     /**
53      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54      * account.
55      */
56     constructor() public {
57         owner = msg.sender;
58         emit OwnershipTransferred(address(0), msg.sender);
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     /**
70      * @dev Allows the current owner to transfer control of the contract to a newOwner.
71      * @param newOwner The address to transfer ownership to.
72      */
73     function transferOwnership(address newOwner) public onlyOwner {
74         if (newOwner != address(0)) {
75             emit OwnershipTransferred(owner, newOwner);
76             owner = newOwner;
77         }
78     }
79 }
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20Basic {
87     uint256 public _totalSupply;
88 
89     function totalSupply() public view returns (uint256);
90 
91     function balanceOf(address who) public view returns (uint256);
92 
93     function transfer(address to, uint256 value) public returns (bool);
94 
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 }
97 
98 /**
99  * @title ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/20
101  */
102 contract ERC20 is ERC20Basic {
103     function allowance(address owner, address spender)
104         public
105         view
106         returns (uint256);
107 
108     function transferFrom(
109         address from,
110         address to,
111         uint256 value
112     ) public returns (bool);
113 
114     function approve(address spender, uint256 value) public returns (bool);
115 
116     event Approval(
117         address indexed owner,
118         address indexed spender,
119         uint256 value
120     );
121 }
122 
123 /**
124  * @title Basic token
125  * @dev Basic version of StandardToken, with no allowances.
126  */
127 contract BasicToken is Ownable, ERC20Basic {
128     using SafeMath for uint256;
129 
130     mapping(address => uint256) public balances;
131 
132     // additional variables for use if transaction fees ever became necessary
133     uint256 public basisPointsRate = 0;
134     uint256 public maximumFee = 0;
135 
136     /**
137      * @dev Fix for the ERC20 short address attack.
138      */
139     modifier onlyPayloadSize(uint256 size) {
140         require(!(msg.data.length < size.add(4)));
141         _;
142     }
143 
144     /**
145      * @dev transfer token for a specified address
146      * @param _to The address to transfer to.
147      * @param _value The amount to be transferred.
148      */
149     function transfer(address _to, uint256 _value)
150         public
151         onlyPayloadSize(2 * 32)
152         returns (bool)
153     {
154         require(_to != address(0));
155         uint256 fee = (_value.mul(basisPointsRate)).div(10000);
156         if (fee > maximumFee) {
157             fee = maximumFee;
158         }
159         uint256 sendAmount = _value.sub(fee);
160         balances[msg.sender] = balances[msg.sender].sub(_value);
161         balances[_to] = balances[_to].add(sendAmount);
162         if (fee > 0) {
163             balances[owner] = balances[owner].add(fee);
164             emit Transfer(msg.sender, owner, fee);
165         }
166         emit Transfer(msg.sender, _to, sendAmount);
167         return true;
168     }
169 
170     /**
171      * @dev Gets the balance of the specified address.
172      * @param _owner The address to query the the balance of.
173      * @return An uint representing the amount owned by the passed address.
174      */
175     function balanceOf(address _owner) public view returns (uint256 balance) {
176         return balances[_owner];
177     }
178 }
179 
180 /**
181  * @title Standard ERC20 token
182  *
183  * @dev Implementation of the basic standard token.
184  * @dev https://github.com/ethereum/EIPs/issues/20
185  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
186  */
187 contract StandardToken is BasicToken, ERC20 {
188     mapping(address => mapping(address => uint256)) public allowed;
189 
190     uint256 public constant MAX_UINT = 2**256 - 1;
191 
192     /**
193      * @dev Transfer tokens from one address to another
194      * @param _from address The address which you want to send tokens from
195      * @param _to address The address which you want to transfer to
196      * @param _value uint the amount of tokens to be transferred
197      */
198     function transferFrom(
199         address _from,
200         address _to,
201         uint256 _value
202     ) public onlyPayloadSize(3 * 32) returns (bool) {
203         require(_to != address(0));
204         uint256 _allowance = allowed[_from][msg.sender];
205 
206         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
207         // if (_value > _allowance) throw;
208 
209         uint256 fee = (_value.mul(basisPointsRate)).div(10000);
210         if (fee > maximumFee) {
211             fee = maximumFee;
212         }
213         if (_allowance < MAX_UINT) {
214             allowed[_from][msg.sender] = _allowance.sub(_value);
215         }
216         uint256 sendAmount = _value.sub(fee);
217         balances[_from] = balances[_from].sub(_value);
218         balances[_to] = balances[_to].add(sendAmount);
219         if (fee > 0) {
220             balances[owner] = balances[owner].add(fee);
221             emit Transfer(_from, owner, fee);
222         }
223         emit Transfer(_from, _to, sendAmount);
224         return true;
225     }
226 
227     /**
228      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
229      * @param _spender The address which will spend the funds.
230      * @param _value The amount of tokens to be spent.
231      */
232     function approve(address _spender, uint256 _value)
233         public
234         onlyPayloadSize(2 * 32)
235         returns (bool)
236     {
237         require(_spender != address(0));
238         // To change the approve amount you first have to reduce the addresses`
239         //  allowance to zero by calling `approve(_spender, 0)` if it is not
240         //  already 0 to mitigate the race condition described here:
241         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
243 
244         allowed[msg.sender][_spender] = _value;
245         emit Approval(msg.sender, _spender, _value);
246         return true;
247     }
248 
249     /**
250      * @dev Function to check the amount of tokens than an owner allowed to a spender.
251      * @param _owner address The address which owns the funds.
252      * @param _spender address The address which will spend the funds.
253      * @return A uint specifying the amount of tokens still available for the spender.
254      */
255     function allowance(address _owner, address _spender)
256         public
257         view
258         returns (uint256 remaining)
259     {
260         return allowed[_owner][_spender];
261     }
262 }
263 
264 /**
265  * @title Pausable
266  * @dev Base contract which allows children to implement an emergency stop mechanism.
267  */
268 contract Pausable is Ownable {
269     event Pause();
270     event Unpause();
271 
272     bool public paused = true;
273 
274     /**
275      * @dev Modifier to make a function callable only when the contract is not paused.
276      */
277     modifier whenNotPaused() {
278         require(!paused);
279         _;
280     }
281 
282     /**
283      * @dev Modifier to make a function callable only when the contract is paused.
284      */
285     modifier whenPaused() {
286         require(paused);
287         _;
288     }
289 
290     /**
291      * @dev called by the owner to pause, triggers stopped state
292      */
293     function pause() public onlyOwner whenNotPaused {
294         paused = true;
295         emit Pause();
296     }
297 
298     /**
299      * @dev called by the owner to unpause, returns to normal state
300      */
301     function unpause() public onlyOwner whenPaused {
302         paused = false;
303         emit Unpause();
304     }
305 }
306 
307 contract BlackList is Ownable, BasicToken {
308     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded CNYT) ///////
309     function getBlackListStatus(address _maker) external view returns (bool) {
310         return isBlackListed[_maker];
311     }
312 
313     function getOwner() external view returns (address) {
314         return owner;
315     }
316 
317     mapping(address => bool) public isBlackListed;
318 
319     function addBlackList(address _evilUser) public onlyOwner {
320         isBlackListed[_evilUser] = true;
321         emit AddedBlackList(_evilUser);
322     }
323 
324     function removeBlackList(address _clearedUser) public onlyOwner {
325         isBlackListed[_clearedUser] = false;
326         emit RemovedBlackList(_clearedUser);
327     }
328 
329     function destroyBlackFunds(address _blackListedUser) public onlyOwner {
330         require(isBlackListed[_blackListedUser]);
331         uint256 dirtyFunds = balances[_blackListedUser];
332         balances[_blackListedUser] = 0;
333         _totalSupply = _totalSupply.sub(dirtyFunds);
334         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
335     }
336 
337     event DestroyedBlackFunds(address _blackListedUser, uint256 _balance);
338 
339     event AddedBlackList(address _user);
340 
341     event RemovedBlackList(address _user);
342 }
343 
344 contract UpgradedStandardToken is StandardToken {
345     // those methods are called by the legacy contract
346     // and they must ensure msg.sender to be the contract address
347     function transferByLegacy(
348         address from,
349         address to,
350         uint256 value
351     ) public returns (bool);
352 
353     function transferFromByLegacy(
354         address sender,
355         address from,
356         address spender,
357         uint256 value
358     ) public returns (bool);
359 
360     function approveByLegacy(
361         address from,
362         address spender,
363         uint256 value
364     ) public returns (bool);
365 
366     function destroyBlackFundsByLegacy(address _blackListedUser) public;
367 }
368 
369 contract Mini is Pausable, StandardToken, BlackList {
370     string public name;
371     string public symbol;
372     uint8 public decimals;
373     address public upgradedAddress;
374     bool public deprecated;
375     uint256 public maxSupply;
376     uint256 public maxBase = 1000000000;
377 
378     uint256 public k = 1;
379     uint256 public priceBase = 93;
380     uint256 public maxK = 30;
381     uint256 public price30 = 2;
382 
383     mapping(uint256 => uint256) public kTotals;
384 
385     mapping(address => bool) issueAuthAddr;
386 
387     //  The contract can be initialized with a number of tokens
388     //  All the tokens are deposited to the owner address
389     //
390     // @param _balance Initial supply of the contract
391     // @param _name Token Name
392     // @param _symbol Token symbol
393     // @param _decimals Token decimals
394     constructor(
395         uint256 _initialSupply,
396         string memory _name,
397         string memory _symbol,
398         uint8 _decimals
399     ) public {
400         require(_initialSupply <= maxBase.mul(10**uint256(_decimals)));
401 
402         _totalSupply = _initialSupply;
403         maxSupply = maxBase.mul(10**uint256(_decimals));
404         name = _name;
405         symbol = _symbol;
406         decimals = _decimals;
407         balances[owner] = _totalSupply;
408         deprecated = false;
409         emit Transfer(address(0), owner, _totalSupply);
410     }
411 
412     // Forward ERC20 methods to upgraded contract if this one is deprecated
413     function transfer(address _to, uint256 _value)
414         public
415         whenNotPaused
416         returns (bool)
417     {
418         require(!isBlackListed[msg.sender]);
419         require(!isBlackListed[_to]);
420         if (deprecated) {
421             return
422                 UpgradedStandardToken(upgradedAddress).transferByLegacy(
423                     msg.sender,
424                     _to,
425                     _value
426                 );
427         } else {
428             return super.transfer(_to, _value);
429         }
430     }
431 
432     // Forward ERC20 methods to upgraded contract if this one is deprecated
433     function transferFrom(
434         address _from,
435         address _to,
436         uint256 _value
437     ) public whenNotPaused returns (bool) {
438         require(!isBlackListed[_from]);
439         require(!isBlackListed[_to]);
440         require(!isBlackListed[msg.sender]);
441         if (deprecated) {
442             return
443                 UpgradedStandardToken(upgradedAddress).transferFromByLegacy(
444                     msg.sender,
445                     _from,
446                     _to,
447                     _value
448                 );
449         } else {
450             return super.transferFrom(_from, _to, _value);
451         }
452     }
453 
454     // Forward ERC20 methods to upgraded contract if this one is deprecated
455     function balanceOf(address who) public view returns (uint256) {
456         if (deprecated) {
457             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
458         } else {
459             return super.balanceOf(who);
460         }
461     }
462 
463     // Forward ERC20 methods to upgraded contract if this one is deprecated
464     function approve(address _spender, uint256 _value)
465         public
466         onlyPayloadSize(2 * 32)
467         returns (bool)
468     {
469         if (deprecated) {
470             return
471                 UpgradedStandardToken(upgradedAddress).approveByLegacy(
472                     msg.sender,
473                     _spender,
474                     _value
475                 );
476         } else {
477             return super.approve(_spender, _value);
478         }
479     }
480 
481     // Forward ERC20 methods to upgraded contract if this one is deprecated
482     function allowance(address _owner, address _spender)
483         public
484         view
485         returns (uint256 remaining)
486     {
487         if (deprecated) {
488             return StandardToken(upgradedAddress).allowance(_owner, _spender);
489         } else {
490             return super.allowance(_owner, _spender);
491         }
492     }
493 
494     // Forward BlackList methods to upgraded contract if this one is deprecated
495     function destroyBlackFunds(address _blackListedUser) public onlyOwner {
496         if (deprecated) {
497             return
498                 UpgradedStandardToken(upgradedAddress)
499                     .destroyBlackFundsByLegacy(_blackListedUser);
500         } else {
501             return super.destroyBlackFunds(_blackListedUser);
502         }
503     }
504 
505     // deprecate current contract in favour of a new one
506     function deprecate(address _upgradedAddress) public onlyOwner {
507         deprecated = true;
508         upgradedAddress = _upgradedAddress;
509         emit Deprecate(_upgradedAddress);
510     }
511 
512     // deprecate current contract if favour of a new one
513     function totalSupply() public view returns (uint256) {
514         if (deprecated) {
515             return StandardToken(upgradedAddress).totalSupply();
516         } else {
517             return _totalSupply;
518         }
519     }
520 
521     function() external payable {
522         _swapMiniToken(msg.sender, msg.value);
523     }
524 
525     function _swapMiniToken(address sender, uint256 value)
526         internal
527         whenNotPaused
528     {
529         require(k <= maxK);
530         require(value > 0);
531         uint256 priceNow = calPrice(k);
532         uint256 NNow = calN(k);
533         uint256 NNext = calN(k.add(1));
534 
535         if (value.add(kTotals[k]) < NNow) {
536             kTotals[k] = kTotals[k].add(value);
537             uint256 swapAmount = calAmount(value, priceNow);
538             _issueTo(sender, swapAmount);
539         } else if (value.add(kTotals[k]) == NNow) {
540             kTotals[k] = kTotals[k].add(value);
541             uint256 swapAmount = calAmount(value, priceNow);
542             _issueTo(sender, swapAmount);
543             k = k.add(1);
544         } else if (
545             value.add(kTotals[k]) > NNow &&
546             value.add(kTotals[k]).sub(NNow) < NNext
547         ) {
548             uint256 valueNow = NNow.sub(kTotals[k]);
549             kTotals[k] = kTotals[k].add(valueNow);
550             uint256 swapAmount1 = calAmount(valueNow, priceNow);
551             uint256 priceNext = calPrice(k.add(1));
552 
553             uint256 valueNext = value.sub(valueNow);
554 
555             kTotals[k.add(1)] = kTotals[k.add(1)].add(valueNext);
556             uint256 swapAmount2 = calAmount(valueNext, priceNext);
557 
558             _issueTo(sender, swapAmount1.add(swapAmount2));
559             k = k.add(1);
560         } else {
561             revert("over max N this step");
562         }
563     }
564 
565     //(246*amount_eth)/price
566     function calAmount(uint256 amount_eth, uint256 price)
567         public
568         view
569         returns (uint256)
570     {
571         return
572             amount_eth
573                 .mul(246)
574                 .mul(10**uint256(decimals))
575                 .div(price)
576                 .mul(10**uint256(decimals))
577                 .div(10**18);
578     }
579 
580     //0.93^(30âk) * P30
581     function calPrice(uint256 tempK) public view returns (uint256) {
582         if (tempK > maxK) {
583             tempK = maxK;
584         }
585         uint256 priceDecimal = uint256(decimals).sub(2);
586         uint256 p30 = price30.mul(10**priceDecimal);
587         uint256 exp = maxK.sub(tempK);
588         return (priceBase**exp).mul(p30).div(100**exp);
589     }
590 
591     //20+10*(n-1)
592     function calN(uint256 tempK) public view returns (uint256) {
593         if (tempK > maxK) {
594             tempK = maxK;
595         }
596         return tempK.sub(1).mul(10).add(20).mul(10**18);
597     }
598 
599     function issueTo(address to, uint256 amount) public {
600         require(issueAuthAddr[msg.sender]);
601         _issueTo(to, amount);
602     }
603 
604     function _issueTo(address to, uint256 amount) internal {
605         require(_totalSupply.add(amount) <= maxSupply);
606         require(_totalSupply.add(amount) > _totalSupply);
607         require(balances[to].add(amount) > balances[to]);
608 
609         balances[to] = balances[to].add(amount);
610         _totalSupply = _totalSupply.add(amount);
611         emit IssueTo(to, amount);
612         emit Transfer(address(0), to, amount);
613     }
614 
615     function setIssueAuthAddr(address addr) public onlyOwner {
616         issueAuthAddr[addr] = true;
617     }
618 
619     function rmIssueAuthAddr(address addr) public onlyOwner {
620         issueAuthAddr[addr] = false;
621     }
622 
623     function withdraw() public onlyOwner {
624         uint256 etherBalance = address(this).balance;
625         msg.sender.transfer(etherBalance);
626     }
627 
628     function setParams(uint256 newBasisPoints, uint256 newMaxFee)
629         public
630         onlyOwner
631     {
632         // Ensure transparency by hardcoding limit beyond which fees can never be added
633         require(newBasisPoints < 20);
634         require(newMaxFee < 50 * (10**uint256(decimals)));
635 
636         basisPointsRate = newBasisPoints;
637         maximumFee = newMaxFee;
638 
639         emit Params(basisPointsRate, maximumFee);
640     }
641 
642     // Called when new token are issued
643 
644     event IssueTo(address to, uint256 amount);
645 
646     // Called when contract is deprecated
647     event Deprecate(address newAddress);
648 
649     // Called if contract ever adds fees
650     event Params(uint256 feeBasisPoints, uint256 maxFee);
651 }
