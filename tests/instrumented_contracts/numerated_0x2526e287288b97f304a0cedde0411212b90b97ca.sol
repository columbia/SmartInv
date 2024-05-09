1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    * @notice Renouncing to ownership will leave the contract without an owner.
88    * It will not be possible to call the functions with the `onlyOwner`
89    * modifier anymore.
90    */
91   function renounceOwnership() public onlyOwner {
92     emit OwnershipRenounced(owner);
93     owner = address(0);
94   }
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param _newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address _newOwner) public onlyOwner {
101     _transferOwnership(_newOwner);
102   }
103 
104   /**
105    * @dev Transfers control of the contract to a newOwner.
106    * @param _newOwner The address to transfer ownership to.
107    */
108   function _transferOwnership(address _newOwner) internal {
109     require(_newOwner != address(0));
110     emit OwnershipTransferred(owner, _newOwner);
111     owner = _newOwner;
112   }
113 }
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * See https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address _who) public view returns (uint256);
123   function transfer(address _to, uint256 _value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 is ERC20Basic {
132   function allowance(address _owner, address _spender)
133     public view returns (uint256);
134 
135   function transferFrom(address _from, address _to, uint256 _value)
136     public returns (bool);
137 
138   function approve(address _spender, uint256 _value) public returns (bool);
139   event Approval(
140     address indexed owner,
141     address indexed spender,
142     uint256 value
143   );
144 }
145 
146 /**
147  * @title Basic token
148  * @dev Basic version of StandardToken, with no allowances.
149  */
150 contract BasicToken is ERC20Basic {
151   using SafeMath for uint256;
152 
153   mapping(address => uint256) internal balances;
154 
155   uint256 internal totalSupply_;
156 
157   /**
158   * @dev Total number of tokens in existence
159   */
160   function totalSupply() public view returns (uint256) {
161     return totalSupply_;
162   }
163 
164   /**
165   * @dev Transfer token for a specified address
166   * @param _to The address to transfer to.
167   * @param _value The amount to be transferred.
168   */
169   function transfer(address _to, uint256 _value) public returns (bool) {
170     require(_value <= balances[msg.sender]);
171     require(_to != address(0));
172 
173     balances[msg.sender] = balances[msg.sender].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     emit Transfer(msg.sender, _to, _value);
176     return true;
177   }
178 
179   /**
180   * @dev Gets the balance of the specified address.
181   * @param _owner The address to query the the balance of.
182   * @return An uint256 representing the amount owned by the passed address.
183   */
184   function balanceOf(address _owner) public view returns (uint256) {
185     return balances[_owner];
186   }
187 
188 }
189 
190 /**
191  * @title Standard ERC20 token
192  *
193  * @dev Implementation of the basic standard token.
194  * https://github.com/ethereum/EIPs/issues/20
195  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
196  */
197 contract StandardToken is ERC20, BasicToken {
198 
199   mapping (address => mapping (address => uint256)) internal allowed;
200 
201 
202   /**
203    * @dev Transfer tokens from one address to another
204    * @param _from address The address which you want to send tokens from
205    * @param _to address The address which you want to transfer to
206    * @param _value uint256 the amount of tokens to be transferred
207    */
208   function transferFrom(
209     address _from,
210     address _to,
211     uint256 _value
212   )
213     public
214     returns (bool)
215   {
216     require(_value <= balances[_from]);
217     require(_value <= allowed[_from][msg.sender]);
218     require(_to != address(0));
219 
220     balances[_from] = balances[_from].sub(_value);
221     balances[_to] = balances[_to].add(_value);
222     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
223     emit Transfer(_from, _to, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
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
261    * approve should be called when allowed[_spender] == 0. To increment
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _addedValue The amount of tokens to increase the allowance by.
267    */
268   function increaseApproval(
269     address _spender,
270     uint256 _addedValue
271   )
272     public
273     returns (bool)
274   {
275     allowed[msg.sender][_spender] = (
276       allowed[msg.sender][_spender].add(_addedValue));
277     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278     return true;
279   }
280 
281   /**
282    * @dev Decrease the amount of tokens that an owner allowed to a spender.
283    * approve should be called when allowed[_spender] == 0. To decrement
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _subtractedValue The amount of tokens to decrease the allowance by.
289    */
290   function decreaseApproval(
291     address _spender,
292     uint256 _subtractedValue
293   )
294     public
295     returns (bool)
296   {
297     uint256 oldValue = allowed[msg.sender][_spender];
298     if (_subtractedValue >= oldValue) {
299       allowed[msg.sender][_spender] = 0;
300     } else {
301       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302     }
303     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 
307 }
308 
309 /**
310  * @title Mintable token
311  * @dev Simple ERC20 Token example, with mintable token creation
312  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
313  */
314 contract MintableToken is StandardToken, Ownable {
315   event Mint(address indexed to, uint256 amount);
316   event MintFinished();
317 
318   bool public mintingFinished = false;
319 
320 
321   modifier canMint() {
322     require(!mintingFinished);
323     _;
324   }
325 
326   modifier hasMintPermission() {
327     require(msg.sender == owner);
328     _;
329   }
330 
331   /**
332    * @dev Function to mint tokens
333    * @param _to The address that will receive the minted tokens.
334    * @param _amount The amount of tokens to mint.
335    * @return A boolean that indicates if the operation was successful.
336    */
337   function mint(
338     address _to,
339     uint256 _amount
340   )
341     public
342     hasMintPermission
343     canMint
344     returns (bool)
345   {
346     totalSupply_ = totalSupply_.add(_amount);
347     balances[_to] = balances[_to].add(_amount);
348     emit Mint(_to, _amount);
349     emit Transfer(address(0), _to, _amount);
350     return true;
351   }
352 
353   /**
354    * @dev Function to stop minting new tokens.
355    * @return True if the operation was successful.
356    */
357   function finishMinting() public onlyOwner canMint returns (bool) {
358     mintingFinished = true;
359     emit MintFinished();
360     return true;
361   }
362 }
363 
364 contract Wetts is MintableToken {
365     string public name = "Wetts";
366     string public symbol = "WTT";
367     uint8 public decimals = 18;
368 }