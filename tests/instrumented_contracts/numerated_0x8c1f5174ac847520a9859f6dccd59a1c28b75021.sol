1 pragma solidity ^0.4.18;
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
45 contract ERC20Basic {
46   function totalSupply() public view returns (uint256);
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 contract BasicToken is ERC20Basic {
94   using SafeMath for uint256;
95 
96   mapping(address => uint256) balances;
97 
98   uint256 totalSupply_;
99 
100   /**
101   * @dev total number of tokens in existence
102   */
103   function totalSupply() public view returns (uint256) {
104     return totalSupply_;
105   }
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[_from]);
149     require(_value <= allowed[_from][msg.sender]);
150 
151     balances[_from] = balances[_from].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154     Transfer(_from, _to, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160    *
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint256 _value) public returns (bool) {
169     allowed[msg.sender][_spender] = _value;
170     Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(address _owner, address _spender) public view returns (uint256) {
181     return allowed[_owner][_spender];
182   }
183 
184   /**
185    * @dev Increase the amount of tokens that an owner allowed to a spender.
186    *
187    * approve should be called when allowed[_spender] == 0. To increment
188    * allowed value is better to use this function to avoid 2 calls (and wait until
189    * the first transaction is mined)
190    * From MonolithDAO Token.sol
191    * @param _spender The address which will spend the funds.
192    * @param _addedValue The amount of tokens to increase the allowance by.
193    */
194   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 
200   /**
201    * @dev Decrease the amount of tokens that an owner allowed to a spender.
202    *
203    * approve should be called when allowed[_spender] == 0. To decrement
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _subtractedValue The amount of tokens to decrease the allowance by.
209    */
210   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
211     uint oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221 }
222 
223 contract Pausable is Ownable {
224   event Pause();
225   event Unpause();
226 
227   bool public paused = false;
228 
229 
230   /**
231    * @dev Modifier to make a function callable only when the contract is not paused.
232    */
233   modifier whenNotPaused() {
234     require(!paused);
235     _;
236   }
237 
238   /**
239    * @dev Modifier to make a function callable only when the contract is paused.
240    */
241   modifier whenPaused() {
242     require(paused);
243     _;
244   }
245 
246   /**
247    * @dev called by the owner to pause, triggers stopped state
248    */
249   function pause() onlyOwner whenNotPaused public {
250     paused = true;
251     Pause();
252   }
253 
254   /**
255    * @dev called by the owner to unpause, returns to normal state
256    */
257   function unpause() onlyOwner whenPaused public {
258     paused = false;
259     Unpause();
260   }
261 }
262 
263 contract PausableToken is StandardToken, Pausable {
264 
265   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
266     return super.transfer(_to, _value);
267   }
268 
269   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
270     return super.transferFrom(_from, _to, _value);
271   }
272 
273   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
274     return super.approve(_spender, _value);
275   }
276 
277   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
278     return super.increaseApproval(_spender, _addedValue);
279   }
280 
281   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
282     return super.decreaseApproval(_spender, _subtractedValue);
283   }
284 }
285 
286 
287 contract MintableToken is StandardToken, Ownable {
288   event Mint(address indexed to, uint256 amount);
289   event MintFinished();
290 
291   bool public mintingFinished = false;
292 
293 
294   modifier canMint() {
295     require(!mintingFinished);
296     _;
297   }
298 
299   /**
300    * @dev Function to mint tokens
301    * @param _to The address that will receive the minted tokens.
302    * @param _amount The amount of tokens to mint.
303    * @return A boolean that indicates if the operation was successful.
304    */
305   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
306     totalSupply_ = totalSupply_.add(_amount);
307     balances[_to] = balances[_to].add(_amount);
308     Mint(_to, _amount);
309     Transfer(address(0), _to, _amount);
310     return true;
311   }
312 
313   /**
314    * @dev Function to stop minting new tokens.
315    * @return True if the operation was successful.
316    */
317   function finishMinting() onlyOwner canMint public returns (bool) {
318     mintingFinished = true;
319     MintFinished();
320     return true;
321   }
322 }
323 
324 contract BurnableToken is BasicToken {
325 
326   event Burn(address indexed burner, uint256 value);
327 
328   /**
329    * @dev Burns a specific amount of tokens.
330    * @param _value The amount of token to be burned.
331    */
332   function burn(uint256 _value) public {
333     require(_value <= balances[msg.sender]);
334     // no need to require value <= totalSupply, since that would imply the
335     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
336 
337     address burner = msg.sender;
338     balances[burner] = balances[burner].sub(_value);
339     totalSupply_ = totalSupply_.sub(_value);
340     Burn(burner, _value);
341   }
342 }
343 
344 contract HNYToken is BurnableToken, MintableToken, PausableToken {
345   string public constant name = "BitFence Token";
346   string public constant symbol = "HNY";
347   uint8 public constant decimals = 18;
348 }