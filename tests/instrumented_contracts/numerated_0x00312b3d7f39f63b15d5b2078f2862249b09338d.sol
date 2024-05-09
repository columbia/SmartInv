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
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23   address public owner;
24 
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28 
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   function Ownable() {
34     owner = msg.sender;
35   }
36 
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address newOwner) onlyOwner public {
52     require(newOwner != address(0));
53     OwnershipTransferred(owner, newOwner);
54     owner = newOwner;
55   }
56 
57 }
58 
59 
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that throw on error
63  */
64 library SafeMath {
65   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
66     uint256 c = a * b;
67     assert(a == 0 || c / a == b);
68     return c;
69   }
70 
71   function div(uint256 a, uint256 b) internal constant returns (uint256) {
72     // assert(b > 0); // Solidity automatically throws when dividing by 0
73     uint256 c = a / b;
74     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75     return c;
76   }
77 
78   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   function add(uint256 a, uint256 b) internal constant returns (uint256) {
84     uint256 c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 
90 
91 /**
92  * @title Basic token
93  * @dev Basic version of StandardToken, with no allowances.
94  */
95 contract BasicToken is ERC20Basic {
96   using SafeMath for uint256;
97 
98   mapping(address => uint256) balances;
99 
100   /**
101   * @dev transfer token for a specified address
102   * @param _to The address to transfer to.
103   * @param _value The amount to be transferred.
104   */
105   function transfer(address _to, uint256 _value) public returns (bool) {
106     require(_to != address(0));
107 
108     // SafeMath.sub will throw if there is not enough balance.
109     balances[msg.sender] = balances[msg.sender].sub(_value);
110     balances[_to] = balances[_to].add(_value);
111     Transfer(msg.sender, _to, _value);
112     return true;
113   }
114 
115   /**
116   * @dev Gets the balance of the specified address.
117   * @param _owner The address to query the the balance of.
118   * @return An uint256 representing the amount owned by the passed address.
119   */
120   function balanceOf(address _owner) public constant returns (uint256 balance) {
121     return balances[_owner];
122   }
123 
124 }
125 
126 
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 is ERC20Basic {
132   function allowance(address owner, address spender) public constant returns (uint256);
133   function transferFrom(address from, address to, uint256 value) public returns (bool);
134   function approve(address spender, uint256 value) public returns (bool);
135   event Approval(address indexed owner, address indexed spender, uint256 value);
136 }
137 
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is ERC20, BasicToken {
147 
148   mapping (address => mapping (address => uint256)) allowed;
149 
150 
151   /**
152    * @dev Transfer tokens from one address to another
153    * @param _from address The address which you want to send tokens from
154    * @param _to address The address which you want to transfer to
155    * @param _value uint256 the amount of tokens to be transferred
156    */
157   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158     require(_to != address(0));
159 
160     uint256 _allowance = allowed[_from][msg.sender];
161 
162     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
163     // require (_value <= _allowance);
164 
165     balances[_from] = balances[_from].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     allowed[_from][msg.sender] = _allowance.sub(_value);
168     Transfer(_from, _to, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174    *
175    * Beware that changing an allowance with this method brings the risk that someone may use both the old
176    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179    * @param _spender The address which will spend the funds.
180    * @param _value The amount of tokens to be spent.
181    */
182   function approve(address _spender, uint256 _value) public returns (bool) {
183     allowed[msg.sender][_spender] = _value;
184     Approval(msg.sender, _spender, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Function to check the amount of tokens that an owner allowed to a spender.
190    * @param _owner address The address which owns the funds.
191    * @param _spender address The address which will spend the funds.
192    * @return A uint256 specifying the amount of tokens still available for the spender.
193    */
194   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
195     return allowed[_owner][_spender];
196   }
197 
198   /**
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    */
204   function increaseApproval (address _spender, uint _addedValue)
205     returns (bool success) {
206     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
207     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211   function decreaseApproval (address _spender, uint _subtractedValue)
212     returns (bool success) {
213     uint oldValue = allowed[msg.sender][_spender];
214     if (_subtractedValue > oldValue) {
215       allowed[msg.sender][_spender] = 0;
216     } else {
217       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
218     }
219     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220     return true;
221   }
222 
223 }
224 
225 
226 /**
227  * @title Pausable
228  * @dev Base contract which allows children to implement an emergency stop mechanism.
229  */
230 contract Pausable is Ownable {
231   event Pause();
232   event Unpause();
233 
234   bool public paused = false;
235 
236 
237   /**
238    * @dev Modifier to make a function callable only when the contract is not paused.
239    */
240   modifier whenNotPaused() {
241     require(!paused);
242     _;
243   }
244 
245   /**
246    * @dev Modifier to make a function callable only when the contract is paused.
247    */
248   modifier whenPaused() {
249     require(paused);
250     _;
251   }
252 
253   /**
254    * @dev called by the owner to pause, triggers stopped state
255    */
256   function pause() onlyOwner whenNotPaused public {
257     paused = true;
258     Pause();
259   }
260 
261   /**
262    * @dev called by the owner to unpause, returns to normal state
263    */
264   function unpause() onlyOwner whenPaused public {
265     paused = false;
266     Unpause();
267   }
268 }
269 
270 contract APToken is StandardToken, Pausable {
271 
272   string public constant name = 'APT Token';                              // Set the token name for display
273   string public constant symbol = 'APT';                                  // Set the token symbol for display
274   uint8 public constant decimals = 18;                                     // Set the number of decimals for display
275   uint256 public constant INITIAL_SUPPLY = 5e8 * 10**uint256(decimals); // supply specified in Grains
276 
277   /**
278    * @dev Modifier to make a function callable only when the contract is not paused.
279    */
280   modifier rejectTokensToContract(address _to) {
281     require(_to != address(this));
282     _;
283   }
284 
285   /**
286    * @dev APToken Constructor
287    * Runs only on initial contract creation.
288    */
289   function APToken() {
290     totalSupply = INITIAL_SUPPLY;                               // Set the total supply
291     balances[msg.sender] = INITIAL_SUPPLY;                      // Creator address is assigned all
292     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
293   }
294 
295   /**
296    * @dev Transfer token for a specified address when not paused
297    * @param _to The address to transfer to.
298    * @param _value The amount to be transferred.
299    */
300   function transfer(address _to, uint256 _value) rejectTokensToContract(_to) public whenNotPaused returns (bool) {
301     return super.transfer(_to, _value);
302   }
303 
304   /**
305    * @dev Transfer tokens from one address to another when not paused
306    * @param _from address The address which you want to send tokens from
307    * @param _to address The address which you want to transfer to
308    * @param _value uint256 the amount of tokens to be transferred
309    */
310   function transferFrom(address _from, address _to, uint256 _value) rejectTokensToContract(_to) public whenNotPaused returns (bool) {
311     return super.transferFrom(_from, _to, _value);
312   }
313 
314   /**
315    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
316    * @param _spender The address which will spend the funds.
317    * @param _value The amount of tokens to be spent.
318    */
319   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
320     return super.approve(_spender, _value);
321   }
322 
323   /**
324    * Adding whenNotPaused
325    */
326   function increaseApproval (address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
327     return super.increaseApproval(_spender, _addedValue);
328   }
329 
330   /**
331    * Adding whenNotPaused
332    */
333   function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
334     return super.decreaseApproval(_spender, _subtractedValue);
335   }
336 
337 }