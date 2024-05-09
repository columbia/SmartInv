1 pragma solidity 0.5.10;  /*
2 
3 
4     
5     ___________________________________________________________________
6       _      _                                        ______           
7       |  |  /          /                                /              
8     --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
9       |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
10     __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
11     
12         
13        
14         
15     ██╗  ██╗██╗   ██╗██████╗ ███████╗    ████████╗ ██████╗ ██╗  ██╗███████╗███╗   ██╗
16     ██║  ██║╚██╗ ██╔╝██╔══██╗██╔════╝    ╚══██╔══╝██╔═══██╗██║ ██╔╝██╔════╝████╗  ██║
17     ███████║ ╚████╔╝ ██████╔╝█████╗         ██║   ██║   ██║█████╔╝ █████╗  ██╔██╗ ██║
18     ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══╝         ██║   ██║   ██║██╔═██╗ ██╔══╝  ██║╚██╗██║
19     ██║  ██║   ██║   ██║     ███████╗       ██║   ╚██████╔╝██║  ██╗███████╗██║ ╚████║
20     ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚══════╝       ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝
21                                                                                      
22                                                                                      
23 
24 
25 ----------------------------------------------------------------------------------------------------
26 
27 === MAIN FEATURES ===
28     => Higher degree of control by owner - safeGuard functionality
29     => SafeMath implementation 
30     => Earning on token for fixed-deposit
31 
32 ------------------------------------------------------------------------------------------------------
33  Copyright (c) 2019 onwards HYPE Inc. ( https://hypetoken.io )
34  Contract designed with ❤ by EtherAuthority  ( https://EtherAuthority.io )
35 ------------------------------------------------------------------------------------------------------
36 */
37 
38 /* Safemath library */
39 library SafeMath {
40     /**
41      * @dev Returns the addition of two unsigned integers, reverting on
42      * overflow.
43      *
44      * Counterpart to Solidity's `+` operator.
45      *
46      * Requirements:
47      * - Addition cannot overflow.
48      */
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52 
53         return c;
54     }
55 
56     /**
57      * @dev Returns the subtraction of two unsigned integers, reverting on
58      * overflow (when the result is negative).
59      *
60      * Counterpart to Solidity's `-` operator.
61      *
62      * Requirements:
63      * - Subtraction cannot overflow.
64      */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b <= a, "SafeMath: subtraction overflow");
67         uint256 c = a - b;
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the multiplication of two unsigned integers, reverting on
74      * overflow.
75      *
76      * Counterpart to Solidity's `*` operator.
77      *
78      * Requirements:
79      * - Multiplication cannot overflow.
80      */
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83         // benefit is lost if 'b' is also tested.
84         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the integer division of two unsigned integers. Reverts on
97      * division by zero. The result is rounded towards zero.
98      *
99      * Counterpart to Solidity's `/` operator. Note: this function uses a
100      * `revert` opcode (which leaves remaining gas untouched) while Solidity
101      * uses an invalid opcode to revert (consuming all remaining gas).
102      *
103      * Requirements:
104      * - The divisor cannot be zero.
105      */
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         // Solidity only automatically asserts when dividing by 0
108         require(b > 0, "SafeMath: division by zero");
109         uint256 c = a / b;
110         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
117      * Reverts when dividing by zero.
118      *
119      * Counterpart to Solidity's `%` operator. This function uses a `revert`
120      * opcode (which leaves remaining gas untouched) while Solidity uses an
121      * invalid opcode to revert (consuming all remaining gas).
122      *
123      * Requirements:
124      * - The divisor cannot be zero.
125      */
126     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
127         require(b != 0, "SafeMath: modulo by zero");
128         return a % b;
129     }
130 }
131 
132 // Owner Handler
133 contract ownerShip    // Auction Contract Owner and OwherShip change
134 {
135     //Global storage declaration
136     address payable public owner;
137 
138     address payable public newOwner;
139 
140     bool public safeGuard ; // To hault all non owner functions in case of imergency
141 
142     //Event defined for ownership transfered
143     event OwnershipTransferredEv(address payable indexed previousOwner, address payable indexed newOwner);
144 
145 
146     //Sets owner only on first run
147     constructor() public 
148     {
149         //Set contract owner
150         owner = msg.sender;
151         // Disabled global hault on first deploy
152         safeGuard = false;
153 
154     }
155 
156     //This will restrict function only for owner where attached
157     modifier onlyOwner() 
158     {
159         require(msg.sender == owner);
160         _;
161     }
162 
163 
164     function transferOwnership(address payable _newOwner) public onlyOwner 
165     {
166         newOwner = _newOwner;
167     }
168 
169 
170     //the reason for this flow is to protect owners from sending ownership to unintended address due to human error
171     function acceptOwnership() public 
172     {
173         require(msg.sender == newOwner);
174         emit OwnershipTransferredEv(owner, newOwner);
175         owner = newOwner;
176         newOwner = address(0);
177     }
178 
179     function changesafeGuardStatus() onlyOwner public
180     {
181         if (safeGuard == false)
182         {
183             safeGuard = true;
184         }
185         else
186         {
187             safeGuard = false;    
188         }
189     }
190 
191 }
192 
193 
194 
195 contract tokenERC20 is  ownerShip
196 {
197     // Public variables of the token
198     using SafeMath for uint256;
199     bytes32 public name;
200     bytes8 public symbol;
201     uint8 public decimals; // places of decimal
202     uint256 public totalSupply;
203     uint256 public totalMintAfterInitial;
204     uint256 public maximumSupply;
205 
206     uint public burningRate = 500;    // 500=5%
207 
208     // struct to store token and ether value 
209     struct userBalance 
210     {
211         uint256 totalValue;
212         uint256 freezeValue;
213         uint256 freezeDate;
214         uint256 meltValue;    
215     }
216 
217     // Mapped storage for token  ( If token address is 0 means ether)
218     mapping (address => mapping (address => userBalance)) public tokens;
219 
220 
221         // This creates an array with all balances
222     mapping (address => uint256) public balanceOf;
223     mapping (address => mapping (address => uint256)) public allowance;
224     
225     /* Records for the fronzen accounts */
226     mapping (address => bool) public frozenAccount;
227         
228     /* This generates a public event on the blockchain that will notify clients */
229     event FrozenFunds(address target, bool frozen);
230     
231     // This generates a public event on the blockchain that will notify clients
232     event Transfer(address indexed from, address indexed to, uint256 value);
233   
234     
235     // This notifies clients about the amount burnt
236     event Burn(address indexed from, uint256 value);
237 
238      //Calculate percent and return result
239     function calculatePercentage(uint256 PercentOf, uint256 percentTo ) internal pure returns (uint256) 
240     {
241         uint256 factor = 10000;
242         require(percentTo <= factor);
243         uint256 c = PercentOf.mul(percentTo).div(factor);
244         return c;
245     }   
246 
247     function setBurningRate(uint _burningRate) onlyOwner public returns(bool success)
248     {
249         burningRate = _burningRate;
250         return true;
251     }
252 
253 
254 
255     //Token type defnition
256     struct tokenTypeData
257     {
258         bytes32 tokenName;
259         bytes8 tokenSymbol;
260         uint decimalCount;
261         uint minFreezingValue;
262         uint rateFactor;      // % of token balance amount = "effective balance amount" to calculate interest
263         uint perDayFreezeRate;   //1000 = 10% ,10 = 0.1%, 1 = 0.01%
264         bool freezingAllowed;   // If false this token type is not allowed or accepted to freeze
265     }
266     // Mapped storage struct for token type  data
267     mapping (address => tokenTypeData) public tokenTypeDatas;
268 
269 
270         /**
271          * Constrctor function
272          *
273          * Initializes contract with initial supply tokens to the creator of the contract
274          */
275     constructor () public {
276     	decimals = 18; // 18 decimal places
277         totalSupply = 50000000000000000000000000;       // 50 Million with 18 decimal places
278         maximumSupply = 100000000000000000000000000;         // 100 Million with 18 decimal places
279         balanceOf[msg.sender]=totalSupply;       // tokens will be sent to owner
280         tokens[address(this)][owner].totalValue = balanceOf[msg.sender];
281         name = "HYPE Token";                           // Set the name for display purposes
282         symbol = "HYPE";                       // Set the symbol for display purposes
283 
284         //In house token type data update
285         tokenTypeData memory temp;
286 
287         temp.tokenName=name;
288         temp.tokenSymbol=symbol;
289         temp.decimalCount=decimals;
290         temp.minFreezingValue=100;
291         temp.rateFactor=10000;   //10000 = 100% means token amount = effective amount   
292         temp.perDayFreezeRate=100;   // 1% daily freezing reward
293         temp.freezingAllowed=true;  
294         tokenTypeDatas[address(this)] = temp;
295         emit Transfer(address(0), msg.sender, totalSupply);
296     }
297     
298          /* Internal transfer, only can be called by this contract */
299         function _transfer(address _from, address _to, uint _value) internal {
300             require(!safeGuard,"safeGuard Active");
301 			require (_to != address(0),"to is address 0");                               // Prevent transfer to 0x0 address. Use burn() instead
302 			require (balanceOf[_from] >= _value, "no balance in from");               // Check if the sender has enough
303 			require (balanceOf[_to].add(_value) >= balanceOf[_to],"overflow balance"); // Check for overflows
304 			require(!frozenAccount[_from],"from account frozen");                     // Check if sender is frozen
305 			require(!frozenAccount[_to],"to account frozen");                       // Check if recipient is frozen
306 			balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
307             tokens[address(this)][_from].totalValue = tokens[address(this)][_from].totalValue.sub(_value); //parallel record for multi token addressing need
308 			balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
309             tokens[address(this)][_to].totalValue = tokens[address(this)][_to].totalValue.add(_value);   //parallel record for multi token addressing need         
310             uint burnValue;
311             if(!(msg.sender == owner || msg.sender == address(this)))   // burn if sender is not this contract or owner
312             {
313                 burnValue = calculatePercentage(_value,burningRate); //amount to burn
314                 require(burnInternal(_to, burnValue),"burning failed");   // burnt from receiver
315             }
316 			emit Transfer(_from, _to,_value);
317             
318         } 
319 
320         function burnInternal(address _burnFrom, uint _burnValue) internal returns(bool success)
321         {   
322             require(!safeGuard,"safeGuard Active");
323             require(_burnFrom != address(0));
324             require(balanceOf[_burnFrom] >= _burnValue);   // Check if the sender has enough
325 			require(!frozenAccount[_burnFrom],"to account frozen");                       // Check if recipient is frozen
326 			balanceOf[_burnFrom] = balanceOf[_burnFrom].sub(_burnValue);    // Subtract from the sender
327             tokens[address(this)][_burnFrom].totalValue = tokens[address(this)][_burnFrom].totalValue.sub(_burnValue); //parallel record for multi token addressing need
328 			balanceOf[address(0)] = balanceOf[address(0)].add(_burnValue);        // Add the same to the recipient
329             tokens[address(this)][address(0)].totalValue = tokens[address(this)][address(0)].totalValue.add(_burnValue);   //parallel record for multi token addressing need         
330             totalSupply = totalSupply.sub(_burnValue);            
331 			emit Transfer(_burnFrom, address(0),_burnValue);                         // Update totalSupply
332             return true;            
333         }
334 
335 		function mintInternal(uint256 mintedAmount)  internal returns (bool success) {                         
336 			totalSupply = totalSupply.add(mintedAmount);
337             totalMintAfterInitial = totalMintAfterInitial.add(mintedAmount);
338 		 	//emit Transfer(address(0), address(this), mintedAmount);
339             return true;
340 		}
341 
342 
343 
344         /**
345          * Transfer tokens
346          *
347          * Send `_value` tokens to `_to` from your account
348          *
349          * @param _to The address of the recipient
350          * @param _value the amount to send
351          */
352     function transfer(address _to, uint256 _value) public returns (bool success) {
353          _transfer(msg.sender, _to, _value);
354         return true;
355     }
356     
357         /**
358          * Transfer tokens from other address
359          *
360          * Send `_value` tokens to `_to` in behalf of `_from`
361          *
362          * @param _from The address of the sender
363          * @param _to The address of the recipient
364          * @param _value the amount to send
365          */
366     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
367         require(!safeGuard);
368         require(_from != address(0),"transfer from adderss(0) is invalid");
369         require(_value <= allowance[_from][msg.sender]);     // Check allowance
370         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
371         _transfer(_from, _to, _value);
372         return true;
373     }
374     
375         /**
376          * Set allowance for other address
377          *
378          * Allows `_spender` to spend no more than `_value` tokens in your behalf
379          *
380          * @param _spender The address authorized to spend
381          * @param _value the max amount they can spend
382          */
383     function approve(address _spender, uint256 _value) public
384         returns (bool success) {
385         require(!safeGuard);
386         allowance[msg.sender][_spender] = _value;
387         return true;
388     }
389 
390         
391 		/// @notice Create `mintedAmount` tokens and send it to `target`
392 		/// @param target Address to receive the tokens
393 		/// @param mintedAmount the amount of tokens it will receive
394 		function mintToken(address target, uint256 mintedAmount)  public onlyOwner returns (bool success) {
395 			balanceOf[target] = balanceOf[target].add(mintedAmount);
396             tokens[address(this)][target].totalValue = tokens[address(this)][target].totalValue.add(mintedAmount); //parallel record for multi token addressing need                         
397 			totalSupply = totalSupply.add(mintedAmount);
398             totalMintAfterInitial = totalMintAfterInitial.add(mintedAmount);
399 		 	emit Transfer(address(0), address(this), mintedAmount);
400             return true;
401 		}
402 
403 
404         /**
405          * Destroy tokens
406          *
407          * Remove `_value` tokens from the system irreversibly
408          *
409          * @param _value the amount of money to burn
410          */
411     function burn(uint256 _value) public onlyOwner returns (bool success) {
412         burnInternal(msg.sender, _value);
413         return true;
414     }
415     
416         /**
417          * Destroy tokens from other account
418          *
419          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
420          *
421          * @param _from the address of the sender
422          * @param _value the amount of money to burn
423          */
424     function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
425         burnInternal(_from, _value);
426         return true;
427     }
428         
429 }
430 
431 
432 
433 interface ERC20Essential 
434 {
435 
436     function transfer(address _to, uint256 _amount) external returns (bool);
437     function transferFrom(address _from, address _to, uint256 _amount) external returns (bool);
438 
439 }
440 
441 //Main contract starts here
442 contract HYPEtoken is tokenERC20
443 {
444 
445     using SafeMath for uint256;
446     
447     
448     	/*************************************/
449         /*  User whitelisting functionality  */
450         /*************************************/
451         bool public whitelistingStatus = false;
452         mapping (address => bool) public whitelisted;
453 
454         
455         /**
456          * Change whitelisting status on or off
457          *
458          * When whitelisting is true, then crowdsale will only accept investors who are whitelisted.
459          */
460         function changeWhitelistingStatus() onlyOwner public{
461             if (whitelistingStatus == false){
462 			    whitelistingStatus = true;
463                 whitelisted[owner]= true;
464             }
465             else{
466                 whitelistingStatus = false;    
467             }
468 		}
469 		
470 		/**
471          * Whitelist any user address - only Owner can do this
472          *
473          * It will add user address in whitelisted mapping
474          */
475         function whitelistUser(address userAddress) onlyOwner public{
476             require(whitelistingStatus == true);
477             require(userAddress != address(0));
478             whitelisted[userAddress] = true;
479 		}    
480 		
481 
482 
483 
484 		/// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
485 		/// @param target Address to be frozen
486 		/// @param freeze either to freeze it or not
487 		function freezeAccount(address target, bool freeze) onlyOwner public {
488 				frozenAccount[target] = freeze;
489 			emit  FrozenFunds(target, freeze);
490 		}
491         
492 
493         
494         //Just in case, owner wants to transfer Tokens from contract to owner address
495         function manualWithdrawToken(uint256 _amount) onlyOwner public {
496       		uint256 tokenAmount = _amount.mul(100);
497             _transfer(address(this), msg.sender, tokenAmount);
498         }
499           
500         //Just in case, owner wants to transfer Ether from contract to owner address
501         function manualWithdrawEther()onlyOwner public{
502 			uint256 amount=address(this).balance;
503 			owner.transfer(amount);
504 		}
505 		
506 
507         //To air drop
508         function airDrop(address[] memory recipients,uint[] memory tokenAmount) public onlyOwner returns (bool) {
509             uint reciversLength  = recipients.length;
510             require(reciversLength <= 150);
511             for(uint i = 0; i < reciversLength; i++)
512             {
513                   //This will loop through all the recipients and send them the specified tokens
514                   _transfer(owner, recipients[i], tokenAmount[i]);
515             }
516             return true;
517         }
518         
519         
520         
521 
522     uint public meltHoldSeconds = 172800;  // 172800 seconds = 48 Hr. user can withdraw only after this period
523 
524 
525 
526 
527     //Event for eexternal token deposit and withdraw
528 
529     event tokenDepositEv(address token, address user, uint amount, uint balance);
530     event tokenWithdrawEv(address token, address user, uint amount, uint balance);
531 
532     function setWithdrawWaitingPeriod(uint valueInSeconds) onlyOwner public returns (bool)
533     {
534         meltHoldSeconds = valueInSeconds;
535         return true;
536     }
537 
538     function newTokenTypeData(address token,bytes32 _tokenName, bytes8 _tokenSymbol, uint _decimalCount, uint _minFreezingValue, uint _rateFactor, uint _perDayFreezeRate) onlyOwner public returns (bool)
539     {
540         tokenTypeData memory temp;
541 
542         temp.tokenName=_tokenName;
543         temp.tokenSymbol=_tokenSymbol;
544         temp.decimalCount=_decimalCount;
545         temp.minFreezingValue=_minFreezingValue;
546         temp.rateFactor=_rateFactor;      
547         temp.perDayFreezeRate=_perDayFreezeRate;   
548         temp.freezingAllowed=true;  
549         tokenTypeDatas[token] = temp;
550         return true;
551     }
552 
553     function freezingOnOffForTokenType(address token) onlyOwner public returns (bool)
554     {
555         if (tokenTypeDatas[token].freezingAllowed == false)
556         {
557             tokenTypeDatas[token].freezingAllowed = true;
558         }
559         else
560         {
561             tokenTypeDatas[token].freezingAllowed = false;    
562         } 
563         return true;     
564     }
565 
566     function setMinFreezingValue(address token, uint _minFreezingValue) onlyOwner public returns (bool)
567     {
568         tokenTypeDatas[token].minFreezingValue = _minFreezingValue;
569         return true;
570     }
571 
572     function setRateFactor(address token, uint _rateFactor) onlyOwner public returns (bool)
573     {
574         tokenTypeDatas[token].rateFactor = _rateFactor;
575         return true;
576     }
577 
578     function setPerDayFreezeRate(address token, uint _perDayFreezeRate) onlyOwner public returns (bool)
579     {
580         tokenTypeDatas[token].perDayFreezeRate = _perDayFreezeRate;
581         return true;
582     }
583 
584    
585     
586 
587     //To deposit token
588     function tokenDeposit(address token, uint amount) public 
589     {
590         //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
591         require(token!=address(0),"Address(0) found, can't continue");
592         require(ERC20Essential(token).transferFrom(msg.sender, address(this), amount),"ERC20 'transferFrom' call failed");
593         tokens[token][msg.sender].totalValue = tokens[token][msg.sender].totalValue.add(amount);
594         emit tokenDepositEv(token, msg.sender, amount, tokens[token][msg.sender].totalValue);
595     }
596 
597     //To withdraw token
598     function tokenWithdraw(address token, uint amount) public
599     {
600         require(!safeGuard,"System Paused By Admin");
601         require(token != address(this));
602         require(token!=address(0),"Address(0) found, can't continue");
603         if(now.sub(meltHoldSeconds) > tokens[token][msg.sender].freezeDate)
604         {
605            tokens[token][msg.sender].meltValue = 0; 
606         }
607         require(tokens[token][msg.sender].totalValue.sub(tokens[token][msg.sender].freezeValue.add(tokens[token][msg.sender].meltValue)) >= amount,"Required amount is not free to withdraw");       
608         tokens[token][msg.sender].totalValue = tokens[token][msg.sender].totalValue.sub(amount);
609         ERC20Essential(token).transfer(msg.sender, amount);
610         emit tokenWithdrawEv(token, msg.sender, amount, tokens[token][msg.sender].totalValue);
611     }
612 
613     event releaseMyHypeEv(address token, uint amount);
614     //releasing after minumum waiting period to withdraw HYPE 
615     function releaseMyHype(address token) public returns (bool)
616     {
617         require(!safeGuard,"System Paused By Admin");
618         require(token!=address(0),"Address(0) found, can't continue");
619         require(token == address(this),"Only pissible for HYPE ");
620         require(now.sub(meltHoldSeconds) > tokens[token][msg.sender].freezeDate,"wait period is not over");
621         uint amount = tokens[token][msg.sender].meltValue;
622         balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
623         tokens[token][msg.sender].totalValue = balanceOf[msg.sender].add(tokens[token][msg.sender].freezeValue );
624         tokens[token][msg.sender].meltValue = 0; 
625         emit releaseMyHypeEv(token, amount);
626         return true;
627     }
628 
629     event tokenBalanceFreezeEv(address token, uint amount, uint earning);
630 
631 
632     function tokenBalanceFreeze(address token, uint amount)   public returns (bool)
633     {
634         require(!safeGuard,"System Paused By Admin");
635         require(tokenTypeDatas[token].freezingAllowed,"token type not allowed to freeze");
636         require(token!=address(0),"Address(0) found, can't continue");
637         address callingUser = msg.sender;
638         require(msg.sender != address(0),"Address(0) found, can't continue");
639 
640         require(amount <=  tokens[token][callingUser].totalValue.sub(tokens[token][callingUser].freezeValue.add(tokens[token][callingUser].meltValue)) && amount >= tokenTypeDatas[token].minFreezingValue, "less than required or less balance");
641         
642         //before adding more freezing amount calculating earning on existing freeze amount and updating same in user ether balance
643         uint freezeValue = tokens[token][callingUser].freezeValue;
644         uint earnedValue;
645         if (freezeValue > 0)
646         {
647             earnedValue = getEarning(token,callingUser,freezeValue);
648             require(mintInternal(earnedValue),"minting failed");
649             tokens[address(this)][callingUser].meltValue = tokens[address(this)][callingUser].meltValue.add(earnedValue);
650         }
651 
652         tokens[token][callingUser].freezeValue = tokens[token][callingUser].freezeValue.add(amount);
653         if (token==address(this))
654         {
655             balanceOf[callingUser] = balanceOf[callingUser].sub(amount);
656         }
657         tokens[token][callingUser].freezeDate = now;
658 
659         emit tokenBalanceFreezeEv(token,amount,earnedValue);
660         return true;
661     }
662 
663     function getEarning(address token,address user,uint amount) internal view returns(uint256)
664     {
665         uint effectiveAmount = calculatePercentage(amount,tokenTypeDatas[token].rateFactor);
666         uint interestAmount = calculatePercentage(effectiveAmount,tokenTypeDatas[token].perDayFreezeRate);
667         uint secondsPassed = (now - tokens[token][user].freezeDate);
668         uint daysPassed=0;
669         if (secondsPassed >= 86400)  // if less than one day earning will be zero
670         {
671            daysPassed = secondsPassed.div(86400); 
672         }
673         return daysPassed.mul(interestAmount);
674     }
675 
676 
677     event tokenBalanceMeltEv(address token, uint amount, uint earning);
678 
679 
680     function tokenBalanceMelt(address token, uint amount)   public returns (bool)
681     {
682         require(!safeGuard,"System Paused By Admin");
683         require(token!=address(0),"Address(0) found, can't continue");
684         address callingUser = msg.sender;
685         require(msg.sender != address(0),"Address(0) found, can't continue");
686         require(amount <=  tokens[token][callingUser].freezeValue && amount > 0, "less than required or less balance");
687         
688         //before melting amount calculating earning on existing freeze amount and updating same in user ether balance
689         uint freezeValue = tokens[token][callingUser].freezeValue;
690         uint earnedValue = getEarning(token,callingUser,freezeValue);
691         require(mintInternal(earnedValue),"minting failed");
692         tokens[address(this)][callingUser].meltValue = tokens[address(this)][callingUser].meltValue.add(earnedValue);       
693         
694         tokens[token][callingUser].freezeValue = tokens[token][callingUser].freezeValue.sub(amount);
695         if (token==address(this))
696         {
697             tokens[token][callingUser].meltValue = tokens[token][callingUser].meltValue.add(amount);
698         }
699 
700         tokens[token][callingUser].freezeDate = now;
701         emit tokenBalanceMeltEv(token,amount,earnedValue);
702         return true;
703     }
704 
705     function viewMyReward(address token) public view returns(uint freezedValue, uint rewardValue)
706     {
707         address callingUser = msg.sender;
708         uint freezeValue = tokens[token][callingUser].freezeValue;
709         uint earnedValue = getEarning(token,callingUser,freezeValue);
710         return (freezeValue,earnedValue);
711     }
712 
713 }