1 pragma solidity^0.4.17;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable{
9   address public owner;
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
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) public onlyOwner {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a * b;
49     assert(a == 0 || c / a == b);
50     return c;
51   }
52 
53   function div(uint256 a, uint256 b) internal pure returns (uint256) {
54     // assert(b > 0); // Solidity automatically throws when dividing by 0
55     uint256 c = a / b;
56     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57     return c;
58   }
59 
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   function add(uint256 a, uint256 b) internal pure returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 /**
72  * @title ERC20Basic
73  * @dev Simpler version of ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/179
75  */
76 contract ERC20Basic {
77   uint256 public totalSupply;
78   function balanceOf(address who) public constant returns (uint256);
79   function transfer(address to, uint256 value) public returns (bool);
80   event Transfer(address indexed from, address indexed to, uint256 value);
81 }
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) public constant returns (uint256);
89   function transferFrom(address from, address to, uint256 value) public returns (bool);
90   function approve(address spender, uint256 value) public returns (bool);
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 
95 /**
96  * @title Basic token
97  * @dev Basic version of StandardToken, with no allowances. 
98  */
99 contract BasicToken is ERC20Basic {
100   using SafeMath for uint256;
101 
102   mapping(address => uint256) balances;
103 
104   /**
105   * @dev transfer token for a specified address
106   * @param _to The address to transfer to.
107   * @param _value The amount to be transferred.
108   */
109   function transfer(address _to, uint256 _value) public returns (bool) {
110     balances[msg.sender] = balances[msg.sender].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     Transfer(msg.sender, _to, _value);
113     return true;
114   }
115 
116   /**
117   * @dev Gets the balance of the specified address.
118   * @param _owner The address to query the the balance of. 
119   * @return An uint256 representing the amount owned by the passed address.
120   */
121   function balanceOf(address _owner) public constant returns (uint256 balance) {
122     return balances[_owner];
123   }
124 
125 }
126 
127 
128 
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implementation of the basic standard token.
134  * @dev https://github.com/ethereum/EIPs/issues/20
135  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  */
137 contract StandardToken is ERC20, BasicToken {
138 
139   mapping (address => mapping (address => uint256)) allowed;
140 
141 
142   /**
143    * @dev Transfer tokens from one address to another
144    * @param _from address The address which you want to send tokens from
145    * @param _to address The address which you want to transfer to
146    * @param _value uint256 the amout of tokens to be transfered
147    */
148   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
149     var _allowance = allowed[_from][msg.sender];
150 
151     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
152     // require (_value <= _allowance);
153 
154     balances[_to] = balances[_to].add(_value);
155     balances[_from] = balances[_from].sub(_value);
156     allowed[_from][msg.sender] = _allowance.sub(_value);
157     Transfer(_from, _to, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) public returns (bool) {
167 
168     // To change the approve amount you first have to reduce the addresses`
169     //  allowance to zero by calling `approve(_spender, 0)` if it is not
170     //  already 0 to mitigate the race condition described here:
171     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
173 
174     allowed[msg.sender][_spender] = _value;
175     Approval(msg.sender, _spender, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Function to check the amount of tokens that an owner allowed to a spender.
181    * @param _owner address The address which owns the funds.
182    * @param _spender address The address which will spend the funds.
183    * @return A uint256 specifing the amount of tokens still avaible for the spender.
184    */
185   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
186     return allowed[_owner][_spender];
187   }
188 
189 }
190 
191 contract VuePayTokenSale is StandardToken, Ownable {
192 	using SafeMath for uint256;
193 	// Events
194 	event CreatedVUP(address indexed _creator, uint256 _amountOfVUP);
195 	event VUPRefundedForWei(address indexed _refunder, uint256 _amountOfWei);
196 	event print(uint256 vup);
197 	// Token data
198 	string public constant name = "VuePay Token";
199 	string public constant symbol = "VUP";
200 	uint256 public constant decimals = 18;  // Since our decimals equals the number of wei per ether, we needn't multiply sent values when converting between VUP and ETH.
201 	string public version = "1.0";
202 	
203 	// Addresses and contracts
204 	address public executor;
205 	//Vuepay Multisig Wallet
206 	address public vuePayETHDestination=0x8B8698DEe100FC5F561848D0E57E94502Bd9318b;
207 	//Vuepay Development activities Wallet
208 	address public constant devVUPDestination=0x31403fA55aEa2065bBDd2778bFEd966014ab0081;
209 	//VuePay Core Team reserve Wallet
210 	address public constant coreVUPDestination=0x22d310194b5ac5086bDacb2b0f36D8f0a5971b23;
211 	//VuePay Advisory and Promotions (PR/Marketing/Media etcc.) wallet
212 	address public constant advisoryVUPDestination=0x991ABE74a1AC3d903dA479Ca9fede3d0954d430B;
213 	//VuePay User DEvelopment Fund Wallet
214 	address public constant udfVUPDestination=0xf4307C073451b80A0BaD1E099fD2B7f0fe38b7e9;
215 	//Vuepay Cofounder Wallet
216 	address public constant cofounderVUPDestination=0x863B2217E80e6C6192f63D3716c0cC7711Fad5b4;
217 	//VuePay Unsold Tokens wallet
218 	address public constant unsoldVUPDestination=0x5076084a3377ecDF8AD5cD0f26A21bA848DdF435;
219 	//Total VuePay Sold
220 	uint256 public totalVUP;
221 	
222 	// Sale data
223 	bool public saleHasEnded;
224 	bool public minCapReached;
225 	bool public preSaleEnded;
226 	bool public allowRefund;
227 	mapping (address => uint256) public ETHContributed;
228 	uint256 public totalETHRaised;
229 	uint256 public preSaleStartBlock;
230 	uint256 public preSaleEndBlock;
231 	uint256 public icoEndBlock;
232 	
233     uint public constant coldStorageYears = 10 years;
234     uint public coreTeamUnlockedAt;
235     uint public unsoldUnlockedAt;
236     uint256 coreTeamShare;
237     uint256 cofounderShare;
238     uint256 advisoryTeamShare;
239     
240 	// Calculate the VUP to ETH rate for the current time period of the sale
241 	uint256 curTokenRate = VUP_PER_ETH_BASE_RATE;
242 	uint256 public constant INITIAL_VUP_TOKEN_SUPPLY =1000000000e18;
243 	uint256 public constant VUP_TOKEN_SUPPLY_TIER1 =150000000e18;
244     uint256 public constant VUP_TOKEN_SUPPLY_TIER2 =270000000e18;
245 	uint256 public constant VUP_TOKEN_SUPPLY_TIER3 =380000000e18;
246 	uint256 public constant VUP_TOKEN_SUPPLY_TIER4 =400000000e18;
247 	
248 	uint256 public constant PRESALE_ICO_PORTION =400000000e18;  // Total for sale in Pre Sale and ICO In percentage
249 	uint256 public constant ADVISORY_TEAM_PORTION =50000000e18;  // Total Advisory share In percentage
250 	uint256 public constant CORE_TEAM_PORTION =50000000e18;  // Total core Team share  percentage
251 	uint256 public constant DEV_TEAM_PORTION =50000000e18;  // Total dev team share In percentage
252 	uint256 public constant CO_FOUNDER_PORTION = 350000000e18;  // Total cofounder share In percentage
253 	uint256 public constant UDF_PORTION =100000000e18;  // Total user deve fund share In percentage
254 	
255 	uint256 public constant VUP_PER_ETH_BASE_RATE = 2000;  // 2000 VUP = 1 ETH during normal part of token sale
256 	uint256 public constant VUP_PER_ETH_PRE_SALE_RATE = 3000; // 3000 VUP @ 50%  discount in pre sale
257 	
258 	uint256 public constant VUP_PER_ETH_ICO_TIER2_RATE = 2500; // 2500 VUP @ 25% discount
259 	uint256 public constant VUP_PER_ETH_ICO_TIER3_RATE = 2250;// 2250 VUP @ 12.5% discount
260 	
261 	
262 	function VuePayTokenSale () public payable
263 	{
264 
265 	    totalSupply = INITIAL_VUP_TOKEN_SUPPLY;
266 
267 		//Start Pre-sale approx on the 6th october 8:00 GMT
268 	    preSaleStartBlock=4340582;
269 	    //preSaleStartBlock=block.number;
270 	    preSaleEndBlock = preSaleStartBlock + 37800;  // Equivalent to 14 days later, assuming 32 second blocks
271 	    icoEndBlock = preSaleEndBlock + 81000;  // Equivalent to 30 days , assuming 32 second blocks
272 		executor = msg.sender;
273 		saleHasEnded = false;
274 		minCapReached = false;
275 		allowRefund = false;
276 		advisoryTeamShare = ADVISORY_TEAM_PORTION;
277 		totalETHRaised = 0;
278 		totalVUP=0;
279 
280 	}
281 
282 	function () payable public {
283 		
284 		//minimum .05 Ether required.
285 		require(msg.value >= .05 ether);
286 		// If sale is not active, do not create VUP
287 		require(!saleHasEnded);
288 		//Requires block to be >= Pre-Sale start block 
289 		require(block.number >= preSaleStartBlock);
290 		//Requires block.number to be less than icoEndBlock number
291 		require(block.number < icoEndBlock);
292 		//Has the Pre-Sale ended, after 14 days, Pre-Sale ends.
293 		if (block.number > preSaleEndBlock){
294 		    preSaleEnded=true;
295 		}
296 		// Do not do anything if the amount of ether sent is 0
297 		require(msg.value!=0);
298 
299 		uint256 newEtherBalance = totalETHRaised.add(msg.value);
300 		//Get the appropriate rate which applies
301 		getCurrentVUPRate();
302 		// Calculate the amount of VUP being purchase
303 		
304 		uint256 amountOfVUP = msg.value.mul(curTokenRate);
305 	
306         //Accrue VUP tokens
307 		totalVUP=totalVUP.add(amountOfVUP);
308 	    // if all tokens sold out , sale ends.
309 		require(totalVUP<= PRESALE_ICO_PORTION);
310 		
311 		// Ensure that the transaction is safe
312 		uint256 totalSupplySafe = totalSupply.sub(amountOfVUP);
313 		uint256 balanceSafe = balances[msg.sender].add(amountOfVUP);
314 		uint256 contributedSafe = ETHContributed[msg.sender].add(msg.value);
315 		
316 		// Update individual and total balances
317 		totalSupply = totalSupplySafe;
318 		balances[msg.sender] = balanceSafe;
319 
320 		totalETHRaised = newEtherBalance;
321 		ETHContributed[msg.sender] = contributedSafe;
322 
323 		CreatedVUP(msg.sender, amountOfVUP);
324 	}
325 	
326 	function getCurrentVUPRate() internal {
327 	        //default to the base rate
328 	        curTokenRate = VUP_PER_ETH_BASE_RATE;
329 
330 	        //if VUP sold < 100 mill and still in presale, use Pre-Sale rate
331 	        if ((totalVUP <= VUP_TOKEN_SUPPLY_TIER1) && (!preSaleEnded)) {    
332 			        curTokenRate = VUP_PER_ETH_PRE_SALE_RATE;
333 	        }
334 		    //If VUP Sold < 100 mill and Pre-Sale ended, use Tier2 rate
335 	        if ((totalVUP <= VUP_TOKEN_SUPPLY_TIER1) && (preSaleEnded)) {
336 			     curTokenRate = VUP_PER_ETH_ICO_TIER2_RATE;
337 		    }
338 		    //if VUP Sold > 100 mill, use Tier 2 rate irrespective of Pre-Sale end or not
339 		    if (totalVUP >VUP_TOKEN_SUPPLY_TIER1 ) {
340 			    curTokenRate = VUP_PER_ETH_ICO_TIER2_RATE;
341 		    }
342 		    //if VUP sold more than 200 mill use Tier3 rate
343 		    if (totalVUP >VUP_TOKEN_SUPPLY_TIER2 ) {
344 			    curTokenRate = VUP_PER_ETH_ICO_TIER3_RATE;
345 		        
346 		    }
347             //if VUP sod more than 300mill
348 		    if (totalVUP >VUP_TOKEN_SUPPLY_TIER3){
349 		        curTokenRate = VUP_PER_ETH_BASE_RATE;
350 		    }
351 	}
352     // Create VUP tokens from the Advisory bucket for marketing, PR, Media where we are 
353     //paying upfront for these activities in VUP tokens.
354     //Clients = Media, PR, Marketing promotion etc.
355     function createCustomVUP(address _clientVUPAddress,uint256 _value) public onlyOwner {
356 	    //Check the address is valid
357 	    require(_clientVUPAddress != address(0x0));
358 		require(_value >0);
359 		require(advisoryTeamShare>= _value);
360 	   
361 	  	uint256 amountOfVUP = _value;
362 	  	//Reduce from advisoryTeamShare
363 	    advisoryTeamShare=advisoryTeamShare.sub(amountOfVUP);
364         //Accrue VUP tokens
365 		totalVUP=totalVUP.add(amountOfVUP);
366 		//Assign tokens to the client
367 		uint256 balanceSafe = balances[_clientVUPAddress].add(amountOfVUP);
368 		balances[_clientVUPAddress] = balanceSafe;
369 		//Create VUP Created event
370 		CreatedVUP(_clientVUPAddress, amountOfVUP);
371 	
372 	}
373     
374 	function endICO() public onlyOwner{
375 		// Do not end an already ended sale
376 		require(!saleHasEnded);
377 		// Can't end a sale that hasn't hit its minimum cap
378 		require(minCapReached);
379 		
380 		saleHasEnded = true;
381 
382 		// Calculate and create all team share VUPs
383 	
384 	    coreTeamShare = CORE_TEAM_PORTION;
385 	    uint256 devTeamShare = DEV_TEAM_PORTION;
386 	    cofounderShare = CO_FOUNDER_PORTION;
387 	    uint256 udfShare = UDF_PORTION;
388 	
389 	    
390 		balances[devVUPDestination] = devTeamShare;
391 		balances[advisoryVUPDestination] = advisoryTeamShare;
392 		balances[udfVUPDestination] = udfShare;
393        
394         // Locked time of approximately 9 months before team members are able to redeeem tokens.
395         uint nineMonths = 9 * 30 days;
396         coreTeamUnlockedAt = now.add(nineMonths);
397         // Locked time of approximately 10 years before team members are able to redeeem tokens.
398         uint lockTime = coldStorageYears;
399         unsoldUnlockedAt = now.add(lockTime);
400 
401 		CreatedVUP(devVUPDestination, devTeamShare);
402 		CreatedVUP(advisoryVUPDestination, advisoryTeamShare);
403 		CreatedVUP(udfVUPDestination, udfShare);
404 
405 	}
406 	function unlock() public onlyOwner{
407 	   require(saleHasEnded);
408        require(now > coreTeamUnlockedAt || now > unsoldUnlockedAt);
409        if (now > coreTeamUnlockedAt) {
410           balances[coreVUPDestination] = coreTeamShare;
411           CreatedVUP(coreVUPDestination, coreTeamShare);
412           balances[cofounderVUPDestination] = cofounderShare;
413           CreatedVUP(cofounderVUPDestination, cofounderShare);
414          
415        }
416        if (now > unsoldUnlockedAt) {
417           uint256 unsoldTokens=PRESALE_ICO_PORTION.sub(totalVUP);
418           require(unsoldTokens > 0);
419           balances[unsoldVUPDestination] = unsoldTokens;
420           CreatedVUP(coreVUPDestination, unsoldTokens);
421          }
422     }
423 
424 	// Allows VuePay to withdraw funds
425 	function withdrawFunds() public onlyOwner {
426 		// Disallow withdraw if the minimum hasn't been reached
427 		require(minCapReached);
428 		require(this.balance > 0);
429 		if(this.balance > 0) {
430 			vuePayETHDestination.transfer(this.balance);
431 		}
432 	}
433 
434 	// Signals that the sale has reached its minimum funding goal
435 	function triggerMinCap() public onlyOwner {
436 		minCapReached = true;
437 	}
438 
439 	// Opens refunding.
440 	function triggerRefund() public onlyOwner{
441 		// No refunds if the sale was successful
442 		require(!saleHasEnded);
443 		// No refunds if minimum cap is hit
444 		require(!minCapReached);
445 		// No refunds if the sale is still progressing
446 	    require(block.number >icoEndBlock);
447 		require(msg.sender == executor);
448 		allowRefund = true;
449 	}
450 
451 	function claimRefund() external {
452 		// No refunds until it is approved
453 		require(allowRefund);
454 		// Nothing to refund
455 		require(ETHContributed[msg.sender]!=0);
456 
457 		// Do the refund.
458 		uint256 etherAmount = ETHContributed[msg.sender];
459 		ETHContributed[msg.sender] = 0;
460 
461 		VUPRefundedForWei(msg.sender, etherAmount);
462 		msg.sender.transfer(etherAmount);
463 	}
464     //Allow changing the Vuepay MultiSig wallet incase of emergency
465 	function changeVuePayETHDestinationAddress(address _newAddress) public onlyOwner {
466 		vuePayETHDestination = _newAddress;
467 	}
468 	
469 	function transfer(address _to, uint _value) public returns (bool) {
470 		// Cannot transfer unless the minimum cap is hit
471 		require(minCapReached);
472 		return super.transfer(_to, _value);
473 	}
474 	
475 	function transferFrom(address _from, address _to, uint _value) public returns (bool) {
476 		// Cannot transfer unless the minimum cap is hit
477 		require(minCapReached);
478 		return super.transferFrom(_from, _to, _value);
479 	}
480 
481 	
482 }