1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   /**
58   * @dev transfer token for a specified address
59   * @param _to The address to transfer to.
60   * @param _value The amount to be transferred.
61   */
62   function transfer(address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64     require(_value <= balances[msg.sender]);
65 
66     // SafeMath.sub will throw if there is not enough balance.
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     Transfer(msg.sender, _to, _value);
70     return true;
71   }
72 
73   /**
74   * @dev Gets the balance of the specified address.
75   * @param _owner The address to query the the balance of.
76   * @return An uint256 representing the amount owned by the passed address.
77   */
78   function balanceOf(address _owner) public view returns (uint256 balance) {
79     return balances[_owner];
80   }
81 
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) public view returns (uint256);
90   function transferFrom(address from, address to, uint256 value) public returns (bool);
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106 
107   /**
108    * @dev Transfer tokens from one address to another
109    * @param _from address The address which you want to send tokens from
110    * @param _to address The address which you want to transfer to
111    * @param _value uint256 the amount of tokens to be transferred
112    */
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[_from]);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    *
128    * Beware that changing an allowance with this method brings the risk that someone may use both the old
129    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public view returns (uint256) {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152    * approve should be called when allowed[_spender] == 0. To increment
153    * allowed value is better to use this function to avoid 2 calls (and wait until
154    * the first transaction is mined)
155    * From MonolithDAO Token.sol
156    */
157   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
158     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
164     uint oldValue = allowed[msg.sender][_spender];
165     if (_subtractedValue > oldValue) {
166       allowed[msg.sender][_spender] = 0;
167     } else {
168       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
169     }
170     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171     return true;
172   }
173 
174 }
175 
176 //
177 // CPYToken is a standard ERC20 token with additional functionality:
178 // - tokenSaleContract receives the whole balance for distribution
179 // - Tokens are only transferable by the tokenSaleContract until finalization
180 // - Token holders can burn their tokens after finalization
181 //
182 contract Token is StandardToken {
183 
184     string  public constant name   = "COPYTRACK Token";
185     string  public constant symbol = "CPY";
186 
187     uint8 public constant   decimals = 18;
188 
189     uint256 constant EXA       = 10 ** 18;
190     uint256 public totalSupply = 100 * 10 ** 6 * EXA;
191 
192     bool public finalized = false;
193 
194     address public tokenSaleContract;
195 
196     //
197     // EVENTS
198     //
199     event Finalized();
200 
201     event Burnt(address indexed _from, uint256 _amount);
202 
203 
204     // Initialize the token with the tokenSaleContract and transfer the whole balance to it
205     function Token(address _tokenSaleContract)
206         public
207     {
208         // Make sure address is set
209         require(_tokenSaleContract != 0);
210 
211         balances[_tokenSaleContract] = totalSupply;
212 
213         tokenSaleContract = _tokenSaleContract;
214     }
215 
216 
217     // Implementation of the standard transfer method that takes the finalize flag into account
218     function transfer(address _to, uint256 _value)
219         public
220         returns (bool success)
221     {
222         checkTransferAllowed(msg.sender);
223 
224         return super.transfer(_to, _value);
225     }
226 
227 
228     // Implementation of the standard transferFrom method that takes into account the finalize flag
229     function transferFrom(address _from, address _to, uint256 _value)
230         public
231         returns (bool success)
232     {
233         checkTransferAllowed(msg.sender);
234 
235         return super.transferFrom(_from, _to, _value);
236     }
237 
238 
239     function checkTransferAllowed(address _sender)
240         private
241         view
242     {
243         if (finalized) {
244             // Every token holder should be allowed to transfer tokens once token was finalized
245             return;
246         }
247 
248         // Only allow tokenSaleContract to transfer tokens before finalization
249         require(_sender == tokenSaleContract);
250     }
251 
252 
253     // Finalize method marks the point where token transfers are finally allowed for everybody
254     function finalize()
255         external
256         returns (bool success)
257     {
258         require(!finalized);
259         require(msg.sender == tokenSaleContract);
260 
261         finalized = true;
262 
263         Finalized();
264 
265         return true;
266     }
267 
268 
269     // Implement a burn function to permit msg.sender to reduce its balance which also reduces totalSupply
270     function burn(uint256 _value)
271         public
272         returns (bool success)
273     {
274         require(finalized);
275         require(_value <= balances[msg.sender]);
276 
277         balances[msg.sender] = balances[msg.sender].sub(_value);
278         totalSupply = totalSupply.sub(_value);
279 
280         Burnt(msg.sender, _value);
281 
282         return true;
283     }
284 }
285 
286 contract TokenSaleConfig  {
287     uint public constant EXA = 10 ** 18;
288 
289     uint256 public constant PUBLIC_START_TIME         = 1515542400; //Wed, 10 Jan 2018 00:00:00 +0000
290     uint256 public constant END_TIME                  = 1518220800; //Sat, 10 Feb 2018 00:00:00 +0000
291     uint256 public constant CONTRIBUTION_MIN          = 0.1 ether;
292     uint256 public constant CONTRIBUTION_MAX          = 2500.0 ether;
293 
294     uint256 public constant COMPANY_ALLOCATION        = 40 * 10 ** 6 * EXA; //40 million;
295 
296     Tranche[4] public tranches;
297 
298     struct Tranche {
299         // How long this tranche will be active
300         uint untilToken;
301 
302         // How many tokens per ether you will get while this tranche is active
303         uint tokensPerEther;
304     }
305 
306     function TokenSaleConfig()
307         public
308     {
309         tranches[0] = Tranche({untilToken : 5000000 * EXA, tokensPerEther : 1554});
310         tranches[1] = Tranche({untilToken : 10000000 * EXA, tokensPerEther : 1178});
311         tranches[2] = Tranche({untilToken : 20000000 * EXA, tokensPerEther : 1000});
312         tranches[3] = Tranche({untilToken : 60000000, tokensPerEther : 740});
313     }
314 }
315 
316 /**
317  * @title Ownable
318  * @dev The Ownable contract has an owner address, and provides basic authorization control
319  * functions, this simplifies the implementation of "user permissions".
320  */
321 contract Ownable {
322   address public owner;
323 
324 
325   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
326 
327 
328   /**
329    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
330    * account.
331    */
332   function Ownable() public {
333     owner = msg.sender;
334   }
335 
336 
337   /**
338    * @dev Throws if called by any account other than the owner.
339    */
340   modifier onlyOwner() {
341     require(msg.sender == owner);
342     _;
343   }
344 
345 
346   /**
347    * @dev Allows the current owner to transfer control of the contract to a newOwner.
348    * @param newOwner The address to transfer ownership to.
349    */
350   function transferOwnership(address newOwner) public onlyOwner {
351     require(newOwner != address(0));
352     OwnershipTransferred(owner, newOwner);
353     owner = newOwner;
354   }
355 
356 }
357 
358 contract TokenSale is TokenSaleConfig, Ownable {
359     using SafeMath for uint;
360 
361     Token  public  tokenContract;
362 
363     // We keep track of whether the sale has been finalized, at which point
364     // no additional contributions will be permitted.
365     bool public finalized = false;
366 
367     // lookup for max wei amount per user allowed
368     mapping (address => uint256) public contributors;
369 
370     // the total amount of wei raised
371     uint256 public totalWeiRaised = 0;
372 
373     // the total amount of token raised
374     uint256 public totalTokenSold = 0;
375 
376     // address where funds are collected
377     address public fundingWalletAddress;
378 
379     // address which manages the whitelist (KYC)
380     mapping (address => bool) public whitelistOperators;
381 
382     // lookup addresses for whitelist
383     mapping (address => bool) public whitelist;
384 
385 
386     // early bird investments
387     address[] public earlyBirds;
388 
389     mapping (address => uint256) public earlyBirdInvestments;
390 
391 
392     //
393     // MODIFIERS
394     //
395 
396     // Throws if purchase would exceed the min max contribution.
397     // @param _contribute address
398     // @param _weiAmount the amount intended to spend
399     modifier withinContributionLimits(address _contributorAddress, uint256 _weiAmount) {
400         uint256 totalContributionAmount = contributors[_contributorAddress].add(_weiAmount);
401         require(_weiAmount >= CONTRIBUTION_MIN);
402         require(totalContributionAmount <= CONTRIBUTION_MAX);
403         _;
404     }
405 
406     // Throws if called by any account not on the whitelist.
407     // @param _address Address which should execute the function
408     modifier onlyWhitelisted(address _address) {
409         require(whitelist[_address] == true);
410         _;
411     }
412 
413     // Throws if called by any account not on the whitelistOperators list
414     modifier onlyWhitelistOperator()
415     {
416         require(whitelistOperators[msg.sender] == true);
417         _;
418     }
419 
420     //Throws if sale is finalized or token sale end time has been reached
421     modifier onlyDuringSale() {
422         require(finalized == false);
423         require(currentTime() <= END_TIME);
424         _;
425     }
426 
427     //Throws if sale is finalized
428     modifier onlyAfterFinalized() {
429         require(finalized);
430         _;
431     }
432 
433 
434 
435     //
436     // EVENTS
437     //
438     event LogWhitelistUpdated(address indexed _account);
439 
440     event LogTokensPurchased(address indexed _account, uint256 _cost, uint256 _tokens, uint256 _totalTokenSold);
441 
442     event UnsoldTokensBurnt(uint256 _amount);
443 
444     event Finalized();
445 
446     // Initialize a new TokenSale contract
447     // @param _fundingWalletAddress Address which all ether will be forwarded to
448     function TokenSale(address _fundingWalletAddress)
449         public
450     {
451         //make sure _fundingWalletAddress is set
452         require(_fundingWalletAddress != 0);
453 
454         fundingWalletAddress = _fundingWalletAddress;
455     }
456 
457     // Connect a token to the tokenSale
458     // @param _fundingWalletAddress Address which all ether will be forwarded to
459     function connectToken(Token _tokenContract)
460         external
461         onlyOwner
462     {
463         require(totalTokenSold == 0);
464         require(tokenContract == address(0));
465 
466         //make sure token is untouched
467         require(_tokenContract.balanceOf(address(this)) == _tokenContract.totalSupply());
468 
469         tokenContract = _tokenContract;
470 
471         // sent tokens to company vault
472         tokenContract.transfer(fundingWalletAddress, COMPANY_ALLOCATION);
473         processEarlyBirds();
474     }
475 
476     function()
477         external
478         payable
479     {
480         uint256 cost = buyTokens(msg.sender, msg.value);
481 
482         // forward contribution to the fundingWalletAddress
483         fundingWalletAddress.transfer(cost);
484     }
485 
486     // execution of the actual token purchase
487     function buyTokens(address contributorAddress, uint256 weiAmount)
488         onlyDuringSale
489         onlyWhitelisted(contributorAddress)
490         withinContributionLimits(contributorAddress, weiAmount)
491         private
492     returns (uint256 costs)
493     {
494         assert(tokenContract != address(0));
495 
496         uint256 tokensLeft = getTokensLeft();
497 
498         // make sure we still have tokens left for sale
499         require(tokensLeft > 0);
500 
501         uint256 tokenAmount = calculateTokenAmount(weiAmount);
502         uint256 cost = weiAmount;
503         uint256 refund = 0;
504 
505         // we sell till we dont have anything left
506         if (tokenAmount > tokensLeft) {
507             tokenAmount = tokensLeft;
508 
509             // calculate actual cost for partial amount of tokens.
510             cost = tokenAmount / getCurrentTokensPerEther();
511 
512             // calculate refund for contributor.
513             refund = weiAmount.sub(cost);
514         }
515 
516         // transfer the tokens to the contributor address
517         tokenContract.transfer(contributorAddress, tokenAmount);
518 
519         // keep track of the amount bought by the contributor
520         contributors[contributorAddress] = contributors[contributorAddress].add(cost);
521 
522 
523         //if we got a refund process it now
524         if (refund > 0) {
525             // transfer back everything that exceeded the amount of tokens left
526             contributorAddress.transfer(refund);
527         }
528 
529         // increase stats
530         totalWeiRaised += cost;
531         totalTokenSold += tokenAmount;
532 
533         LogTokensPurchased(contributorAddress, cost, tokenAmount, totalTokenSold);
534 
535         // If all tokens available for sale have been sold out, finalize the sale automatically.
536         if (tokensLeft.sub(tokenAmount) == 0) {
537             finalizeInternal();
538         }
539 
540 
541         //return the actual cost of the sale
542         return cost;
543     }
544 
545     // ask the connected token how many tokens we have left 
546     function getTokensLeft()
547         public
548         view
549     returns (uint256 tokensLeft)
550     {
551         return tokenContract.balanceOf(this);
552     }
553 
554     // calculate the current tokens per ether
555     function getCurrentTokensPerEther()
556         public
557         view
558     returns (uint256 tokensPerEther)
559     {
560         uint i;
561         uint defaultTokensPerEther = tranches[tranches.length - 1].tokensPerEther;
562 
563         if (currentTime() >= PUBLIC_START_TIME) {
564             return defaultTokensPerEther;
565         }
566 
567         for (i = 0; i < tranches.length; i++) {
568             if (totalTokenSold >= tranches[i].untilToken) {
569                 continue;
570             }
571 
572             //sell until the contract has nor more tokens
573             return tranches[i].tokensPerEther;
574         }
575 
576         return defaultTokensPerEther;
577     }
578 
579     // calculate the token amount for a give weiAmount
580     function calculateTokenAmount(uint256 weiAmount)
581         public
582         view
583     returns (uint256 tokens)
584     {
585         return weiAmount * getCurrentTokensPerEther();
586     }
587 
588     //
589     // WHITELIST
590     //
591 
592     // add a new whitelistOperator
593     function addWhitelistOperator(address _address)
594         public
595         onlyOwner
596     {
597         whitelistOperators[_address] = true;
598     }
599 
600     // remove a whitelistOperator
601     function removeWhitelistOperator(address _address)
602         public
603         onlyOwner
604     {
605         require(whitelistOperators[_address]);
606 
607         delete whitelistOperators[_address];
608     }
609 
610 
611     // Allows whitelistOperators to add an account to the whitelist.
612     // Only those accounts will be allowed to contribute during the sale.
613     function addToWhitelist(address _address)
614         public
615         onlyWhitelistOperator
616     {
617         require(_address != address(0));
618 
619         whitelist[_address] = true;
620         LogWhitelistUpdated(_address);
621     }
622 
623     // Allows whitelistOperators to remove an account from the whitelist.
624     function removeFromWhitelist(address _address)
625         public
626         onlyWhitelistOperator
627     {
628         require(_address != address(0));
629 
630         delete whitelist[_address];
631     }
632 
633     //returns the current time, needed for tests
634     function currentTime()
635         public
636         view
637         returns (uint256 _currentTime)
638     {
639         return now;
640     }
641 
642 
643     // Allows the owner to finalize the sale.
644     function finalize()
645         external
646         onlyOwner
647         returns (bool)
648     {
649         //allow only after the defined end_time
650         require(currentTime() > END_TIME);
651 
652         return finalizeInternal();
653     }
654 
655 
656     // The internal one will be called if tokens are sold out or
657     // the end time for the sale is reached, in addition to being called
658     // from the public version of finalize().
659     function finalizeInternal() private returns (bool) {
660         require(!finalized);
661 
662         finalized = true;
663 
664         Finalized();
665 
666         //also finalize the token contract
667         tokenContract.finalize();
668 
669         return true;
670     }
671 
672     // register an early bird investment
673     function addEarlyBird(address _address, uint256 weiAmount)
674         onlyOwner
675         withinContributionLimits(_address, weiAmount)
676         external
677     {
678         // only allowed as long as we dont have a connected token
679         require(tokenContract == address(0));
680 
681         earlyBirds.push(_address);
682         earlyBirdInvestments[_address] = weiAmount;
683 
684         // auto whitelist early bird;
685         whitelist[_address] = true;
686     }
687 
688     // transfer the tokens bought by the early birds before contract creation
689     function processEarlyBirds()
690         private
691     {
692         for (uint256 i = 0; i < earlyBirds.length; i++)
693         {
694             address earlyBirdAddress = earlyBirds[i];
695             uint256 weiAmount = earlyBirdInvestments[earlyBirdAddress];
696 
697             buyTokens(earlyBirdAddress, weiAmount);
698         }
699     }
700 
701 
702     // allows everyone to burn all unsold tokens in the sale contract after finalized.
703     function burnUnsoldTokens()
704         external
705         onlyAfterFinalized
706         returns (bool)
707     {
708         uint256 leftTokens = getTokensLeft();
709 
710         require(leftTokens > 0);
711 
712         // let'em burn
713         require(tokenContract.burn(leftTokens));
714 
715         UnsoldTokensBurnt(leftTokens);
716 
717         return true;
718     }
719 }