1 pragma solidity ^0.4.25;
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
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
49 contract Ownable {
50   address public owner;
51 
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   constructor() public {
58     owner = msg.sender;
59   }
60 
61 
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70 
71   /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address newOwner) public onlyOwner {
76     if (newOwner != address(0)) {
77       owner = newOwner;
78     }
79   }
80 
81 }
82 
83 /**
84  * @title Pausable
85  * @dev Base contract which allows children to implement an emergency stop mechanism.
86  */
87 contract Pausable is Ownable {
88   event Pause();
89   event Unpause();
90 
91   bool public paused = false;
92 
93 
94   /**
95    * @dev Modifier to make a function callable only when the contract is not paused.
96    */
97   modifier whenNotPaused() {
98     require(!paused);
99     _;
100   }
101 
102   /**
103    * @dev Modifier to make a function callable only when the contract is paused.
104    */
105   modifier whenPaused() {
106     require(paused);
107     _;
108   }
109 
110   /**
111    * @dev called by the owner to pause, triggers stopped state
112    */
113   function pause() onlyOwner whenNotPaused public {
114     paused = true;
115     emit Pause();
116   }
117 
118   /**
119    * @dev called by the owner to unpause, returns to normal state
120    */
121   function unpause() onlyOwner whenPaused public {
122     paused = false;
123     emit Unpause();
124   }
125 
126 }
127 
128 /**
129  * @title ERC20Basic
130  * @dev Simpler version of ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/179
132  */
133 contract ERC20Basic {
134   function totalSupply() public view returns (uint256);
135   function balanceOf(address who) public view returns (uint256);
136   function transfer(address to, uint256 value) public returns (bool);
137   event Transfer(address indexed from, address indexed to, uint256 value);
138 }
139 
140 /**
141  * @title ERC20 interface
142  * @dev see https://github.com/ethereum/EIPs/issues/20
143  */
144 contract ERC20 is ERC20Basic {
145   function allowance(address owner, address spender) public view returns (uint256);
146   function transferFrom(address from, address to, uint256 value) public returns (bool);
147   function approve(address spender, uint256 value) public returns (bool);
148   event Approval(address indexed owner, address indexed spender, uint256 value);
149 }
150 
151 /**
152  * @title Basic token
153  * @dev Basic version of StandardToken, with no allowances.
154  */
155 contract BasicToken is ERC20Basic {
156   using SafeMath for uint256;
157 
158   mapping(address => uint256) balances;
159 
160   uint256 totalSupply_;
161 
162   /**
163   * @dev total number of tokens in existence
164   */
165   function totalSupply() public view returns (uint256) {
166     return totalSupply_;
167   }
168 
169   /**
170   * @dev transfer token for a specified address
171   * @param _to The address to transfer to.
172   * @param _value The amount to be transferred.
173   */
174   function transfer(address _to, uint256 _value) public returns (bool) {
175     require(_to != address(0));
176     require(_value <= balances[msg.sender]);
177 
178     balances[msg.sender] = balances[msg.sender].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     emit Transfer(msg.sender, _to, _value);
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
195 /**
196  * @title Standard ERC20 token
197  *
198  * @dev Implementation of the basic standard token.
199  * @dev https://github.com/ethereum/EIPs/issues/20
200  */
201 contract StandardToken is ERC20, BasicToken {
202 
203   mapping (address => mapping (address => uint256)) internal allowed;
204 
205 
206   /**
207    * @dev Transfer tokens from one address to another
208    * @param _from address The address which you want to send tokens from
209    * @param _to address The address which you want to transfer to
210    * @param _value uint256 the amount of tokens to be transferred
211    */
212   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
213     require(_to != address(0));
214     require(_value <= balances[_from]);
215     require(_value <= allowed[_from][msg.sender]);
216 
217     balances[_from] = balances[_from].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220     emit Transfer(_from, _to, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226    *
227    * Beware that changing an allowance with this method brings the risk that someone may use both the old
228    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231    * @param _spender The address which will spend the funds.
232    * @param _value The amount of tokens to be spent.
233    */
234   function approve(address _spender, uint256 _value) public returns (bool) {
235     allowed[msg.sender][_spender] = _value;
236     emit Approval(msg.sender, _spender, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Function to check the amount of tokens that an owner allowed to a spender.
242    * @param _owner address The address which owns the funds.
243    * @param _spender address The address which will spend the funds.
244    * @return A uint256 specifying the amount of tokens still available for the spender.
245    */
246   function allowance(address _owner, address _spender) public view returns (uint256) {
247     return allowed[_owner][_spender];
248   }
249 
250   /**
251    * @dev Increase the amount of tokens that an owner allowed to a spender.
252    *
253    * approve should be called when allowed[_spender] == 0. To increment
254    * allowed value is better to use this function to avoid 2 calls (and wait until
255    * the first transaction is mined)
256    * From MonolithDAO Token.sol
257    * @param _spender The address which will spend the funds.
258    * @param _addedValue The amount of tokens to increase the allowance by.
259    */
260   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
261     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
262     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263     return true;
264   }
265 
266   /**
267    * @dev Decrease the amount of tokens that an owner allowed to a spender.
268    *
269    * approve should be called when allowed[_spender] == 0. To decrement
270    * allowed value is better to use this function to avoid 2 calls (and wait until
271    * the first transaction is mined)
272    * From MonolithDAO Token.sol
273    * @param _spender The address which will spend the funds.
274    * @param _subtractedValue The amount of tokens to decrease the allowance by.
275    */
276   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
277     uint oldValue = allowed[msg.sender][_spender];
278     if (_subtractedValue > oldValue) {
279       allowed[msg.sender][_spender] = 0;
280     } else {
281       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
282     }
283     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284     return true;
285   }
286 
287 }
288 
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
311 
312   function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
313     uint receiverCount = _receivers.length;
314     uint256 amount = _value.mul(uint256(receiverCount));
315     /* require(receiverCount > 0 && receiverCount <= 20); */
316     require(receiverCount > 0);
317     require(_value > 0 && balances[msg.sender] >= amount);
318 
319     balances[msg.sender] = balances[msg.sender].sub(amount);
320     for (uint i = 0; i < receiverCount; i++) {
321         balances[_receivers[i]] = balances[_receivers[i]].add(_value);
322         emit Transfer(msg.sender, _receivers[i], _value);
323     }
324     return true;
325   }
326 }
327 
328 
329 contract CarDataChainCoinTest is PausableToken {
330 
331     string public constant name = "CarDataChainCoinTest";
332     string public constant symbol = "CDCCT";
333     uint8 public constant decimals = 18;
334 
335     uint256 private constant TOKEN_INITIAL = 2000000000 * (10 ** uint256(decimals));
336 
337     constructor() public {
338       totalSupply_ = TOKEN_INITIAL;
339 
340       balances[msg.sender] = TOKEN_INITIAL;
341       emit Transfer(address(0), msg.sender, TOKEN_INITIAL);
342 
343       paused = false;
344   }
345 }