1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
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
36    * @dev Allows the current owner to relinquish control of the contract.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 /**
63  * @title ERC20Basic
64  * @dev Simpler version of ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/179
66  */
67 contract ERC20Basic {
68   function totalSupply() public view returns (uint256);
69   function balanceOf(address who) public view returns (uint256);
70   function transfer(address to, uint256 value) public returns (bool);
71   event Transfer(address indexed from, address indexed to, uint256 value);
72 }
73 
74 /**
75  * @title SafeMath
76  * @dev Math operations with safety checks that throw on error
77  */
78 library SafeMath {
79 
80   /**
81   * @dev Multiplies two numbers, throws on overflow.
82   */
83   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
84     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
85     // benefit is lost if 'b' is also tested.
86     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
87     if (a == 0) {
88       return 0;
89     }
90 
91     c = a * b;
92     assert(c / a == b);
93     return c;
94   }
95 
96   /**
97   * @dev Integer division of two numbers, truncating the quotient.
98   */
99   function div(uint256 a, uint256 b) internal pure returns (uint256) {
100     // assert(b > 0); // Solidity automatically throws when dividing by 0
101     // uint256 c = a / b;
102     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103     return a / b;
104   }
105 
106   /**
107   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
108   */
109   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110     assert(b <= a);
111     return a - b;
112   }
113 
114   /**
115   * @dev Adds two numbers, throws on overflow.
116   */
117   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
118     c = a + b;
119     assert(c >= a);
120     return c;
121   }
122 }
123 
124 /**
125  * @title Basic token
126  * @dev Basic version of StandardToken, with no allowances.
127  */
128 contract BasicToken is ERC20Basic {
129   using SafeMath for uint256;
130 
131   mapping(address => uint256) balances;
132 
133   uint256 totalSupply_;
134 
135   /**
136   * @dev total number of tokens in existence
137   */
138   function totalSupply() public view returns (uint256) {
139     return totalSupply_;
140   }
141 
142   /**
143   * @dev transfer token for a specified address
144   * @param _to The address to transfer to.
145   * @param _value The amount to be transferred.
146   */
147   function transfer(address _to, uint256 _value) public returns (bool) {
148     require(_to != address(0));
149     require(_value <= balances[msg.sender]);
150 
151     balances[msg.sender] = balances[msg.sender].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     emit Transfer(msg.sender, _to, _value);
154     return true;
155   }
156 
157   /**
158   * @dev Gets the balance of the specified address.
159   * @param _owner The address to query the the balance of.
160   * @return An uint256 representing the amount owned by the passed address.
161   */
162   function balanceOf(address _owner) public view returns (uint256) {
163     return balances[_owner];
164   }
165 
166 }
167 
168 /**
169  * @title ERC20 interface
170  * @dev see https://github.com/ethereum/EIPs/issues/20
171  */
172 contract ERC20 is ERC20Basic {
173   function allowance(address owner, address spender)
174     public view returns (uint256);
175 
176   function transferFrom(address from, address to, uint256 value)
177     public returns (bool);
178 
179   function approve(address spender, uint256 value) public returns (bool);
180   event Approval(
181     address indexed owner,
182     address indexed spender,
183     uint256 value
184   );
185 }
186 
187 
188 
189 /**
190  * @title Standard ERC20 token
191  *
192  * @dev Implementation of the basic standard token.
193  * @dev https://github.com/ethereum/EIPs/issues/20
194  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
195  */
196 contract StandardToken is ERC20, BasicToken {
197 
198   mapping (address => mapping (address => uint256)) internal allowed;
199 
200 
201   /**
202    * @dev Transfer tokens from one address to another
203    * @param _from address The address which you want to send tokens from
204    * @param _to address The address which you want to transfer to
205    * @param _value uint256 the amount of tokens to be transferred
206    */
207   function transferFrom(
208     address _from,
209     address _to,
210     uint256 _value
211   )
212     public
213     returns (bool)
214   {
215     require(_to != address(0));
216     require(_value <= balances[_from]);
217     require(_value <= allowed[_from][msg.sender]);
218 
219     balances[_from] = balances[_from].sub(_value);
220     balances[_to] = balances[_to].add(_value);
221     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
222     emit Transfer(_from, _to, _value);
223     return true;
224   }
225 
226   /**
227    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
228    *
229    * Beware that changing an allowance with this method brings the risk that someone may use both the old
230    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
231    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
232    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233    * @param _spender The address which will spend the funds.
234    * @param _value The amount of tokens to be spent.
235    */
236   function approve(address _spender, uint256 _value) public returns (bool) {
237     allowed[msg.sender][_spender] = _value;
238     emit Approval(msg.sender, _spender, _value);
239     return true;
240   }
241 
242   /**
243    * @dev Function to check the amount of tokens that an owner allowed to a spender.
244    * @param _owner address The address which owns the funds.
245    * @param _spender address The address which will spend the funds.
246    * @return A uint256 specifying the amount of tokens still available for the spender.
247    */
248   function allowance(
249     address _owner,
250     address _spender
251    )
252     public
253     view
254     returns (uint256)
255   {
256     return allowed[_owner][_spender];
257   }
258 
259   /**
260    * @dev Increase the amount of tokens that an owner allowed to a spender.
261    *
262    * approve should be called when allowed[_spender] == 0. To increment
263    * allowed value is better to use this function to avoid 2 calls (and wait until
264    * the first transaction is mined)
265    * From MonolithDAO Token.sol
266    * @param _spender The address which will spend the funds.
267    * @param _addedValue The amount of tokens to increase the allowance by.
268    */
269   function increaseApproval(
270     address _spender,
271     uint _addedValue
272   )
273     public
274     returns (bool)
275   {
276     allowed[msg.sender][_spender] = (
277       allowed[msg.sender][_spender].add(_addedValue));
278     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282   /**
283    * @dev Decrease the amount of tokens that an owner allowed to a spender.
284    *
285    * approve should be called when allowed[_spender] == 0. To decrement
286    * allowed value is better to use this function to avoid 2 calls (and wait until
287    * the first transaction is mined)
288    * From MonolithDAO Token.sol
289    * @param _spender The address which will spend the funds.
290    * @param _subtractedValue The amount of tokens to decrease the allowance by.
291    */
292   function decreaseApproval(
293     address _spender,
294     uint _subtractedValue
295   )
296     public
297     returns (bool)
298   {
299     uint oldValue = allowed[msg.sender][_spender];
300     if (_subtractedValue > oldValue) {
301       allowed[msg.sender][_spender] = 0;
302     } else {
303       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
304     }
305     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
306     return true;
307   }
308 
309 }
310 
311 /**
312  * @title Burnable Token
313  * @dev Token that can be irreversibly burned (destroyed).
314  */
315 contract BurnableToken is BasicToken {
316 
317   event Burn(address indexed burner, uint256 value);
318 
319   /**
320    * @dev Burns a specific amount of tokens.
321    * @param _value The amount of token to be burned.
322    */
323   function burn(uint256 _value) public {
324     _burn(msg.sender, _value);
325   }
326 
327   function _burn(address _who, uint256 _value) internal {
328     require(_value <= balances[_who]);
329     // no need to require value <= totalSupply, since that would imply the
330     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
331 
332     balances[_who] = balances[_who].sub(_value);
333     totalSupply_ = totalSupply_.sub(_value);
334     emit Burn(_who, _value);
335     emit Transfer(_who, address(0), _value);
336   }
337 }
338 
339 /**
340  * @title Standard Burnable Token
341  * @dev Adds burnFrom method to ERC20 implementations
342  */
343 contract StandardBurnableToken is BurnableToken, StandardToken {
344 
345   /**
346    * @dev Burns a specific amount of tokens from the target address and decrements allowance
347    * @param _from address The address which you want to send tokens from
348    * @param _value uint256 The amount of token to be burned
349    */
350   function burnFrom(address _from, uint256 _value) public {
351     require(_value <= allowed[_from][msg.sender]);
352     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
353     // this function needs to emit an event with the updated approval.
354     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
355     _burn(_from, _value);
356   }
357 }
358 
359 /**
360  * @title Mintable token
361  * @dev Simple ERC20 Token example, with mintable token creation
362  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
363  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
364  */
365 contract MintableToken is StandardToken, Ownable {
366   event Mint(address indexed to, uint256 amount);
367   event MintFinished();
368 
369   bool public mintingFinished = false;
370 
371 
372   modifier canMint() {
373     require(!mintingFinished);
374     _;
375   }
376 
377   modifier hasMintPermission() {
378     require(msg.sender == owner);
379     _;
380   }
381 
382   /**
383    * @dev Function to mint tokens
384    * @param _to The address that will receive the minted tokens.
385    * @param _amount The amount of tokens to mint.
386    * @return A boolean that indicates if the operation was successful.
387    */
388   function mint(
389     address _to,
390     uint256 _amount
391   )
392     hasMintPermission
393     canMint
394     public
395     returns (bool)
396   {
397     totalSupply_ = totalSupply_.add(_amount);
398     balances[_to] = balances[_to].add(_amount);
399     emit Mint(_to, _amount);
400     emit Transfer(address(0), _to, _amount);
401     return true;
402   }
403 
404   /**
405    * @dev Function to stop minting new tokens.
406    * @return True if the operation was successful.
407    */
408   function finishMinting() onlyOwner canMint public returns (bool) {
409     mintingFinished = true;
410     emit MintFinished();
411     return true;
412   }
413 }
414 
415 /**
416  * @title DetailedERC20 token
417  * @dev The decimals are only for visualization purposes.
418  * All the operations are done using the smallest and indivisible token unit,
419  * just as on Ethereum all the operations are done in wei.
420  */
421 contract DetailedERC20 is ERC20 {
422   string public name;
423   string public symbol;
424   uint8 public decimals;
425 
426   constructor(string _name, string _symbol, uint8 _decimals) public {
427     name = _name;
428     symbol = _symbol;
429     decimals = _decimals;
430   }
431 }
432 
433 contract OrcToken is StandardBurnableToken, MintableToken, DetailedERC20{
434     constructor()
435     DetailedERC20('Orch Network', 'ORC', 18)
436     public {
437     }
438 }