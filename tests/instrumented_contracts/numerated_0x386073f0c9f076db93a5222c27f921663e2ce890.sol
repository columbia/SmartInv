1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
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
74     emit OwnershipTransferred(owner, newOwner);
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
108     emit Pause();
109   }
110 
111   /**
112    * @dev called by the owner to unpause, returns to normal state
113    */
114   function unpause() onlyOwner whenPaused public {
115     paused = false;
116     emit Unpause();
117   }
118 }
119 
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address who) public view returns (uint256);
123   function transfer(address to, uint256 value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 contract ERC20 is ERC20Basic {
128   function allowance(address owner, address spender) public view returns (uint256);
129   function transferFrom(address from, address to, uint256 value) public returns (bool);
130   function approve(address spender, uint256 value) public returns (bool);
131   event Approval(address indexed owner, address indexed spender, uint256 value);
132 }
133 
134 contract BasicToken is ERC20Basic {
135   using SafeMath for uint256;
136 
137   mapping(address => uint256) balances;
138 
139   uint256 totalSupply_;
140 
141   /**
142   * @dev total number of tokens in existence
143   */
144   function totalSupply() public view returns (uint256) {
145     return totalSupply_;
146   }
147 
148   /**
149   * @dev transfer token for a specified address
150   * @param _to The address to transfer to.
151   * @param _value The amount to be transferred.
152   */
153   function transfer(address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155     require(_value <= balances[msg.sender]);
156 
157     balances[msg.sender] = balances[msg.sender].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     emit Transfer(msg.sender, _to, _value);
160     return true;
161   }
162 
163   /**
164   * @dev Gets the balance of the specified address.
165   * @param _owner The address to query the the balance of.
166   * @return An uint256 representing the amount owned by the passed address.
167   */
168   function balanceOf(address _owner) public view returns (uint256) {
169     return balances[_owner];
170   }
171 
172 }
173 contract StandardToken is ERC20, BasicToken {
174 
175   mapping (address => mapping (address => uint256)) internal allowed;
176 
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param _from address The address which you want to send tokens from
181    * @param _to address The address which you want to transfer to
182    * @param _value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
185     require(_to != address(0));
186     require(_value <= balances[_from]);
187     require(_value <= allowed[_from][msg.sender]);
188 
189     balances[_from] = balances[_from].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192     emit Transfer(_from, _to, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
198    *
199    * Beware that changing an allowance with this method brings the risk that someone may use both the old
200    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203    * @param _spender The address which will spend the funds.
204    * @param _value The amount of tokens to be spent.
205    */
206   function approve(address _spender, uint256 _value) public returns (bool) {
207     allowed[msg.sender][_spender] = _value;
208     emit Approval(msg.sender, _spender, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Function to check the amount of tokens that an owner allowed to a spender.
214    * @param _owner address The address which owns the funds.
215    * @param _spender address The address which will spend the funds.
216    * @return A uint256 specifying the amount of tokens still available for the spender.
217    */
218   function allowance(address _owner, address _spender) public view returns (uint256) {
219     return allowed[_owner][_spender];
220   }
221 
222   /**
223    * @dev Increase the amount of tokens that an owner allowed to a spender.
224    *
225    * approve should be called when allowed[_spender] == 0. To increment
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param _spender The address which will spend the funds.
230    * @param _addedValue The amount of tokens to increase the allowance by.
231    */
232   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
233     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
234     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237 
238   /**
239    * @dev Decrease the amount of tokens that an owner allowed to a spender.
240    *
241    * approve should be called when allowed[_spender] == 0. To decrement
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param _spender The address which will spend the funds.
246    * @param _subtractedValue The amount of tokens to decrease the allowance by.
247    */
248   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
249     uint oldValue = allowed[msg.sender][_spender];
250     if (_subtractedValue > oldValue) {
251       allowed[msg.sender][_spender] = 0;
252     } else {
253       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
254     }
255     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259 }
260 
261 contract PausableToken is StandardToken, Pausable {
262 
263   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
264     return super.transfer(_to, _value);
265   }
266 
267   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
268     return super.transferFrom(_from, _to, _value);
269   }
270 
271   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
272     return super.approve(_spender, _value);
273   }
274 
275   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
276     return super.increaseApproval(_spender, _addedValue);
277   }
278 
279   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
280     return super.decreaseApproval(_spender, _subtractedValue);
281   }
282 }
283 contract MintableToken is StandardToken, Ownable {
284   event Mint(address indexed to, uint256 amount);
285   event MintFinished();
286 
287   bool public mintingFinished = false;
288 
289 
290   modifier canMint() {
291     require(!mintingFinished);
292     _;
293   }
294 
295   /**
296    * @dev Function to mint tokens
297    * @param _to The address that will receive the minted tokens.
298    * @param _amount The amount of tokens to mint.
299    * @return A boolean that indicates if the operation was successful.
300    */
301   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
302     totalSupply_ = totalSupply_.add(_amount);
303     balances[_to] = balances[_to].add(_amount);
304     emit Mint(_to, _amount);
305     emit Transfer(address(0), _to, _amount);
306     return true;
307   }
308 
309   /**
310    * @dev Function to stop minting new tokens.
311    * @return True if the operation was successful.
312    */
313   function finishMinting() onlyOwner canMint public returns (bool) {
314     mintingFinished = true;
315     emit MintFinished();
316     return true;
317   }
318 }
319 contract CappedToken is MintableToken {
320 
321   uint256 public cap;
322 
323   function CappedToken(uint256 _cap) public {
324     require(_cap > 0);
325     cap = _cap;
326   }
327 
328   /**
329    * @dev Function to mint tokens
330    * @param _to The address that will receive the minted tokens.
331    * @param _amount The amount of tokens to mint.
332    * @return A boolean that indicates if the operation was successful.
333    */
334   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
335     require(totalSupply_.add(_amount) <= cap);
336 
337     return super.mint(_to, _amount);
338   }
339 
340 }
341 contract Clinicoin is PausableToken, CappedToken {
342 
343 	//metadata 
344 
345 	string public name = "Clinicoin";
346 	string public symbol = "CLIN";
347 	uint256 public decimals = 18;
348 
349 	//Constructor allocates inital pools of tokens and sets totalSupply
350 
351 	function Clinicoin() CappedToken(3000000000 ether){
352 		//initial transfer pause
353 		pause();
354 
355 		
356 	}
357 
358 }