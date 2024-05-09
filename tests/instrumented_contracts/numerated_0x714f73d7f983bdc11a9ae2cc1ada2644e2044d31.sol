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
71 /**
72  * @title SafeMath
73  * @dev Math operations with safety checks that throw on error
74  */
75 library SafeMath {
76   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
77     uint256 c = a * b;
78     assert(a == 0 || c / a == b);
79     return c;
80   }
81 
82   function div(uint256 a, uint256 b) internal constant returns (uint256) {
83     // assert(b > 0); // Solidity automatically throws when dividing by 0
84     uint256 c = a / b;
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86     return c;
87   }
88 
89   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
90     assert(b <= a);
91     return a - b;
92   }
93 
94   function add(uint256 a, uint256 b) internal constant returns (uint256) {
95     uint256 c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 
101 
102 
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances.
106  */
107 contract BasicToken is ERC20Basic {
108   using SafeMath for uint256;
109 
110   mapping(address => uint256) balances;
111 
112   /**
113   * @dev transfer token for a specified address
114   * @param _to The address to transfer to.
115   * @param _value The amount to be transferred.
116   */
117   function transfer(address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119 
120     // SafeMath.sub will throw if there is not enough balance.
121     balances[msg.sender] = balances[msg.sender].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     Transfer(msg.sender, _to, _value);
124     return true;
125   }
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param _owner The address to query the the balance of.
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address _owner) public constant returns (uint256 balance) {
133     return balances[_owner];
134   }
135 
136 }
137 
138 
139 
140 
141 
142 
143 
144 /**
145  * @title ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/20
147  */
148 contract ERC20 is ERC20Basic {
149   function allowance(address owner, address spender) public constant returns (uint256);
150   function transferFrom(address from, address to, uint256 value) public returns (bool);
151   function approve(address spender, uint256 value) public returns (bool);
152   event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165 
166   mapping (address => mapping (address => uint256)) allowed;
167 
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param _from address The address which you want to send tokens from
172    * @param _to address The address which you want to transfer to
173    * @param _value uint256 the amount of tokens to be transferred
174    */
175   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177 
178     uint256 _allowance = allowed[_from][msg.sender];
179 
180     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
181     // require (_value <= _allowance);
182 
183     balances[_from] = balances[_from].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185     allowed[_from][msg.sender] = _allowance.sub(_value);
186     Transfer(_from, _to, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192    *
193    * Beware that changing an allowance with this method brings the risk that someone may use both the old
194    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197    * @param _spender The address which will spend the funds.
198    * @param _value The amount of tokens to be spent.
199    */
200   function approve(address _spender, uint256 _value) public returns (bool) {
201     allowed[msg.sender][_spender] = _value;
202     Approval(msg.sender, _spender, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Function to check the amount of tokens that an owner allowed to a spender.
208    * @param _owner address The address which owns the funds.
209    * @param _spender address The address which will spend the funds.
210    * @return A uint256 specifying the amount of tokens still available for the spender.
211    */
212   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
213     return allowed[_owner][_spender];
214   }
215 
216   /**
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    */
222   function increaseApproval (address _spender, uint _addedValue)
223     returns (bool success) {
224     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   function decreaseApproval (address _spender, uint _subtractedValue)
230     returns (bool success) {
231     uint oldValue = allowed[msg.sender][_spender];
232     if (_subtractedValue > oldValue) {
233       allowed[msg.sender][_spender] = 0;
234     } else {
235       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236     }
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241 }
242 
243 
244 
245 
246 
247 
248 
249 /**
250  * @title Pausable
251  * @dev Base contract which allows children to implement an emergency stop mechanism.
252  */
253 contract Pausable is Ownable {
254   event Pause();
255   event Unpause();
256 
257   bool public paused = false;
258 
259 
260   /**
261    * @dev Modifier to make a function callable only when the contract is not paused.
262    */
263   modifier whenNotPaused() {
264     require(!paused);
265     _;
266   }
267 
268   /**
269    * @dev Modifier to make a function callable only when the contract is paused.
270    */
271   modifier whenPaused() {
272     require(paused);
273     _;
274   }
275 
276   /**
277    * @dev called by the owner to pause, triggers stopped state
278    */
279   function pause() onlyOwner whenNotPaused public {
280     paused = true;
281     Pause();
282   }
283 
284   /**
285    * @dev called by the owner to unpause, returns to normal state
286    */
287   function unpause() onlyOwner whenPaused public {
288     paused = false;
289     Unpause();
290   }
291 }
292 
293 
294 
295 /**
296  * @title Bitcoin Petrol
297  * @dev ERC20 BTCX Token
298  *
299  * BTCX Tokens are divisible by 1e8 (100,000,000) base
300  * units referred to as 'Grains'.
301  *
302  * BTCX are displayed using 8 decimal places of precision.
303  *
304  * 1.85 Billion Bitcoin Petrol total supply (185 Quadrillion Grains):
305  *   1,850,000,000 * 1e8 == 185e7 * 10**8 == 185e15
306  *
307  * All initial BTCX Grains are assigned to the creator of
308  * this contract.
309  */
310 contract BitcoinPetrol is StandardToken, Pausable {
311 
312   string public constant name = 'Bitcoin Petrol';                              // Set the token name for display
313   string public constant symbol = 'BTCX';                                  // Set the token symbol for display
314   uint8 public constant decimals = 8;                                     // Set the number of decimals for display
315   uint256 public constant INITIAL_SUPPLY = 185e7 * 10**uint256(decimals); // supply specified in Grains
316 
317   /**
318    * @dev Modifier to make a function callable only when the contract is not paused.
319    */
320   modifier rejectTokensToContract(address _to) {
321     require(_to != address(this));
322     _;
323   }
324 
325   /**
326    * @dev BitcoinPetrol Constructor
327    * Runs only on initial contract creation.
328    */
329   function BitcoinPetrol() {
330     totalSupply = INITIAL_SUPPLY;                               // Set the total supply
331     balances[msg.sender] = INITIAL_SUPPLY;                      // Creator address is assigned all
332     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
333   }
334 
335   /**
336    * @dev Transfer token for a specified address when not paused
337    * @param _to The address to transfer to.
338    * @param _value The amount to be transferred.
339    */
340   function transfer(address _to, uint256 _value) rejectTokensToContract(_to) public whenNotPaused returns (bool) {
341     return super.transfer(_to, _value);
342   }
343 
344   /**
345    * @dev Transfer tokens from one address to another when not paused
346    * @param _from address The address which you want to send tokens from
347    * @param _to address The address which you want to transfer to
348    * @param _value uint256 the amount of tokens to be transferred
349    */
350   function transferFrom(address _from, address _to, uint256 _value) rejectTokensToContract(_to) public whenNotPaused returns (bool) {
351     return super.transferFrom(_from, _to, _value);
352   }
353 
354   /**
355    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
356    * @param _spender The address which will spend the funds.
357    * @param _value The amount of tokens to be spent.
358    */
359   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
360     return super.approve(_spender, _value);
361   }
362 
363   /**
364    * Adding whenNotPaused
365    */
366   function increaseApproval (address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
367     return super.increaseApproval(_spender, _addedValue);
368   }
369 
370   /**
371    * Adding whenNotPaused
372    */
373   function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
374     return super.decreaseApproval(_spender, _subtractedValue);
375   }
376 
377 }