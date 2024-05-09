1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title ERC20
5  * @dev ERC20 interface
6  */
7 contract ERC20 {
8     function balanceOf(address who) public constant returns (uint256);
9     function transfer(address to, uint256 value) public returns (bool);
10     function allowance(address owner, address spender) public constant returns (uint256);
11     function transferFrom(address from, address to, uint256 value) public returns (bool);
12     function approve(address spender, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) onlyOwner public {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 /// @dev Crowdsale interface for Etheal Normal Sale, functions needed from outside.
61 contract iEthealSale {
62     bool public paused;
63     uint256 public minContribution;
64     uint256 public whitelistThreshold;
65     mapping (address => uint256) public stakes;
66     function setPromoBonus(address _investor, uint256 _value) public;
67     function buyTokens(address _beneficiary) public payable;
68     function depositEth(address _beneficiary, uint256 _time, bytes _whitelistSign) public payable;
69     function depositOffchain(address _beneficiary, uint256 _amount, uint256 _time) public;
70     function hasEnded() public constant returns (bool);
71 }
72 
73 
74 
75 
76 
77 
78 /**
79  * @title claim accidentally sent tokens
80  */
81 contract HasNoTokens is Ownable {
82     event ExtractedTokens(address indexed _token, address indexed _claimer, uint _amount);
83 
84     /// @notice This method can be used to extract mistakenly
85     ///  sent tokens to this contract.
86     /// @param _token The address of the token contract that you want to recover
87     ///  set to 0 in case you want to extract ether.
88     /// @param _claimer Address that tokens will be send to
89     function extractTokens(address _token, address _claimer) onlyOwner public {
90         if (_token == 0x0) {
91             _claimer.transfer(this.balance);
92             return;
93         }
94 
95         ERC20 token = ERC20(_token);
96         uint balance = token.balanceOf(this);
97         token.transfer(_claimer, balance);
98         ExtractedTokens(_token, _claimer, balance);
99     }
100 }
101 
102 
103 
104 
105 
106 /**
107  * @title SafeMath
108  * @dev Math operations with safety checks that throw on error
109  */
110 library SafeMath {
111   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112     uint256 c = a * b;
113     assert(a == 0 || c / a == b);
114     return c;
115   }
116 
117   function div(uint256 a, uint256 b) internal pure returns (uint256) {
118     // assert(b > 0); // Solidity automatically throws when dividing by 0
119     uint256 c = a / b;
120     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121     return c;
122   }
123 
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   function add(uint256 a, uint256 b) internal pure returns (uint256) {
130     uint256 c = a + b;
131     assert(c >= a);
132     return c;
133   }
134 }
135 
136 /*
137  * ERC-20 Standard Token Smart Contract Interface.
138  * Copyright © 2016–2017 by ABDK Consulting.
139  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
140  */
141 
142 /**
143  * ERC-20 standard token interface, as defined
144  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
145  */
146 contract Token {
147     /**
148      * Get total number of tokens in circulation.
149      *
150      * @return total number of tokens in circulation
151      */
152     function totalSupply () view returns (uint256 supply);
153 
154     /**
155      * Get number of tokens currently belonging to given owner.
156      *
157      * @param _owner address to get number of tokens currently belonging to the
158      *        owner of
159      * @return number of tokens currently belonging to the owner of given address
160      */
161     function balanceOf (address _owner) view returns (uint256 balance);
162 
163     /**
164      * Transfer given number of tokens from message sender to given recipient.
165      *
166      * @param _to address to transfer tokens to the owner of
167      * @param _value number of tokens to transfer to the owner of given address
168      * @return true if tokens were transferred successfully, false otherwise
169      */
170     function transfer (address _to, uint256 _value) returns (bool success);
171 
172     /**
173      * Transfer given number of tokens from given owner to given recipient.
174      *
175      * @param _from address to transfer tokens from the owner of
176      * @param _to address to transfer tokens to the owner of
177      * @param _value number of tokens to transfer from given owner to given
178      *        recipient
179      * @return true if tokens were transferred successfully, false otherwise
180      */
181     function transferFrom (address _from, address _to, uint256 _value) returns (bool success);
182 
183     /**
184      * Allow given spender to transfer given number of tokens from message sender.
185      *
186      * @param _spender address to allow the owner of to transfer tokens from
187      *        message sender
188      * @param _value number of tokens to allow to transfer
189      * @return true if token transfer was successfully approved, false otherwise
190      */
191     function approve (address _spender, uint256 _value) returns (bool success);
192 
193     /**
194      * Tell how many tokens given spender is currently allowed to transfer from
195      * given owner.
196      *
197      * @param _owner address to get number of tokens allowed to be transferred
198      *        from the owner of
199      * @param _spender address to get number of tokens allowed to be transferred
200      *        by the owner of
201      * @return number of tokens given spender is currently allowed to transfer
202      *         from given owner
203      */
204     function allowance (address _owner, address _spender) view returns (uint256 remaining);
205 
206     /**
207      * Logged when tokens were transferred from one owner to another.
208      *
209      * @param _from address of the owner, tokens were transferred from
210      * @param _to address of the owner, tokens were transferred to
211      * @param _value number of tokens transferred
212      */
213     event Transfer (address indexed _from, address indexed _to, uint256 _value);
214 
215     /**
216      * Logged when owner approved his tokens to be transferred by some spender.
217      *
218      * @param _owner owner who approved his tokens to be transferred
219      * @param _spender spender who were allowed to transfer the tokens belonging
220      *        to the owner
221      * @param _value number of tokens belonging to the owner, approved to be
222      *        transferred by the spender
223      */
224     event Approval (address indexed _owner, address indexed _spender, uint256 _value);
225 }
226 
227 /*
228  * Abstract Token Smart Contract.  Copyright © 2017 by ABDK Consulting.
229  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
230  * Modified to use SafeMath library by thesved
231  */
232 /**
233  * Abstract Token Smart Contract that could be used as a base contract for
234  * ERC-20 token contracts.
235  */
236 contract AbstractToken is Token {
237     using SafeMath for uint;
238 
239     /**
240      * Create new Abstract Token contract.
241      */
242     function AbstractToken () {
243         // Do nothing
244     }
245 
246     /**
247      * Get number of tokens currently belonging to given owner.
248      *
249      * @param _owner address to get number of tokens currently belonging to the owner
250      * @return number of tokens currently belonging to the owner of given address
251      */
252     function balanceOf (address _owner) view returns (uint256 balance) {
253         return accounts[_owner];
254     }
255 
256     /**
257      * Transfer given number of tokens from message sender to given recipient.
258      *
259      * @param _to address to transfer tokens to the owner of
260      * @param _value number of tokens to transfer to the owner of given address
261      * @return true if tokens were transferred successfully, false otherwise
262      */
263     function transfer (address _to, uint256 _value) returns (bool success) {
264         uint256 fromBalance = accounts[msg.sender];
265         if (fromBalance < _value) return false;
266         if (_value > 0 && msg.sender != _to) {
267             accounts[msg.sender] = fromBalance.sub(_value);
268             accounts[_to] = accounts[_to].add(_value);
269             Transfer(msg.sender, _to, _value);
270         }
271         return true;
272     }
273 
274     /**
275      * Transfer given number of tokens from given owner to given recipient.
276      *
277      * @param _from address to transfer tokens from the owner of
278      * @param _to address to transfer tokens to the owner of
279      * @param _value number of tokens to transfer from given owner to given recipient
280      * @return true if tokens were transferred successfully, false otherwise
281      */
282     function transferFrom (address _from, address _to, uint256 _value) returns (bool success) {
283         uint256 spenderAllowance = allowances[_from][msg.sender];
284         if (spenderAllowance < _value) return false;
285         uint256 fromBalance = accounts[_from];
286         if (fromBalance < _value) return false;
287 
288         allowances[_from][msg.sender] = spenderAllowance.sub(_value);
289 
290         if (_value > 0 && _from != _to) {
291             accounts[_from] = fromBalance.sub(_value);
292             accounts[_to] = accounts[_to].add(_value);
293             Transfer(_from, _to, _value);
294         }
295         return true;
296     }
297 
298     /**
299      * Allow given spender to transfer given number of tokens from message sender.
300      *
301      * @param _spender address to allow the owner of to transfer tokens from
302      *        message sender
303      * @param _value number of tokens to allow to transfer
304      * @return true if token transfer was successfully approved, false otherwise
305      */
306     function approve (address _spender, uint256 _value) returns (bool success) {
307         allowances[msg.sender][_spender] = _value;
308         Approval(msg.sender, _spender, _value);
309 
310         return true;
311     }
312 
313     /**
314      * Tell how many tokens given spender is currently allowed to transfer from
315      * given owner.
316      *
317      * @param _owner address to get number of tokens allowed to be transferred from the owner
318      * @param _spender address to get number of tokens allowed to be transferred by the owner
319      * @return number of tokens given spender is currently allowed to transfer from given owner
320      */
321     function allowance (address _owner, address _spender) view returns (uint256 remaining) {
322         return allowances[_owner][_spender];
323     }
324 
325     /**
326      * Mapping from addresses of token holders to the numbers of tokens belonging
327      * to these token holders.
328      */
329     mapping (address => uint256) accounts;
330 
331     /**
332      * Mapping from addresses of token holders to the mapping of addresses of
333      * spenders to the allowances set by these token holders to these spenders.
334      */
335     mapping (address => mapping (address => uint256)) private allowances;
336 }
337 
338 
339 /*
340  * Abstract Virtual Token Smart Contract.  Copyright © 2017 by ABDK Consulting.
341  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
342  * Modified to use SafeMath library by thesved
343  */
344 
345 /**
346  * Abstract Token Smart Contract that could be used as a base contract for
347  * ERC-20 token contracts supporting virtual balance.
348  */
349 contract AbstractVirtualToken is AbstractToken {
350     using SafeMath for uint;
351 
352     /**
353      * Maximum number of real (i.e. non-virtual) tokens in circulation (2^255-1).
354      */
355     uint256 constant MAXIMUM_TOKENS_COUNT = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
356 
357     /**
358      * Mask used to extract real balance of an account (2^255-1).
359      */
360     uint256 constant BALANCE_MASK = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
361 
362     /**
363      * Mask used to extract "materialized" flag of an account (2^255).
364      */
365     uint256 constant MATERIALIZED_FLAG_MASK = 0x8000000000000000000000000000000000000000000000000000000000000000;
366 
367     /**
368      * Create new Abstract Virtual Token contract.
369      */
370     function AbstractVirtualToken () {
371         // Do nothing
372     }
373 
374     /**
375      * Get total number of tokens in circulation.
376      *
377      * @return total number of tokens in circulation
378      */
379     function totalSupply () view returns (uint256 supply) {
380         return tokensCount;
381     }
382 
383     /**
384      * Get number of tokens currently belonging to given owner.
385      *
386      * @param _owner address to get number of tokens currently belonging to the owner
387      * @return number of tokens currently belonging to the owner of given address
388     */
389     function balanceOf (address _owner) constant returns (uint256 balance) { 
390         return (accounts[_owner] & BALANCE_MASK).add(getVirtualBalance(_owner));
391     }
392 
393     /**
394      * Transfer given number of tokens from message sender to given recipient.
395      *
396      * @param _to address to transfer tokens to the owner of
397      * @param _value number of tokens to transfer to the owner of given address
398      * @return true if tokens were transferred successfully, false otherwise
399      */
400     function transfer (address _to, uint256 _value) returns (bool success) {
401         if (_value > balanceOf(msg.sender)) return false;
402         else {
403             materializeBalanceIfNeeded(msg.sender, _value);
404             return AbstractToken.transfer(_to, _value);
405         }
406     }
407 
408     /**
409      * Transfer given number of tokens from given owner to given recipient.
410      *
411      * @param _from address to transfer tokens from the owner of
412      * @param _to address to transfer tokens to the owner of
413      * @param _value number of tokens to transfer from given owner to given
414      *        recipient
415      * @return true if tokens were transferred successfully, false otherwise
416      */
417     function transferFrom (address _from, address _to, uint256 _value) returns (bool success) {
418         if (_value > allowance(_from, msg.sender)) return false;
419         if (_value > balanceOf(_from)) return false;
420         else {
421             materializeBalanceIfNeeded(_from, _value);
422             return AbstractToken.transferFrom(_from, _to, _value);
423         }
424     }
425 
426     /**
427      * Get virtual balance of the owner of given address.
428      *
429      * @param _owner address to get virtual balance for the owner of
430      * @return virtual balance of the owner of given address
431      */
432     function virtualBalanceOf (address _owner) internal view returns (uint256 _virtualBalance);
433 
434     /**
435      * Calculate virtual balance of the owner of given address taking into account
436      * materialized flag and total number of real tokens already in circulation.
437      */
438     function getVirtualBalance (address _owner) private view returns (uint256 _virtualBalance) {
439         if (accounts [_owner] & MATERIALIZED_FLAG_MASK != 0) return 0;
440         else {
441             _virtualBalance = virtualBalanceOf(_owner);
442             uint256 maxVirtualBalance = MAXIMUM_TOKENS_COUNT.sub(tokensCount);
443             if (_virtualBalance > maxVirtualBalance)
444                 _virtualBalance = maxVirtualBalance;
445         }
446     }
447 
448     /**
449      * Materialize virtual balance of the owner of given address if this will help
450      * to transfer given number of tokens from it.
451      *
452      * @param _owner address to materialize virtual balance of
453      * @param _value number of tokens to be transferred
454      */
455     function materializeBalanceIfNeeded (address _owner, uint256 _value) private {
456         uint256 storedBalance = accounts[_owner];
457         if (storedBalance & MATERIALIZED_FLAG_MASK == 0) {
458             // Virtual balance is not materialized yet
459             if (_value > storedBalance) {
460                 // Real balance is not enough
461                 uint256 virtualBalance = getVirtualBalance(_owner);
462                 require (_value.sub(storedBalance) <= virtualBalance);
463                 accounts[_owner] = MATERIALIZED_FLAG_MASK | storedBalance.add(virtualBalance);
464                 tokensCount = tokensCount.add(virtualBalance);
465             }
466         }
467     }
468 
469     /**
470     * Number of real (i.e. non-virtual) tokens in circulation.
471     */
472     uint256 tokensCount;
473 }
474 
475 
476 /**
477  * Etheal Promo ERC-20 contract
478  * Author: thesved
479  */
480 contract EthealPromoToken is HasNoTokens, AbstractVirtualToken {
481     // Balance threshold to assign virtual tokens to the owner of higher balances then this threshold.
482     uint256 private constant VIRTUAL_THRESHOLD = 0.1 ether;
483 
484     // Number of virtual tokens to assign to the owners of balances higher than virtual threshold.
485     uint256 private constant VIRTUAL_COUNT = 911;
486 
487     // crowdsale to set bonus when sending token
488     iEthealSale public crowdsale;
489 
490 
491     ////////////////
492     // Basic functions
493     ////////////////
494 
495     /// @dev Constructor, crowdsale address can be 0x0
496     function EthealPromoToken(address _crowdsale) {
497         crowdsale = iEthealSale(_crowdsale);
498     }
499 
500     /// @dev Setting crowdsale, crowdsale address can be 0x0
501     function setCrowdsale(address _crowdsale) public onlyOwner {
502         crowdsale = iEthealSale(_crowdsale);
503     }
504 
505     /// @notice Get virtual balance of the owner of given address.
506     /// @param _owner address to get virtual balance for the owner
507     /// @return virtual balance of the owner of given address
508     function virtualBalanceOf(address _owner) internal view returns (uint256) {
509         return _owner.balance >= VIRTUAL_THRESHOLD ? VIRTUAL_COUNT : 0;
510     }
511 
512     /// @notice Get name of this token.
513     function name() public pure returns (string result) {
514         return "An Etheal Promo";
515     }
516 
517     /// @notice Get symbol of this token.
518     function symbol() public pure returns (string result) {
519         return "HEALP";
520     }
521 
522     /// @notice Get number of decimals for this token.
523     function decimals() public pure returns (uint8 result) {
524         return 0;
525     }
526 
527 
528     ////////////////
529     // Set sale bonus
530     ////////////////
531 
532     /// @dev Internal function for setting sale bonus
533     function setSaleBonus(address _from, address _to, uint256 _value) internal {
534         if (address(crowdsale) == address(0)) return;
535         if (_value == 0) return;
536 
537         if (_to == address(1) || _to == address(this) || _to == address(crowdsale)) {
538             crowdsale.setPromoBonus(_from, _value);
539         }
540     }
541 
542     /// @dev Override transfer function to set sale bonus
543     function transfer(address _to, uint256 _value) public returns (bool) {
544         bool success = super.transfer(_to, _value); 
545 
546         if (success) {
547             setSaleBonus(msg.sender, _to, _value);
548         }
549 
550         return success;
551     }
552 
553     /// @dev Override transfer function to set sale bonus
554     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
555         bool success = super.transferFrom(_from, _to, _value);
556 
557         if (success) {
558             setSaleBonus(_from, _to, _value);
559         }
560 
561         return success;
562     }
563 
564 
565     ////////////////
566     // Extra
567     ////////////////
568 
569     /// @notice Notify owners about their virtual balances.
570     function massNotify(address[] _owners) public onlyOwner {
571         for (uint256 i = 0; i < _owners.length; i++) {
572             Transfer(address(0), _owners[i], VIRTUAL_COUNT);
573         }
574     }
575 
576     /// @notice Kill this smart contract.
577     function kill() public onlyOwner {
578         selfdestruct(owner);
579     }
580 
581     
582 }