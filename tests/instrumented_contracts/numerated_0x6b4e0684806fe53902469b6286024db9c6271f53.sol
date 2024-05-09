1 pragma solidity ^0.4.9;
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
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50   /** 
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() {
55     owner = msg.sender;
56   }
57 
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) onlyOwner public {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract ERC20Basic {
81   function totalSupply() public view returns (uint256);
82   function balanceOf(address who) public view returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
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
115     Pause();
116   }
117 
118   /**
119    * @dev called by the owner to unpause, returns to normal state
120    */
121   function unpause() onlyOwner whenPaused public {
122     paused = false;
123     Unpause();
124   }
125 }
126 
127 contract BasicToken is Ownable, ERC20Basic {
128   using SafeMath for uint256;
129 
130   mapping(address => uint256) balances;
131 
132   uint256 totalSupply_;
133 
134   /**
135   * @dev total number of tokens in existence
136   */
137   function totalSupply() public view returns (uint256) {
138     return totalSupply_;
139   }
140 
141   /**
142   * @dev transfer token for a specified address
143   * @param _to The address to transfer to.
144   * @param _value The amount to be transferred.
145   */
146   function transfer(address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[msg.sender]);
149 
150     // SafeMath.sub will throw if there is not enough balance.
151     balances[msg.sender] = balances[msg.sender].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     Transfer(msg.sender, _to, _value);
154     return true;
155   }
156 
157   /**
158   * @dev Gets the balance of the specified address.
159   * @param _owner The address to query the the balance of.
160   * @return An uint256 representing the amount owned by the passed address.
161   */
162   function balanceOf(address _owner) public view returns (uint256 balance) {
163     return balances[_owner];
164   }
165 
166 }
167 
168 contract ERC20 is ERC20Basic {
169   function allowance(address owner, address spender) public view returns (uint256);
170   function transferFrom(address from, address to, uint256 value) public returns (bool);
171   function approve(address spender, uint256 value) public returns (bool);
172   event Approval(address indexed owner, address indexed spender, uint256 value);
173 }
174 
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
187     require(_to != address(0));
188     require(_value <= balances[_from]);
189     require(_value <= allowed[_from][msg.sender]);
190 
191     balances[_from] = balances[_from].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194     Transfer(_from, _to, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    *
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param _spender The address which will spend the funds.
206    * @param _value The amount of tokens to be spent.
207    */
208   function approve(address _spender, uint256 _value) public returns (bool) {
209     allowed[msg.sender][_spender] = _value;
210     Approval(msg.sender, _spender, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param _owner address The address which owns the funds.
217    * @param _spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(address _owner, address _spender) public view returns (uint256) {
221     return allowed[_owner][_spender];
222   }
223 
224   /**
225    * @dev Increase the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
235     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240   /**
241    * @dev Decrease the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To decrement
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _subtractedValue The amount of tokens to decrease the allowance by.
249    */
250   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
251     uint oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue > oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261 }
262 
263 contract TuneToken is Pausable, StandardToken {
264 
265   string public constant name = "TuneToken"; // solium-disable-line uppercase
266   string public constant symbol = "TUNE"; // solium-disable-line uppercase
267   uint8 public constant decimals = 18; // solium-disable-line uppercase
268 
269   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
270 
271   /**
272    * @dev Constructor that gives msg.sender all of existing tokens.
273    */
274   function TuneToken() public {
275     totalSupply_ = INITIAL_SUPPLY;
276     balances[msg.sender] = INITIAL_SUPPLY;
277     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
278   }
279 
280   /**
281    * @dev Transfer token for a specified address when not paused
282    * @param _to The address to transfer to.
283    * @param _value The amount to be transferred.
284    */    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
285       return super.transfer(_to, _value);
286     }
287 
288   /**
289    * @dev Transfer tokens from one address to another when not paused
290    * @param _from address The address which you want to send tokens from
291    * @param _to address The address which you want to transfer to
292    * @param _value uint256 the amount of tokens to be transferred
293    */
294   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
295     return super.transferFrom(_from, _to, _value);
296   }
297   /**
298    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
299    * @param _spender The address which will spend the funds.
300    * @param _value The amount of tokens to be spent.
301    */
302   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
303     return super.approve(_spender, _value);
304   }
305 
306   /**
307    * Adding whenNotPaused
308    */
309   function increaseApproval (address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
310     return super.increaseApproval(_spender, _addedValue);
311   }
312 
313   /**
314    * Adding whenNotPaused
315    */
316   function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
317     return super.decreaseApproval(_spender, _subtractedValue);
318   }
319 
320 }