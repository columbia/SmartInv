1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
76     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
77     // benefit is lost if 'b' is also tested.
78     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
79     if (a == 0) {
80       return 0;
81     }
82 
83     c = a * b;
84     assert(c / a == b);
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, truncating the quotient.
90   */
91   function div(uint256 a, uint256 b) internal pure returns (uint256) {
92     // assert(b > 0); // Solidity automatically throws when dividing by 0
93     // uint256 c = a / b;
94     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95     return a / b;
96   }
97 
98   /**
99   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100   */
101   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102     assert(b <= a);
103     return a - b;
104   }
105 
106   /**
107   * @dev Adds two numbers, throws on overflow.
108   */
109   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
110     c = a + b;
111     assert(c >= a);
112     return c;
113   }
114 }
115 
116 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124   function totalSupply() public view returns (uint256);
125   function balanceOf(address who) public view returns (uint256);
126   function transfer(address to, uint256 value) public returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
131 
132 /**
133  * @title Basic token
134  * @dev Basic version of StandardToken, with no allowances.
135  */
136 contract BasicToken is ERC20Basic {
137   using SafeMath for uint256;
138 
139   mapping(address => uint256) balances;
140 
141   uint256 totalSupply_;
142 
143   /**
144   * @dev total number of tokens in existence
145   */
146   function totalSupply() public view returns (uint256) {
147     return totalSupply_;
148   }
149 
150   /**
151   * @dev transfer token for a specified address
152   * @param _to The address to transfer to.
153   * @param _value The amount to be transferred.
154   */
155   function transfer(address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[msg.sender]);
158 
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     emit Transfer(msg.sender, _to, _value);
162     return true;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256) {
171     return balances[_owner];
172   }
173 
174 }
175 
176 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
177 
178 /**
179  * @title Burnable Token
180  * @dev Token that can be irreversibly burned (destroyed).
181  */
182 contract BurnableToken is BasicToken {
183 
184   event Burn(address indexed burner, uint256 value);
185 
186   /**
187    * @dev Burns a specific amount of tokens.
188    * @param _value The amount of token to be burned.
189    */
190   function burn(uint256 _value) public {
191     _burn(msg.sender, _value);
192   }
193 
194   function _burn(address _who, uint256 _value) internal {
195     require(_value <= balances[_who]);
196     // no need to require value <= totalSupply, since that would imply the
197     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
198 
199     balances[_who] = balances[_who].sub(_value);
200     totalSupply_ = totalSupply_.sub(_value);
201     emit Burn(_who, _value);
202     emit Transfer(_who, address(0), _value);
203   }
204 }
205 
206 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
207 
208 /**
209  * @title ERC20 interface
210  * @dev see https://github.com/ethereum/EIPs/issues/20
211  */
212 contract ERC20 is ERC20Basic {
213   function allowance(address owner, address spender)
214     public view returns (uint256);
215 
216   function transferFrom(address from, address to, uint256 value)
217     public returns (bool);
218 
219   function approve(address spender, uint256 value) public returns (bool);
220   event Approval(
221     address indexed owner,
222     address indexed spender,
223     uint256 value
224   );
225 }
226 
227 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
228 
229 /**
230  * @title DetailedERC20 token
231  * @dev The decimals are only for visualization purposes.
232  * All the operations are done using the smallest and indivisible token unit,
233  * just as on Ethereum all the operations are done in wei.
234  */
235 contract DetailedERC20 is ERC20 {
236   string public name;
237   string public symbol;
238   uint8 public decimals;
239 
240   constructor(string _name, string _symbol, uint8 _decimals) public {
241     name = _name;
242     symbol = _symbol;
243     decimals = _decimals;
244   }
245 }
246 
247 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
248 
249 /**
250  * @title Standard ERC20 token
251  *
252  * @dev Implementation of the basic standard token.
253  * @dev https://github.com/ethereum/EIPs/issues/20
254  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
255  */
256 contract StandardToken is ERC20, BasicToken {
257 
258   mapping (address => mapping (address => uint256)) internal allowed;
259 
260 
261   /**
262    * @dev Transfer tokens from one address to another
263    * @param _from address The address which you want to send tokens from
264    * @param _to address The address which you want to transfer to
265    * @param _value uint256 the amount of tokens to be transferred
266    */
267   function transferFrom(
268     address _from,
269     address _to,
270     uint256 _value
271   )
272     public
273     returns (bool)
274   {
275     require(_to != address(0));
276     require(_value <= balances[_from]);
277     require(_value <= allowed[_from][msg.sender]);
278 
279     balances[_from] = balances[_from].sub(_value);
280     balances[_to] = balances[_to].add(_value);
281     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
282     emit Transfer(_from, _to, _value);
283     return true;
284   }
285 
286   /**
287    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
288    *
289    * Beware that changing an allowance with this method brings the risk that someone may use both the old
290    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
291    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
292    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
293    * @param _spender The address which will spend the funds.
294    * @param _value The amount of tokens to be spent.
295    */
296   function approve(address _spender, uint256 _value) public returns (bool) {
297     allowed[msg.sender][_spender] = _value;
298     emit Approval(msg.sender, _spender, _value);
299     return true;
300   }
301 
302   /**
303    * @dev Function to check the amount of tokens that an owner allowed to a spender.
304    * @param _owner address The address which owns the funds.
305    * @param _spender address The address which will spend the funds.
306    * @return A uint256 specifying the amount of tokens still available for the spender.
307    */
308   function allowance(
309     address _owner,
310     address _spender
311    )
312     public
313     view
314     returns (uint256)
315   {
316     return allowed[_owner][_spender];
317   }
318 
319   /**
320    * @dev Increase the amount of tokens that an owner allowed to a spender.
321    *
322    * approve should be called when allowed[_spender] == 0. To increment
323    * allowed value is better to use this function to avoid 2 calls (and wait until
324    * the first transaction is mined)
325    * From MonolithDAO Token.sol
326    * @param _spender The address which will spend the funds.
327    * @param _addedValue The amount of tokens to increase the allowance by.
328    */
329   function increaseApproval(
330     address _spender,
331     uint _addedValue
332   )
333     public
334     returns (bool)
335   {
336     allowed[msg.sender][_spender] = (
337       allowed[msg.sender][_spender].add(_addedValue));
338     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
339     return true;
340   }
341 
342   /**
343    * @dev Decrease the amount of tokens that an owner allowed to a spender.
344    *
345    * approve should be called when allowed[_spender] == 0. To decrement
346    * allowed value is better to use this function to avoid 2 calls (and wait until
347    * the first transaction is mined)
348    * From MonolithDAO Token.sol
349    * @param _spender The address which will spend the funds.
350    * @param _subtractedValue The amount of tokens to decrease the allowance by.
351    */
352   function decreaseApproval(
353     address _spender,
354     uint _subtractedValue
355   )
356     public
357     returns (bool)
358   {
359     uint oldValue = allowed[msg.sender][_spender];
360     if (_subtractedValue > oldValue) {
361       allowed[msg.sender][_spender] = 0;
362     } else {
363       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
364     }
365     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
366     return true;
367   }
368 
369 }
370 
371 // File: contracts/grapevine/token/GrapevineToken.sol
372 
373 /**
374  * @title Grapevine Token
375  * @dev Grapevine Token
376  **/
377 contract GrapevineToken is DetailedERC20, BurnableToken, StandardToken, Ownable {
378 
379   constructor() DetailedERC20("TESTGVINE", "TESTGVINE", 18) public {
380     totalSupply_ = 825000000 * (10 ** uint256(decimals)); // Update total supply with the decimal amount
381     balances[msg.sender] = totalSupply_;
382     emit Transfer(address(0), msg.sender, totalSupply_);
383   }
384 
385   /**
386   * @dev burns the provided the _value, can be used only by the owner of the contract.
387   * @param _value The value of the tokens to be burnt.
388   */
389   function burn(uint256 _value) public onlyOwner {
390     super.burn(_value);
391   }
392 }