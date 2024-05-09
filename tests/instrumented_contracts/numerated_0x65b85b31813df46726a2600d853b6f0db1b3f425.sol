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
12 contract Ownable {
13   address public owner;
14 
15 
16   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   function Ownable() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     if (a == 0) {
54       return 0;
55     }
56     uint256 c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) public view returns (uint256);
91   function transferFrom(address from, address to, uint256 value) public returns (bool);
92   function approve(address spender, uint256 value) public returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 contract BasicToken is ERC20Basic {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) balances;
100 
101   uint256 totalSupply_;
102 
103   /**
104   * @dev total number of tokens in existence
105   */
106   function totalSupply() public view returns (uint256) {
107     return totalSupply_;
108   }
109 
110   /**
111   * @dev transfer token for a specified address
112   * @param _to The address to transfer to.
113   * @param _value The amount to be transferred.
114   */
115   function transfer(address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(_value <= balances[msg.sender]);
118 
119     // SafeMath.sub will throw if there is not enough balance.
120     balances[msg.sender] = balances[msg.sender].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     Transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public view returns (uint256 balance) {
132     return balances[_owner];
133   }
134 
135 }
136 
137 contract Pausable is Ownable {
138   event Pause();
139   event Unpause();
140 
141   bool public paused = false;
142 
143 
144   /**
145    * @dev Modifier to make a function callable only when the contract is not paused.
146    */
147   modifier whenNotPaused() {
148     require(!paused);
149     _;
150   }
151 
152   /**
153    * @dev Modifier to make a function callable only when the contract is paused.
154    */
155   modifier whenPaused() {
156     require(paused);
157     _;
158   }
159 
160   /**
161    * @dev called by the owner to pause, triggers stopped state
162    */
163   function pause() onlyOwner whenNotPaused public {
164     paused = true;
165     Pause();
166   }
167 
168   /**
169    * @dev called by the owner to unpause, returns to normal state
170    */
171   function unpause() onlyOwner whenPaused public {
172     paused = false;
173     Unpause();
174   }
175 }
176 
177 contract Relay is Ownable {
178     address public licenseSalesContractAddress;
179     address public registryContractAddress;
180     address public apiRegistryContractAddress;
181     address public apiCallsContractAddress;
182     uint public version;
183 
184     // ------------------------------------------------------------------------
185     // Constructor, establishes ownership because contract is owned
186     // ------------------------------------------------------------------------
187     constructor() public {
188         version = 4;
189     }
190 
191     // ------------------------------------------------------------------------
192     // Owner can transfer out any accidentally sent ERC20 tokens (just in case)
193     // ------------------------------------------------------------------------
194     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
195         return ERC20(tokenAddress).transfer(owner, tokens);
196     }
197 
198     // ------------------------------------------------------------------------
199     // Sets the license sales contract address
200     // ------------------------------------------------------------------------
201     function setLicenseSalesContractAddress(address newAddress) public onlyOwner {
202         require(newAddress != address(0));
203         licenseSalesContractAddress = newAddress;
204     }
205 
206     // ------------------------------------------------------------------------
207     // Sets the registry contract address
208     // ------------------------------------------------------------------------
209     function setRegistryContractAddress(address newAddress) public onlyOwner {
210         require(newAddress != address(0));
211         registryContractAddress = newAddress;
212     }
213 
214     // ------------------------------------------------------------------------
215     // Sets the api registry contract address
216     // ------------------------------------------------------------------------
217     function setApiRegistryContractAddress(address newAddress) public onlyOwner {
218         require(newAddress != address(0));
219         apiRegistryContractAddress = newAddress;
220     }
221 
222     // ------------------------------------------------------------------------
223     // Sets the api calls contract address
224     // ------------------------------------------------------------------------
225     function setApiCallsContractAddress(address newAddress) public onlyOwner {
226         require(newAddress != address(0));
227         apiCallsContractAddress = newAddress;
228     }
229 }
230 contract APIRegistry is Ownable {
231 
232     struct APIForSale {
233         uint pricePerCall;
234         bytes32 sellerUsername;
235         bytes32 apiName;
236         address sellerAddress;
237         string hostname;
238         string docsUrl;
239     }
240 
241     mapping(string => uint) internal apiIds;
242     mapping(uint => APIForSale) public apis;
243 
244     uint public numApis;
245     uint public version;
246 
247     // ------------------------------------------------------------------------
248     // Constructor, establishes ownership because contract is owned
249     // ------------------------------------------------------------------------
250     constructor() public {
251         numApis = 0;
252         version = 1;
253     }
254 
255     // ------------------------------------------------------------------------
256     // Owner can transfer out any accidentally sent ERC20 tokens (just in case)
257     // ------------------------------------------------------------------------
258     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
259         return ERC20(tokenAddress).transfer(owner, tokens);
260     }
261 
262     // ------------------------------------------------------------------------
263     // Lets a user list an API to sell
264     // ------------------------------------------------------------------------
265     function listApi(uint pricePerCall, bytes32 sellerUsername, bytes32 apiName, string hostname, string docsUrl) public {
266         // make sure input params are valid
267         require(pricePerCall != 0 && sellerUsername != "" && apiName != "" && bytes(hostname).length != 0);
268         
269         // make sure the name isn't already taken
270         require(apiIds[hostname] == 0);
271 
272         numApis += 1;
273         apiIds[hostname] = numApis;
274 
275         APIForSale storage api = apis[numApis];
276 
277         api.pricePerCall = pricePerCall;
278         api.sellerUsername = sellerUsername;
279         api.apiName = apiName;
280         api.sellerAddress = msg.sender;
281         api.hostname = hostname;
282         api.docsUrl = docsUrl;
283     }
284 
285     // ------------------------------------------------------------------------
286     // Get the ID number of an API given it's hostname
287     // ------------------------------------------------------------------------
288     function getApiId(string hostname) public view returns (uint) {
289         return apiIds[hostname];
290     }
291 
292     // ------------------------------------------------------------------------
293     // Get info stored for the API but without the dynamic members, because solidity can't return dynamics to other smart contracts yet
294     // ------------------------------------------------------------------------
295     function getApiByIdWithoutDynamics(
296         uint apiId
297     ) 
298         public
299         view 
300         returns (
301             uint pricePerCall, 
302             bytes32 sellerUsername,
303             bytes32 apiName, 
304             address sellerAddress
305         ) 
306     {
307         APIForSale storage api = apis[apiId];
308 
309         pricePerCall = api.pricePerCall;
310         sellerUsername = api.sellerUsername;
311         apiName = api.apiName;
312         sellerAddress = api.sellerAddress;
313     }
314 
315     // ------------------------------------------------------------------------
316     // Get info stored for an API by id
317     // ------------------------------------------------------------------------
318     function getApiById(
319         uint apiId
320     ) 
321         public 
322         view 
323         returns (
324             uint pricePerCall, 
325             bytes32 sellerUsername, 
326             bytes32 apiName, 
327             address sellerAddress, 
328             string hostname, 
329             string docsUrl
330         ) 
331     {
332         APIForSale storage api = apis[apiId];
333 
334         pricePerCall = api.pricePerCall;
335         sellerUsername = api.sellerUsername;
336         apiName = api.apiName;
337         sellerAddress = api.sellerAddress;
338         hostname = api.hostname;
339         docsUrl = api.docsUrl;
340     }
341 
342     // ------------------------------------------------------------------------
343     // Get info stored for an API by hostname
344     // ------------------------------------------------------------------------
345     function getApiByName(
346         string _hostname
347     ) 
348         public 
349         view 
350         returns (
351             uint pricePerCall, 
352             bytes32 sellerUsername, 
353             bytes32 apiName, 
354             address sellerAddress, 
355             string hostname, 
356             string docsUrl
357         ) 
358     {
359         uint apiId = apiIds[_hostname];
360         if (apiId == 0) {
361             return;
362         }
363         APIForSale storage api = apis[apiId];
364 
365         pricePerCall = api.pricePerCall;
366         sellerUsername = api.sellerUsername;
367         apiName = api.apiName;
368         sellerAddress = api.sellerAddress;
369         hostname = api.hostname;
370         docsUrl = api.docsUrl;
371     }
372 
373     // ------------------------------------------------------------------------
374     // Edit an API listing
375     // ------------------------------------------------------------------------
376     function editApi(uint apiId, uint pricePerCall, address sellerAddress, string docsUrl) public {
377         require(apiId != 0 && pricePerCall != 0 && sellerAddress != address(0));
378 
379         APIForSale storage api = apis[apiId];
380 
381         // prevent editing an empty api (effectively listing an api)
382         require(
383             api.pricePerCall != 0 && api.sellerUsername != "" && api.apiName != "" &&  bytes(api.hostname).length != 0 && api.sellerAddress != address(0)
384         );
385 
386         // require that sender is the original api lister, or the contract owner
387         // the contract owner clause lets us recover a api listing if a dev loses access to their privkey
388         require(msg.sender == api.sellerAddress || msg.sender == owner);
389 
390         api.pricePerCall = pricePerCall;
391         api.sellerAddress = sellerAddress;
392         api.docsUrl = docsUrl;
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
604     }
605 
606     // Stores basic info about a buyer including their lifetime stats and reputation info
607     struct BuyerInfo {
608         // whether or not the account is overdrafted or not
609         bool overdrafted;
610         // total number of overdrafts, ever
611         uint lifetimeOverdraftCount;
612         // credits on file with this contract (wei)
613         uint credits;
614         // total amount of credits used / spent, ever (wei)
615         uint lifetimeCreditsUsed;
616         // maps apiId to approved spending balance for each API per second.
617         mapping(uint => uint) approvedAmounts;
618         // maps apiId to whether or not the user has exceeded their approved amount
619         mapping(uint => bool) exceededApprovedAmount;
620         // total number of times exceededApprovedAmount has happened
621         uint lifetimeExceededApprovalAmountCount;
622     }
623 
624     // Logged when API call usage is reported
625     event LogAPICallsMade(
626         uint apiId,
627         address indexed sellerAddress,
628         address indexed buyerAddress,
629         uint pricePerCall,
630         uint numCalls,
631         uint totalPrice,
632         address reportingAddress
633     );
634 
635     // Logged when seller is paid for API calls
636     event LogAPICallsPaid(
637         uint apiId,
638         address indexed sellerAddress,
639         uint totalPrice,
640         uint rewardedTokens,
641         uint networkFee
642     );
643 
644     // Logged when the credits from a specific buyer are spent on a specific api
645     event LogSpendCredits(
646         address indexed buyerAddress,
647         uint apiId,
648         uint amount,
649         bool causedAnOverdraft
650     );
651 
652     // Logged when a buyer deposits credits
653     event LogDepositCredits(
654         address indexed buyerAddress,
655         uint amount
656     );
657 
658     // Logged whena  buyer withdraws credits
659     event LogWithdrawCredits(
660         address indexed buyerAddress,
661         uint amount
662     );
663 
664     // ------------------------------------------------------------------------
665     // Constructor
666     // ------------------------------------------------------------------------
667     constructor() public {
668         version = 1;
669 
670         // default token reward of 100 tokens.  
671         // token has 18 decimal places so that's why 100 * 10^18
672         tokenReward = 100 * 10**18;
673 
674         // default saleFee of 10%
675         saleFee = 10;
676 
677         // 604,800 seconds = 1 week.  this is the default for when a user started using an api (1 week ago)
678         defaultBuyerLastPaidAt = 604800;
679 
680         // default withdrawAddress is owner
681         withdrawAddress = msg.sender;
682         usageReportingAddress = msg.sender;
683     }
684 
685     // ------------------------------------------------------------------------
686     // Owner can transfer out any accidentally sent ERC20 tokens (just in case)
687     // ------------------------------------------------------------------------
688     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
689         return ERC20(tokenAddress).transfer(owner, tokens);
690     }
691 
692     // ------------------------------------------------------------------------
693     // Owner can transfer out any ETH
694     // ------------------------------------------------------------------------
695     function withdrawEther(uint amount) public {
696         require(msg.sender == withdrawAddress);
697         require(amount <= this.balance);
698         require(amount <= safeWithdrawAmount);
699         safeWithdrawAmount = safeWithdrawAmount.sub(amount);
700         withdrawAddress.transfer(amount);
701     }
702 
703     // ------------------------------------------------------------------------
704     // Owner can set address of who can withdraw
705     // ------------------------------------------------------------------------
706     function setWithdrawAddress(address _withdrawAddress) public onlyOwner {
707         require(_withdrawAddress != address(0));
708         withdrawAddress = _withdrawAddress;
709     }
710 
711     // ------------------------------------------------------------------------
712     // Owner can set address of who can report usage
713     // ------------------------------------------------------------------------
714     function setUsageReportingAddress(address _usageReportingAddress) public onlyOwner {
715         require(_usageReportingAddress != address(0));
716         usageReportingAddress = _usageReportingAddress;
717     }
718 
719     // ------------------------------------------------------------------------
720     // Owner can set address of relay contract
721     // ------------------------------------------------------------------------
722     function setRelayContractAddress(address _relayContractAddress) public onlyOwner {
723         require(_relayContractAddress != address(0));
724         relayContractAddress = _relayContractAddress;
725     }
726 
727     // ------------------------------------------------------------------------
728     // Owner can set address of token contract
729     // ------------------------------------------------------------------------
730     function setTokenContractAddress(address _tokenContractAddress) public onlyOwner {
731         require(_tokenContractAddress != address(0));
732         tokenContractAddress = _tokenContractAddress;
733     }
734 
735     // ------------------------------------------------------------------------
736     // Owner can set token reward
737     // ------------------------------------------------------------------------
738     function setTokenReward(uint _tokenReward) public onlyOwner {
739         tokenReward = _tokenReward;
740     }
741 
742     // ------------------------------------------------------------------------
743     // Owner can set the sale fee
744     // ------------------------------------------------------------------------
745     function setSaleFee(uint _saleFee) public onlyOwner {
746         saleFee = _saleFee;
747     }
748 
749     // ------------------------------------------------------------------------
750     // Owner can set the default buyer last paid at
751     // ------------------------------------------------------------------------
752     function setDefaultBuyerLastPaidAt(uint _defaultBuyerLastPaidAt) public onlyOwner {
753         defaultBuyerLastPaidAt = _defaultBuyerLastPaidAt;
754     }
755 
756     // ------------------------------------------------------------------------
757     // The API owner or the authorized deconet usage reporting address may report usage
758     // ------------------------------------------------------------------------
759     function reportUsage(uint apiId, uint numCalls, address buyerAddress) public {
760         // look up the registry address from relay contract
761         Relay relay = Relay(relayContractAddress);
762         address apiRegistryAddress = relay.apiRegistryContractAddress();
763 
764         // get the module info from registry
765         APIRegistry apiRegistry = APIRegistry(apiRegistryAddress);
766 
767         uint pricePerCall;
768         bytes32 sellerUsername;
769         bytes32 apiName;
770         address sellerAddress;
771 
772         (pricePerCall, sellerUsername, apiName, sellerAddress) = apiRegistry.getApiByIdWithoutDynamics(apiId);
773 
774         // make sure the caller is either the api owner or the deconet reporting address
775         require(sellerAddress != address(0));
776         require(msg.sender == sellerAddress || msg.sender == usageReportingAddress);
777 
778         // make sure the api is actually valid
779         require(sellerUsername != "" && apiName != "");
780 
781         uint totalPrice = pricePerCall.mul(numCalls);
782 
783         require(totalPrice > 0);
784 
785         APIBalance storage apiBalance = owed[apiId];
786 
787         if (apiBalance.amounts[buyerAddress] == 0) {
788             // add buyerAddress to list of addresses with nonzero balance for this api
789             apiBalance.nonzeroAddresses.push(buyerAddress);
790         }
791 
792         apiBalance.amounts[buyerAddress] = apiBalance.amounts[buyerAddress].add(totalPrice);
793 
794         emit LogAPICallsMade(
795             apiId,
796             sellerAddress,
797             buyerAddress,
798             pricePerCall,
799             numCalls,
800             totalPrice,
801             msg.sender
802         );
803     }
804 
805     // ------------------------------------------------------------------------
806     // Function to pay the seller for a single API buyer.  
807     // Settles reported usage according to credits and approved amounts.
808     // ------------------------------------------------------------------------
809     function paySellerForBuyer(uint apiId, address buyerAddress) public {
810         // look up the registry address from relay contract
811         Relay relay = Relay(relayContractAddress);
812         address apiRegistryAddress = relay.apiRegistryContractAddress();
813 
814         // get the module info from registry
815         APIRegistry apiRegistry = APIRegistry(apiRegistryAddress);
816 
817         uint pricePerCall;
818         bytes32 sellerUsername;
819         bytes32 apiName;
820         address sellerAddress;
821 
822         (pricePerCall, sellerUsername, apiName, sellerAddress) = apiRegistry.getApiByIdWithoutDynamics(apiId);
823 
824         // make sure it's a legit real api
825         require(pricePerCall != 0 && sellerUsername != "" && apiName != "" && sellerAddress != address(0));
826 
827         uint buyerPaid = processSalesForSingleBuyer(apiId, buyerAddress);
828 
829         if (buyerPaid == 0) {
830             return; // buyer paid nothing, we are done.
831         }
832 
833         // calculate fee and payout
834         uint fee = buyerPaid.mul(saleFee).div(100);
835         uint payout = buyerPaid.sub(fee);
836 
837         // log that we stored the fee so we know we can take it out later
838         safeWithdrawAmount += fee;
839 
840         emit LogAPICallsPaid(
841             apiId,
842             sellerAddress,
843             buyerPaid,
844             tokenReward,
845             fee
846         );
847 
848         // give seller some tokens for the sale
849         rewardTokens(sellerAddress, tokenReward);
850 
851         // transfer seller the eth
852         sellerAddress.transfer(payout);
853     }
854 
855     // ------------------------------------------------------------------------
856     // Function to pay the seller for all buyers with nonzero balance.  
857     // Settles reported usage according to credits and approved amounts.
858     // ------------------------------------------------------------------------
859     function paySeller(uint apiId) public {
860         // look up the registry address from relay contract
861         Relay relay = Relay(relayContractAddress);
862         address apiRegistryAddress = relay.apiRegistryContractAddress();
863 
864         // get the module info from registry
865         APIRegistry apiRegistry = APIRegistry(apiRegistryAddress);
866 
867         uint pricePerCall;
868         bytes32 sellerUsername;
869         bytes32 apiName;
870         address sellerAddress;
871 
872         (pricePerCall, sellerUsername, apiName, sellerAddress) = apiRegistry.getApiByIdWithoutDynamics(apiId);
873 
874         // make sure it's a legit real api
875         require(pricePerCall != 0 && sellerUsername != "" && apiName != "" && sellerAddress != address(0));
876 
877         // calculate totalPayable for the api
878         uint totalPayable = 0;
879         uint totalBuyers = 0;
880         (totalPayable, totalBuyers) = processSalesForAllBuyers(apiId);
881 
882         if (totalPayable == 0) {
883             return; // if there's nothing to pay, we are done here.
884         }
885 
886         // calculate fee and payout
887         uint fee = totalPayable.mul(saleFee).div(100);
888         uint payout = totalPayable.sub(fee);
889 
890         // log that we stored the fee so we know we can take it out later
891         safeWithdrawAmount += fee;
892 
893         // we reward token reward on a "per buyer" basis.  so multiply the reward to give by the number of actual buyers
894         uint totalTokenReward = tokenReward.mul(totalBuyers);
895 
896         emit LogAPICallsPaid(
897             apiId,
898             sellerAddress,
899             totalPayable,
900             totalTokenReward,
901             fee
902         );
903 
904         // give seller some tokens for the sale
905         rewardTokens(sellerAddress, totalTokenReward);
906 
907         // transfer seller the eth
908         sellerAddress.transfer(payout);
909     } 
910 
911     // ------------------------------------------------------------------------
912     // Let anyone see when the buyer last paid for a given API
913     // ------------------------------------------------------------------------
914     function buyerLastPaidAt(uint apiId, address buyerAddress) public view returns (uint) {
915         APIBalance storage apiBalance = owed[apiId];
916         return apiBalance.buyerLastPaidAt[buyerAddress];
917     }   
918 
919     // ------------------------------------------------------------------------
920     // Get buyer info struct for a specific buyer address
921     // ------------------------------------------------------------------------
922     function buyerInfoOf(address addr) 
923         public 
924         view 
925         returns (
926             bool overdrafted, 
927             uint lifetimeOverdraftCount, 
928             uint credits, 
929             uint lifetimeCreditsUsed, 
930             uint lifetimeExceededApprovalAmountCount
931         ) 
932     {
933         BuyerInfo storage buyer = buyers[addr];
934         overdrafted = buyer.overdrafted;
935         lifetimeOverdraftCount = buyer.lifetimeOverdraftCount;
936         credits = buyer.credits;
937         lifetimeCreditsUsed = buyer.lifetimeCreditsUsed;
938         lifetimeExceededApprovalAmountCount = buyer.lifetimeExceededApprovalAmountCount;
939     }
940 
941     // ------------------------------------------------------------------------
942     // Gets the credits balance of a buyer
943     // ------------------------------------------------------------------------
944     function creditsBalanceOf(address addr) public view returns (uint) {
945         BuyerInfo storage buyer = buyers[addr];
946         return buyer.credits;
947     }
948 
949     // ------------------------------------------------------------------------
950     // Lets a buyer add credits
951     // ------------------------------------------------------------------------
952     function addCredits(address to) public payable {
953         BuyerInfo storage buyer = buyers[to];
954         buyer.credits = buyer.credits.add(msg.value);
955         emit LogDepositCredits(to, msg.value);
956     }
957 
958     // ------------------------------------------------------------------------
959     // Lets a buyer withdraw credits
960     // ------------------------------------------------------------------------
961     function withdrawCredits(uint amount) public {
962         BuyerInfo storage buyer = buyers[msg.sender];
963         require(buyer.credits >= amount);
964         buyer.credits = buyer.credits.sub(amount);
965         msg.sender.transfer(amount);
966         emit LogWithdrawCredits(msg.sender, amount);
967     }
968 
969     // ------------------------------------------------------------------------
970     // Get the length of array of buyers who have a nonzero balance for a given API
971     // ------------------------------------------------------------------------
972     function nonzeroAddressesElementForApi(uint apiId, uint index) public view returns (address) {
973         APIBalance storage apiBalance = owed[apiId];
974         return apiBalance.nonzeroAddresses[index];
975     }
976 
977     // ------------------------------------------------------------------------
978     // Get an element from the array of buyers who have a nonzero balance for a given API
979     // ------------------------------------------------------------------------
980     function nonzeroAddressesLengthForApi(uint apiId) public view returns (uint) {
981         APIBalance storage apiBalance = owed[apiId];
982         return apiBalance.nonzeroAddresses.length;
983     }
984 
985     // ------------------------------------------------------------------------
986     // Get the amount owed for a specific api for a specific buyer
987     // ------------------------------------------------------------------------
988     function amountOwedForApiForBuyer(uint apiId, address buyerAddress) public view returns (uint) {
989         APIBalance storage apiBalance = owed[apiId];
990         return apiBalance.amounts[buyerAddress];
991     }
992 
993     // ------------------------------------------------------------------------
994     // Get the total owed for an entire api for all nonzero buyers
995     // ------------------------------------------------------------------------
996     function totalOwedForApi(uint apiId) public view returns (uint) {
997         APIBalance storage apiBalance = owed[apiId];
998 
999         uint totalOwed = 0;
1000         for (uint i = 0; i < apiBalance.nonzeroAddresses.length; i++) {
1001             address buyerAddress = apiBalance.nonzeroAddresses[i];
1002             uint buyerOwes = apiBalance.amounts[buyerAddress];
1003             totalOwed = totalOwed.add(buyerOwes);
1004         }
1005 
1006         return totalOwed;
1007     }
1008 
1009     // ------------------------------------------------------------------------
1010     // Gets the amount of wei per second a buyer has approved for a specific api
1011     // ------------------------------------------------------------------------
1012     function approvedAmount(uint apiId, address buyerAddress) public view returns (uint) {
1013         return buyers[buyerAddress].approvedAmounts[apiId];
1014     }
1015 
1016     // ------------------------------------------------------------------------
1017     // Let the buyer set an approved amount of wei per second for a specific api
1018     // ------------------------------------------------------------------------
1019     function approveAmount(uint apiId, address buyerAddress, uint newAmount) public {
1020         require(buyerAddress != address(0) && apiId != 0);
1021 
1022         // only the buyer or the usage reporing system can change the buyers approval amount
1023         require(msg.sender == buyerAddress || msg.sender == usageReportingAddress);
1024 
1025         BuyerInfo storage buyer = buyers[buyerAddress];
1026         buyer.approvedAmounts[apiId] = newAmount;
1027     }
1028 
1029     // ------------------------------------------------------------------------
1030     // function to let the buyer set their approved amount of wei per second for an api
1031     // this function also lets the buyer set the time they last paid for an API if they've never paid that API before.  
1032     // this is important because the total amount approved for a given transaction is based on a wei per second spending limit
1033     // but the smart contract doesn't know when the buyer started using the API
1034     // so with this function, a buyer can et the time they first used the API and the approved amount calculations will be accurate when the seller requests payment.
1035     // ------------------------------------------------------------------------
1036     function approveAmountAndSetFirstUseTime(
1037         uint apiId, 
1038         address buyerAddress, 
1039         uint newAmount, 
1040         uint firstUseTime
1041     ) 
1042         public 
1043     {
1044         require(buyerAddress != address(0) && apiId != 0);
1045 
1046         // only the buyer or the usage reporing system can change the buyers approval amount
1047         require(msg.sender == buyerAddress || msg.sender == usageReportingAddress);
1048 
1049         APIBalance storage apiBalance = owed[apiId];
1050         require(apiBalance.buyerLastPaidAt[buyerAddress] == 0);
1051 
1052         apiBalance.buyerLastPaidAt[buyerAddress] = firstUseTime;
1053         
1054         BuyerInfo storage buyer = buyers[buyerAddress];
1055         buyer.approvedAmounts[apiId] = newAmount;
1056 
1057     }
1058 
1059     // ------------------------------------------------------------------------
1060     // Gets whether or not a buyer exceeded their approved amount in the last seller payout
1061     // ------------------------------------------------------------------------
1062     function buyerExceededApprovedAmount(uint apiId, address buyerAddress) public view returns (bool) {
1063         return buyers[buyerAddress].exceededApprovedAmount[apiId];
1064     }
1065 
1066     // ------------------------------------------------------------------------
1067     // Reward user with tokens IF the contract has them in it's allowance
1068     // ------------------------------------------------------------------------
1069     function rewardTokens(address toReward, uint amount) private {
1070         DeconetToken token = DeconetToken(tokenContractAddress);
1071         address tokenOwner = token.owner();
1072 
1073         // check balance of tokenOwner
1074         uint tokenOwnerBalance = token.balanceOf(tokenOwner);
1075         uint tokenOwnerAllowance = token.allowance(tokenOwner, address(this));
1076         if (tokenOwnerBalance >= amount && tokenOwnerAllowance >= amount) {
1077             token.transferFrom(tokenOwner, toReward, amount);
1078         }
1079     }
1080 
1081     // ------------------------------------------------------------------------
1082     // Process and settle balances for a single buyer for a specific api
1083     // ------------------------------------------------------------------------
1084     function processSalesForSingleBuyer(uint apiId, address buyerAddress) private returns (uint) {
1085         APIBalance storage apiBalance = owed[apiId];
1086 
1087         uint buyerOwes = apiBalance.amounts[buyerAddress];
1088         uint buyerLastPaidAtTime = apiBalance.buyerLastPaidAt[buyerAddress];
1089         if (buyerLastPaidAtTime == 0) {
1090             // if buyer has never paid, assume they paid a week ago.  or whatever now - defaultBuyerLastPaidAt is.
1091             buyerLastPaidAtTime = now - defaultBuyerLastPaidAt; // default is 604,800 = 7 days of seconds
1092         }
1093         uint elapsedSecondsSinceLastPayout = now - buyerLastPaidAtTime;
1094         uint buyerNowOwes = buyerOwes;
1095         uint buyerPaid = 0;
1096         bool overdrafted = false;
1097 
1098         (buyerPaid, overdrafted) = chargeBuyer(apiId, buyerAddress, elapsedSecondsSinceLastPayout, buyerOwes);
1099 
1100         buyerNowOwes = buyerOwes.sub(buyerPaid);
1101         apiBalance.amounts[buyerAddress] = buyerNowOwes;
1102 
1103         // if the buyer now owes zero, then remove them from nonzeroAddresses
1104         if (buyerNowOwes != 0) {
1105             removeAddressFromNonzeroBalancesArray(apiId, buyerAddress);
1106         }
1107         // if the buyer paid nothing, we are done here.
1108         if (buyerPaid == 0) {
1109             return 0;
1110         }
1111 
1112         // log the event
1113         emit LogSpendCredits(buyerAddress, apiId, buyerPaid, overdrafted);
1114 
1115         // log that they paid
1116         apiBalance.buyerLastPaidAt[buyerAddress] = now;
1117         
1118         return buyerPaid;
1119     }
1120 
1121     // ------------------------------------------------------------------------
1122     // Process and settle balances for all buyers with a nonzero balance for a specific api
1123     // ------------------------------------------------------------------------
1124     function processSalesForAllBuyers(uint apiId) private returns (uint totalPayable, uint totalBuyers) {
1125         APIBalance storage apiBalance = owed[apiId];
1126 
1127         uint currentTime = now;
1128         address[] memory oldNonzeroAddresses = apiBalance.nonzeroAddresses;
1129         apiBalance.nonzeroAddresses = new address[](0);
1130 
1131         for (uint i = 0; i < oldNonzeroAddresses.length; i++) {
1132             address buyerAddress = oldNonzeroAddresses[i];
1133             uint buyerOwes = apiBalance.amounts[buyerAddress];
1134             uint buyerLastPaidAtTime = apiBalance.buyerLastPaidAt[buyerAddress];
1135             if (buyerLastPaidAtTime == 0) {
1136                 // if buyer has never paid, assume they paid a week ago.  or whatever now - defaultBuyerLastPaidAt is.
1137                 buyerLastPaidAtTime = now - defaultBuyerLastPaidAt; // default is 604,800 = 7 days of seconds
1138             }
1139             uint elapsedSecondsSinceLastPayout = currentTime - buyerLastPaidAtTime;
1140             uint buyerNowOwes = buyerOwes;
1141             uint buyerPaid = 0;
1142             bool overdrafted = false;
1143 
1144             (buyerPaid, overdrafted) = chargeBuyer(apiId, buyerAddress, elapsedSecondsSinceLastPayout, buyerOwes);
1145 
1146             totalPayable = totalPayable.add(buyerPaid);
1147             buyerNowOwes = buyerOwes.sub(buyerPaid);
1148             apiBalance.amounts[buyerAddress] = buyerNowOwes;
1149 
1150             // if the buyer still owes something, make sure we keep them in the nonzeroAddresses array
1151             if (buyerNowOwes != 0) {
1152                 apiBalance.nonzeroAddresses.push(buyerAddress);
1153             }
1154             // if the buyer paid more than 0, log the spend.
1155             if (buyerPaid != 0) {
1156                 // log the event
1157                 emit LogSpendCredits(buyerAddress, apiId, buyerPaid, overdrafted);
1158 
1159                 // log that they paid
1160                 apiBalance.buyerLastPaidAt[buyerAddress] = now;
1161 
1162                 // add to total buyer count
1163                 totalBuyers += 1;
1164             }
1165         }
1166     }
1167 
1168     // ------------------------------------------------------------------------
1169     // given a specific buyer, api, and the amount they owe, we need to figure out how much to pay
1170     // the final amount paid is based on the chart below:
1171     // if credits >= approved >= owed then pay owed
1172     // if credits >= owed > approved then pay approved and mark as exceeded approved amount
1173     // if owed > credits >= approved then pay approved and mark as overdrafted
1174     // if owed > approved > credits then pay credits and mark as overdrafted
1175     // ------------------------------------------------------------------------
1176     function chargeBuyer(
1177         uint apiId, 
1178         address buyerAddress, 
1179         uint elapsedSecondsSinceLastPayout, 
1180         uint buyerOwes
1181     ) 
1182         private 
1183         returns (
1184             uint paid, 
1185             bool overdrafted
1186         ) 
1187     {
1188         BuyerInfo storage buyer = buyers[buyerAddress];
1189         uint approvedAmountPerSecond = buyer.approvedAmounts[apiId];
1190         uint approvedAmountSinceLastPayout = approvedAmountPerSecond.mul(elapsedSecondsSinceLastPayout);
1191         
1192         // do we have the credits to pay owed?
1193         if (buyer.credits >= buyerOwes) {
1194             // yay, buyer can pay their debits
1195             overdrafted = false;
1196             buyer.overdrafted = false;
1197 
1198             // has buyer approved enough to pay what they owe?
1199             if (approvedAmountSinceLastPayout >= buyerOwes) {
1200                 // approved is greater than owed.  
1201                 // mark as not exceeded approved amount
1202                 buyer.exceededApprovedAmount[apiId] = false;
1203 
1204                 // we can pay the entire debt
1205                 paid = buyerOwes;
1206 
1207             } else {
1208                 // they have no approved enough
1209                 // mark as exceeded
1210                 buyer.exceededApprovedAmount[apiId] = true;
1211                 buyer.lifetimeExceededApprovalAmountCount += 1;
1212 
1213                 // we can only pay the approved portion of the debt
1214                 paid = approvedAmountSinceLastPayout;
1215             }
1216         } else {
1217             // buyer spent more than they have.  mark as overdrafted
1218             overdrafted = true;
1219             buyer.overdrafted = true;
1220             buyer.lifetimeOverdraftCount += 1;
1221 
1222             // does buyer have more credits than the amount they've approved?
1223             if (buyer.credits >= approvedAmountSinceLastPayout) {
1224                 // they have enough credits to pay approvedAmountSinceLastPayout, so pay that
1225                 paid = approvedAmountSinceLastPayout;
1226 
1227             } else {
1228                 // the don't have enough credits to pay approvedAmountSinceLastPayout
1229                 // so just pay whatever credits they have
1230                 paid = buyer.credits;
1231             }
1232         }
1233 
1234         buyer.credits = buyer.credits.sub(paid);
1235         buyer.lifetimeCreditsUsed = buyer.lifetimeCreditsUsed.add(paid);
1236     }
1237 
1238     function removeAddressFromNonzeroBalancesArray(uint apiId, address toRemove) private {
1239         APIBalance storage apiBalance = owed[apiId];
1240 
1241         bool foundElement = false;
1242 
1243         for (uint i = 0; i < apiBalance.nonzeroAddresses.length-1; i++) {
1244             if (apiBalance.nonzeroAddresses[i] == toRemove) {
1245                 foundElement = true;
1246             }
1247             if (foundElement == true) {
1248                 apiBalance.nonzeroAddresses[i] = apiBalance.nonzeroAddresses[i+1];
1249             }
1250         }
1251         if (foundElement == true) {
1252             apiBalance.nonzeroAddresses.length--;
1253         }
1254     }
1255 }