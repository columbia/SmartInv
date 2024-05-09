1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
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
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
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
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
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
152   function allowance(address _owner, address _spender)
153     public view returns (uint256);
154 
155   function transferFrom(address _from, address _to, uint256 _value)
156     public returns (bool);
157 
158   function approve(address _spender, uint256 _value) public returns (bool);
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
172  * https://github.com/ethereum/EIPs/issues/20
173  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
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
194     require(_value <= balances[_from]);
195     require(_value <= allowed[_from][msg.sender]);
196     require(_to != address(0));
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
207    * Beware that changing an allowance with this method brings the risk that someone may use both the old
208    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
209    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
210    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211    * @param _spender The address which will spend the funds.
212    * @param _value The amount of tokens to be spent.
213    */
214   function approve(address _spender, uint256 _value) public returns (bool) {
215     allowed[msg.sender][_spender] = _value;
216     emit Approval(msg.sender, _spender, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Function to check the amount of tokens that an owner allowed to a spender.
222    * @param _owner address The address which owns the funds.
223    * @param _spender address The address which will spend the funds.
224    * @return A uint256 specifying the amount of tokens still available for the spender.
225    */
226   function allowance(
227     address _owner,
228     address _spender
229    )
230     public
231     view
232     returns (uint256)
233   {
234     return allowed[_owner][_spender];
235   }
236 
237   /**
238    * @dev Increase the amount of tokens that an owner allowed to a spender.
239    * approve should be called when allowed[_spender] == 0. To increment
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _addedValue The amount of tokens to increase the allowance by.
245    */
246   function increaseApproval(
247     address _spender,
248     uint256 _addedValue
249   )
250     public
251     returns (bool)
252   {
253     allowed[msg.sender][_spender] = (
254       allowed[msg.sender][_spender].add(_addedValue));
255     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259   /**
260    * @dev Decrease the amount of tokens that an owner allowed to a spender.
261    * approve should be called when allowed[_spender] == 0. To decrement
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _subtractedValue The amount of tokens to decrease the allowance by.
267    */
268   function decreaseApproval(
269     address _spender,
270     uint256 _subtractedValue
271   )
272     public
273     returns (bool)
274   {
275     uint256 oldValue = allowed[msg.sender][_spender];
276     if (_subtractedValue >= oldValue) {
277       allowed[msg.sender][_spender] = 0;
278     } else {
279       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
280     }
281     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 
285 }
286 
287 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
288 
289 /**
290  * @title Ownable
291  * @dev The Ownable contract has an owner address, and provides basic authorization control
292  * functions, this simplifies the implementation of "user permissions".
293  */
294 contract Ownable {
295   address public owner;
296 
297 
298   event OwnershipRenounced(address indexed previousOwner);
299   event OwnershipTransferred(
300     address indexed previousOwner,
301     address indexed newOwner
302   );
303 
304 
305   /**
306    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
307    * account.
308    */
309   constructor() public {
310     owner = msg.sender;
311   }
312 
313   /**
314    * @dev Throws if called by any account other than the owner.
315    */
316   modifier onlyOwner() {
317     require(msg.sender == owner);
318     _;
319   }
320 
321   /**
322    * @dev Allows the current owner to relinquish control of the contract.
323    * @notice Renouncing to ownership will leave the contract without an owner.
324    * It will not be possible to call the functions with the `onlyOwner`
325    * modifier anymore.
326    */
327   function renounceOwnership() public onlyOwner {
328     emit OwnershipRenounced(owner);
329     owner = address(0);
330   }
331 
332   /**
333    * @dev Allows the current owner to transfer control of the contract to a newOwner.
334    * @param _newOwner The address to transfer ownership to.
335    */
336   function transferOwnership(address _newOwner) public onlyOwner {
337     _transferOwnership(_newOwner);
338   }
339 
340   /**
341    * @dev Transfers control of the contract to a newOwner.
342    * @param _newOwner The address to transfer ownership to.
343    */
344   function _transferOwnership(address _newOwner) internal {
345     require(_newOwner != address(0));
346     emit OwnershipTransferred(owner, _newOwner);
347     owner = _newOwner;
348   }
349 }
350 
351 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
352 
353 /**
354  * @title Claimable
355  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
356  * This allows the new owner to accept the transfer.
357  */
358 contract Claimable is Ownable {
359   address public pendingOwner;
360 
361   /**
362    * @dev Modifier throws if called by any account other than the pendingOwner.
363    */
364   modifier onlyPendingOwner() {
365     require(msg.sender == pendingOwner);
366     _;
367   }
368 
369   /**
370    * @dev Allows the current owner to set the pendingOwner address.
371    * @param newOwner The address to transfer ownership to.
372    */
373   function transferOwnership(address newOwner) public onlyOwner {
374     pendingOwner = newOwner;
375   }
376 
377   /**
378    * @dev Allows the pendingOwner address to finalize the transfer.
379    */
380   function claimOwnership() public onlyPendingOwner {
381     emit OwnershipTransferred(owner, pendingOwner);
382     owner = pendingOwner;
383     pendingOwner = address(0);
384   }
385 }
386 
387 // File: contracts/ZeroCarbon.sol
388 
389 /**
390  * @title ZeroCarbon
391  * 
392  * Symbol      : ZCC
393  * Name        : Zero Carbon
394  * Total supply: 240,000,000.000000000000000000
395  * Decimals    : 18
396  *
397  * (c) Philip Louw / Zero Carbon Project 2018. The MIT Licence.
398  */
399 contract ZeroCarbon is StandardToken, Claimable, BurnableToken {
400     using SafeMath for uint256;
401 
402     string public constant name = "ZeroCarbon"; // solium-disable-line uppercase
403     string public constant symbol = "ZCC"; // solium-disable-line uppercase
404     uint8 public constant decimals = 18; // solium-disable-line uppercase
405 
406     uint256 public constant INITIAL_SUPPLY = 240000000 * (10 ** uint256(decimals));
407 
408     /**
409     * @dev Constructor that gives msg.sender all of existing tokens.
410     */
411     constructor () public {
412         totalSupply_ = INITIAL_SUPPLY;
413         balances[msg.sender] = INITIAL_SUPPLY;
414         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
415     }
416 
417     /**
418     * @dev Owner can transfer out any accidentally sent ERC20 tokens
419     */
420     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
421         return ERC20Basic(tokenAddress).transfer(owner, tokens);
422     }  
423 }