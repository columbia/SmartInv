1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   /**
30   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 /**
48  * @title ERC20Basic
49  * @dev Simpler version of ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/179
51  */
52 contract ERC20Basic {
53   function totalSupply() public view returns (uint256);
54   function balanceOf(address who) public view returns (uint256);
55   function transfer(address to, uint256 value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances.
62  */
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
86     // SafeMath.sub will throw if there is not enough balance.
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of.
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98   function balanceOf(address _owner) public view returns (uint256 balance) {
99     return balances[_owner];
100   }
101 }
102 
103 /**
104  * @title ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20 is ERC20Basic {
108   function allowance(address owner, address spender) public view returns (uint256);
109   function transferFrom(address from, address to, uint256 value) public returns (bool);
110   function approve(address spender, uint256 value) public returns (bool);
111   event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 /**
115  * @title Standard ERC20 token
116  *
117  * @dev Implementation of the basic standard token.
118  * @dev https://github.com/ethereum/EIPs/issues/20
119  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
120  */
121 contract StandardToken is ERC20, BasicToken {
122 
123   mapping (address => mapping (address => uint256)) internal allowed;
124 
125 
126   /**
127    * @dev Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amount of tokens to be transferred
131    */
132   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[_from]);
135     require(_value <= allowed[_from][msg.sender]);
136 
137     balances[_from] = balances[_from].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140     Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
146    *
147    * Beware that changing an allowance with this method brings the risk that someone may use both the old
148    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint256 _value) public returns (bool) {
155     allowed[msg.sender][_spender] = _value;
156     Approval(msg.sender, _spender, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Function to check the amount of tokens that an owner allowed to a spender.
162    * @param _owner address The address which owns the funds.
163    * @param _spender address The address which will spend the funds.
164    * @return A uint256 specifying the amount of tokens still available for the spender.
165    */
166   function allowance(address _owner, address _spender) public view returns (uint256) {
167     return allowed[_owner][_spender];
168   }
169 
170   /**
171    * @dev Increase the amount of tokens that an owner allowed to a spender.
172    *
173    * approve should be called when allowed[_spender] == 0. To increment
174    * allowed value is better to use this function to avoid 2 calls (and wait until
175    * the first transaction is mined)
176    * From MonolithDAO Token.sol
177    * @param _spender The address which will spend the funds.
178    * @param _addedValue The amount of tokens to increase the allowance by.
179    */
180   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
181     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
182     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186   /**
187    * @dev Decrease the amount of tokens that an owner allowed to a spender.
188    *
189    * approve should be called when allowed[_spender] == 0. To decrement
190    * allowed value is better to use this function to avoid 2 calls (and wait until
191    * the first transaction is mined)
192    * From MonolithDAO Token.sol
193    * @param _spender The address which will spend the funds.
194    * @param _subtractedValue The amount of tokens to decrease the allowance by.
195    */
196   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
197     uint oldValue = allowed[msg.sender][_spender];
198     if (_subtractedValue > oldValue) {
199       allowed[msg.sender][_spender] = 0;
200     } else {
201       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
202     }
203     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204     return true;
205   }
206 
207 }
208 
209 /**
210  * @title Ownable
211  * @dev The Ownable contract has an owner address, and provides basic authorization control
212  * functions, this simplifies the implementation of "user permissions".
213  */
214 contract Ownable {
215   address public owner;
216 
217 
218   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
219 
220 
221   /**
222    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
223    * account.
224    */
225   function Ownable() public {
226     owner = msg.sender;
227   }
228 
229   /**
230    * @dev Throws if called by any account other than the owner.
231    */
232   modifier onlyOwner() {
233     require(msg.sender == owner);
234     _;
235   }
236 
237   /**
238    * @dev Allows the current owner to transfer control of the contract to a newOwner.
239    * @param newOwner The address to transfer ownership to.
240    */
241   function transferOwnership(address newOwner) public onlyOwner {
242     require(newOwner != address(0));
243     OwnershipTransferred(owner, newOwner);
244     owner = newOwner;
245   }
246 
247 }
248 
249 /**
250  * @title Mintable token
251  * @dev Simple ERC20 Token example, with mintable token creation
252  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
253  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
254  */
255 contract MintableToken is StandardToken, Ownable {
256   event Mint(address indexed to, uint256 amount);
257   event MintFinished();
258 
259   bool public mintingFinished = false;
260 
261 
262   modifier canMint() {
263     require(!mintingFinished);
264     _;
265   }
266 
267   /**
268    * @dev Function to mint tokens
269    * @param _to The address that will receive the minted tokens.
270    * @param _amount The amount of tokens to mint.
271    * @return A boolean that indicates if the operation was successful.
272    */
273   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
274     totalSupply_ = totalSupply_.add(_amount);
275     balances[_to] = balances[_to].add(_amount);
276     Mint(_to, _amount);
277     Transfer(address(0), _to, _amount);
278     return true;
279   }
280 
281   /**
282    * @dev Function to stop minting new tokens.
283    * @return True if the operation was successful.
284    */
285   function finishMinting() onlyOwner canMint public returns (bool) {
286     mintingFinished = true;
287     MintFinished();
288     return true;
289   }
290 }
291 
292 contract BLS is MintableToken {
293   using SafeMath for uint256;
294 
295   string public name = "BLS Token";
296   string public symbol = "BLS";
297   uint8 public decimals = 18;
298 
299   bool public enableTransfers = false;
300 
301   // functions overrides in order to maintain the token locked during the ICO
302   function transfer(address _to, uint256 _value) public returns(bool) {
303     require(enableTransfers);
304     return super.transfer(_to,_value);
305   }
306 
307   function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
308       require(enableTransfers);
309       return super.transferFrom(_from,_to,_value);
310   }
311 
312   function approve(address _spender, uint256 _value) public returns (bool) {
313     require(enableTransfers);
314     return super.approve(_spender,_value);
315   }
316 
317   /* function burn(uint256 _value) public {
318     require(enableTransfers);
319     super.burn(_value);
320   } */
321 
322   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
323     require(enableTransfers);
324     super.increaseApproval(_spender, _addedValue);
325   }
326 
327   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
328     require(enableTransfers);
329     super.decreaseApproval(_spender, _subtractedValue);
330   }
331 
332   // enable token transfers
333   function enableTokenTransfers() public onlyOwner {
334     enableTransfers = true;
335   }
336 }