1 pragma solidity ^0.4.23;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     if (a == 0) {
11       return 0;
12     }
13     c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   /**
19   * @dev Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     // uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return a / b;
26   }
27 
28   /**
29   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
40     c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 
47 contract ERC20Basic {
48   function totalSupply() public view returns (uint256);
49   function balanceOf(address who) public view returns (uint256);
50   function transfer(address to, uint256 value) public returns (bool);
51   event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public view returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 
63 contract BasicToken is ERC20Basic {
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   uint256 totalSupply_;
69 
70   /**
71   * @dev total number of tokens in existence
72   */
73   function totalSupply() public view returns (uint256) {
74     return totalSupply_;
75   }
76 
77   /**
78   * @dev transfer token for a specified address
79   * @param _to The address to transfer to.
80   * @param _value The amount to be transferred.
81   */
82   function transfer(address _to, uint256 _value) public returns (bool) {
83     require(_to != address(0));
84     require(_value <= balances[msg.sender]);
85 
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     emit Transfer(msg.sender, _to, _value);
89     return true;
90   }
91 
92   /**
93   * @dev Gets the balance of the specified address.
94   * @param _owner The address to query the the balance of.
95   * @return An uint256 representing the amount owned by the passed address.
96   */
97   function balanceOf(address _owner) public view returns (uint256) {
98     return balances[_owner];
99   }
100 
101 }
102 
103 
104 contract StandardToken is ERC20, BasicToken {
105 
106   mapping (address => mapping (address => uint256)) internal allowed;
107 
108 
109   /**
110    * @dev Transfer tokens from one address to another
111    * @param _from address The address which you want to send tokens from
112    * @param _to address The address which you want to transfer to
113    * @param _value uint256 the amount of tokens to be transferred
114    */
115   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(_value <= balances[_from]);
118     require(_value <= allowed[_from][msg.sender]);
119 
120     balances[_from] = balances[_from].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123     emit Transfer(_from, _to, _value);
124     return true;
125   }
126 
127   /**
128    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
129    *
130    * Beware that changing an allowance with this method brings the risk that someone may use both the old
131    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
132    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
133    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134    * @param _spender The address which will spend the funds.
135    * @param _value The amount of tokens to be spent.
136    */
137   function approve(address _spender, uint256 _value) public returns (bool) {
138     allowed[msg.sender][_spender] = _value;
139     emit Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifying the amount of tokens still available for the spender.
148    */
149   function allowance(address _owner, address _spender) public view returns (uint256) {
150     return allowed[_owner][_spender];
151   }
152 
153   /**
154    * @dev Increase the amount of tokens that an owner allowed to a spender.
155    *
156    * approve should be called when allowed[_spender] == 0. To increment
157    * allowed value is better to use this function to avoid 2 calls (and wait until
158    * the first transaction is mined)
159    * From MonolithDAO Token.sol
160    * @param _spender The address which will spend the funds.
161    * @param _addedValue The amount of tokens to increase the allowance by.
162    */
163   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
164     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
165     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166     return true;
167   }
168 
169   /**
170    * @dev Decrease the amount of tokens that an owner allowed to a spender.
171    *
172    * approve should be called when allowed[_spender] == 0. To decrement
173    * allowed value is better to use this function to avoid 2 calls (and wait until
174    * the first transaction is mined)
175    * From MonolithDAO Token.sol
176    * @param _spender The address which will spend the funds.
177    * @param _subtractedValue The amount of tokens to decrease the allowance by.
178    */
179   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
180     uint oldValue = allowed[msg.sender][_spender];
181     if (_subtractedValue > oldValue) {
182       allowed[msg.sender][_spender] = 0;
183     } else {
184       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
185     }
186     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190 }
191 
192 contract Ownable {
193   address public owner;
194 
195 
196   event OwnershipRenounced(address indexed previousOwner);
197   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
198 
199 
200   /**
201    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
202    * account.
203    */
204   constructor() public {
205     owner = msg.sender;
206   }
207 
208   /**
209    * @dev Throws if called by any account other than the owner.
210    */
211   modifier onlyOwner() {
212     require(msg.sender == owner);
213     _;
214   }
215 
216   /**
217    * @dev Allows the current owner to transfer control of the contract to a newOwner.
218    * @param newOwner The address to transfer ownership to.
219    */
220   function transferOwnership(address newOwner) public onlyOwner {
221     require(newOwner != address(0));
222     emit OwnershipTransferred(owner, newOwner);
223     owner = newOwner;
224   }
225 
226   /**
227    * @dev Allows the current owner to relinquish control of the contract.
228    */
229   function renounceOwnership() public onlyOwner {
230     emit OwnershipRenounced(owner);
231     owner = address(0);
232   }
233 }
234 
235 
236 contract MintableToken is StandardToken, Ownable {
237   event Mint(address indexed to, uint256 amount);
238   event MintFinished();
239 
240   bool public mintingFinished = false;
241 
242 
243   modifier canMint() {
244     require(!mintingFinished);
245     _;
246   }
247 
248   modifier hasMintPermission() {
249     require(msg.sender == owner);
250     _;
251   }
252 
253   /**
254    * @dev Function to mint tokens
255    * @param _to The address that will receive the minted tokens.
256    * @param _amount The amount of tokens to mint.
257    * @return A boolean that indicates if the operation was successful.
258    */
259   function mint(address _to, uint256 _amount) hasMintPermission canMint public returns (bool) {
260     totalSupply_ = totalSupply_.add(_amount);
261     balances[_to] = balances[_to].add(_amount);
262     emit Mint(_to, _amount);
263     emit Transfer(address(0), _to, _amount);
264     return true;
265   }
266 
267   /**
268    * @dev Function to stop minting new tokens.
269    * @return True if the operation was successful.
270    */
271   function finishMinting() onlyOwner canMint public returns (bool) {
272     mintingFinished = true;
273     emit MintFinished();
274     return true;
275   }
276 }
277 
278 
279 contract Pausable is Ownable {
280   event Pause();
281   event Unpause();
282 
283   bool public paused = false;
284 
285 
286   /**
287    * @dev Modifier to make a function callable only when the contract is not paused.
288    */
289   modifier whenNotPaused() {
290     require(!paused);
291     _;
292   }
293 
294   /**
295    * @dev Modifier to make a function callable only when the contract is paused.
296    */
297   modifier whenPaused() {
298     require(paused);
299     _;
300   }
301 
302   /**
303    * @dev called by the owner to pause, triggers stopped state
304    */
305   function pause() onlyOwner whenNotPaused public {
306     paused = true;
307     emit Pause();
308   }
309 
310   /**
311    * @dev called by the owner to unpause, returns to normal state
312    */
313   function unpause() onlyOwner whenPaused public {
314     paused = false;
315     emit Unpause();
316   }
317 }
318 
319 contract PausableToken is MintableToken, Pausable {
320 
321   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
322     return super.transfer(_to, _value);
323   }
324 
325   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
326     return super.transferFrom(_from, _to, _value);
327   }
328 
329   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
330     return super.approve(_spender, _value);
331   }
332 
333   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
334     return super.increaseApproval(_spender, _addedValue);
335   }
336 
337   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
338     return super.decreaseApproval(_spender, _subtractedValue);
339   }
340 }
341 
342 contract DetailedERC20 is PausableToken {
343   string public name;
344   string public symbol;
345   uint8 public decimals;
346   constructor(string _name, string _symbol, uint8 _decimals, uint256 INITIAL_SUPPLY) public {
347     name = _name;
348     symbol = _symbol;
349     decimals = _decimals;
350     totalSupply_ = INITIAL_SUPPLY * 10**uint(decimals);
351     balances[owner] = totalSupply_;
352     Transfer(address(0), owner, totalSupply_);
353   }
354 }