1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * See https://github.com/ethereum/EIPs/issues/179
58  */
59 contract ERC20Basic {
60   function totalSupply() public view returns (uint256);
61   function balanceOf(address _who) public view returns (uint256);
62   function transfer(address _to, uint256 _value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) internal balances;
74 
75   uint256 internal totalSupply_;
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
90     require(_value <= balances[msg.sender]);
91     require(_to != address(0));
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
110 
111 /**
112  * @title Burnable Token
113  * @dev Token that can be irreversibly burned (destroyed).
114  */
115 contract BurnableToken is BasicToken {
116 
117   event Burn(address indexed burner, uint256 value);
118 
119   /**
120    * @dev Burns a specific amount of tokens.
121    * @param _value The amount of token to be burned.
122    */
123   function burn(uint256 _value) public {
124     _burn(msg.sender, _value);
125   }
126 
127   function _burn(address _who, uint256 _value) internal {
128     require(_value <= balances[_who]);
129     // no need to require value <= totalSupply, since that would imply the
130     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
131 
132     balances[_who] = balances[_who].sub(_value);
133     totalSupply_ = totalSupply_.sub(_value);
134     emit Burn(_who, _value);
135     emit Transfer(_who, address(0), _value);
136   }
137 }
138 
139 /**
140  * @title ERC20 interface
141  * @dev see https://github.com/ethereum/EIPs/issues/20
142  */
143 contract ERC20 is ERC20Basic {
144   function allowance(address _owner, address _spender)
145     public view returns (uint256);
146 
147   function transferFrom(address _from, address _to, uint256 _value)
148     public returns (bool);
149 
150   function approve(address _spender, uint256 _value) public returns (bool);
151   event Approval(
152     address indexed owner,
153     address indexed spender,
154     uint256 value
155   );
156 }
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * https://github.com/ethereum/EIPs/issues/20
163  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167   mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(
177     address _from,
178     address _to,
179     uint256 _value
180   )
181     public
182     returns (bool)
183   {
184     require(_value <= balances[_from]);
185     require(_value <= allowed[_from][msg.sender]);
186     require(_to != address(0));
187 
188     balances[_from] = balances[_from].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191     emit Transfer(_from, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) public returns (bool) {
205     allowed[msg.sender][_spender] = _value;
206     emit Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Function to check the amount of tokens that an owner allowed to a spender.
212    * @param _owner address The address which owns the funds.
213    * @param _spender address The address which will spend the funds.
214    * @return A uint256 specifying the amount of tokens still available for the spender.
215    */
216   function allowance(
217     address _owner,
218     address _spender
219    )
220     public
221     view
222     returns (uint256)
223   {
224     return allowed[_owner][_spender];
225   }
226 
227   /**
228    * @dev Increase the amount of tokens that an owner allowed to a spender.
229    * approve should be called when allowed[_spender] == 0. To increment
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _addedValue The amount of tokens to increase the allowance by.
235    */
236   function increaseApproval(
237     address _spender,
238     uint256 _addedValue
239   )
240     public
241     returns (bool)
242   {
243     allowed[msg.sender][_spender] = (
244       allowed[msg.sender][_spender].add(_addedValue));
245     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249   /**
250    * @dev Decrease the amount of tokens that an owner allowed to a spender.
251    * approve should be called when allowed[_spender] == 0. To decrement
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    * @param _spender The address which will spend the funds.
256    * @param _subtractedValue The amount of tokens to decrease the allowance by.
257    */
258   function decreaseApproval(
259     address _spender,
260     uint256 _subtractedValue
261   )
262     public
263     returns (bool)
264   {
265     uint256 oldValue = allowed[msg.sender][_spender];
266     if (_subtractedValue >= oldValue) {
267       allowed[msg.sender][_spender] = 0;
268     } else {
269       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270     }
271     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275 }
276 
277 
278 /**
279  * @title Ownable
280  * @dev The Ownable contract has an owner address, and provides basic authorization control
281  * functions, this simplifies the implementation of "user permissions".
282  */
283 contract Ownable {
284   address public owner;
285 
286 
287   event OwnershipRenounced(address indexed previousOwner);
288   event OwnershipTransferred(
289     address indexed previousOwner,
290     address indexed newOwner
291   );
292 
293 
294   /**
295    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
296    * account.
297    */
298   constructor() public {
299     owner = msg.sender;
300   }
301 
302   /**
303    * @dev Throws if called by any account other than the owner.
304    */
305   modifier onlyOwner() {
306     require(msg.sender == owner);
307     _;
308   }
309 
310   /**
311    * @dev Allows the current owner to relinquish control of the contract.
312    * @notice Renouncing to ownership will leave the contract without an owner.
313    * It will not be possible to call the functions with the `onlyOwner`
314    * modifier anymore.
315    */
316   function renounceOwnership() public onlyOwner {
317     emit OwnershipRenounced(owner);
318     owner = address(0);
319   }
320 
321   /**
322    * @dev Allows the current owner to transfer control of the contract to a newOwner.
323    * @param _newOwner The address to transfer ownership to.
324    */
325   function transferOwnership(address _newOwner) public onlyOwner {
326     _transferOwnership(_newOwner);
327   }
328 
329   /**
330    * @dev Transfers control of the contract to a newOwner.
331    * @param _newOwner The address to transfer ownership to.
332    */
333   function _transferOwnership(address _newOwner) internal {
334     require(_newOwner != address(0));
335     emit OwnershipTransferred(owner, _newOwner);
336     owner = _newOwner;
337   }
338 }
339 
340 /**
341 * @title CTF15Token
342 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
343 * Note they can later distribute these tokens as they wish using `transfer` and other
344 * `StandardToken` functions.
345 */
346 contract CTF15Token is StandardToken, BurnableToken, Ownable {
347         address public owner;
348         address public pricingBot;
349         string public constant name = "CTF15Token"; // solium-disable-line uppercase
350         string public constant symbol = "C15"; // solium-disable-line uppercase
351         uint8 public constant decimals = 5; // solium-disable-line uppercase
352 
353         uint256 public constant INITIAL_SUPPLY = 0 * (10 ** uint256(decimals));
354 
355         /**
356         * @dev Constructor that gives msg.sender all of existing tokens.
357         */
358         constructor() public {
359                 owner = msg.sender;
360                 pricingBot = msg.sender;
361                 coinNumber = 15;
362                 // Prices in XXX - USD
363                 coinPrices = new uint64[](coinNumber);
364                 // Shares go from 1 to 1000, i.e. pro mille
365                 coinShares = new uint64[](coinNumber);
366         }
367 
368         /**
369         * CTF15 coin prices
370         */
371         uint8 public coinNumber;
372         uint64 public buyBackPrice;
373         uint64[] public coinPrices;
374         uint64[] public coinShares;
375         uint64 public indexValue;
376 
377         /*
378         * True if Minting period finished
379         */
380         bool public mintingFinished = false;
381 
382         /**
383         * CTF15 specific Events
384         */
385         event BuyAssets(
386                 uint256[] assetsToBuy
387         );
388         event SellAssets(
389                 uint256[] assetsToSell
390         );
391         event Mint(
392                 address indexed to,
393                 uint256 amount
394         );
395         event MintFinished();
396 
397         modifier canMint() {
398                 require(!mintingFinished);
399                 _;
400         }
401 
402         modifier hasMintPermission() {
403                 require(msg.sender == owner);
404                 _;
405         }
406 
407         /**
408         * @dev Function to mint tokens
409         * @param _to The address that will receive the minted tokens.
410         * @param _amount The amount of tokens to mint.
411         * @return A boolean that indicates if the operation was successful.
412         */
413         function mint(
414                 address _to,
415                 uint256 _amount
416         )
417         hasMintPermission
418         canMint
419         public
420         returns (bool) {
421                 totalSupply_ = totalSupply_.add(_amount);
422                 balances[_to] = balances[_to].add(_amount);
423                 emit Mint(_to, _amount);
424                 emit Transfer(address(0), _to, _amount);
425                 return true;
426         }
427 
428         /**
429         * @dev Function to stop minting new tokens.
430         * @return True if the operation was successful.
431         */
432         function finishMinting() onlyOwner canMint public returns (bool) {
433                 mintingFinished = true;
434                 emit MintFinished();
435                 return true;
436         }
437 
438         /**
439         * Functions for CTF15
440         */
441         function UpdatePricingBot(address newBotAddress) onlyOwner public {
442                 pricingBot = newBotAddress;
443         }
444 
445         function UpdateCoinShares(uint64[] _shares) public {
446                 require(msg.sender == pricingBot);
447                 require(_shares.length >= coinNumber);
448 
449                 for (uint8 i = 0; i < coinNumber; i++) {
450                         coinShares[i] = _shares[i];
451                 }
452         }
453 
454         function UpdateCoinPrices(uint64[] _prices) public {
455                 require(msg.sender == pricingBot);
456                 require(_prices.length >= coinNumber);
457 
458                 for (uint8 i = 0; i < coinNumber; i++) {
459                         coinPrices[i] = _prices[i];
460                 }
461         }
462 
463         // ethIndex is the index (0-14) of Ethereum in our basket
464         function GenerateNewTokens(uint ethIndex, uint totalAmount) public returns(bool) {
465                 // Set new owner values of token and mint them
466                 mint(msg.sender, totalAmount);
467 
468                 // Generate data for trading bot which assets to buy
469                 uint256[] memory buyOrders = new uint256[](coinNumber);
470                 for (uint8 i = 0; i < coinNumber; i++) {
471                         buyOrders[i] = (coinShares[i] * totalAmount * coinPrices[ethIndex]) / (1e16 * 1000);
472                 }
473                 emit BuyAssets(buyOrders);
474                 return true;
475         }
476 
477         function SellTokens(uint ethIndex, uint amount) public returns(bool) {
478                 // Ensure sender has enough funds to Sell shares
479                 require(amount <= balances[msg.sender]);
480 
481                 // Set new balance
482                 _burn(msg.sender, amount);
483 
484                 // Generate data for trading bot which assets to sell
485                 uint256[] memory sellOrders = new uint256[](coinNumber);
486                 for (uint8 i = 0; i < coinNumber; i++) {
487                         sellOrders[i] = (coinShares[i] * amount * coinPrices[ethIndex]) / (1e16 * 1000);
488                 }
489                 emit SellAssets(sellOrders);
490                 return true;
491         }
492 
493         function SetBuyBackPrice(uint64 newPrice) public onlyOwner {
494                 buyBackPrice = newPrice;
495         }
496 
497         function SetCoinNumber(uint8 newNumber) public onlyOwner {
498                 coinNumber = newNumber;
499                 coinPrices = new uint64[](coinNumber);
500                 coinShares = new uint64[](coinNumber);
501         }
502 
503         function SetIndexValue(uint64 newValue) public onlyOwner {
504                 indexValue = newValue;
505         }
506 }