1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
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
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (a == 0) {
29       return 0;
30     }
31 
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) balances;
74 
75   uint256 totalSupply_;
76 
77   /**
78   * @dev Total number of tokens in existence
79   */
80   function totalSupply() public view returns (uint256) {
81     return totalSupply_;
82   }
83 
84   /**
85   * @dev Transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     emit Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of.
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) public view returns (uint256) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 contract ERC20 is ERC20Basic {
111  function allowance(address owner, address spender)
112    public view returns (uint256);
113 
114  function transferFrom(address from, address to, uint256 value)
115    public returns (bool);
116 
117  function approve(address spender, uint256 value) public returns (bool);
118  event Approval(
119    address indexed owner,
120    address indexed spender,
121    uint256 value
122  );
123 }
124 
125 
126 
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implementation of the basic standard token.
131  * https://github.com/ethereum/EIPs/issues/20
132  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136   mapping (address => mapping (address => uint256)) internal allowed;
137 
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(
146     address _from,
147     address _to,
148     uint256 _value
149   )
150     public
151     returns (bool)
152   {
153     require(_to != address(0));
154     require(_value <= balances[_from]);
155     require(_value <= allowed[_from][msg.sender]);
156 
157     balances[_from] = balances[_from].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
160     emit Transfer(_from, _to, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166    * Beware that changing an allowance with this method brings the risk that someone may use both the old
167    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170    * @param _spender The address which will spend the funds.
171    * @param _value The amount of tokens to be spent.
172    */
173   function approve(address _spender, uint256 _value) public returns (bool) {
174     allowed[msg.sender][_spender] = _value;
175     emit Approval(msg.sender, _spender, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Function to check the amount of tokens that an owner allowed to a spender.
181    * @param _owner address The address which owns the funds.
182    * @param _spender address The address which will spend the funds.
183    * @return A uint256 specifying the amount of tokens still available for the spender.
184    */
185   function allowance(
186     address _owner,
187     address _spender
188    )
189     public
190     view
191     returns (uint256)
192   {
193     return allowed[_owner][_spender];
194   }
195 
196   /**
197    * @dev Increase the amount of tokens that an owner allowed to a spender.
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _addedValue The amount of tokens to increase the allowance by.
204    */
205   function increaseApproval(
206     address _spender,
207     uint256 _addedValue
208   )
209     public
210     returns (bool)
211   {
212     allowed[msg.sender][_spender] = (
213       allowed[msg.sender][_spender].add(_addedValue));
214     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218   /**
219    * @dev Decrease the amount of tokens that an owner allowed to a spender.
220    * approve should be called when allowed[_spender] == 0. To decrement
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * From MonolithDAO Token.sol
224    * @param _spender The address which will spend the funds.
225    * @param _subtractedValue The amount of tokens to decrease the allowance by.
226    */
227   function decreaseApproval(
228     address _spender,
229     uint256 _subtractedValue
230   )
231     public
232     returns (bool)
233   {
234     uint256 oldValue = allowed[msg.sender][_spender];
235     if (_subtractedValue > oldValue) {
236       allowed[msg.sender][_spender] = 0;
237     } else {
238       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
239     }
240     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241     return true;
242   }
243 
244 }
245 
246 contract Ownable {
247   address public owner;
248 
249 
250   event OwnershipRenounced(address indexed previousOwner);
251   event OwnershipTransferred(
252     address indexed previousOwner,
253     address indexed newOwner
254   );
255 
256 
257   /**
258    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
259    * account.
260    */
261   constructor() public {
262     owner = msg.sender;
263   }
264 
265   /**
266    * @dev Throws if called by any account other than the owner.
267    */
268   modifier onlyOwner() {
269     require(msg.sender == owner);
270     _;
271   }
272 
273   /**
274    * @dev Allows the current owner to relinquish control of the contract.
275    * @notice Renouncing to ownership will leave the contract without an owner.
276    * It will not be possible to call the functions with the `onlyOwner`
277    * modifier anymore.
278    */
279   function renounceOwnership() public onlyOwner {
280     emit OwnershipRenounced(owner);
281     owner = address(0);
282   }
283 
284   /**
285    * @dev Allows the current owner to transfer control of the contract to a newOwner.
286    * @param _newOwner The address to transfer ownership to.
287    */
288   function transferOwnership(address _newOwner) public onlyOwner {
289     _transferOwnership(_newOwner);
290   }
291 
292   /**
293    * @dev Transfers control of the contract to a newOwner.
294    * @param _newOwner The address to transfer ownership to.
295    */
296   function _transferOwnership(address _newOwner) internal {
297     require(_newOwner != address(0));
298     emit OwnershipTransferred(owner, _newOwner);
299     owner = _newOwner;
300   }
301 }
302 
303 /**
304  * @title Mintable token
305  * @dev Simple ERC20 Token example, with mintable token creation
306  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
307  */
308 contract MintableToken is StandardToken, Ownable {
309   event Mint(address indexed to, uint256 amount);
310   event MintFinished();
311 
312   bool public mintingFinished = false;
313 
314 
315   modifier canMint() {
316     require(!mintingFinished);
317     _;
318   }
319 
320   modifier hasMintPermission() {
321     require(msg.sender == owner);
322     _;
323   }
324 
325   /**
326    * @dev Function to mint tokens
327    * @param _to The address that will receive the minted tokens.
328    * @param _amount The amount of tokens to mint.
329    * @return A boolean that indicates if the operation was successful.
330    */
331   function mint(
332     address _to,
333     uint256 _amount
334   )
335     hasMintPermission
336     canMint
337     public
338     returns (bool)
339   {
340     totalSupply_ = totalSupply_.add(_amount);
341     balances[_to] = balances[_to].add(_amount);
342     emit Mint(_to, _amount);
343     emit Transfer(address(0), _to, _amount);
344     return true;
345   }
346 
347   /**
348    * @dev Function to stop minting new tokens.
349    * @return True if the operation was successful.
350    */
351   function finishMinting() onlyOwner canMint public returns (bool) {
352     mintingFinished = true;
353     emit MintFinished();
354     return true;
355   }
356 }
357 
358 
359 /**
360  * @title Burnable Token
361  * @dev Token that can be irreversibly burned (destroyed).
362  */
363 contract BurnableToken is BasicToken {
364 
365   event Burn(address indexed burner, uint256 value);
366 
367   /**
368    * @dev Burns a specific amount of tokens.
369    * @param _value The amount of token to be burned.
370    */
371   function burn(uint256 _value) public {
372     _burn(msg.sender, _value);
373   }
374 
375   function _burn(address _who, uint256 _value) internal {
376     require(_value <= balances[_who]);
377     // no need to require value <= totalSupply, since that would imply the
378     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
379 
380     balances[_who] = balances[_who].sub(_value);
381     totalSupply_ = totalSupply_.sub(_value);
382     emit Burn(_who, _value);
383     emit Transfer(_who, address(0), _value);
384   }
385 }
386 
387 
388 
389 /**
390  * @title Standard Burnable Token
391  * @dev Adds burnFrom method to ERC20 implementations
392  */
393 contract StandardBurnableToken is BurnableToken, StandardToken {
394 
395   /**
396    * @dev Burns a specific amount of tokens from the target address and decrements allowance
397    * @param _from address The address which you want to send tokens from
398    * @param _value uint256 The amount of token to be burned
399    */
400   function burnFrom(address _from, uint256 _value) public {
401     require(_value <= allowed[_from][msg.sender]);
402     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
403     // this function needs to emit an event with the updated approval.
404     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
405     _burn(_from, _value);
406   }
407 }
408 
409 
410 contract MintableBurnableToken is MintableToken, StandardBurnableToken {
411   uint MAX_UINT_256 = 2 ** 256 - 1;
412   string public name;
413   string public symbol;
414   uint8 public decimals = 18;
415   constructor(string _name, string _symbol) public MintableToken() {
416     name = _name;
417     symbol = _symbol;
418   }
419 
420   function transferFrom(
421     address _from,
422     address _to,
423     uint256 _value
424   )
425     public
426     returns (bool)
427   {
428     require(_to != address(0));
429     require(_value <= balances[_from]);
430     require(_value <= allowed[_from][msg.sender]);
431 
432     balances[_from] = balances[_from].sub(_value);
433     balances[_to] = balances[_to].add(_value);
434     if(allowed[_from][msg.sender] < MAX_UINT_256) {
435       // If they set an "unlimited" allowance, save gas by not decreasing the
436       // allowance
437       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
438     }
439     emit Transfer(_from, _to, _value);
440     return true;
441   }
442 }
443 
444 // Copyright (C) 2015, 2016, 2017 Dapphub
445 
446 // This program is free software: you can redistribute it and/or modify
447 // it under the terms of the GNU General Public License as published by
448 // the Free Software Foundation, either version 3 of the License, or
449 // (at your option) any later version.
450 
451 // This program is distributed in the hope that it will be useful,
452 // but WITHOUT ANY WARRANTY; without even the implied warranty of
453 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
454 // GNU General Public License for more details.
455 
456 // You should have received a copy of the GNU General Public License
457 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
458 
459 contract WETH9 {
460     string public name     = "Wrapped Ether";
461     string public symbol   = "WETH";
462     uint8  public decimals = 18;
463 
464     event  Approval(address indexed src, address indexed guy, uint wad);
465     event  Transfer(address indexed src, address indexed dst, uint wad);
466     event  Deposit(address indexed dst, uint wad);
467     event  Withdrawal(address indexed src, uint wad);
468 
469     mapping (address => uint)                       public  balanceOf;
470     mapping (address => mapping (address => uint))  public  allowance;
471 
472     function() public payable {
473         deposit();
474     }
475     function deposit() public payable {
476         balanceOf[msg.sender] += msg.value;
477         Deposit(msg.sender, msg.value);
478     }
479     function withdraw(uint wad) public {
480         require(balanceOf[msg.sender] >= wad);
481         balanceOf[msg.sender] -= wad;
482         msg.sender.transfer(wad);
483         Withdrawal(msg.sender, wad);
484     }
485 
486     function totalSupply() public view returns (uint) {
487         return this.balance;
488     }
489 
490     function approve(address guy, uint wad) public returns (bool) {
491         allowance[msg.sender][guy] = wad;
492         Approval(msg.sender, guy, wad);
493         return true;
494     }
495 
496     function transfer(address dst, uint wad) public returns (bool) {
497         return transferFrom(msg.sender, dst, wad);
498     }
499 
500     function transferFrom(address src, address dst, uint wad)
501         public
502         returns (bool)
503     {
504         require(balanceOf[src] >= wad);
505 
506         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
507             require(allowance[src][msg.sender] >= wad);
508             allowance[src][msg.sender] -= wad;
509         }
510 
511         balanceOf[src] -= wad;
512         balanceOf[dst] += wad;
513 
514         Transfer(src, dst, wad);
515 
516         return true;
517     }
518 }
519 
520 
521 contract StakeholderPot is Ownable {
522   WETH9 weth;
523   MintableBurnableToken stakeToken;
524   bool private _upgrading;
525 
526   event Debug(uint256 data);
527 
528   constructor(address _weth, address _stakeToken) Ownable() public {
529     weth = WETH9(_weth);
530     stakeToken = MintableBurnableToken(_stakeToken);
531   }
532 
533   function() public payable {
534     // If we get paid in ETH, convert to WETH so payouts work the same.
535     // Converting to WETH also makes payouts a bit safer, as we don't have to
536     // worry about code execution if the stakeholder is a contract.
537     if(!_upgrading) {
538       weth.deposit.value(msg.value)();
539     }
540   }
541 
542   function transferToken(address token, address recipient, uint quantity) external onlyOwner {
543     require(ERC20(token).transfer(recipient, quantity));
544   }
545 
546   function upgradeWeth(address _newWeth) external onlyOwner {
547     // At some point in the future we may want to upgrade from one WETH
548     // contract to a new one.
549     _upgrading = true;
550     weth.withdraw(weth.balanceOf(address(this)));
551     _upgrading = false;
552     weth = WETH9(_newWeth);
553     weth.deposit.value(address(this).balance)();
554   }
555 
556   function redeem(uint shares, address[] tokens) public {
557     require(
558       stakeToken.balanceOf(msg.sender) >= shares &&
559       stakeToken.allowance(msg.sender, address(this)) >= shares,
560       "Insufficient balance or allowance"
561     );
562     uint totalShares = stakeToken.totalSupply();
563     // Burn the sender's share before sending their tokens to ensure that a
564     // malicious token contract couldn't use reentrancy to empty the pot.
565     stakeToken.burnFrom(msg.sender, shares);
566 
567     for(uint i=0; i < tokens.length; i++) {
568       uint balance = ERC20(tokens[i]).balanceOf(address(this));
569       ERC20(tokens[i]).transfer(msg.sender, SafeMath.mul(balance, shares) / totalShares);
570     }
571   }
572 }