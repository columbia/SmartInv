1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 contract ERC20Basic {
51   function totalSupply() public view returns (uint256);
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 contract ERC20 is ERC20Basic {
58   function allowance(address owner, address spender) public view returns (uint256);
59   function transferFrom(address from, address to, uint256 value) public returns (bool);
60   function approve(address spender, uint256 value) public returns (bool);
61   event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 contract BasicToken is ERC20Basic {
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   uint256 totalSupply_;
70 
71   /**
72   * @dev total number of tokens in existence
73   */
74   function totalSupply() public view returns (uint256) {
75     return totalSupply_;
76   }
77 
78   /**
79   * @dev transfer token for a specified address
80   * @param _to The address to transfer to.
81   * @param _value The amount to be transferred.
82   */
83   function transfer(address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85     require(_value <= balances[msg.sender]);
86 
87     // SafeMath.sub will throw if there is not enough balance.
88     balances[msg.sender] = balances[msg.sender].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     Transfer(msg.sender, _to, _value);
91     return true;
92   }
93 
94   /**
95   * @dev Gets the balance of the specified address.
96   * @param _owner The address to query the the balance of.
97   * @return An uint256 representing the amount owned by the passed address.
98   */
99   function balanceOf(address _owner) public view returns (uint256 balance) {
100     return balances[_owner];
101   }
102 
103 }
104 
105 contract StandardToken is ERC20, BasicToken {
106 
107   mapping (address => mapping (address => uint256)) internal allowed;
108 
109 
110   /**
111    * @dev Transfer tokens from one address to another
112    * @param _from address The address which you want to send tokens from
113    * @param _to address The address which you want to transfer to
114    * @param _value uint256 the amount of tokens to be transferred
115    */
116   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[_from]);
119     require(_value <= allowed[_from][msg.sender]);
120 
121     balances[_from] = balances[_from].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124     Transfer(_from, _to, _value);
125     return true;
126   }
127 
128   /**
129    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
130    *
131    * Beware that changing an allowance with this method brings the risk that someone may use both the old
132    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
133    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
134    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135    * @param _spender The address which will spend the funds.
136    * @param _value The amount of tokens to be spent.
137    */
138   function approve(address _spender, uint256 _value) public returns (bool) {
139     allowed[msg.sender][_spender] = _value;
140     Approval(msg.sender, _spender, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Function to check the amount of tokens that an owner allowed to a spender.
146    * @param _owner address The address which owns the funds.
147    * @param _spender address The address which will spend the funds.
148    * @return A uint256 specifying the amount of tokens still available for the spender.
149    */
150   function allowance(address _owner, address _spender) public view returns (uint256) {
151     return allowed[_owner][_spender];
152   }
153 
154   /**
155    * @dev Increase the amount of tokens that an owner allowed to a spender.
156    *
157    * approve should be called when allowed[_spender] == 0. To increment
158    * allowed value is better to use this function to avoid 2 calls (and wait until
159    * the first transaction is mined)
160    * From MonolithDAO Token.sol
161    * @param _spender The address which will spend the funds.
162    * @param _addedValue The amount of tokens to increase the allowance by.
163    */
164   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
165     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
166     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167     return true;
168   }
169 
170   /**
171    * @dev Decrease the amount of tokens that an owner allowed to a spender.
172    *
173    * approve should be called when allowed[_spender] == 0. To decrement
174    * allowed value is better to use this function to avoid 2 calls (and wait until
175    * the first transaction is mined)
176    * From MonolithDAO Token.sol
177    * @param _spender The address which will spend the funds.
178    * @param _subtractedValue The amount of tokens to decrease the allowance by.
179    */
180   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
181     uint oldValue = allowed[msg.sender][_spender];
182     if (_subtractedValue > oldValue) {
183       allowed[msg.sender][_spender] = 0;
184     } else {
185       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
186     }
187     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191 }
192 
193 contract Ownable {
194   address public owner;
195 
196 
197   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
198 
199 
200   /**
201    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
202    * account.
203    */
204   function Ownable() public {
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
222     OwnershipTransferred(owner, newOwner);
223     owner = newOwner;
224   }
225 
226 }
227 
228 
229 contract Pausable is Ownable {
230   event Pause();
231   event Unpause();
232 
233   bool public paused = false;
234 
235 
236   /**
237    * @dev Modifier to make a function callable only when the contract is not paused.
238    */
239   modifier whenNotPaused() {
240     require(!paused);
241     _;
242   }
243 
244   /**
245    * @dev Modifier to make a function callable only when the contract is paused.
246    */
247   modifier whenPaused() {
248     require(paused);
249     _;
250   }
251 
252   /**
253    * @dev called by the owner to pause, triggers stopped state
254    */
255   function pause() onlyOwner whenNotPaused public {
256     paused = true;
257     Pause();
258   }
259 
260   /**
261    * @dev called by the owner to unpause, returns to normal state
262    */
263   function unpause() onlyOwner whenPaused public {
264     paused = false;
265     Unpause();
266   }
267 }
268 
269 
270 contract PausableToken is StandardToken, Pausable {
271 
272   function transfer(address _to, uint256 _value) public whenNotPaused  returns (bool) {
273     return super.transfer(_to, _value);
274   }
275 
276   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
277     return super.transferFrom(_from, _to, _value);
278   } 
279 
280   function approve(address _spender, uint256 _value) public whenNotPaused  returns (bool) {
281     return super.approve(_spender, _value);
282   }
283 
284   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused  returns (bool success) {
285     return super.increaseApproval(_spender, _addedValue);
286   }
287 
288   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused   returns (bool success) {
289     return super.decreaseApproval(_spender, _subtractedValue);
290   }
291 }
292 
293 
294 contract MintableToken is StandardToken, Ownable {
295   event Mint(address indexed to, uint256 amount);
296   event MintFinished();
297 
298   bool public mintingFinished = false;
299 
300 
301   modifier canMint() {
302     require(!mintingFinished);
303     _;
304   }
305 
306   /**
307    * @dev Function to mint tokens
308    * @param _to The address that will receive the minted tokens.
309    * @param _amount The amount of tokens to mint.
310    * @return A boolean that indicates if the operation was successful.
311    */
312   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
313     totalSupply_ = totalSupply_.add(_amount);
314     balances[_to] = balances[_to].add(_amount);
315     Mint(_to, _amount);
316     Transfer(address(0), _to, _amount);
317     return true;
318   }
319 
320   /**
321    * @dev Function to stop minting new tokens.
322    * @return True if the operation was successful.
323    */
324   function finishMinting() onlyOwner canMint public returns (bool) {
325     mintingFinished = true;
326     MintFinished();
327     return true;
328   }
329 }
330 
331 contract LoveToken is PausableToken,MintableToken {
332 
333   string public constant name = "LoveToken";
334   string public constant symbol = "Love";
335   uint8 public constant decimals = 8;
336 
337   function LoveToken(uint256 _initialSupply) public {
338       totalSupply_=_initialSupply * (10 ** uint256(decimals));
339       balances[msg.sender]=totalSupply_;
340   }
341 }