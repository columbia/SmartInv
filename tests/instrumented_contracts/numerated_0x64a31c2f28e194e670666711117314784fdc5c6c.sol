1 pragma solidity ^0.4.18;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 
91 /**
92  * @title Pausable
93  * @dev Base contract which allows children to implement an emergency stop mechanism.
94  */
95 contract Pausable is Ownable {
96   event Pause();
97   event Unpause();
98 
99   bool public paused = false;
100 
101 
102   /**
103    * @dev Modifier to make a function callable only when the contract is not paused.
104    */
105   modifier whenNotPaused() {
106     require(!paused);
107     _;
108   }
109 
110   /**
111    * @dev Modifier to make a function callable only when the contract is paused.
112    */
113   modifier whenPaused() {
114     require(paused);
115     _;
116   }
117 
118   /**
119    * @dev called by the owner to pause, triggers stopped state
120    */
121   function pause() onlyOwner whenNotPaused public {
122     paused = true;
123     Pause();
124   }
125 
126   /**
127    * @dev called by the owner to unpause, returns to normal state
128    */
129   function unpause() onlyOwner whenPaused public {
130     paused = false;
131     Unpause();
132   }
133 }
134 
135 
136 
137 /**
138  * @title ERC20Basic
139  * @dev Simpler version of ERC20 interface
140  * @dev see https://github.com/ethereum/EIPs/issues/179
141  */
142 contract ERC20Basic {
143   function totalSupply() public view returns (uint256);
144   function balanceOf(address who) public view returns (uint256);
145   function transfer(address to, uint256 value) public returns (bool);
146   event Transfer(address indexed from, address indexed to, uint256 value);
147 }
148 
149 
150 
151 /**
152  * @title ERC20 interface
153  * @dev see https://github.com/ethereum/EIPs/issues/20
154  */
155 contract ERC20 is ERC20Basic {
156   function allowance(address owner, address spender) public view returns (uint256);
157   function transferFrom(address from, address to, uint256 value) public returns (bool);
158   function approve(address spender, uint256 value) public returns (bool);
159   event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161 
162 
163 
164 /**
165  * @title Basic token
166  * @dev Basic version of StandardToken, with no allowances.
167  */
168 contract BasicToken is ERC20Basic {
169   using SafeMath for uint256;
170 
171   mapping(address => uint256) balances;
172 
173   uint256 totalSupply_;
174 
175   /**
176   * @dev total number of tokens in existence
177   */
178   function totalSupply() public view returns (uint256) {
179     return totalSupply_;
180   }
181 
182   /**
183   * @dev transfer token for a specified address
184   * @param _to The address to transfer to.
185   * @param _value The amount to be transferred.
186   */
187   function transfer(address _to, uint256 _value) public returns (bool) {
188     require(_to != address(0));
189     require(_value <= balances[msg.sender]);
190 
191     // SafeMath.sub will throw if there is not enough balance.
192     balances[msg.sender] = balances[msg.sender].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     Transfer(msg.sender, _to, _value);
195     return true;
196   }
197 
198   /**
199   * @dev Gets the balance of the specified address.
200   * @param _owner The address to query the the balance of.
201   * @return An uint256 representing the amount owned by the passed address.
202   */
203   function balanceOf(address _owner) public view returns (uint256 balance) {
204     return balances[_owner];
205   }
206 
207 }
208 
209 
210 
211 
212 /**
213  * @title Standard ERC20 token
214  *
215  * @dev Implementation of the basic standard token.
216  * @dev https://github.com/ethereum/EIPs/issues/20
217  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
218  */
219 contract StandardToken is ERC20, BasicToken {
220 
221   mapping (address => mapping (address => uint256)) internal allowed;
222 
223 
224   /**
225    * @dev Transfer tokens from one address to another
226    * @param _from address The address which you want to send tokens from
227    * @param _to address The address which you want to transfer to
228    * @param _value uint256 the amount of tokens to be transferred
229    */
230   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
231     require(_to != address(0));
232     require(_value <= balances[_from]);
233     require(_value <= allowed[_from][msg.sender]);
234 
235     balances[_from] = balances[_from].sub(_value);
236     balances[_to] = balances[_to].add(_value);
237     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
238     Transfer(_from, _to, _value);
239     return true;
240   }
241 
242   /**
243    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
244    *
245    * Beware that changing an allowance with this method brings the risk that someone may use both the old
246    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
247    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
248    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249    * @param _spender The address which will spend the funds.
250    * @param _value The amount of tokens to be spent.
251    */
252   function approve(address _spender, uint256 _value) public returns (bool) {
253     allowed[msg.sender][_spender] = _value;
254     Approval(msg.sender, _spender, _value);
255     return true;
256   }
257 
258   /**
259    * @dev Function to check the amount of tokens that an owner allowed to a spender.
260    * @param _owner address The address which owns the funds.
261    * @param _spender address The address which will spend the funds.
262    * @return A uint256 specifying the amount of tokens still available for the spender.
263    */
264   function allowance(address _owner, address _spender) public view returns (uint256) {
265     return allowed[_owner][_spender];
266   }
267 
268   /**
269    * @dev Increase the amount of tokens that an owner allowed to a spender.
270    *
271    * approve should be called when allowed[_spender] == 0. To increment
272    * allowed value is better to use this function to avoid 2 calls (and wait until
273    * the first transaction is mined)
274    * From MonolithDAO Token.sol
275    * @param _spender The address which will spend the funds.
276    * @param _addedValue The amount of tokens to increase the allowance by.
277    */
278   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
279     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
280     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281     return true;
282   }
283 
284   /**
285    * @dev Decrease the amount of tokens that an owner allowed to a spender.
286    *
287    * approve should be called when allowed[_spender] == 0. To decrement
288    * allowed value is better to use this function to avoid 2 calls (and wait until
289    * the first transaction is mined)
290    * From MonolithDAO Token.sol
291    * @param _spender The address which will spend the funds.
292    * @param _subtractedValue The amount of tokens to decrease the allowance by.
293    */
294   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
295     uint oldValue = allowed[msg.sender][_spender];
296     if (_subtractedValue > oldValue) {
297       allowed[msg.sender][_spender] = 0;
298     } else {
299       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
300     }
301     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302     return true;
303   }
304 
305 }
306 
307 
308 /**
309  * @title Pausable token
310  * @dev StandardToken modified with pausable transfers.
311  **/
312 contract PausableToken is StandardToken, Pausable {
313 
314   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
315     return super.transfer(_to, _value);
316   }
317 
318   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
319     return super.transferFrom(_from, _to, _value);
320   }
321 
322   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
323     return super.approve(_spender, _value);
324   }
325 
326   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
327     return super.increaseApproval(_spender, _addedValue);
328   }
329 
330   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
331     return super.decreaseApproval(_spender, _subtractedValue);
332   }
333 }
334 
335 
336 
337 
338 contract ROLCToken is PausableToken {
339 
340   string public name = "ROLC Token";
341   string public symbol = "ROLC";
342   uint8 public decimals = 18;
343   uint256 public TOTAL_SUPPLY = 10000000000e18; // 10 billion Tokens.
344 
345   function ROLCToken () public {
346      totalSupply_ = TOTAL_SUPPLY;
347      balances[msg.sender] = TOTAL_SUPPLY;
348      Transfer(0x0, msg.sender, TOTAL_SUPPLY);
349   }
350 
351   function multiTransferDecimals(address[] _addresses, uint256[] amounts) public onlyOwner returns (bool success){
352      require(_addresses.length == amounts.length);
353      for (uint256 i = 0; i < _addresses.length; i++) {
354         transfer(_addresses[i], amounts[i] * 10**uint(decimals));
355      }
356      return true;
357   }
358 }