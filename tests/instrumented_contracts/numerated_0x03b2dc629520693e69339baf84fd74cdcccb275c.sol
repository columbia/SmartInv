1 pragma solidity ^0.4.18;
2 
3 
4 
5 contract ERC20Basic {
6   function totalSupply() public view returns (uint256);
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 
13 library SafeMath {
14 
15   /**
16   * @dev Multiplies two numbers, throws on overflow.
17   */
18   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19     if (a == 0) {
20       return 0;
21     }
22     uint256 c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   /**
38   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) balances;
58 
59   uint256 totalSupply_;
60 
61   /**
62   * @dev total number of tokens in existence
63   */
64   function totalSupply() public view returns (uint256) {
65     return totalSupply_;
66   }
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[msg.sender]);
76 
77     // SafeMath.sub will throw if there is not enough balance.
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of.
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) public view returns (uint256 balance) {
90     return balances[_owner];
91   }
92 
93 }
94 
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender) public view returns (uint256);
97   function transferFrom(address from, address to, uint256 value) public returns (bool);
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 library SafeERC20 {
102   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
103     assert(token.transfer(to, value));
104   }
105 
106   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
107     assert(token.transferFrom(from, to, value));
108   }
109 
110   function safeApprove(ERC20 token, address spender, uint256 value) internal {
111     assert(token.approve(spender, value));
112   }
113 }
114 contract StandardToken is ERC20, BasicToken {
115 
116   mapping (address => mapping (address => uint256)) internal allowed;
117 
118 
119   /**
120    * @dev Transfer tokens from one address to another
121    * @param _from address The address which you want to send tokens from
122    * @param _to address The address which you want to transfer to
123    * @param _value uint256 the amount of tokens to be transferred
124    */
125   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[_from]);
128     require(_value <= allowed[_from][msg.sender]);
129 
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133     Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139    *
140    * Beware that changing an allowance with this method brings the risk that someone may use both the old
141    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144    * @param _spender The address which will spend the funds.
145    * @param _value The amount of tokens to be spent.
146    */
147   function approve(address _spender, uint256 _value) public returns (bool) {
148     allowed[msg.sender][_spender] = _value;
149     Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(address _owner, address _spender) public view returns (uint256) {
160     return allowed[_owner][_spender];
161   }
162 
163   /**
164    * @dev Increase the amount of tokens that an owner allowed to a spender.
165    *
166    * approve should be called when allowed[_spender] == 0. To increment
167    * allowed value is better to use this function to avoid 2 calls (and wait until
168    * the first transaction is mined)
169    * From MonolithDAO Token.sol
170    * @param _spender The address which will spend the funds.
171    * @param _addedValue The amount of tokens to increase the allowance by.
172    */
173   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
174     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
175     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176     return true;
177   }
178 
179   /**
180    * @dev Decrease the amount of tokens that an owner allowed to a spender.
181    *
182    * approve should be called when allowed[_spender] == 0. To decrement
183    * allowed value is better to use this function to avoid 2 calls (and wait until
184    * the first transaction is mined)
185    * From MonolithDAO Token.sol
186    * @param _spender The address which will spend the funds.
187    * @param _subtractedValue The amount of tokens to decrease the allowance by.
188    */
189   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
190     uint oldValue = allowed[msg.sender][_spender];
191     if (_subtractedValue > oldValue) {
192       allowed[msg.sender][_spender] = 0;
193     } else {
194       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
195     }
196     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 
200 }
201 contract Ownable {
202   address public owner;
203 
204 
205   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
206 
207 
208   /**
209    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
210    * account.
211    */
212   function Ownable() public {
213     owner = msg.sender;
214   }
215 
216   /**
217    * @dev Throws if called by any account other than the owner.
218    */
219   modifier onlyOwner() {
220     require(msg.sender == owner);
221     _;
222   }
223 
224   /**
225    * @dev Allows the current owner to transfer control of the contract to a newOwner.
226    * @param newOwner The address to transfer ownership to.
227    */
228   function transferOwnership(address newOwner) public onlyOwner {
229     require(newOwner != address(0));
230     OwnershipTransferred(owner, newOwner);
231     owner = newOwner;
232   }
233 
234 }
235 
236 contract Pausable is Ownable {
237   event Pause();
238   event Unpause();
239 
240   bool public paused = false;
241 
242 
243   /**
244    * @dev Modifier to make a function callable only when the contract is not paused.
245    */
246   modifier whenNotPaused() {
247     require(!paused);
248     _;
249   }
250 
251   /**
252    * @dev Modifier to make a function callable only when the contract is paused.
253    */
254   modifier whenPaused() {
255     require(paused);
256     _;
257   }
258 
259   /**
260    * @dev called by the owner to pause, triggers stopped state
261    */
262   function pause() onlyOwner whenNotPaused public {
263     paused = true;
264     Pause();
265   }
266 
267   /**
268    * @dev called by the owner to unpause, returns to normal state
269    */
270   function unpause() onlyOwner whenPaused public {
271     paused = false;
272     Unpause();
273   }
274 }
275 
276 contract PausableToken is StandardToken, Pausable {
277 
278   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
279     return super.transfer(_to, _value);
280   }
281 
282   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
283     return super.transferFrom(_from, _to, _value);
284   }
285 
286   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
287     return super.approve(_spender, _value);
288   }
289 
290   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
291     return super.increaseApproval(_spender, _addedValue);
292   }
293 
294   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
295     return super.decreaseApproval(_spender, _subtractedValue);
296   }
297 }
298 
299 
300 contract RICO is PausableToken {
301     using SafeMath for uint256;
302 
303     string public name = "RICO";
304     string public symbol = "RICO";
305     uint256 public decimals = 18;
306     uint256 public totalSupply = 20000000 * (10 ** decimals);
307     address public beneficiary = 0x1eCD8a6Bf1fdB629b3e47957178760962C91b7ca;
308 
309     mapping (address => uint256) public spawnWallet;
310 
311     function RICO() public {
312         // initially assign all tokens to the fundsWallet
313         spawnWallet[beneficiary] = totalSupply;
314     
315     }
316     function totalSupply() public constant returns (uint256 totalsupply) {
317         return totalSupply;
318     }
319     
320     function balanceOf(address _owner) public constant returns (uint256 balance) {
321         return spawnWallet[_owner];  
322     }
323 }