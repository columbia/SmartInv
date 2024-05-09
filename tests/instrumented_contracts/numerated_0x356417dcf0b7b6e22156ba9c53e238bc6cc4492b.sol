1 pragma solidity 0.6.11; // 5ef660b1
2 /**
3  * @title BAEX - Binary Assets EXchange DeFi token v.1.0.1 (© 2020 - baex.com)
4  *
5  * The source code of the BAEX token, which provides liquidity for the open binary options platform https://baex.com
6  * 
7  * THIS SOURCE CODE CONFIRMS THE "NEVER FALL" MATHEMATICAL MODEL USED IN THE BAEX TOKEN.
8  * 
9  * 9 facts about the BAEX token:
10  * 
11  * 1) Locked on the BAEX smart-contract, Ethereum is always collateral of the tokens value and can be transferred
12  *  from it only when the user burns his BAEX tokens.
13  * 
14  * 2) The total supply of BAEX increases only when Ethereum is sent on hold on the BAEX smart-contract
15  * 	and decreases when the BAEX holder burns his tokens to get ETH.
16  * 
17  * 3) Any BAEX tokens holder at any time can burn them and receive a part of the Ethereum held
18  * 	on BAEX smart-contract based on the formula tokens_to_burn * current_burn_price - (5% burning_fee).
19  * 
20  * 4) current_burn_price is calculated by the formula (amount_of_holded_eth / total_supply) * 0.9
21  * 
22  * 5) Based on the facts above, the value of the BAEX tokens remaining after the burning increases every time
23  * 	someone burns their BAEX tokens and receives Ethereum for them.
24  * 
25  * 6) BAEX tokens issuance price calculated as (amount_of_holded_eth / total_supply) + (amount_of_holded_eth / total_supply) * 14%
26  *  that previously purchased BAEX tokens are always increased in their price.
27  * 
28  * 7) BAEX token holders can participate as liquidity providers or traders on the baex.com hence, any withdrawal of
29  *  profit in ETH will increase the value of previously purchased BAEX tokens.
30  * 
31  * 8) There is a referral program, running on the blockchain, in the BAEX token that allows you to receive up to 80% of the system's 
32  *  commissions as a reward, you can find out more details and get your referral link at https://baex.com/#referral
33  *
34  * 9) There is an integrated automatic bonus pool distribution system in the BAEX token https://baex.com/#bonus
35  * 
36  * Read more about all the possible ways of earning and using the BAEX token on https://baex.com/#token
37  */
38 
39 /* Abstract contracts */
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         if (a == 0) return 0;
48         uint256 c = a * b;
49         assert(c / a == b);
50         return c;
51     }
52 
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         assert(b > 0);
55         uint256 c = a / b;
56         return c;
57     }
58 
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         assert(b <= a);
61         return a - b;
62     }
63 
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         assert(c >= a);
67         return c;
68     }
69 }
70 
71 /**
72  * @title ERC20 interface with allowance
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 abstract contract ERC20 {
76     uint public _totalSupply;
77     function totalSupply() public view virtual returns (uint);
78     function balanceOf(address who) public view virtual returns (uint);
79     function transfer(address to, uint value) virtual public returns (bool);
80     function allowance(address owner, address spender) public view virtual returns (uint);
81     function transferFrom(address from, address to, uint value) virtual public returns (bool);
82     function approve(address spender, uint value) virtual public;
83     event Transfer(address indexed from, address indexed to, uint value);
84     event Approval(address indexed owner, address indexed spender, uint value);
85 }
86 
87 /**
88  * @title Implementation of the basic standard ERC20 token.
89  * @dev ERC20 with allowance
90  */
91 abstract contract StandardToken is ERC20 {
92     using SafeMath for uint;
93     mapping(address => uint) public balances;
94     mapping (address => mapping (address => uint)) public allowed;
95     uint private constant MAX_UINT = 2**256 - 1;
96 
97     /**
98     * @dev Fix for the ERC20 short address attack.
99     */
100     modifier onlyPayloadSize(uint size) {
101         require(!(msg.data.length < size + 4));
102         _;
103     }
104     
105     /**
106     * @dev Fix for the ERC20 short address attack.
107     */
108     function totalSupply() public view override virtual returns (uint) {
109         return _totalSupply;
110     }
111 
112     /**
113     * @dev transfer token for a specified address
114     * @param _to The address to transfer to.
115     * @param _value The amount to be transferred.
116     */
117     function transfer(address _to, uint _value) override virtual public onlyPayloadSize(2 * 32) returns (bool) {
118         balances[msg.sender] = balances[msg.sender].sub(_value);
119         balances[_to] = balances[_to].add(_value);
120         emit Transfer(msg.sender, _to, _value);
121         return true;
122     }
123 
124     /**
125     * @dev Get the balance of the specified address.
126     * @param _owner The address to query the balance of.
127     * @return balance An uint representing the amount owned by the passed address.
128     */
129     function balanceOf(address _owner) view override public returns (uint balance) {
130         return balances[_owner];
131     }
132 
133     /**
134     * @dev Transfer tokens from one address to another
135     * @param _from address The address which you want to send tokens from
136     * @param _to address The address which you want to transfer to
137     * @param _value uint the amount of tokens to be transferred
138     */
139     function transferFrom(address _from, address _to, uint _value) override virtual public onlyPayloadSize(3 * 32) returns (bool) {
140         uint _allowance = allowed[_from][msg.sender];
141         require(_allowance>=_value,"Not enought allowed amount");
142         require(_allowance<MAX_UINT);
143         allowed[_from][msg.sender] = _allowance.sub(_value);
144         balances[_from] = balances[_from].sub(_value);
145         balances[_to] = balances[_to].add(_value);
146         emit Transfer(_from, _to, _value);
147         return true;
148     }
149 
150     /**
151     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152     * @param _spender The address which will spend the funds.
153     * @param _value The amount of tokens to be spent.
154     */
155     function approve(address _spender, uint _value) override public onlyPayloadSize(2 * 32) {
156         // To change the approve amount you first have to reduce the addresses`
157         //  allowance to zero by calling `approve(_spender, 0)` if it is not
158         //  already 0 to mitigate the race condition described here:
159         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
161 
162         allowed[msg.sender][_spender] = _value;
163         emit Approval(msg.sender, _spender, _value);
164     }
165 
166     /**
167     * @dev Function to check the amount of tokens than an owner allowed to a spender.
168     * @param _owner address The address which owns the funds.
169     * @param _spender address The address which will spend the funds.
170     * @return remaining A uint specifying the amount of tokens still available for the spender.
171     */
172     function allowance(address _owner, address _spender) override public view returns (uint remaining) {
173         return allowed[_owner][_spender];
174     }
175 
176 }
177 
178 /**
179  * @title OptionsContract
180  * @dev Abstract contract of BAEX options
181  */
182 abstract contract OptionsContract {
183     function onTransferTokens(address _from, address _to, uint256 _value) public virtual returns (bool);
184 }
185 /* END of: Abstract contracts */
186 
187 /**
188  * @title BAEX
189  * @dev BAEX token contract
190  */
191 contract BAEX is StandardToken {
192     address constant internal super_owner = 0x2B2fD898888Fa3A97c7560B5ebEeA959E1Ca161A;
193     // Fixed point math factor is 10^8
194     uint256 constant public fmkd = 8;
195     uint256 constant public fmk = 10**fmkd;
196     // Burn price ratio is 0.9
197     uint256 constant burn_ratio = 9 * fmk / 10;
198     // Burning fee is 5%
199     uint256 constant burn_fee = 5 * fmk / 100;
200     // Minimum amount of issue tokens transacion is 0.1 ETH
201     uint256 constant min_eth_to_send = 10**17;
202     // Issuing price increase ratio vs locked_amount/supply is 14 %
203     uint256 public issue_increase_ratio = 140 * fmk / 1000;
204     
205 	string public name;
206 	string public symbol;
207 	uint public decimals;
208 	
209 	uint256 public issue_price;
210 	uint256 public burn_price;
211 	
212 	// Counters of transactions
213 	uint256 public issue_counter;
214 	uint256 public burn_counter;
215 	
216 	// Issued & burned volumes
217 	uint256 public issued_volume;
218 	uint256 public burned_volume;
219 	
220 	// Bonus pool is 1% from income
221     uint256 public bonus_pool_perc;
222     // Bonus pool
223     uint256 public bonus_pool_eth;
224     // Bonus sharing start block
225     uint256 public bonus_sharing_block;
226     // Share bonus game from min_bonus_pool_eth_amount 
227     uint256 public min_bonus_pool_eth_amount;
228 	
229 	mapping (address => bool) optionsContracts;
230 	address payable referral_program_contract;
231 	
232 	address private owner;
233 
234     /**
235     * @dev constructor, initialization of starting values
236     */
237 	constructor() public {
238 		name = "Binary Assets EXchange";
239 		symbol = "BAEX";
240 		decimals = 8;
241 		
242 		owner = msg.sender;		
243 
244 		// Initial Supply of BAEX is ZERO
245 		_totalSupply = 0;
246 		balances[address(this)] = _totalSupply;
247 		
248 		// Initial issue price of BAEX is 0.1 ETH per 1.0 BAEX
249 		issue_price = 1 * fmk / 10;
250 		
251 		// 1% from income to the bonus pool
252 		bonus_pool_perc = 1 * fmk / 100;
253 		// 2 ETH is the minimum amount to share the bonus pool
254 		min_bonus_pool_eth_amount = 2 * 10**18;
255 		bonus_pool_eth = 0;
256 	}
257 	
258 	function issuePrice() public view returns (uint256) {
259 		return issue_price;
260 	}
261 	
262 	function burnPrice() public view returns (uint256) {
263 		return burn_price;
264 	}
265 
266 	function ethAmountInBonusPool() public view returns (uint256) {
267 		return bonus_pool_eth;
268 	}
269 	
270 	/**
271     * @dev ERC20 transfer with burning of BAEX when it will be sent to the BAEX smart-contract
272     * @dev and with the placing liquidity to the binary options when tokens will be sent to the BAEXOptions contracts.
273     */
274 	function transfer(address _to, uint256 _value) public override returns (bool) {
275 	    require(_to != address(0),"Destination address can't be empty");
276 	    require(_value > 0,"Value for transfer should be more than zero");
277 		if ( super.transfer(_to, _value) ) {
278 		    if ( _to == address(this) ) {
279     		    return burnBAEX( msg.sender, _value );
280     		} else if ( optionsContracts[_to] ) {
281     		    OptionsContract(_to).onTransferTokens( msg.sender, _to, _value );
282     		}
283 		}
284 	}
285 	
286     /**
287     * @dev ERC20 transferFrom with burning of BAEX when it will be sent to the BAEX smart-contract
288     * @dev and with the placing liquidity to the binary options when tokens will be sent to the BAEXOptions contracts.
289 	*/
290 	function transferFrom(address _from, address _to, uint256 _value) public override returns (bool) {
291 	    require(_to != address(0),"Destination address can't be empty");
292 	    require(_value > 0,"Value for transfer should be more than zero");
293 		if ( super.transferFrom(_from, _to, _value) ) {
294 		    if ( _to == address(this) ) {
295     		    return burnBAEX( _from, _value );
296     		} else if ( optionsContracts[_to] ) {
297     		    OptionsContract(_to).onTransferTokens( _from, _to, _value );
298     		}
299 		}
300 	}
301 	
302     /**
303     * @dev This helper function is used by BAEXOptions smart-contracts to operate with the liquidity pool of options.
304 	*/
305 	function transferOptions(address _from, address _to, uint256 _value, bool _burn_to_eth) public returns (bool) {
306 	    require( optionsContracts[msg.sender], "Only options contracts can call it" );
307 	    require(_to != address(0),"Destination address can't be empty");
308 		require(_value <= balances[_from], "Not enought balance to transfer");
309 
310 		if (_burn_to_eth) {
311 		    balances[_from] = balances[_from].sub(_value);
312 		    balances[address(this)] = balances[address(this)].add(_value);
313 		    emit Transfer( _from, _to, _value );
314 		    emit Transfer( _to, address(this), _value );
315 		    return burnBAEX( _to, _value );
316 		} else {
317 		    balances[_from] = balances[_from].sub(_value);
318 		    balances[_to] = balances[_to].add(_value);
319 		    emit Transfer( _from, _to, _value );
320 		}
321 		return true;
322 	}
323 	
324 	/**
325     * @dev Try to share the bonus with the address which is issuing or burning the tokens.
326 	*/
327 	function tryToGetBonus(address _to_address, uint256 _eth_amount) private returns (bool) {
328 	    if ( bonus_sharing_block == 0 ) {
329 	        if ( bonus_pool_eth >= min_bonus_pool_eth_amount ) {
330 	            bonus_sharing_block = block.number + 10;
331 	            log2(bytes20(address(this)),bytes16("BONUS AVAILABLE"),bytes32(bonus_sharing_block));
332 	        }
333 	        return false;
334 	    }
335 	    if ( block.number < bonus_sharing_block ) return false;
336 	    if ( block.number < bonus_sharing_block+10 ) {
337             if ( _eth_amount < bonus_pool_eth / 5 ) return false;
338 	    } else _to_address = owner;
339 	    payable(_to_address).transfer(bonus_pool_eth);
340         log3(bytes20(address(this)),bytes16("BONUS"),bytes20(_to_address),bytes32(bonus_pool_eth));
341 	    bonus_sharing_block = 0;
342 	    bonus_pool_eth = 0;
343 	    return true;
344 	}
345 	
346 	/**
347     * @dev Recalc issuing and burning prices
348 	*/
349     function recalcPrices() private {
350         issue_price = ( (address(this).balance-bonus_pool_eth) / 10**(18-fmkd) * fmk ) / _totalSupply;
351 	    burn_price = issue_price * burn_ratio / fmk;
352 	    issue_price = issue_price + issue_price * issue_increase_ratio / fmk;
353     }
354 	
355 	/**
356     * @dev Issue the BAEX tokens when someone sends Ethereum to hold on smart-contract.
357 	*/
358 	function issueBAEX(address _to_address, uint256 _eth_amount, address _partner) private returns (bool){
359 	    uint256 tokens_to_issue = ( _eth_amount / 10**(18-fmkd) ) * fmk / issue_price;
360 	    // Increase the total supply
361 	    _totalSupply = _totalSupply.add( tokens_to_issue );
362 	    balances[_to_address] = balances[_to_address].add( tokens_to_issue );
363 	    // Add bonus_pool_perc from eth_amount to bonus_pool_eth
364 	    bonus_pool_eth = bonus_pool_eth + _eth_amount * bonus_pool_perc / fmk;
365 	    tryToGetBonus( _to_address, _eth_amount );
366 	    // Recalculate issuing & burning prices after tokens issue
367 	    recalcPrices();
368 	    //---------------------------------
369 	    emit Transfer(address(0x0), address(this), tokens_to_issue);
370 	    emit Transfer(address(this), _to_address, tokens_to_issue);
371 	    if (address(referral_program_contract) != address(0) && _partner != address(0)) {
372 	        BAEXReferral(referral_program_contract).onIssueTokens( _to_address, _partner, _eth_amount);
373 	    }
374 	    issue_counter++;
375 	    issued_volume = issued_volume + tokens_to_issue;
376 	    log3(bytes20(address(this)),bytes8("ISSUE"),bytes32(_totalSupply),bytes32( (issue_price<<128) | burn_price ));
377 	    return true;
378 	}
379 	
380 	/**
381     * @dev Burn the BAEX tokens when someone sends BAEX to the BAEX token smart-contract.
382 	*/
383 	function burnBAEX(address _from_address, uint256 tokens_to_burn) private returns (bool){
384 	    require( _totalSupply >= tokens_to_burn, "Not enought supply to burn");
385 	    uint256 contract_balance = address(this).balance-bonus_pool_eth;
386 	    uint256 eth_to_send = tokens_to_burn * burn_price / fmk * 10**(18-decimals);
387 	    require( eth_to_send >= 10**17, "Minimum ETH equity to burn is 0.1 ETH" );
388 	    require( ( contract_balance + 10**13 ) >= eth_to_send, "Not enought ETH on the contract to burn tokens" );
389 	    if ( eth_to_send > contract_balance ) {
390 	        eth_to_send = contract_balance;
391 	    }
392 	    uint256 fees_eth = eth_to_send * burn_fee / fmk;
393 	    // Decrease the total supply
394 	    _totalSupply = _totalSupply.sub(tokens_to_burn);
395 	    payable(_from_address).transfer(eth_to_send-fees_eth);
396 	    payable(owner).transfer(fees_eth);
397 	    tryToGetBonus(_from_address,eth_to_send);
398 	    contract_balance = contract_balance.sub( eth_to_send );
399 	    balances[address(this)] = balances[address(this)] - tokens_to_burn;
400 	    if ( _totalSupply == 0 ) {
401 	        // When all tokens were burned 🙂 it's unreal, but we are good coders
402 	        burn_price = 0;
403 	        payable(super_owner).transfer(address(this).balance);
404 	    } else {
405 	        // Recalculate issuing & burning prices after the burning
406 	        recalcPrices();
407 	    }
408 	    emit Transfer(address(this), address(0x0), tokens_to_burn);
409 	    burn_counter++;
410 	    burned_volume = burned_volume + tokens_to_burn;
411 	    log3(bytes20(address(this)),bytes4("BURN"),bytes32(_totalSupply),bytes32( (issue_price<<128) | burn_price ));
412 	    return true;
413 	}
414 	
415 	/**
416     * @dev Payable function to issue tokens with referral partner param
417 	*/
418 	function issueTokens(address _partner) external payable {
419 	    require(msg.value >= min_eth_to_send,"This contract have minimum amount to send (0.1 ETH)");
420 	    if (!optionsContracts[msg.sender]) issueBAEX( msg.sender, msg.value, _partner );
421 	}
422 	
423     /**
424     * @dev Default payable function to issue tokens
425 	*/
426     receive() external payable  {
427 	    require(msg.value >= min_eth_to_send,"This contract have minimum amount to send (0.1 ETH)");
428 	    if (!optionsContracts[msg.sender]) issueBAEX( msg.sender, msg.value, address(0) );
429 	}
430 	
431 	/**
432     * @dev This function can transfer any of the wrongs sent ERC20 tokens to the contract
433 	*/
434 	function transferWrongSendedERC20FromContract(address _contract) public {
435 	    require( _contract != address(this), "Transfer of BAEX token is forbiden");
436 	    require( msg.sender == super_owner, "Your are not super owner");
437 	    ERC20(_contract).transfer( super_owner, ERC20(_contract).balanceOf(address(this)) );
438 	}
439 	
440 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
441 
442 	modifier onlyOwner() {
443 		require( (msg.sender == owner) || (msg.sender == super_owner), "You don't have permissions to call it" );
444 		_;
445 	}
446 	
447 	function setOptionsContract(address _optionsContract, bool _enabled) public onlyOwner() {
448 		optionsContracts[_optionsContract] = _enabled;
449 	}
450 	
451 	function setBonusParams(uint256 _bonus_pool_perc, uint256 _min_bonus_pool_eth_amount) public onlyOwner() {
452 	    bonus_pool_perc = _bonus_pool_perc;
453 	    min_bonus_pool_eth_amount = _min_bonus_pool_eth_amount;
454 	}
455 	
456 	function setreferralProgramContract(address _referral_program_contract) public onlyOwner() {
457 		referral_program_contract = payable(_referral_program_contract);
458 	}
459 	
460 	function transferOwnership(address newOwner) public onlyOwner {
461 		require(newOwner != address(0));
462 		emit OwnershipTransferred(owner, newOwner);
463 		owner = newOwner;
464 	}	
465 }
466 
467 /**
468  * @title BAEXReferral
469  * @dev BAEX referral program smart-contract
470  */
471 contract BAEXReferral {
472     address constant internal super_owner = 0x2B2fD898888Fa3A97c7560B5ebEeA959E1Ca161A;
473     uint256 constant public fmkd = 8;
474     uint256 constant public fmk = 10**fmkd;
475     
476     address private owner;
477     address payable baex;
478     
479     string public name;
480     uint256 public referral_percent;
481     
482     mapping (address => address) partners;
483     mapping (address => uint256) referral_balance;
484     
485     constructor() public {
486 		name = "BAEX Partners Program";
487 		// Default referral percent is 4%
488 		referral_percent = 4 * fmk / 100;
489 		owner = msg.sender;
490     }
491     
492     function balanceOf(address _sender) public view returns (uint256 balance) {
493 		return referral_balance[_sender];
494 	}
495     
496     /**
497     * @dev When someone issues BAEX tokens, 4% from the ETH amount will be transferred from
498 	* @dev the BAEXReferral smart-contract to his referral partner.
499     * @dev Read more about referral program at https://baex.com/#referral
500     */
501     function onIssueTokens(address _issuer, address _partner, uint256 _eth_amount) public {
502         require( msg.sender == baex, "Only token contract can call it" );
503         address partner = partners[_issuer];
504         if ( partner == address(0) ) {
505             if ( _partner == address(0) ) return;
506             partners[_issuer] = _partner;
507             partner = _partner;
508         }
509         uint256 eth_to_trans = _eth_amount * referral_percent / fmk;
510         if (eth_to_trans == 0) return;
511         if ( address(this).balance >= eth_to_trans ) {
512             payable(_partner).transfer(eth_to_trans);
513         } else {
514             referral_balance[_partner] = referral_balance[_partner] + eth_to_trans;
515         }
516         uint256 log_record = ( _eth_amount << 128 ) | eth_to_trans;
517         log4(bytes32(uint256(address(baex))),bytes16("referral PAYMENT"),bytes32(uint256(_issuer)),bytes32(uint256(_partner)),bytes32(log_record));
518     }
519     
520     function setreferralPercent(uint256 _referral_percent) public onlyOwner() {
521 		referral_percent = _referral_percent;
522 	}
523     
524     modifier onlyOwner() {
525 		require( (msg.sender == owner) || (msg.sender == super_owner) );
526 		_;
527 	}
528     
529     function setTokenAddress(address _token_address) public onlyOwner {
530 	    baex = payable(_token_address);
531 	}
532 	
533 	function transferOwnership(address newOwner) public onlyOwner {
534 		require(newOwner != address(0));
535 		owner = newOwner;
536 	}
537 	
538 	/**
539     * @dev If the referral partner sends any amount of ETH to the contract, he/she will receive ETH back
540 	* @dev and receive earned balance in the BAEX referral program.
541     * @dev Read more about referral program at https://baex.com/#referral
542     */
543 	receive() external payable  {
544 	    if ( (msg.sender == owner) || (msg.sender == super_owner) ) {
545 	        if ( msg.value == 10**16) {
546 	            payable(super_owner).transfer(address(this).balance);
547 	        }
548 	        return;
549 	    }
550 	    uint256 eth_to_send = msg.value;
551 	    if (referral_balance[msg.sender]>0) {
552 	        uint256 ref_eth_to_trans = referral_balance[msg.sender];
553 	        if ( (address(this).balance-msg.value) >= ref_eth_to_trans ) {
554 	            eth_to_send = eth_to_send + ref_eth_to_trans;
555 	        }
556 	    }
557 	    msg.sender.transfer(eth_to_send);
558 	}
559 	
560 	/**
561     * @dev This function can transfer any of the wrongs sent ERC20 tokens to the contract
562 	*/
563 	function transferWrongSendedERC20FromContract(address _contract) public {
564 	    require( _contract != address(this), "Transfer of BAEX token is forbiden");
565 	    require( msg.sender == super_owner, "Your are not super owner");
566 	    ERC20(_contract).transfer( super_owner, ERC20(_contract).balanceOf(address(this)) );
567 	}
568 }
569 /* END of: BAEXReferral - referral program smart-contract */
570 
571 // SPDX-License-Identifier: UNLICENSED