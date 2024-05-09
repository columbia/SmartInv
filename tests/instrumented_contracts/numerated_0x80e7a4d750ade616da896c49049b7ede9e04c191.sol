1 pragma solidity ^0.4.11;
2 
3 /************************************************************************************************
4 *  
5 *  AstrCoin 20171115
6 * 
7 *************************************************************************************************/
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {  //was constant
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 /************************************************************************************************
40  * 
41  *************************************************************************************************/
42 
43 contract Ownable {
44   address public owner;
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable()  {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 
77 /************************************************************************************************
78  * 
79  *************************************************************************************************/
80 /**
81  * @title Pausable
82  * @dev Base contract which allows children to implement an emergency stop mechanism.
83  */
84 contract Pausable is Ownable {
85   event Pause();
86   event Unpause();
87 
88   bool public paused = false;
89 
90 
91   /**
92    * @dev Modifier to make a function callable only when the contract is not paused.
93    */
94   modifier whenNotPaused() {
95     require(!paused);
96     _;
97   }
98 
99   /**
100    * @dev Modifier to make a function callable only when the contract is paused.
101    */
102   modifier whenPaused() {
103     require(paused);
104     _;
105   }
106 
107   /**
108    * @dev called by the owner to pause, triggers stopped state
109    */
110   function pause() onlyOwner whenNotPaused public {
111     paused = true;
112     Pause();
113   }
114 
115   /**
116    * @dev called by the owner to unpause, returns to normal state
117    */
118   function unpause() onlyOwner whenPaused public {
119     paused = false;
120     Unpause();
121   }
122 }
123 /************************************************************************************************
124  * 
125  *************************************************************************************************/
126 
127 /**
128  * @title ERC20Basic
129  * @dev Simpler version of ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/179
131  */
132 contract ERC20Basic {
133   uint256 public totalSupply;
134   function balanceOf(address who) public constant returns (uint256);
135   function transfer(address to, uint256 value) public returns (bool);
136   event Transfer(address indexed from, address indexed to, uint256 value);
137 }
138 
139 /************************************************************************************************
140  * 
141  *************************************************************************************************/
142 
143 /**
144  * @title ERC20 interface
145  * @dev see https://github.com/ethereum/EIPs/issues/20
146  */
147 contract ERC20 is ERC20Basic {
148   function allowance(address owner, address spender) public constant returns (uint256);
149   function transferFrom(address from, address to, uint256 value) public returns (bool);
150   function approve(address spender, uint256 value) public returns (bool);
151   event Approval(address indexed owner, address indexed spender, uint256 value);
152 }
153 
154 
155 
156 
157 /************************************************************************************************
158  * 
159  *************************************************************************************************/
160 /**
161  */
162 contract BasicToken is ERC20Basic {
163   using SafeMath for uint256;
164 
165   mapping(address => uint256) balances;
166 
167 
168   /**
169   * @dev transfer token for a specified address
170   */
171   function transfer(address _to, uint256 _value) public returns (bool) {
172     require(_to != address(0));
173     require(_value <= balances[msg.sender]);
174 
175     // SafeMath.sub will throw if there is not enough balance.
176     balances[msg.sender] = balances[msg.sender].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     Transfer(msg.sender, _to, _value);
179     return true;
180   }
181 
182   /**
183   * @return An uint256 representing the amount owned by the passed address.
184   */
185   function balanceOf(address _owner) public constant returns (uint256 balance) {
186     return balances[_owner];
187   }
188 
189 
190 
191 
192 }
193 
194 /************************************************************************************************
195  * 
196  *************************************************************************************************/
197 contract StandardToken is ERC20, BasicToken {
198 
199   mapping (address => mapping (address => uint256)) internal allowed;
200 
201 
202   /**
203    */
204   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
205     require(_to != address(0));
206     require(_value <= balances[_from]);
207     require(_value <= allowed[_from][msg.sender]);
208 
209     balances[_from] = balances[_from].sub(_value);
210     balances[_to] = balances[_to].add(_value);
211     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212     Transfer(_from, _to, _value);
213     return true;
214   }
215 
216   /**
217    *
218    * Beware that changing an allowance with this method brings the risk that someone may use both the old
219    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222    */
223   function approve(address _spender, uint256 _value) public returns (bool) {
224     allowed[msg.sender][_spender] = _value;
225     Approval(msg.sender, _spender, _value);
226     return true;
227   }
228 
229   /**
230    */
231   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
232     return allowed[_owner][_spender];
233   }
234 
235   /**
236    * approve should be called when allowed[_spender] == 0. To increment
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    */
241   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
242     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
243     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
248     uint oldValue = allowed[msg.sender][_spender];
249     if (_subtractedValue > oldValue) {
250       allowed[msg.sender][_spender] = 0;
251     } else {
252       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253     }
254     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258 }
259 
260 
261 /**
262  * [receiveApproval description]
263  */
264 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
265 
266 
267 /************************************************************************************************
268  * 
269  *************************************************************************************************/
270 /**
271  *  AstrCoin token contract. Implements
272  */
273 contract AstrCoin is StandardToken, Ownable {
274   string public constant name     = "AstrCoin";
275   string public constant symbol   = "ASTR";
276   uint8 public  constant decimals = 4;    // 4 decimal places should be enough in general
277 
278   uint256 public constant INITIAL_SUPPLY = 200000000 * (10 ** uint256(decimals)); // 200 mill
279   bool public mintingFinished            = false;
280 
281   event Mint(address indexed to, uint256 amount);
282   event MintFinished();
283 
284   mapping (address => bool) public frozenAccount;
285     event FrozenFunds(address target, bool frozen);
286 
287    /**
288      * [freezeAccount description]
289      */
290     function freezeAccount(address target, bool freeze) onlyOwner public{
291         frozenAccount[target] = freeze;
292         FrozenFunds(target, freeze);
293     }
294 
295 
296   modifier canMint() {
297     require(!mintingFinished);
298     _;
299   }
300 
301   // Constructor
302   function AstrCoin()  {
303       totalSupply          = INITIAL_SUPPLY;
304       balances[msg.sender] = totalSupply; // Send all tokens to owner
305   }
306   /**
307    *  Burn away the specified amount of AstrCoin tokens
308    */
309   function burn(uint _value) onlyOwner public returns (bool) {
310     balances[msg.sender] = balances[msg.sender].sub(_value);
311     totalSupply          = totalSupply.sub(_value);
312     Transfer(msg.sender, 0x0, _value);
313     return true;
314   }
315 
316   /**
317    * @dev Function to mint tokens
318    * @param _to The address that will receive the minted tokens.
319    * @param _amount The amount of tokens to mint.
320    * @return A boolean that indicates if the operation was successful.
321    */
322   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
323     totalSupply = totalSupply.add(_amount);
324     balances[_to] = balances[_to].add(_amount);
325     Mint(_to, _amount);
326     Transfer(address(0), _to, _amount);
327     return true;
328   }
329 
330 
331 
332   /**
333    * @dev Function to stop minting new tokens.
334    * @return True if the operation was successful.
335    */
336   function finishMinting() onlyOwner public returns (bool) {
337     mintingFinished = true;
338     MintFinished();
339     return true;
340   }
341 }