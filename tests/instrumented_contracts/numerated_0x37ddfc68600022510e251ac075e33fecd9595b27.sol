1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public constant returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) onlyOwner public {
53     require(newOwner != address(0));
54     emit OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 }
58 
59 
60 
61 
62 /**
63  * @title SafeMath
64  * @dev Math operations with safety checks that throw on error
65  */
66 library SafeMath {
67   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a * b;
69     assert(a == 0 || c / a == b);
70     return c;
71   }
72 
73   function div(uint256 a, uint256 b) internal pure returns (uint256) {
74     // assert(b > 0); // Solidity automatically throws when dividing by 0
75     uint256 c = a / b;
76     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77     return c;
78   }
79 
80   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81     assert(b <= a);
82     return a - b;
83   }
84 
85   function add(uint256 a, uint256 b) internal pure returns (uint256) {
86     uint256 c = a + b;
87     assert(c >= a);
88     return c;
89   }
90 }
91 
92 
93 
94 /**
95  * @title Basic token
96  * @dev Basic version of StandardToken, with no allowances.
97  */
98 contract BasicToken is ERC20Basic {
99   using SafeMath for uint256;
100 
101   mapping(address => uint256) balances;
102 
103   /**
104   * @dev transfer token for a specified address
105   * @param _to The address to transfer to.
106   * @param _value The amount to be transferred.
107   */
108   function transfer(address _to, uint256 _value) public returns (bool) {
109     require(_to != address(0));
110 
111     // SafeMath.sub will throw if there is not enough balance.
112     balances[msg.sender] = balances[msg.sender].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     emit Transfer(msg.sender, _to, _value);
115     return true;
116   }
117 
118   /**
119   * @dev Gets the balance of the specified address.
120   * @param _owner The address to query the the balance of.
121   * @return An uint256 representing the amount owned by the passed address.
122   */
123   function balanceOf(address _owner) public constant returns (uint256 balance) {
124     return balances[_owner];
125   }
126 
127 }
128 
129 
130 
131 
132 
133 
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 contract ERC20 is ERC20Basic {
140   function allowance(address owner, address spender) public constant returns (uint256);
141   function transferFrom(address from, address to, uint256 value) public returns (bool);
142   function approve(address spender, uint256 value) public returns (bool);
143   event Approval(address indexed owner, address indexed spender, uint256 value);
144 }
145 
146 
147 
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * @dev https://github.com/ethereum/EIPs/issues/20
153  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  */
155 contract StandardToken is ERC20, BasicToken {
156 
157   mapping (address => mapping (address => uint256)) allowed;
158 
159 
160   /**
161    * @dev Transfer tokens from one address to another
162    * @param _from address The address which you want to send tokens from
163    * @param _to address The address which you want to transfer to
164    * @param _value uint256 the amount of tokens to be transferred
165    */
166   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
167     require(_to != address(0));
168 
169     uint256 _allowance = allowed[_from][msg.sender];
170 
171     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
172     // require (_value <= _allowance);
173 
174     balances[_from] = balances[_from].sub(_value);
175     balances[_to] = balances[_to].add(_value);
176     allowed[_from][msg.sender] = _allowance.sub(_value);
177     emit Transfer(_from, _to, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
183    *
184    * Beware that changing an allowance with this method brings the risk that someone may use both the old
185    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
186    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
187    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188    * @param _spender The address which will spend the funds.
189    * @param _value The amount of tokens to be spent.
190    */
191   function approve(address _spender, uint256 _value) public returns (bool) {
192     allowed[msg.sender][_spender] = _value;
193     emit Approval(msg.sender, _spender, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Function to check the amount of tokens that an owner allowed to a spender.
199    * @param _owner address The address which owns the funds.
200    * @param _spender address The address which will spend the funds.
201    * @return A uint256 specifying the amount of tokens still available for the spender.
202    */
203   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    */
213   function increaseApproval (address _spender, uint _addedValue) public
214     returns (bool success) {
215     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
216     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220   function decreaseApproval (address _spender, uint _subtractedValue) public
221     returns (bool success) {
222     uint oldValue = allowed[msg.sender][_spender];
223     if (_subtractedValue > oldValue) {
224       allowed[msg.sender][_spender] = 0;
225     } else {
226       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
227     }
228     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229     return true;
230   }
231 
232 }
233 
234 
235 
236 /**
237  * @title Pausable
238  * @dev Base contract which allows children to implement an emergency stop mechanism.
239  */
240 contract Pausable is Ownable {
241   event Pause();
242   event Unpause();
243 
244   bool public paused = false;
245 
246 
247   /**
248    * @dev Modifier to make a function callable only when the contract is not paused.
249    */
250   modifier whenNotPaused() {
251     require(!paused);
252     _;
253   }
254 
255   /**
256    * @dev Modifier to make a function callable only when the contract is paused.
257    */
258   modifier whenPaused() {
259     require(paused);
260     _;
261   }
262 
263   /**
264    * @dev called by the owner to pause, triggers stopped state
265    */
266   function pause() onlyOwner whenNotPaused public {
267     paused = true;
268     emit Pause();
269   }
270 
271   /**
272    * @dev called by the owner to unpause, returns to normal state
273    */
274   function unpause() onlyOwner whenPaused public {
275     paused = false;
276     emit Unpause();
277   }
278 }
279 
280 
281 
282 /**
283  * @title GBN Coin
284  * @dev ERC20 Element Token)
285  *
286  * All initial tokens are assigned to the creator of
287  * this contract.
288  *
289  */
290 contract GBNC is StandardToken, Pausable {
291 
292   string public name = "";               // Set the token name for display
293   string public symbol = "";             // Set the token symbol for display
294   uint8 public decimals = 0;             // Set the token symbol for display
295 
296   /**
297    * @dev Don't allow tokens to be sent to the contract
298    */
299   modifier rejectTokensToContract(address _to) {
300     require(_to != address(this));
301     _;
302   }
303 
304   /**
305    * @dev GBNC Constructor
306    * Runs only on initial contract creation.
307    */
308   function GBNC(string _name, string _symbol, uint256 _tokens, uint8 _decimals) public {
309     name = _name;
310     symbol = _symbol;
311     decimals = _decimals;
312     totalSupply = _tokens * 10**uint256(decimals);          // Set the total supply
313     balances[msg.sender] = totalSupply;                      // Creator address is assigned all
314     emit Transfer(0x0, msg.sender, totalSupply);                  // create Transfer event for minting
315   }
316 
317   /**
318    * @dev Transfer token for a specified address when not paused
319    * @param _to The address to transfer to.
320    * @param _value The amount to be transferred.
321    */
322   function transfer(address _to, uint256 _value) rejectTokensToContract(_to) public whenNotPaused returns (bool) {
323     return super.transfer(_to, _value);
324   }
325 
326   /**
327    * @dev Transfer tokens from one address to another when not paused
328    * @param _from address The address which you want to send tokens from
329    * @param _to address The address which you want to transfer to
330    * @param _value uint256 the amount of tokens to be transferred
331    */
332   function transferFrom(address _from, address _to, uint256 _value) rejectTokensToContract(_to) public whenNotPaused returns (bool) {
333     return super.transferFrom(_from, _to, _value);
334   }
335 
336   /**
337    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
338    * @param _spender The address which will spend the funds.
339    * @param _value The amount of tokens to be spent.
340    */
341   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
342     return super.approve(_spender, _value);
343   }
344 
345   /**
346    * Adding whenNotPaused
347    */
348   function increaseApproval (address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
349     return super.increaseApproval(_spender, _addedValue);
350   }
351 
352   /**
353    * Adding whenNotPaused
354    */
355   function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
356     return super.decreaseApproval(_spender, _subtractedValue);
357   }
358 }