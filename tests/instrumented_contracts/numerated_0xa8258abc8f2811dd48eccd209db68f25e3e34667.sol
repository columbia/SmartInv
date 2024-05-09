1 pragma solidity ^0.4.11;
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
34   function Ownable() {
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
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that throw on error
75  */
76 library SafeMath {
77   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
78     uint256 c = a * b;
79     assert(a == 0 || c / a == b);
80     return c;
81   }
82 
83   function div(uint256 a, uint256 b) internal constant returns (uint256) {
84     // assert(b > 0); // Solidity automatically throws when dividing by 0
85     uint256 c = a / b;
86     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87     return c;
88   }
89 
90   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
91     assert(b <= a);
92     return a - b;
93   }
94 
95   function add(uint256 a, uint256 b) internal constant returns (uint256) {
96     uint256 c = a + b;
97     assert(c >= a);
98     return c;
99   }
100 }
101 
102 
103 
104 /**
105  * @title Basic token
106  * @dev Basic version of StandardToken, with no allowances.
107  */
108 contract BasicToken is ERC20Basic {
109   using SafeMath for uint256;
110 
111   mapping(address => uint256) balances;
112 
113   /**
114   * @dev transfer token for a specified address
115   * @param _to The address to transfer to.
116   * @param _value The amount to be transferred.
117   */
118   function transfer(address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120 
121     // SafeMath.sub will throw if there is not enough balance.
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     Transfer(msg.sender, _to, _value);
125     return true;
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) public constant returns (uint256 balance) {
134     return balances[_owner];
135   }
136 
137 }
138 
139 
140 
141 
142 
143 
144 
145 /**
146  * @title ERC20 interface
147  * @dev see https://github.com/ethereum/EIPs/issues/20
148  */
149 contract ERC20 is ERC20Basic {
150   function allowance(address owner, address spender) public constant returns (uint256);
151   function transferFrom(address from, address to, uint256 value) public returns (bool);
152   function approve(address spender, uint256 value) public returns (bool);
153   event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155 
156 
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * @dev https://github.com/ethereum/EIPs/issues/20
163  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167   mapping (address => mapping (address => uint256)) allowed;
168 
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177     require(_to != address(0));
178 
179     uint256 _allowance = allowed[_from][msg.sender];
180 
181     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
182     // require (_value <= _allowance);
183 
184     balances[_from] = balances[_from].sub(_value);
185     balances[_to] = balances[_to].add(_value);
186     allowed[_from][msg.sender] = _allowance.sub(_value);
187     Transfer(_from, _to, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193    *
194    * Beware that changing an allowance with this method brings the risk that someone may use both the old
195    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198    * @param _spender The address which will spend the funds.
199    * @param _value The amount of tokens to be spent.
200    */
201   function approve(address _spender, uint256 _value) public returns (bool) {
202     allowed[msg.sender][_spender] = _value;
203     Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens that an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint256 specifying the amount of tokens still available for the spender.
212    */
213   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
214     return allowed[_owner][_spender];
215   }
216 
217   /**
218    * approve should be called when allowed[_spender] == 0. To increment
219    * allowed value is better to use this function to avoid 2 calls (and wait until
220    * the first transaction is mined)
221    * From MonolithDAO Token.sol
222    */
223   function increaseApproval (address _spender, uint _addedValue)
224     returns (bool success) {
225     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
226     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230   function decreaseApproval (address _spender, uint _subtractedValue)
231     returns (bool success) {
232     uint oldValue = allowed[msg.sender][_spender];
233     if (_subtractedValue > oldValue) {
234       allowed[msg.sender][_spender] = 0;
235     } else {
236       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237     }
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 }
243 
244 
245 
246 
247 
248 
249 
250 /**
251  * @title Pausable
252  * @dev Base contract which allows children to implement an emergency stop mechanism.
253  */
254 contract Pausable is Ownable {
255   event Pause();
256   event Unpause();
257 
258   bool public paused = false;
259 
260 
261   /**
262    * @dev Modifier to make a function callable only when the contract is not paused.
263    */
264   modifier whenNotPaused() {
265     require(!paused);
266     _;
267   }
268 
269   /**
270    * @dev Modifier to make a function callable only when the contract is paused.
271    */
272   modifier whenPaused() {
273     require(paused);
274     _;
275   }
276 
277   /**
278    * @dev called by the owner to pause, triggers stopped state
279    */
280   function pause() onlyOwner whenNotPaused public {
281     paused = true;
282     Pause();
283   }
284 
285   /**
286    * @dev called by the owner to unpause, returns to normal state
287    */
288   function unpause() onlyOwner whenPaused public {
289     paused = false;
290     Unpause();
291   }
292 }
293 
294 
295 
296 /**
297  * @title Element Token
298  * @dev ERC20 Element Token)
299  *
300  * All initial tokens are assigned to the creator of
301  * this contract.
302  *
303  */
304 contract ElementToken is StandardToken, Pausable {
305 
306   string public name = '';               // Set the token name for display
307   string public symbol = '';             // Set the token symbol for display
308   uint8 public decimals = 0;             // Set the token symbol for display
309 
310   /**
311    * @dev Don't allow tokens to be sent to the contract
312    */
313   modifier rejectTokensToContract(address _to) {
314     require(_to != address(this));
315     _;
316   }
317 
318   /**
319    * @dev ElementToken Constructor
320    * Runs only on initial contract creation.
321    */
322   function ElementToken(string _name, string _symbol, uint256 _tokens, uint8 _decimals) {
323     name = _name;
324     symbol = _symbol;
325     decimals = _decimals;
326     totalSupply = _tokens * 10**uint256(decimals);          // Set the total supply
327     balances[msg.sender] = totalSupply;                      // Creator address is assigned all
328     Transfer(0x0, msg.sender, totalSupply);                  // create Transfer event for minting
329   }
330 
331   /**
332    * @dev Transfer token for a specified address when not paused
333    * @param _to The address to transfer to.
334    * @param _value The amount to be transferred.
335    */
336   function transfer(address _to, uint256 _value) rejectTokensToContract(_to) public whenNotPaused returns (bool) {
337     return super.transfer(_to, _value);
338   }
339 
340   /**
341    * @dev Transfer tokens from one address to another when not paused
342    * @param _from address The address which you want to send tokens from
343    * @param _to address The address which you want to transfer to
344    * @param _value uint256 the amount of tokens to be transferred
345    */
346   function transferFrom(address _from, address _to, uint256 _value) rejectTokensToContract(_to) public whenNotPaused returns (bool) {
347     return super.transferFrom(_from, _to, _value);
348   }
349 
350   /**
351    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
352    * @param _spender The address which will spend the funds.
353    * @param _value The amount of tokens to be spent.
354    */
355   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
356     return super.approve(_spender, _value);
357   }
358 
359   /**
360    * Adding whenNotPaused
361    */
362   function increaseApproval (address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
363     return super.increaseApproval(_spender, _addedValue);
364   }
365 
366   /**
367    * Adding whenNotPaused
368    */
369   function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
370     return super.decreaseApproval(_spender, _subtractedValue);
371   }
372 
373 }