1 pragma solidity ^0.4.24;
2 
3   /**
4   * @dev ERC20 Token standard:  https://github.com/ethereum/EIPs/issues/20.
5   * Reference the openzeppelin-solidity:
6   * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol
7   */
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15   /**
16   * @dev Multiplies two numbers, throws on overflow.
17   */
18   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
19     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
20     // benefit is lost if 'b' is also tested.
21     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
22     if (_a == 0) {
23       return 0;
24     }
25 
26     c = _a * _b;
27     assert(c / _a == _b);
28     return c;
29   }
30 
31   /**
32   * @dev Integer division of two numbers, truncating the quotient.
33   */
34   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     // assert(_b > 0); // Solidity automatically throws when dividing by 0
36     // uint256 c = _a / _b;
37     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
38     return _a / _b;
39   }
40 
41   /**
42   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43   */
44   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     assert(_b <= _a);
46     return _a - _b;
47   }
48 
49   /**
50   * @dev Adds two numbers, throws on overflow.
51   */
52   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
53     c = _a + _b;
54     assert(c >= _a);
55     return c;
56   }
57 }
58 
59 /**
60  * @title ERC20Basic
61  * @dev Simpler version of ERC20 interface
62  * See https://github.com/ethereum/EIPs/issues/179
63  */
64 contract ERC20Basic {
65   function totalSupply() public view returns (uint256);
66   function balanceOf(address _who) public view returns (uint256);
67   function transfer(address _to, uint256 _value) public returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 
72 /**
73  * @title ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 contract ERC20 is ERC20Basic {
77   function allowance(address _owner, address _spender)
78     public view returns (uint256);
79 
80   function transferFrom(address _from, address _to, uint256 _value)
81     public returns (bool);
82 
83   function approve(address _spender, uint256 _value) public returns (bool);
84   event Approval(
85     address indexed owner,
86     address indexed spender,
87     uint256 value
88   );
89 }
90 
91 /**
92  * @title Basic token
93  * @dev Basic version of StandardToken, with no allowances.
94  */
95 contract BasicToken is ERC20Basic {
96   using SafeMath for uint256;
97 
98   mapping(address => uint256) internal balances;
99 
100   uint256 internal totalSupply_;
101 
102   /**
103   * @dev Total number of tokens in existence
104   */
105   function totalSupply() public view returns (uint256) {
106     return totalSupply_;
107   }
108 
109   /**
110   * @dev Transfer token for a specified address
111   * @param _to The address to transfer to.
112   * @param _value The amount to be transferred.
113   */
114   function transfer(address _to, uint256 _value) public returns (bool) {
115     require(_value <= balances[msg.sender]);
116     require(_to != address(0));
117 
118     balances[msg.sender] = balances[msg.sender].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     emit Transfer(msg.sender, _to, _value);
121     return true;
122   }
123 
124   /**
125   * @dev Gets the balance of the specified address.
126   * @param _owner The address to query the the balance of.
127   * @return An uint256 representing the amount owned by the passed address.
128   */
129   function balanceOf(address _owner) public view returns (uint256) {
130     return balances[_owner];
131   }
132 
133 }
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
255 /**
256  * @title Ownable
257  * @dev The Ownable contract has an owner address, and provides basic authorization control
258  * functions, this simplifies the implementation of "user permissions".
259  */
260 contract Ownable {
261   address public owner;
262 
263 
264   event OwnershipRenounced(address indexed previousOwner);
265   event OwnershipTransferred(
266     address indexed previousOwner,
267     address indexed newOwner
268   );
269 
270 
271   /**
272    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
273    * account.
274    */
275   constructor() public {
276     owner = msg.sender;
277   }
278 
279   /**
280    * @dev Throws if called by any account other than the owner.
281    */
282   modifier onlyOwner() {
283     require(msg.sender == owner);
284     _;
285   }
286 
287   /**
288    * @dev Allows the current owner to relinquish control of the contract.
289    * @notice Renouncing to ownership will leave the contract without an owner.
290    * It will not be possible to call the functions with the `onlyOwner`
291    * modifier anymore.
292    */
293   function renounceOwnership() public onlyOwner {
294     emit OwnershipRenounced(owner);
295     owner = address(0);
296   }
297 
298   /**
299    * @dev Allows the current owner to transfer control of the contract to a newOwner.
300    * @param _newOwner The address to transfer ownership to.
301    */
302   function transferOwnership(address _newOwner) public onlyOwner {
303     _transferOwnership(_newOwner);
304   }
305 
306   /**
307    * @dev Transfers control of the contract to a newOwner.
308    * @param _newOwner The address to transfer ownership to.
309    */
310   function _transferOwnership(address _newOwner) internal {
311     require(_newOwner != address(0));
312     emit OwnershipTransferred(owner, _newOwner);
313     owner = _newOwner;
314   }
315 }
316 
317 
318 /**
319  * @title Mintable token
320  * @dev Simple ERC20 Token example, with mintable token creation
321  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
322  */
323 contract MintableToken is StandardToken, Ownable {
324   event Mint(address indexed to, uint256 amount);
325   event MintFinished();
326 
327   bool public mintingFinished = false;
328 
329 
330   modifier canMint() {
331     require(!mintingFinished);
332     _;
333   }
334 
335   modifier hasMintPermission() {
336     require(msg.sender == owner);
337     _;
338   }
339 
340   /**
341    * @dev Function to mint tokens
342    * @param _to The address that will receive the minted tokens.
343    * @param _amount The amount of tokens to mint.
344    * @return A boolean that indicates if the operation was successful.
345    */
346   function mint(
347     address _to,
348     uint256 _amount
349   )
350     public
351     hasMintPermission
352     canMint
353     returns (bool)
354   {
355     totalSupply_ = totalSupply_.add(_amount);
356     balances[_to] = balances[_to].add(_amount);
357     emit Mint(_to, _amount);
358     emit Transfer(address(0), _to, _amount);
359     return true;
360   }
361 
362   /**
363    * @dev Function to stop minting new tokens.
364    * @return True if the operation was successful.
365    */
366   function finishMinting() public onlyOwner canMint returns (bool) {
367     mintingFinished = true;
368     emit MintFinished();
369     return true;
370   }
371 }
372 
373 
374 contract UpcToken is StandardToken, MintableToken {
375   string public name    = "Unit Personer Token";
376   string public symbol  = "UPT";
377   uint8 public decimals = 18;
378 
379   // one billion in initial supply
380   uint256 public constant INITIAL_SUPPLY = 10000000000;
381 
382   function UpcCoin() public {
383     totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));
384     balances[msg.sender] = totalSupply_;
385   }
386 }