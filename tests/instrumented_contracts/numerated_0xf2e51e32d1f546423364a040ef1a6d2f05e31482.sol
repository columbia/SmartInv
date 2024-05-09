1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) returns (bool);
52   function approve(address spender, uint256 value) returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) returns (bool) {
71     balances[msg.sender] = balances[msg.sender].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     Transfer(msg.sender, _to, _value);
74     return true;
75   }
76 
77   /**
78   * @dev Gets the balance of the specified address.
79   * @param _owner The address to query the the balance of.
80   * @return An uint256 representing the amount owned by the passed address.
81   */
82   function balanceOf(address _owner) constant returns (uint256 balance) {
83     return balances[_owner];
84   }
85 
86 }
87 
88 /**
89  * @title Standard ERC20 token
90  *
91  * @dev Implementation of the basic standard token.
92  * @dev https://github.com/ethereum/EIPs/issues/20
93  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
94  */
95 contract StandardToken is ERC20, BasicToken {
96 
97   mapping (address => mapping (address => uint256)) allowed;
98 
99 
100   /**
101    * @dev Transfer tokens from one address to another
102    * @param _from address The address which you want to send tokens from
103    * @param _to address The address which you want to transfer to
104    * @param _value uint256 the amout of tokens to be transfered
105    */
106   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
107     var _allowance = allowed[_from][msg.sender];
108 
109     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
110     // require (_value <= _allowance);
111 
112     balances[_to] = balances[_to].add(_value);
113     balances[_from] = balances[_from].sub(_value);
114     allowed[_from][msg.sender] = _allowance.sub(_value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   /**
120    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
121    * @param _spender The address which will spend the funds.
122    * @param _value The amount of tokens to be spent.
123    */
124   function approve(address _spender, uint256 _value) returns (bool) {
125 
126     // To change the approve amount you first have to reduce the addresses`
127     //  allowance to zero by calling `approve(_spender, 0)` if it is not
128     //  already 0 to mitigate the race condition described here:
129     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131 
132     allowed[msg.sender][_spender] = _value;
133     Approval(msg.sender, _spender, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifing the amount of tokens still avaible for the spender.
142    */
143   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144     return allowed[_owner][_spender];
145   }
146 
147 }
148 
149 /**
150  * @title Ownable
151  * @dev The Ownable contract has an owner address, and provides basic authorization control
152  * functions, this simplifies the implementation of "user permissions".
153  */
154 contract Ownable {
155   address public owner;
156 
157 
158   /**
159    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160    * account.
161    */
162   function Ownable() {
163     owner = msg.sender;
164   }
165 
166 
167   /**
168    * @dev Throws if called by any account other than the owner.
169    */
170   modifier onlyOwner() {
171     require(msg.sender == owner);
172     _;
173   }
174 
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address newOwner) onlyOwner {
181     if (newOwner != address(0)) {
182       owner = newOwner;
183     }
184   }
185 
186 }
187 
188 /**
189  * @title Pausable
190  * @dev Base contract which allows children to implement an emergency stop mechanism.
191  */
192 contract Pausable is Ownable {
193   event Pause();
194   event Unpause();
195 
196   bool public paused = false;
197 
198 
199   /**
200    * @dev modifier to allow actions only when the contract IS paused
201    */
202   modifier whenNotPaused() {
203     require(!paused);
204     _;
205   }
206 
207   /**
208    * @dev modifier to allow actions only when the contract IS NOT paused
209    */
210   modifier whenPaused {
211     require(paused);
212     _;
213   }
214 
215   /**
216    * @dev called by the owner to pause, triggers stopped state
217    */
218   function pause() onlyOwner whenNotPaused returns (bool) {
219     paused = true;
220     Pause();
221     return true;
222   }
223 
224   /**
225    * @dev called by the owner to unpause, returns to normal state
226    */
227   function unpause() onlyOwner whenPaused returns (bool) {
228     paused = false;
229     Unpause();
230     return true;
231   }
232 }
233 
234 /**
235  * @title Hubcoin Token
236  * @dev ERC20 Hubcoin Token (HUB)
237  *
238  * HUB Tokens are divisible by 1e8 (100,000,000) base
239  * units referred to as 'Grains'.
240  *
241  * HUB are displayed using 8 decimal places of precision.
242  *
243  * 1 HUB is equivalent to:
244  *   100000000 == 1 * 10**8 == 1e8 == One Hundred Million Grains
245  *
246  * All initial HUB Grains are assigned to the creator of
247  * this contract.
248  *
249  */
250 contract Hubcoin is StandardToken, Pausable {
251 
252   string public constant name = 'Hubcoin';                       // Set the token name for display
253   string public constant symbol = 'HUB';                                       // Set the token symbol for display
254   uint8 public constant decimals = 6;                                          // Set the number of decimals for display
255   uint256 public constant INITIAL_SUPPLY = 107336 * 10**uint256(decimals); // 326804 HUB specified in Grains
256   uint256 public constant total_freeze_term = 86400*365;   //Freeze duration
257   uint256 public constant launch_date = 1501545600;
258   uint256 public constant owner_freeze_start = 1507918487;
259   uint256 public constant owner_freeze_term = 3600*24;
260 
261   mapping (address => uint256) public frozenAccount;
262 
263   event FrozenFunds(address target, uint256 frozen);
264   event Burn(address burner, uint256 burned);
265 
266   /**
267    * @dev Hubcoin Constructor
268    * Runs only on initial contract creation.
269    */
270   function Hubcoin() {
271     totalSupply = INITIAL_SUPPLY;                               // Set the total supply
272     balances[msg.sender] = INITIAL_SUPPLY;                      // Creator address is assigned all
273   }
274 
275   /**
276    * @dev Transfer token for a specified address when not paused
277    * @param _to The address to transfer to.
278    * @param _value The amount to be transferred.
279    */
280   function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
281     freezeCheck(msg.sender, _value);
282 
283     return super.transfer(_to, _value);
284   }
285 
286   /**
287    * @dev Transfer tokens from one address to another when not paused
288    * @param _from address The address which you want to send tokens from
289    * @param _to address The address which you want to transfer to
290    * @param _value uint256 the amount of tokens to be transferred
291    */
292   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
293     freezeCheck(msg.sender, _value);
294 
295     return super.transferFrom(_from, _to, _value);
296   }
297 
298   /**
299    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
300    * @param _spender The address which will spend the funds.
301    * @param _value The amount of tokens to be spent.
302    */
303   function approve(address _spender, uint256 _value) whenNotPaused returns (bool) {
304     return super.approve(_spender, _value);
305   }
306 
307 
308   /**
309    * @dev Freeze of a premine
310    * @param target The address to whom we freeze
311    * @param freeze The amount of tokens freeze.
312    */
313   function freezeAccount(address target, uint256 freeze)  onlyOwner  {
314     require(block.timestamp < (owner_freeze_start + owner_freeze_term));
315     frozenAccount[target] = freeze;
316     FrozenFunds(target, freeze);
317   }
318 
319   /**
320    * @dev Is it possible to spend the received amount
321    * @param _from The address which is checked
322    * @param _value The amount to spend
323    */
324   function freezeCheck(address _from, uint256 _value)  returns (bool) {
325     uint forbiddenPremine =  launch_date - block.timestamp + total_freeze_term;
326 
327     if (forbiddenPremine > 0) {
328       require(balances[_from] >= _value.add( frozenAccount[_from] * forbiddenPremine / total_freeze_term) );
329     }
330 
331     return true;
332   }
333 
334   /**
335    * @dev Burning the rest of the coins
336    * @param _value The amount tokens
337    */
338   function burn(uint256 _value) onlyOwner public {
339     require(_value > 0);
340 
341     address burner = msg.sender;
342     balances[burner] = balances[burner].sub(_value);
343     totalSupply = totalSupply.sub(_value);
344     Burn(burner, _value);
345   }
346 }