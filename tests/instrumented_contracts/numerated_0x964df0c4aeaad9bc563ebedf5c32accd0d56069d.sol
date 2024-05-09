1 pragma solidity ^0.4.24;
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
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * See https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61   function totalSupply() public view returns (uint256);
62   function balanceOf(address _who) public view returns (uint256);
63   function transfer(address _to, uint256 _value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances.
71  */
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) internal balances;
76 
77   uint256 internal totalSupply_;
78 
79   /**
80   * @dev Total number of tokens in existence
81   */
82   function totalSupply() public view returns (uint256) {
83     return totalSupply_;
84   }
85 
86   /**
87   * @dev Transfer token for a specified address
88   * @param _to The address to transfer to.
89   * @param _value The amount to be transferred.
90   */
91   function transfer(address _to, uint256 _value) public returns (bool) {
92     require(_value <= balances[msg.sender]);
93     require(_to != address(0));
94 
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 
113 
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120   function allowance(address _owner, address _spender)
121     public view returns (uint256);
122 
123   function transferFrom(address _from, address _to, uint256 _value)
124     public returns (bool);
125 
126   function approve(address _spender, uint256 _value) public returns (bool);
127   event Approval(
128     address indexed owner,
129     address indexed spender,
130     uint256 value
131   );
132 }
133 
134 
135 
136 /**
137  * @title Standard ERC20 token
138  *
139  * @dev Implementation of the basic standard token.
140  * https://github.com/ethereum/EIPs/issues/20
141  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
142  */
143 contract StandardToken is ERC20, BasicToken {
144 
145   mapping (address => mapping (address => uint256)) internal allowed;
146 
147 
148   /**
149    * @dev Transfer tokens from one address to another
150    * @param _from address The address which you want to send tokens from
151    * @param _to address The address which you want to transfer to
152    * @param _value uint256 the amount of tokens to be transferred
153    */
154   function transferFrom(
155     address _from,
156     address _to,
157     uint256 _value
158   )
159     public
160     returns (bool)
161   {
162     require(_value <= balances[_from]);
163     require(_value <= allowed[_from][msg.sender]);
164     require(_to != address(0));
165 
166     balances[_from] = balances[_from].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169     emit Transfer(_from, _to, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175    * Beware that changing an allowance with this method brings the risk that someone may use both the old
176    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179    * @param _spender The address which will spend the funds.
180    * @param _value The amount of tokens to be spent.
181    */
182   function approve(address _spender, uint256 _value) public returns (bool) {
183     allowed[msg.sender][_spender] = _value;
184     emit Approval(msg.sender, _spender, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Function to check the amount of tokens that an owner allowed to a spender.
190    * @param _owner address The address which owns the funds.
191    * @param _spender address The address which will spend the funds.
192    * @return A uint256 specifying the amount of tokens still available for the spender.
193    */
194   function allowance(
195     address _owner,
196     address _spender
197    )
198     public
199     view
200     returns (uint256)
201   {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    * approve should be called when allowed[_spender] == 0. To increment
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    * @param _spender The address which will spend the funds.
212    * @param _addedValue The amount of tokens to increase the allowance by.
213    */
214   function increaseApproval(
215     address _spender,
216     uint256 _addedValue
217   )
218     public
219     returns (bool)
220   {
221     allowed[msg.sender][_spender] = (
222       allowed[msg.sender][_spender].add(_addedValue));
223     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224     return true;
225   }
226 
227   /**
228    * @dev Decrease the amount of tokens that an owner allowed to a spender.
229    * approve should be called when allowed[_spender] == 0. To decrement
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _subtractedValue The amount of tokens to decrease the allowance by.
235    */
236   function decreaseApproval(
237     address _spender,
238     uint256 _subtractedValue
239   )
240     public
241     returns (bool)
242   {
243     uint256 oldValue = allowed[msg.sender][_spender];
244     if (_subtractedValue >= oldValue) {
245       allowed[msg.sender][_spender] = 0;
246     } else {
247       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
248     }
249     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253 }
254 
255 
256 /**
257  * @title Ownable
258  * @dev The Ownable contract has an owner address, and provides basic authorization control
259  * functions, this simplifies the implementation of "user permissions".
260  */
261 contract Ownable {
262   address public owner;
263 
264 
265   event OwnershipRenounced(address indexed previousOwner);
266   event OwnershipTransferred(
267     address indexed previousOwner,
268     address indexed newOwner
269   );
270 
271 
272   /**
273    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
274    * account.
275    */
276   constructor() public {
277     owner = msg.sender;
278   }
279 
280   /**
281    * @dev Throws if called by any account other than the owner.
282    */
283   modifier onlyOwner() {
284     require(msg.sender == owner);
285     _;
286   }
287 
288   /**
289    * @dev Allows the current owner to relinquish control of the contract.
290    * @notice Renouncing to ownership will leave the contract without an owner.
291    * It will not be possible to call the functions with the `onlyOwner`
292    * modifier anymore.
293    */
294   function renounceOwnership() public onlyOwner {
295     emit OwnershipRenounced(owner);
296     owner = address(0);
297   }
298 
299   /**
300    * @dev Allows the current owner to transfer control of the contract to a newOwner.
301    * @param _newOwner The address to transfer ownership to.
302    */
303   function transferOwnership(address _newOwner) public onlyOwner {
304     _transferOwnership(_newOwner);
305   }
306 
307   /**
308    * @dev Transfers control of the contract to a newOwner.
309    * @param _newOwner The address to transfer ownership to.
310    */
311   function _transferOwnership(address _newOwner) internal {
312     require(_newOwner != address(0));
313     emit OwnershipTransferred(owner, _newOwner);
314     owner = _newOwner;
315   }
316 }
317 
318 
319 
320 /**
321  * @title Mintable token
322  * @dev Simple ERC20 Token example, with mintable token creation
323  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
324  */
325 contract MintableToken is StandardToken, Ownable {
326   event Mint(address indexed to, uint256 amount);
327   event MintFinished();
328 
329   bool public mintingFinished = false;
330 
331 
332   modifier canMint() {
333     require(!mintingFinished);
334     _;
335   }
336 
337   modifier hasMintPermission() {
338     require(msg.sender == owner);
339     _;
340   }
341 
342   /**
343    * @dev Function to mint tokens
344    * @param _to The address that will receive the minted tokens.
345    * @param _amount The amount of tokens to mint.
346    * @return A boolean that indicates if the operation was successful.
347    */
348   function mint(
349     address _to,
350     uint256 _amount
351   )
352     public
353     hasMintPermission
354     canMint
355     returns (bool)
356   {
357     totalSupply_ = totalSupply_.add(_amount);
358     balances[_to] = balances[_to].add(_amount);
359     emit Mint(_to, _amount);
360     emit Transfer(address(0), _to, _amount);
361     return true;
362   }
363 
364   /**
365    * @dev Function to stop minting new tokens.
366    * @return True if the operation was successful.
367    */
368   function finishMinting() public onlyOwner canMint returns (bool) {
369     mintingFinished = true;
370     emit MintFinished();
371     return true;
372   }
373 }
374 
375 
376 
377 /**
378  * @title Capped token
379  * @dev Mintable token with a token cap.
380  */
381 contract CappedToken is MintableToken {
382 
383   uint256 public cap;
384 
385   constructor(uint256 _cap) public {
386     require(_cap > 0);
387     cap = _cap;
388   }
389 
390   /**
391    * @dev Function to mint tokens
392    * @param _to The address that will receive the minted tokens.
393    * @param _amount The amount of tokens to mint.
394    * @return A boolean that indicates if the operation was successful.
395    */
396   function mint(
397     address _to,
398     uint256 _amount
399   )
400     public
401     returns (bool)
402   {
403     require(totalSupply_.add(_amount) <= cap);
404 
405     return super.mint(_to, _amount);
406   }
407 
408 }
409 
410 
411 contract D24Token is CappedToken {
412   string public name = "D24Token"; 
413   string public symbol = "D24";
414   uint public decimals = 18;
415   uint public INITIAL_SUPPLY = 60000000 * (10 ** decimals);
416 
417   constructor() public 
418   CappedToken(200000000 * (10 ** decimals)){
419     totalSupply_ = INITIAL_SUPPLY;
420     balances[0x8cCD2c58eE67eB628366De4Bc4A8A4594B09528E] = 28000000 * (10 ** decimals);
421     balances[0x7A9767810585ECf7aF8487085bF2b58A83Fa1c36] = 32000000 * (10 ** decimals);
422  
423   }
424 }