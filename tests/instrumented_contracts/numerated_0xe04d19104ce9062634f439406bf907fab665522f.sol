1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5 
6 
7   /**
8 
9   * @dev Multiplies two numbers, throws on overflow.
10 
11   */
12 
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14 
15     if (a == 0) {
16 
17       return 0;
18 
19     }
20 
21     uint256 c = a * b;
22 
23     require(c / a == b);
24 
25     return c;
26 
27   }
28 
29 
30 
31   /**
32 
33   * @dev Integer division of two numbers, truncating the quotient.
34 
35   */
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38 
39     require(b > 0); // Solidity automatically throws when dividing by 0
40 
41     uint256 c = a / b;
42 
43     return c;
44 
45   }
46 
47 
48 
49   /**
50 
51   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52 
53   */
54 
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56 
57     require(b <= a);
58 
59     return a - b;
60 
61   }
62 
63 
64 
65   /**
66 
67   * @dev Adds two numbers, throws on overflow.
68 
69   */
70 
71   function add(uint256 a, uint256 b) internal pure returns (uint256) {
72 
73     uint256 c = a + b;
74 
75     require(c >= a);
76 
77     return c;
78 
79   }
80 
81 }
82 
83 contract ERC20Basic {
84   function totalSupply() public view returns (uint256);
85   function balanceOf(address who) public view returns (uint256);
86   function transfer(address to, uint256 value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 contract ERC20 is ERC20Basic {
91   function allowance(address owner, address spender)
92     public view returns (uint256);
93 
94   function transferFrom(address from, address to, uint256 value)
95     public returns (bool);
96 
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(
99     address indexed owner,
100     address indexed spender,
101     uint256 value
102   );
103 }
104 
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   uint256 totalSupply_;
111 
112   /**
113   * @dev total number of tokens in existence
114   */
115   function totalSupply() public view returns (uint256) {
116     return totalSupply_;
117   }
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[msg.sender]);
127 
128     balances[msg.sender] = balances[msg.sender].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     emit Transfer(msg.sender, _to, _value);
131     return true;
132   }
133 
134   /**
135   * @dev Gets the balance of the specified address.
136   * @param _owner The address to query the the balance of.
137   * @return An uint256 representing the amount owned by the passed address.
138   */
139   function balanceOf(address _owner) public view returns (uint256) {
140     return balances[_owner];
141   }
142 
143 }
144 
145 contract Ownable 
146 
147 {
148 
149   address public owner;
150 
151  
152 
153   constructor(address _owner) public 
154 
155   {
156 
157     owner = _owner;
158 
159   }
160 
161  
162 
163   modifier onlyOwner() 
164 
165   {
166 
167     require(msg.sender == owner);
168 
169     _;
170 
171   }
172 
173  
174 
175   function transferOwnership(address newOwner) onlyOwner 
176 
177   {
178 
179     require(newOwner != address(0));      
180 
181     owner = newOwner;
182 
183   }
184 
185 }
186 
187 contract StandardToken is ERC20, BasicToken {
188 
189   mapping (address => mapping (address => uint256)) internal allowed;
190 
191 
192   /**
193    * @dev Transfer tokens from one address to another
194    * @param _from address The address which you want to send tokens from
195    * @param _to address The address which you want to transfer to
196    * @param _value uint256 the amount of tokens to be transferred
197    */
198   function transferFrom(
199     address _from,
200     address _to,
201     uint256 _value
202   )
203     public
204     returns (bool)
205   {
206     require(_to != address(0));
207     require(_value <= balances[_from]);
208     require(_value <= allowed[_from][msg.sender]);
209 
210     balances[_from] = balances[_from].sub(_value);
211     balances[_to] = balances[_to].add(_value);
212     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
213     emit Transfer(_from, _to, _value);
214     return true;
215   }
216 
217   /**
218    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
219    *
220    * Beware that changing an allowance with this method brings the risk that someone may use both the old
221    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
222    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
223    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
224    * @param _spender The address which will spend the funds.
225    * @param _value The amount of tokens to be spent.
226    */
227   function approve(address _spender, uint256 _value) public returns (bool) {
228     allowed[msg.sender][_spender] = _value;
229     emit Approval(msg.sender, _spender, _value);
230     return true;
231   }
232 
233   /**
234    * @dev Function to check the amount of tokens that an owner allowed to a spender.
235    * @param _owner address The address which owns the funds.
236    * @param _spender address The address which will spend the funds.
237    * @return A uint256 specifying the amount of tokens still available for the spender.
238    */
239   function allowance(
240     address _owner,
241     address _spender
242    )
243     public
244     view
245     returns (uint256)
246   {
247     return allowed[_owner][_spender];
248   }
249 
250   /**
251    * @dev Increase the amount of tokens that an owner allowed to a spender.
252    *
253    * approve should be called when allowed[_spender] == 0. To increment
254    * allowed value is better to use this function to avoid 2 calls (and wait until
255    * the first transaction is mined)
256    * From MonolithDAO Token.sol
257    * @param _spender The address which will spend the funds.
258    * @param _addedValue The amount of tokens to increase the allowance by.
259    */
260   function increaseApproval(
261     address _spender,
262     uint _addedValue
263   )
264     public
265     returns (bool)
266   {
267     allowed[msg.sender][_spender] = (
268       allowed[msg.sender][_spender].add(_addedValue));
269     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273   /**
274    * @dev Decrease the amount of tokens that an owner allowed to a spender.
275    *
276    * approve should be called when allowed[_spender] == 0. To decrement
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    * @param _spender The address which will spend the funds.
281    * @param _subtractedValue The amount of tokens to decrease the allowance by.
282    */
283   function decreaseApproval(
284     address _spender,
285     uint _subtractedValue
286   )
287     public
288     returns (bool)
289   {
290     uint oldValue = allowed[msg.sender][_spender];
291     if (_subtractedValue > oldValue) {
292       allowed[msg.sender][_spender] = 0;
293     } else {
294       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
295     }
296     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297     return true;
298   }
299 
300 }
301 
302 contract BiLinkToken is StandardToken, Ownable {
303 	string public name = "BiLink"; 
304 	string public symbol = "BLK";
305 	uint256 public decimals = 18;
306 	uint256 public INITIAL_SUPPLY = 10000 * 10000 * (10 ** decimals);
307 	bool public mintingFinished = false;
308 	uint256 public totalMintableAmount;
309 
310 	address public contractBalance;
311 
312 	address public accountFoundation;
313 	address public accountCompany;
314 	address public accountPartnerBase;
315 	mapping (address => uint256) public lockedAccount2WithdrawTap;
316 	mapping (address => uint256) public lockedAccount2WithdrawedAmount;
317 	uint256 public lockStartTime;
318 	uint256 public lockEndTime;
319 	uint256 public releaseEndTime;
320 	uint256 public tapOfOne;
321 	uint256 public amountMinted;
322 	uint256 public lockTimeSpan;
323 
324 	address[] public accountsCanShareProfit;//balance > 10000 * (10 ** decimals)
325 	uint256 public amountMinCanShareProfit;
326 
327 	event Burn(address indexed burner, uint256 value);
328 	event Mint(address indexed to, uint256 amount);
329 	event MintFinished();
330 
331 	constructor(address _owner, address _accountFoundation, address _accountCompany, address _accountPartnerBase) public 
332 		Ownable(_owner)
333 	{
334 		totalSupply_ = INITIAL_SUPPLY* 70/ 100;
335 		accountFoundation= _accountFoundation;
336 		accountCompany= _accountCompany;
337 		accountPartnerBase= _accountPartnerBase;
338 
339 		lockStartTime= now;
340 		lockTimeSpan= 1 * 365 * 24 * 3600;
341 		lockEndTime= now+ lockTimeSpan;
342 		releaseEndTime= now+ 2 * lockTimeSpan;
343 
344 		balances[accountCompany]= INITIAL_SUPPLY* 40/ 100;
345 		balances[accountFoundation]= INITIAL_SUPPLY* 10/ 100;
346 		balances[accountPartnerBase]= INITIAL_SUPPLY* 20/ 100;
347 
348 		tapOfOne= (10 ** decimals)/ (lockTimeSpan);
349 		lockedAccount2WithdrawTap[accountCompany]= tapOfOne.mul(balances[accountCompany]);
350 		lockedAccount2WithdrawTap[accountPartnerBase]= tapOfOne.mul(balances[accountPartnerBase]);
351 
352 		accountsCanShareProfit.push(accountCompany);
353 		accountsCanShareProfit.push(accountFoundation);
354 		accountsCanShareProfit.push(accountPartnerBase);
355 
356 		amountMinCanShareProfit= 10000 * (10 ** decimals);
357 		totalMintableAmount= INITIAL_SUPPLY * 30/ 100;
358 	}
359 
360 	function setMintAndBurnOwner (address _contractBalance) public onlyOwner {
361 		contractBalance= _contractBalance;
362 	}
363 
364 	function burn(uint256 _amount) public {
365 		require(msg.sender== contractBalance);
366 		require(_amount <= balances[msg.sender]);
367 
368 		balances[msg.sender] = balances[msg.sender].sub(_amount);
369 		totalSupply_ = totalSupply_.sub(_amount);
370 		emit Burn(msg.sender, _amount);
371 		emit Transfer(msg.sender, address(0), _amount);
372 	}
373 
374 	function transferToPartnerAccount(address _partner, uint256 _amount) onlyOwner {
375 		require(balances[accountPartnerBase].sub(_amount) > 0);
376 
377 		balances[_partner]= balances[_partner].add(_amount);
378 		balances[accountPartnerBase]= balances[accountPartnerBase].sub(_amount);
379 
380 		lockedAccount2WithdrawTap[_partner]= tapOfOne.mul(balances[_partner]);
381 
382 		if(balances[_partner].sub(_amount) < amountMinCanShareProfit&& balances[_partner] >= amountMinCanShareProfit)
383 			accountsCanShareProfit.push(_partner);
384 	}
385 
386 	modifier canMint() {
387 		require(!mintingFinished);
388 		_;
389 	}
390 
391 	modifier hasMintPermission() {
392 		require(msg.sender == contractBalance);
393 		_;
394 	}
395 
396 	modifier canTransfer(address _from, address _to, uint256 _value)  {
397         require(_from != accountFoundation&& (lockedAccount2WithdrawTap[_from] <= 0 || now >= releaseEndTime || (now >= lockEndTime && _value <= (lockedAccount2WithdrawTap[_from].mul(now.sub(lockStartTime))).sub(lockedAccount2WithdrawedAmount[_from]))));
398         _;
399     }
400 
401 	function mintFinished() public constant returns (bool) {
402 		return mintingFinished;
403 	}
404 
405 	function mint(address _to, uint256 _amount)
406 		hasMintPermission
407 		canMint
408 		public
409 		returns (bool)
410 	{
411 		uint256 _actualMintAmount= _amount.mul(totalMintableAmount- amountMinted).div(totalMintableAmount);
412 		if(amountMinted.add(_actualMintAmount) > totalMintableAmount) {
413 			finishMinting();
414 			return false;
415 		}
416 		else {
417 			amountMinted= amountMinted.add(_actualMintAmount);
418 			totalSupply_ = totalSupply_.add(_actualMintAmount);
419 			balances[_to] = balances[_to].add(_actualMintAmount);
420 
421 			emit Mint(_to, _actualMintAmount);
422 			emit Transfer(address(0), _to, _actualMintAmount);
423 			return true;
424 		}
425 	}
426 
427 	function finishMinting() canMint private returns (bool) {
428 		mintingFinished = true;
429 		emit MintFinished();
430 		return true;
431 	}
432 
433 	function preTransfer(address _from, address _to, uint256 _value) private {
434 		if(lockedAccount2WithdrawTap[_from] > 0)
435 			lockedAccount2WithdrawedAmount[_from]= lockedAccount2WithdrawedAmount[_from].add(_value);
436 
437 		if(balances[_from] >= amountMinCanShareProfit && balances[_from].sub(_value) < amountMinCanShareProfit) {
438 			for(uint256 i= 0; i< accountsCanShareProfit.length; i++) {
439 
440 				if(accountsCanShareProfit[i]== _from) {
441 
442 					if(i< accountsCanShareProfit.length- 1&& accountsCanShareProfit.length> 1)
443 
444 						accountsCanShareProfit[i]= accountsCanShareProfit[accountsCanShareProfit.length- 1];
445 
446 					delete accountsCanShareProfit[accountsCanShareProfit.length- 1];
447 
448 					accountsCanShareProfit.length--;
449 
450 					break;
451 
452 				}
453 
454 			}
455 		}
456 
457 		if(balances[_to] < amountMinCanShareProfit&& balances[_to].add(_value) >= amountMinCanShareProfit) {
458 			accountsCanShareProfit.push(_to);
459 		}
460 	}
461 
462 	function transfer(address _to, uint256 _value) public canTransfer(msg.sender, _to, _value) returns (bool) {
463 		preTransfer(msg.sender, _to, _value);
464 
465         return super.transfer(_to, _value);
466     }
467 
468     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from, _to, _value) returns (bool) {
469 		preTransfer(_from, _to, _value);
470 
471         return super.transferFrom(_from, _to, _value);
472     }
473 
474     function approve(address _spender, uint256 _value) public canTransfer(msg.sender, _spender, _value) returns (bool) {
475         return super.approve(_spender,_value);
476     }
477 
478 	function getCanShareProfitAccounts() public constant returns (address[]) {
479 		return accountsCanShareProfit;
480 	}
481 }