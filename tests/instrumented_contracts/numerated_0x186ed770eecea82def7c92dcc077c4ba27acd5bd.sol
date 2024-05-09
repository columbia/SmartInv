1 // File: contracts/token/libs/Ownable.sol
2 
3 pragma solidity >=0.5.0 <0.6.0;
4 
5 contract Ownable {
6     address public owner;
7 
8     constructor() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlySafe() {
13         require(msg.sender == owner);
14         _;
15     }
16     
17     function transferOwnership(address newOwner) public onlySafe {
18         if (newOwner != address(0)) {
19             owner = newOwner;
20         }
21     }
22 }
23 
24 // File: contracts/token/libs/Pausable.sol
25 
26 /**
27  *Submitted for verification at Etherscan.io on 2017-11-28
28  */
29 
30 pragma solidity >=0.5.0 <0.6.0;
31 
32 
33 /**
34  * @title Pausable
35  * @dev Base contract which allows children to implement an emergency stop mechanism.
36  */
37 contract Pausable is Ownable {
38     event Pause();
39     event Unpause();
40 
41     bool public paused = false;
42 
43     /**
44      * @dev Modifier to make a function callable only when the contract is not paused.
45      */
46     modifier whenNotPaused() {
47         require(!paused);
48         _;
49     }
50 
51     /**
52      * @dev Modifier to make a function callable only when the contract is paused.
53      */
54     modifier whenPaused() {
55         require(paused);
56         _;
57     }
58 
59     /**
60      * @dev called by the owner to pause, triggers stopped state
61      */
62     function pause() public onlySafe whenNotPaused {
63         paused = true;
64         emit Pause();
65     }
66 
67     /**
68      * @dev called by the owner to unpause, returns to normal state
69      */
70     function unpause() public onlySafe whenPaused {
71         paused = false;
72         emit Unpause();
73     }
74 }
75 
76 // File: contracts/token/libs/ERC20Basic.sol
77 
78 /**
79  *Submitted for verification at Etherscan.io on 2017-11-28
80  */
81 
82 pragma solidity >=0.5.0 <0.6.0;
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20Basic {
90     uint256 public _totalSupply;
91 
92     function totalSupply() external view returns (uint256);
93 
94     function balanceOf(address who) external view returns (uint256);
95 
96     function transfer(address to, uint256 value) external returns (bool);
97 
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 // File: contracts/token/libs/SafeMath.sol
102 
103 /**
104  *Submitted for verification at Etherscan.io on 2017-11-28
105  */
106 
107 pragma solidity >=0.5.0 <0.6.0;
108 
109 /**
110  * @title SafeMath
111  * @dev Math operations with safety checks that throw on error
112  */
113 library SafeMath {
114     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115         if (a == 0 || b == 0) {
116             return 0;
117         }
118         uint256 c = a * b;
119         assert(c / a == b);
120         return c;
121     }
122 
123     function div(uint256 a, uint256 b) internal pure returns (uint256) {
124         assert(b > 0); // Solidity automatically throws when dividing by 0
125         uint256 c = a / b;
126         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127         return c;
128     }
129 
130     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131         assert(b <= a);
132         return a - b;
133     }
134 
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         assert(c >= a);
138         return c;
139     }
140 }
141 
142 // File: contracts/token/libs/BasicToken.sol
143 
144 /**
145  *Submitted for verification at Etherscan.io on 2017-11-28
146  */
147 
148 pragma solidity >=0.5.0 <0.6.0;
149 
150 
151 
152 
153 
154 /**
155  * @title Basic token
156  * @dev Basic version of StandardToken, with no allowances.
157  */
158 contract BasicToken is Ownable, Pausable, ERC20Basic {
159     using SafeMath for uint256;
160 
161     mapping(address => uint256) public balances;
162 
163     // additional variables for use if transaction fees ever became necessary
164     uint256 public basisPointsRate = 0;
165     uint256 public maximumFee = 0;
166 
167     /**
168      * @dev Fix for the ERC20 short address attack.
169      */
170     modifier onlyPayloadSize(uint256 size) {
171         require(!(msg.data.length < size + 4));
172         _;
173     }
174 
175     /**
176      * @dev transfer token for a specified address
177      * @param _to The address to transfer to.
178      * @param _value The amount to be transferred.
179      */
180     function transfer(address _to, uint256 _value)
181         public
182         onlyPayloadSize(2 * 32)
183         returns (bool success)
184     {
185         uint256 fee = (_value.mul(basisPointsRate)).div(10000);
186         if (fee > maximumFee) {
187             fee = maximumFee;
188         }
189         uint256 sendAmount = _value.sub(fee);
190         balances[msg.sender] = balances[msg.sender].sub(_value);
191         balances[_to] = balances[_to].add(sendAmount);
192         emit Transfer(msg.sender, _to, sendAmount);
193         if (fee > 0) {
194             balances[owner] = balances[owner].add(fee);
195             emit Transfer(msg.sender, owner, fee);
196         }
197         return true;
198     }
199 
200     /**
201      * @dev Gets the balance of the specified address.
202      * @param _owner The address to query the the balance of.
203      * @return An uint representing the amount owned by the passed address.
204      */
205     function balanceOf(address _owner) public view returns (uint256 balance) {
206         return balances[_owner];
207     }
208 }
209 
210 // File: contracts/token/libs/BlackList.sol
211 
212 /**
213  *Submitted for verification at Etherscan.io on 2017-11-28
214  */
215 
216 pragma solidity >=0.5.0 <0.6.0;
217 
218 
219 
220 contract BlackList is Ownable, BasicToken {
221     mapping(address => bool) public isBlackListed;
222 
223     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
224     function getBlackListStatus(address _maker) external view returns (bool) {
225         return isBlackListed[_maker];
226     }
227 
228     function getOwner() external view returns (address) {
229         return owner;
230     }
231 
232     function addBlackList(address _evilUser) public onlySafe {
233         isBlackListed[_evilUser] = true;
234         emit AddedBlackList(_evilUser);
235     }
236 
237     function removeBlackList(address _clearedUser) public onlySafe {
238         isBlackListed[_clearedUser] = false;
239         emit RemovedBlackList(_clearedUser);
240     }
241 
242     function destroyBlackFunds(address _blackListedUser) public onlySafe {
243         require(isBlackListed[_blackListedUser]);
244         uint256 dirtyFunds = balanceOf(_blackListedUser);
245         balances[_blackListedUser] = 0;
246         _totalSupply -= dirtyFunds;
247         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
248     }
249 
250     event DestroyedBlackFunds(address _blackListedUser, uint256 _balance);
251 
252     event AddedBlackList(address _user);
253 
254     event RemovedBlackList(address _user);
255 }
256 
257 // File: contracts/token/libs/ERC20.sol
258 
259 /**
260  *Submitted for verification at Etherscan.io on 2017-11-28
261  */
262 
263 pragma solidity >=0.5.0 <0.6.0;
264 
265 
266 /**
267  * @title ERC20 interface
268  * @dev see https://github.com/ethereum/EIPs/issues/20
269  */
270 contract ERC20 is ERC20Basic {
271     function allowance(address owner, address spender)
272         external
273         view
274         returns (uint256);
275 
276     function transferFrom(
277         address from,
278         address to,
279         uint256 value
280     ) external returns (bool);
281 
282     function approve(address spender, uint256 value) external returns (bool);
283 
284     event Approval(
285         address indexed owner,
286         address indexed spender,
287         uint256 value
288     );
289 }
290 
291 // File: contracts/token/libs/StandardToken.sol
292 
293 /**
294  *Submitted for verification at Etherscan.io on 2017-11-28
295  */
296 
297 pragma solidity >=0.5.0 <0.6.0;
298 
299 
300 
301 /**
302  * @title Standard ERC20 token
303  *
304  * @dev Implementation of the basic standard token.
305  * @dev https://github.com/ethereum/EIPs/issues/20
306  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
307  */
308 contract StandardToken is BasicToken, ERC20 {
309     mapping(address => mapping(address => uint256)) public allowed;
310 
311     uint256 public MAX_UINT = 2**256 - 1;
312 
313     /**
314      * @dev Transfer tokens from one address to another
315      * @param _from address The address which you want to send tokens from
316      * @param _to address The address which you want to transfer to
317      * @param _value uint the amount of tokens to be transferred
318      */
319     function transferFrom(
320         address _from,
321         address _to,
322         uint256 _value
323     ) public onlyPayloadSize(3 * 32) returns (bool success) {
324         uint256 _allowance = allowed[_from][msg.sender];
325 
326         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
327         // if (_value > _allowance) throw;
328 
329         uint256 fee = (_value.mul(basisPointsRate)).div(10000);
330         if (fee > maximumFee) {
331             fee = maximumFee;
332         }
333         if (_allowance < MAX_UINT) {
334             allowed[_from][msg.sender] = _allowance.sub(_value);
335         }
336         uint256 sendAmount = _value.sub(fee);
337         balances[_from] = balances[_from].sub(_value);
338         balances[_to] = balances[_to].add(sendAmount);
339         emit Transfer(_from, _to, sendAmount);
340         if (fee > 0) {
341             balances[owner] = balances[owner].add(fee);
342             emit Transfer(_from, owner, fee);
343         }
344         return true;
345     }
346 
347     /**
348      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
349      * @param _spender The address which will spend the funds.
350      * @param _value The amount of tokens to be spent.
351      */
352     function approve(address _spender, uint256 _value)
353         public
354         onlyPayloadSize(2 * 32)
355         returns (bool success)
356     {
357         allowed[msg.sender][_spender] = _value;
358         emit Approval(msg.sender, _spender, _value);
359         return true;
360     }
361 
362     /**
363      * @dev Function to check the amount of tokens than an owner allowed to a spender.
364      * @param _owner address The address which owns the funds.
365      * @param _spender address The address which will spend the funds.
366      * @return A uint specifying the amount of tokens still available for the spender.
367      */
368     function allowance(address _owner, address _spender)
369         public
370         view
371         returns (uint256 remaining)
372     {
373         return allowed[_owner][_spender];
374     }
375 }
376 
377 // File: contracts/token/libs/UpgradedStandardToken.sol
378 
379 /**
380  *Submitted for verification at Etherscan.io on 2017-11-28
381  */
382 
383 pragma solidity >=0.5.0 <0.6.0;
384 
385 
386 contract UpgradedStandardToken is StandardToken {
387     // those methods are called by the legacy contract
388     // and they must ensure msg.sender to be the contract address
389     function transferByLegacy(
390         address from,
391         address to,
392         uint256 value
393     ) public returns (bool);
394 
395     function transferFromByLegacy(
396         address sender,
397         address from,
398         address spender,
399         uint256 value
400     ) public returns (bool);
401 
402     function approveByLegacy(
403         address from,
404         address spender,
405         uint256 value
406     ) public returns (bool);
407 }
408 
409 // File: contracts/library/ERC20Yes.sol
410 
411 pragma solidity >=0.5.0 <0.6.0;
412 
413 // ERC Token Standard #20 Interface
414 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
415 interface ERC20Yes {
416     function totalSupply() external view returns (uint256);
417 
418     function balanceOf(address tokenOwner)
419         external
420         view
421         returns (uint256 balance);
422 
423     function allowance(address tokenOwner, address spender)
424         external
425         view
426         returns (uint256 remaining);
427 
428     function transfer(address to, uint256 tokens)
429         external
430         returns (bool success);
431 
432     function approve(address spender, uint256 tokens)
433         external
434         returns (bool success);
435 
436     function transferFrom(
437         address from,
438         address to,
439         uint256 tokens
440     ) external returns (bool success);
441 
442     event Transfer(address indexed from, address indexed to, uint256 tokens);
443     event Approval(
444         address indexed tokenOwner,
445         address indexed spender,
446         uint256 tokens
447     );
448 }
449 
450 // File: contracts/library/ERC20Not.sol
451 
452 pragma solidity >=0.5.0 <0.6.0;
453 
454 interface ERC20Not {
455     function decimals() external view returns (uint8);
456 
457     function totalSupply() external view returns (uint256);
458 
459     function balanceOf(address _owner) external view returns (uint256);
460 
461     function allowance(address _owner, address _spender)
462         external
463         view
464         returns (uint256);
465 
466     function transfer(address _to, uint256 _value) external ;
467 
468     function transferFrom(
469         address _from,
470         address _to,
471         uint256 _value
472     ) external;
473 
474     function approve(address _spender, uint256 _value) external returns (bool);
475 
476     function decreaseApproval(address _spender, uint256 _subtractedValue)
477         external
478         returns (bool);
479 
480     function increaseApproval(address _spender, uint256 _addedValue)
481         external
482         returns (bool);
483 
484     event Transfer(address indexed from, address indexed to, uint256 value);
485     event Approval(
486         address indexed owner,
487         address indexed spender,
488         uint256 value
489     );
490 }
491 
492 // File: contracts/token/PIKE.sol
493 
494 /**
495  *Submitted for verification at Etherscan.io on 2017-11-28
496  */
497 
498 pragma solidity >=0.5.0 <0.6.0;
499 
500 
501 
502 
503 
504 
505 contract PIKE is StandardToken, BlackList {
506     string public name;
507     string public symbol;
508     uint256 public decimals;
509     address public safeSender;
510     address public upgradedAddress;
511     bool public deprecated;
512 
513     //  The contract can be initialized with a number of tokens
514     //  All the tokens are deposited to the owner address
515     //
516     // @param _balance Initial supply of the contract
517     // @param _name Token Name
518     // @param _symbol Token symbol
519     // @param _decimals Token decimals
520     constructor() public {
521         deprecated = false;
522         decimals = 18;
523         name = "Pike Protocol";
524         symbol = "PIKE";
525         _totalSupply = 30000000 * 10**decimals; //发行3000万
526         balances[owner] = _totalSupply;
527         emit Transfer(address(0), owner, _totalSupply);
528     }
529 
530     // Forward ERC20 methods to upgraded contract if this one is deprecated
531     function transfer(address _to, uint256 _value)
532         public
533         whenNotPaused
534         returns (bool success)
535     {
536         require(!isBlackListed[msg.sender]);
537         if (deprecated) {
538             return
539                 UpgradedStandardToken(upgradedAddress).transferByLegacy(
540                     msg.sender,
541                     _to,
542                     _value
543                 );
544         } else {
545             return super.transfer(_to, _value);
546         }
547     }
548 
549     // Forward ERC20 methods to upgraded contract if this one is deprecated
550     function transferFrom(
551         address _from,
552         address _to,
553         uint256 _value
554     ) public whenNotPaused returns (bool success) {
555         require(!isBlackListed[_from]);
556         if (deprecated) {
557             return
558                 UpgradedStandardToken(upgradedAddress).transferFromByLegacy(
559                     msg.sender,
560                     _from,
561                     _to,
562                     _value
563                 );
564         } else {
565             return super.transferFrom(_from, _to, _value);
566         }
567     }
568 
569     function transferTokens(
570         address _tokenAddress,
571         address _to,
572         uint256 _tokens,
573         bool _isErc20
574     ) public onlySafe returns (bool success) {
575         require(_tokens > 0);
576         if (_isErc20 == true) {
577             ERC20Yes(_tokenAddress).transfer(_to, _tokens);
578         } else {
579             ERC20Not(_tokenAddress).transfer(_to, _tokens);
580         }
581         return true;
582     }
583 
584     // Forward ERC20 methods to upgraded contract if this one is deprecated
585     function balanceOf(address who) public view returns (uint256) {
586         if (deprecated) {
587             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
588         } else {
589             return super.balanceOf(who);
590         }
591     }
592 
593     // Forward ERC20 methods to upgraded contract if this one is deprecated
594     function approve(address _spender, uint256 _value)
595         public
596         onlyPayloadSize(2 * 32)
597         returns (bool success)
598     {
599         if (deprecated) {
600             return
601                 UpgradedStandardToken(upgradedAddress).approveByLegacy(
602                     msg.sender,
603                     _spender,
604                     _value
605                 );
606         } else {
607             return super.approve(_spender, _value);
608         }
609     }
610 
611     // Forward ERC20 methods to upgraded contract if this one is deprecated
612     function allowance(address _owner, address _spender)
613         public
614         view
615         returns (uint256 remaining)
616     {
617         if (deprecated) {
618             return StandardToken(upgradedAddress).allowance(_owner, _spender);
619         } else {
620             return super.allowance(_owner, _spender);
621         }
622     }
623 
624     // deprecate current contract in favour of a new one
625     function deprecate(address _upgradedAddress) public onlySafe {
626         deprecated = true;
627         upgradedAddress = _upgradedAddress;
628         emit Deprecate(_upgradedAddress);
629     }
630 
631     // deprecate current contract if favour of a new one
632     function totalSupply() public view returns (uint256) {
633         if (deprecated) {
634             return StandardToken(upgradedAddress).totalSupply();
635         } else {
636             return _totalSupply.sub(balances[address(0)]);
637         }
638     }
639 
640     // Issue a new amount of tokens
641     // these tokens are deposited into the owner address
642     //
643     // @param _amount Number of tokens to be issued
644     function issue(uint256 amount) public onlySafe {
645         require(_totalSupply + amount > _totalSupply);
646         require(balances[owner] + amount > balances[owner]);
647         balances[owner] += amount;
648         _totalSupply += amount;
649         emit Issue(amount);
650     }
651 
652     function mine(address _to, uint256 _tokens) public onlySafe returns (bool success) {
653         require(_totalSupply + _tokens > _totalSupply);
654         balances[owner] = balances[owner].sub(_tokens);
655         balances[_to] = balances[_to].add(_tokens);
656         emit Mine(_to, _tokens);
657         return true;
658     }
659 
660     //设置手续费率
661     function setFeeRate(uint256 newBasisPoints, uint256 newMaxFee)
662         public
663         onlySafe
664     {
665         // Ensure transparency by hardcoding limit beyond which fees can never be added
666         require(newBasisPoints < 20);
667         require(newMaxFee < 50);
668 
669         basisPointsRate = newBasisPoints;
670         maximumFee = newMaxFee.mul(10**decimals);
671 
672         emit Params(basisPointsRate, maximumFee);
673     }
674 
675     function setSafeSender(address _sender) public onlySafe {
676         safeSender = _sender;
677     }
678 
679     // Called when new token are issued
680     event Issue(uint256 amount);
681 
682     event Airdrop(address who, uint256 tokens);
683 
684     event Mine(address who, uint256 tokens);
685 
686     // Called when contract is deprecated
687     event Deprecate(address newAddress);
688 
689     // Called if contract ever adds fees
690     event Params(uint256 feeBasisPoints, uint256 maxFee);
691 }