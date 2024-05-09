1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() public {
48     owner = msg.sender;
49   }
50 
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) public onlyOwner {
66     if (newOwner != address(0)) {
67       owner = newOwner;
68     }
69   }
70 
71 }
72 
73 /**
74  * @title Distributable
75  * @dev The Distribution contract has multi dealer address, and provides basic authorization control
76  * functions, this simplifies the implementation of "user permissions".
77  */
78 contract Distributable is Ownable {
79   mapping(address => bool) public dealership;
80   event Trust(address dealer);
81   event Distrust(address dealer);
82 
83   modifier onlyDealers() {
84     require(dealership[msg.sender]);
85     _;
86   }
87 
88   function trust(address newDealer) public onlyOwner {
89     require(newDealer != address(0));
90     require(!dealership[newDealer]);
91     dealership[newDealer] = true;
92     Trust(newDealer);
93   }
94 
95   function distrust(address dealer) public onlyOwner {
96     require(dealership[dealer]);
97     dealership[dealer] = false;
98     Distrust(dealer);
99   }
100 
101 }
102 
103 
104 contract Pausable is Ownable {
105   event Pause();
106   event Unpause();
107 
108   bool public paused = false;
109 
110 
111   /**
112    * @dev modifier to allow actions only when the contract IS paused
113    */
114   modifier whenNotPaused() {
115     require(!paused);
116     _;
117   }
118 
119   /**
120    * @dev modifier to allow actions only when the contract IS NOT paused
121    */
122   modifier whenPaused {
123     require(paused);
124     _;
125   }
126 
127   /**
128    * @dev called by the owner to pause, triggers stopped state
129    */
130   function pause() public onlyOwner whenNotPaused returns (bool) {
131     paused = true;
132     Pause();
133     return true;
134   }
135 
136   /**
137    * @dev called by the owner to unpause, returns to normal state
138    */
139   function unpause() public onlyOwner whenPaused returns (bool) {
140     paused = false;
141     Unpause();
142     return true;
143   }
144 }
145 
146 
147 
148 
149 /**
150  * @title ERC20Basic
151  * @dev Simpler version of ERC20 interface
152  * @dev see https://github.com/ethereum/EIPs/issues/179
153  */
154 contract ERC20Basic {
155   uint256 public totalSupply;
156   function balanceOf(address who) public constant returns (uint256);
157   function transfer(address to, uint256 value) public returns (bool);
158   event Transfer(address indexed from, address indexed to, uint256 value);
159 }
160 
161 
162 /**
163  * @title Basic token
164  * @dev Basic version of StandardToken, with no allowances.
165  */
166 contract BasicToken is ERC20Basic {
167   using SafeMath for uint256;
168 
169   mapping(address => uint256) balances;
170 
171   /**
172   * @dev transfer token for a specified address
173   * @param _to The address to transfer to.
174   * @param _value The amount to be transferred.
175   */
176   function transfer(address _to, uint256 _value) public returns (bool) {
177     balances[msg.sender] = balances[msg.sender].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     Transfer(msg.sender, _to, _value);
180     return true;
181   }
182 
183   /**
184   * @dev Gets the balance of the specified address.
185   * @param _owner The address to query the the balance of.
186   * @return An uint256 representing the amount owned by the passed address.
187   */
188   function balanceOf(address _owner) public constant returns (uint256 balance) {
189     return balances[_owner];
190   }
191 
192 }
193 
194 
195 /**
196  * @title ERC20 interface
197  * @dev see https://github.com/ethereum/EIPs/issues/20
198  */
199 contract ERC20 is ERC20Basic {
200   function allowance(address owner, address spender) public constant returns (uint256);
201   function transferFrom(address from, address to, uint256 value) public returns (bool);
202   function approve(address spender, uint256 value) public returns (bool);
203   event Approval(address indexed owner, address indexed spender, uint256 value);
204 }
205 
206 
207 /**
208  * @title Standard ERC20 token
209  *
210  * @dev Implementation of the basic standard token.
211  * @dev https://github.com/ethereum/EIPs/issues/20
212  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
213  */
214 contract StandardToken is ERC20, BasicToken {
215 
216   mapping (address => mapping (address => uint256)) allowed;
217 
218 
219   /**
220    * @dev Transfer tokens from one address to another
221    * @param _from address The address which you want to send tokens from
222    * @param _to address The address which you want to transfer to
223    * @param _value uint256 the amout of tokens to be transfered
224    */
225   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
226     var _allowance = allowed[_from][msg.sender];
227 
228     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
229     // require (_value <= _allowance);
230 
231     balances[_to] = balances[_to].add(_value);
232     balances[_from] = balances[_from].sub(_value);
233     allowed[_from][msg.sender] = _allowance.sub(_value);
234     Transfer(_from, _to, _value);
235     return true;
236   }
237 
238   /**
239    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
240    * @param _spender The address which will spend the funds.
241    * @param _value The amount of tokens to be spent.
242    */
243   function approve(address _spender, uint256 _value) public returns (bool) {
244 
245     // To change the approve amount you first have to reduce the addresses`
246     //  allowance to zero by calling `approve(_spender, 0)` if it is not
247     //  already 0 to mitigate the race condition described here:
248     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
250 
251     allowed[msg.sender][_spender] = _value;
252     Approval(msg.sender, _spender, _value);
253     return true;
254   }
255 
256   /**
257    * @dev Function to check the amount of tokens that an owner allowed to a spender.
258    * @param _owner address The address which owns the funds.
259    * @param _spender address The address which will spend the funds.
260    * @return A uint256 specifing the amount of tokens still avaible for the spender.
261    */
262   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
263     return allowed[_owner][_spender];
264   }
265 
266 }
267 
268 
269 contract DistributionToken is StandardToken, Distributable {
270   event Mint(address indexed dealer, address indexed to, uint256 value);
271   event Burn(address indexed dealer, address indexed from, uint256 value);
272 
273    /**
274    * @dev to mint tokens
275    * @param _to The address that will recieve the minted tokens.
276    * @param _value The amount of tokens to mint.
277    * @return A boolean that indicates if the operation was successful.
278    */
279   function mint(address _to, uint256 _value) public onlyDealers returns (bool) {
280     totalSupply = totalSupply.add(_value);
281     balances[_to] = balances[_to].add(_value);
282     Mint(msg.sender, _to, _value);
283     Transfer(address(0), _to, _value);
284     return true;
285   }
286 
287   function burn(address _from, uint256 _value) public onlyDealers returns (bool) {
288     totalSupply = totalSupply.sub(_value);
289     balances[_from] = balances[_from].sub(_value);
290     Burn(msg.sender, _from, _value);
291     Transfer(_from, address(0), _value);
292     return true;
293   }
294 
295 }
296 
297 contract InitialToken is Ownable {
298   DistributionToken public token;
299   bool public initiated = false;
300   address public privateSaleAddress = 0x2F196AdBeD104ceB69C86BCD06625a9F1A6cb1aF;
301   uint256 public privateSaleAmount = 1800000 ether;
302 
303   address public publicSaleAddress = 0x543AC29C0D11646148a93Bc8d7160b2f005D7918;
304   uint256 public publicSaleAmount = 7200000 ether;
305 
306   function InitialToken(DistributionToken _token) public {
307     require(_token != address(0));
308     token = _token;
309   }
310 
311   function initial() onlyOwner public {
312     require(!initiated);
313     initiated = true;
314     token.mint(privateSaleAddress, privateSaleAmount);
315     token.mint(publicSaleAddress, publicSaleAmount);
316   }
317 }