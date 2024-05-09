1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) public view returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24   function approve(address spender, uint256 value) public returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 
30 /**
31    @title ERC827 interface, an extension of ERC20 token standard
32 
33    Interface of a ERC827 token, following the ERC20 standard with extra
34    methods to transfer value and data and execute calls in transfers and
35    approvals.
36  */
37 contract ERC827 is ERC20 {
38 
39   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
40   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
41   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
42 
43 }
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   /**
74   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 
92 
93 /**
94  * @title Basic token
95  * @dev Basic version of StandardToken, with no allowances.
96  */
97 contract BasicToken is ERC20Basic {
98   using SafeMath for uint256;
99 
100   mapping(address => uint256) balances;
101 
102   uint256 totalSupply_;
103 
104   /**
105   * @dev total number of tokens in existence
106   */
107   function totalSupply() public view returns (uint256) {
108     return totalSupply_;
109   }
110 
111   /**
112   * @dev transfer token for a specified address
113   * @param _to The address to transfer to.
114   * @param _value The amount to be transferred.
115   */
116   function transfer(address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[msg.sender]);
119 
120     // SafeMath.sub will throw if there is not enough balance.
121     balances[msg.sender] = balances[msg.sender].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     Transfer(msg.sender, _to, _value);
124     return true;
125   }
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param _owner The address to query the the balance of.
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address _owner) public view returns (uint256 balance) {
133     return balances[_owner];
134   }
135 
136 }
137 
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is ERC20, BasicToken {
147 
148   mapping (address => mapping (address => uint256)) internal allowed;
149 
150 
151   /**
152    * @dev Transfer tokens from one address to another
153    * @param _from address The address which you want to send tokens from
154    * @param _to address The address which you want to transfer to
155    * @param _value uint256 the amount of tokens to be transferred
156    */
157   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158     require(_to != address(0));
159     require(_value <= balances[_from]);
160     require(_value <= allowed[_from][msg.sender]);
161 
162     balances[_from] = balances[_from].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165     Transfer(_from, _to, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    *
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint256 _value) public returns (bool) {
180     allowed[msg.sender][_spender] = _value;
181     Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifying the amount of tokens still available for the spender.
190    */
191   function allowance(address _owner, address _spender) public view returns (uint256) {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _addedValue The amount of tokens to increase the allowance by.
204    */
205   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
206     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
207     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211   /**
212    * @dev Decrease the amount of tokens that an owner allowed to a spender.
213    *
214    * approve should be called when allowed[_spender] == 0. To decrement
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param _spender The address which will spend the funds.
219    * @param _subtractedValue The amount of tokens to decrease the allowance by.
220    */
221   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
222     uint oldValue = allowed[msg.sender][_spender];
223     if (_subtractedValue > oldValue) {
224       allowed[msg.sender][_spender] = 0;
225     } else {
226       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
227     }
228     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229     return true;
230   }
231 
232 }
233 
234 
235 /**
236  * @title Ownable
237  * @dev The Ownable contract has an owner address, and provides basic authorization control
238  * functions, this simplifies the implementation of "user permissions".
239  */
240 contract Ownable {
241   address public owner;
242 
243 
244   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
245 
246 
247   /**
248    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
249    * account.
250    */
251   function Ownable() public {
252     owner = msg.sender;
253   }
254 
255   /**
256    * @dev Throws if called by any account other than the owner.
257    */
258   modifier onlyOwner() {
259     require(msg.sender == owner);
260     _;
261   }
262 
263   /**
264    * @dev Allows the current owner to transfer control of the contract to a newOwner.
265    * @param newOwner The address to transfer ownership to.
266    */
267   function transferOwnership(address newOwner) public onlyOwner {
268     require(newOwner != address(0));
269     OwnershipTransferred(owner, newOwner);
270     owner = newOwner;
271   }
272 
273 }
274 
275 
276 
277 /**
278  * @title Mintable token
279  * @dev Simple ERC20 Token example, with mintable token creation
280  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
281  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
282  */
283 contract MintableToken is StandardToken, Ownable {
284   event Mint(address indexed to, uint256 amount);
285   event MintFinished();
286 
287   bool public mintingFinished = false;
288 
289 
290   modifier canMint() {
291     require(!mintingFinished);
292     _;
293   }
294 
295   /**
296    * @dev Function to mint tokens
297    * @param _to The address that will receive the minted tokens.
298    * @param _amount The amount of tokens to mint.
299    * @return A boolean that indicates if the operation was successful.
300    */
301   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
302     totalSupply_ = totalSupply_.add(_amount);
303     balances[_to] = balances[_to].add(_amount);
304     Mint(_to, _amount);
305     Transfer(address(0), _to, _amount);
306     return true;
307   }
308 
309   /**
310    * @dev Function to stop minting new tokens.
311    * @return True if the operation was successful.
312    */
313   function finishMinting() onlyOwner canMint public returns (bool) {
314     mintingFinished = true;
315     MintFinished();
316     return true;
317   }
318 }
319 
320 
321 contract MintableBurnableToken is MintableToken {
322     event Burn(address indexed burner, uint256 value);
323 
324     /**
325      * @dev Burns a specific amount of tokens.
326      * @param _value The amount of token to be burned.
327      */
328     function burn(uint256 _value) public {
329         require(_value <= balances[msg.sender]);
330         // no need to require value <= totalSupply, since that would imply the
331         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
332 
333         address burner = msg.sender;
334         balances[burner] = balances[burner].sub(_value);
335         totalSupply_ = totalSupply_.sub(_value);
336         Burn(burner, _value);
337         Transfer(burner, address(0), _value);
338     }
339 }
340 
341 
342 /**
343    @title ERC827, an extension of ERC20 token standard
344 
345    Implementation the ERC827, following the ERC20 standard with extra
346    methods to transfer value and data and execute calls in transfers and
347    approvals.
348    Uses OpenZeppelin StandardToken.
349  */
350 contract MintableBurnableERC827Token is ERC827, MintableBurnableToken {
351 
352     /**
353        @dev Addition to ERC20 token methods. It allows to
354        approve the transfer of value and execute a call with the sent data.
355 
356        Beware that changing an allowance with this method brings the risk that
357        someone may use both the old and the new allowance by unfortunate
358        transaction ordering. One possible solution to mitigate this race condition
359        is to first reduce the spender's allowance to 0 and set the desired value
360        afterwards:
361        https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
362 
363        @param _spender The address that will spend the funds.
364        @param _value The amount of tokens to be spent.
365        @param _data ABI-encoded contract call to call `_to` address.
366 
367        @return true if the call function was executed successfully
368      */
369     function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
370         require(_spender != address(this));
371 
372         super.approve(_spender, _value);
373 
374         require(_spender.call(_data));
375 
376         return true;
377     }
378 
379     /**
380        @dev Addition to ERC20 token methods. Transfer tokens to a specified
381        address and execute a call with the sent data on the same transaction
382 
383        @param _to address The address which you want to transfer to
384        @param _value uint256 the amout of tokens to be transfered
385        @param _data ABI-encoded contract call to call `_to` address.
386 
387        @return true if the call function was executed successfully
388      */
389     function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
390         require(_to != address(this));
391 
392         super.transfer(_to, _value);
393 
394         require(_to.call(_data));
395         return true;
396     }
397 
398     /**
399        @dev Addition to ERC20 token methods. Transfer tokens from one address to
400        another and make a contract call on the same transaction
401 
402        @param _from The address which you want to send tokens from
403        @param _to The address which you want to transfer to
404        @param _value The amout of tokens to be transferred
405        @param _data ABI-encoded contract call to call `_to` address.
406 
407        @return true if the call function was executed successfully
408      */
409     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
410         require(_to != address(this));
411 
412         super.transferFrom(_from, _to, _value);
413 
414         require(_to.call(_data));
415         return true;
416     }
417 
418     /**
419      * @dev Addition to StandardToken methods. Increase the amount of tokens that
420      * an owner allowed to a spender and execute a call with the sent data.
421      *
422      * approve should be called when allowed[_spender] == 0. To increment
423      * allowed value is better to use this function to avoid 2 calls (and wait until
424      * the first transaction is mined)
425      * From MonolithDAO Token.sol
426      * @param _spender The address which will spend the funds.
427      * @param _addedValue The amount of tokens to increase the allowance by.
428      * @param _data ABI-encoded contract call to call `_spender` address.
429      */
430     function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
431         require(_spender != address(this));
432 
433         super.increaseApproval(_spender, _addedValue);
434 
435         require(_spender.call(_data));
436 
437         return true;
438     }
439 
440     /**
441      * @dev Addition to StandardToken methods. Decrease the amount of tokens that
442      * an owner allowed to a spender and execute a call with the sent data.
443      *
444      * approve should be called when allowed[_spender] == 0. To decrement
445      * allowed value is better to use this function to avoid 2 calls (and wait until
446      * the first transaction is mined)
447      * From MonolithDAO Token.sol
448      * @param _spender The address which will spend the funds.
449      * @param _subtractedValue The amount of tokens to decrease the allowance by.
450      * @param _data ABI-encoded contract call to call `_spender` address.
451      */
452     function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
453         require(_spender != address(this));
454 
455         super.decreaseApproval(_spender, _subtractedValue);
456 
457         require(_spender.call(_data));
458 
459         return true;
460     }
461 
462 }
463 
464 
465 contract Pycoin is MintableBurnableERC827Token{
466     // Name of the token
467     string constant public name = "Pycoin";
468     // Token abbreviation
469     string constant public symbol = "Pyc";
470     // Decimal places
471     uint8 constant public decimals = 18;
472 }