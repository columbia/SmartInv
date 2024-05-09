1 pragma solidity 0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract Ownable {
6   address public owner;
7 
8 
9   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() public {
17     owner = msg.sender;
18   }
19 
20   /**
21    * @dev Throws if called by any account other than the owner.
22    */
23   modifier onlyOwner() {
24     require(msg.sender == owner);
25     _;
26   }
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) public onlyOwner {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, throws on overflow.
44   */
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     if (a == 0) {
47       return 0;
48     }
49     uint256 c = a * b;
50     assert(c / a == b);
51     return c;
52   }
53 
54   /**
55   * @dev Integer division of two numbers, truncating the quotient.
56   */
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63 
64   /**
65   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
66   */
67   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   /**
73   * @dev Adds two numbers, throws on overflow.
74   */
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 contract ERC20Basic {
83   function totalSupply() public view returns (uint256);
84   function balanceOf(address who) public view returns (uint256);
85   function transfer(address to, uint256 value) public returns (bool);
86   event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 contract BasicToken is ERC20Basic {
90   using SafeMath for uint256;
91 
92   mapping(address => uint256) balances;
93 
94   uint256 totalSupply_;
95 
96   /**
97   * @dev total number of tokens in existence
98   */
99   function totalSupply() public view returns (uint256) {
100     return totalSupply_;
101   }
102 
103   /**
104   * @dev transfer token for a specified address
105   * @param _to The address to transfer to.
106   * @param _value The amount to be transferred.
107   */
108   function transfer(address _to, uint256 _value) public returns (bool) {
109     require(_to != address(0));
110     require(_value <= balances[msg.sender]);
111 
112     // SafeMath.sub will throw if there is not enough balance.
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of.
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) public view returns (uint256 balance) {
125     return balances[_owner];
126   }
127 
128 }
129 
130 contract Pausable is Ownable {
131   event Pause();
132   event Unpause();
133 
134   bool public paused = false;
135 
136 
137   /**
138    * @dev Modifier to make a function callable only when the contract is not paused.
139    */
140   modifier whenNotPaused() {
141     require(!paused);
142     _;
143   }
144 
145   /**
146    * @dev Modifier to make a function callable only when the contract is paused.
147    */
148   modifier whenPaused() {
149     require(paused);
150     _;
151   }
152 
153   /**
154    * @dev called by the owner to pause, triggers stopped state
155    */
156   function pause() onlyOwner whenNotPaused public {
157     paused = true;
158     Pause();
159   }
160 
161   /**
162    * @dev called by the owner to unpause, returns to normal state
163    */
164   function unpause() onlyOwner whenPaused public {
165     paused = false;
166     Unpause();
167   }
168 }
169 
170 contract ERC20 is ERC20Basic {
171   function allowance(address owner, address spender) public view returns (uint256);
172   function transferFrom(address from, address to, uint256 value) public returns (bool);
173   function approve(address spender, uint256 value) public returns (bool);
174   event Approval(address indexed owner, address indexed spender, uint256 value);
175 }
176 
177 contract StandardToken is ERC20, BasicToken {
178 
179   mapping (address => mapping (address => uint256)) internal allowed;
180 
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param _from address The address which you want to send tokens from
185    * @param _to address The address which you want to transfer to
186    * @param _value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
189     require(_to != address(0));
190     require(_value <= balances[_from]);
191     require(_value <= allowed[_from][msg.sender]);
192 
193     balances[_from] = balances[_from].sub(_value);
194     balances[_to] = balances[_to].add(_value);
195     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
196     Transfer(_from, _to, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
202    *
203    * Beware that changing an allowance with this method brings the risk that someone may use both the old
204    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
205    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
206    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207    * @param _spender The address which will spend the funds.
208    * @param _value The amount of tokens to be spent.
209    */
210   function approve(address _spender, uint256 _value) public returns (bool) {
211     allowed[msg.sender][_spender] = _value;
212     Approval(msg.sender, _spender, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Function to check the amount of tokens that an owner allowed to a spender.
218    * @param _owner address The address which owns the funds.
219    * @param _spender address The address which will spend the funds.
220    * @return A uint256 specifying the amount of tokens still available for the spender.
221    */
222   function allowance(address _owner, address _spender) public view returns (uint256) {
223     return allowed[_owner][_spender];
224   }
225 
226   /**
227    * @dev Increase the amount of tokens that an owner allowed to a spender.
228    *
229    * approve should be called when allowed[_spender] == 0. To increment
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _addedValue The amount of tokens to increase the allowance by.
235    */
236   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
237     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242   /**
243    * @dev Decrease the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To decrement
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _subtractedValue The amount of tokens to decrease the allowance by.
251    */
252   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
253     uint oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue > oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263 }
264 
265 contract DeconetToken is StandardToken, Ownable, Pausable {
266     // token naming etc
267     string public constant symbol = "DCO";
268     string public constant name = "Deconet Token";
269     uint8 public constant decimals = 18;
270 
271     // contract version
272     uint public constant version = 4;
273 
274     // ------------------------------------------------------------------------
275     // Constructor
276     // ------------------------------------------------------------------------
277     constructor() public {
278         // 1 billion tokens (1,000,000,000)
279         totalSupply_ = 1000000000 * 10**uint(decimals);
280 
281         // transfer initial supply to msg.sender who is also contract owner
282         balances[msg.sender] = totalSupply_;
283         Transfer(address(0), msg.sender, totalSupply_);
284 
285         // pause contract until we're ready to allow transfers
286         paused = true;
287     }
288 
289     // ------------------------------------------------------------------------
290     // Owner can transfer out any accidentally sent ERC20 tokens (just in case)
291     // ------------------------------------------------------------------------
292     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
293         return ERC20(tokenAddress).transfer(owner, tokens);
294     }
295 
296     // ------------------------------------------------------------------------
297     // Modifier to make a function callable only when called by the contract owner
298     // or if the contract is not paused.
299     // ------------------------------------------------------------------------
300     modifier whenOwnerOrNotPaused() {
301         require(msg.sender == owner || !paused);
302         _;
303     }
304 
305     // ------------------------------------------------------------------------
306     // overloaded openzepplin method to add whenOwnerOrNotPaused modifier
307     // ------------------------------------------------------------------------
308     function transfer(address _to, uint256 _value) public whenOwnerOrNotPaused returns (bool) {
309         return super.transfer(_to, _value);
310     }
311 
312     // ------------------------------------------------------------------------
313     // overloaded openzepplin method to add whenOwnerOrNotPaused modifier
314     // ------------------------------------------------------------------------
315     function transferFrom(address _from, address _to, uint256 _value) public whenOwnerOrNotPaused returns (bool) {
316         return super.transferFrom(_from, _to, _value);
317     }
318 
319     // ------------------------------------------------------------------------
320     // overloaded openzepplin method to add whenOwnerOrNotPaused modifier
321     // ------------------------------------------------------------------------
322     function approve(address _spender, uint256 _value) public whenOwnerOrNotPaused returns (bool) {
323         return super.approve(_spender, _value);
324     }
325 
326     // ------------------------------------------------------------------------
327     // overloaded openzepplin method to add whenOwnerOrNotPaused modifier
328     // ------------------------------------------------------------------------
329     function increaseApproval(address _spender, uint _addedValue) public whenOwnerOrNotPaused returns (bool success) {
330         return super.increaseApproval(_spender, _addedValue);
331     }
332 
333     // ------------------------------------------------------------------------
334     // overloaded openzepplin method to add whenOwnerOrNotPaused modifier
335     // ------------------------------------------------------------------------
336     function decreaseApproval(address _spender, uint _subtractedValue) public whenOwnerOrNotPaused returns (bool success) {
337         return super.decreaseApproval(_spender, _subtractedValue);
338     }
339 }
340 
341 contract Relay is Ownable {
342     address public licenseSalesContractAddress;
343     address public registryContractAddress;
344     address public apiRegistryContractAddress;
345     address public apiCallsContractAddress;
346     uint public version;
347 
348     // ------------------------------------------------------------------------
349     // Constructor, establishes ownership because contract is owned
350     // ------------------------------------------------------------------------
351     constructor() public {
352         version = 4;
353     }
354 
355     // ------------------------------------------------------------------------
356     // Owner can transfer out any accidentally sent ERC20 tokens (just in case)
357     // ------------------------------------------------------------------------
358     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
359         return ERC20(tokenAddress).transfer(owner, tokens);
360     }
361 
362     // ------------------------------------------------------------------------
363     // Sets the license sales contract address
364     // ------------------------------------------------------------------------
365     function setLicenseSalesContractAddress(address newAddress) public onlyOwner {
366         require(newAddress != address(0));
367         licenseSalesContractAddress = newAddress;
368     }
369 
370     // ------------------------------------------------------------------------
371     // Sets the registry contract address
372     // ------------------------------------------------------------------------
373     function setRegistryContractAddress(address newAddress) public onlyOwner {
374         require(newAddress != address(0));
375         registryContractAddress = newAddress;
376     }
377 
378     // ------------------------------------------------------------------------
379     // Sets the api registry contract address
380     // ------------------------------------------------------------------------
381     function setApiRegistryContractAddress(address newAddress) public onlyOwner {
382         require(newAddress != address(0));
383         apiRegistryContractAddress = newAddress;
384     }
385 
386     // ------------------------------------------------------------------------
387     // Sets the api calls contract address
388     // ------------------------------------------------------------------------
389     function setApiCallsContractAddress(address newAddress) public onlyOwner {
390         require(newAddress != address(0));
391         apiCallsContractAddress = newAddress;
392     }
393 }
394 contract Registry is Ownable {
395 
396     struct ModuleForSale {
397         uint price;
398         bytes32 sellerUsername;
399         bytes32 moduleName;
400         address sellerAddress;
401         bytes4 licenseId;
402     }
403 
404     mapping(string => uint) internal moduleIds;
405     mapping(uint => ModuleForSale) public modules;
406 
407     uint public numModules;
408     uint public version;
409 
410     // ------------------------------------------------------------------------
411     // Constructor, establishes ownership because contract is owned
412     // ------------------------------------------------------------------------
413     constructor() public {
414         numModules = 0;
415         version = 1;
416     }
417 
418     // ------------------------------------------------------------------------
419     // Owner can transfer out any accidentally sent ERC20 tokens (just in case)
420     // ------------------------------------------------------------------------
421     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
422         return ERC20(tokenAddress).transfer(owner, tokens);
423     }
424 
425     // ------------------------------------------------------------------------
426     // Lets a user list a software module for sale in this registry
427     // ------------------------------------------------------------------------
428     function listModule(uint price, bytes32 sellerUsername, bytes32 moduleName, string usernameAndProjectName, bytes4 licenseId) public {
429         // make sure input params are valid
430         require(price != 0 && sellerUsername != "" && moduleName != "" && bytes(usernameAndProjectName).length != 0 && licenseId != 0);
431 
432         // make sure the name isn't already taken
433         require(moduleIds[usernameAndProjectName] == 0);
434 
435         numModules += 1;
436         moduleIds[usernameAndProjectName] = numModules;
437 
438         ModuleForSale storage module = modules[numModules];
439 
440         module.price = price;
441         module.sellerUsername = sellerUsername;
442         module.moduleName = moduleName;
443         module.sellerAddress = msg.sender;
444         module.licenseId = licenseId;
445     }
446 
447     // ------------------------------------------------------------------------
448     // Get the ID number of a module given the username and project name of that module
449     // ------------------------------------------------------------------------
450     function getModuleId(string usernameAndProjectName) public view returns (uint) {
451         return moduleIds[usernameAndProjectName];
452     }
453 
454     // ------------------------------------------------------------------------
455     // Get info stored for a module by id
456     // ------------------------------------------------------------------------
457     function getModuleById(
458         uint moduleId
459     ) 
460         public 
461         view 
462         returns (
463             uint price, 
464             bytes32 sellerUsername, 
465             bytes32 moduleName, 
466             address sellerAddress, 
467             bytes4 licenseId
468         ) 
469     {
470         ModuleForSale storage module = modules[moduleId];
471         
472 
473         if (module.sellerAddress == address(0)) {
474             return;
475         }
476 
477         price = module.price;
478         sellerUsername = module.sellerUsername;
479         moduleName = module.moduleName;
480         sellerAddress = module.sellerAddress;
481         licenseId = module.licenseId;
482     }
483 
484     // ------------------------------------------------------------------------
485     // get info stored for a module by name
486     // ------------------------------------------------------------------------
487     function getModuleByName(
488         string usernameAndProjectName
489     ) 
490         public 
491         view
492         returns (
493             uint price, 
494             bytes32 sellerUsername, 
495             bytes32 moduleName, 
496             address sellerAddress, 
497             bytes4 licenseId
498         ) 
499     {
500         uint moduleId = moduleIds[usernameAndProjectName];
501         if (moduleId == 0) {
502             return;
503         }
504         ModuleForSale storage module = modules[moduleId];
505 
506         price = module.price;
507         sellerUsername = module.sellerUsername;
508         moduleName = module.moduleName;
509         sellerAddress = module.sellerAddress;
510         licenseId = module.licenseId;
511     }
512 
513     // ------------------------------------------------------------------------
514     // Edit a module listing
515     // ------------------------------------------------------------------------
516     function editModule(uint moduleId, uint price, address sellerAddress, bytes4 licenseId) public {
517         // Make sure input params are valid
518         require(moduleId != 0 && price != 0 && sellerAddress != address(0) && licenseId != 0);
519 
520         ModuleForSale storage module = modules[moduleId];
521 
522         // prevent editing an empty module (effectively listing a module)
523         require(
524             module.price != 0 && module.sellerUsername != "" && module.moduleName != "" && module.licenseId != 0 && module.sellerAddress != address(0)
525         );
526 
527         // require that sender is the original module lister, or the contract owner
528         // the contract owner clause lets us recover a module listing if a dev loses access to their privkey
529         require(msg.sender == module.sellerAddress || msg.sender == owner);
530 
531         module.price = price;
532         module.sellerAddress = sellerAddress;
533         module.licenseId = licenseId;
534     }
535 }
536 contract LicenseSales is Ownable {
537     using SafeMath for uint;
538 
539     // the amount rewarded to a seller for selling a license
540     uint public tokenReward;
541 
542     // the fee this contract takes from every sale.  expressed as percent.  so a value of 3 indicates a 3% txn fee
543     uint public saleFee;
544 
545     // address of the relay contract which holds the address of the registry contract.
546     address public relayContractAddress;
547 
548     // the token address
549     address public tokenContractAddress;
550 
551     // this contract version
552     uint public version;
553 
554     // the address that is authorized to withdraw eth
555     address private withdrawAddress;
556 
557     event LicenseSale(
558         bytes32 moduleName,
559         bytes32 sellerUsername,
560         address indexed sellerAddress,
561         address indexed buyerAddress,
562         uint price,
563         uint soldAt,
564         uint rewardedTokens,
565         uint networkFee,
566         bytes4 licenseId
567     );
568 
569     // ------------------------------------------------------------------------
570     // Constructor
571     // ------------------------------------------------------------------------
572     constructor() public {
573         version = 1;
574 
575         // default token reward of 100 tokens.  
576         // token has 18 decimal places so that's why 100 * 10^18
577         tokenReward = 100 * 10**18;
578 
579         // default saleFee of 10%
580         saleFee = 10;
581 
582         // default withdrawAddress is owner
583         withdrawAddress = msg.sender;
584     }
585 
586     // ------------------------------------------------------------------------
587     // Owner can transfer out any accidentally sent ERC20 tokens (just in case)
588     // ------------------------------------------------------------------------
589     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
590         return ERC20(tokenAddress).transfer(owner, tokens);
591     }
592 
593     // ------------------------------------------------------------------------
594     // Owner can transfer out any ETH
595     // ------------------------------------------------------------------------
596     function withdrawEther() public {
597         require(msg.sender == withdrawAddress);
598         withdrawAddress.transfer(this.balance);
599     }
600 
601     // ------------------------------------------------------------------------
602     // Owner can set address of who can withdraw
603     // ------------------------------------------------------------------------
604     function setWithdrawAddress(address _withdrawAddress) public onlyOwner {
605         require(_withdrawAddress != address(0));
606         withdrawAddress = _withdrawAddress;
607     }
608 
609     // ------------------------------------------------------------------------
610     // Owner can set address of relay contract
611     // ------------------------------------------------------------------------
612     function setRelayContractAddress(address _relayContractAddress) public onlyOwner {
613         require(_relayContractAddress != address(0));
614         relayContractAddress = _relayContractAddress;
615     }
616 
617     // ------------------------------------------------------------------------
618     // Owner can set address of token contract
619     // ------------------------------------------------------------------------
620     function setTokenContractAddress(address _tokenContractAddress) public onlyOwner {
621         require(_tokenContractAddress != address(0));
622         tokenContractAddress = _tokenContractAddress;
623     }
624 
625     // ------------------------------------------------------------------------
626     // Owner can set token reward
627     // ------------------------------------------------------------------------
628     function setTokenReward(uint _tokenReward) public onlyOwner {
629         tokenReward = _tokenReward;
630     }
631 
632     // ------------------------------------------------------------------------
633     // Owner can set the sale fee
634     // ------------------------------------------------------------------------
635     function setSaleFee(uint _saleFee) public onlyOwner {
636         saleFee = _saleFee;
637     }
638 
639     // ------------------------------------------------------------------------
640     // Anyone can make a sale if they provide a moduleId
641     // ------------------------------------------------------------------------
642     function makeSale(uint moduleId) public payable {
643         require(moduleId != 0);
644 
645         // look up the registry address from relay token
646         Relay relay = Relay(relayContractAddress);
647         address registryAddress = relay.registryContractAddress();
648 
649         // get the module info from registry
650         Registry registry = Registry(registryAddress);
651 
652         uint price;
653         bytes32 sellerUsername;
654         bytes32 moduleName;
655         address sellerAddress;
656         bytes4 licenseId;
657 
658         (price, sellerUsername, moduleName, sellerAddress, licenseId) = registry.getModuleById(moduleId);
659 
660         // make sure the customer has sent enough eth
661         require(msg.value >= price);
662 
663         // make sure the module is actually valid
664         require(sellerUsername != "" && moduleName != "" && sellerAddress != address(0) && licenseId != "");
665 
666         // calculate fee and payout
667         uint fee = msg.value.mul(saleFee).div(100); 
668         uint payout = msg.value.sub(fee);
669 
670         // log the sale
671         emit LicenseSale(
672             moduleName,
673             sellerUsername,
674             sellerAddress,
675             msg.sender,
676             price,
677             block.timestamp,
678             tokenReward,
679             fee,
680             licenseId
681         );
682 
683         // give seller some tokens for the sale
684         rewardTokens(sellerAddress);
685         
686         // pay seller the ETH
687         sellerAddress.transfer(payout);
688     }
689 
690     // ------------------------------------------------------------------------
691     // Reward user with tokens IF the contract has them in it's allowance
692     // ------------------------------------------------------------------------
693     function rewardTokens(address toReward) private {
694         DeconetToken token = DeconetToken(tokenContractAddress);
695         address tokenOwner = token.owner();
696 
697         // check balance of tokenOwner
698         uint tokenOwnerBalance = token.balanceOf(tokenOwner);
699         uint tokenOwnerAllowance = token.allowance(tokenOwner, address(this));
700         if (tokenOwnerBalance >= tokenReward && tokenOwnerAllowance >= tokenReward) {
701             token.transferFrom(tokenOwner, toReward, tokenReward);
702         }
703     }
704 }