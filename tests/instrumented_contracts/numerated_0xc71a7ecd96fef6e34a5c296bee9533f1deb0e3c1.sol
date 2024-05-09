1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4 
5     /**
6      * @dev Multiplies two numbers, reverts on overflow.
7      */
8     function mul(uint256 _a, uint256 _b) internal pure returns(uint256) {
9         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10         // benefit is lost if 'b' is also tested.
11         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12         if (_a == 0) {
13             return 0;
14         }
15 
16         uint256 c = _a * _b;
17         require(c / _a == _b);
18 
19         return c;
20     }
21 
22     /**
23      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24      */
25     function div(uint256 _a, uint256 _b) internal pure returns(uint256) {
26         require(_b > 0); // Solidity only automatically asserts when dividing by 0
27         uint256 c = _a / _b;
28         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35      */
36     function sub(uint256 _a, uint256 _b) internal pure returns(uint256) {
37         require(_b <= _a);
38         uint256 c = _a - _b;
39 
40         return c;
41     }
42 
43     /**
44      * @dev Adds two numbers, reverts on overflow.
45      */
46     function add(uint256 _a, uint256 _b) internal pure returns(uint256) {
47         uint256 c = _a + _b;
48         require(c >= _a);
49 
50         return c;
51     }
52 
53     /**
54      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
55      * reverts when dividing by zero.
56      */
57     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 contract Ownable {
64   address public owner;
65 
66 
67   event OwnershipRenounced(address indexed previousOwner);
68   event OwnershipTransferred(
69     address indexed previousOwner,
70     address indexed newOwner
71   );
72 
73 
74   /**
75    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76    * account.
77    */
78   constructor() public {
79     owner = msg.sender;
80   }
81 
82   /**
83    * @dev Throws if called by any account other than the owner.
84    */
85   modifier onlyOwner() {
86     require(msg.sender == owner);
87     _;
88   }
89 
90   /**
91    * @dev Allows the current owner to relinquish control of the contract.
92    * @dev Renouncing to ownership will leave the contract without an owner.
93    * It will not be possible to call the functions with the `onlyOwner`
94    * modifier anymore.
95    */
96   function renounceOwnership() public onlyOwner {
97     emit OwnershipRenounced(owner);
98     owner = address(0);
99   }
100 
101   /**
102    * @dev Allows the current owner to transfer control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function transferOwnership(address _newOwner) public onlyOwner {
106     _transferOwnership(_newOwner);
107   }
108 
109   /**
110    * @dev Transfers control of the contract to a newOwner.
111    * @param _newOwner The address to transfer ownership to.
112    */
113   function _transferOwnership(address _newOwner) internal {
114     require(_newOwner != address(0));
115     emit OwnershipTransferred(owner, _newOwner);
116     owner = _newOwner;
117   }
118 }
119 
120 interface IRemoteFunctions {
121   function _externalAddMasternode(address) external;
122   function _externalStopMasternode(address) external;
123   function isMasternodeOwner(address) external view returns (bool);
124   function userHasActiveNodes(address) external view returns (bool);
125 }
126 
127 interface ICaelumMasternode {
128     function _externalArrangeFlow() external;
129     function rewardsProofOfWork() external view returns (uint) ;
130     function rewardsMasternode() external view returns (uint) ;
131     function masternodeIDcounter() external view returns (uint) ;
132     function masternodeCandidate() external view returns (uint) ; 
133     function getUserFromID(uint) external view returns  (address) ;
134     function userCounter() external view returns(uint);
135     function contractProgress() external view returns (uint, uint, uint, uint, uint, uint, uint, uint);
136 }
137 
138 contract ERC20Basic {
139     function totalSupply() public view returns(uint256);
140 
141     function balanceOf(address _who) public view returns(uint256);
142 
143     function transfer(address _to, uint256 _value) public returns(bool);
144     event Transfer(address indexed from, address indexed to, uint256 value);
145 }
146 
147 contract ERC20 is ERC20Basic {
148     function allowance(address _owner, address _spender) public view returns(uint256);
149 
150     function transferFrom(address _from, address _to, uint256 _value) public returns(bool);
151 
152     function approve(address _spender, uint256 _value) public returns(bool);
153 
154     event Approval(
155         address indexed owner,
156         address indexed spender,
157         uint256 value
158     );
159 }
160 
161 contract BasicToken is ERC20Basic {
162     using SafeMath
163     for uint256;
164 
165     mapping(address => uint256) internal balances;
166 
167     uint256 internal totalSupply_;
168 
169     /**
170      * @dev Total number of tokens in existence
171      */
172     function totalSupply() public view returns(uint256) {
173         return totalSupply_;
174     }
175 
176     /**
177      * @dev Transfer token for a specified address
178      * @param _to The address to transfer to.
179      * @param _value The amount to be transferred.
180      */
181     function transfer(address _to, uint256 _value) public returns(bool) {
182         require(_value <= balances[msg.sender]);
183         require(_to != address(0));
184 
185         balances[msg.sender] = balances[msg.sender].sub(_value);
186         balances[_to] = balances[_to].add(_value);
187         emit Transfer(msg.sender, _to, _value);
188         return true;
189     }
190 
191     /**
192      * @dev Gets the balance of the specified address.
193      * @param _owner The address to query the the balance of.
194      * @return An uint256 representing the amount owned by the passed address.
195      */
196     function balanceOf(address _owner) public view returns(uint256) {
197         return balances[_owner];
198     }
199 
200 }
201 
202 contract StandardToken is ERC20, BasicToken {
203 
204     mapping(address => mapping(address => uint256)) internal allowed;
205 
206 
207     /**
208      * @dev Transfer tokens from one address to another
209      * @param _from address The address which you want to send tokens from
210      * @param _to address The address which you want to transfer to
211      * @param _value uint256 the amount of tokens to be transferred
212      */
213     function transferFrom(
214         address _from,
215         address _to,
216         uint256 _value
217     )
218     public
219     returns(bool) {
220         require(_value <= balances[_from]);
221         require(_value <= allowed[_from][msg.sender]);
222         require(_to != address(0));
223 
224         balances[_from] = balances[_from].sub(_value);
225         balances[_to] = balances[_to].add(_value);
226         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
227         emit Transfer(_from, _to, _value);
228         return true;
229     }
230 
231     /**
232      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233      * Beware that changing an allowance with this method brings the risk that someone may use both the old
234      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
235      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
236      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237      * @param _spender The address which will spend the funds.
238      * @param _value The amount of tokens to be spent.
239      */
240     function approve(address _spender, uint256 _value) public returns(bool) {
241         allowed[msg.sender][_spender] = _value;
242         emit Approval(msg.sender, _spender, _value);
243         return true;
244     }
245 
246     /**
247      * @dev Function to check the amount of tokens that an owner allowed to a spender.
248      * @param _owner address The address which owns the funds.
249      * @param _spender address The address which will spend the funds.
250      * @return A uint256 specifying the amount of tokens still available for the spender.
251      */
252     function allowance(
253         address _owner,
254         address _spender
255     )
256     public
257     view
258     returns(uint256) {
259         return allowed[_owner][_spender];
260     }
261 
262     /**
263      * @dev Increase the amount of tokens that an owner allowed to a spender.
264      * approve should be called when allowed[_spender] == 0. To increment
265      * allowed value is better to use this function to avoid 2 calls (and wait until
266      * the first transaction is mined)
267      * From MonolithDAO Token.sol
268      * @param _spender The address which will spend the funds.
269      * @param _addedValue The amount of tokens to increase the allowance by.
270      */
271     function increaseApproval(
272         address _spender,
273         uint256 _addedValue
274     )
275     public
276     returns(bool) {
277         allowed[msg.sender][_spender] = (
278             allowed[msg.sender][_spender].add(_addedValue));
279         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280         return true;
281     }
282 
283     /**
284      * @dev Decrease the amount of tokens that an owner allowed to a spender.
285      * approve should be called when allowed[_spender] == 0. To decrement
286      * allowed value is better to use this function to avoid 2 calls (and wait until
287      * the first transaction is mined)
288      * From MonolithDAO Token.sol
289      * @param _spender The address which will spend the funds.
290      * @param _subtractedValue The amount of tokens to decrease the allowance by.
291      */
292     function decreaseApproval(
293         address _spender,
294         uint256 _subtractedValue
295     )
296     public
297     returns(bool) {
298         uint256 oldValue = allowed[msg.sender][_spender];
299         if (_subtractedValue >= oldValue) {
300             allowed[msg.sender][_spender] = 0;
301         } else {
302             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
303         }
304         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305         return true;
306     }
307 
308 }
309 
310 contract ERC20Interface {
311 
312     function totalSupply() public constant returns (uint);
313 
314     function balanceOf(address tokenOwner) public constant returns (uint balance);
315 
316     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
317 
318     function transfer(address to, uint tokens) public returns (bool success);
319 
320     function approve(address spender, uint tokens) public returns (bool success);
321 
322     function transferFrom(address from, address to, uint tokens) public returns (bool success);
323 
324 
325     event Transfer(address indexed from, address indexed to, uint tokens);
326 
327     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
328 
329 }
330 
331 contract InterfaceContracts is Ownable {
332     InterfaceContracts public _internalMod;
333     
334     function setModifierContract (address _t) onlyOwner public {
335         _internalMod = InterfaceContracts(_t);
336     }
337 
338     modifier onlyMiningContract() {
339       require(msg.sender == _internalMod._contract_miner(), "Wrong sender");
340           _;
341       }
342 
343     modifier onlyTokenContract() {
344       require(msg.sender == _internalMod._contract_token(), "Wrong sender");
345       _;
346     }
347     
348     modifier onlyMasternodeContract() {
349       require(msg.sender == _internalMod._contract_masternode(), "Wrong sender");
350       _;
351     }
352     
353     modifier onlyVotingOrOwner() {
354       require(msg.sender == _internalMod._contract_voting() || msg.sender == owner, "Wrong sender");
355       _;
356     }
357     
358     modifier onlyVotingContract() {
359       require(msg.sender == _internalMod._contract_voting() || msg.sender == owner, "Wrong sender");
360       _;
361     }
362       
363     function _contract_voting () public view returns (address) {
364         return _internalMod._contract_voting();
365     }
366     
367     function _contract_masternode () public view returns (address) {
368         return _internalMod._contract_masternode();
369     }
370     
371     function _contract_token () public view returns (address) {
372         return _internalMod._contract_token();
373     }
374     
375     function _contract_miner () public view returns (address) {
376         return _internalMod._contract_miner();
377     }
378 }
379 
380 contract CaelumAcceptERC20  is InterfaceContracts {
381     using SafeMath for uint;
382 
383     address[] public tokensList;
384     bool setOwnContract = true;
385 
386     struct _whitelistTokens {
387         address tokenAddress;
388         bool active;
389         uint requiredAmount;
390         uint validUntil;
391         uint timestamp;
392     }
393 
394     mapping(address => mapping(address => uint)) public tokens;
395     mapping(address => _whitelistTokens) acceptedTokens;
396 
397     event Deposit(address token, address user, uint amount, uint balance);
398     event Withdraw(address token, address user, uint amount, uint balance);
399 
400     /**
401      * @notice Allow the dev to set it's own token as accepted payment.
402      * @dev Can be hardcoded in the constructor. Given the contract size, we decided to separate it.
403      * @return bool
404      */
405     function addOwnToken() internal returns(bool) {
406         require(setOwnContract);
407         addToWhitelist(this, 5000 * 1e8, 36500);
408         setOwnContract = false;
409         return true;
410     }
411 
412 
413     /**
414      * @notice Add a new token as accepted payment method.
415      * @param _token Token contract address.
416      * @param _amount Required amount of this Token as collateral
417      * @param daysAllowed How many days will we accept this token?
418      */
419     function addToWhitelist(address _token, uint _amount, uint daysAllowed) internal {
420         _whitelistTokens storage newToken = acceptedTokens[_token];
421         newToken.tokenAddress = _token;
422         newToken.requiredAmount = _amount;
423         newToken.timestamp = now;
424         newToken.validUntil = now + (daysAllowed * 1 days);
425         newToken.active = true;
426 
427         tokensList.push(_token);
428     }
429 
430     /**
431      * @dev internal function to determine if we accept this token.
432      * @param _ad Token contract address
433      * @return bool
434      */
435     function isAcceptedToken(address _ad) internal view returns(bool) {
436         return acceptedTokens[_ad].active;
437     }
438 
439     /**
440      * @dev internal function to determine the requiredAmount for a specific token.
441      * @param _ad Token contract address
442      * @return bool
443      */
444     function getAcceptedTokenAmount(address _ad) internal view returns(uint) {
445         return acceptedTokens[_ad].requiredAmount;
446     }
447 
448     /**
449      * @dev internal function to determine if the token is still accepted timewise.
450      * @param _ad Token contract address
451      * @return bool
452      */
453     function isValid(address _ad) internal view returns(bool) {
454         uint endTime = acceptedTokens[_ad].validUntil;
455         if (block.timestamp < endTime) return true;
456         return false;
457     }
458 
459     /**
460      * @notice Returns an array of all accepted token. You can get more details by calling getTokenDetails function with this address.
461      * @return array Address
462      */
463     function listAcceptedTokens() public view returns(address[]) {
464         return tokensList;
465     }
466 
467     /**
468      * @notice Returns a full list of the token details
469      * @param token Token contract address
470      */
471     function getTokenDetails(address token) public view returns(address ad, uint required, bool active, uint valid) {
472         return (acceptedTokens[token].tokenAddress, acceptedTokens[token].requiredAmount, acceptedTokens[token].active, acceptedTokens[token].validUntil);
473     }
474 
475     /**
476      * @notice Public function that allows any user to deposit accepted tokens as collateral to become a masternode.
477      * @param token Token contract address
478      * @param amount Amount to deposit
479      */
480     function depositCollateral(address token, uint amount) public {
481 
482         require(isAcceptedToken(token), "ERC20 not authorised"); // Should be a token from our list
483         require(amount == getAcceptedTokenAmount(token)); // The amount needs to match our set amount
484         require(isValid(token)); // It should be called within the setup timeframe
485 
486 
487         tokens[token][msg.sender] = tokens[token][msg.sender].add(amount);
488         emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
489 
490         require(StandardToken(token).transferFrom(msg.sender, this, amount), "error with transfer");
491         IRemoteFunctions(_contract_masternode())._externalAddMasternode(msg.sender);
492     }
493 
494     /**
495      * @notice Public function that allows any user to withdraw deposited tokens and stop as masternode
496      * @param token Token contract address
497      * @param amount Amount to withdraw
498      */
499     function withdrawCollateral(address token, uint amount) public {
500         require(token != 0, "No token specified"); // token should be an actual address
501         require(isAcceptedToken(token), "ERC20 not authorised"); // Should be a token from our list
502         require(amount == getAcceptedTokenAmount(token)); // The amount needs to match our set amount, allow only one withdrawal at a time.
503         uint amountToWithdraw = amount;
504 
505         tokens[token][msg.sender] = tokens[token][msg.sender] - amount;
506         emit Withdraw(token, msg.sender, amountToWithdraw, amountToWithdraw);
507 
508         require(StandardToken(token).transfer(msg.sender, amountToWithdraw),"error with transfer");
509         IRemoteFunctions(_contract_masternode())._externalStopMasternode(msg.sender);
510     }
511 
512 }
513 
514 contract CaelumToken is CaelumAcceptERC20, StandardToken {
515     using SafeMath for uint;
516 
517     ICaelumMasternode public masternodeInterface;
518 
519     bool public swapClosed = false;
520     bool isOnTestNet = true;
521 
522     string public symbol = "CLM";
523     string public name = "Caelum Token";
524     uint8 public decimals = 8;
525     uint256 public totalSupply = 2100000000000000;
526 
527     address allowedSwapAddress01 = 0x7600bF5112945F9F006c216d5d6db0df2806eDc6;
528     address allowedSwapAddress02 = 0x16Da16948e5092A3D2aA71Aca7b57b8a9CFD8ddb;
529 
530     uint swapStartedBlock;
531 
532     mapping(address => uint) manualSwaps;
533     mapping(address => bool) hasSwapped;
534 
535     event NewSwapRequest(address _swapper, uint _amount);
536     event TokenSwapped(address _swapper, uint _amount);
537 
538     constructor() public {
539         addOwnToken();
540         swapStartedBlock = now;
541     }
542 
543     /**
544      * @dev Allow users to upgrade from our previous tokens.
545      * For trust issues, addresses are hardcoded.
546      * @param _token Token the user wants to swap.
547      */
548     function upgradeTokens(address _token) public {
549         require(!hasSwapped[msg.sender], "User already swapped");
550         require(now <= swapStartedBlock + 1 days, "Timeframe exipred, please use manualUpgradeTokens function");
551         require(_token == allowedSwapAddress01 || _token == allowedSwapAddress02, "Token not allowed to swap.");
552 
553         uint amountToUpgrade = ERC20(_token).balanceOf(msg.sender);
554 
555         require(amountToUpgrade <= ERC20(_token).allowance(msg.sender, this));
556         require(ERC20(_token).transferFrom(msg.sender, this, amountToUpgrade));
557         require(ERC20(_token).balanceOf(msg.sender) == 0);
558 
559         tokens[_token][msg.sender] = tokens[_token][msg.sender].add(amountToUpgrade);
560         balances[msg.sender] = balances[msg.sender].add(amountToUpgrade);
561 
562         emit Transfer(this, msg.sender, amountToUpgrade);
563         emit TokenSwapped(msg.sender, amountToUpgrade);
564 
565         if(
566           ERC20(allowedSwapAddress01).balanceOf(msg.sender) == 0  &&
567           ERC20(allowedSwapAddress02).balanceOf(msg.sender) == 0
568         ) {
569           hasSwapped[msg.sender] = true;
570         }
571 
572     }
573 
574     /**
575      * @dev Allow users to upgrade manualy from our previous tokens.
576      * For trust issues, addresses are hardcoded.
577      * Used when a user failed to swap in time.
578      * Dev should manually verify the origin of these tokens before allowing it.
579      * @param _token Token the user wants to swap.
580      */
581     function manualUpgradeTokens(address _token) public {
582         require(!hasSwapped[msg.sender], "User already swapped");
583         require(now >= swapStartedBlock + 1 days, "Timeframe incorrect");
584         require(_token == allowedSwapAddress01 || _token == allowedSwapAddress02, "Token not allowed to swap.");
585 
586         uint amountToUpgrade = ERC20(_token).balanceOf(msg.sender);
587         require(amountToUpgrade <= ERC20(_token).allowance(msg.sender, this));
588 
589         if (ERC20(_token).transferFrom(msg.sender, this, amountToUpgrade)) {
590             require(ERC20(_token).balanceOf(msg.sender) == 0);
591             if(
592               ERC20(allowedSwapAddress01).balanceOf(msg.sender) == 0  &&
593               ERC20(allowedSwapAddress02).balanceOf(msg.sender) == 0
594             ) {
595               hasSwapped[msg.sender] = true;
596             }
597 
598             tokens[_token][msg.sender] = tokens[_token][msg.sender].add(amountToUpgrade);
599             manualSwaps[msg.sender] = amountToUpgrade;
600             emit NewSwapRequest(msg.sender, amountToUpgrade);
601         }
602     }
603 
604     /**
605      * @dev Allow users to partially upgrade manualy from our previous tokens.
606      * For trust issues, addresses are hardcoded.
607      * Used when a user failed to swap in time.
608      * Dev should manually verify the origin of these tokens before allowing it.
609      * @param _token Token the user wants to swap.
610      */
611     function manualUpgradePartialTokens(address _token, uint _amount) public {
612         require(!hasSwapped[msg.sender], "User already swapped");
613         require(now >= swapStartedBlock + 1 days, "Timeframe incorrect");
614         require(_token == allowedSwapAddress01 || _token == allowedSwapAddress02, "Token not allowed to swap.");
615 
616         uint amountToUpgrade = _amount; //ERC20(_token).balanceOf(msg.sender);
617         require(amountToUpgrade <= ERC20(_token).allowance(msg.sender, this));
618 
619         uint newBalance = ERC20(_token).balanceOf(msg.sender) - (amountToUpgrade);
620         if (ERC20(_token).transferFrom(msg.sender, this, amountToUpgrade)) {
621 
622             require(ERC20(_token).balanceOf(msg.sender) == newBalance, "Balance error.");
623 
624             if(
625               ERC20(allowedSwapAddress01).balanceOf(msg.sender) == 0  &&
626               ERC20(allowedSwapAddress02).balanceOf(msg.sender) == 0
627             ) {
628               hasSwapped[msg.sender] = true;
629             }
630 
631             tokens[_token][msg.sender] = tokens[_token][msg.sender].add(amountToUpgrade);
632             manualSwaps[msg.sender] = amountToUpgrade;
633             emit NewSwapRequest(msg.sender, amountToUpgrade);
634         }
635     }
636 
637     /**
638      * @dev Due to some bugs in the previous contracts, a handfull of users will
639      * be unable to fully withdraw their masternodes. Owner can replace those tokens
640      * who are forever locked up in the old contract with new ones.
641      */
642      function getLockedTokens(address _contract, address _holder) public view returns(uint) {
643          return CaelumAcceptERC20(_contract).tokens(_contract, _holder);
644      }
645 
646     /**
647      * @dev Approve a request for manual token swaps
648      * @param _holder Holder The user who requests a swap.
649      */
650     function approveManualUpgrade(address _holder) onlyOwner public {
651         balances[_holder] = balances[_holder].add(manualSwaps[_holder]);
652         emit Transfer(this, _holder, manualSwaps[_holder]);
653     }
654 
655     /**
656      * @dev Decline a request for manual token swaps
657      * @param _holder Holder The user who requests a swap.
658      */
659     function declineManualUpgrade(address _token, address _holder) onlyOwner public {
660         require(ERC20(_token).transfer(_holder, manualSwaps[_holder]));
661         tokens[_token][_holder] = tokens[_token][_holder] - manualSwaps[_holder];
662         delete manualSwaps[_holder];
663         delete hasSwapped[_holder];
664     }
665 
666     /**
667      * @dev Due to some bugs in the previous contracts, a handfull of users will
668      * be unable to fully withdraw their masternodes. Owner can replace those tokens
669      * who are forever locked up in the old contract with new ones.
670      */
671      function replaceLockedTokens(address _contract, address _holder) onlyOwner public {
672          uint amountLocked = getLockedTokens(_contract, _holder);
673          balances[_holder] = balances[_holder].add(amountLocked);
674          emit Transfer(this, _holder, amountLocked);
675          hasSwapped[msg.sender] = true;
676      }
677 
678     /**
679      * @dev Used to grant the mining contract rights to reward users.
680      * As our contracts are separate, we call this function with modifier onlyMiningContract to sent out rewards.
681      * @param _receiver Who receives the mining reward.
682      * @param _amount What amount to reward.
683      */
684     function rewardExternal(address _receiver, uint _amount) onlyMiningContract public {
685         balances[_receiver] = balances[_receiver].add(_amount);
686         emit Transfer(this, _receiver, _amount);
687     }
688 
689     /**
690      * @dev We allow the masternodecontract to add tokens to our whitelist. By this approach,
691      * we can move all voting logic to a contract that can be upgraden when needed.
692      */
693     function addToWhitelistExternal(address _token, uint _amount, uint daysAllowed) onlyMasternodeContract public {
694         addToWhitelist( _token, _amount, daysAllowed);
695     }
696 
697     /**
698      * @dev Fetch data from the actual reward. We do this to prevent pools payout out
699      * the global reward instead of the calculated ones.
700      * By default, pools fetch the `getMiningReward()` value and will payout this amount.
701      */
702     function getMiningRewardForPool() public view returns(uint) {
703         return masternodeInterface.rewardsProofOfWork();
704     }
705 
706     /**
707      * @dev Return the Proof of Work reward from the masternode contract.
708      */
709     function rewardsProofOfWork() public view returns(uint) {
710         return masternodeInterface.rewardsProofOfWork();
711     }
712 
713     /**
714      * @dev Return the masternode reward from the masternode contract.
715      */
716     function rewardsMasternode() public view returns(uint) {
717         return masternodeInterface.rewardsMasternode();
718     }
719 
720     /**
721      * @dev Return the number of masternodes from the masternode contract.
722      */
723     function masternodeCounter() public view returns(uint) {
724         return masternodeInterface.userCounter();
725     }
726 
727     /**
728      * @dev Return the general state from the masternode contract.
729      */
730     function contractProgress() public view returns
731     (
732         uint epoch,
733         uint candidate,
734         uint round,
735         uint miningepoch,
736         uint globalreward,
737         uint powreward,
738         uint masternodereward,
739         uint usercounter
740     )
741     {
742         return ICaelumMasternode(_contract_masternode()).contractProgress();
743 
744     }
745 
746     /**
747      * @dev pull new masternode contract from the modifier contract
748      */
749     function setMasternodeContract() internal  {
750         masternodeInterface = ICaelumMasternode(_contract_masternode());
751     }
752 
753     /**
754      * Override; For some reason, truffle testing does not recognize function.
755      * Remove before live?
756      */
757     function setModifierContract (address _contract) onlyOwner public {
758         require (now <= swapStartedBlock + 10 days);
759         _internalMod = InterfaceContracts(_contract);
760         setMasternodeContract();
761     }
762 
763     /**
764     * @dev Move the voting away from token. All votes will be made from the voting
765     */
766     function VoteModifierContract (address _contract) onlyVotingContract external {
767         //_internalMod = CaelumModifierAbstract(_contract);
768         _internalMod = InterfaceContracts(_contract);
769         setMasternodeContract();
770     }
771     
772     /**
773      * Owner can transfer out any accidentally sent ERC20 tokens
774      */
775     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
776         return ERC20Interface(tokenAddress).transfer(owner, tokens);
777     }
778 
779     /**
780      * @dev Needed for testnet only. Comment codeblock out before deploy, leave it as example.
781      */
782     /** 
783     function setSwap(address _contract, address _contract_2) onlyOwner public {
784         require (isOnTestNet == true);
785         allowedSwapAddress01 = _contract;
786         allowedSwapAddress02 = _contract_2;
787     }
788     */
789 
790 
791 }