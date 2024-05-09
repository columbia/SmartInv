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
46 contract Ownable {
47   address public owner;
48 
49 
50   event OwnershipRenounced(address indexed previousOwner);
51   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53 
54   /**
55    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56    * account.
57    */
58   constructor() public {
59     owner = msg.sender;
60   }
61 
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     emit OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80   /**
81    * @dev Allows the current owner to relinquish control of the contract.
82    */
83   function renounceOwnership() public onlyOwner {
84     emit OwnershipRenounced(owner);
85     owner = address(0);
86   }
87 }
88 
89 
90 contract ERC20Basic {
91   function totalSupply() public view returns (uint256);
92   function balanceOf(address who) public view returns (uint256);
93   function transfer(address to, uint256 value) public returns (bool);
94   event Transfer(address indexed from, address indexed to, uint256 value);
95 }
96 
97 
98 contract ERC20 is ERC20Basic {
99   function allowance(address owner, address spender)
100     public view returns (uint256);
101 
102   function transferFrom(address from, address to, uint256 value)
103     public returns (bool);
104 
105   function approve(address spender, uint256 value) public returns (bool);
106   event Approval(
107     address indexed owner,
108     address indexed spender,
109     uint256 value
110   );
111 }
112 
113 
114 contract BasicToken is ERC20Basic {
115   using SafeMath for uint256;
116 
117   mapping(address => uint256) balances;
118 
119   uint256 totalSupply_;
120 
121   /**
122   * @dev total number of tokens in existence
123   */
124   function totalSupply() public view returns (uint256) {
125     return totalSupply_;
126   }
127 
128   /**
129   * @dev transfer token for a specified address
130   * @param _to The address to transfer to.
131   * @param _value The amount to be transferred.
132   */
133   function transfer(address _to, uint256 _value) public returns (bool) {
134     require(_to != address(0));
135     require(_value <= balances[msg.sender]);
136 
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     emit Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256) {
149     return balances[_owner];
150   }
151 
152 }
153 
154 
155 contract StandardToken is ERC20, BasicToken {
156 
157   mapping (address => mapping (address => uint256)) internal allowed;
158 
159 
160   /**
161    * @dev Transfer tokens from one address to another
162    * @param _from address The address which you want to send tokens from
163    * @param _to address The address which you want to transfer to
164    * @param _value uint256 the amount of tokens to be transferred
165    */
166   function transferFrom(
167     address _from,
168     address _to,
169     uint256 _value
170   )
171     public
172     returns (bool)
173   {
174     require(_to != address(0));
175     require(_value <= balances[_from]);
176     require(_value <= allowed[_from][msg.sender]);
177 
178     balances[_from] = balances[_from].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
181     emit Transfer(_from, _to, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187    *
188    * Beware that changing an allowance with this method brings the risk that someone may use both the old
189    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
190    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
191    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192    * @param _spender The address which will spend the funds.
193    * @param _value The amount of tokens to be spent.
194    */
195   function approve(address _spender, uint256 _value) public returns (bool) {
196     allowed[msg.sender][_spender] = _value;
197     emit Approval(msg.sender, _spender, _value);
198     return true;
199   }
200 
201   /**
202    * @dev Function to check the amount of tokens that an owner allowed to a spender.
203    * @param _owner address The address which owns the funds.
204    * @param _spender address The address which will spend the funds.
205    * @return A uint256 specifying the amount of tokens still available for the spender.
206    */
207   function allowance(
208     address _owner,
209     address _spender
210    )
211     public
212     view
213     returns (uint256)
214   {
215     return allowed[_owner][_spender];
216   }
217 
218   /**
219    * @dev Increase the amount of tokens that an owner allowed to a spender.
220    *
221    * approve should be called when allowed[_spender] == 0. To increment
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _addedValue The amount of tokens to increase the allowance by.
227    */
228   function increaseApproval(
229     address _spender,
230     uint _addedValue
231   )
232     public
233     returns (bool)
234   {
235     allowed[msg.sender][_spender] = (
236       allowed[msg.sender][_spender].add(_addedValue));
237     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241   /**
242    * @dev Decrease the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To decrement
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _subtractedValue The amount of tokens to decrease the allowance by.
250    */
251   function decreaseApproval(
252     address _spender,
253     uint _subtractedValue
254   )
255     public
256     returns (bool)
257   {
258     uint oldValue = allowed[msg.sender][_spender];
259     if (_subtractedValue > oldValue) {
260       allowed[msg.sender][_spender] = 0;
261     } else {
262       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
263     }
264     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265     return true;
266   }
267 
268 }
269 
270 
271 contract MintableToken is StandardToken, Ownable {
272   event Mint(address indexed to, uint256 amount);
273   event MintFinished();
274 
275   bool public mintingFinished = false;
276 
277 
278   modifier canMint() {
279     require(!mintingFinished);
280     _;
281   }
282 
283   modifier hasMintPermission() {
284     require(msg.sender == owner);
285     _;
286   }
287 
288   /**
289    * @dev Function to mint tokens
290    * @param _to The address that will receive the minted tokens.
291    * @param _amount The amount of tokens to mint.
292    * @return A boolean that indicates if the operation was successful.
293    */
294   function mint(
295     address _to,
296     uint256 _amount
297   )
298     hasMintPermission
299     canMint
300     public
301     returns (bool)
302   {
303     totalSupply_ = totalSupply_.add(_amount);
304     balances[_to] = balances[_to].add(_amount);
305     emit Mint(_to, _amount);
306     emit Transfer(address(0), _to, _amount);
307     return true;
308   }
309 
310   /**
311    * @dev Function to stop minting new tokens.
312    * @return True if the operation was successful.
313    */
314   function finishMinting() onlyOwner canMint public returns (bool) {
315     mintingFinished = true;
316     emit MintFinished();
317     return true;
318   }
319 }
320 
321 /**
322  * @title DigiUSD
323  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
324  * Note they can later distribute these tokens as they wish using `transfer` and other
325  * `StandardToken` functions.
326  */
327 contract DigiUSD is StandardToken , MintableToken {
328 
329   string public constant name = "DigiUSD"; // solium-disable-line uppercase
330   string public constant symbol = "DUSD"; // solium-disable-line uppercase
331   uint8 public constant decimals = 18; // solium-disable-line uppercase
332 
333   uint256 public constant INITIAL_SUPPLY = 500000000000000000000000000;
334 
335   /**
336    * @dev Constructor that gives msg.sender all of existing tokens.
337    */
338   constructor() public {
339     totalSupply_ = INITIAL_SUPPLY;
340     balances[msg.sender] = INITIAL_SUPPLY;
341     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
342   }
343 
344 }