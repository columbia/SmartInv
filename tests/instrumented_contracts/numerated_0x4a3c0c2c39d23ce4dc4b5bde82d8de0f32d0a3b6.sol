1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address _who) public view returns (uint256);
11   function transfer(address _to, uint256 _value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21     /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (_a == 0) {
29       return 0;
30     }
31 
32     c = _a * _b;
33     assert(c / _a == _b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     // assert(_b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = _a / _b;
43     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
44     return _a / _b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     assert(_b <= _a);
52     return _a - _b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
59     c = _a + _b;
60     assert(c >= _a);
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
139 
140 /**
141  * @title ERC20 interface
142  * @dev see https://github.com/ethereum/EIPs/issues/20
143  */
144 contract ERC20 is ERC20Basic {
145   function allowance(address _owner, address _spender)
146     public view returns (uint256);
147 
148   function transferFrom(address _from, address _to, uint256 _value)
149     public returns (bool);
150 
151   function approve(address _spender, uint256 _value) public returns (bool);
152   event Approval(
153     address indexed owner,
154     address indexed spender,
155     uint256 value
156   );
157 }
158 
159 
160 /**
161  * @title Standard ERC20 token
162  *
163  * @dev Implementation of the basic standard token.
164  * https://github.com/ethereum/EIPs/issues/20
165  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
166  */
167 contract StandardToken is ERC20, BasicToken {
168 
169   mapping (address => mapping (address => uint256)) internal allowed;
170 
171 
172   /**
173    * @dev Transfer tokens from one address to another
174    * @param _from address The address which you want to send tokens from
175    * @param _to address The address which you want to transfer to
176    * @param _value uint256 the amount of tokens to be transferred
177    */
178   function transferFrom(
179     address _from,
180     address _to,
181     uint256 _value
182   )
183     public
184     returns (bool)
185   {
186     require(_value <= balances[_from]);
187     require(_value <= allowed[_from][msg.sender]);
188     require(_to != address(0));
189 
190     balances[_from] = balances[_from].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193     emit Transfer(_from, _to, _value);
194     return true;
195     }
196 
197   /**
198    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199    * Beware that changing an allowance with this method brings the risk that someone may use both the old
200    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203    * @param _spender The address which will spend the funds.
204    * @param _value The amount of tokens to be spent.
205    */
206   function approve(address _spender, uint256 _value) public returns (bool) {
207     allowed[msg.sender][_spender] = _value;
208     emit Approval(msg.sender, _spender, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Function to check the amount of tokens that an owner allowed to a spender.
214    * @param _owner address The address which owns the funds.
215    * @param _spender address The address which will spend the funds.
216    * @return A uint256 specifying the amount of tokens still available for the spender.
217    */
218   function allowance(
219     address _owner,
220     address _spender
221    )
222     public
223     view
224     returns (uint256)
225   {
226     return allowed[_owner][_spender];
227   }
228 
229   /**
230    * @dev Increase the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To increment
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _addedValue The amount of tokens to increase the allowance by.
237    */
238   function increaseApproval(
239     address _spender,
240     uint256 _addedValue
241   )
242     public
243     returns (bool)
244   {
245     allowed[msg.sender][_spender] = (
246       allowed[msg.sender][_spender].add(_addedValue));
247     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251   /**
252    * @dev Decrease the amount of tokens that an owner allowed to a spender.
253    * approve should be called when allowed[_spender] == 0. To decrement
254    * allowed value is better to use this function to avoid 2 calls (and wait until
255    * the first transaction is mined)
256    * From MonolithDAO Token.sol
257    * @param _spender The address which will spend the funds.
258    * @param _subtractedValue The amount of tokens to decrease the allowance by.
259    */
260   function decreaseApproval(
261     address _spender,
262     uint256 _subtractedValue
263   )
264     public
265     returns (bool)
266   {
267     uint256 oldValue = allowed[msg.sender][_spender];
268     if (_subtractedValue >= oldValue) {
269       allowed[msg.sender][_spender] = 0;
270     } else {
271       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
272     }
273     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274     return true;
275   }
276 
277 }
278 
279 /**
280  * @title Ownable
281  * @dev The Ownable contract has an owner address, and provides basic authorization control
282  * functions, this simplifies the implementation of "user permissions".
283  */
284 contract Ownable {
285   address public owner;
286 
287 
288   event OwnershipRenounced(address indexed previousOwner);
289   event OwnershipTransferred(
290     address indexed previousOwner,
291     address indexed newOwner
292   );
293 
294 
295   /**
296    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
297    * account.
298    */
299   constructor() public {
300     owner = msg.sender;
301   }
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
341  * @title Claimable
342  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
343  * This allows the new owner to accept the transfer.
344  */
345 contract Claimable is Ownable {
346   address public pendingOwner;
347 
348   /**
349    * @dev Modifier throws if called by any account other than the pendingOwner.
350    */
351   modifier onlyPendingOwner() {
352     require(msg.sender == pendingOwner);
353     _;
354   }
355 
356   /**
357    * @dev Allows the current owner to set the pendingOwner address.
358    * @param newOwner The address to transfer ownership to.
359    */
360   function transferOwnership(address newOwner) public onlyOwner {
361     pendingOwner = newOwner;
362   }
363 
364   /**
365    * @dev Allows the pendingOwner address to finalize the transfer.
366    */
367   function claimOwnership() public onlyPendingOwner {
368     emit OwnershipTransferred(owner, pendingOwner);
369     owner = pendingOwner;
370     pendingOwner = address(0);
371   }
372 }
373 
374 /**
375  * @title TMNK
376  *
377  * Symbol      : TMNK
378  * Name        : TMNK
379  * Total supply: 2800000.000000000000000000
380  * Decimals    : 18
381  *
382  */
383 contract TMNK is StandardToken, Claimable, BurnableToken {
384     using SafeMath for uint256;
385 
386     string public constant name = "TMNK";
387     string public constant symbol = "TMNK";
388     uint8 public constant decimals = 18;
389 
390     uint256 public constant INITIAL_SUPPLY = 2800000 * (10 ** uint256(decimals));
391 
392     /**
393     * @dev Constructor that gives msg.sender all of existing tokens.
394     */
395     constructor () public {
396         totalSupply_ = INITIAL_SUPPLY;
397         balances[msg.sender] = INITIAL_SUPPLY;
398         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
399     }
400 
401     /**
402     * @dev Owner can transfer out any accidentally sent ERC20 tokens
403     */
404     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
405         return ERC20Basic(tokenAddress).transfer(owner, tokens);
406     }
407 }