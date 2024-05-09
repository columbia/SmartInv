1 pragma solidity ^0.4.18;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /// @title ServiceAllowance.
34 ///
35 /// Provides a way to delegate operation allowance decision to a service contract
36 contract ServiceAllowance {
37     function isTransferAllowed(address _from, address _to, address _sender, address _token, uint _value) public view returns (bool);
38 }
39 
40 contract ATxPlatformInterface {
41     mapping(bytes32 => address) public proxies;
42     function name(bytes32 _symbol) public view returns (string);
43     function setProxy(address _address, bytes32 _symbol) public returns (uint errorCode);
44     function isOwner(address _owner, bytes32 _symbol) public view returns (bool);
45     function totalSupply(bytes32 _symbol) public view returns (uint);
46     function balanceOf(address _holder, bytes32 _symbol) public view returns (uint);
47     function allowance(address _from, address _spender, bytes32 _symbol) public view returns (uint);
48     function baseUnit(bytes32 _symbol) public view returns (uint8);
49     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
50     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
51     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) public returns (uint errorCode);
52     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) public returns (uint errorCode);
53     function reissueAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
54     function revokeAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
55     function isReissuable(bytes32 _symbol) public view returns (bool);
56     function changeOwnership(bytes32 _symbol, address _newOwner) public returns (uint errorCode);
57 }
58 
59 /**
60  * @title Owned contract with safe ownership pass.
61  *
62  * Note: all the non constant functions return false instead of throwing in case if state change
63  * didn't happen yet.
64  */
65 contract Owned {
66     /**
67      * Contract owner address
68      */
69     address public contractOwner;
70 
71     /**
72      * Contract owner address
73      */
74     address public pendingContractOwner;
75 
76     function Owned() {
77         contractOwner = msg.sender;
78     }
79 
80     /**
81     * @dev Owner check modifier
82     */
83     modifier onlyContractOwner() {
84         if (contractOwner == msg.sender) {
85             _;
86         }
87     }
88 
89     /**
90      * @dev Destroy contract and scrub a data
91      * @notice Only owner can call it
92      */
93     function destroy() onlyContractOwner {
94         suicide(msg.sender);
95     }
96 
97     /**
98      * Prepares ownership pass.
99      *
100      * Can only be called by current owner.
101      *
102      * @param _to address of the next owner. 0x0 is not allowed.
103      *
104      * @return success.
105      */
106     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
107         if (_to  == 0x0) {
108             return false;
109         }
110 
111         pendingContractOwner = _to;
112         return true;
113     }
114 
115     /**
116      * Finalize ownership pass.
117      *
118      * Can only be called by pending owner.
119      *
120      * @return success.
121      */
122     function claimContractOwnership() returns(bool) {
123         if (pendingContractOwner != msg.sender) {
124             return false;
125         }
126 
127         contractOwner = pendingContractOwner;
128         delete pendingContractOwner;
129 
130         return true;
131     }
132 }
133 
134 contract ERC20Interface {
135     event Transfer(address indexed from, address indexed to, uint256 value);
136     event Approval(address indexed from, address indexed spender, uint256 value);
137     string public symbol;
138 
139     function totalSupply() constant returns (uint256 supply);
140     function balanceOf(address _owner) constant returns (uint256 balance);
141     function transfer(address _to, uint256 _value) returns (bool success);
142     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
143     function approve(address _spender, uint256 _value) returns (bool success);
144     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
145 }
146 
147 /**
148  * @title Generic owned destroyable contract
149  */
150 contract Object is Owned {
151     /**
152     *  Common result code. Means everything is fine.
153     */
154     uint constant OK = 1;
155     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
156 
157     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
158         for(uint i=0;i<tokens.length;i++) {
159             address token = tokens[i];
160             uint balance = ERC20Interface(token).balanceOf(this);
161             if(balance != 0)
162                 ERC20Interface(token).transfer(_to,balance);
163         }
164         return OK;
165     }
166 
167     function checkOnlyContractOwner() internal constant returns(uint) {
168         if (contractOwner == msg.sender) {
169             return OK;
170         }
171 
172         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
173     }
174 }
175 
176 /// @title Provides possibility manage holders? country limits and limits for holders.
177 contract DataControllerInterface {
178 
179     /// @notice Checks user is holder.
180     /// @param _address - checking address.
181     /// @return `true` if _address is registered holder, `false` otherwise.
182     function isHolderAddress(address _address) public view returns (bool);
183 
184     function allowance(address _user) public view returns (uint);
185 
186     function changeAllowance(address _holder, uint _value) public returns (uint);
187 }
188 
189 /// @title ServiceController
190 ///
191 /// Base implementation
192 /// Serves for managing service instances
193 contract ServiceControllerInterface {
194 
195     /// @notice Check target address is service
196     /// @param _address target address
197     /// @return `true` when an address is a service, `false` otherwise
198     function isService(address _address) public view returns (bool);
199 }
200 
201 contract ATxAssetInterface {
202 
203     DataControllerInterface public dataController;
204     ServiceControllerInterface public serviceController;
205 
206     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public returns (bool);
207     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns (bool);
208     function __approve(address _spender, uint _value, address _sender) public returns (bool);
209     function __process(bytes /*_data*/, address /*_sender*/) payable public {
210         revert();
211     }
212 }
213 
214 contract ERC20 {
215     event Transfer(address indexed from, address indexed to, uint256 value);
216     event Approval(address indexed from, address indexed spender, uint256 value);
217     string public symbol;
218 
219     function totalSupply() constant returns (uint256 supply);
220     function balanceOf(address _owner) constant returns (uint256 balance);
221     function transfer(address _to, uint256 _value) returns (bool success);
222     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
223     function approve(address _spender, uint256 _value) returns (bool success);
224     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
225 }
226 
227 contract Platform {
228     mapping(bytes32 => address) public proxies;
229     function name(bytes32 _symbol) public view returns (string);
230     function setProxy(address _address, bytes32 _symbol) public returns (uint errorCode);
231     function isOwner(address _owner, bytes32 _symbol) public view returns (bool);
232     function totalSupply(bytes32 _symbol) public view returns (uint);
233     function balanceOf(address _holder, bytes32 _symbol) public view returns (uint);
234     function allowance(address _from, address _spender, bytes32 _symbol) public view returns (uint);
235     function baseUnit(bytes32 _symbol) public view returns (uint8);
236     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
237     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
238     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) public returns (uint errorCode);
239     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) public returns (uint errorCode);
240     function reissueAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
241     function revokeAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
242     function isReissuable(bytes32 _symbol) public view returns (bool);
243     function changeOwnership(bytes32 _symbol, address _newOwner) public returns (uint errorCode);
244 }
245 
246 contract ATxAssetProxy is ERC20, Object, ServiceAllowance {
247 
248     using SafeMath for uint;
249 
250     /**
251      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
252      */
253     event UpgradeProposal(address newVersion);
254 
255     // Current asset implementation contract address.
256     address latestVersion;
257 
258     // Assigned platform, immutable.
259     Platform public platform;
260 
261     // Assigned symbol, immutable.
262     bytes32 public smbl;
263 
264     // Assigned name, immutable.
265     string public name;
266 
267     /**
268      * Only platform is allowed to call.
269      */
270     modifier onlyPlatform() {
271         if (msg.sender == address(platform)) {
272             _;
273         }
274     }
275 
276     /**
277      * Only current asset owner is allowed to call.
278      */
279     modifier onlyAssetOwner() {
280         if (platform.isOwner(msg.sender, smbl)) {
281             _;
282         }
283     }
284 
285     /**
286      * Only asset implementation contract assigned to sender is allowed to call.
287      */
288     modifier onlyAccess(address _sender) {
289         if (getLatestVersion() == msg.sender) {
290             _;
291         }
292     }
293 
294     /**
295      * Resolves asset implementation contract for the caller and forwards there transaction data,
296      * along with the value. This allows for proxy interface growth.
297      */
298     function() public payable {
299         _getAsset().__process.value(msg.value)(msg.data, msg.sender);
300     }
301 
302     /**
303      * Sets platform address, assigns symbol and name.
304      *
305      * Can be set only once.
306      *
307      * @param _platform platform contract address.
308      * @param _symbol assigned symbol.
309      * @param _name assigned name.
310      *
311      * @return success.
312      */
313     function init(Platform _platform, string _symbol, string _name) public returns (bool) {
314         if (address(platform) != 0x0) {
315             return false;
316         }
317         platform = _platform;
318         symbol = _symbol;
319         smbl = stringToBytes32(_symbol);
320         name = _name;
321         return true;
322     }
323 
324     /**
325      * Returns asset total supply.
326      *
327      * @return asset total supply.
328      */
329     function totalSupply() public view returns (uint) {
330         return platform.totalSupply(smbl);
331     }
332 
333     /**
334      * Returns asset balance for a particular holder.
335      *
336      * @param _owner holder address.
337      *
338      * @return holder balance.
339      */
340     function balanceOf(address _owner) public view returns (uint) {
341         return platform.balanceOf(_owner, smbl);
342     }
343 
344     /**
345      * Returns asset allowance from one holder to another.
346      *
347      * @param _from holder that allowed spending.
348      * @param _spender holder that is allowed to spend.
349      *
350      * @return holder to spender allowance.
351      */
352     function allowance(address _from, address _spender) public view returns (uint) {
353         return platform.allowance(_from, _spender, smbl);
354     }
355 
356     /**
357      * Returns asset decimals.
358      *
359      * @return asset decimals.
360      */
361     function decimals() public view returns (uint8) {
362         return platform.baseUnit(smbl);
363     }
364 
365     /**
366      * Transfers asset balance from the caller to specified receiver.
367      *
368      * @param _to holder address to give to.
369      * @param _value amount to transfer.
370      *
371      * @return success.
372      */
373     function transfer(address _to, uint _value) public returns (bool) {
374         if (_to != 0x0) {
375             return _transferWithReference(_to, _value, "");
376         }
377         else {
378             return false;
379         }
380     }
381 
382     /**
383      * Transfers asset balance from the caller to specified receiver adding specified comment.
384      *
385      * @param _to holder address to give to.
386      * @param _value amount to transfer.
387      * @param _reference transfer comment to be included in a platform's Transfer event.
388      *
389      * @return success.
390      */
391     function transferWithReference(address _to, uint _value, string _reference) public returns (bool) {
392         if (_to != 0x0) {
393             return _transferWithReference(_to, _value, _reference);
394         }
395         else {
396             return false;
397         }
398     }
399 
400     /**
401      * Performs transfer call on the platform by the name of specified sender.
402      *
403      * Can only be called by asset implementation contract assigned to sender.
404      *
405      * @param _to holder address to give to.
406      * @param _value amount to transfer.
407      * @param _reference transfer comment to be included in a platform's Transfer event.
408      * @param _sender initial caller.
409      *
410      * @return success.
411      */
412     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public onlyAccess(_sender) returns (bool) {
413         return platform.proxyTransferWithReference(_to, _value, smbl, _reference, _sender) == OK;
414     }
415 
416     /**
417      * Prforms allowance transfer of asset balance between holders.
418      *
419      * @param _from holder address to take from.
420      * @param _to holder address to give to.
421      * @param _value amount to transfer.
422      *
423      * @return success.
424      */
425     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
426         if (_to != 0x0) {
427             return _getAsset().__transferFromWithReference(_from, _to, _value, "", msg.sender);
428         }
429         else {
430             return false;
431         }
432     }
433 
434     /**
435      * Performs allowance transfer call on the platform by the name of specified sender.
436      *
437      * Can only be called by asset implementation contract assigned to sender.
438      *
439      * @param _from holder address to take from.
440      * @param _to holder address to give to.
441      * @param _value amount to transfer.
442      * @param _reference transfer comment to be included in a platform's Transfer event.
443      * @param _sender initial caller.
444      *
445      * @return success.
446      */
447     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public onlyAccess(_sender) returns (bool) {
448         return platform.proxyTransferFromWithReference(_from, _to, _value, smbl, _reference, _sender) == OK;
449     }
450 
451     /**
452      * Sets asset spending allowance for a specified spender.
453      *
454      * @param _spender holder address to set allowance to.
455      * @param _value amount to allow.
456      *
457      * @return success.
458      */
459     function approve(address _spender, uint _value) public returns (bool) {
460         if (_spender != 0x0) {
461             return _getAsset().__approve(_spender, _value, msg.sender);
462         }
463         else {
464             return false;
465         }
466     }
467 
468     /**
469      * Performs allowance setting call on the platform by the name of specified sender.
470      *
471      * Can only be called by asset implementation contract assigned to sender.
472      *
473      * @param _spender holder address to set allowance to.
474      * @param _value amount to allow.
475      * @param _sender initial caller.
476      *
477      * @return success.
478      */
479     function __approve(address _spender, uint _value, address _sender) public onlyAccess(_sender) returns (bool) {
480         return platform.proxyApprove(_spender, _value, smbl, _sender) == OK;
481     }
482 
483     /**
484      * Emits ERC20 Transfer event on this contract.
485      *
486      * Can only be, and, called by assigned platform when asset transfer happens.
487      */
488     function emitTransfer(address _from, address _to, uint _value) public onlyPlatform() {
489         Transfer(_from, _to, _value);
490     }
491 
492     /**
493      * Emits ERC20 Approval event on this contract.
494      *
495      * Can only be, and, called by assigned platform when asset allowance set happens.
496      */
497     function emitApprove(address _from, address _spender, uint _value) public onlyPlatform() {
498         Approval(_from, _spender, _value);
499     }
500 
501     /**
502      * Returns current asset implementation contract address.
503      *
504      * @return asset implementation contract address.
505      */
506     function getLatestVersion() public view returns (address) {
507         return latestVersion;
508     }
509 
510     /**
511      * Propose next asset implementation contract address.
512      *
513      * Can only be called by current asset owner.
514      *
515      * Note: freeze-time should not be applied for the initial setup.
516      *
517      * @param _newVersion asset implementation contract address.
518      *
519      * @return success.
520      */
521     function proposeUpgrade(address _newVersion) public onlyAssetOwner returns (bool) {
522         // New version address should be other than 0x0.
523         if (_newVersion == 0x0) {
524             return false;
525         }
526         
527         latestVersion = _newVersion;
528 
529         UpgradeProposal(_newVersion); 
530         return true;
531     }
532 
533     function isTransferAllowed(address, address, address, address, uint) public view returns (bool) {
534         return true;
535     }
536 
537     /**
538      * Returns asset implementation contract for current caller.
539      *
540      * @return asset implementation contract.
541      */
542     function _getAsset() internal view returns (ATxAssetInterface) {
543         return ATxAssetInterface(getLatestVersion());
544     }
545 
546     /**
547      * Resolves asset implementation contract for the caller and forwards there arguments along with
548      * the caller address.
549      *
550      * @return success.
551      */
552     function _transferWithReference(address _to, uint _value, string _reference) internal returns (bool) {
553         return _getAsset().__transferWithReference(_to, _value, _reference, msg.sender);
554     }
555 
556     function stringToBytes32(string memory source) private pure returns (bytes32 result) {
557         assembly {
558             result := mload(add(source, 32))
559         }
560     }
561 }
562 
563 contract ATxBuybackInterface {
564 
565 	event EtherReceived(uint amount);
566 	event TokenExchanged(
567 		address recepient, 
568 		address token, 
569 		uint tokenAmount, 
570 		uint etherAmount, 
571 		uint feeAmount, 
572 		address feeReceiver, 
573 		uint price
574 	);
575 }
576 
577 /// @title Token Buyback contract.
578 /// @notice Plays role of token exchange to Ether.
579 /// Has only one token at a contract. To support other tokens
580 /// there should be created other ATxBuyback contracts.
581 contract ATxBuyback is Object, ATxBuybackInterface, ServiceAllowance {
582 
583 	using SafeMath for uint;
584 
585     struct FeeData {
586         uint feeValue;
587         uint feeDecimals;
588     }
589 
590 	/// @dev Redemption fee collector address
591 	address public rdCollectorAddress;
592 	/// @dev Fee value
593 	FeeData rdFee;
594 
595 	/// @dev Token to exchange.
596 	ATxAssetProxy public token;
597 	/// @dev Price for 1 token
598 	uint public price;
599 	/// @dev Active flag
600 	bool public active;
601 
602 	/// @dev Guards from invocation only when state is active
603 	modifier onlyActive {
604 		if (active) {
605 			_;
606 		}
607 	}
608 
609 	function ATxBuyback(ATxAssetProxy _token) public {
610 		require(address(_token) != 0x0);
611 		token = _token;
612 	}
613 
614 	/// @notice Sets a price (in wei) for selling one token
615 	/// @param _price "in wei" = 1 ATx
616 	function setPrice(uint _price) onlyContractOwner external returns (uint) {
617 		price = _price;
618 		return OK;
619 	}
620 
621 	/// @notice Sets contract to active/non active state.
622 	/// Should be performed only by contract owner.
623 	/// @param _active next state of contract. True to activate a contract
624 	/// @return result code of an operation
625 	function setActive(bool _active) onlyContractOwner external returns (uint) {
626 		if (active == _active) {
627 			return;
628 		}
629 
630         active = _active;
631 		return OK;
632 	}
633 
634 	/// @notice Setup redemption destination address
635 	/// @param _collectorAddress address where all redemptiom fee will be directed
636 	/// @return result code of an operation
637 	function setRdCollectorAddress(address _collectorAddress) onlyContractOwner external returns (uint) {
638 		require(_collectorAddress != 0x0);
639 		
640 		rdCollectorAddress = _collectorAddress;
641 		return OK;
642 	}
643 
644 	/// @notice Setup redemption fee value
645 	/// @param _feeValue fee amount; the minimal value is 1
646 	/// @param _feeDecimals fee decimals, sets a precision for fee value
647 	/// @return result code of an operation
648 	function setRdFee(uint _feeValue, uint _feeDecimals) onlyContractOwner external returns (uint) {
649 		require(_validFee(_feeValue, _feeDecimals));
650 
651 		rdFee = FeeData(_feeValue, _feeDecimals);
652 		return OK;
653 	}
654 
655 	/// @notice Gets redemption fee value
656 	/// @return {
657 	/// 	"_value": "amount of percents",
658 	///		"_decimals": "percent's precision"
659 	/// }
660 	function getRdFee() public view returns (uint _value, uint _decimals) {
661 		FeeData memory _fee = rdFee;
662 		return (_fee.feeValue, _fee.feeDecimals);
663 	}
664 
665 	/// @notice Withdraws all Ether from buyback contract to specified address.
666 	/// Allowed only for contract owner.
667 	/// @param _to destination address to send Ether
668 	/// @return result code of an operation
669 	function withdrawAllEth(address _to) onlyContractOwner external returns (uint) {
670 		uint _balance = address(this).balance;
671 		if (_balance == 0) {
672 			return 0;
673 		}
674 
675 		_to.transfer(_balance);
676 
677 		return OK;
678 	}
679 
680 	/// ServiceAllowance
681     ///
682     /// @notice ServiceAllowance interface implementation
683     /// @dev Should cover conditions for allowance of transfers
684     function isTransferAllowed(address, address _to, address, address _token, uint) onlyActive public view returns (bool) {
685         if (_token == address(token) && _to == address(this)) {
686             return true;
687         }
688     }
689 
690 	/// @notice Fallback function for ERC223 standard.
691 	/// Allowed to work only in active state.
692 	/// @param _sender original sender of token transfer
693 	/// @param _value amount of tokens that has been sent
694 	function tokenFallback(address _sender, uint _value, bytes) external {
695 		/// Don't allow to transfer and exchange tokens when Buyback contract
696 		/// is not in 'active' state
697 		if (!active) {
698 			revert();
699 		}
700 		
701 		/// This call should be produced by AssetProxy's backend - an Asset contract.
702 		/// Any other call will be followed by revert()
703 		ATxAssetProxy _token = token;
704 		if (msg.sender != _token.getLatestVersion()) {
705 			revert();
706 		}
707 
708 		/// Need to check available ETH balance in order to fulfill holder's request
709 		/// about exchanging ATx Token to ETH equivalent
710 		uint _etherToExchange = _value.mul(price) / (10 ** uint(_token.decimals()));
711 		if (this.balance < _etherToExchange) {
712 			revert();
713 		}
714 
715 		/// To prevent double spending we revoke transferred assets from foundation platform,
716 		ATxPlatformInterface _platform = ATxPlatformInterface(address(_token.platform()));
717 		require(OK == _platform.revokeAsset(_token.smbl(), _value));
718 
719 		/// Take redemption fee and return left amount of Ether to transfer it to a holder
720 		uint _restEther = _takeRdFee(_etherToExchange);
721 		/// Transfer the rest to holder's account
722 		_sender.transfer(_restEther);
723 
724 		/// Voila! Just emit the event to say to the world that one more exchange action was finished
725 		TokenExchanged(_sender, _token, _value, _restEther, _etherToExchange.sub(_restEther), rdCollectorAddress, price);
726 	}
727 
728 	/// @notice Accepts Ether and emits EtherReceived event
729 	function() payable external {
730 		if (msg.value > 0) {
731 			EtherReceived(msg.value);
732 		}
733 	}
734 
735 	/* Internal */
736 
737 	function _takeRdFee(uint _fromValue) private returns (uint _restValue) {
738 		/// Here we check if redemption fee was setup after the contract initialization
739 		FeeData memory _fee = rdFee;
740 		require(_validFee(_fee.feeValue, _fee.feeDecimals));
741 
742 		/// Calculate amount of redemption fee that we have to take from the whole sum
743 		uint _rdFeeEther;
744 		_rdFeeEther = _fromValue.mul(_fee.feeValue).div(10 ** _fee.feeDecimals);
745 		_restValue = _fromValue.sub(_rdFeeEther);
746 
747 		/// At first use method collector.transfer() to ensure that if this move is not possible
748 		/// then revert all changes
749 		address _rdCollectorAddress = rdCollectorAddress;
750 		require(_rdCollectorAddress != 0x0);
751 		_rdCollectorAddress.transfer(_rdFeeEther);
752 	}
753 
754 	function _validFee(uint _value, uint _decimals) private pure returns (bool) {
755         return _value != 0 && _value / 10 ** _decimals.sub(1) >= 0 && _value / 10 ** _decimals.sub(1) < 10;
756     }
757 }