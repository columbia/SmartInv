1 pragma solidity 0.4.24;
2 
3 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
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
17 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address _owner, address _spender)
25     public view returns (uint256);
26 
27   function transferFrom(address _from, address _to, uint256 _value)
28     public returns (bool);
29 
30   function approve(address _spender, uint256 _value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\DetailedERC20.sol
39 
40 /**
41  * @title DetailedERC20 token
42  * @dev The decimals are only for visualization purposes.
43  * All the operations are done using the smallest and indivisible token unit,
44  * just as on Ethereum all the operations are done in wei.
45  */
46 contract DetailedERC20 is ERC20 {
47   string public name;
48   string public symbol;
49   uint8 public decimals;
50 
51   constructor(string _name, string _symbol, uint8 _decimals) public {
52     name = _name;
53     symbol = _symbol;
54     decimals = _decimals;
55   }
56 }
57 
58 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
59 
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that throw on error
63  */
64 library SafeMath {
65 
66   /**
67   * @dev Multiplies two numbers, throws on overflow.
68   */
69   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
70     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
71     // benefit is lost if 'b' is also tested.
72     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
73     if (_a == 0) {
74       return 0;
75     }
76 
77     c = _a * _b;
78     assert(c / _a == _b);
79     return c;
80   }
81 
82   /**
83   * @dev Integer division of two numbers, truncating the quotient.
84   */
85   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
86     // assert(_b > 0); // Solidity automatically throws when dividing by 0
87     // uint256 c = _a / _b;
88     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
89     return _a / _b;
90   }
91 
92   /**
93   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
94   */
95   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
96     assert(_b <= _a);
97     return _a - _b;
98   }
99 
100   /**
101   * @dev Adds two numbers, throws on overflow.
102   */
103   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
104     c = _a + _b;
105     assert(c >= _a);
106     return c;
107   }
108 }
109 
110 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
111 
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117   using SafeMath for uint256;
118 
119   mapping(address => uint256) internal balances;
120 
121   uint256 internal totalSupply_;
122 
123   /**
124   * @dev Total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return totalSupply_;
128   }
129 
130   /**
131   * @dev Transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135   function transfer(address _to, uint256 _value) public returns (bool) {
136     require(_value <= balances[msg.sender]);
137     require(_to != address(0));
138 
139     balances[msg.sender] = balances[msg.sender].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     emit Transfer(msg.sender, _to, _value);
142     return true;
143   }
144 
145   /**
146   * @dev Gets the balance of the specified address.
147   * @param _owner The address to query the the balance of.
148   * @return An uint256 representing the amount owned by the passed address.
149   */
150   function balanceOf(address _owner) public view returns (uint256) {
151     return balances[_owner];
152   }
153 
154 }
155 
156 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
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
205     require(_value == 0 || (allowed[msg.sender][_spender] == 0));
206     allowed[msg.sender][_spender] = _value;
207     emit Approval(msg.sender, _spender, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Function to check the amount of tokens that an owner allowed to a spender.
213    * @param _owner address The address which owns the funds.
214    * @param _spender address The address which will spend the funds.
215    * @return A uint256 specifying the amount of tokens still available for the spender.
216    */
217   function allowance(
218     address _owner,
219     address _spender
220    )
221     public
222     view
223     returns (uint256)
224   {
225     return allowed[_owner][_spender];
226   }
227 
228   /**
229    * @dev Increase the amount of tokens that an owner allowed to a spender.
230    * approve should be called when allowed[_spender] == 0. To increment
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    * @param _spender The address which will spend the funds.
235    * @param _addedValue The amount of tokens to increase the allowance by.
236    */
237   function increaseApproval(
238     address _spender,
239     uint256 _addedValue
240   )
241     public
242     returns (bool)
243   {
244     allowed[msg.sender][_spender] = (
245       allowed[msg.sender][_spender].add(_addedValue));
246     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250   /**
251    * @dev Decrease the amount of tokens that an owner allowed to a spender.
252    * approve should be called when allowed[_spender] == 0. To decrement
253    * allowed value is better to use this function to avoid 2 calls (and wait until
254    * the first transaction is mined)
255    * From MonolithDAO Token.sol
256    * @param _spender The address which will spend the funds.
257    * @param _subtractedValue The amount of tokens to decrease the allowance by.
258    */
259   function decreaseApproval(
260     address _spender,
261     uint256 _subtractedValue
262   )
263     public
264     returns (bool)
265   {
266     uint256 oldValue = allowed[msg.sender][_spender];
267     if (_subtractedValue >= oldValue) {
268       allowed[msg.sender][_spender] = 0;
269     } else {
270       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
271     }
272     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273     return true;
274   }
275 
276 }
277 
278 // File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
279 
280 /**
281  * @title Ownable
282  * @dev The Ownable contract has an owner address, and provides basic authorization control
283  * functions, this simplifies the implementation of "user permissions".
284  */
285 contract Ownable {
286   address public owner;
287 
288 
289   event OwnershipRenounced(address indexed previousOwner);
290   event OwnershipTransferred(
291     address indexed previousOwner,
292     address indexed newOwner
293   );
294 
295 
296   /**
297    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
298    * account.
299    */
300   constructor() public {
301     owner = msg.sender;
302   }
303 
304   /**
305    * @dev Throws if called by any account other than the owner.
306    */
307   modifier onlyOwner() {
308     require(msg.sender == owner);
309     _;
310   }
311 
312   /**
313    * @dev Allows the current owner to relinquish control of the contract.
314    * @notice Renouncing to ownership will leave the contract without an owner.
315    * It will not be possible to call the functions with the `onlyOwner`
316    * modifier anymore.
317    */
318   function renounceOwnership() public onlyOwner {
319     emit OwnershipRenounced(owner);
320     owner = address(0);
321   }
322 
323   /**
324    * @dev Allows the current owner to transfer control of the contract to a newOwner.
325    * @param _newOwner The address to transfer ownership to.
326    */
327   function transferOwnership(address _newOwner) public onlyOwner {
328     _transferOwnership(_newOwner);
329   }
330 
331   /**
332    * @dev Transfers control of the contract to a newOwner.
333    * @param _newOwner The address to transfer ownership to.
334    */
335   function _transferOwnership(address _newOwner) internal {
336     require(_newOwner != address(0));
337     emit OwnershipTransferred(owner, _newOwner);
338     owner = _newOwner;
339   }
340 }
341 
342 // File: contracts\COSBALLToken.sol
343 
344 contract COSBALLToken is DetailedERC20, StandardToken, Ownable {
345   string public name = "COSBALL Token";
346   string public symbol = "COSB";
347   uint8 public decimals = 18;
348   uint public initialSupply = 9000000000 * 10 ** uint256(decimals);
349 
350   mapping (address => bool) public frozenAccount;
351   event FrozenFunds(address target, bool frozen);
352   
353   constructor() DetailedERC20(name, symbol, decimals) public {
354     totalSupply_ = initialSupply;
355     balances[msg.sender] = totalSupply_;
356     emit Transfer(address(0), owner, totalSupply_);
357   }
358 
359   function transfer(address _to, uint256 _value) public returns (bool){
360     _transfer(msg.sender, _to, _value);
361   }
362 
363   function _transfer(address _from, address _to, uint _value) internal {
364         require (_to != address(0));
365         require (balances[_from] >= _value);               
366         require (balances[_to].add(_value) >= balances[_to]); 
367         require(!frozenAccount[_from]);                  
368         require(!frozenAccount[_to]);                     
369         balances[_from] = balances[_from].sub(_value); 
370         balances[_to] = balances[_to].add(_value);        
371         emit Transfer(_from, _to, _value);
372   }
373 
374   function freezeAccount(address target, bool freeze) onlyOwner public {
375         frozenAccount[target] = freeze;
376         emit FrozenFunds(target, freeze);
377   }
378 }