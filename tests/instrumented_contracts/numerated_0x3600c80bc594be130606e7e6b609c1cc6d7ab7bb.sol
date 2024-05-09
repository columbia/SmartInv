1 pragma solidity 0.4.21;
2 
3 
4 /**
5 
6 BEGIN IMPORTED CONTRACTS
7 
8 
9 */
10 
11 /**
12  * @title ERC20Basic
13  * @dev Simpler version of ERC20 interface
14  * See https://github.com/ethereum/EIPs/issues/179
15  */
16 contract ERC20Basic {
17   function totalSupply() public view returns (uint256);
18   function balanceOf(address who) public view returns (uint256);
19   function transfer(address to, uint256 value) public returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 }
22 
23 /**
24  * @title Basic token
25  * @dev Basic version of StandardToken, with no allowances.
26  */
27 contract BasicToken is ERC20Basic {
28   using SafeMath for uint256;
29 
30   mapping(address => uint256) balances;
31 
32   uint256 totalSupply_;
33 
34   /**
35   * @dev Total number of tokens in existence
36   */
37   function totalSupply() public view returns (uint256) {
38     return totalSupply_;
39   }
40 
41   /**
42   * @dev Transfer token for a specified address
43   * @param _to The address to transfer to.
44   * @param _value The amount to be transferred.
45   */
46   function transfer(address _to, uint256 _value) public returns (bool) {
47     require(_to != address(0));
48     require(_value <= balances[msg.sender]);
49 
50     balances[msg.sender] = balances[msg.sender].sub(_value);
51     balances[_to] = balances[_to].add(_value);
52     emit Transfer(msg.sender, _to, _value);
53     return true;
54   }
55 
56   /**
57   * @dev Gets the balance of the specified address.
58   * @param _owner The address to query the the balance of.
59   * @return An uint256 representing the amount owned by the passed address.
60   */
61   function balanceOf(address _owner) public view returns (uint256) {
62     return balances[_owner];
63   }
64 
65 }
66 
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20 is ERC20Basic {
73   function allowance(address owner, address spender)
74     public view returns (uint256);
75 
76   function transferFrom(address from, address to, uint256 value)
77     public returns (bool);
78 
79   function approve(address spender, uint256 value) public returns (bool);
80   event Approval(
81     address indexed owner,
82     address indexed spender,
83     uint256 value
84   );
85 }
86 
87 
88 /**
89  * @title Standard ERC20 token
90  *
91  * @dev Implementation of the basic standard token.
92  * https://github.com/ethereum/EIPs/issues/20
93  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
94  */
95 contract StandardToken is ERC20, BasicToken {
96 
97   mapping (address => mapping (address => uint256)) internal allowed;
98 
99 
100   /**
101    * @dev Transfer tokens from one address to another
102    * @param _from address The address which you want to send tokens from
103    * @param _to address The address which you want to transfer to
104    * @param _value uint256 the amount of tokens to be transferred
105    */
106   function transferFrom(
107     address _from,
108     address _to,
109     uint256 _value
110   )
111     public
112     returns (bool)
113   {
114     require(_to != address(0));
115     require(_value <= balances[_from]);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     emit Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    * Beware that changing an allowance with this method brings the risk that someone may use both the old
128    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
129    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
130    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131    * @param _spender The address which will spend the funds.
132    * @param _value The amount of tokens to be spent.
133    */
134   function approve(address _spender, uint256 _value) public returns (bool) {
135     allowed[msg.sender][_spender] = _value;
136     emit Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifying the amount of tokens still available for the spender.
145    */
146   function allowance(
147     address _owner,
148     address _spender
149    )
150     public
151     view
152     returns (uint256)
153   {
154     return allowed[_owner][_spender];
155   }
156 
157   /**
158    * @dev Increase the amount of tokens that an owner allowed to a spender.
159    * approve should be called when allowed[_spender] == 0. To increment
160    * allowed value is better to use this function to avoid 2 calls (and wait until
161    * the first transaction is mined)
162    * From MonolithDAO Token.sol
163    * @param _spender The address which will spend the funds.
164    * @param _addedValue The amount of tokens to increase the allowance by.
165    */
166   function increaseApproval(
167     address _spender,
168     uint256 _addedValue
169   )
170     public
171     returns (bool)
172   {
173     allowed[msg.sender][_spender] = (
174       allowed[msg.sender][_spender].add(_addedValue));
175     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176     return true;
177   }
178 
179   /**
180    * @dev Decrease the amount of tokens that an owner allowed to a spender.
181    * approve should be called when allowed[_spender] == 0. To decrement
182    * allowed value is better to use this function to avoid 2 calls (and wait until
183    * the first transaction is mined)
184    * From MonolithDAO Token.sol
185    * @param _spender The address which will spend the funds.
186    * @param _subtractedValue The amount of tokens to decrease the allowance by.
187    */
188   function decreaseApproval(
189     address _spender,
190     uint256 _subtractedValue
191   )
192     public
193     returns (bool)
194   {
195     uint256 oldValue = allowed[msg.sender][_spender];
196     if (_subtractedValue > oldValue) {
197       allowed[msg.sender][_spender] = 0;
198     } else {
199       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
200     }
201     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205 }
206 
207 
208 /**
209  * @title Burnable Token
210  * @dev Token that can be irreversibly burned (destroyed).
211  */
212 contract BurnableToken is BasicToken {
213 
214   event Burn(address indexed burner, uint256 value);
215 
216   /**
217    * @dev Burns a specific amount of tokens.
218    * @param _value The amount of token to be burned.
219    */
220   function burn(uint256 _value) public {
221     _burn(msg.sender, _value);
222   }
223 
224   function _burn(address _who, uint256 _value) internal {
225     require(_value <= balances[_who]);
226     // no need to require value <= totalSupply, since that would imply the
227     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
228 
229     balances[_who] = balances[_who].sub(_value);
230     totalSupply_ = totalSupply_.sub(_value);
231     emit Burn(_who, _value);
232     emit Transfer(_who, address(0), _value);
233   }
234 }
235 
236 
237 /**
238  * @title Standard Burnable Token
239  * @dev Adds burnFrom method to ERC20 implementations
240  */
241 contract StandardBurnableToken is BurnableToken, StandardToken {
242 
243   /**
244    * @dev Burns a specific amount of tokens from the target address and decrements allowance
245    * @param _from address The address which you want to send tokens from
246    * @param _value uint256 The amount of token to be burned
247    */
248   function burnFrom(address _from, uint256 _value) public {
249     require(_value <= allowed[_from][msg.sender]);
250     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
251     // this function needs to emit an event with the updated approval.
252     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
253     _burn(_from, _value);
254   }
255 }
256 
257 
258 /**
259  * @title SafeMath
260  * @dev Math operations with safety checks that throw on error
261  */
262 library SafeMath {
263 
264   /**
265   * @dev Multiplies two numbers, throws on overflow.
266   */
267   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
268     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
269     // benefit is lost if 'b' is also tested.
270     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
271     if (a == 0) {
272       return 0;
273     }
274 
275     c = a * b;
276     assert(c / a == b);
277     return c;
278   }
279 
280   /**
281   * @dev Integer division of two numbers, truncating the quotient.
282   */
283   function div(uint256 a, uint256 b) internal pure returns (uint256) {
284     // assert(b > 0); // Solidity automatically throws when dividing by 0
285     // uint256 c = a / b;
286     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
287     return a / b;
288   }
289 
290   /**
291   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
292   */
293   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
294     assert(b <= a);
295     return a - b;
296   }
297 
298   /**
299   * @dev Adds two numbers, throws on overflow.
300   */
301   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
302     c = a + b;
303     assert(c >= a);
304     return c;
305   }
306 }
307 
308 
309 /**
310  * @title Ownable
311  * @dev The Ownable contract has an owner address, and provides basic authorization control
312  * functions, this simplifies the implementation of "user permissions".
313  */
314 contract Ownable {
315   address public owner;
316 
317 
318   event OwnershipRenounced(address indexed previousOwner);
319   event OwnershipTransferred(
320     address indexed previousOwner,
321     address indexed newOwner
322   );
323 
324 
325   /**
326    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
327    * account.
328    */
329   function Ownable() public {
330     owner = msg.sender;
331   }
332 
333   /**
334    * @dev Throws if called by any account other than the owner.
335    */
336   modifier onlyOwner() {
337     require(msg.sender == owner);
338     _;
339   }
340 
341   /**
342    * @dev Allows the current owner to relinquish control of the contract.
343    * @notice Renouncing to ownership will leave the contract without an owner.
344    * It will not be possible to call the functions with the `onlyOwner`
345    * modifier anymore.
346    */
347   function renounceOwnership() public onlyOwner {
348     emit OwnershipRenounced(owner);
349     owner = address(0);
350   }
351 
352   /**
353    * @dev Allows the current owner to transfer control of the contract to a newOwner.
354    * @param _newOwner The address to transfer ownership to.
355    */
356   function transferOwnership(address _newOwner) public onlyOwner {
357     _transferOwnership(_newOwner);
358   }
359 
360   /**
361    * @dev Transfers control of the contract to a newOwner.
362    * @param _newOwner The address to transfer ownership to.
363    */
364   function _transferOwnership(address _newOwner) internal {
365     require(_newOwner != address(0));
366     emit OwnershipTransferred(owner, _newOwner);
367     owner = _newOwner;
368   }
369 }
370 
371 
372 
373 /**
374 
375 END IMPORTED CONTRACTS
376 
377 */
378 
379 /**
380  * @title BolivarX
381  * @dev This is Standard, Ownable and Burnable token. www.bolivarx.com
382  */
383 contract bsx is StandardBurnableToken, Ownable {
384     
385     string public name;
386     string public symbol;
387     uint256 public decimals = 18;
388     
389     /**
390      * Constructor function
391      *
392      * Initializes contract with initial supply tokens to the creator of the contract
393      */
394     function bsx (
395         uint256 initialSupply,
396         string tokenName,
397         string tokenSymbol
398     ) public {
399         totalSupply_ = initialSupply * 10 ** decimals;  // Update total supply with the decimal amount
400         balances[msg.sender] = totalSupply_;                // Give the creator all initial tokens
401         name = tokenName;                                   // Set the name for display purposes
402         symbol = tokenSymbol;                               // Set the symbol for display purposes
403     }
404 }