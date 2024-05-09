1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract Pausable is Ownable {
81   event Pause();
82   event Unpause();
83 
84   bool public paused = false;
85 
86 
87   /**
88    * @dev Modifier to make a function callable only when the contract is not paused.
89    */
90   modifier whenNotPaused() {
91     require(!paused);
92     _;
93   }
94 
95   /**
96    * @dev Modifier to make a function callable only when the contract is paused.
97    */
98   modifier whenPaused() {
99     require(paused);
100     _;
101   }
102 
103   /**
104    * @dev called by the owner to pause, triggers stopped state
105    */
106   function pause() onlyOwner whenNotPaused public {
107     paused = true;
108     Pause();
109   }
110 
111   /**
112    * @dev called by the owner to unpause, returns to normal state
113    */
114   function unpause() onlyOwner whenPaused public {
115     paused = false;
116     Unpause();
117   }
118 }
119 
120 contract HasNoEther is Ownable {
121 
122   /**
123   * @dev Constructor that rejects incoming Ether
124   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
125   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
126   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
127   * we could use assembly to access msg.value.
128   */
129   function HasNoEther() public payable {
130     require(msg.value == 0);
131   }
132 
133   /**
134    * @dev Disallows direct send by settings a default function without the `payable` flag.
135    */
136   function() external {
137   }
138 
139   /**
140    * @dev Transfer all Ether held by the contract to the owner.
141    */
142   function reclaimEther() external onlyOwner {
143     assert(owner.send(this.balance));
144   }
145 }
146 
147 contract ERC20Basic {
148   function totalSupply() public view returns (uint256);
149   function balanceOf(address who) public view returns (uint256);
150   function transfer(address to, uint256 value) public returns (bool);
151   event Transfer(address indexed from, address indexed to, uint256 value);
152 }
153 
154 contract BasicToken is ERC20Basic {
155   using SafeMath for uint256;
156 
157   mapping(address => uint256) balances;
158 
159   uint256 totalSupply_;
160 
161   /**
162   * @dev total number of tokens in existence
163   */
164   function totalSupply() public view returns (uint256) {
165     return totalSupply_;
166   }
167 
168   /**
169   * @dev transfer token for a specified address
170   * @param _to The address to transfer to.
171   * @param _value The amount to be transferred.
172   */
173   function transfer(address _to, uint256 _value) public returns (bool) {
174     require(_to != address(0));
175     require(_value <= balances[msg.sender]);
176 
177     // SafeMath.sub will throw if there is not enough balance.
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
189   function balanceOf(address _owner) public view returns (uint256 balance) {
190     return balances[_owner];
191   }
192 
193 }
194 
195 contract ERC20 is ERC20Basic {
196   function allowance(address owner, address spender) public view returns (uint256);
197   function transferFrom(address from, address to, uint256 value) public returns (bool);
198   function approve(address spender, uint256 value) public returns (bool);
199   event Approval(address indexed owner, address indexed spender, uint256 value);
200 }
201 
202 contract StandardToken is ERC20, BasicToken {
203 
204   mapping (address => mapping (address => uint256)) internal allowed;
205 
206 
207   /**
208    * @dev Transfer tokens from one address to another
209    * @param _from address The address which you want to send tokens from
210    * @param _to address The address which you want to transfer to
211    * @param _value uint256 the amount of tokens to be transferred
212    */
213   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
214     require(_to != address(0));
215     require(_value <= balances[_from]);
216     require(_value <= allowed[_from][msg.sender]);
217 
218     balances[_from] = balances[_from].sub(_value);
219     balances[_to] = balances[_to].add(_value);
220     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
221     Transfer(_from, _to, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227    *
228    * Beware that changing an allowance with this method brings the risk that someone may use both the old
229    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
230    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
231    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232    * @param _spender The address which will spend the funds.
233    * @param _value The amount of tokens to be spent.
234    */
235   function approve(address _spender, uint256 _value) public returns (bool) {
236     allowed[msg.sender][_spender] = _value;
237     Approval(msg.sender, _spender, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Function to check the amount of tokens that an owner allowed to a spender.
243    * @param _owner address The address which owns the funds.
244    * @param _spender address The address which will spend the funds.
245    * @return A uint256 specifying the amount of tokens still available for the spender.
246    */
247   function allowance(address _owner, address _spender) public view returns (uint256) {
248     return allowed[_owner][_spender];
249   }
250 
251   /**
252    * @dev Increase the amount of tokens that an owner allowed to a spender.
253    *
254    * approve should be called when allowed[_spender] == 0. To increment
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _addedValue The amount of tokens to increase the allowance by.
260    */
261   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
262     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
263     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 
267   /**
268    * @dev Decrease the amount of tokens that an owner allowed to a spender.
269    *
270    * approve should be called when allowed[_spender] == 0. To decrement
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _subtractedValue The amount of tokens to decrease the allowance by.
276    */
277   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
278     uint oldValue = allowed[msg.sender][_spender];
279     if (_subtractedValue > oldValue) {
280       allowed[msg.sender][_spender] = 0;
281     } else {
282       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
283     }
284     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288 }
289 
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
313 contract PBToken is PausableToken, HasNoEther {
314   string public name = "Primalbase Token";
315   string public symbol = "PBT";
316   uint256 public decimals = 4;
317   string public version = 'v1.0.0';
318   uint256 public INITIAL_SUPPLY = 1250 * (10 ** uint256(decimals));
319 
320   event TokenTransferLog(address indexed from, address indexed to, uint256 amount, string wallet, string currency);
321 
322   function PBToken() public {
323     totalSupply_ = INITIAL_SUPPLY;
324     balances[msg.sender] = INITIAL_SUPPLY;
325   }
326 
327   /**
328    * @dev Transfer tokens from sender address to gateway
329    * @param _amount uint256 the amount of tokens to be transferred
330    * @param _wallet string another currency receiver wallet address
331    * @param _currency string another currency name
332    */
333   function TransferBase(uint256 _amount, string _wallet, string _currency) public returns (bool) {
334     require(_amount <= balances[msg.sender]);
335     require(bytes(_wallet).length > 0);
336     require(bytes(_currency).length > 0);
337 
338     transfer(owner, _amount);
339     TokenTransferLog(msg.sender, owner, _amount, _wallet, _currency);
340     return true;
341   }
342 
343   /**
344    * @dev Transfer Waves tokens from sender address to Waves gateway
345    * @param _amount uint256 the amount of tokens to be transferred
346    * @param _wallet string another currency receiver wallet address
347    */
348   function TransferToWaves(uint256 _amount, string _wallet) public returns (bool) {
349     TransferBase(_amount, _wallet, 'waves');
350     return true;
351   }
352 
353 }