1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
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
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
66 
67 /**
68  * @title ERC20Basic
69  * @dev Simpler version of ERC20 interface
70  * See https://github.com/ethereum/EIPs/issues/179
71  */
72 contract ERC20Basic {
73   function totalSupply() public view returns (uint256);
74   function balanceOf(address _who) public view returns (uint256);
75   function transfer(address _to, uint256 _value) public returns (bool);
76   event Transfer(address indexed from, address indexed to, uint256 value);
77 }
78 
79 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
80 
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that throw on error
84  */
85 library SafeMath {
86 
87   /**
88   * @dev Multiplies two numbers, throws on overflow.
89   */
90   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
91     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
92     // benefit is lost if 'b' is also tested.
93     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
94     if (_a == 0) {
95       return 0;
96     }
97 
98     c = _a * _b;
99     assert(c / _a == _b);
100     return c;
101   }
102 
103   /**
104   * @dev Integer division of two numbers, truncating the quotient.
105   */
106   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
107     // assert(_b > 0); // Solidity automatically throws when dividing by 0
108     // uint256 c = _a / _b;
109     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
110     return _a / _b;
111   }
112 
113   /**
114   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
115   */
116   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
117     assert(_b <= _a);
118     return _a - _b;
119   }
120 
121   /**
122   * @dev Adds two numbers, throws on overflow.
123   */
124   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
125     c = _a + _b;
126     assert(c >= _a);
127     return c;
128   }
129 }
130 
131 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
132 
133 /**
134  * @title Basic token
135  * @dev Basic version of StandardToken, with no allowances.
136  */
137 contract BasicToken is ERC20Basic {
138   using SafeMath for uint256;
139 
140   mapping(address => uint256) internal balances;
141 
142   uint256 internal totalSupply_;
143 
144   /**
145   * @dev Total number of tokens in existence
146   */
147   function totalSupply() public view returns (uint256) {
148     return totalSupply_;
149   }
150 
151   /**
152   * @dev Transfer token for a specified address
153   * @param _to The address to transfer to.
154   * @param _value The amount to be transferred.
155   */
156   function transfer(address _to, uint256 _value) public returns (bool) {
157     require(_value <= balances[msg.sender]);
158     require(_to != address(0));
159 
160     balances[msg.sender] = balances[msg.sender].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     emit Transfer(msg.sender, _to, _value);
163     return true;
164   }
165 
166   /**
167   * @dev Gets the balance of the specified address.
168   * @param _owner The address to query the the balance of.
169   * @return An uint256 representing the amount owned by the passed address.
170   */
171   function balanceOf(address _owner) public view returns (uint256) {
172     return balances[_owner];
173   }
174 }
175 
176 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
177 
178 /**
179  * @title ERC20 interface
180  * @dev see https://github.com/ethereum/EIPs/issues/20
181  */
182 contract ERC20 is ERC20Basic {
183   function allowance(address _owner, address _spender)
184     public view returns (uint256);
185 
186   function transferFrom(address _from, address _to, uint256 _value)
187     public returns (bool);
188 
189   function approve(address _spender, uint256 _value) public returns (bool);
190   event Approval(
191     address indexed owner,
192     address indexed spender,
193     uint256 value
194   );
195 }
196 
197 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
198 
199 /**
200  * @title Standard ERC20 token
201  *
202  * @dev Implementation of the basic standard token.
203  * https://github.com/ethereum/EIPs/issues/20
204  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
205  */
206 contract StandardToken is ERC20, BasicToken {
207 
208   mapping (address => mapping (address => uint256)) internal allowed;
209 
210   /**
211    * @dev Transfer tokens from one address to another
212    * @param _from address The address which you want to send tokens from
213    * @param _to address The address which you want to transfer to
214    * @param _value uint256 the amount of tokens to be transferred
215    */
216   function transferFrom(
217     address _from,
218     address _to,
219     uint256 _value
220   )
221     public
222     returns (bool)
223   {
224     require(_value <= balances[_from]);
225     require(_value <= allowed[_from][msg.sender]);
226     require(_to != address(0));
227 
228     balances[_from] = balances[_from].sub(_value);
229     balances[_to] = balances[_to].add(_value);
230     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
231     emit Transfer(_from, _to, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
237    * Beware that changing an allowance with this method brings the risk that someone may use both the old
238    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
239    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
240    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241    * @param _spender The address which will spend the funds.
242    * @param _value The amount of tokens to be spent.
243    */
244   function approve(address _spender, uint256 _value) public returns (bool) {
245     allowed[msg.sender][_spender] = _value;
246     emit Approval(msg.sender, _spender, _value);
247     return true;
248   }
249 
250   /**
251    * @dev Function to check the amount of tokens that an owner allowed to a spender.
252    * @param _owner address The address which owns the funds.
253    * @param _spender address The address which will spend the funds.
254    * @return A uint256 specifying the amount of tokens still available for the spender.
255    */
256   function allowance(
257     address _owner,
258     address _spender
259    )
260     public
261     view
262     returns (uint256)
263   {
264     return allowed[_owner][_spender];
265   }
266 
267   /**
268    * @dev Increase the amount of tokens that an owner allowed to a spender.
269    * approve should be called when allowed[_spender] == 0. To increment
270    * allowed value is better to use this function to avoid 2 calls (and wait until
271    * the first transaction is mined)
272    * From MonolithDAO Token.sol
273    * @param _spender The address which will spend the funds.
274    * @param _addedValue The amount of tokens to increase the allowance by.
275    */
276   function increaseApproval(
277     address _spender,
278     uint256 _addedValue
279   )
280     public
281     returns (bool)
282   {
283     allowed[msg.sender][_spender] = (
284       allowed[msg.sender][_spender].add(_addedValue));
285     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
286     return true;
287   }
288 
289   /**
290    * @dev Decrease the amount of tokens that an owner allowed to a spender.
291    * approve should be called when allowed[_spender] == 0. To decrement
292    * allowed value is better to use this function to avoid 2 calls (and wait until
293    * the first transaction is mined)
294    * From MonolithDAO Token.sol
295    * @param _spender The address which will spend the funds.
296    * @param _subtractedValue The amount of tokens to decrease the allowance by.
297    */
298   function decreaseApproval(
299     address _spender,
300     uint256 _subtractedValue
301   )
302     public
303     returns (bool)
304   {
305     uint256 oldValue = allowed[msg.sender][_spender];
306     if (_subtractedValue >= oldValue) {
307       allowed[msg.sender][_spender] = 0;
308     } else {
309       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
310     }
311     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
312     return true;
313   }
314 }
315 
316 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
317 
318 /**
319  * @title Burnable Token
320  * @dev Token that can be irreversibly burned (destroyed).
321  */
322 contract BurnableToken is BasicToken {
323 
324   event Burn(address indexed burner, uint256 value);
325 
326   /**
327    * @dev Burns a specific amount of tokens.
328    * @param _value The amount of token to be burned.
329    */
330   function burn(uint256 _value) public {
331     _burn(msg.sender, _value);
332   }
333 
334   function _burn(address _who, uint256 _value) internal {
335     require(_value <= balances[_who]);
336     // no need to require value <= totalSupply, since that would imply the
337     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
338 
339     balances[_who] = balances[_who].sub(_value);
340     totalSupply_ = totalSupply_.sub(_value);
341     emit Burn(_who, _value);
342     emit Transfer(_who, address(0), _value);
343   }
344 }
345 
346 // File: openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
347 
348 /**
349  * @title Standard Burnable Token
350  * @dev Adds burnFrom method to ERC20 implementations
351  */
352 contract StandardBurnableToken is BurnableToken, StandardToken {
353 
354   /**
355    * @dev Burns a specific amount of tokens from the target address and decrements allowance
356    * @param _from address The address which you want to send tokens from
357    * @param _value uint256 The amount of token to be burned
358    */
359   function burnFrom(address _from, uint256 _value) public {
360     require(_value <= allowed[_from][msg.sender]);
361     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
362     // this function needs to emit an event with the updated approval.
363     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
364     _burn(_from, _value);
365   }
366 }
367 
368 // File: contracts/Amplify.sol
369 
370 contract Amplify is StandardBurnableToken, Ownable {
371     string public constant name = "Amplify";
372     string public constant symbol = "AMPX";
373     uint8 public constant decimals = 18;
374     bool public crowdsaleActive = true;
375 
376     // 1.2 billion tokens * decimal places (10^18)
377     uint256 public constant INITIAL_SUPPLY = 1200000000000000000000000000;
378 
379     constructor() public {
380         totalSupply_ = INITIAL_SUPPLY;
381         balances[msg.sender] = INITIAL_SUPPLY;
382         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
383     }
384 
385     modifier afterCrowdsale {
386         require(
387             msg.sender == owner || !crowdsaleActive,
388               "Transfers are not allowed until after the crowdsale."
389         );
390         _;
391     }
392 
393     function endCrowdsale() public onlyOwner {
394         crowdsaleActive = false;
395     }
396 
397     function transfer(address _to, uint256 _value) public afterCrowdsale returns (bool) {
398         return BasicToken.transfer(_to, _value);
399     }
400 
401     function approve(address _spender, uint256 _value) public returns (bool) {
402         require(_value == 0 || allowed[msg.sender][_spender] == 0, "Use increaseApproval or decreaseApproval to prevent double-spend.");
403 
404         return StandardToken.approve(_spender, _value);
405     }
406 
407     function transferFrom(address _from, address _to, uint256 _value) public afterCrowdsale returns (bool) {
408         return StandardToken.transferFrom(_from, _to, _value);
409     }
410 }