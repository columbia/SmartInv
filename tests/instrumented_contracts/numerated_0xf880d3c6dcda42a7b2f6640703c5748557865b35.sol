1 pragma solidity ^0.4.24;
2 
3 // File: contracts/badERC20Fix.sol
4 
5 /*
6 
7 badERC20 POC Fix by SECBIT Team
8 
9 USE WITH CAUTION & NO WARRANTY
10 
11 REFERENCE & RELATED READING
12 - https://github.com/ethereum/solidity/issues/4116
13 - https://medium.com/@chris_77367/explaining-unexpected-reverts-starting-with-solidity-0-4-22-3ada6e82308c
14 - https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
15 - https://gist.github.com/BrendanChou/88a2eeb80947ff00bcf58ffdafeaeb61
16 
17 */
18 
19 pragma solidity ^0.4.24;
20 
21 library ERC20AsmFn {
22 
23     function isContract(address addr) internal {
24         assembly {
25             if iszero(extcodesize(addr)) { revert(0, 0) }
26         }
27     }
28 
29     function handleReturnData() internal returns (bool result) {
30         assembly {
31             switch returndatasize()
32             case 0 { // not a std erc20
33                 result := 1
34             }
35             case 32 { // std erc20
36                 returndatacopy(0, 0, 32)
37                 result := mload(0)
38             }
39             default { // anything else, should revert for safety
40                 revert(0, 0)
41             }
42         }
43     }
44 
45     function asmTransfer(address _erc20Addr, address _to, uint256 _value) internal returns (bool result) {
46 
47         // Must be a contract addr first!
48         isContract(_erc20Addr);
49 
50         // call return false when something wrong
51         require(_erc20Addr.call(bytes4(keccak256("transfer(address,uint256)")), _to, _value));
52 
53         // handle returndata
54         return handleReturnData();
55     }
56 
57     function asmTransferFrom(address _erc20Addr, address _from, address _to, uint256 _value) internal returns (bool result) {
58 
59         // Must be a contract addr first!
60         isContract(_erc20Addr);
61 
62         // call return false when something wrong
63         require(_erc20Addr.call(bytes4(keccak256("transferFrom(address,address,uint256)")), _from, _to, _value));
64 
65         // handle returndata
66         return handleReturnData();
67     }
68 
69     function asmApprove(address _erc20Addr, address _spender, uint256 _value) internal returns (bool result) {
70 
71         // Must be a contract addr first!
72         isContract(_erc20Addr);
73 
74         // call return false when something wrong
75         require(_erc20Addr.call(bytes4(keccak256("approve(address,uint256)")), _spender, _value));
76 
77         // handle returndata
78         return handleReturnData();
79     }
80 }
81 
82 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
83 
84 /**
85  * @title SafeMath
86  * @dev Math operations with safety checks that throw on error
87  */
88 library SafeMath {
89 
90   /**
91   * @dev Multiplies two numbers, throws on overflow.
92   */
93   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
94     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
95     // benefit is lost if 'b' is also tested.
96     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
97     if (_a == 0) {
98       return 0;
99     }
100 
101     c = _a * _b;
102     assert(c / _a == _b);
103     return c;
104   }
105 
106   /**
107   * @dev Integer division of two numbers, truncating the quotient.
108   */
109   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
110     // assert(_b > 0); // Solidity automatically throws when dividing by 0
111     // uint256 c = _a / _b;
112     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
113     return _a / _b;
114   }
115 
116   /**
117   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
118   */
119   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
120     assert(_b <= _a);
121     return _a - _b;
122   }
123 
124   /**
125   * @dev Adds two numbers, throws on overflow.
126   */
127   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
128     c = _a + _b;
129     assert(c >= _a);
130     return c;
131   }
132 }
133 
134 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
135 
136 /**
137  * @title ERC20Basic
138  * @dev Simpler version of ERC20 interface
139  * See https://github.com/ethereum/EIPs/issues/179
140  */
141 contract ERC20Basic {
142   function totalSupply() public view returns (uint256);
143   function balanceOf(address _who) public view returns (uint256);
144   function transfer(address _to, uint256 _value) public returns (bool);
145   event Transfer(address indexed from, address indexed to, uint256 value);
146 }
147 
148 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
149 
150 /**
151  * @title Basic token
152  * @dev Basic version of StandardToken, with no allowances.
153  */
154 contract BasicToken is ERC20Basic {
155   using SafeMath for uint256;
156 
157   mapping(address => uint256) internal balances;
158 
159   uint256 internal totalSupply_;
160 
161   /**
162   * @dev Total number of tokens in existence
163   */
164   function totalSupply() public view returns (uint256) {
165     return totalSupply_;
166   }
167 
168   /**
169   * @dev Transfer token for a specified address
170   * @param _to The address to transfer to.
171   * @param _value The amount to be transferred.
172   */
173   function transfer(address _to, uint256 _value) public returns (bool) {
174     require(_value <= balances[msg.sender]);
175     require(_to != address(0));
176 
177     balances[msg.sender] = balances[msg.sender].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     emit Transfer(msg.sender, _to, _value);
180     return true;
181   }
182 
183   /**
184   * @dev Gets the balance of the specified address.
185   * @param _owner The address to query the the balance of.
186   * @return An uint256 representing the amount owned by the passed address.
187   */
188   function balanceOf(address _owner) public view returns (uint256) {
189     return balances[_owner];
190   }
191 
192 }
193 
194 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
195 
196 /**
197  * @title ERC20 interface
198  * @dev see https://github.com/ethereum/EIPs/issues/20
199  */
200 contract ERC20 is ERC20Basic {
201   function allowance(address _owner, address _spender)
202     public view returns (uint256);
203 
204   function transferFrom(address _from, address _to, uint256 _value)
205     public returns (bool);
206 
207   function approve(address _spender, uint256 _value) public returns (bool);
208   event Approval(
209     address indexed owner,
210     address indexed spender,
211     uint256 value
212   );
213 }
214 
215 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
216 
217 /**
218  * @title Standard ERC20 token
219  *
220  * @dev Implementation of the basic standard token.
221  * https://github.com/ethereum/EIPs/issues/20
222  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
223  */
224 contract StandardToken is ERC20, BasicToken {
225 
226   mapping (address => mapping (address => uint256)) internal allowed;
227 
228 
229   /**
230    * @dev Transfer tokens from one address to another
231    * @param _from address The address which you want to send tokens from
232    * @param _to address The address which you want to transfer to
233    * @param _value uint256 the amount of tokens to be transferred
234    */
235   function transferFrom(
236     address _from,
237     address _to,
238     uint256 _value
239   )
240     public
241     returns (bool)
242   {
243     require(_value <= balances[_from]);
244     require(_value <= allowed[_from][msg.sender]);
245     require(_to != address(0));
246 
247     balances[_from] = balances[_from].sub(_value);
248     balances[_to] = balances[_to].add(_value);
249     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
250     emit Transfer(_from, _to, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
256    * Beware that changing an allowance with this method brings the risk that someone may use both the old
257    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
258    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
259    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260    * @param _spender The address which will spend the funds.
261    * @param _value The amount of tokens to be spent.
262    */
263   function approve(address _spender, uint256 _value) public returns (bool) {
264     allowed[msg.sender][_spender] = _value;
265     emit Approval(msg.sender, _spender, _value);
266     return true;
267   }
268 
269   /**
270    * @dev Function to check the amount of tokens that an owner allowed to a spender.
271    * @param _owner address The address which owns the funds.
272    * @param _spender address The address which will spend the funds.
273    * @return A uint256 specifying the amount of tokens still available for the spender.
274    */
275   function allowance(
276     address _owner,
277     address _spender
278    )
279     public
280     view
281     returns (uint256)
282   {
283     return allowed[_owner][_spender];
284   }
285 
286   /**
287    * @dev Increase the amount of tokens that an owner allowed to a spender.
288    * approve should be called when allowed[_spender] == 0. To increment
289    * allowed value is better to use this function to avoid 2 calls (and wait until
290    * the first transaction is mined)
291    * From MonolithDAO Token.sol
292    * @param _spender The address which will spend the funds.
293    * @param _addedValue The amount of tokens to increase the allowance by.
294    */
295   function increaseApproval(
296     address _spender,
297     uint256 _addedValue
298   )
299     public
300     returns (bool)
301   {
302     allowed[msg.sender][_spender] = (
303       allowed[msg.sender][_spender].add(_addedValue));
304     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305     return true;
306   }
307 
308   /**
309    * @dev Decrease the amount of tokens that an owner allowed to a spender.
310    * approve should be called when allowed[_spender] == 0. To decrement
311    * allowed value is better to use this function to avoid 2 calls (and wait until
312    * the first transaction is mined)
313    * From MonolithDAO Token.sol
314    * @param _spender The address which will spend the funds.
315    * @param _subtractedValue The amount of tokens to decrease the allowance by.
316    */
317   function decreaseApproval(
318     address _spender,
319     uint256 _subtractedValue
320   )
321     public
322     returns (bool)
323   {
324     uint256 oldValue = allowed[msg.sender][_spender];
325     if (_subtractedValue >= oldValue) {
326       allowed[msg.sender][_spender] = 0;
327     } else {
328       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
329     }
330     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
331     return true;
332   }
333 
334 }
335 
336 // File: contracts/FUTC.sol
337 
338 /**
339  * Holders of FUTC can claim tokens fed to it using the claimTokens()
340  * function. This contract will be fed several tokens automatically by other Futereum
341  * contracts.
342  */
343 contract FUTC1 is StandardToken {
344   using SafeMath for uint;
345   using ERC20AsmFn for ERC20;
346 
347   string public constant name = "Futereum Centurian 1";
348   string public constant symbol = "FUTC1";
349   uint8 public constant decimals = 0;
350 
351   address public admin;
352   uint public totalEthReleased = 0;
353 
354   mapping(address => uint) public ethReleased;
355   address[] public trackedTokens;
356   mapping(address => bool) public isTokenTracked;
357   mapping(address => uint) public totalTokensReleased;
358   mapping(address => mapping(address => uint)) public tokensReleased;
359 
360   constructor() public {
361     admin = msg.sender;
362     totalSupply_ = 100000;
363     balances[admin] = totalSupply_;
364     emit Transfer(address(0), admin, totalSupply_);
365   }
366 
367   function () public payable {}
368 
369   modifier onlyAdmin() {
370     require(msg.sender == admin);
371     _;
372   }
373 
374   function changeAdmin(address _receiver) onlyAdmin external {
375     admin = _receiver;
376   }
377 
378   /**
379    * Claim your eth.
380    */
381   function claimEth() public {
382     claimEthFor(msg.sender);
383   }
384 
385   // Claim eth for address
386   function claimEthFor(address payee) public {
387     require(balances[payee] > 0);
388 
389     uint totalReceived = address(this).balance.add(totalEthReleased);
390     uint payment = totalReceived.mul(
391       balances[payee]).div(
392         totalSupply_).sub(
393           ethReleased[payee]
394     );
395 
396     require(payment != 0);
397     require(address(this).balance >= payment);
398 
399     ethReleased[payee] = ethReleased[payee].add(payment);
400     totalEthReleased = totalEthReleased.add(payment);
401 
402     payee.transfer(payment);
403   }
404 
405   // Claim your tokens
406   function claimMyTokens() external {
407     claimTokensFor(msg.sender);
408   }
409 
410   // Claim on behalf of payee address
411   function claimTokensFor(address payee) public {
412     require(balances[payee] > 0);
413 
414     for (uint16 i = 0; i < trackedTokens.length; i++) {
415       claimToken(trackedTokens[i], payee);
416     }
417   }
418 
419   /**
420    * Transfers the unclaimed token amount for the given token and address
421    * @param _tokenAddr The address of the ERC20 token
422    * @param _payee The address of the payee (FUTC holder)
423    */
424   function claimToken(address _tokenAddr, address _payee) public {
425     require(balances[_payee] > 0);
426     require(isTokenTracked[_tokenAddr]);
427 
428     uint payment = getUnclaimedTokenAmount(_tokenAddr, _payee);
429     if (payment == 0) {
430       return;
431     }
432 
433     ERC20 Token = ERC20(_tokenAddr);
434     require(Token.balanceOf(address(this)) >= payment);
435     tokensReleased[address(Token)][_payee] = tokensReleased[address(Token)][_payee].add(payment);
436     totalTokensReleased[address(Token)] = totalTokensReleased[address(Token)].add(payment);
437     Token.asmTransfer(_payee, payment);
438   }
439 
440   /**
441    * Returns the amount of a token (tokenAddr) that payee can claim
442    * @param tokenAddr The address of the ERC20 token
443    * @param payee The address of the payee
444    */
445   function getUnclaimedTokenAmount(address tokenAddr, address payee) public view returns (uint) {
446     ERC20 Token = ERC20(tokenAddr);
447     uint totalReceived = Token.balanceOf(address(this)).add(totalTokensReleased[address(Token)]);
448     uint payment = totalReceived.mul(
449       balances[payee]).div(
450         totalSupply_).sub(
451           tokensReleased[address(Token)][payee]
452     );
453     return payment;
454   }
455 
456   function transfer(address _to, uint256 _value) public returns (bool) {
457     require(msg.sender != _to);
458     uint startingBalance = balances[msg.sender];
459     require(super.transfer(_to, _value));
460 
461     transferChecks(msg.sender, _to, _value, startingBalance);
462     return true;
463   }
464 
465   function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
466     require(_from != _to);
467     uint startingBalance = balances[_from];
468     require(super.transferFrom(_from, _to, _value));
469 
470     transferChecks(_from, _to, _value, startingBalance);
471     return true;
472   }
473 
474   function transferChecks(address from, address to, uint checks, uint startingBalance) internal {
475 
476     // proportional amount of eth released already
477     uint claimedEth = ethReleased[from].mul(
478       checks).div(
479         startingBalance
480     );
481 
482     // increment to's released eth
483     ethReleased[to] = ethReleased[to].add(claimedEth);
484 
485     // decrement from's released eth
486     ethReleased[from] = ethReleased[from].sub(claimedEth);
487 
488     for (uint16 i = 0; i < trackedTokens.length; i++) {
489       address tokenAddr = trackedTokens[i];
490 
491       // proportional amount of token released already
492       uint claimed = tokensReleased[tokenAddr][from].mul(
493         checks).div(
494           startingBalance
495       );
496 
497       // increment to's released token
498       tokensReleased[tokenAddr][to] = tokensReleased[tokenAddr][to].add(claimed);
499 
500       // decrement from's released token
501       tokensReleased[tokenAddr][from] = tokensReleased[tokenAddr][from].sub(claimed);
502     }
503   }
504 
505   function trackToken(address _addr) onlyAdmin external {
506     require(_addr != address(0));
507     require(!isTokenTracked[_addr]);
508     trackedTokens.push(_addr);
509     isTokenTracked[_addr] = true;
510   }
511 
512   /*
513    * However unlikely, it is possible that the number of tracked tokens
514    * reaches the point that would make the gas cost of transferring FUTC
515    * exceed the block gas limit. This function allows the admin to remove
516    * a token from the tracked token list thus reducing the number of loops
517    * required in transferChecks, lowering the gas cost of transfer. The
518    * remaining balance of this token is sent back to the token's contract.
519    *
520    * Removal is irreversible.
521    *
522    * @param _addr The address of the ERC token to untrack
523    * @param _position The index of the _addr in the trackedTokens array.
524    * Use web3 to cycle through and find the index position.
525    */
526   function unTrackToken(address _addr, uint16 _position) onlyAdmin external {
527     require(isTokenTracked[_addr]);
528     require(trackedTokens[_position] == _addr);
529 
530     ERC20(_addr).asmTransfer(_addr, ERC20(_addr).balanceOf(address(this)));
531     trackedTokens[_position] = trackedTokens[trackedTokens.length-1];
532     delete trackedTokens[trackedTokens.length-1];
533     trackedTokens.length--;
534   }
535 }