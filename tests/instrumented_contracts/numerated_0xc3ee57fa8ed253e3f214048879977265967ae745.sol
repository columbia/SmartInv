1 pragma solidity ^0.4.23;
2     /**
3     * @title ERC20Basic
4     * @dev Simpler version of ERC20 interface
5     * @dev see https://github.com/ethereum/EIPs/issues/179
6     */
7     contract ERC20Basic {
8      function totalSupply() public view returns (uint256);
9      function balanceOf(address who) public view returns (uint256);
10      function transfer(address to, uint256 value) public returns (bool);
11      event Transfer(address indexed from, address indexed to, uint256 value);
12    }
13     /**
14     * @title Ownable
15     * @dev The Ownable contract has an owner address, and provides basic authorization control
16     * functions, this simplifies the implementation of "user permissions".
17     */
18     contract Ownable {
19      address public owner;
20      event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21      /**
22       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23       * account.
24       */
25       constructor() public {
26        owner = msg.sender;
27      }
28      /**
29       * @dev Throws if called by any account other than the owner.
30       */
31       modifier onlyOwner() {
32        require(msg.sender == owner);
33        _;
34      }
35      /**
36       * @dev Allows the current owner to transfer control of the contract to a newOwner.
37       * @param newOwner The address to transfer ownership to.
38       */
39       function transferOwnership(address newOwner) public onlyOwner {
40        require(newOwner != address(0));
41        emit OwnershipTransferred(owner, newOwner);
42        owner = newOwner;
43      }
44    }
45 
46 
47 
48     /**
49     * @title Pausable
50     * @dev Base contract which allows children to implement an emergency stop mechanism.
51     */
52     contract Pausable is Ownable {
53      event Pause();
54      event Unpause();
55 
56      bool public paused = false;
57 
58 
59      /**
60       * @dev Modifier to make a function callable only when the contract is not paused.
61       */
62       modifier whenNotPaused() {
63        require(!paused);
64        _;
65      }
66 
67      /**
68       * @dev Modifier to make a function callable only when the contract is paused.
69       */
70       modifier whenPaused() {
71        require(paused);
72        _;
73      }
74 
75      /**
76       * @dev called by the owner to pause, triggers stopped state
77       */
78       function pause() onlyOwner whenNotPaused public {
79        paused = true;
80        emit Pause();
81      }
82 
83      /**
84       * @dev called by the owner to unpause, returns to normal state
85       */
86       function unpause() onlyOwner whenPaused public {
87        paused = false;
88        emit Unpause();
89      }
90    }
91 
92     /**
93     * @title Whitelist
94     * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
95     * @dev This simplifies the implementation of "user permissions".
96     */
97     contract Whitelist is Pausable {
98      mapping(address => bool) public whitelist;
99 
100      event WhitelistedAddressAdded(address addr);
101      event WhitelistedAddressRemoved(address addr);
102      /**
103       * @dev Throws if called by any account that's not whitelisted.
104       */
105       modifier onlyWhitelisted() {
106        require(whitelist[msg.sender]);
107        _;
108      }
109      /**
110       * @dev add an address to the whitelist
111       * @param addr address
112       * @return true if the address was added to the whitelist, false if the address was already in the whitelist
113       */
114       function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
115        if (!whitelist[addr]) {
116          whitelist[addr] = true;
117          emit WhitelistedAddressAdded(addr);
118          success = true;
119        }
120      }
121      /**
122       * @dev add addresses to the whitelist
123       * @param addrs addresses
124       * @return true if at least one address was added to the whitelist,
125       * false if all addresses were already in the whitelist
126       */
127       function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
128        for (uint256 i = 0; i < addrs.length; i++) {
129          if (addAddressToWhitelist(addrs[i])) {
130            success = true;
131          }
132        }
133      }
134      /**
135       * @dev remove an address from the whitelist
136       * @param addr address
137       * @return true if the address was removed from the whitelist,
138       * false if the address wasn't in the whitelist in the first place
139       */
140       function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
141        if (whitelist[addr]) {
142          whitelist[addr] = false;
143          emit WhitelistedAddressRemoved(addr);
144          success = true;
145        }
146      }
147      /**
148       * @dev remove addresses from the whitelist
149       * @param addrs addresses
150       * @return true if at least one address was removed from the whitelist,
151       * false if all addresses weren't in the whitelist in the first place
152       */
153       function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
154        for (uint256 i = 0; i < addrs.length; i++) {
155          if (removeAddressFromWhitelist(addrs[i])) {
156            success = true;
157          }
158        }
159      }
160    }
161     /**
162     * @title ERC20 interface
163     * @dev see https://github.com/ethereum/EIPs/issues/20
164     */
165     contract ERC20 is ERC20Basic {
166      function allowance(address owner, address spender) public view returns (uint256);
167      function transferFrom(address from, address to, uint256 value) public returns (bool);
168      function approve(address spender, uint256 value) public returns (bool);
169      event Approval(address indexed owner, address indexed spender, uint256 value);
170    }
171     /**
172     * @title SafeMath
173     * @dev Math operations with safety checks that throw on error
174     */
175     library SafeMath {
176      /**
177      * @dev Multiplies two numbers, throws on overflow.
178      */
179      function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180        if (a == 0) {
181          return 0;
182        }
183        uint256 c = a * b;
184        assert(c / a == b);
185        return c;
186      }
187      /**
188      * @dev Integer division of two numbers, truncating the quotient.
189      */
190      function div(uint256 a, uint256 b) internal pure returns (uint256) {
191        // assert(b > 0); // Solidity automatically throws when dividing by 0
192        uint256 c = a / b;
193        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194        return c;
195      }
196      /**
197      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
198      */
199      function sub(uint256 a, uint256 b) internal pure returns (uint256) {
200        assert(b <= a);
201        return a - b;
202      }
203      /**
204      * @dev Adds two numbers, throws on overflow.
205      */
206      function add(uint256 a, uint256 b) internal pure returns (uint256) {
207        uint256 c = a + b;
208        assert(c >= a);
209        return c;
210      }
211    }
212     /**
213     * @title Crowdsale
214     * @dev Crowdsale is a base contract for managing a token crowdsale,
215     * allowing investors to purchase tokens with ether. This contract implements
216     * such functionality in its most fundamental form and can be extended to provide additional
217     * functionality and/or custom behavior.
218     * The external interface represents the basic interface for purchasing tokens, and conform
219     * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
220     * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
221     * the methods to add functionality. Consider using 'super' where appropiate to concatenate
222     * behavior.
223     */
224     contract Crowdsale is Whitelist{
225      using SafeMath for uint256;
226      // The token being sold
227      MiniMeToken public token;
228      // Address where funds are collected
229      address public wallet;
230      // How many token units a buyer gets per wei
231      uint256 public rate = 6120;
232      // Amount of tokens sold
233      uint256 public tokensSold;
234     //Star of the crowdsale
235      uint256 startTime;
236 
237 
238 
239      /**
240       * Event for token purchase logging
241       * @param purchaser who paid for the tokens
242       * @param beneficiary who got the tokens
243       * @param value weis paid for purchase
244       * @param amount amount of tokens purchased
245       */
246       event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
247 
248       event buyx(address buyer, address contractAddr, uint256 amount);
249 
250       constructor(address _wallet, MiniMeToken _token, uint256 starttime) public{
251 
252        require(_wallet != address(0));
253        require(_token != address(0));
254 
255        wallet = _wallet;
256        token = _token;
257        startTime = starttime;
258      }
259      function setCrowdsale(address _wallet, MiniMeToken _token, uint256 starttime) public{
260 
261 
262        require(_wallet != address(0));
263        require(_token != address(0));
264 
265        wallet = _wallet;
266        token = _token;
267        startTime = starttime;
268      }
269 
270 
271 
272      // -----------------------------------------
273      // Crowdsale external interface
274      // -----------------------------------------
275      /**
276       *  fallback function ***DO NOT OVERRIDE***
277       */
278       function () external whenNotPaused payable {
279         emit buyx(msg.sender, this, _getTokenAmount(msg.value));
280         buyTokens(msg.sender);
281       }
282      /**
283       * @dev low level token purchase ***DO NOT OVERRIDE***
284       * @param _beneficiary Address performing the token purchase
285       */
286      function buyTokens(address _beneficiary) public whenNotPaused payable {
287       
288        if ((tokensSold > 20884500000000000000000000 ) && (tokensSold <= 30791250000000000000000000)) {
289          rate = 5967;
290        }
291        else if ((tokensSold > 30791250000000000000000000) && (tokensSold <= 39270000000000000000000000)) {
292         rate = 5865;
293        }
294        else if ((tokensSold > 39270000000000000000000000) && (tokensSold <= 46856250000000000000000000)) {
295         rate = 5610;
296        }
297        else if ((tokensSold > 46856250000000000000000000) && (tokensSold <= 35700000000000000000000000)) {
298         rate = 5355;
299        }
300        else if (tokensSold > 35700000000000000000000000) {
301         rate = 5100;
302        }
303 
304 
305       uint256 weiAmount = msg.value;
306       uint256 tokens = _getTokenAmount(weiAmount);
307       tokensSold = tokensSold.add(tokens);
308       _processPurchase(_beneficiary, tokens);
309       emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
310       _updatePurchasingState(_beneficiary, weiAmount);
311       _forwardFunds();
312       _postValidatePurchase(_beneficiary, weiAmount);
313     }
314 
315     // -----------------------------------------
316     // Internal interface (extensible)
317     // -----------------------------------------
318 
319 
320 
321      /**
322       * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
323       * @param _beneficiary Address performing the token purchase
324       * @param _weiAmount Value in wei involved in the purchase
325       */
326       function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
327        require(_beneficiary != address(0));
328        require(_weiAmount != 0);
329      }
330      /**
331       * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
332       * @param _beneficiary Address performing the token purchase
333       * @param _weiAmount Value in wei involved in the purchase
334       */
335       function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
336        // optional override
337      }
338      /**
339       * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
340       * @param _beneficiary Address performing the token purchase
341       * @param _tokenAmount Number of tokens to be emitted
342       */
343       function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
344        token.transfer(_beneficiary, _tokenAmount);
345      }
346      /**
347       * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
348       * @param _beneficiary Address receiving the tokens
349       * @param _tokenAmount Number of tokens to be purchased
350       */
351       function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
352        _deliverTokens(_beneficiary, _tokenAmount);
353      }
354      /**
355       * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
356       * @param _beneficiary Address receiving the tokens
357       * @param _weiAmount Value in wei involved in the purchase
358       */
359       function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
360        // optional override
361      }
362      /**
363       * @dev Override to extend the way in which ether is converted to tokens.
364       * @param _weiAmount Value in wei to be converted into tokens
365       * @return Number of tokens that can be purchased with the specified _weiAmount
366       */
367       function _getTokenAmount(uint256 _weiAmount) internal  returns (uint256) {
368 
369        return _weiAmount.mul(rate);
370      }
371 
372      /**
373       * @dev Determines how ETH is stored/forwarded on purchases.
374       */
375       function _forwardFunds() internal {
376        wallet.transfer(msg.value);
377      }
378 
379    }
380 
381 
382 
383    contract EmaCrowdSale is Crowdsale {
384     uint256 public hardcap;
385     uint256 public starttime;
386     Crowdsale public csale;
387     using SafeMath for uint256; 
388     constructor(address wallet, MiniMeToken token, uint256 startTime, uint256 cap) Crowdsale(wallet, token, starttime) public onlyOwner
389     {
390 
391       hardcap = cap;
392       starttime = startTime;
393       setCrowdsale(wallet, token, startTime);
394     }
395 
396 function tranferPresaleTokens(address investor, uint256 ammount)public onlyOwner{
397     tokensSold = tokensSold.add(ammount); 
398     token.transferFrom(this, investor, ammount); 
399 }
400 
401     function setTokenTransferState(bool state) public onlyOwner {
402      token.changeController(this);
403      token.enableTransfers(state);
404    }
405 
406    function claim(address claimToken) public onlyOwner {
407      token.changeController(this);
408      token.claimTokens(claimToken);
409    }
410 
411    function () external payable onlyWhitelisted whenNotPaused{
412 
413     emit buyx(msg.sender, this, _getTokenAmount(msg.value));
414 
415     buyTokens(msg.sender);
416   }
417 
418 
419 }
420 
421 
422 
423 
424 
425 
426 contract Controlled is Pausable {
427  /// @notice The address of the controller is the only address that can call
428  ///  a function with this modifier
429  modifier onlyController { require(msg.sender == controller); _; }
430  modifier onlyControllerorOwner { require((msg.sender == controller) || (msg.sender == owner)); _; }
431  address public controller;
432  constructor() public { controller = msg.sender;}
433  /// @notice Changes the controller of the contract
434  /// @param _newController The new controller of the contract
435  function changeController(address _newController) public onlyControllerorOwner {
436    controller = _newController;
437  }
438 }
439 /// @dev The token controller contract must implement these functions
440 contract TokenController {
441  /// @notice Called when `_owner` sends ether to the MiniMe Token contract
442  /// @param _owner The address that sent the ether to create tokens
443  /// @return True if the ether is accepted, false if it throws
444  function proxyPayment(address _owner) public payable returns(bool);
445  /// @notice Notifies the controller about a token transfer allowing the
446  ///  controller to react if desired
447  /// @param _from The origin of the transfer
448  /// @param _to The destination of the transfer
449  /// @param _amount The amount of the transfer
450  /// @return False if the controller does not authorize the transfer
451  function onTransfer(address _from, address _to, uint _amount) public returns(bool);
452  /// @notice Notifies the controller about an approval allowing the
453  ///  controller to react if desired
454  /// @param _owner The address that calls `approve()`
455  /// @param _spender The spender in the `approve()` call
456  /// @param _amount The amount in the `approve()` call
457  /// @return False if the controller does not authorize the approval
458  function onApprove(address _owner, address _spender, uint _amount) public
459  returns(bool);
460 }
461     /*
462        Copyright 2016, Jordi Baylina
463        This program is free software: you can redistribute it and/or modify
464        it under the terms of the GNU General Public License as published by
465        the Free Software Foundation, either version 3 of the License, or
466        (at your option) any later version.
467        This program is distributed in the hope that it will be useful,
468        but WITHOUT ANY WARRANTY; without even the implied warranty of
469        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
470        GNU General Public License for more details.
471        You should have received a copy of the GNU General Public License
472        along with this program.  If not, see <http://www.gnu.org/licenses/>.
473        */
474        /// @title MiniMeToken Contract
475        /// @author Jordi Baylina
476        /// @dev This token contract's goal is to make it easy for anyone to clone this
477        ///  token using the token distribution at a given block, this will allow DAO's
478        ///  and DApps to upgrade their features in a decentralized manner without
479        ///  affecting the original token
480        /// @dev It is ERC20 compliant, but still needs to under go further testing.
481        contract ApproveAndCallFallBack {
482          function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
483        }
484        /// @dev The actual token contract, the default controller is the msg.sender
485        ///  that deploys the contract, so usually this token will be deployed by a
486        ///  token controller contract, which Giveth will call a "Campaign"
487        contract MiniMeToken is Controlled
488        {
489          using SafeMath for uint256;
490          string public name;                //The Token's name: e.g. DigixDAO Tokens
491          uint8 public decimals;             //Number of decimals of the smallest unit
492          string public symbol;              //An identifier: e.g. REP
493          string public version = 'V 1.0'; //An arbitrary versioning scheme
494          /// @dev `Checkpoint` is the structure that attaches a block number to a
495          ///  given value, the block number attached is the one that last changed the
496          ///  value
497          struct  Checkpoint {
498            // `fromBlock` is the block number that the value was generated from
499            uint128 fromBlock;
500            // `value` is the amount of tokens at a specific block number
501            uint128 value;
502          }
503          // `parentToken` is the Token address that was cloned to produce this token;
504          //  it will be 0x0 for a token that was not cloned
505          MiniMeToken public parentToken;
506          // `parentSnapShotBlock` is the block number from the Parent Token that was
507          //  used to determine the initial distribution of the Clone Token
508          uint public parentSnapShotBlock;
509          // `creationBlock` is the block number that the Clone Token was created
510          uint public creationBlock;
511          // `balances` is the map that tracks the balance of each address, in this
512          //  contract when the balance changes the block number that the change
513          //  occurred is also included in the map
514          mapping (address => Checkpoint[]) balances;
515          // `allowed` tracks any extra transfer rights as in all ERC20 tokens
516          mapping (address => mapping (address => uint256)) allowed;
517          // Tracks the history of the `totalSupply` of the token
518          Checkpoint[] totalSupplyHistory;
519          // Flag that determines if the token is transferable or not.
520          bool public transfersEnabled;
521          // The factory used to create new clone tokens
522          MiniMeTokenFactory public tokenFactory;
523          ////////////////
524          // Constructor
525          ////////////////
526          /// @notice Constructor to create a MiniMeToken
527          /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
528          ///  will create the Clone token contracts, the token factory needs to be
529          ///  deployed first
530          /// @param _parentToken Address of the parent token, set to 0x0 if it is a
531          ///  new token
532          /// @param _parentSnapShotBlock Block of the parent token that will
533          ///  determine the initial distribution of the clone token, set to 0 if it
534          ///  is a new token
535          /// @param _tokenName Name of the new token
536          /// @param _decimalUnits Number of decimals of the new token
537          /// @param _tokenSymbol Token Symbol for the new token
538          /// @param _transfersEnabled If true, tokens will be able to be transferred
539          constructor(
540            address _tokenFactory,
541            address _parentToken,
542            uint _parentSnapShotBlock,
543            string _tokenName,
544            uint8 _decimalUnits,
545            string _tokenSymbol,
546            bool _transfersEnabled
547            ) public {
548            tokenFactory = MiniMeTokenFactory(_tokenFactory);
549            name = _tokenName;                                 // Set the name
550            decimals = _decimalUnits;                          // Set the decimals
551            symbol = _tokenSymbol;                             // Set the symbol
552            parentToken = MiniMeToken(_parentToken);
553            parentSnapShotBlock = _parentSnapShotBlock;
554            transfersEnabled = _transfersEnabled;
555            creationBlock = block.number;
556          }
557          ///////////////////
558          // ERC20 Methods
559          ///////////////////
560          /// @notice Send `_amount` tokens to `_to` from `msg.sender`
561          /// @param _to The address of the recipient
562          /// @param _amount The amount of tokens to be transferred
563          /// @return Whether the transfer was successful or not
564          function transfer(address _to, uint256 _amount) public returns (bool success)  {
565            require(transfersEnabled);
566            doTransfer(msg.sender, _to, _amount);
567            return true;
568          }
569          /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
570          ///  is approved by `_from`
571          /// @param _from The address holding the tokens being transferred
572          /// @param _to The address of the recipient
573          /// @param _amount The amount of tokens to be transferred
574          /// @return True if the transfer was successful
575          function transferFrom(address _from, address _to, uint256 _amount
576            ) public  returns (bool success) {
577            // The controller of this contract can move tokens around at will,
578            //  this is important to recognize! Confirm that you trust the
579            //  controller of this contract, which in most situations should be
580            //  another open source smart contract or 0x0
581            if (msg.sender != controller) {
582              require(transfersEnabled);
583              // The standard ERC 20 transferFrom functionality
584              require(allowed[_from][msg.sender] >= _amount);
585              allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
586            }
587            doTransfer(_from, _to, _amount);
588            return true;
589          }
590 
591          /// @dev This is the actual transfer function in the token contract, it can
592          ///  only be called by other functions in this contract.
593          /// @param _from The address holding the tokens being transferred
594          /// @param _to The address of the recipient
595          /// @param _amount The amount of tokens to be transferred
596          /// @return True if the transfer was successful
597          function doTransfer(address _from, address _to, uint _amount
598            ) internal {
599           if (_amount == 0) {
600             emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
601             return;
602           }
603 
604           // Do not allow transfer to 0x0 or the token contract itself
605           require((_to != 0) && (_to != address(this)));
606           // If the amount being transfered is more than the balance of the
607           //  account the transfer throws
608           uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
609           require(previousBalanceFrom >= _amount);
610           //  sending the tokens
611           updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
612           // Then update the balance array with the new value for the address
613           //  receiving the tokens
614           uint256 previousBalanceTo = balanceOfAt(_to, block.number);
615           require(previousBalanceTo.add(_amount) >= previousBalanceTo); // Check for overflow
616           updateValueAtNow(balances[_to], previousBalanceTo.add(_amount));
617           // An event to make the transfer easy to find on the blockchain
618           emit Transfer(_from, _to, _amount);
619         }
620         /// @param _owner The address that's balance is being requested
621         /// @return The balance of `_owner` at the current block
622         function balanceOf(address _owner) public constant returns (uint256 balance) {
623          return balanceOfAt(_owner, block.number);
624        }
625        /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
626        ///  its behalf. This is a modified version of the ERC20 approve function
627        ///  to be a little bit safer
628        /// @param _spender The address of the account able to transfer the tokens
629        /// @param _amount The amount of tokens to be approved for transfer
630        /// @return True if the approval was successful
631        function approve(address _spender, uint256 _amount) public returns (bool success) {
632         require(transfersEnabled);
633         // To change the approve amount you first have to reduce the addresses`
634         //  allowance to zero by calling `approve(_spender,0)` if it is not
635         //  already 0 to mitigate the race condition described here:
636         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
637         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
638         //  Alerts the token controller of the approve function call
639         if (isContract(controller)) {
640          require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
641        }
642        allowed[msg.sender][_spender] = _amount;
643        emit Approval(msg.sender, _spender, _amount);
644        return true;
645      }
646      /// @dev This function makes it easy to read the `allowed[]` map
647      /// @param _owner The address of the account that owns the token
648      /// @param _spender The address of the account able to transfer the tokens
649      /// @return Amount of remaining tokens of _owner that _spender is allowed
650      ///  to spend
651      function allowance(address _owner, address _spender
652        ) public constant returns (uint256 remaining) {
653        return allowed[_owner][_spender];
654      }
655      /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
656      ///  its behalf, and then a function is triggered in the contract that is
657      ///  being approved, `_spender`. This allows users to use their tokens to
658      ///  interact with contracts in one function call instead of two
659      /// @param _spender The address of the contract able to transfer the tokens
660      /// @param _amount The amount of tokens to be approved for transfer
661      /// @return True if the function call was successful
662      function approveAndCall(address _spender, uint256 _amount, bytes _extraData
663        ) public returns (bool success) {
664        require(approve(_spender, _amount));
665        ApproveAndCallFallBack(_spender).receiveApproval(
666          msg.sender,
667          _amount,
668          this,
669          _extraData
670          );
671        return true;
672      }
673      /// @dev This function makes it easy to get the total number of tokens
674      /// @return The total number of tokens
675      function totalSupply() public constant returns (uint) {
676        return totalSupplyAt(block.number);
677      }
678      ////////////////
679      // Query balance and totalSupply in History
680      ////////////////
681      /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
682      /// @param _owner The address from which the balance will be retrieved
683      /// @param _blockNumber The block number when the balance is queried
684      /// @return The balance at `_blockNumber`
685      function balanceOfAt(address _owner, uint _blockNumber) public constant
686      returns (uint) {
687        // These next few lines are used when the balance of the token is
688        //  requested before a check point was ever created for this token, it
689        //  requires that the `parentToken.balanceOfAt` be queried at the
690        //  genesis block for that token as this contains initial balance of
691        //  this token
692        if ((balances[_owner].length == 0)
693          || (balances[_owner][0].fromBlock > _blockNumber)) {
694          if (address(parentToken) != 0) {
695            return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
696            } else {
697              // Has no parent
698              return 0;
699            }
700            // This will return the expected balance during normal situations
701            } else {
702              return getValueAt(balances[_owner], _blockNumber);
703            }
704          }
705          /// @notice Total amount of tokens at a specific `_blockNumber`.
706          /// @param _blockNumber The block number when the totalSupply is queried
707          /// @return The total amount of tokens at `_blockNumber`
708          function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
709            // These next few lines are used when the totalSupply of the token is
710            //  requested before a check point was ever created for this token, it
711            //  requires that the `parentToken.totalSupplyAt` be queried at the
712            //  genesis block for this token as that contains totalSupply of this
713            //  token at this block number.
714            if ((totalSupplyHistory.length == 0)
715              || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
716              if (address(parentToken) != 0) {
717                return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
718                } else {
719                  return 0;
720                }
721                // This will return the expected totalSupply during normal situations
722                } else {
723                  return getValueAt(totalSupplyHistory, _blockNumber);
724                }
725              }
726              
727              ////////////////
728              // Generate and destroy tokens
729              ////////////////
730              /// @notice Generates `_amount` tokens that are assigned to `_owner`
731              /// @param _owner The address that will be assigned the new tokens
732              /// @param _amount The quantity of tokens generated
733              /// @return True if the tokens are generated correctly
734              function generateTokens(address _owner, uint _amount
735                ) public onlyControllerorOwner whenNotPaused  returns (bool) {
736                uint curTotalSupply = totalSupply();
737                require(curTotalSupply.add(_amount) >= curTotalSupply); // Check for overflow
738                uint previousBalanceTo = balanceOf(_owner);
739                require(previousBalanceTo.add(_amount) >= previousBalanceTo); // Check for overflow
740                updateValueAtNow(totalSupplyHistory, curTotalSupply.add(_amount));
741                updateValueAtNow(balances[_owner], previousBalanceTo.add(_amount));
742                emit Transfer(0, _owner, _amount);
743                return true;
744              }
745              /// @notice Burns `_amount` tokens from `_owner`
746              /// @param _owner The address that will lose the tokens
747              /// @param _amount The quantity of tokens to burn
748              /// @return True if the tokens are burned correctly
749              function destroyTokens(address _owner, uint _amount
750                ) onlyControllerorOwner public returns (bool) {
751                uint curTotalSupply = totalSupply();
752                require(curTotalSupply >= _amount);
753                uint previousBalanceFrom = balanceOf(_owner);
754                require(previousBalanceFrom >= _amount);
755                updateValueAtNow(totalSupplyHistory, curTotalSupply.sub(_amount));
756                updateValueAtNow(balances[_owner], previousBalanceFrom.sub(_amount));
757                emit Transfer(_owner, 0, _amount);
758                return true;
759              }
760              ////////////////
761              // Enable tokens transfers
762              ////////////////
763              /// @notice Enables token holders to transfer their tokens freely if true
764              /// @param _transfersEnabled True if transfers are allowed in the clone
765              function enableTransfers(bool _transfersEnabled) public onlyControllerorOwner {
766                transfersEnabled = _transfersEnabled;
767              }
768              ////////////////
769              // Internal helper functions to query and set a value in a snapshot array
770              ////////////////
771              /// @dev `getValueAt` retrieves the number of tokens at a given block number
772              /// @param checkpoints The history of values being queried
773              /// @param _block The block number to retrieve the value at
774              /// @return The number of tokens being queried
775              function getValueAt(Checkpoint[] storage checkpoints, uint _block
776                ) constant internal returns (uint) {
777                if (checkpoints.length == 0) return 0;
778                // Shortcut for the actual value
779                if (_block >= checkpoints[checkpoints.length.sub(1)].fromBlock)
780                return checkpoints[checkpoints.length.sub(1)].value;
781                if (_block < checkpoints[0].fromBlock) return 0;
782                // Binary search of the value in the array
783                uint min = 0;
784                uint max = checkpoints.length.sub(1);
785                while (max > min) {
786                  uint mid = (max.add(min).add(1)).div(2);
787                  if (checkpoints[mid].fromBlock<=_block) {
788                    min = mid;
789                    } else {
790                      max = mid.sub(1);
791                    }
792                  }
793                  return checkpoints[min].value;
794                }
795                /// @dev `updateValueAtNow` used to update the `balances` map and the
796                ///  `totalSupplyHistory`
797                /// @param checkpoints The history of data being updated
798                /// @param _value The new number of tokens
799                function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
800                  ) internal  {
801                  if ((checkpoints.length == 0)
802                    || (checkpoints[checkpoints.length.sub(1)].fromBlock < block.number)) {
803                   Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
804                   newCheckPoint.fromBlock =  uint128(block.number);
805                   newCheckPoint.value = uint128(_value);
806                   } else {
807                     Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length.sub(1)];
808                     oldCheckPoint.value = uint128(_value);
809                   }
810                 }
811                 /// @dev Internal function to determine if an address is a contract
812                 /// @param _addr The address being queried
813                 /// @return True if `_addr` is a contract
814                 function isContract(address _addr) constant internal returns(bool) {
815                  uint size;
816                  if (_addr == 0) return false;
817                  assembly {
818                    size := extcodesize(_addr)
819                  }
820                  return size>0;
821                }
822                /// @dev Helper function to return a min betwen the two uints
823                function min(uint a, uint b) pure internal returns (uint) {
824                  return a < b ? a : b;
825                }
826                /// @notice The fallback function: If the contract's controller has not been
827                ///  set to 0, then the `proxyPayment` method is called which relays the
828                ///  ether and creates tokens as described in the token controller contract
829                function () public payable {
830            /*require(isContract(controller));
831            require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));*/
832            revert();
833          }
834          //////////
835          // Safety Methods
836          //////////
837          /// @notice This method can be used by the controller to extract mistakenly
838          ///  sent tokens to this contract.
839          /// @param _token The address of the token contract that you want to recover
840          ///  set to 0 in case you want to extract ether.
841          function claimTokens(address _token) public onlyControllerorOwner {
842            if (_token == 0x0) {
843              controller.transfer(address(this).balance);
844              return;
845            }
846            MiniMeToken token = MiniMeToken(_token);
847            uint balance = token.balanceOf(this);
848            token.transfer(controller, balance);
849            emit ClaimedTokens(_token, controller, balance);
850          }
851          ////////////////
852          // Events
853          ////////////////
854          event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
855          event Transfer(address indexed _from, address indexed _to, uint256 _amount);
856          event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
857          event Approval(
858            address indexed _owner,
859            address indexed _spender,
860            uint256 _amount
861            );
862        }
863        ////////////////
864        // MiniMeTokenFactory
865        ////////////////
866        /// @dev This contract is used to generate clone contracts from a contract.
867        ///  In solidity this is the way to create a contract from a contract of the
868        ///  same class
869        contract MiniMeTokenFactory {
870          /// @notice Update the DApp by creating a new token with new functionalities
871          ///  the msg.sender becomes the controller of this clone token
872          /// @param _parentToken Address of the token being cloned
873          /// @param _snapshotBlock Block of the parent token that will
874          ///  determine the initial distribution of the clone token
875          /// @param _tokenName Name of the new token
876          /// @param _decimalUnits Number of decimals of the new token
877          /// @param _tokenSymbol Token Symbol for the new token
878          /// @param _transfersEnabled If true, tokens will be able to be transferred
879          /// @return The address of the new token contract
880          function createCloneToken(
881            address _parentToken,
882            uint _snapshotBlock,
883            string _tokenName,
884            uint8 _decimalUnits,
885            string _tokenSymbol,
886            bool _transfersEnabled
887            ) public returns (MiniMeToken) {
888            MiniMeToken newToken = new MiniMeToken(
889              this,
890              _parentToken,
891              _snapshotBlock,
892              _tokenName,
893              _decimalUnits,
894              _tokenSymbol,
895              _transfersEnabled
896              );
897            newToken.changeController(msg.sender);
898            return newToken;
899          }
900        }
901 
902        contract EmaToken is MiniMeToken {
903         constructor(address tokenfactory, address parenttoken, uint parentsnapshot, string tokenname, uint8 dec, string tokensymbol, bool transfersenabled)
904         MiniMeToken(tokenfactory, parenttoken, parentsnapshot, tokenname, dec, tokensymbol, transfersenabled) public{
905         }
906       }
907       contract Configurator is Ownable {
908         EmaToken public token = EmaToken(0xC3EE57Fa8eD253E3F214048879977265967AE745);
909         EmaCrowdSale public crowdsale = EmaCrowdSale(0xAd97aF045F815d91621040809F863a5fb070B52d);
910         address ownerWallet = 0x3046751e1d843748b4983D7bca58ECF6Ef1e5c77;
911         address tokenfactory = 0xB74AA356913316ce49626527AE8543FFf23bB672;
912         address fundsWallet = 0x3046751e1d843748b4983D7bca58ECF6Ef1e5c77;
913         address incetivesPool = 0x95eac65414a6a650E2c71e3480AeEF0cF76392FA;
914         address FoundersAndTeam = 0x88C952c4A8fc156b883318CdA8b4a5279d989391;
915         address FuturePartners = 0x5B0333399E0D8F3eF1e5202b4eA4ffDdFD7a0382;
916         address Contributors = 0xa02dfB73de485Ebd9d37CbA4583e916F3bA94CeE;
917         address BountiesWal = 0xaB662f89A2c6e71BD8c7f754905cAaEC326BcdE7;
918         uint256 public crowdSaleStart;
919 
920 
921         function deploy() onlyOwner public{
922  	    owner = msg.sender; 
923 	    
924 	  
925 	//	crowdsale.transferOwnership(ownerWallet);
926 	//	token.transferOwnership(ownerWallet);
927 	//	token.changeController(this);
928 		token.generateTokens(crowdsale, 255000000000000000000000000); // Generate CrowdSale tokens
929 		token.generateTokens(incetivesPool, 115000000000000000000000000); //generate Incentives pool tokens
930 		token.generateTokens(FoundersAndTeam, 85000000000000000000000000); //generate Founders and team tokens
931 		token.generateTokens(FuturePartners, 40000000000000000000000000); //generate future partners tokens and contributors
932 		token.generateTokens(BountiesWal, 5000000000000000000000000); //generate contributors tokens
933 		token.changeController(EmaCrowdSale(crowdsale));
934 			token.transferOwnership(ownerWallet);
935 			crowdsale.transferOwnership(ownerWallet);
936         }
937       }