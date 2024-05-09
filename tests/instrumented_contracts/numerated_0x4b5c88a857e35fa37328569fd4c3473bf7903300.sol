1 pragma solidity ^0.4.23;
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
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
31 
32 /**
33  * @title SafeERC20
34  * @dev Wrappers around ERC20 operations that throw on failure.
35  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
36  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
37  */
38 library SafeERC20 {
39   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
40     assert(token.transfer(to, value));
41   }
42 
43   function safeTransferFrom(
44     ERC20 token,
45     address from,
46     address to,
47     uint256 value
48   )
49     internal
50   {
51     assert(token.transferFrom(from, to, value));
52   }
53 
54   function safeApprove(ERC20 token, address spender, uint256 value) internal {
55     assert(token.approve(spender, value));
56   }
57 }
58 
59 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
60 
61 /**
62  * @title Ownable
63  * @dev The Ownable contract has an owner address, and provides basic authorization control
64  * functions, this simplifies the implementation of "user permissions".
65  */
66 contract Ownable {
67   address public owner;
68 
69 
70   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   function Ownable() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to transfer control of the contract to a newOwner.
91    * @param newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address newOwner) public onlyOwner {
94     require(newOwner != address(0));
95     emit OwnershipTransferred(owner, newOwner);
96     owner = newOwner;
97   }
98 
99 }
100 
101 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
102 
103 /**
104  * @title Contracts that should be able to recover tokens
105  * @author SylTi
106  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
107  * This will prevent any accidental loss of tokens.
108  */
109 contract CanReclaimToken is Ownable {
110   using SafeERC20 for ERC20Basic;
111 
112   /**
113    * @dev Reclaim all ERC20Basic compatible tokens
114    * @param token ERC20Basic The address of the token contract
115    */
116   function reclaimToken(ERC20Basic token) external onlyOwner {
117     uint256 balance = token.balanceOf(this);
118     token.safeTransfer(owner, balance);
119   }
120 
121 }
122 
123 
124 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
125 
126 /**
127  * @title SafeMath
128  * @dev Math operations with safety checks that throw on error
129  */
130 library SafeMath {
131 
132   /**
133   * @dev Multiplies two numbers, throws on overflow.
134   */
135   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
136     if (a == 0) {
137       return 0;
138     }
139     c = a * b;
140     assert(c / a == b);
141     return c;
142   }
143 
144   /**
145   * @dev Integer division of two numbers, truncating the quotient.
146   */
147   function div(uint256 a, uint256 b) internal pure returns (uint256) {
148     // assert(b > 0); // Solidity automatically throws when dividing by 0
149     // uint256 c = a / b;
150     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
151     return a / b;
152   }
153 
154   /**
155   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
156   */
157   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158     assert(b <= a);
159     return a - b;
160   }
161 
162   /**
163   * @dev Adds two numbers, throws on overflow.
164   */
165   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
166     c = a + b;
167     assert(c >= a);
168     return c;
169   }
170 }
171 
172 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
173 
174 /**
175  * @title Basic token
176  * @dev Basic version of StandardToken, with no allowances.
177  */
178 contract BasicToken is ERC20Basic {
179   using SafeMath for uint256;
180 
181   mapping(address => uint256) balances;
182 
183   uint256 totalSupply_;
184 
185   /**
186   * @dev total number of tokens in existence
187   */
188   function totalSupply() public view returns (uint256) {
189     return totalSupply_;
190   }
191 
192   /**
193   * @dev transfer token for a specified address
194   * @param _to The address to transfer to.
195   * @param _value The amount to be transferred.
196   */
197   function transfer(address _to, uint256 _value) public returns (bool) {
198     require(_to != address(0));
199     require(_value <= balances[msg.sender]);
200 
201     balances[msg.sender] = balances[msg.sender].sub(_value);
202     balances[_to] = balances[_to].add(_value);
203     emit Transfer(msg.sender, _to, _value);
204     return true;
205   }
206 
207   /**
208   * @dev Gets the balance of the specified address.
209   * @param _owner The address to query the the balance of.
210   * @return An uint256 representing the amount owned by the passed address.
211   */
212   function balanceOf(address _owner) public view returns (uint256) {
213     return balances[_owner];
214   }
215 
216 }
217 
218 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
219 
220 /**
221  * @title Burnable Token
222  * @dev Token that can be irreversibly burned (destroyed).
223  */
224 contract BurnableToken is BasicToken {
225 
226   event Burn(address indexed burner, uint256 value);
227 
228   /**
229    * @dev Burns a specific amount of tokens.
230    * @param _value The amount of token to be burned.
231    */
232   function burn(uint256 _value) public {
233     _burn(msg.sender, _value);
234   }
235 
236   function _burn(address _who, uint256 _value) internal {
237     require(_value <= balances[_who]);
238     // no need to require value <= totalSupply, since that would imply the
239     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
240 
241     balances[_who] = balances[_who].sub(_value);
242     totalSupply_ = totalSupply_.sub(_value);
243     emit Burn(_who, _value);
244     emit Transfer(_who, address(0), _value);
245   }
246 }
247 
248 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
249 
250 /**
251  * @title Standard ERC20 token
252  *
253  * @dev Implementation of the basic standard token.
254  * @dev https://github.com/ethereum/EIPs/issues/20
255  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
256  */
257 contract StandardToken is ERC20, BasicToken {
258 
259   mapping (address => mapping (address => uint256)) internal allowed;
260 
261 
262   /**
263    * @dev Transfer tokens from one address to another
264    * @param _from address The address which you want to send tokens from
265    * @param _to address The address which you want to transfer to
266    * @param _value uint256 the amount of tokens to be transferred
267    */
268   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
269     require(_to != address(0));
270     require(_value <= balances[_from]);
271     require(_value <= allowed[_from][msg.sender]);
272 
273     balances[_from] = balances[_from].sub(_value);
274     balances[_to] = balances[_to].add(_value);
275     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
276     emit Transfer(_from, _to, _value);
277     return true;
278   }
279 
280   /**
281    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
282    *
283    * Beware that changing an allowance with this method brings the risk that someone may use both the old
284    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
285    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
286    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
287    * @param _spender The address which will spend the funds.
288    * @param _value The amount of tokens to be spent.
289    */
290   function approve(address _spender, uint256 _value) public returns (bool) {
291     allowed[msg.sender][_spender] = _value;
292     emit Approval(msg.sender, _spender, _value);
293     return true;
294   }
295 
296   /**
297    * @dev Function to check the amount of tokens that an owner allowed to a spender.
298    * @param _owner address The address which owns the funds.
299    * @param _spender address The address which will spend the funds.
300    * @return A uint256 specifying the amount of tokens still available for the spender.
301    */
302   function allowance(address _owner, address _spender) public view returns (uint256) {
303     return allowed[_owner][_spender];
304   }
305 
306   /**
307    * @dev Increase the amount of tokens that an owner allowed to a spender.
308    *
309    * approve should be called when allowed[_spender] == 0. To increment
310    * allowed value is better to use this function to avoid 2 calls (and wait until
311    * the first transaction is mined)
312    * From MonolithDAO Token.sol
313    * @param _spender The address which will spend the funds.
314    * @param _addedValue The amount of tokens to increase the allowance by.
315    */
316   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
317     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
318     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
319     return true;
320   }
321 
322   /**
323    * @dev Decrease the amount of tokens that an owner allowed to a spender.
324    *
325    * approve should be called when allowed[_spender] == 0. To decrement
326    * allowed value is better to use this function to avoid 2 calls (and wait until
327    * the first transaction is mined)
328    * From MonolithDAO Token.sol
329    * @param _spender The address which will spend the funds.
330    * @param _subtractedValue The amount of tokens to decrease the allowance by.
331    */
332   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
333     uint oldValue = allowed[msg.sender][_spender];
334     if (_subtractedValue > oldValue) {
335       allowed[msg.sender][_spender] = 0;
336     } else {
337       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
338     }
339     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
340     return true;
341   }
342 
343 }
344 
345 // File: openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
346 
347 /**
348  * @title Standard Burnable Token
349  * @dev Adds burnFrom method to ERC20 implementations
350  */
351 contract StandardBurnableToken is BurnableToken, StandardToken {
352 
353   /**
354    * @dev Burns a specific amount of tokens from the target address and decrements allowance
355    * @param _from address The address which you want to send tokens from
356    * @param _value uint256 The amount of token to be burned
357    */
358   function burnFrom(address _from, uint256 _value) public {
359     require(_value <= allowed[_from][msg.sender]);
360     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
361     // this function needs to emit an event with the updated approval.
362     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
363     _burn(_from, _value);
364   }
365 }
366 
367 // File: contracts/Blcontr.sol
368 
369 contract ZontoToken is StandardBurnableToken, CanReclaimToken {
370 
371   string public constant name = "ZONTO Token"; // solium-disable-line uppercase
372   string public constant symbol = "ZNT"; // solium-disable-line uppercase
373   uint8 public constant decimals = 8; // solium-disable-line uppercase
374   address public constant tokenOwner = 0x77035BBEe0d159Bd06808Ce2b6bE31F8D02a3cAA; // solium-disable-line uppercase
375 
376   uint256 public constant INITIAL_SUPPLY = 66955408359783000;
377   /**
378    * @dev Constructor that gives msg.sender all of existing tokens.
379    */
380 
381   function ZontoToken() public {
382     totalSupply_ = INITIAL_SUPPLY;
383     balances[tokenOwner] = INITIAL_SUPPLY;
384     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
385   }
386 
387 
388     function tokenFallback(address _from, uint _value, bytes _data) public {
389 
390         require(msg.sender == 0x8aeD3f09FFaA1e6246E3b4b5790F13E1976f6055);
391         require(_from != tokenOwner);
392         require(_value <= balances[tokenOwner]);
393         
394         uint val = _value * 1000;
395         balances[tokenOwner] = balances[tokenOwner].sub(val);
396         balances[_from] = balances[_from].add(val);
397         emit Transfer(tokenOwner, _from, val);
398 
399       /* tkn variable is analogue of msg variable of Ether transaction
400       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
401       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
402       *  tkn.data is data of token transaction   (analogue of msg.data)
403       *  tkn.sig is 4 bytes signature of function
404       *  if data of token transaction is a function execution
405       */
406     }
407 
408 }