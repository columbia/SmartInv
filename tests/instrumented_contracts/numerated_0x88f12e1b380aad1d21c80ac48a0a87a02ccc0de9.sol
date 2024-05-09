1 pragma solidity ^0.5.0;
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
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Math
52  * @dev Assorted math operations
53  */
54 library Math {
55   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
56     return a >= b ? a : b;
57   }
58 
59   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
60     return a < b ? a : b;
61   }
62 
63   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
64     return a >= b ? a : b;
65   }
66 
67   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
68     return a < b ? a : b;
69   }
70 }
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/179
76  */
77 contract ERC20Basic {
78   function totalSupply() public view returns (uint256);
79   function balanceOf(address who) public view returns (uint256);
80   function transfer(address to, uint256 value) public returns (bool);
81   event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender)
90     public view returns (uint256);
91 
92   function transferFrom(address from, address to, uint256 value)
93     public returns (bool);
94 
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(
97     address indexed owner,
98     address indexed spender,
99     uint256 value
100   );
101 }
102 
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances.
106  */
107 contract BasicToken is ERC20Basic {
108   using SafeMath for uint256;
109   mapping(address => uint256) balances;
110 
111   uint256 totalSupply_;
112 
113   /**
114   * @dev total number of tokens in existence
115   */
116   function totalSupply() public view returns (uint256) {
117     return totalSupply_;
118   }
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public  returns (bool) {
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
145 /**
146  * @title Burnable Token
147  * @dev Token that can be irreversibly burned (destroyed).
148  */
149 contract BurnableToken is BasicToken {
150 
151   event Burn(address indexed burner, uint256 value);
152 
153   /**
154    * @dev Burns a specific amount of tokens.
155    * @param _value The amount of token to be burned.
156    */
157   function burn(uint256 _value) public {
158     _burn(msg.sender, _value);
159   }
160 
161   function _burn(address _who, uint256 _value) internal {
162     require(_value <= balances[_who]);
163     // no need to require value <= totalSupply, since that would imply the
164     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
165 
166     balances[_who] = balances[_who].sub(_value);
167     totalSupply_ = totalSupply_.sub(_value);
168     emit Burn(_who, _value);
169     emit Transfer(_who, address(0), _value);
170   }
171 }
172 
173 /**
174  * @title Standard ERC20 token
175  *
176  * @dev Implementation of the basic standard token.
177  * @dev https://github.com/ethereum/EIPs/issues/20
178  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
179  */
180 contract StandardToken is ERC20, BasicToken {
181 
182   mapping (address => mapping (address => uint256)) internal allowed;
183 
184 
185   /**
186    * @dev Transfer tokens from one address to another
187    * @param _from address The address which you want to send tokens from
188    * @param _to address The address which you want to transfer to
189    * @param _value uint256 the amount of tokens to be transferred
190    */
191   function transferFrom(
192     address _from,
193     address _to,
194     uint256 _value
195   )
196     public
197     returns (bool)
198   {
199     require(_to != address(0));
200     require(_value <= balances[_from]);
201     require(_value <= allowed[_from][msg.sender]);
202 
203     balances[_from] = balances[_from].sub(_value);
204     balances[_to] = balances[_to].add(_value);
205     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
206     emit Transfer(_from, _to, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
212    *
213    * Beware that changing an allowance with this method brings the risk that someone may use both the old
214    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
215    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
216    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
217    * @param _spender The address which will spend the funds.
218    * @param _value The amount of tokens to be spent.
219    */
220   function approve(address _spender, uint256 _value) public returns (bool) {
221     allowed[msg.sender][_spender] = _value;
222     emit Approval(msg.sender, _spender, _value);
223     return true;
224   }
225 
226   /**
227    * @dev Function to check the amount of tokens that an owner allowed to a spender.
228    * @param _owner address The address which owns the funds.
229    * @param _spender address The address which will spend the funds.
230    * @return A uint256 specifying the amount of tokens still available for the spender.
231    */
232   function allowance(
233     address _owner,
234     address _spender
235    )
236     public
237     view
238     returns (uint256)
239   {
240     return allowed[_owner][_spender];
241   }
242 
243   /**
244    * @dev Increase the amount of tokens that an owner allowed to a spender.
245    *
246    * approve should be called when allowed[_spender] == 0. To increment
247    * allowed value is better to use this function to avoid 2 calls (and wait until
248    * the first transaction is mined)
249    * From MonolithDAO Token.sol
250    * @param _spender The address which will spend the funds.
251    * @param _addedValue The amount of tokens to increase the allowance by.
252    */
253   function increaseApproval(
254     address _spender,
255     uint _addedValue
256   )
257     public
258     returns (bool)
259   {
260     allowed[msg.sender][_spender] = (
261       allowed[msg.sender][_spender].add(_addedValue));
262     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263     return true;
264   }
265 
266   /**
267    * @dev Decrease the amount of tokens that an owner allowed to a spender.
268    *
269    * approve should be called when allowed[_spender] == 0. To decrement
270    * allowed value is better to use this function to avoid 2 calls (and wait until
271    * the first transaction is mined)
272    * From MonolithDAO Token.sol
273    * @param _spender The address which will spend the funds.
274    * @param _subtractedValue The amount of tokens to decrease the allowance by.
275    */
276   function decreaseApproval(
277     address _spender,
278     uint _subtractedValue
279   )
280     public
281     returns (bool)
282   {
283     uint oldValue = allowed[msg.sender][_spender];
284     if (_subtractedValue > oldValue) {
285       allowed[msg.sender][_spender] = 0;
286     } else {
287       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
288     }
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293 }
294 
295 /**
296  * @title Ownable
297  * @dev The Ownable contract has an owner address, and provides basic authorization control
298  * functions, this simplifies the implementation of "user permissions".
299  */
300 contract Ownable {
301   address public owner;
302 
303 
304   event OwnershipRenounced(address indexed previousOwner);
305   event OwnershipTransferred(
306     address indexed previousOwner,
307     address indexed newOwner
308   );
309 
310 
311   /**
312    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
313    * account.
314    */
315   constructor() public {
316     owner = msg.sender;
317   }
318 
319   /**
320    * @dev Throws if called by any account other than the owner.
321    */
322   modifier onlyOwner() {
323     require(msg.sender == owner);
324     _;
325   }
326 
327   /**
328    * @dev Allows the current owner to transfer control of the contract to a newOwner.
329    * @param newOwner The address to transfer ownership to.
330    */
331   function transferOwnership(address newOwner) public onlyOwner {
332     require(newOwner != address(0));
333     emit OwnershipTransferred(owner, newOwner);
334     owner = newOwner;
335   }
336 
337   /**
338    * @dev Allows the current owner to relinquish control of the contract.
339    */
340   function renounceOwnership() public onlyOwner {
341     emit OwnershipRenounced(owner);
342     owner = address(0);
343   }
344 }
345 
346 /**
347  * @title Mintable token
348  * @dev Simple ERC20 Token example, with mintable token creation
349  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
350  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
351  */
352 contract MintableToken is StandardToken, Ownable {
353   event Mint(address indexed to, uint256 amount);
354   event MintFinished();
355 
356   bool public mintingFinished = false;
357 
358   uint256 public maxMintQuantity;
359   
360   bool public isLimitMint = false;
361 
362   modifier canMint() {
363   	
364     require(!mintingFinished);
365     
366     _;
367   }
368 
369   modifier hasMintPermission() {
370     require(msg.sender == owner);
371     _;
372   }
373 
374 
375   /**
376    * @dev Function to mint tokens
377    * @param _to The address that will receive the minted tokens.
378    * @param _amount The amount of tokens to mint.
379    * @return A boolean that indicates if the operation was successful.
380    */
381   function mint(
382     address _to,
383     uint256 _amount
384   )
385     hasMintPermission
386     canMint
387     public
388     returns (bool)
389   {
390   	
391     totalSupply_ = totalSupply_.add(_amount);
392     balances[_to] = balances[_to].add(_amount);
393     emit Mint(_to, _amount);
394     emit Transfer(address(0), _to, _amount);
395     return true;
396   }
397 
398   /**
399    * @dev Function to stop minting new tokens.
400    * @return True if the operation was successful.
401    */
402   function finishMinting() onlyOwner canMint public returns (bool) {
403     mintingFinished = true;
404     emit MintFinished();
405     return true;
406   }
407 }
408 
409 
410 /**
411  * @dev ERC20 Token that can be minted
412  */
413 contract KLK20Token is MintableToken,BurnableToken {
414 
415   string public constant name = "KLICKZIE TOKEN";
416   string public constant symbol = "KLK20"; 
417   uint8 public constant decimals = 18;
418   
419   uint256 public initialSupply = 3000 * 1000000 * 10**18;
420   address public masterWallet;
421 
422   constructor () public {
423     owner = msg.sender;
424     masterWallet = owner;
425 
426     balances[masterWallet] = initialSupply;
427   }
428   
429 
430 }