1 pragma solidity 0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract ERC20Basic {
6   function totalSupply() public view returns (uint256);
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) public view returns (uint256);
91   function transferFrom(address from, address to, uint256 value) public returns (bool);
92   function approve(address spender, uint256 value) public returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 contract Pausable is Ownable {
97   event Pause();
98   event Unpause();
99 
100   bool public paused = false;
101 
102 
103   /**
104    * @dev Modifier to make a function callable only when the contract is not paused.
105    */
106   modifier whenNotPaused() {
107     require(!paused);
108     _;
109   }
110 
111   /**
112    * @dev Modifier to make a function callable only when the contract is paused.
113    */
114   modifier whenPaused() {
115     require(paused);
116     _;
117   }
118 
119   /**
120    * @dev called by the owner to pause, triggers stopped state
121    */
122   function pause() onlyOwner whenNotPaused public {
123     paused = true;
124     Pause();
125   }
126 
127   /**
128    * @dev called by the owner to unpause, returns to normal state
129    */
130   function unpause() onlyOwner whenPaused public {
131     paused = false;
132     Unpause();
133   }
134 }
135 
136 contract BasicToken is ERC20Basic {
137   using SafeMath for uint256;
138 
139   mapping(address => uint256) balances;
140 
141   uint256 totalSupply_;
142 
143   /**
144   * @dev total number of tokens in existence
145   */
146   function totalSupply() public view returns (uint256) {
147     return totalSupply_;
148   }
149 
150   /**
151   * @dev transfer token for a specified address
152   * @param _to The address to transfer to.
153   * @param _value The amount to be transferred.
154   */
155   function transfer(address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[msg.sender]);
158 
159     // SafeMath.sub will throw if there is not enough balance.
160     balances[msg.sender] = balances[msg.sender].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     Transfer(msg.sender, _to, _value);
163     return true;
164   }
165 
166   /**
167   * @dev Gets the balance of the specified address.
168   * @param _owner The address to query the the balance of.
169   * @return An uint256 representing the amount owned by the passed address.
170   */
171   function balanceOf(address _owner) public view returns (uint256 balance) {
172     return balances[_owner];
173   }
174 
175 }
176 
177 contract APIRegistry is Ownable {
178 
179     struct APIForSale {
180         uint pricePerCall;
181         bytes32 sellerUsername;
182         bytes32 apiName;
183         address sellerAddress;
184         string hostname;
185         string docsUrl;
186     }
187 
188     mapping(string => uint) internal apiIds;
189     mapping(uint => APIForSale) public apis;
190 
191     uint public numApis;
192     uint public version;
193 
194     // ------------------------------------------------------------------------
195     // Constructor, establishes ownership because contract is owned
196     // ------------------------------------------------------------------------
197     constructor() public {
198         numApis = 0;
199         version = 1;
200     }
201 
202     // ------------------------------------------------------------------------
203     // Owner can transfer out any accidentally sent ERC20 tokens (just in case)
204     // ------------------------------------------------------------------------
205     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
206         return ERC20(tokenAddress).transfer(owner, tokens);
207     }
208 
209     // ------------------------------------------------------------------------
210     // Lets a user list an API to sell
211     // ------------------------------------------------------------------------
212     function listApi(uint pricePerCall, bytes32 sellerUsername, bytes32 apiName, string hostname, string docsUrl) public {
213         // make sure input params are valid
214         require(pricePerCall != 0 && sellerUsername != "" && apiName != "" && bytes(hostname).length != 0);
215         
216         // make sure the name isn't already taken
217         require(apiIds[hostname] == 0);
218 
219         numApis += 1;
220         apiIds[hostname] = numApis;
221 
222         APIForSale storage api = apis[numApis];
223 
224         api.pricePerCall = pricePerCall;
225         api.sellerUsername = sellerUsername;
226         api.apiName = apiName;
227         api.sellerAddress = msg.sender;
228         api.hostname = hostname;
229         api.docsUrl = docsUrl;
230     }
231 
232     // ------------------------------------------------------------------------
233     // Get the ID number of an API given it's hostname
234     // ------------------------------------------------------------------------
235     function getApiId(string hostname) public view returns (uint) {
236         return apiIds[hostname];
237     }
238 
239     // ------------------------------------------------------------------------
240     // Get info stored for the API but without the dynamic members, because solidity can't return dynamics to other smart contracts yet
241     // ------------------------------------------------------------------------
242     function getApiByIdWithoutDynamics(
243         uint apiId
244     ) 
245         public
246         view 
247         returns (
248             uint pricePerCall, 
249             bytes32 sellerUsername,
250             bytes32 apiName, 
251             address sellerAddress
252         ) 
253     {
254         APIForSale storage api = apis[apiId];
255 
256         pricePerCall = api.pricePerCall;
257         sellerUsername = api.sellerUsername;
258         apiName = api.apiName;
259         sellerAddress = api.sellerAddress;
260     }
261 
262     // ------------------------------------------------------------------------
263     // Get info stored for an API by id
264     // ------------------------------------------------------------------------
265     function getApiById(
266         uint apiId
267     ) 
268         public 
269         view 
270         returns (
271             uint pricePerCall, 
272             bytes32 sellerUsername, 
273             bytes32 apiName, 
274             address sellerAddress, 
275             string hostname, 
276             string docsUrl
277         ) 
278     {
279         APIForSale storage api = apis[apiId];
280 
281         pricePerCall = api.pricePerCall;
282         sellerUsername = api.sellerUsername;
283         apiName = api.apiName;
284         sellerAddress = api.sellerAddress;
285         hostname = api.hostname;
286         docsUrl = api.docsUrl;
287     }
288 
289     // ------------------------------------------------------------------------
290     // Get info stored for an API by hostname
291     // ------------------------------------------------------------------------
292     function getApiByName(
293         string _hostname
294     ) 
295         public 
296         view 
297         returns (
298             uint pricePerCall, 
299             bytes32 sellerUsername, 
300             bytes32 apiName, 
301             address sellerAddress, 
302             string hostname, 
303             string docsUrl
304         ) 
305     {
306         uint apiId = apiIds[_hostname];
307         if (apiId == 0) {
308             return;
309         }
310         APIForSale storage api = apis[apiId];
311 
312         pricePerCall = api.pricePerCall;
313         sellerUsername = api.sellerUsername;
314         apiName = api.apiName;
315         sellerAddress = api.sellerAddress;
316         hostname = api.hostname;
317         docsUrl = api.docsUrl;
318     }
319 
320     // ------------------------------------------------------------------------
321     // Edit an API listing
322     // ------------------------------------------------------------------------
323     function editApi(uint apiId, uint pricePerCall, address sellerAddress, string docsUrl) public {
324         require(apiId != 0 && pricePerCall != 0 && sellerAddress != address(0));
325 
326         APIForSale storage api = apis[apiId];
327 
328         // prevent editing an empty api (effectively listing an api)
329         require(
330             api.pricePerCall != 0 && api.sellerUsername != "" && api.apiName != "" &&  bytes(api.hostname).length != 0 && api.sellerAddress != address(0)
331         );
332 
333         // require that sender is the original api lister, or the contract owner
334         // the contract owner clause lets us recover a api listing if a dev loses access to their privkey
335         require(msg.sender == api.sellerAddress || msg.sender == owner);
336 
337         api.pricePerCall = pricePerCall;
338         api.sellerAddress = sellerAddress;
339         api.docsUrl = docsUrl;
340     }
341 }
342 contract Relay is Ownable {
343     address public licenseSalesContractAddress;
344     address public registryContractAddress;
345     address public apiRegistryContractAddress;
346     address public apiCallsContractAddress;
347     uint public version;
348 
349     // ------------------------------------------------------------------------
350     // Constructor, establishes ownership because contract is owned
351     // ------------------------------------------------------------------------
352     constructor() public {
353         version = 4;
354     }
355 
356     // ------------------------------------------------------------------------
357     // Owner can transfer out any accidentally sent ERC20 tokens (just in case)
358     // ------------------------------------------------------------------------
359     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
360         return ERC20(tokenAddress).transfer(owner, tokens);
361     }
362 
363     // ------------------------------------------------------------------------
364     // Sets the license sales contract address
365     // ------------------------------------------------------------------------
366     function setLicenseSalesContractAddress(address newAddress) public onlyOwner {
367         require(newAddress != address(0));
368         licenseSalesContractAddress = newAddress;
369     }
370 
371     // ------------------------------------------------------------------------
372     // Sets the registry contract address
373     // ------------------------------------------------------------------------
374     function setRegistryContractAddress(address newAddress) public onlyOwner {
375         require(newAddress != address(0));
376         registryContractAddress = newAddress;
377     }
378 
379     // ------------------------------------------------------------------------
380     // Sets the api registry contract address
381     // ------------------------------------------------------------------------
382     function setApiRegistryContractAddress(address newAddress) public onlyOwner {
383         require(newAddress != address(0));
384         apiRegistryContractAddress = newAddress;
385     }
386 
387     // ------------------------------------------------------------------------
388     // Sets the api calls contract address
389     // ------------------------------------------------------------------------
390     function setApiCallsContractAddress(address newAddress) public onlyOwner {
391         require(newAddress != address(0));
392         apiCallsContractAddress = newAddress;
393     }
394 }
395 contract StandardToken is ERC20, BasicToken {
396 
397   mapping (address => mapping (address => uint256)) internal allowed;
398 
399 
400   /**
401    * @dev Transfer tokens from one address to another
402    * @param _from address The address which you want to send tokens from
403    * @param _to address The address which you want to transfer to
404    * @param _value uint256 the amount of tokens to be transferred
405    */
406   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
407     require(_to != address(0));
408     require(_value <= balances[_from]);
409     require(_value <= allowed[_from][msg.sender]);
410 
411     balances[_from] = balances[_from].sub(_value);
412     balances[_to] = balances[_to].add(_value);
413     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
414     Transfer(_from, _to, _value);
415     return true;
416   }
417 
418   /**
419    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
420    *
421    * Beware that changing an allowance with this method brings the risk that someone may use both the old
422    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
423    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
424    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
425    * @param _spender The address which will spend the funds.
426    * @param _value The amount of tokens to be spent.
427    */
428   function approve(address _spender, uint256 _value) public returns (bool) {
429     allowed[msg.sender][_spender] = _value;
430     Approval(msg.sender, _spender, _value);
431     return true;
432   }
433 
434   /**
435    * @dev Function to check the amount of tokens that an owner allowed to a spender.
436    * @param _owner address The address which owns the funds.
437    * @param _spender address The address which will spend the funds.
438    * @return A uint256 specifying the amount of tokens still available for the spender.
439    */
440   function allowance(address _owner, address _spender) public view returns (uint256) {
441     return allowed[_owner][_spender];
442   }
443 
444   /**
445    * @dev Increase the amount of tokens that an owner allowed to a spender.
446    *
447    * approve should be called when allowed[_spender] == 0. To increment
448    * allowed value is better to use this function to avoid 2 calls (and wait until
449    * the first transaction is mined)
450    * From MonolithDAO Token.sol
451    * @param _spender The address which will spend the funds.
452    * @param _addedValue The amount of tokens to increase the allowance by.
453    */
454   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
455     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
456     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
457     return true;
458   }
459 
460   /**
461    * @dev Decrease the amount of tokens that an owner allowed to a spender.
462    *
463    * approve should be called when allowed[_spender] == 0. To decrement
464    * allowed value is better to use this function to avoid 2 calls (and wait until
465    * the first transaction is mined)
466    * From MonolithDAO Token.sol
467    * @param _spender The address which will spend the funds.
468    * @param _subtractedValue The amount of tokens to decrease the allowance by.
469    */
470   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
471     uint oldValue = allowed[msg.sender][_spender];
472     if (_subtractedValue > oldValue) {
473       allowed[msg.sender][_spender] = 0;
474     } else {
475       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
476     }
477     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
478     return true;
479   }
480 
481 }
482 
483 contract DeconetToken is StandardToken, Ownable, Pausable {
484     // token naming etc
485     string public constant symbol = "DCO";
486     string public constant name = "Deconet Token";
487     uint8 public constant decimals = 18;
488 
489     // contract version
490     uint public constant version = 4;
491 
492     // ------------------------------------------------------------------------
493     // Constructor
494     // ------------------------------------------------------------------------
495     constructor() public {
496         // 1 billion tokens (1,000,000,000)
497         totalSupply_ = 1000000000 * 10**uint(decimals);
498 
499         // transfer initial supply to msg.sender who is also contract owner
500         balances[msg.sender] = totalSupply_;
501         Transfer(address(0), msg.sender, totalSupply_);
502 
503         // pause contract until we're ready to allow transfers
504         paused = true;
505     }
506 
507     // ------------------------------------------------------------------------
508     // Owner can transfer out any accidentally sent ERC20 tokens (just in case)
509     // ------------------------------------------------------------------------
510     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
511         return ERC20(tokenAddress).transfer(owner, tokens);
512     }
513 
514     // ------------------------------------------------------------------------
515     // Modifier to make a function callable only when called by the contract owner
516     // or if the contract is not paused.
517     // ------------------------------------------------------------------------
518     modifier whenOwnerOrNotPaused() {
519         require(msg.sender == owner || !paused);
520         _;
521     }
522 
523     // ------------------------------------------------------------------------
524     // overloaded openzepplin method to add whenOwnerOrNotPaused modifier
525     // ------------------------------------------------------------------------
526     function transfer(address _to, uint256 _value) public whenOwnerOrNotPaused returns (bool) {
527         return super.transfer(_to, _value);
528     }
529 
530     // ------------------------------------------------------------------------
531     // overloaded openzepplin method to add whenOwnerOrNotPaused modifier
532     // ------------------------------------------------------------------------
533     function transferFrom(address _from, address _to, uint256 _value) public whenOwnerOrNotPaused returns (bool) {
534         return super.transferFrom(_from, _to, _value);
535     }
536 
537     // ------------------------------------------------------------------------
538     // overloaded openzepplin method to add whenOwnerOrNotPaused modifier
539     // ------------------------------------------------------------------------
540     function approve(address _spender, uint256 _value) public whenOwnerOrNotPaused returns (bool) {
541         return super.approve(_spender, _value);
542     }
543 
544     // ------------------------------------------------------------------------
545     // overloaded openzepplin method to add whenOwnerOrNotPaused modifier
546     // ------------------------------------------------------------------------
547     function increaseApproval(address _spender, uint _addedValue) public whenOwnerOrNotPaused returns (bool success) {
548         return super.increaseApproval(_spender, _addedValue);
549     }
550 
551     // ------------------------------------------------------------------------
552     // overloaded openzepplin method to add whenOwnerOrNotPaused modifier
553     // ------------------------------------------------------------------------
554     function decreaseApproval(address _spender, uint _subtractedValue) public whenOwnerOrNotPaused returns (bool success) {
555         return super.decreaseApproval(_spender, _subtractedValue);
556     }
557 }
558 
559 contract APICalls is Ownable {
560     using SafeMath for uint;
561 
562     // the amount rewarded to a seller for selling api calls per buyer
563     uint public tokenReward;
564 
565     // the fee this contract takes from every sale.  expressed as percent.  so a value of 3 indicates a 3% txn fee
566     uint public saleFee;
567 
568     // if the buyer has never paid, we need to pick a date for when they probably started using the API.  
569     // This is in seconds and will be subtracted from "now"
570     uint public defaultBuyerLastPaidAt;
571 
572     // address of the relay contract which holds the address of the registry contract.
573     address public relayContractAddress;
574 
575     // the token address
576     address public tokenContractAddress;
577 
578     // this contract version
579     uint public version;
580 
581     // the amount that can be safely withdrawn from the contract
582     uint public safeWithdrawAmount;
583 
584     // the address that is authorized to withdraw eth
585     address private withdrawAddress;
586 
587     // the address that is authorized to report usage on behalf of deconet
588     address private usageReportingAddress;
589 
590     // maps apiId to a APIBalance which stores how much each address owes
591     mapping(uint => APIBalance) internal owed;
592 
593     // maps buyer addresses to whether or not accounts are overdrafted and more
594     mapping(address => BuyerInfo) internal buyers;
595 
596     // Stores amounts owed and when buyers last paid on a per-api and per-user basis
597     struct APIBalance {
598         // maps address -> amount owed in wei
599         mapping(address => uint) amounts;
600         // basically a list of keys for the above map
601         address[] nonzeroAddresses;
602         // maps address -> tiemstamp of when buyer last paid
603         mapping(address => uint) buyerLastPaidAt;
604         // used to find address position in nonzeroAddresses
605         mapping (address => uint) nonzeroAddressesPosition;
606     }
607 
608     // Stores basic info about a buyer including their lifetime stats and reputation info
609     struct BuyerInfo {
610         // whether or not the account is overdrafted or not
611         bool overdrafted;
612         // total number of overdrafts, ever
613         uint lifetimeOverdraftCount;
614         // credits on file with this contract (wei)
615         uint credits;
616         // total amount of credits used / spent, ever (wei)
617         uint lifetimeCreditsUsed;
618         // maps apiId to approved spending balance for each API per second.
619         mapping(uint => uint) approvedAmounts;
620         // maps apiId to whether or not the user has exceeded their approved amount
621         mapping(uint => bool) exceededApprovedAmount;
622         // total number of times exceededApprovedAmount has happened
623         uint lifetimeExceededApprovalAmountCount;
624     }
625 
626     // Logged when API call usage is reported
627     event LogAPICallsMade(
628         uint apiId,
629         address indexed sellerAddress,
630         address indexed buyerAddress,
631         uint pricePerCall,
632         uint numCalls,
633         uint totalPrice,
634         address reportingAddress
635     );
636 
637     // Logged when seller is paid for API calls
638     event LogAPICallsPaid(
639         uint apiId,
640         address indexed sellerAddress,
641         uint totalPrice,
642         uint rewardedTokens,
643         uint networkFee
644     );
645 
646     // Logged when the credits from a specific buyer are spent on a specific api
647     event LogSpendCredits(
648         address indexed buyerAddress,
649         uint apiId,
650         uint amount,
651         bool causedAnOverdraft
652     );
653 
654     // Logged when a buyer deposits credits
655     event LogDepositCredits(
656         address indexed buyerAddress,
657         uint amount
658     );
659 
660     // Logged whena  buyer withdraws credits
661     event LogWithdrawCredits(
662         address indexed buyerAddress,
663         uint amount
664     );
665 
666     // ------------------------------------------------------------------------
667     // Constructor
668     // ------------------------------------------------------------------------
669     constructor() public {
670         version = 2;
671 
672         // default token reward of 100 tokens.  
673         // token has 18 decimal places so that's why 100 * 10^18
674         tokenReward = 100 * 10**18;
675 
676         // default saleFee of 10%
677         saleFee = 10;
678 
679         // 604,800 seconds = 1 week.  this is the default for when a user started using an api (1 week ago)
680         defaultBuyerLastPaidAt = 604800;
681 
682         // default withdrawAddress is owner
683         withdrawAddress = msg.sender;
684         usageReportingAddress = msg.sender;
685     }
686 
687     // ------------------------------------------------------------------------
688     // Owner can transfer out any accidentally sent ERC20 tokens (just in case)
689     // ------------------------------------------------------------------------
690     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
691         return ERC20(tokenAddress).transfer(owner, tokens);
692     }
693 
694     // ------------------------------------------------------------------------
695     // Owner can transfer out any ETH
696     // ------------------------------------------------------------------------
697     function withdrawEther(uint amount) public {
698         require(msg.sender == withdrawAddress);
699         require(amount <= this.balance);
700         require(amount <= safeWithdrawAmount);
701         safeWithdrawAmount = safeWithdrawAmount.sub(amount);
702         withdrawAddress.transfer(amount);
703     }
704 
705     // ------------------------------------------------------------------------
706     // Owner can set address of who can withdraw
707     // ------------------------------------------------------------------------
708     function setWithdrawAddress(address _withdrawAddress) public onlyOwner {
709         require(_withdrawAddress != address(0));
710         withdrawAddress = _withdrawAddress;
711     }
712 
713     // ------------------------------------------------------------------------
714     // Owner can set address of who can report usage
715     // ------------------------------------------------------------------------
716     function setUsageReportingAddress(address _usageReportingAddress) public onlyOwner {
717         require(_usageReportingAddress != address(0));
718         usageReportingAddress = _usageReportingAddress;
719     }
720 
721     // ------------------------------------------------------------------------
722     // Owner can set address of relay contract
723     // ------------------------------------------------------------------------
724     function setRelayContractAddress(address _relayContractAddress) public onlyOwner {
725         require(_relayContractAddress != address(0));
726         relayContractAddress = _relayContractAddress;
727     }
728 
729     // ------------------------------------------------------------------------
730     // Owner can set address of token contract
731     // ------------------------------------------------------------------------
732     function setTokenContractAddress(address _tokenContractAddress) public onlyOwner {
733         require(_tokenContractAddress != address(0));
734         tokenContractAddress = _tokenContractAddress;
735     }
736 
737     // ------------------------------------------------------------------------
738     // Owner can set token reward
739     // ------------------------------------------------------------------------
740     function setTokenReward(uint _tokenReward) public onlyOwner {
741         tokenReward = _tokenReward;
742     }
743 
744     // ------------------------------------------------------------------------
745     // Owner can set the sale fee
746     // ------------------------------------------------------------------------
747     function setSaleFee(uint _saleFee) public onlyOwner {
748         saleFee = _saleFee;
749     }
750 
751     // ------------------------------------------------------------------------
752     // Owner can set the default buyer last paid at
753     // ------------------------------------------------------------------------
754     function setDefaultBuyerLastPaidAt(uint _defaultBuyerLastPaidAt) public onlyOwner {
755         defaultBuyerLastPaidAt = _defaultBuyerLastPaidAt;
756     }
757 
758     // ------------------------------------------------------------------------
759     // The API owner or the authorized deconet usage reporting address may report usage
760     // ------------------------------------------------------------------------
761     function reportUsage(uint apiId, uint numCalls, address buyerAddress) public {
762         // look up the registry address from relay contract
763         Relay relay = Relay(relayContractAddress);
764         address apiRegistryAddress = relay.apiRegistryContractAddress();
765 
766         // get the module info from registry
767         APIRegistry apiRegistry = APIRegistry(apiRegistryAddress);
768 
769         uint pricePerCall;
770         bytes32 sellerUsername;
771         bytes32 apiName;
772         address sellerAddress;
773 
774         (pricePerCall, sellerUsername, apiName, sellerAddress) = apiRegistry.getApiByIdWithoutDynamics(apiId);
775 
776         // make sure the caller is either the api owner or the deconet reporting address
777         require(sellerAddress != address(0));
778         require(msg.sender == sellerAddress || msg.sender == usageReportingAddress);
779 
780         // make sure the api is actually valid
781         require(sellerUsername != "" && apiName != "");
782 
783         uint totalPrice = pricePerCall.mul(numCalls);
784 
785         require(totalPrice > 0);
786 
787         APIBalance storage apiBalance = owed[apiId];
788 
789         if (apiBalance.amounts[buyerAddress] == 0) {
790             // add buyerAddress to list of addresses with nonzero balance for this api
791             apiBalance.nonzeroAddressesPosition[buyerAddress] = apiBalance.nonzeroAddresses.length;
792             apiBalance.nonzeroAddresses.push(buyerAddress);
793         }
794 
795         apiBalance.amounts[buyerAddress] = apiBalance.amounts[buyerAddress].add(totalPrice);
796 
797         emit LogAPICallsMade(
798             apiId,
799             sellerAddress,
800             buyerAddress,
801             pricePerCall,
802             numCalls,
803             totalPrice,
804             msg.sender
805         );
806     }
807 
808     // ------------------------------------------------------------------------
809     // Function to pay the seller for a single API buyer.  
810     // Settles reported usage according to credits and approved amounts.
811     // ------------------------------------------------------------------------
812     function paySellerForBuyer(uint apiId, address buyerAddress) public {
813         // look up the registry address from relay contract
814         Relay relay = Relay(relayContractAddress);
815         address apiRegistryAddress = relay.apiRegistryContractAddress();
816 
817         // get the module info from registry
818         APIRegistry apiRegistry = APIRegistry(apiRegistryAddress);
819 
820         uint pricePerCall;
821         bytes32 sellerUsername;
822         bytes32 apiName;
823         address sellerAddress;
824 
825         (pricePerCall, sellerUsername, apiName, sellerAddress) = apiRegistry.getApiByIdWithoutDynamics(apiId);
826 
827         // make sure it's a legit real api
828         require(pricePerCall != 0 && sellerUsername != "" && apiName != "" && sellerAddress != address(0));
829 
830         uint buyerPaid = processSalesForSingleBuyer(apiId, buyerAddress);
831 
832         if (buyerPaid == 0) {
833             return; // buyer paid nothing, we are done.
834         }
835 
836         // calculate fee and payout
837         uint fee = buyerPaid.mul(saleFee).div(100);
838         uint payout = buyerPaid.sub(fee);
839 
840         // log that we stored the fee so we know we can take it out later
841         safeWithdrawAmount += fee;
842 
843         emit LogAPICallsPaid(
844             apiId,
845             sellerAddress,
846             buyerPaid,
847             tokenReward,
848             fee
849         );
850 
851         // give seller some tokens for the sale
852         rewardTokens(sellerAddress, tokenReward);
853 
854         // transfer seller the eth
855         sellerAddress.transfer(payout);
856     }
857 
858     // ------------------------------------------------------------------------
859     // Function to pay the seller for all buyers with nonzero balance.  
860     // Settles reported usage according to credits and approved amounts.
861     // ------------------------------------------------------------------------
862     function paySeller(uint apiId) public {
863         // look up the registry address from relay contract
864         Relay relay = Relay(relayContractAddress);
865         address apiRegistryAddress = relay.apiRegistryContractAddress();
866 
867         // get the module info from registry
868         APIRegistry apiRegistry = APIRegistry(apiRegistryAddress);
869 
870         uint pricePerCall;
871         bytes32 sellerUsername;
872         bytes32 apiName;
873         address sellerAddress;
874 
875         (pricePerCall, sellerUsername, apiName, sellerAddress) = apiRegistry.getApiByIdWithoutDynamics(apiId);
876 
877         // make sure it's a legit real api
878         require(pricePerCall != 0 && sellerUsername != "" && apiName != "" && sellerAddress != address(0));
879 
880         // calculate totalPayable for the api
881         uint totalPayable = 0;
882         uint totalBuyers = 0;
883         (totalPayable, totalBuyers) = processSalesForAllBuyers(apiId);
884 
885         if (totalPayable == 0) {
886             return; // if there's nothing to pay, we are done here.
887         }
888 
889         // calculate fee and payout
890         uint fee = totalPayable.mul(saleFee).div(100);
891         uint payout = totalPayable.sub(fee);
892 
893         // log that we stored the fee so we know we can take it out later
894         safeWithdrawAmount += fee;
895 
896         // we reward token reward on a "per buyer" basis.  so multiply the reward to give by the number of actual buyers
897         uint totalTokenReward = tokenReward.mul(totalBuyers);
898 
899         emit LogAPICallsPaid(
900             apiId,
901             sellerAddress,
902             totalPayable,
903             totalTokenReward,
904             fee
905         );
906 
907         // give seller some tokens for the sale
908         rewardTokens(sellerAddress, totalTokenReward);
909 
910         // transfer seller the eth
911         sellerAddress.transfer(payout);
912     } 
913 
914     // ------------------------------------------------------------------------
915     // Let anyone see when the buyer last paid for a given API
916     // ------------------------------------------------------------------------
917     function buyerLastPaidAt(uint apiId, address buyerAddress) public view returns (uint) {
918         APIBalance storage apiBalance = owed[apiId];
919         return apiBalance.buyerLastPaidAt[buyerAddress];
920     }   
921 
922     // ------------------------------------------------------------------------
923     // Get buyer info struct for a specific buyer address
924     // ------------------------------------------------------------------------
925     function buyerInfoOf(address addr) 
926         public 
927         view 
928         returns (
929             bool overdrafted, 
930             uint lifetimeOverdraftCount, 
931             uint credits, 
932             uint lifetimeCreditsUsed, 
933             uint lifetimeExceededApprovalAmountCount
934         ) 
935     {
936         BuyerInfo storage buyer = buyers[addr];
937         overdrafted = buyer.overdrafted;
938         lifetimeOverdraftCount = buyer.lifetimeOverdraftCount;
939         credits = buyer.credits;
940         lifetimeCreditsUsed = buyer.lifetimeCreditsUsed;
941         lifetimeExceededApprovalAmountCount = buyer.lifetimeExceededApprovalAmountCount;
942     }
943 
944     // ------------------------------------------------------------------------
945     // Gets the credits balance of a buyer
946     // ------------------------------------------------------------------------
947     function creditsBalanceOf(address addr) public view returns (uint) {
948         BuyerInfo storage buyer = buyers[addr];
949         return buyer.credits;
950     }
951 
952     // ------------------------------------------------------------------------
953     // Lets a buyer add credits
954     // ------------------------------------------------------------------------
955     function addCredits(address to) public payable {
956         BuyerInfo storage buyer = buyers[to];
957         buyer.credits = buyer.credits.add(msg.value);
958         emit LogDepositCredits(to, msg.value);
959     }
960 
961     // ------------------------------------------------------------------------
962     // Lets a buyer withdraw credits
963     // ------------------------------------------------------------------------
964     function withdrawCredits(uint amount) public {
965         BuyerInfo storage buyer = buyers[msg.sender];
966         require(buyer.credits >= amount);
967         buyer.credits = buyer.credits.sub(amount);
968         msg.sender.transfer(amount);
969         emit LogWithdrawCredits(msg.sender, amount);
970     }
971 
972     // ------------------------------------------------------------------------
973     // Get the length of array of buyers who have a nonzero balance for a given API
974     // ------------------------------------------------------------------------
975     function nonzeroAddressesElementForApi(uint apiId, uint index) public view returns (address) {
976         APIBalance storage apiBalance = owed[apiId];
977         return apiBalance.nonzeroAddresses[index];
978     }
979 
980     // ------------------------------------------------------------------------
981     // Get an element from the array of buyers who have a nonzero balance for a given API
982     // ------------------------------------------------------------------------
983     function nonzeroAddressesLengthForApi(uint apiId) public view returns (uint) {
984         APIBalance storage apiBalance = owed[apiId];
985         return apiBalance.nonzeroAddresses.length;
986     }
987 
988     // ------------------------------------------------------------------------
989     // Get the amount owed for a specific api for a specific buyer
990     // ------------------------------------------------------------------------
991     function amountOwedForApiForBuyer(uint apiId, address buyerAddress) public view returns (uint) {
992         APIBalance storage apiBalance = owed[apiId];
993         return apiBalance.amounts[buyerAddress];
994     }
995 
996     // ------------------------------------------------------------------------
997     // Get the total owed for an entire api for all nonzero buyers
998     // ------------------------------------------------------------------------
999     function totalOwedForApi(uint apiId) public view returns (uint) {
1000         APIBalance storage apiBalance = owed[apiId];
1001 
1002         uint totalOwed = 0;
1003         for (uint i = 0; i < apiBalance.nonzeroAddresses.length; i++) {
1004             address buyerAddress = apiBalance.nonzeroAddresses[i];
1005             uint buyerOwes = apiBalance.amounts[buyerAddress];
1006             totalOwed = totalOwed.add(buyerOwes);
1007         }
1008 
1009         return totalOwed;
1010     }
1011 
1012     // ------------------------------------------------------------------------
1013     // Gets the amount of wei per second a buyer has approved for a specific api
1014     // ------------------------------------------------------------------------
1015     function approvedAmount(uint apiId, address buyerAddress) public view returns (uint) {
1016         return buyers[buyerAddress].approvedAmounts[apiId];
1017     }
1018 
1019     // ------------------------------------------------------------------------
1020     // Let the buyer set an approved amount of wei per second for a specific api
1021     // ------------------------------------------------------------------------
1022     function approveAmount(uint apiId, address buyerAddress, uint newAmount) public {
1023         require(buyerAddress != address(0) && apiId != 0);
1024 
1025         // only the buyer or the usage reporing system can change the buyers approval amount
1026         require(msg.sender == buyerAddress || msg.sender == usageReportingAddress);
1027 
1028         BuyerInfo storage buyer = buyers[buyerAddress];
1029         buyer.approvedAmounts[apiId] = newAmount;
1030     }
1031 
1032     // ------------------------------------------------------------------------
1033     // function to let the buyer set their approved amount of wei per second for an api
1034     // this function also lets the buyer set the time they last paid for an API if they've never paid that API before.  
1035     // this is important because the total amount approved for a given transaction is based on a wei per second spending limit
1036     // but the smart contract doesn't know when the buyer started using the API
1037     // so with this function, a buyer can et the time they first used the API and the approved amount calculations will be accurate when the seller requests payment.
1038     // ------------------------------------------------------------------------
1039     function approveAmountAndSetFirstUseTime(
1040         uint apiId, 
1041         address buyerAddress, 
1042         uint newAmount, 
1043         uint firstUseTime
1044     ) 
1045         public 
1046     {
1047         require(buyerAddress != address(0) && apiId != 0);
1048 
1049         // only the buyer or the usage reporing system can change the buyers approval amount
1050         require(msg.sender == buyerAddress || msg.sender == usageReportingAddress);
1051 
1052         APIBalance storage apiBalance = owed[apiId];
1053         require(apiBalance.buyerLastPaidAt[buyerAddress] == 0);
1054 
1055         apiBalance.buyerLastPaidAt[buyerAddress] = firstUseTime;
1056         
1057         BuyerInfo storage buyer = buyers[buyerAddress];
1058         buyer.approvedAmounts[apiId] = newAmount;
1059 
1060     }
1061 
1062     // ------------------------------------------------------------------------
1063     // Gets whether or not a buyer exceeded their approved amount in the last seller payout
1064     // ------------------------------------------------------------------------
1065     function buyerExceededApprovedAmount(uint apiId, address buyerAddress) public view returns (bool) {
1066         return buyers[buyerAddress].exceededApprovedAmount[apiId];
1067     }
1068 
1069     // ------------------------------------------------------------------------
1070     // Reward user with tokens IF the contract has them in it's allowance
1071     // ------------------------------------------------------------------------
1072     function rewardTokens(address toReward, uint amount) private {
1073         DeconetToken token = DeconetToken(tokenContractAddress);
1074         address tokenOwner = token.owner();
1075 
1076         // check balance of tokenOwner
1077         uint tokenOwnerBalance = token.balanceOf(tokenOwner);
1078         uint tokenOwnerAllowance = token.allowance(tokenOwner, address(this));
1079         if (tokenOwnerBalance >= amount && tokenOwnerAllowance >= amount) {
1080             token.transferFrom(tokenOwner, toReward, amount);
1081         }
1082     }
1083 
1084     // ------------------------------------------------------------------------
1085     // Process and settle balances for a single buyer for a specific api
1086     // ------------------------------------------------------------------------
1087     function processSalesForSingleBuyer(uint apiId, address buyerAddress) private returns (uint) {
1088         APIBalance storage apiBalance = owed[apiId];
1089 
1090         uint buyerOwes = apiBalance.amounts[buyerAddress];
1091         uint buyerLastPaidAtTime = apiBalance.buyerLastPaidAt[buyerAddress];
1092         if (buyerLastPaidAtTime == 0) {
1093             // if buyer has never paid, assume they paid a week ago.  or whatever now - defaultBuyerLastPaidAt is.
1094             buyerLastPaidAtTime = now - defaultBuyerLastPaidAt; // default is 604,800 = 7 days of seconds
1095         }
1096         uint elapsedSecondsSinceLastPayout = now - buyerLastPaidAtTime;
1097         uint buyerNowOwes = buyerOwes;
1098         uint buyerPaid = 0;
1099         bool overdrafted = false;
1100 
1101         (buyerPaid, overdrafted) = chargeBuyer(apiId, buyerAddress, elapsedSecondsSinceLastPayout, buyerOwes);
1102 
1103         buyerNowOwes = buyerOwes.sub(buyerPaid);
1104         apiBalance.amounts[buyerAddress] = buyerNowOwes;
1105 
1106         // if the buyer now owes zero, then remove them from nonzeroAddresses
1107         if (buyerNowOwes == 0) {
1108             removeAddressFromNonzeroBalancesArray(apiId, buyerAddress);
1109         }
1110         // if the buyer paid nothing, we are done here.
1111         if (buyerPaid == 0) {
1112             return 0;
1113         }
1114 
1115         // log the event
1116         emit LogSpendCredits(buyerAddress, apiId, buyerPaid, overdrafted);
1117 
1118         // log that they paid
1119         apiBalance.buyerLastPaidAt[buyerAddress] = now;
1120         
1121         return buyerPaid;
1122     }
1123 
1124     // ------------------------------------------------------------------------
1125     // Process and settle balances for all buyers with a nonzero balance for a specific api
1126     // ------------------------------------------------------------------------
1127     function processSalesForAllBuyers(uint apiId) private returns (uint totalPayable, uint totalBuyers) {
1128         APIBalance storage apiBalance = owed[apiId];
1129 
1130         uint currentTime = now;
1131         address[] memory oldNonzeroAddresses = apiBalance.nonzeroAddresses;
1132         apiBalance.nonzeroAddresses = new address[](0);
1133 
1134         for (uint i = 0; i < oldNonzeroAddresses.length; i++) {
1135             address buyerAddress = oldNonzeroAddresses[i];
1136             uint buyerOwes = apiBalance.amounts[buyerAddress];
1137             uint buyerLastPaidAtTime = apiBalance.buyerLastPaidAt[buyerAddress];
1138             if (buyerLastPaidAtTime == 0) {
1139                 // if buyer has never paid, assume they paid a week ago.  or whatever now - defaultBuyerLastPaidAt is.
1140                 buyerLastPaidAtTime = now - defaultBuyerLastPaidAt; // default is 604,800 = 7 days of seconds
1141             }
1142             uint elapsedSecondsSinceLastPayout = currentTime - buyerLastPaidAtTime;
1143             uint buyerNowOwes = buyerOwes;
1144             uint buyerPaid = 0;
1145             bool overdrafted = false;
1146 
1147             (buyerPaid, overdrafted) = chargeBuyer(apiId, buyerAddress, elapsedSecondsSinceLastPayout, buyerOwes);
1148 
1149             totalPayable = totalPayable.add(buyerPaid);
1150             buyerNowOwes = buyerOwes.sub(buyerPaid);
1151             apiBalance.amounts[buyerAddress] = buyerNowOwes;
1152 
1153             // if the buyer still owes something, make sure we keep them in the nonzeroAddresses array
1154             if (buyerNowOwes != 0) {
1155                 apiBalance.nonzeroAddressesPosition[buyerAddress] = apiBalance.nonzeroAddresses.length;
1156                 apiBalance.nonzeroAddresses.push(buyerAddress);
1157             }
1158             // if the buyer paid more than 0, log the spend.
1159             if (buyerPaid != 0) {
1160                 // log the event
1161                 emit LogSpendCredits(buyerAddress, apiId, buyerPaid, overdrafted);
1162 
1163                 // log that they paid
1164                 apiBalance.buyerLastPaidAt[buyerAddress] = now;
1165 
1166                 // add to total buyer count
1167                 totalBuyers += 1;
1168             }
1169         }
1170     }
1171 
1172     // ------------------------------------------------------------------------
1173     // given a specific buyer, api, and the amount they owe, we need to figure out how much to pay
1174     // the final amount paid is based on the chart below:
1175     // if credits >= approved >= owed then pay owed
1176     // if credits >= owed > approved then pay approved and mark as exceeded approved amount
1177     // if owed > credits >= approved then pay approved and mark as overdrafted
1178     // if owed > approved > credits then pay credits and mark as overdrafted
1179     // ------------------------------------------------------------------------
1180     function chargeBuyer(
1181         uint apiId, 
1182         address buyerAddress, 
1183         uint elapsedSecondsSinceLastPayout, 
1184         uint buyerOwes
1185     ) 
1186         private 
1187         returns (
1188             uint paid, 
1189             bool overdrafted
1190         ) 
1191     {
1192         BuyerInfo storage buyer = buyers[buyerAddress];
1193         uint approvedAmountPerSecond = buyer.approvedAmounts[apiId];
1194         uint approvedAmountSinceLastPayout = approvedAmountPerSecond.mul(elapsedSecondsSinceLastPayout);
1195         
1196         // do we have the credits to pay owed?
1197         if (buyer.credits >= buyerOwes) {
1198             // yay, buyer can pay their debits
1199             overdrafted = false;
1200             buyer.overdrafted = false;
1201 
1202             // has buyer approved enough to pay what they owe?
1203             if (approvedAmountSinceLastPayout >= buyerOwes) {
1204                 // approved is greater than owed.  
1205                 // mark as not exceeded approved amount
1206                 buyer.exceededApprovedAmount[apiId] = false;
1207 
1208                 // we can pay the entire debt
1209                 paid = buyerOwes;
1210 
1211             } else {
1212                 // they have no approved enough
1213                 // mark as exceeded
1214                 buyer.exceededApprovedAmount[apiId] = true;
1215                 buyer.lifetimeExceededApprovalAmountCount += 1;
1216 
1217                 // we can only pay the approved portion of the debt
1218                 paid = approvedAmountSinceLastPayout;
1219             }
1220         } else {
1221             // buyer spent more than they have.  mark as overdrafted
1222             overdrafted = true;
1223             buyer.overdrafted = true;
1224             buyer.lifetimeOverdraftCount += 1;
1225 
1226             // does buyer have more credits than the amount they've approved?
1227             if (buyer.credits >= approvedAmountSinceLastPayout) {
1228                 // they have enough credits to pay approvedAmountSinceLastPayout, so pay that
1229                 paid = approvedAmountSinceLastPayout;
1230 
1231             } else {
1232                 // the don't have enough credits to pay approvedAmountSinceLastPayout
1233                 // so just pay whatever credits they have
1234                 paid = buyer.credits;
1235             }
1236         }
1237 
1238         buyer.credits = buyer.credits.sub(paid);
1239         buyer.lifetimeCreditsUsed = buyer.lifetimeCreditsUsed.add(paid);
1240     }
1241 
1242     function removeAddressFromNonzeroBalancesArray(uint apiId, address toRemove) private {
1243         APIBalance storage apiBalance = owed[apiId];
1244         uint position = apiBalance.nonzeroAddressesPosition[toRemove];
1245         if (position < apiBalance.nonzeroAddresses.length && apiBalance.nonzeroAddresses[position] == toRemove) {
1246             apiBalance.nonzeroAddresses[position] = apiBalance.nonzeroAddresses[apiBalance.nonzeroAddresses.length - 1];
1247             apiBalance.nonzeroAddresses.length--;
1248         }
1249     }
1250 }