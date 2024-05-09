1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
29         c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      */
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256 c) {
58         require(b <= a, errorMessage);
59         c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      */
113     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256 c) {
114         // Solidity only automatically asserts when dividing by 0
115         require(b > 0, errorMessage);
116         c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119         return c;
120     }
121 }
122 
123 /**
124  * @dev Collection of functions related to the address type
125  */
126 library Address {
127     /**
128      * @dev Returns true if `account` is a contract.
129      *
130      * This test is non-exhaustive, and there may be false-negatives: during the
131      * execution of a contract's constructor, its address will be reported as
132      * not containing a contract.
133      *
134      * IMPORTANT: It is unsafe to assume that an address for which this
135      * function returns false is an externally-owned account (EOA) and not a
136      * contract.
137      */
138     function isContract(address account) internal view returns (bool) {
139         // This method relies in extcodesize, which returns 0 for contracts in
140         // construction, since the code is only stored at the end of the
141         // constructor execution.
142 
143         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
144         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
145         // for accounts without code, i.e. `keccak256('')`
146         bytes32 codehash;
147         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
148         // solhint-disable-next-line no-inline-assembly
149         assembly { codehash := extcodehash(account) }
150         return (codehash != 0x0 && codehash != accountHash);
151     }
152 
153     /**
154      * @dev Converts an `address` into `address payable`. Note that this is
155      * simply a type cast: the actual underlying value is not changed.
156      *
157      * _Available since v2.4.0._
158      */
159     function toPayable(address account) internal pure returns (address payable) {
160         return address(uint160(account));
161     }
162 }
163 
164 
165 /**
166  * @title ERC20Basic
167  * @dev Simpler version of ERC20 interface
168  * See https://github.com/ethereum/EIPs/issues/179
169  */
170 interface ERC20Basic {
171     function totalSupply() external view returns (uint256);
172     function balanceOf(address who) external view returns (uint256);
173     function transfer(address to, uint256 value) external returns (bool);
174     event Transfer(
175         address indexed _from,
176         address indexed _to,
177         uint256 _value
178     );
179 }
180 
181 
182 /**
183  * @title Basic token
184  * @dev Basic version of StandardToken, with no allowances.
185  */
186 contract BasicToken is ERC20Basic {
187     using SafeMath for uint256;
188 
189     uint256 totalSupply_;
190 
191     mapping(address => uint256) balances;
192 
193     /**
194      * @dev Total number of tokens in existence
195      */
196     function totalSupply() public view override returns (uint256) {
197         return totalSupply_;
198     }
199 
200     /**
201      * @dev Transfer token for a specified address
202      * @param _to The address to transfer to.
203      * @param _value The amount to be transferred.
204      */
205     function transfer(address _to, uint256 _value) public override returns (bool) {
206         return _transfer(msg.sender, _to, _value);
207     }
208 
209     /**
210      * @dev Transfer token for a specified address
211      * @param _from The address to transfer from.
212      * @param _to The address to transfer to.
213      * @param _value The amount to be transferred.
214      */
215     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
216         require(_to != address(0), "transfer addr is the zero address");
217         require(_value <= balances[_from], "lack of balance");
218 
219         balances[_from] = balances[_from].sub(_value);
220         balances[_to] = balances[_to].add(_value);
221         emit Transfer(_from, _to, _value);
222         return true;
223     }
224 
225     /**
226      * @dev Gets the balance of the specified address.
227      * @param _owner The address to query the the balance of.
228      * @return An uint256 representing the amount owned by the passed address.
229      */
230     function balanceOf(address _owner) public view override returns (uint256) {
231         return balances[_owner];
232     }
233 }
234 
235 
236 /**
237  * @title ERC20 interface
238  * @dev see https://github.com/ethereum/EIPs/issues/20
239  */
240 interface ERC20 is ERC20Basic {
241     function allowance(address owner, address spender) external view returns (uint256);
242     function transferFrom(address from, address to, uint256 value) external returns (bool);
243     function approve(address spender, uint256 value) external returns (bool);
244     event Approval(
245         address indexed _owner,
246         address indexed _spender,
247         uint256 _value
248     );
249 }
250 
251 
252 /**
253  * @title Standard ERC20 token
254  *
255  * @dev Implementation of the basic standard token.
256  * https://github.com/ethereum/EIPs/issues/20
257  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
258  */
259 contract StandardToken is ERC20, BasicToken {
260     mapping (address => mapping (address => uint256)) internal allowed;
261 
262     /**
263      * @dev Transfer tokens from one address to another
264      * @param _from address The address which you want to send tokens from
265      * @param _to address The address which you want to transfer to
266      * @param _value uint256 the amount of tokens to be transferred
267      */
268     function transferFrom(
269         address _from,
270         address _to,
271         uint256 _value
272     )
273         public
274         override
275         returns (bool)
276     {
277         require(_to != address(0), "transfer addr is the zero address");
278         require(_value <= balances[_from], "lack of balance");
279         require(_value <= allowed[_from][msg.sender], "lack of transfer balance allowed");
280         
281         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
282         balances[_from] = balances[_from].sub(_value);
283         balances[_to] = balances[_to].add(_value);
284 
285         emit Transfer(_from, _to, _value);
286         return true;
287     }
288 
289     /**
290      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
291      * Beware that changing an allowance with this method brings the risk that someone may use both the old
292      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
293      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
294      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
295      * @param _spender The address which will spend the funds.
296      * @param _value The amount of tokens to be spent.
297      */
298     function approve(address _spender, uint256 _value) public override returns (bool) {
299         // avoid race condition
300         require((_value == 0) || (allowed[msg.sender][_spender] == 0), "reset allowance to 0 before change it's value.");
301         allowed[msg.sender][_spender] = _value;
302         emit Approval(msg.sender, _spender, _value);
303         return true;
304     }
305 
306     /**
307      * @dev Function to check the amount of tokens that an owner allowed to a spender.
308      * @param _owner address The address which owns the funds.
309      * @param _spender address The address which will spend the funds.
310      * @return A uint256 specifying the amount of tokens still available for the spender.
311      */
312     function allowance(
313         address _owner,
314         address _spender
315     )
316         public
317         view
318         override
319         returns (uint256)
320     {
321         return allowed[_owner][_spender];
322     }
323 }
324 
325 
326 contract Token_StandardToken is StandardToken {
327     // region{fields}
328     string public name;
329     string public symbol;
330     uint8 public decimals;
331 
332     // region{Constructor}
333     // note : [(final)totalSupply] >> claimAmount * 10 ** decimals
334     // example : args << "The Kh Token No.X", "ABC", "10000000000", "18"
335     constructor(
336         string memory _token_name,
337         string memory _symbol,
338         uint256 _claim_amount,
339         uint8 _decimals,
340         address minaddr
341     ) public {
342         name = _token_name;
343         symbol = _symbol;
344         decimals = _decimals;
345         totalSupply_ = _claim_amount.mul(10 ** uint256(decimals));
346         balances[minaddr] = totalSupply_;
347         emit Transfer(address(0), minaddr, totalSupply_);
348     }
349 }
350 
351 /**
352  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
353  * the optional functions; to access them see {ERC20Detailed}.
354  * USDT transfer and transferFrom not returns
355  */
356 interface ITokenERC20_USDT {
357     /**
358      * @dev Returns the amount of tokens owned by `account`.
359      */
360     function balanceOf(address account) external view returns (uint256);
361 
362     /**
363      * @dev Moves `amount` tokens from the caller's account to `recipient`.
364      *
365      * Returns a boolean value indicating whether the operation succeeded.
366      *
367      * Emits a {Transfer} event.
368      */
369     function transfer(address recipient, uint256 amount) external;
370 
371     /**
372      * @dev Moves `amount` tokens from `sender` to `recipient` using the
373      * allowance mechanism. `amount` is then deducted from the caller's
374      * allowance.
375      *
376      * Returns a boolean value indicating whether the operation succeeded.
377      *
378      * Emits a {Transfer} event.
379      */
380     function transferFrom(address sender, address recipient, uint256 amount) external;
381 }
382 
383 /**
384  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
385  * the optional functions; to access them see {ERC20Detailed}.
386  */
387 interface ITokenERC20 {
388     /**
389      * @dev Returns the amount of tokens owned by `account`.
390      */
391     function balanceOf(address account) external view returns (uint256);
392 
393     /**
394      * @dev Moves `amount` tokens from the caller's account to `recipient`.
395      *
396      * Returns a boolean value indicating whether the operation succeeded.
397      *
398      * Emits a {Transfer} event.
399      */
400     function transfer(address recipient, uint256 amount) external returns (bool);
401 
402     /**
403      * @dev Moves `amount` tokens from `sender` to `recipient` using the
404      * allowance mechanism. `amount` is then deducted from the caller's
405      * allowance.
406      *
407      * Returns a boolean value indicating whether the operation succeeded.
408      *
409      * Emits a {Transfer} event.
410      */
411     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
412 }
413 
414 /**
415  * @title DB
416  * @dev This Provide database support services
417  */
418 contract DB  {
419     //lib using list
420 
421 	struct UserInfo {
422 		uint id;
423         address code;
424 		address rCode;
425 	}
426 
427 	uint _uid = 0;
428 	mapping(uint => address) indexMapping;//UID address Mapping
429     mapping(address => address) addressMapping;//inviteCode address Mapping
430     mapping(address => UserInfo) userInfoMapping;//address UserInfo Mapping
431 
432     /**
433      * @dev Create store user information
434      * @param addr user addr
435      * @param code user invite Code
436      * @param rCode recommend code
437      */
438     function _registerUser(address addr, address code, address rCode)
439         internal
440     {
441 		UserInfo storage userInfo = userInfoMapping[addr];
442         if (userInfo.id == 0) {
443             if (_uid != 0) {
444                 require(isUsedCode(rCode), "DB: rCode not exist");
445                 address pAddr = addressMapping[rCode];
446                 require(pAddr != msg.sender, "DB: rCode can't be self");
447                 userInfo.rCode = rCode;
448             }
449 
450             require(!isUsedCode(code), "DB: code is used");
451             require(code != address(0), "DB: invalid invite code");
452 
453             _uid++;
454             userInfo.id = _uid;
455             userInfo.code = code;
456 
457             addressMapping[code] = addr;
458             indexMapping[_uid] = addr;
459         }
460 	}
461 
462     /**
463      * @dev determine if user invite code is use
464      * @param code user invite Code
465      * @return bool
466      */
467     function _isUsedCode(address code)
468         internal
469         view
470         returns (bool)
471     {
472 		return addressMapping[code] != address(0);
473 	}
474 
475     /**
476      * @dev get the user address of the corresponding user invite code
477      * Authorization Required
478      * @param code user invite Code
479      * @return address
480      */
481     function _getCodeMapping(address code)
482         internal
483         view
484         returns (address)
485     {
486 		return addressMapping[code];
487 	}
488 
489     /**
490      * @dev get the user address of the corresponding user id
491      * Authorization Required
492      * @param uid user id
493      * @return address
494      */
495     function _getIndexMapping(uint uid)
496         internal
497         view
498         returns (address)
499     {
500 		return indexMapping[uid];
501 	}
502 
503     /**
504      * @dev get the user address of the corresponding User info
505      * Authorization Required or addr is owner
506      * @param addr user address
507      * @return info info[id,status,level,levelStatus]
508      * @return code code
509      * @return rCode rCode
510      */
511     function _getUserInfo(address addr)
512         internal
513         view
514         returns (uint[1] memory info, address code, address rCode)
515     {
516 		UserInfo memory userInfo = userInfoMapping[addr];
517 		info[0] = userInfo.id;
518 
519 		return (info, userInfo.code, userInfo.rCode);
520 	}
521 
522     /**
523      * @dev get the current latest ID
524      * Authorization Required
525      * @return current uid
526      */
527     function _getCurrentUserID()
528         internal
529         view
530         returns (uint)
531     {
532 		return _uid;
533 	}
534 
535     /**
536      * @dev determine if user invite code is use
537      * @param code user invite Code
538      * @return bool
539      */
540     function isUsedCode(address code)
541         public
542         view
543         returns (bool)
544     {
545 		return _isUsedCode(code);
546 	}
547 }
548 
549 
550 /**
551  * @title Utillibrary
552  * @dev This integrates the basic functions.
553  */
554 contract Utillibrary is Token_StandardToken {
555     //lib using list
556 	using SafeMath for *;
557     using Address for address;
558 
559     //base param setting
560     // uint internal ethWei = 1 ether;
561     uint internal USDTWei = 10 ** 6;
562     uint internal ETTWei = 10 ** 18;
563     uint internal USDT_ETTWei_Ratio = 10 ** 12;
564 
565     constructor() 
566         Token_StandardToken("EAS", "EAS", 11000000, 18, address(this))
567         public
568     {
569 
570     }
571 
572     /**
573      * @dev modifier to scope access to a Contract (uses tx.origin and msg.sender)
574      */
575 	modifier isHuman() {
576 		require(msg.sender == tx.origin, "humans only");
577 		_;
578 	}
579 
580     /**
581      * @dev check Zero Addr
582      */
583 	modifier checkZeroAddr(address addr) {
584 		require(addr != address(0), "zero addr");
585 		_;
586 	}
587 
588     /**
589      * @dev check Addr is Contract
590      */
591 	modifier checkIsContract(address addr) {
592 		require(addr.isContract(), "not token addr");
593 		_;
594 	}
595 
596     /**
597      * @dev check User ID
598      * @param uid user ID
599      */
600     function checkUserID(uint uid)
601         internal
602         pure
603     {
604         require(uid != 0, "user not exist");
605 	}
606 
607     /**
608      * @dev Transfer to designated user
609      * @param _addr user address
610      * @param _val transfer-out amount
611      */
612 	function sendTokenToUser(address _addr, uint _val)
613         internal
614     {
615 		if (_val > 0) {
616             _transfer(address(this), _addr, _val);//erc20 internal Function
617 		}
618 	}
619 
620     /**
621      * @dev Gets the amount from the specified user
622      * @param _addr user address
623      * @param _val transfer-get amount
624      */
625 	function getTokenFormUser(address _addr, uint _val)
626         internal
627     {
628 		if (_val > 0) {
629             _transfer(_addr, address(this), _val);//erc20 internal Function
630 		}
631 	}
632 
633     /**
634      * @dev Transfer to designated user
635      * USDT transfer and transferFrom not returns
636      * @param _taddr token address
637      * @param _addr user address
638      * @param _val transfer-out amount
639      */
640 	function sendTokenToUser_USDT(address _taddr, address _addr, uint _val)
641         internal
642         checkZeroAddr(_addr)
643         checkIsContract(_taddr)
644     {
645 		if (_val > 0) {
646             ITokenERC20_USDT(_taddr).transfer(_addr, _val);
647 		}
648 	}
649 
650     /**
651      * @dev Gets the amount from the specified user
652      * USDT transfer and transferFrom not returns
653      * @param _taddr token address
654      * @param _addr user address
655      * @param _val transfer-get amount
656      */
657 	function getTokenFormUser_USDT(address _taddr, address _addr, uint _val)
658         internal
659         checkZeroAddr(_addr)
660         checkIsContract(_taddr)
661     {
662 		if (_val > 0) {
663             ITokenERC20_USDT(_taddr).transferFrom(_addr, address(this), _val);
664 		}
665 	}
666 
667     /**
668      * @dev Check and correct transfer amount
669      * @param sendMoney transfer-out amount
670      * @return bool,amount
671      */
672 	function isEnoughTokneBalance(address _taddr, uint sendMoney)
673         internal
674         view
675         returns (bool, uint tokneBalance)
676     {
677         tokneBalance = ITokenERC20(_taddr).balanceOf(address(this));
678 		if (sendMoney > tokneBalance) {
679 			return (false, tokneBalance);
680 		} else {
681 			return (true, sendMoney);
682 		}
683 	}
684 
685     /**
686      * @dev get Resonance Ratio for the Resonance ID
687      * @param value Resonance ID
688      * @return Resonance Ratio
689      */
690 	function getResonanceRatio(uint value)
691         internal
692         view
693         returns (uint)
694     {
695         // base 1U=10E
696         // 1.10U=100E => 10/100U=1E => 1U=100/10E
697         // 2.11U=100E => 11/100U=1E => 1U=100/11E
698         // 3.12U=100E => 12/100U=1E => 1U=100/12E
699         return USDT_ETTWei_Ratio * 100 / ((value - 1) + 10);
700 	}
701 
702     /**
703      * @dev get scale for the level (*scale/1000)
704      * @param level level
705      * @return scale
706      */
707 	function getScaleByLevel(uint level)
708         internal
709         pure
710         returns (uint)
711     {
712 		if (level == 1) {
713 			return 10;
714 		}
715 		if (level == 2) {
716 			return 12;
717 		}
718 		if (level == 3) {
719 			return 15;
720 		}
721         if (level == 4) {
722 			return 15;
723 		}
724 		return 0;
725 	}
726 
727     /**
728      * @dev get scale for the DailyDividend (*scale/1000)
729      * @param level level
730      * @return scale algebra
731      */
732 	function getScaleByDailyDividend(uint level)
733         internal
734         pure
735         returns (uint scale, uint algebra)
736     {
737 		if (level == 1) {
738 			return (100, 1);
739 		}
740 		if (level == 2) {
741 			return (60, 5);
742 		}
743 		if (level == 3) {
744             return (80, 8);
745 		}
746         if (level == 4) {
747             return (100, 10);
748 		}
749 		return (0, 0);
750 	}
751 }
752 
753 contract EASContract is Utillibrary, DB {
754     using SafeMath for *;
755 
756     //struct
757 	struct User {
758 		uint id;
759 
760         uint investAmountAddup;//add up invest Amount
761         uint investAmountOut;//add up invest Amount Out
762 
763         uint investMoney;//invest amount current
764         uint investAddupStaticBonus;//add up settlement static bonus amonut
765         uint investAddupDynamicBonus;//add up settlement dynamic bonus amonut
766         uint8 investOutMultiple;//invest Exit multiple of investment  n/10
767         uint8 investLevel;//invest level
768         uint40 investTime;//invest time
769         uint40 investLastRwTime;//last settlement time
770 
771         uint bonusStaticAmount;//add up static bonus amonut (static bonus)
772 		uint bonusDynamicAmonut;//add up dynamic bonus amonut (dynamic bonus)
773 
774         uint takeBonusWallet;//takeBonus Wallet
775         uint takeBonusAddup;//add up takeBonus
776 	}
777     struct ResonanceData {
778         uint40 time;//Resonance time
779         uint ratio;//Resonance amount
780         uint investMoney;//invest amount
781 	}
782 
783     //Loglist
784     event InvestEvent(address indexed _addr, address indexed _code, address indexed _rCode, uint _value, uint time);
785     event TakeBonusEvent(address indexed _addr, uint _type, uint _value_USDT, uint _value_ETT, uint time);
786 
787     //ERC Token addr
788     address USDTToken;//USDT contract
789 
790     //base param setting
791 	address devAddr;//The special account
792 
793     //resonance
794     uint internal rid = 1;//sell Round id
795     mapping(uint => ResonanceData) internal resonanceDataMapping;//RoundID ResonanceData Mapping
796 
797     //address User Mapping
798 	mapping(address => User) userMapping;
799 
800     //addup
801     uint AddupInvestUSD = 0;
802 
803     //ETT Token Pool
804     uint ETTPool_User = ETTWei * 9900000;
805 
806     uint ETTPool_Dev = ETTWei * 1100000;
807     uint ETTPool_Dev_RwAddup = 0;
808     uint40 ETTPool_Dev_LastRwTime = uint40(now + 365 * 1 days);
809 
810     /**
811      * @dev the content of contract is Beginning
812      */
813 	constructor (
814         address _devAddr,
815         address _USDTAddr
816     )
817         public
818     {
819         //set addr
820         devAddr = _devAddr;
821         USDTToken = _USDTAddr;
822 
823         //init ResonanceData
824         ResonanceData storage resonance = resonanceDataMapping[rid];
825         if (resonance.ratio == 0) {
826             resonance.time = uint40(now);
827             resonance.ratio = getResonanceRatio(rid);
828         }
829     }
830 
831     /**
832      * @dev the invest of contract is Beginning
833      * @param money USDT amount for invest
834      * @param rCode recommend code
835      */
836 	function invest(uint money, address rCode)
837         public
838         isHuman()
839     {
840         address code = msg.sender;
841 
842         //判断是投资范围
843         require(
844             money == USDTWei * 2000
845             || money == USDTWei * 1000
846             || money == USDTWei * 500
847             || money == USDTWei * 100
848             , "invalid invest range");
849 
850         //init userInfo
851         uint[1] memory user_data;
852         (user_data, , ) = _getUserInfo(msg.sender);
853         uint user_id = user_data[0];
854 		if (user_id == 0) {
855 			_registerUser(msg.sender, code, rCode);
856             (user_data, , ) = _getUserInfo(msg.sender);
857             user_id = user_data[0];
858 		}
859 
860 		User storage user = userMapping[msg.sender];
861 		if (user.id == 0) {
862             user.id = user_id;
863 		}
864 
865         //判断是已投资
866         require(user.investMoney == 0, "Has been invested");
867 
868         //投资等级
869         uint8 investLevel = 0;
870         if(money == USDTWei * 2000) {
871             investLevel = 4;
872         } else if(money == USDTWei * 1000) {
873             investLevel = 3;
874         } else if(money == USDTWei * 500) {
875             investLevel = 2;
876         } else if(money == USDTWei * 100) {
877             investLevel = 1;
878         }
879         require(investLevel >= user.investLevel,"invalid invest Level");
880 
881         if(AddupInvestUSD < USDTWei * 500000) {
882             //Transfer USDT Token to Contract
883             getTokenFormUser_USDT(USDTToken, msg.sender, money);
884         } else {
885             uint ETTMoney = money.mul(resonanceDataMapping[rid].ratio).mul(30).div(100);
886 
887             //Transfer USDT Token to Contract
888             getTokenFormUser_USDT(USDTToken, msg.sender, money.mul(70).div(100));
889             //Transfer ETT Token to Contract
890             getTokenFormUser(msg.sender, ETTMoney);
891 
892             //add user Token pool
893             ETTPool_User += ETTMoney;
894         }
895 
896         //send USDT Token to dev addr
897         sendTokenToUser_USDT(USDTToken, devAddr, money.div(20));
898 
899         //addup
900         AddupInvestUSD += money;
901 
902         //user invest info
903         user.investAmountAddup += money;
904         user.investMoney = money;
905         user.investAddupStaticBonus = 0;
906         user.investAddupDynamicBonus = 0;
907         user.investOutMultiple = 22;
908         user.investLevel = investLevel;
909         user.investTime = uint40(now);
910         user.investLastRwTime = uint40(now);
911 
912         //update Ratio
913         updateRatio(money);
914 
915         //触发更新直推投资出局倍数
916         updateUser_Parent(rCode, money);
917 
918         emit InvestEvent(msg.sender, code, rCode, money, now);
919 	}
920 
921     /**
922      * @dev settlement
923      */
924     function settlement()
925         public
926         isHuman()
927     {
928 		User storage user = userMapping[msg.sender];
929         checkUserID(user.id);
930 
931         require(user.investMoney > 0, "uninvested or out");
932         require(now >= user.investLastRwTime, "not release time");
933 
934         //reacquire rCode
935         address rCode;
936         (, , rCode) = _getUserInfo(msg.sender);
937 
938         //-----------Static Start
939         uint settlementNumber_base = (now - user.investLastRwTime) / 1 days;
940         if (user.investMoney > 0 && settlementNumber_base > 0) 
941         {
942             uint moneyBonus_base = user.investMoney * getScaleByLevel(user.investLevel) / 1000;
943             uint settlementNumber = settlementNumber_base;
944             uint settlementMaxMoney = 0;
945             if(user.investMoney * user.investOutMultiple / 10 >= user.investAddupStaticBonus + user.investAddupDynamicBonus) {
946                 settlementMaxMoney = user.investMoney * user.investOutMultiple / 10 - (user.investAddupStaticBonus + user.investAddupDynamicBonus);
947             }
948             uint moneyBonus = 0;
949             if (moneyBonus_base * settlementNumber > settlementMaxMoney) 
950             {
951                 settlementNumber = settlementMaxMoney / moneyBonus_base;
952                 if (moneyBonus_base * settlementNumber < settlementMaxMoney) {
953                     settlementNumber ++;
954                 }
955                 if (settlementNumber > settlementNumber_base) {
956                     settlementNumber = settlementNumber_base;
957                 }
958                 // moneyBonus = moneyBonus_base * settlementNumber;
959                 moneyBonus = settlementMaxMoney;
960             } else {
961                 moneyBonus = moneyBonus_base * settlementNumber;
962             }
963 
964             user.takeBonusWallet += moneyBonus;
965             user.bonusStaticAmount += moneyBonus;
966 
967             user.investAddupStaticBonus += moneyBonus;
968             user.investLastRwTime += uint40(settlementNumber * 1 days);
969             //check out
970             if (user.investAddupStaticBonus + user.investAddupDynamicBonus >= user.investMoney * user.investOutMultiple / 10) {
971                 user.investAmountOut += user.investMoney;
972                 user.investMoney = 0;//out
973             }
974 
975             //Calculate the bonus (Daily Dividend)
976             // countBonus_DailyDividend(rCode, moneyBonus, user.investMoney);
977             countBonus_DailyDividend(rCode, moneyBonus_base * settlementNumber, user.investMoney);
978         }
979         //-----------Static End
980 	}
981 
982     /**
983      * @dev the take bonus of contract is Beginning
984      * @param _type take type 0:default 100%USDT, 1:30%ETT 70%USDT, 2:50%ETT 50%USDT, 3:70%ETT 30%USDT, 4:100%ETT 0%USDT
985      */
986     function takeBonus(uint8 _type)
987         public
988         isHuman()
989     {
990 		User storage user = userMapping[msg.sender];
991 		checkUserID(user.id);
992 
993 		require(user.takeBonusWallet >= USDTWei * 1, "invalid amount");
994 
995         uint sendDevMoney_USDT = user.takeBonusWallet.div(20);
996 		uint takeMoney_USDT = user.takeBonusWallet.sub(sendDevMoney_USDT);
997         uint takeMoney_USDT_ETT = 0;
998 
999         //Calculation amount
1000         (takeMoney_USDT, takeMoney_USDT_ETT) = calculationTakeBonus(_type, takeMoney_USDT);
1001 
1002         bool isEnoughBalance = false;
1003         uint resultMoney = 0;
1004 
1005         //check send USDT
1006         //check USDT Enough Balance
1007         (isEnoughBalance, resultMoney) = isEnoughTokneBalance(USDTToken, takeMoney_USDT + sendDevMoney_USDT);
1008         if(isEnoughBalance == false)
1009         {
1010             require(resultMoney > 0, "not Enough Balance USDT");
1011             //correct
1012             sendDevMoney_USDT = resultMoney.div(20);
1013             takeMoney_USDT = resultMoney.sub(sendDevMoney_USDT);
1014             //Calculation amount
1015             (takeMoney_USDT, takeMoney_USDT_ETT) = calculationTakeBonus(_type, takeMoney_USDT);
1016         }
1017 
1018         //check send ETT
1019         if(takeMoney_USDT_ETT > 0)
1020         {
1021             uint ETTMoney = takeMoney_USDT_ETT.mul(resonanceDataMapping[rid].ratio);
1022             //check user Token pool
1023             if(ETTMoney > ETTPool_User) {
1024                 ETTMoney = ETTPool_User;
1025                 require(ETTMoney > 0, "not Enough Balance pool");
1026                 //correct
1027                 uint ETTMoney_USDT = ETTMoney.div(resonanceDataMapping[rid].ratio);
1028                 sendDevMoney_USDT = sendDevMoney_USDT.mul(ETTMoney_USDT).div(takeMoney_USDT_ETT);
1029                 takeMoney_USDT = takeMoney_USDT.mul(ETTMoney_USDT).div(takeMoney_USDT_ETT);
1030                 takeMoney_USDT_ETT = ETTMoney_USDT;
1031             }
1032 
1033             //check ETT Enough Balance
1034             (isEnoughBalance, resultMoney) = isEnoughTokneBalance(address(this), ETTMoney);
1035             if(isEnoughBalance == false)
1036             {
1037                 require(resultMoney > 0, "not Enough Balance ETT");
1038                 //correct
1039                 uint resultMoney_USDT = resultMoney.div(resonanceDataMapping[rid].ratio);
1040                 sendDevMoney_USDT = sendDevMoney_USDT.mul(resultMoney_USDT).div(takeMoney_USDT_ETT);
1041                 takeMoney_USDT = takeMoney_USDT.mul(resultMoney_USDT).div(takeMoney_USDT_ETT);
1042                 takeMoney_USDT_ETT = resultMoney_USDT;
1043             }
1044         }
1045 
1046         if(sendDevMoney_USDT > 0)
1047         {
1048             //Transfer USDT Token to Dev
1049             sendTokenToUser_USDT(USDTToken, devAddr, sendDevMoney_USDT);
1050         }
1051         if(takeMoney_USDT > 0)
1052         {
1053             //Transfer USDT Token to User
1054             sendTokenToUser_USDT(USDTToken, msg.sender, takeMoney_USDT);
1055         }
1056         if(takeMoney_USDT_ETT > 0)
1057         {
1058             //Transfer ETT Token to User
1059             sendTokenToUser(msg.sender, takeMoney_USDT_ETT.mul(resonanceDataMapping[rid].ratio));
1060             ETTPool_User = ETTPool_User.sub(takeMoney_USDT_ETT.mul(resonanceDataMapping[rid].ratio));
1061         }
1062 
1063         user.takeBonusWallet = user.takeBonusWallet.sub(takeMoney_USDT).sub(takeMoney_USDT_ETT).sub(sendDevMoney_USDT);
1064         user.takeBonusAddup = user.takeBonusAddup.add(takeMoney_USDT).add(takeMoney_USDT_ETT).add(sendDevMoney_USDT);
1065 
1066         emit TakeBonusEvent(msg.sender, _type, takeMoney_USDT, takeMoney_USDT_ETT, now);
1067 	}
1068 
1069     /**
1070      * @dev settlement ETT Pool Dev
1071      */
1072     function settlement_Dev()
1073         public
1074         isHuman()
1075     {
1076         require(now >= ETTPool_Dev_LastRwTime, "not release time");
1077         require(ETTPool_Dev > ETTPool_Dev_RwAddup, "release done");
1078         
1079         uint settlementNumber_base =  (now - ETTPool_Dev_LastRwTime) / 1 days;
1080         uint moneyBonus_base = ETTPool_Dev / 365;
1081         uint settlementNumber = settlementNumber_base;
1082         uint settlementMaxMoney = 0;
1083         if(ETTPool_Dev >= ETTPool_Dev_RwAddup) {
1084             settlementMaxMoney = ETTPool_Dev - ETTPool_Dev_RwAddup;
1085         }
1086         uint moneyBonus = 0;
1087         if (moneyBonus_base * settlementNumber > settlementMaxMoney) 
1088         {
1089             settlementNumber = settlementMaxMoney / moneyBonus_base;
1090             if (moneyBonus_base * settlementNumber < settlementMaxMoney) {
1091                 settlementNumber ++;
1092             }
1093             if (settlementNumber > settlementNumber_base) {
1094                 settlementNumber = settlementNumber_base;
1095             }
1096             // moneyBonus = moneyBonus_base * settlementNumber;
1097             moneyBonus = settlementMaxMoney;
1098         } else {
1099             moneyBonus = moneyBonus_base * settlementNumber;
1100         }
1101 
1102         //Transfer ETT Token to Dev
1103         sendTokenToUser(devAddr, moneyBonus);
1104 
1105         //update Dev_Rw
1106         ETTPool_Dev_RwAddup += moneyBonus;
1107         ETTPool_Dev_LastRwTime += uint40(settlementNumber * 1 days);
1108 	}
1109 
1110     /**
1111      * @dev Show contract state view
1112      * @return info contract state view
1113      */
1114     function stateView()
1115         public
1116         view
1117         returns (uint[8] memory info)
1118     {
1119         info[0] = _getCurrentUserID();
1120         info[1] = rid;
1121         info[2] = resonanceDataMapping[rid].ratio;
1122         info[3] = resonanceDataMapping[rid].investMoney;
1123         info[4] = resonanceDataMapping[rid].time;
1124         info[5] = AddupInvestUSD;
1125         info[6] = ETTPool_Dev_RwAddup;
1126         info[7] = ETTPool_Dev_LastRwTime;
1127 
1128 		return (info);
1129 	}
1130 
1131     /**
1132      * @dev get the user info based
1133      * @param addr user addressrd
1134      * @return info user info
1135      */
1136 	function getUserByAddress(
1137         address addr
1138     )
1139         public
1140         view
1141         returns (uint[14] memory info, address code, address rCode)
1142     {
1143         uint[1] memory user_data;
1144         (user_data, code, rCode) = _getUserInfo(addr);
1145         uint user_id = user_data[0];
1146 
1147 		User storage user = userMapping[addr];
1148 
1149 		info[0] = user_id;
1150         info[1] = user.investAmountAddup;
1151         info[2] = user.investAmountOut;
1152         info[3] = user.investMoney;
1153         info[4] = user.investAddupStaticBonus;
1154         info[5] = user.investAddupDynamicBonus;
1155         info[6] = user.investOutMultiple;
1156         info[7] = user.investLevel;
1157         info[8] = user.investTime;
1158         info[9] = user.investLastRwTime;
1159         info[10] = user.bonusStaticAmount;
1160         info[11] = user.bonusDynamicAmonut;
1161         info[12] = user.takeBonusWallet;
1162         info[13] = user.takeBonusAddup;
1163 		return (info, code, rCode);
1164 	}
1165 
1166     /**
1167      * @dev update Resonance Ratio
1168      * @param investMoney invest USDT amount
1169      */
1170 	function updateRatio(uint investMoney)
1171         private
1172     {
1173         ResonanceData storage resonance = resonanceDataMapping[rid];
1174         resonance.investMoney += investMoney;
1175 
1176         //check
1177         if(AddupInvestUSD >= USDTWei * 500000)
1178         {
1179             uint newRatio = 0;
1180             uint newResonanceInvestMoney = 0;
1181             if(rid == 1)
1182             {
1183                 if(resonance.investMoney >= USDTWei * 600000)
1184                 {
1185                     newResonanceInvestMoney = resonance.investMoney - USDTWei * 600000;
1186                     resonance.investMoney = USDTWei * 600000;
1187                     newRatio = getResonanceRatio(rid + 1);
1188                 }
1189             } else {
1190                 if(resonance.investMoney >= USDTWei * 100000)
1191                 {
1192                     newResonanceInvestMoney = resonance.investMoney - USDTWei * 100000;
1193                     resonance.investMoney = USDTWei * 100000;
1194                     newRatio = getResonanceRatio(rid + 1);
1195                 }
1196             }
1197 
1198             if (newRatio > 0) 
1199             {
1200                 rid ++;
1201                 resonance = resonanceDataMapping[rid];
1202                 resonance.time = uint40(now);
1203                 resonance.ratio = newRatio;
1204                 //Continuous rise
1205                 resonance.investMoney = newResonanceInvestMoney;
1206                 updateRatio(0);
1207             }
1208         }
1209 	}
1210 
1211         /**
1212      * @dev update Parent User
1213      * @param rCode user recommend code
1214      * @param money invest money
1215      */
1216 	function updateUser_Parent(address rCode, uint money)
1217         private
1218     {
1219 		if (rCode == address(0)) {
1220             return;
1221         }
1222 
1223         User storage user = userMapping[rCode];
1224 
1225         //-----------updateUser_Parent Start
1226         if (user.investMoney > 0 && money >= user.investMoney) {
1227             user.investOutMultiple = 30;
1228         }
1229         //-----------updateUser_Parent End
1230 	}
1231 
1232     /**
1233      * @dev Calculate the bonus (Daily Dividend)
1234      * @param rCode user recommend code
1235      * @param money base money
1236      * @param investMoney invest money
1237      */
1238 	function countBonus_DailyDividend(address rCode, uint money, uint investMoney)
1239         private
1240     {
1241 		address tmpReferrerCode = rCode;
1242         address tmpUser_rCode;
1243 
1244 		for (uint i = 1; i <= 10; i++) {
1245 			if (tmpReferrerCode == address(0)) {
1246 				break;
1247 			}
1248 
1249 			User storage user = userMapping[tmpReferrerCode];
1250 
1251             //last rRcode and currUserInfo
1252             (, , tmpUser_rCode) = _getUserInfo(tmpReferrerCode);
1253 
1254             //-----------DailyDividend Start
1255             if (user.investMoney > 0) 
1256             {
1257                 uint moneyBonusDailyDividend = 0;
1258 
1259                 (uint scale, uint algebra) = getScaleByDailyDividend(user.investLevel);
1260                 if (algebra >= i) 
1261                 {
1262                     moneyBonusDailyDividend = money * scale / 1000;
1263                     //burns
1264                     if (user.investMoney < investMoney) {
1265                         moneyBonusDailyDividend = moneyBonusDailyDividend * user.investMoney / investMoney;
1266                     }
1267                     if (moneyBonusDailyDividend > 0) {
1268                         //check out
1269 
1270                         if (user.investAddupStaticBonus + user.investAddupDynamicBonus + moneyBonusDailyDividend >= user.investMoney * user.investOutMultiple / 10) {
1271                             moneyBonusDailyDividend = user.investMoney * user.investOutMultiple / 10 - (user.investAddupStaticBonus + user.investAddupDynamicBonus);
1272 
1273                             user.investAmountOut += user.investMoney;
1274                             user.investMoney = 0;//out
1275                         }
1276                         user.takeBonusWallet += moneyBonusDailyDividend;
1277                         user.bonusDynamicAmonut += moneyBonusDailyDividend;
1278                         user.investAddupDynamicBonus += moneyBonusDailyDividend;
1279                     }
1280                 }
1281             }
1282             //-----------DailyDividend End
1283 
1284             tmpReferrerCode = tmpUser_rCode;
1285 		}
1286 	}
1287 
1288 
1289     /**
1290      * @dev Calculation amount
1291      * @param _type take type
1292      * @param takeMoney take Money
1293      * @return takeMoney_USDT take Money USDT
1294      * @return takeMoney_USDT_ETT take Money USDT(ETT)
1295      */
1296 	function calculationTakeBonus(uint8 _type, uint takeMoney)
1297         internal
1298         pure
1299         returns (uint takeMoney_USDT, uint takeMoney_USDT_ETT)
1300     {
1301 		takeMoney_USDT = takeMoney;
1302 
1303         if(_type == 1) {
1304             //ETT 30%
1305             takeMoney_USDT_ETT = takeMoney_USDT.mul(30).div(100);
1306         }
1307         else if(_type == 2) {
1308             //ETT 50%
1309             takeMoney_USDT_ETT = takeMoney_USDT.div(2);
1310         }
1311         else if(_type == 3) {
1312             //ETT 70%
1313             takeMoney_USDT_ETT = takeMoney_USDT.mul(70).div(100);
1314         }
1315         else if(_type == 4) {
1316             //ETT 100%
1317             takeMoney_USDT_ETT = takeMoney_USDT;
1318         }
1319         takeMoney_USDT = takeMoney_USDT.sub(takeMoney_USDT_ETT);
1320 	}
1321 }