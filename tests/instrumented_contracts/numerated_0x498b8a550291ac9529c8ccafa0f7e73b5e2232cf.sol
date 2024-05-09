1 pragma solidity ^0.4.21;
2 
3 // openzeppelin-solidity@1.10.0 from NPM
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
64 /**
65  * @title SafeMath
66  * @dev Math operations with safety checks that throw on error
67  */
68 library SafeMath {
69 
70   /**
71   * @dev Multiplies two numbers, throws on overflow.
72   */
73   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
74     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
75     // benefit is lost if 'b' is also tested.
76     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
77     if (a == 0) {
78       return 0;
79     }
80 
81     c = a * b;
82     assert(c / a == b);
83     return c;
84   }
85 
86   /**
87   * @dev Integer division of two numbers, truncating the quotient.
88   */
89   function div(uint256 a, uint256 b) internal pure returns (uint256) {
90     // assert(b > 0); // Solidity automatically throws when dividing by 0
91     // uint256 c = a / b;
92     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93     return a / b;
94   }
95 
96   /**
97   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
98   */
99   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100     assert(b <= a);
101     return a - b;
102   }
103 
104   /**
105   * @dev Adds two numbers, throws on overflow.
106   */
107   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
108     c = a + b;
109     assert(c >= a);
110     return c;
111   }
112 }
113 
114 /**
115  * @title ERC20Basic
116  * @dev Simpler version of ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/179
118  */
119 contract ERC20Basic {
120   function totalSupply() public view returns (uint256);
121   function balanceOf(address who) public view returns (uint256);
122   function transfer(address to, uint256 value) public returns (bool);
123   event Transfer(address indexed from, address indexed to, uint256 value);
124 }
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131   function allowance(address owner, address spender)
132     public view returns (uint256);
133 
134   function transferFrom(address from, address to, uint256 value)
135     public returns (bool);
136 
137   function approve(address spender, uint256 value) public returns (bool);
138   event Approval(
139     address indexed owner,
140     address indexed spender,
141     uint256 value
142   );
143 }
144 
145 /**
146  * @title Basic token
147  * @dev Basic version of StandardToken, with no allowances.
148  */
149 contract BasicToken is ERC20Basic {
150   using SafeMath for uint256;
151 
152   mapping(address => uint256) balances;
153 
154   uint256 totalSupply_;
155 
156   /**
157   * @dev total number of tokens in existence
158   */
159   function totalSupply() public view returns (uint256) {
160     return totalSupply_;
161   }
162 
163   /**
164   * @dev transfer token for a specified address
165   * @param _to The address to transfer to.
166   * @param _value The amount to be transferred.
167   */
168   function transfer(address _to, uint256 _value) public returns (bool) {
169     require(_to != address(0));
170     require(_value <= balances[msg.sender]);
171 
172     balances[msg.sender] = balances[msg.sender].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     emit Transfer(msg.sender, _to, _value);
175     return true;
176   }
177 
178   /**
179   * @dev Gets the balance of the specified address.
180   * @param _owner The address to query the the balance of.
181   * @return An uint256 representing the amount owned by the passed address.
182   */
183   function balanceOf(address _owner) public view returns (uint256) {
184     return balances[_owner];
185   }
186 
187 }
188 
189 /**
190  * @title Standard ERC20 token
191  *
192  * @dev Implementation of the basic standard token.
193  * @dev https://github.com/ethereum/EIPs/issues/20
194  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
195  */
196 contract StandardToken is ERC20, BasicToken {
197 
198   mapping (address => mapping (address => uint256)) internal allowed;
199 
200 
201   /**
202    * @dev Transfer tokens from one address to another
203    * @param _from address The address which you want to send tokens from
204    * @param _to address The address which you want to transfer to
205    * @param _value uint256 the amount of tokens to be transferred
206    */
207   function transferFrom(
208     address _from,
209     address _to,
210     uint256 _value
211   )
212     public
213     returns (bool)
214   {
215     require(_to != address(0));
216     require(_value <= balances[_from]);
217     require(_value <= allowed[_from][msg.sender]);
218 
219     balances[_from] = balances[_from].sub(_value);
220     balances[_to] = balances[_to].add(_value);
221     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
222     emit Transfer(_from, _to, _value);
223     return true;
224   }
225 
226   /**
227    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
228    *
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
261    *
262    * approve should be called when allowed[_spender] == 0. To increment
263    * allowed value is better to use this function to avoid 2 calls (and wait until
264    * the first transaction is mined)
265    * From MonolithDAO Token.sol
266    * @param _spender The address which will spend the funds.
267    * @param _addedValue The amount of tokens to increase the allowance by.
268    */
269   function increaseApproval(
270     address _spender,
271     uint _addedValue
272   )
273     public
274     returns (bool)
275   {
276     allowed[msg.sender][_spender] = (
277       allowed[msg.sender][_spender].add(_addedValue));
278     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282   /**
283    * @dev Decrease the amount of tokens that an owner allowed to a spender.
284    *
285    * approve should be called when allowed[_spender] == 0. To decrement
286    * allowed value is better to use this function to avoid 2 calls (and wait until
287    * the first transaction is mined)
288    * From MonolithDAO Token.sol
289    * @param _spender The address which will spend the funds.
290    * @param _subtractedValue The amount of tokens to decrease the allowance by.
291    */
292   function decreaseApproval(
293     address _spender,
294     uint _subtractedValue
295   )
296     public
297     returns (bool)
298   {
299     uint oldValue = allowed[msg.sender][_spender];
300     if (_subtractedValue > oldValue) {
301       allowed[msg.sender][_spender] = 0;
302     } else {
303       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
304     }
305     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
306     return true;
307   }
308 
309 }
310 
311 /**
312  * @title Burnable Token
313  * @dev Token that can be irreversibly burned (destroyed).
314  */
315 contract BurnableToken is BasicToken {
316 
317   event Burn(address indexed burner, uint256 value);
318 
319   /**
320    * @dev Burns a specific amount of tokens.
321    * @param _value The amount of token to be burned.
322    */
323   function burn(uint256 _value) public {
324     _burn(msg.sender, _value);
325   }
326 
327   function _burn(address _who, uint256 _value) internal {
328     require(_value <= balances[_who]);
329     // no need to require value <= totalSupply, since that would imply the
330     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
331 
332     balances[_who] = balances[_who].sub(_value);
333     totalSupply_ = totalSupply_.sub(_value);
334     emit Burn(_who, _value);
335     emit Transfer(_who, address(0), _value);
336   }
337 }
338 
339 /**
340  * @title Standard Burnable Token
341  * @dev Adds burnFrom method to ERC20 implementations
342  */
343 contract StandardBurnableToken is BurnableToken, StandardToken {
344 
345   /**
346    * @dev Burns a specific amount of tokens from the target address and decrements allowance
347    * @param _from address The address which you want to send tokens from
348    * @param _value uint256 The amount of token to be burned
349    */
350   function burnFrom(address _from, uint256 _value) public {
351     require(_value <= allowed[_from][msg.sender]);
352     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
353     // this function needs to emit an event with the updated approval.
354     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
355     _burn(_from, _value);
356   }
357 }
358 
359 contract WLO is StandardBurnableToken, Ownable {
360 
361   string public name = "Wollo";
362   string public symbol = "WLO";
363 
364   uint8 public decimals = 18;
365   uint public INITIAL_SUPPLY = 13500000 * uint(10**uint(decimals));
366 
367   constructor () public {
368     totalSupply_ = INITIAL_SUPPLY;
369     balances[msg.sender] = INITIAL_SUPPLY;
370   }
371 }