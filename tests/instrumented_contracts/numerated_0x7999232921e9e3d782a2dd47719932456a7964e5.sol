1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (a == 0) {
33       return 0;
34     }
35 
36     c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return a / b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63     c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
116 
117 /**
118  * @title Burnable Token
119  * @dev Token that can be irreversibly burned (destroyed).
120  */
121 contract BurnableToken is BasicToken {
122 
123   event Burn(address indexed burner, uint256 value);
124 
125   /**
126    * @dev Burns a specific amount of tokens.
127    * @param _value The amount of token to be burned.
128    */
129   function burn(uint256 _value) public {
130     _burn(msg.sender, _value);
131   }
132 
133   function _burn(address _who, uint256 _value) internal {
134     require(_value <= balances[_who]);
135     // no need to require value <= totalSupply, since that would imply the
136     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
137 
138     balances[_who] = balances[_who].sub(_value);
139     totalSupply_ = totalSupply_.sub(_value);
140     emit Burn(_who, _value);
141     emit Transfer(_who, address(0), _value);
142   }
143 }
144 
145 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
146 
147 /**
148  * @title ERC20 interface
149  * @dev see https://github.com/ethereum/EIPs/issues/20
150  */
151 contract ERC20 is ERC20Basic {
152   function allowance(address owner, address spender)
153     public view returns (uint256);
154 
155   function transferFrom(address from, address to, uint256 value)
156     public returns (bool);
157 
158   function approve(address spender, uint256 value) public returns (bool);
159   event Approval(
160     address indexed owner,
161     address indexed spender,
162     uint256 value
163   );
164 }
165 
166 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(
187     address _from,
188     address _to,
189     uint256 _value
190   )
191     public
192     returns (bool)
193   {
194     require(_to != address(0));
195     require(_value <= balances[_from]);
196     require(_value <= allowed[_from][msg.sender]);
197 
198     balances[_from] = balances[_from].sub(_value);
199     balances[_to] = balances[_to].add(_value);
200     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
201     emit Transfer(_from, _to, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
207    *
208    * Beware that changing an allowance with this method brings the risk that someone may use both the old
209    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
210    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
211    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212    * @param _spender The address which will spend the funds.
213    * @param _value The amount of tokens to be spent.
214    */
215   function approve(address _spender, uint256 _value) public returns (bool) {
216     allowed[msg.sender][_spender] = _value;
217     emit Approval(msg.sender, _spender, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Function to check the amount of tokens that an owner allowed to a spender.
223    * @param _owner address The address which owns the funds.
224    * @param _spender address The address which will spend the funds.
225    * @return A uint256 specifying the amount of tokens still available for the spender.
226    */
227   function allowance(
228     address _owner,
229     address _spender
230    )
231     public
232     view
233     returns (uint256)
234   {
235     return allowed[_owner][_spender];
236   }
237 
238   /**
239    * @dev Increase the amount of tokens that an owner allowed to a spender.
240    *
241    * approve should be called when allowed[_spender] == 0. To increment
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param _spender The address which will spend the funds.
246    * @param _addedValue The amount of tokens to increase the allowance by.
247    */
248   function increaseApproval(
249     address _spender,
250     uint _addedValue
251   )
252     public
253     returns (bool)
254   {
255     allowed[msg.sender][_spender] = (
256       allowed[msg.sender][_spender].add(_addedValue));
257     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261   /**
262    * @dev Decrease the amount of tokens that an owner allowed to a spender.
263    *
264    * approve should be called when allowed[_spender] == 0. To decrement
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _subtractedValue The amount of tokens to decrease the allowance by.
270    */
271   function decreaseApproval(
272     address _spender,
273     uint _subtractedValue
274   )
275     public
276     returns (bool)
277   {
278     uint oldValue = allowed[msg.sender][_spender];
279     if (_subtractedValue > oldValue) {
280       allowed[msg.sender][_spender] = 0;
281     } else {
282       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
283     }
284     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288 }
289 
290 // File: openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
291 
292 /**
293  * @title Standard Burnable Token
294  * @dev Adds burnFrom method to ERC20 implementations
295  */
296 contract StandardBurnableToken is BurnableToken, StandardToken {
297 
298   /**
299    * @dev Burns a specific amount of tokens from the target address and decrements allowance
300    * @param _from address The address which you want to send tokens from
301    * @param _value uint256 The amount of token to be burned
302    */
303   function burnFrom(address _from, uint256 _value) public {
304     require(_value <= allowed[_from][msg.sender]);
305     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
306     // this function needs to emit an event with the updated approval.
307     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
308     _burn(_from, _value);
309   }
310 }
311 
312 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
313 
314 /**
315  * @title DetailedERC20 token
316  * @dev The decimals are only for visualization purposes.
317  * All the operations are done using the smallest and indivisible token unit,
318  * just as on Ethereum all the operations are done in wei.
319  */
320 contract DetailedERC20 is ERC20 {
321   string public name;
322   string public symbol;
323   uint8 public decimals;
324 
325   constructor(string _name, string _symbol, uint8 _decimals) public {
326     name = _name;
327     symbol = _symbol;
328     decimals = _decimals;
329   }
330 }
331 
332 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
333 
334 /**
335  * @title Ownable
336  * @dev The Ownable contract has an owner address, and provides basic authorization control
337  * functions, this simplifies the implementation of "user permissions".
338  */
339 contract Ownable {
340   address public owner;
341 
342 
343   event OwnershipRenounced(address indexed previousOwner);
344   event OwnershipTransferred(
345     address indexed previousOwner,
346     address indexed newOwner
347   );
348 
349 
350   /**
351    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
352    * account.
353    */
354   constructor() public {
355     owner = msg.sender;
356   }
357 
358   /**
359    * @dev Throws if called by any account other than the owner.
360    */
361   modifier onlyOwner() {
362     require(msg.sender == owner);
363     _;
364   }
365 
366   /**
367    * @dev Allows the current owner to relinquish control of the contract.
368    */
369   function renounceOwnership() public onlyOwner {
370     emit OwnershipRenounced(owner);
371     owner = address(0);
372   }
373 
374   /**
375    * @dev Allows the current owner to transfer control of the contract to a newOwner.
376    * @param _newOwner The address to transfer ownership to.
377    */
378   function transferOwnership(address _newOwner) public onlyOwner {
379     _transferOwnership(_newOwner);
380   }
381 
382   /**
383    * @dev Transfers control of the contract to a newOwner.
384    * @param _newOwner The address to transfer ownership to.
385    */
386   function _transferOwnership(address _newOwner) internal {
387     require(_newOwner != address(0));
388     emit OwnershipTransferred(owner, _newOwner);
389     owner = _newOwner;
390   }
391 }
392 
393 // File: contracts/SudanGoldCoinToken.sol
394 
395 contract SudanGoldCoinToken is StandardBurnableToken, DetailedERC20, Ownable {
396   uint8 public constant decimals = 18;
397 
398   uint256 public TOKENS_NOT_FOR_SALE = 7700000 * (10 ** uint256(decimals));
399   uint256 public MAX_SUPPLY = 25000000 * (10 ** uint256(decimals));
400   uint256 public usedTokens = 0;
401 
402   constructor() public DetailedERC20('Sudan Gold Coin', 'SGC', decimals) {
403     totalSupply_ = MAX_SUPPLY;
404     sendTokens(msg.sender, TOKENS_NOT_FOR_SALE);
405   }
406 
407   function sendTokens(address addr, uint256 tokens) public onlyOwner returns (bool) {
408     require(addr != address(0));
409     require(tokens > 0);
410 
411     usedTokens = usedTokens.add(tokens);
412     require(usedTokens <= MAX_SUPPLY);
413 
414     balances[addr] = balances[addr].add(tokens);
415     emit Transfer(address(0), addr, tokens);
416 
417     return true;
418   }
419 }