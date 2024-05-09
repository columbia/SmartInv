1 // B3log Token
2 //   https://hacpai.com
3 //   https://github.com/b3log
4 pragma solidity ^0.4.18;
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   /**
35   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
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
87 }
88 
89 /**
90  * @title Pausable
91  * @dev Base contract which allows children to implement an emergency stop mechanism.
92  */
93 contract Pausable is Ownable {
94   event Pause();
95   event Unpause();
96 
97   bool public paused = false;
98 
99   /**
100    * @dev Modifier to make a function callable only when the contract is not paused.
101    */
102   modifier whenNotPaused() {
103     require(!paused);
104     _;
105   }
106 
107   /**
108    * @dev Modifier to make a function callable only when the contract is paused.
109    */
110   modifier whenPaused() {
111     require(paused);
112     _;
113   }
114 
115   /**
116    * @dev called by the owner to pause, triggers stopped state
117    */
118   function pause() onlyOwner whenNotPaused public {
119     paused = true;
120     Pause();
121   }
122 
123   /**
124    * @dev called by the owner to unpause, returns to normal state
125    */
126   function unpause() onlyOwner whenPaused public {
127     paused = false;
128     Unpause();
129   }
130 }
131 
132 /**
133  * @title ERC20Basic
134  * @dev Simpler version of ERC20 interface
135  * @dev see https://github.com/ethereum/EIPs/issues/179
136  */
137 contract ERC20Basic {
138   uint256 public totalSupply;
139   function balanceOf(address who) public view returns (uint256);
140   function transfer(address to, uint256 value) public returns (bool);
141   event Transfer(address indexed from, address indexed to, uint256 value);
142 }
143 
144 /**
145  * @title ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/20
147  */
148 contract ERC20 is ERC20Basic {
149   function allowance(address owner, address spender) public view returns (uint256);
150   function transferFrom(address from, address to, uint256 value) public returns (bool);
151   function approve(address spender, uint256 value) public returns (bool);
152   event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 /**
156  * @title Basic token
157  * @dev Basic version of StandardToken, with no allowances.
158  */
159 contract BasicToken is ERC20Basic {
160   using SafeMath for uint256;
161 
162   mapping(address => uint256) balances;
163 
164   /**
165   * @dev transfer token for a specified address
166   * @param _to The address to transfer to.
167   * @param _value The amount to be transferred.
168   */
169   function transfer(address _to, uint256 _value) public returns (bool) {
170     require(_to != address(0));
171     require(_value <= balances[msg.sender]);
172 
173     // SafeMath.sub will throw if there is not enough balance.
174     balances[msg.sender] = balances[msg.sender].sub(_value);
175     balances[_to] = balances[_to].add(_value);
176     Transfer(msg.sender, _to, _value);
177     return true;
178   }
179 
180   /**
181   * @dev Gets the balance of the specified address.
182   * @param _owner The address to query the the balance of.
183   * @return An uint256 representing the amount owned by the passed address.
184   */
185   function balanceOf(address _owner) public view returns (uint256 balance) {
186     return balances[_owner];
187   }
188 
189 }
190 
191 /**
192  * @title Standard ERC20 token
193  *
194  * @dev Implementation of the basic standard token.
195  * @dev https://github.com/ethereum/EIPs/issues/20
196  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
197  */
198 contract StandardToken is ERC20, BasicToken {
199 
200   mapping (address => mapping (address => uint256)) internal allowed;
201 
202 
203   /**
204    * @dev Transfer tokens from one address to another
205    * @param _from address The address which you want to send tokens from
206    * @param _to address The address which you want to transfer to
207    * @param _value uint256 the amount of tokens to be transferred
208    */
209   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
210     require(_to != address(0));
211     require(_value <= balances[_from]);
212     require(_value <= allowed[_from][msg.sender]);
213 
214     balances[_from] = balances[_from].sub(_value);
215     balances[_to] = balances[_to].add(_value);
216     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
217     Transfer(_from, _to, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
223    *
224    * Beware that changing an allowance with this method brings the risk that someone may use both the old
225    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
226    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
227    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228    * @param _spender The address which will spend the funds.
229    * @param _value The amount of tokens to be spent.
230    */
231   function approve(address _spender, uint256 _value) public returns (bool) {
232     allowed[msg.sender][_spender] = _value;
233     Approval(msg.sender, _spender, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Function to check the amount of tokens that an owner allowed to a spender.
239    * @param _owner address The address which owns the funds.
240    * @param _spender address The address which will spend the funds.
241    * @return A uint256 specifying the amount of tokens still available for the spender.
242    */
243   function allowance(address _owner, address _spender) public view returns (uint256) {
244     return allowed[_owner][_spender];
245   }
246 
247   /**
248    * @dev Increase the amount of tokens that an owner allowed to a spender.
249    *
250    * approve should be called when allowed[_spender] == 0. To increment
251    * allowed value is better to use this function to avoid 2 calls (and wait until
252    * the first transaction is mined)
253    * From MonolithDAO Token.sol
254    * @param _spender The address which will spend the funds.
255    * @param _addedValue The amount of tokens to increase the allowance by.
256    */
257   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
258     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
259     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263   /**
264    * @dev Decrease the amount of tokens that an owner allowed to a spender.
265    *
266    * approve should be called when allowed[_spender] == 0. To decrement
267    * allowed value is better to use this function to avoid 2 calls (and wait until
268    * the first transaction is mined)
269    * From MonolithDAO Token.sol
270    * @param _spender The address which will spend the funds.
271    * @param _subtractedValue The amount of tokens to decrease the allowance by.
272    */
273   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
274     uint oldValue = allowed[msg.sender][_spender];
275     if (_subtractedValue > oldValue) {
276       allowed[msg.sender][_spender] = 0;
277     } else {
278       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
279     }
280     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281     return true;
282   }
283 }
284 
285 /**
286  * @title Pausable token
287  *
288  * @dev StandardToken modified with pausable transfers.
289  **/
290 contract PausableToken is StandardToken, Pausable {
291 
292   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
293     return super.transfer(_to, _value);
294   }
295 
296   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
297     return super.transferFrom(_from, _to, _value);
298   }
299 
300   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
301     return super.approve(_spender, _value);
302   }
303 
304   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
305     return super.increaseApproval(_spender, _addedValue);
306   }
307 
308   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
309     return super.decreaseApproval(_spender, _subtractedValue);
310   }
311 }
312 
313 /**
314  * @title Burnable Token
315  * @dev Token that can be irreversibly burned (destroyed).
316  */
317 contract BurnableToken is PausableToken {
318 
319   event Burn(address indexed burner, uint256 value);
320 
321   /**
322    * @dev Burns a specific amount of tokens.
323    * @param _value The amount of token to be burned.
324    */
325   function burn(uint256 _value) public {
326     require(_value <= balances[msg.sender]);
327     // no need to require value <= totalSupply, since that would imply the
328     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
329 
330     address burner = msg.sender;
331     balances[burner] = balances[burner].sub(_value);
332     totalSupply = totalSupply.sub(_value);
333     Burn(burner, _value);
334   }
335 }
336 
337 /**
338  * @title B3log Token
339  * @dev ERC20 B3log Token
340  */
341 contract B3T is BurnableToken {
342 
343   string public name = "B3log Token";
344   string public symbol = "B3T";
345   uint8 public decimals = 18;
346 
347   uint256 public constant INITIAL_SUPPLY = 2000000000 * 10**uint256(18);
348 
349   /**
350    * @dev Constructor that gives msg.sender all of existing tokens.
351    */
352   function B3T() public {
353     totalSupply = INITIAL_SUPPLY;
354     balances[msg.sender] = INITIAL_SUPPLY;
355     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
356   }
357 }