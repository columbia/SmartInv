1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() {
49     owner = msg.sender;
50   }
51 
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) onlyOwner {
67     if (newOwner != address(0)) {
68       owner = newOwner;
69     }
70   }
71 
72 }
73 
74 /**
75  * @title Distributable
76  * @dev The Distribution contract has multi dealer address, and provides basic authorization control
77  * functions, this simplifies the implementation of "user permissions".
78  */
79 contract Distributable is Ownable {
80   mapping(address => bool) public dealership;
81   event Trust(address dealer);
82   event Distrust(address dealer);
83 
84   modifier onlyDealers() {
85     require(dealership[msg.sender]);
86     _;
87   }
88 
89   function trust(address newDealer) onlyOwner {
90     require(newDealer != address(0));
91     require(!dealership[newDealer]);
92     dealership[newDealer] = true;
93     Trust(newDealer);
94   }
95 
96   function distrust(address dealer) onlyOwner {
97     require(dealership[dealer]);
98     dealership[dealer] = false;
99     Distrust(dealer);
100   }
101 
102 }
103 
104 
105 contract Pausable is Ownable {
106   event Pause();
107   event Unpause();
108 
109   bool public paused = false;
110 
111 
112   /**
113    * @dev modifier to allow actions only when the contract IS paused
114    */
115   modifier whenNotPaused() {
116     require(!paused);
117     _;
118   }
119 
120   /**
121    * @dev modifier to allow actions only when the contract IS NOT paused
122    */
123   modifier whenPaused {
124     require(paused);
125     _;
126   }
127 
128   /**
129    * @dev called by the owner to pause, triggers stopped state
130    */
131   function pause() onlyOwner whenNotPaused returns (bool) {
132     paused = true;
133     Pause();
134     return true;
135   }
136 
137   /**
138    * @dev called by the owner to unpause, returns to normal state
139    */
140   function unpause() onlyOwner whenPaused returns (bool) {
141     paused = false;
142     Unpause();
143     return true;
144   }
145 }
146 
147 
148 
149 
150 /**
151  * @title ERC20Basic
152  * @dev Simpler version of ERC20 interface
153  * @dev see https://github.com/ethereum/EIPs/issues/179
154  */
155 contract ERC20Basic {
156   uint256 public totalSupply;
157   function balanceOf(address who) constant returns (uint256);
158   function transfer(address to, uint256 value) returns (bool);
159   event Transfer(address indexed from, address indexed to, uint256 value);
160 }
161 
162 
163 /**
164  * @title Basic token
165  * @dev Basic version of StandardToken, with no allowances.
166  */
167 contract BasicToken is ERC20Basic {
168   using SafeMath for uint256;
169 
170   mapping(address => uint256) balances;
171 
172   /**
173   * @dev transfer token for a specified address
174   * @param _to The address to transfer to.
175   * @param _value The amount to be transferred.
176   */
177   function transfer(address _to, uint256 _value) returns (bool) {
178     balances[msg.sender] = balances[msg.sender].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     Transfer(msg.sender, _to, _value);
181     return true;
182   }
183 
184   /**
185   * @dev Gets the balance of the specified address.
186   * @param _owner The address to query the the balance of.
187   * @return An uint256 representing the amount owned by the passed address.
188   */
189   function balanceOf(address _owner) constant returns (uint256 balance) {
190     return balances[_owner];
191   }
192 
193 }
194 
195 
196 /**
197  * @title ERC20 interface
198  * @dev see https://github.com/ethereum/EIPs/issues/20
199  */
200 contract ERC20 is ERC20Basic {
201   function allowance(address owner, address spender) constant returns (uint256);
202   function transferFrom(address from, address to, uint256 value) returns (bool);
203   function approve(address spender, uint256 value) returns (bool);
204   event Approval(address indexed owner, address indexed spender, uint256 value);
205 }
206 
207 
208 /**
209  * @title Standard ERC20 token
210  *
211  * @dev Implementation of the basic standard token.
212  * @dev https://github.com/ethereum/EIPs/issues/20
213  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
214  */
215 contract StandardToken is ERC20, BasicToken {
216 
217   mapping (address => mapping (address => uint256)) allowed;
218 
219 
220   /**
221    * @dev Transfer tokens from one address to another
222    * @param _from address The address which you want to send tokens from
223    * @param _to address The address which you want to transfer to
224    * @param _value uint256 the amout of tokens to be transfered
225    */
226   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
227     var _allowance = allowed[_from][msg.sender];
228 
229     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
230     // require (_value <= _allowance);
231 
232     balances[_to] = balances[_to].add(_value);
233     balances[_from] = balances[_from].sub(_value);
234     allowed[_from][msg.sender] = _allowance.sub(_value);
235     Transfer(_from, _to, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
241    * @param _spender The address which will spend the funds.
242    * @param _value The amount of tokens to be spent.
243    */
244   function approve(address _spender, uint256 _value) returns (bool) {
245 
246     // To change the approve amount you first have to reduce the addresses`
247     //  allowance to zero by calling `approve(_spender, 0)` if it is not
248     //  already 0 to mitigate the race condition described here:
249     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
250     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
251 
252     allowed[msg.sender][_spender] = _value;
253     Approval(msg.sender, _spender, _value);
254     return true;
255   }
256 
257   /**
258    * @dev Function to check the amount of tokens that an owner allowed to a spender.
259    * @param _owner address The address which owns the funds.
260    * @param _spender address The address which will spend the funds.
261    * @return A uint256 specifing the amount of tokens still avaible for the spender.
262    */
263   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
264     return allowed[_owner][_spender];
265   }
266 
267 }
268 
269 
270 contract DistributionToken is StandardToken, Distributable {
271   event Mint(address indexed dealer, address indexed to, uint256 value);
272   event Burn(address indexed dealer, address indexed from, uint256 value);
273 
274    /**
275    * @dev to mint tokens
276    * @param _to The address that will recieve the minted tokens.
277    * @param _value The amount of tokens to mint.
278    * @return A boolean that indicates if the operation was successful.
279    */
280   function mint(address _to, uint256 _value) onlyDealers returns (bool) {
281     totalSupply = totalSupply.add(_value);
282     balances[_to] = balances[_to].add(_value);
283     Mint(msg.sender, _to, _value);
284     Transfer(address(0), _to, _value);
285     return true;
286   }
287 
288 
289   function burn(address _from, uint256 _value) onlyDealers returns (bool) {
290     totalSupply = totalSupply.sub(_value);
291     balances[_from] = balances[_from].sub(_value);
292     Burn(msg.sender, _from, _value);
293     Transfer(_from, address(0), _value);
294     return true;
295   }
296 
297 
298 }
299 
300 
301 contract EverFountainBean is DistributionToken {
302   string public name = "Bean";
303   string public symbol = "BEAN";
304   uint256 public decimals = 0;
305 }