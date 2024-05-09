1 /**
2  * Copyright 2017–2018, bZeroX, LLC. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5 
6 pragma solidity 0.4.24;
7 
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15   /**
16   * @dev Multiplies two numbers, throws on overflow.
17   */
18   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
19     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
20     // benefit is lost if 'b' is also tested.
21     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
22     if (_a == 0) {
23       return 0;
24     }
25 
26     c = _a * _b;
27     assert(c / _a == _b);
28     return c;
29   }
30 
31   /**
32   * @dev Integer division of two numbers, truncating the quotient.
33   */
34   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     // assert(_b > 0); // Solidity automatically throws when dividing by 0
36     // uint256 c = _a / _b;
37     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
38     return _a / _b;
39   }
40 
41   /**
42   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43   */
44   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     assert(_b <= _a);
46     return _a - _b;
47   }
48 
49   /**
50   * @dev Adds two numbers, throws on overflow.
51   */
52   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
53     c = _a + _b;
54     assert(c >= _a);
55     return c;
56   }
57 }
58 
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65   address public owner;
66 
67 
68   event OwnershipRenounced(address indexed previousOwner);
69   event OwnershipTransferred(
70     address indexed previousOwner,
71     address indexed newOwner
72   );
73 
74 
75   /**
76    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77    * account.
78    */
79   constructor() public {
80     owner = msg.sender;
81   }
82 
83   /**
84    * @dev Throws if called by any account other than the owner.
85    */
86   modifier onlyOwner() {
87     require(msg.sender == owner);
88     _;
89   }
90 
91   /**
92    * @dev Allows the current owner to relinquish control of the contract.
93    * @notice Renouncing to ownership will leave the contract without an owner.
94    * It will not be possible to call the functions with the `onlyOwner`
95    * modifier anymore.
96    */
97   function renounceOwnership() public onlyOwner {
98     emit OwnershipRenounced(owner);
99     owner = address(0);
100   }
101 
102   /**
103    * @dev Allows the current owner to transfer control of the contract to a newOwner.
104    * @param _newOwner The address to transfer ownership to.
105    */
106   function transferOwnership(address _newOwner) public onlyOwner {
107     _transferOwnership(_newOwner);
108   }
109 
110   /**
111    * @dev Transfers control of the contract to a newOwner.
112    * @param _newOwner The address to transfer ownership to.
113    */
114   function _transferOwnership(address _newOwner) internal {
115     require(_newOwner != address(0));
116     emit OwnershipTransferred(owner, _newOwner);
117     owner = _newOwner;
118   }
119 }
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * See https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   function totalSupply() public view returns (uint256);
128   function balanceOf(address _who) public view returns (uint256);
129   function transfer(address _to, uint256 _value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 /**
134  * @title ERC20 interface
135  * @dev see https://github.com/ethereum/EIPs/issues/20
136  */
137 contract ERC20 is ERC20Basic {
138   function allowance(address _owner, address _spender)
139     public view returns (uint256);
140 
141   function transferFrom(address _from, address _to, uint256 _value)
142     public returns (bool);
143 
144   function approve(address _spender, uint256 _value) public returns (bool);
145   event Approval(
146     address indexed owner,
147     address indexed spender,
148     uint256 value
149   );
150 }
151 
152 /**
153  * @title DetailedERC20 token
154  * @dev The decimals are only for visualization purposes.
155  * All the operations are done using the smallest and indivisible token unit,
156  * just as on Ethereum all the operations are done in wei.
157  */
158 contract DetailedERC20 is ERC20 {
159   string public name;
160   string public symbol;
161   uint8 public decimals;
162 
163   constructor(string _name, string _symbol, uint8 _decimals) public {
164     name = _name;
165     symbol = _symbol;
166     decimals = _decimals;
167   }
168 }
169 
170 /**
171  * @title Basic token
172  * @dev Basic version of StandardToken, with no allowances.
173  */
174 contract BasicToken is ERC20Basic {
175   using SafeMath for uint256;
176 
177   mapping(address => uint256) internal balances;
178 
179   uint256 internal totalSupply_;
180 
181   /**
182   * @dev Total number of tokens in existence
183   */
184   function totalSupply() public view returns (uint256) {
185     return totalSupply_;
186   }
187 
188   /**
189   * @dev Transfer token for a specified address
190   * @param _to The address to transfer to.
191   * @param _value The amount to be transferred.
192   */
193   function transfer(address _to, uint256 _value) public returns (bool) {
194     require(_value <= balances[msg.sender]);
195     require(_to != address(0));
196 
197     balances[msg.sender] = balances[msg.sender].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     emit Transfer(msg.sender, _to, _value);
200     return true;
201   }
202 
203   /**
204   * @dev Gets the balance of the specified address.
205   * @param _owner The address to query the the balance of.
206   * @return An uint256 representing the amount owned by the passed address.
207   */
208   function balanceOf(address _owner) public view returns (uint256) {
209     return balances[_owner];
210   }
211 
212 }
213 
214 /**
215  * @title Standard ERC20 token
216  *
217  * @dev Implementation of the basic standard token.
218  * https://github.com/ethereum/EIPs/issues/20
219  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
220  */
221 contract StandardToken is ERC20, BasicToken {
222 
223   mapping (address => mapping (address => uint256)) internal allowed;
224 
225 
226   /**
227    * @dev Transfer tokens from one address to another
228    * @param _from address The address which you want to send tokens from
229    * @param _to address The address which you want to transfer to
230    * @param _value uint256 the amount of tokens to be transferred
231    */
232   function transferFrom(
233     address _from,
234     address _to,
235     uint256 _value
236   )
237     public
238     returns (bool)
239   {
240     require(_value <= balances[_from]);
241     require(_value <= allowed[_from][msg.sender]);
242     require(_to != address(0));
243 
244     balances[_from] = balances[_from].sub(_value);
245     balances[_to] = balances[_to].add(_value);
246     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
247     emit Transfer(_from, _to, _value);
248     return true;
249   }
250 
251   /**
252    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
253    * Beware that changing an allowance with this method brings the risk that someone may use both the old
254    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
255    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
256    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257    * @param _spender The address which will spend the funds.
258    * @param _value The amount of tokens to be spent.
259    */
260   function approve(address _spender, uint256 _value) public returns (bool) {
261     allowed[msg.sender][_spender] = _value;
262     emit Approval(msg.sender, _spender, _value);
263     return true;
264   }
265 
266   /**
267    * @dev Function to check the amount of tokens that an owner allowed to a spender.
268    * @param _owner address The address which owns the funds.
269    * @param _spender address The address which will spend the funds.
270    * @return A uint256 specifying the amount of tokens still available for the spender.
271    */
272   function allowance(
273     address _owner,
274     address _spender
275    )
276     public
277     view
278     returns (uint256)
279   {
280     return allowed[_owner][_spender];
281   }
282 
283   /**
284    * @dev Increase the amount of tokens that an owner allowed to a spender.
285    * approve should be called when allowed[_spender] == 0. To increment
286    * allowed value is better to use this function to avoid 2 calls (and wait until
287    * the first transaction is mined)
288    * From MonolithDAO Token.sol
289    * @param _spender The address which will spend the funds.
290    * @param _addedValue The amount of tokens to increase the allowance by.
291    */
292   function increaseApproval(
293     address _spender,
294     uint256 _addedValue
295   )
296     public
297     returns (bool)
298   {
299     allowed[msg.sender][_spender] = (
300       allowed[msg.sender][_spender].add(_addedValue));
301     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302     return true;
303   }
304 
305   /**
306    * @dev Decrease the amount of tokens that an owner allowed to a spender.
307    * approve should be called when allowed[_spender] == 0. To decrement
308    * allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)
310    * From MonolithDAO Token.sol
311    * @param _spender The address which will spend the funds.
312    * @param _subtractedValue The amount of tokens to decrease the allowance by.
313    */
314   function decreaseApproval(
315     address _spender,
316     uint256 _subtractedValue
317   )
318     public
319     returns (bool)
320   {
321     uint256 oldValue = allowed[msg.sender][_spender];
322     if (_subtractedValue >= oldValue) {
323       allowed[msg.sender][_spender] = 0;
324     } else {
325       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
326     }
327     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
328     return true;
329   }
330 
331 }
332 
333 contract UnlimitedAllowanceToken is StandardToken {
334 
335     uint internal constant MAX_UINT = 2**256 - 1;
336     
337     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited allowance, and to add revert reasons.
338     /// @param _from Address to transfer from.
339     /// @param _to Address to transfer to.
340     /// @param _value Amount to transfer.
341     /// @return Success of transfer.
342     function transferFrom(
343         address _from,
344         address _to,
345         uint256 _value)
346         public
347         returns (bool)
348     {
349         uint allowance = allowed[_from][msg.sender];
350         require(_value <= balances[_from], "insufficient balance");
351         require(_value <= allowance, "insufficient allowance");
352         require(_to != address(0), "token burn not allowed");
353 
354         balances[_from] = balances[_from].sub(_value);
355         balances[_to] = balances[_to].add(_value);
356         if (allowance < MAX_UINT) {
357             allowed[_from][msg.sender] = allowance.sub(_value);
358         }
359         emit Transfer(_from, _to, _value);
360         return true;
361     }
362 
363     /// @dev Transfer token for a specified address, modified to add revert reasons.
364     /// @param _to The address to transfer to.
365     /// @param _value The amount to be transferred.
366     function transfer(
367         address _to,
368         uint256 _value)
369         public 
370         returns (bool)
371     {
372         require(_value <= balances[msg.sender], "insufficient balance");
373         require(_to != address(0), "token burn not allowed");
374 
375         balances[msg.sender] = balances[msg.sender].sub(_value);
376         balances[_to] = balances[_to].add(_value);
377         emit Transfer(msg.sender, _to, _value);
378         return true;
379     }
380 }
381 
382 contract BZRxToken is UnlimitedAllowanceToken, DetailedERC20, Ownable {
383 
384     event Mint(address indexed to, uint256 amount);
385     event MintFinished();
386     event LockingFinished();
387 
388     bool public mintingFinished = false;
389     bool public lockingFinished = false;
390 
391     mapping (address => bool) public minters;
392 
393     modifier canMint() {
394         require(!mintingFinished);
395         _;
396     }
397 
398     modifier hasMintPermission() {
399         require(minters[msg.sender]);
400         _;
401     }
402 
403     modifier isLocked() {
404         require(!lockingFinished);
405         _;
406     }
407 
408     constructor()
409         public
410         DetailedERC20(
411             "BZRX Protocol Token",
412             "BZRX", 
413             18
414         )
415     {
416         minters[msg.sender] = true;
417     }
418 
419     /// @dev ERC20 transferFrom function
420     /// @param _from Address to transfer from.
421     /// @param _to Address to transfer to.
422     /// @param _value Amount to transfer.
423     /// @return Success of transfer.
424     function transferFrom(
425         address _from,
426         address _to,
427         uint256 _value)
428         public
429         returns (bool)
430     {
431         if (lockingFinished || minters[msg.sender]) {
432             return super.transferFrom(
433                 _from,
434                 _to,
435                 _value
436             );
437         }
438 
439         revert("this token is locked for transfers");
440     }
441 
442     /// @dev ERC20 transfer function
443     /// @param _to Address to transfer to.
444     /// @param _value Amount to transfer.
445     /// @return Success of transfer.
446     function transfer(
447         address _to, 
448         uint256 _value) 
449         public 
450         returns (bool)
451     {
452         if (lockingFinished || minters[msg.sender]) {
453             return super.transfer(
454                 _to,
455                 _value
456             );
457         }
458 
459         revert("this token is locked for transfers");
460     }
461 
462     /// @dev Allows minter to initiate a transfer on behalf of another spender
463     /// @param _spender Minter with permission to spend.
464     /// @param _from Address to transfer from.
465     /// @param _to Address to transfer to.
466     /// @param _value Amount to transfer.
467     /// @return Success of transfer.
468     function minterTransferFrom(
469         address _spender,
470         address _from,
471         address _to,
472         uint256 _value)
473         public
474         hasMintPermission
475         canMint
476         returns (bool)
477     {
478         require(canTransfer(
479             _spender,
480             _from,
481             _value),
482             "canTransfer is false");
483 
484         require(_to != address(0), "token burn not allowed");
485 
486         uint allowance = allowed[_from][_spender];
487         balances[_from] = balances[_from].sub(_value);
488         balances[_to] = balances[_to].add(_value);
489         if (allowance < MAX_UINT) {
490             allowed[_from][_spender] = allowance.sub(_value);
491         }
492         emit Transfer(_from, _to, _value);
493         return true;
494     }
495 
496     /**
497     * @dev Function to mint tokens
498     * @param _to The address that will receive the minted tokens.
499     * @param _amount The amount of tokens to mint.
500     * @return A boolean that indicates if the operation was successful.
501     */
502     function mint(
503         address _to,
504         uint256 _amount)
505         public
506         hasMintPermission
507         canMint
508         returns (bool)
509     {
510         require(_to != address(0), "token burn not allowed");
511         totalSupply_ = totalSupply_.add(_amount);
512         balances[_to] = balances[_to].add(_amount);
513         emit Mint(_to, _amount);
514         emit Transfer(address(0), _to, _amount);
515         return true;
516     }
517 
518     /**
519     * @dev Function to stop minting new tokens.
520     * @return True if the operation was successful.
521     */
522     function finishMinting() 
523         public 
524         onlyOwner 
525         canMint 
526         returns (bool)
527     {
528         mintingFinished = true;
529         emit MintFinished();
530         return true;
531     }
532 
533     /**
534     * @dev Function to stop locking token.
535     * @return True if the operation was successful.
536     */
537     function finishLocking() 
538         public 
539         onlyOwner 
540         isLocked 
541         returns (bool)
542     {
543         lockingFinished = true;
544         emit LockingFinished();
545         return true;
546     }
547 
548     /**
549     * @dev Function to add minter address.
550     * @return True if the operation was successful.
551     */
552     function addMinter(
553         address _minter) 
554         public 
555         onlyOwner 
556         canMint 
557         returns (bool)
558     {
559         minters[_minter] = true;
560         return true;
561     }
562 
563     /**
564     * @dev Function to remove minter address.
565     * @return True if the operation was successful.
566     */
567     function removeMinter(
568         address _minter) 
569         public 
570         onlyOwner 
571         canMint 
572         returns (bool)
573     {
574         minters[_minter] = false;
575         return true;
576     }
577 
578     /**
579     * @dev Function to check balance and allowance for a spender.
580     * @return True transfer will succeed based on balance and allowance.
581     */
582     function canTransfer(
583         address _spender,
584         address _from,
585         uint256 _value)
586         public
587         view
588         returns (bool)
589     {
590         return (
591             balances[_from] >= _value && 
592             (_spender == _from || allowed[_from][_spender] >= _value)
593         );
594     }
595 }
596 
597 interface WETHInterface {
598     function deposit() external payable;
599     function withdraw(uint wad) external;
600 }
601 
602 interface PriceFeed {
603     function read() external view returns (bytes32);
604 }
605 
606 contract BZRxTokenSale is Ownable {
607     using SafeMath for uint256;
608 
609     struct TokenPurchases {
610         uint totalETH;
611         uint totalTokens;
612         uint totalTokenBonus;
613     }
614 
615     event BonusChanged(uint oldBonus, uint newBonus);
616     event TokenPurchase(address indexed buyer, uint ethAmount, uint ethRate, uint tokensReceived);
617     
618     event SaleOpened(uint bonusMultiplier);
619     event SaleClosed(uint bonusMultiplier);
620     
621     bool public saleClosed = true;
622 
623     address public bZRxTokenContractAddress;    // BZRX Token
624     address public bZxVaultAddress;             // bZx Vault
625     address public wethContractAddress;         // WETH Token
626     address public priceContractAddress;        // MakerDao Medianizer price feed
627 
628     // The current token bonus offered to purchasers (example: 110 == 10% bonus)
629     uint public bonusMultiplier;
630 
631     uint public ethRaised;
632 
633     address[] public purchasers;
634     mapping (address => TokenPurchases) public purchases;
635 
636     bool public whitelistEnforced = false;
637     mapping (address => uint) public whitelist;
638 
639     modifier saleOpen() {
640         require(!saleClosed, "sale is closed");
641         _;
642     }
643 
644     modifier whitelisted(address user, uint value) {
645         require(canPurchaseAmount(user, value), "not whitelisted");
646         _;
647     }
648 
649     constructor(
650         address _bZRxTokenContractAddress,
651         address _bZxVaultAddress,
652         address _wethContractAddress,
653         address _priceContractAddress,
654         uint _bonusMultiplier)
655         public
656     {
657         require(_bonusMultiplier > 100);
658         
659         bZRxTokenContractAddress = _bZRxTokenContractAddress;
660         bZxVaultAddress = _bZxVaultAddress;
661         wethContractAddress = _wethContractAddress;
662         priceContractAddress = _priceContractAddress;
663         bonusMultiplier = _bonusMultiplier;
664     }
665 
666     function()  
667         public
668         payable 
669     {
670         buyToken();
671     }
672 
673     function buyToken()
674         public
675         payable 
676         saleOpen
677         whitelisted(msg.sender, msg.value)
678         returns (bool)
679     {
680         require(msg.value > 0, "no ether sent");
681         
682         uint ethRate = getEthRate();
683 
684         ethRaised += msg.value;
685 
686         uint tokenAmount = msg.value                        // amount of ETH sent
687                             .mul(ethRate).div(10**18)       // curent ETH/USD rate
688                             .mul(1000).div(73);             // fixed price per token $0.073
689 
690         uint tokenAmountAndBonus = tokenAmount
691                                             .mul(bonusMultiplier).div(100);
692 
693         TokenPurchases storage purchase = purchases[msg.sender];
694         
695         if (purchase.totalETH == 0) {
696             purchasers.push(msg.sender);
697         }
698         
699         purchase.totalETH += msg.value;
700         purchase.totalTokens += tokenAmountAndBonus;
701         purchase.totalTokenBonus += tokenAmountAndBonus.sub(tokenAmount);
702 
703         emit TokenPurchase(msg.sender, msg.value, ethRate, tokenAmountAndBonus);
704 
705         return BZRxToken(bZRxTokenContractAddress).mint(
706             msg.sender,
707             tokenAmountAndBonus
708         );
709     }
710 
711     // conforms to ERC20 transferFrom function for BZRX token support
712     function transferFrom(
713         address _from,
714         address _to,
715         uint256 _value)
716         public
717         saleOpen
718         returns (bool)
719     {
720         require(msg.sender == bZxVaultAddress, "only the bZx vault can call this function");
721         
722         if (BZRxToken(bZRxTokenContractAddress).canTransfer(msg.sender, _from, _value)) {
723             return BZRxToken(bZRxTokenContractAddress).minterTransferFrom(
724                 msg.sender,
725                 _from,
726                 _to,
727                 _value
728             );
729         } else {
730             uint ethRate = getEthRate();
731             
732             uint wethValue = _value                             // amount of BZRX
733                                 .mul(73).div(1000)              // fixed price per token $0.073
734                                 .mul(10**18).div(ethRate);      // curent ETH/USD rate
735 
736             // discount on purchase
737             wethValue -= wethValue.mul(bonusMultiplier).div(100).sub(wethValue);
738 
739             require(canPurchaseAmount(_from, wethValue), "not whitelisted");
740 
741             require(StandardToken(wethContractAddress).transferFrom(
742                 _from,
743                 this,
744                 wethValue
745             ), "weth transfer failed");
746 
747             ethRaised += wethValue;
748 
749             TokenPurchases storage purchase = purchases[_from];
750 
751             if (purchase.totalETH == 0) {
752                 purchasers.push(_from);
753             }
754 
755             purchase.totalETH += wethValue;
756             purchase.totalTokens += _value;
757 
758             return BZRxToken(bZRxTokenContractAddress).mint(
759                 _to,
760                 _value
761             );
762         }
763     }
764 
765     function closeSale(
766         bool _closed) 
767         public 
768         onlyOwner 
769         returns (bool)
770     {
771         saleClosed = _closed;
772 
773         if (_closed)
774             emit SaleClosed(bonusMultiplier);
775         else
776             emit SaleOpened(bonusMultiplier);
777 
778         return true;
779     }
780 
781     function changeBZRxTokenContract(
782         address _bZRxTokenContractAddress) 
783         public 
784         onlyOwner 
785         returns (bool)
786     {
787         bZRxTokenContractAddress = _bZRxTokenContractAddress;
788         return true;
789     }
790 
791     function changeBZxVault(
792         address _bZxVaultAddress) 
793         public 
794         onlyOwner 
795         returns (bool)
796     {
797         bZxVaultAddress = _bZxVaultAddress;
798         return true;
799     }
800 
801     function changeWethContract(
802         address _wethContractAddress) 
803         public 
804         onlyOwner 
805         returns (bool)
806     {
807         wethContractAddress = _wethContractAddress;
808         return true;
809     }
810 
811     function changePriceContract(
812         address _priceContractAddress) 
813         public 
814         onlyOwner 
815         returns (bool)
816     {
817         priceContractAddress = _priceContractAddress;
818         return true;
819     }
820 
821     function changeBonusMultiplier(
822         uint _newBonusMultiplier) 
823         public 
824         onlyOwner 
825         returns (bool)
826     {
827         require(bonusMultiplier != _newBonusMultiplier && _newBonusMultiplier > 100);
828         emit BonusChanged(bonusMultiplier, _newBonusMultiplier);
829         bonusMultiplier = _newBonusMultiplier;
830         return true;
831     }
832 
833     function unwrapEth() 
834         public 
835         onlyOwner 
836         returns (bool)
837     {
838         uint balance = StandardToken(wethContractAddress).balanceOf.gas(4999)(this);
839         if (balance == 0)
840             return false;
841 
842         WETHInterface(wethContractAddress).withdraw(balance);
843         return true;
844     }
845 
846     function transferEther(
847         address _to,
848         uint _value)
849         public
850         onlyOwner
851         returns (bool)
852     {
853         uint amount = _value;
854         if (amount > address(this).balance) {
855             amount = address(this).balance;
856         }
857 
858         return (_to.send(amount));
859     }
860 
861     function enforceWhitelist(
862         bool _isEnforced) 
863         public 
864         onlyOwner 
865         returns (bool)
866     {
867         whitelistEnforced = _isEnforced;
868 
869         return true;
870     }
871 
872     function setWhitelist(
873         address[] _users,
874         uint[] _values) 
875         public 
876         onlyOwner 
877         returns (bool)
878     {
879         require(_users.length == _values.length, "users and values count mismatch");
880         
881         for (uint i=0; i < _users.length; i++) {
882             whitelist[_users[i]] = _values[i];
883         }
884 
885         return true;
886     }
887 
888 
889     function getEthRate()
890         public
891         view
892         returns (uint)
893     {
894         return uint(PriceFeed(priceContractAddress).read());
895     }
896 
897     function canPurchaseAmount(
898         address _user,
899         uint _value)
900         public
901         view
902         returns (bool)
903     {
904         if (!whitelistEnforced || (whitelist[_user] > 0 && purchases[_user].totalETH.add(_value) <= whitelist[_user])) {
905             return true;
906         } else {
907             return false;
908         }
909     }
910 }