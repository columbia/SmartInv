1 pragma solidity 0.4.24;
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
174 
175 }
176 
177 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
178 
179 /**
180  * @title ERC20 interface
181  * @dev see https://github.com/ethereum/EIPs/issues/20
182  */
183 contract ERC20 is ERC20Basic {
184   function allowance(address _owner, address _spender)
185     public view returns (uint256);
186 
187   function transferFrom(address _from, address _to, uint256 _value)
188     public returns (bool);
189 
190   function approve(address _spender, uint256 _value) public returns (bool);
191   event Approval(
192     address indexed owner,
193     address indexed spender,
194     uint256 value
195   );
196 }
197 
198 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
199 
200 /**
201  * @title Standard ERC20 token
202  *
203  * @dev Implementation of the basic standard token.
204  * https://github.com/ethereum/EIPs/issues/20
205  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
206  */
207 contract StandardToken is ERC20, BasicToken {
208 
209   mapping (address => mapping (address => uint256)) internal allowed;
210 
211 
212   /**
213    * @dev Transfer tokens from one address to another
214    * @param _from address The address which you want to send tokens from
215    * @param _to address The address which you want to transfer to
216    * @param _value uint256 the amount of tokens to be transferred
217    */
218   function transferFrom(
219     address _from,
220     address _to,
221     uint256 _value
222   )
223     public
224     returns (bool)
225   {
226     require(_value <= balances[_from]);
227     require(_value <= allowed[_from][msg.sender]);
228     require(_to != address(0));
229 
230     balances[_from] = balances[_from].sub(_value);
231     balances[_to] = balances[_to].add(_value);
232     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
233     emit Transfer(_from, _to, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
239    * Beware that changing an allowance with this method brings the risk that someone may use both the old
240    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
241    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
242    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243    * @param _spender The address which will spend the funds.
244    * @param _value The amount of tokens to be spent.
245    */
246   function approve(address _spender, uint256 _value) public returns (bool) {
247     allowed[msg.sender][_spender] = _value;
248     emit Approval(msg.sender, _spender, _value);
249     return true;
250   }
251 
252   /**
253    * @dev Function to check the amount of tokens that an owner allowed to a spender.
254    * @param _owner address The address which owns the funds.
255    * @param _spender address The address which will spend the funds.
256    * @return A uint256 specifying the amount of tokens still available for the spender.
257    */
258   function allowance(
259     address _owner,
260     address _spender
261    )
262     public
263     view
264     returns (uint256)
265   {
266     return allowed[_owner][_spender];
267   }
268 
269   /**
270    * @dev Increase the amount of tokens that an owner allowed to a spender.
271    * approve should be called when allowed[_spender] == 0. To increment
272    * allowed value is better to use this function to avoid 2 calls (and wait until
273    * the first transaction is mined)
274    * From MonolithDAO Token.sol
275    * @param _spender The address which will spend the funds.
276    * @param _addedValue The amount of tokens to increase the allowance by.
277    */
278   function increaseApproval(
279     address _spender,
280     uint256 _addedValue
281   )
282     public
283     returns (bool)
284   {
285     allowed[msg.sender][_spender] = (
286       allowed[msg.sender][_spender].add(_addedValue));
287     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
288     return true;
289   }
290 
291   /**
292    * @dev Decrease the amount of tokens that an owner allowed to a spender.
293    * approve should be called when allowed[_spender] == 0. To decrement
294    * allowed value is better to use this function to avoid 2 calls (and wait until
295    * the first transaction is mined)
296    * From MonolithDAO Token.sol
297    * @param _spender The address which will spend the funds.
298    * @param _subtractedValue The amount of tokens to decrease the allowance by.
299    */
300   function decreaseApproval(
301     address _spender,
302     uint256 _subtractedValue
303   )
304     public
305     returns (bool)
306   {
307     uint256 oldValue = allowed[msg.sender][_spender];
308     if (_subtractedValue >= oldValue) {
309       allowed[msg.sender][_spender] = 0;
310     } else {
311       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
312     }
313     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
314     return true;
315   }
316 
317 }
318 
319 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
320 
321 
322 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
323 
324 /**
325  * @title Mintable token
326  * @dev Simple ERC20 Token example, with mintable token creation
327  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
328  */
329 contract MintableToken is StandardToken, Ownable {
330   event Mint(address indexed to, uint256 amount);
331   event MintFinished();
332 
333   bool public mintingFinished = false;
334 
335 
336   modifier canMint() {
337     require(!mintingFinished);
338     _;
339   }
340 
341   modifier hasMintPermission() {
342     require(msg.sender == owner);
343     _;
344   }
345 
346   /**
347    * @dev Function to mint tokens
348    * @param _to The address that will receive the minted tokens.
349    * @param _amount The amount of tokens to mint.
350    * @return A boolean that indicates if the operation was successful.
351    */
352   function mint(
353     address _to,
354     uint256 _amount
355   )
356     public
357     hasMintPermission
358     canMint
359     returns (bool)
360   {
361     totalSupply_ = totalSupply_.add(_amount);
362     balances[_to] = balances[_to].add(_amount);
363     emit Mint(_to, _amount);
364     emit Transfer(address(0), _to, _amount);
365     return true;
366   }
367 
368   /**
369    * @dev Function to stop minting new tokens.
370    * @return True if the operation was successful.
371    */
372   function finishMinting() public onlyOwner canMint returns (bool) {
373     mintingFinished = true;
374     emit MintFinished();
375     return true;
376   }
377 }
378 
379 // File: contracts/JeruToken.sol
380 
381 contract JeruToken is MintableToken {
382   string public constant name = "Jerusalem Chain";
383   string public constant symbol = "JERU";
384   uint8 public constant decimals = 0;
385 
386   constructor(address _wallet, uint256 _initialSupply) public {
387     mint(_wallet, _initialSupply);
388     finishMinting();
389   }
390 }