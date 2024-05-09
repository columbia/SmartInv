1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title ERC20Basic
37  * @dev Simpler version of ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/179
39  */
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) public constant returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 /**
48  * @title ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/20
50  */
51 contract ERC20 is ERC20Basic {
52   function allowance(address owner, address spender) public constant returns (uint256);
53   function transferFrom(address from, address to, uint256 value) public returns (bool);
54   function approve(address spender, uint256 value) public returns (bool);
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances.
61  */
62 contract BasicToken is ERC20Basic {
63   using SafeMath for uint256;
64 
65   mapping(address => uint256) balances;
66 
67   /**
68   * @dev transfer token for a specified address
69   * @param _to The address to transfer to.
70   * @param _value The amount to be transferred.
71   */
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0));
74 
75     // SafeMath.sub will throw if there is not enough balance.
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public constant returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * @dev https://github.com/ethereum/EIPs/issues/20
98  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract StandardToken is ERC20, BasicToken {
101 
102   mapping (address => mapping (address => uint256)) allowed;
103 
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amount of tokens to be transferred
110    */
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113 
114     uint256 _allowance = allowed[_from][msg.sender];
115 
116     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
117     // require (_value <= _allowance);
118 
119     balances[_from] = balances[_from].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     allowed[_from][msg.sender] = _allowance.sub(_value);
122     Transfer(_from, _to, _value);
123     return true;
124   }
125 
126   /**
127    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128    *
129    * Beware that changing an allowance with this method brings the risk that someone may use both the old
130    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
131    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
132    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133    * @param _spender The address which will spend the funds.
134    * @param _value The amount of tokens to be spent.
135    */
136   function approve(address _spender, uint256 _value) public returns (bool) {
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint256 specifying the amount of tokens still available for the spender.
147    */
148   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
149     return allowed[_owner][_spender];
150   }
151 
152   /**
153    * approve should be called when allowed[_spender] == 0. To increment
154    * allowed value is better to use this function to avoid 2 calls (and wait until
155    * the first transaction is mined)
156    * From MonolithDAO Token.sol
157    */
158   function increaseApproval (address _spender, uint _addedValue)
159     returns (bool success) {
160     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   function decreaseApproval (address _spender, uint _subtractedValue)
166     returns (bool success) {
167     uint oldValue = allowed[msg.sender][_spender];
168     if (_subtractedValue > oldValue) {
169       allowed[msg.sender][_spender] = 0;
170     } else {
171       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172     }
173     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177 }
178 
179 /**
180  * @title Ownable
181  * @dev The Ownable contract has an owner address, and provides basic authorization control
182  * functions, this simplifies the implementation of "user permissions".
183  */
184 contract Ownable {
185   address public owner;
186 
187 
188   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190 
191   /**
192    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
193    * account.
194    */
195   function Ownable() {
196     owner = msg.sender;
197   }
198 
199 
200   /**
201    * @dev Throws if called by any account other than the owner.
202    */
203   modifier onlyOwner() {
204     require(msg.sender == owner);
205     _;
206   }
207 
208 
209   /**
210    * @dev Allows the current owner to transfer control of the contract to a newOwner.
211    * @param newOwner The address to transfer ownership to.
212    */
213   function transferOwnership(address newOwner) onlyOwner public {
214     require(newOwner != address(0));
215     OwnershipTransferred(owner, newOwner);
216     owner = newOwner;
217   }
218 
219 }
220 
221 
222 /**
223  * @title Mintable token
224  * @dev Simple ERC20 Token example, with mintable token creation
225  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
226  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
227  */
228 
229 contract MintableToken is StandardToken, Ownable {
230   event Mint(address indexed to, uint256 amount);
231   event MintFinished();
232 
233   bool public mintingFinished = false;
234 
235 
236   modifier canMint() {
237     require(!mintingFinished);
238     _;
239   }
240 
241   /**
242    * @dev Function to mint tokens
243    * @param _to The address that will receive the minted tokens.
244    * @param _amount The amount of tokens to mint.
245    * @return A boolean that indicates if the operation was successful.
246    */
247   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
248     totalSupply = totalSupply.add(_amount);
249     balances[_to] = balances[_to].add(_amount);
250     Mint(_to, _amount);
251     Transfer(0x0, _to, _amount);
252     return true;
253   }
254 
255   /**
256    * @dev Function to stop minting new tokens.
257    * @return True if the operation was successful.
258    */
259   function finishMinting() onlyOwner public returns (bool) {
260     mintingFinished = true;
261     MintFinished();
262     return true;
263   }
264 }
265 
266 
267 /**
268  * @title Pausable
269  * @dev Base contract which allows children to implement an emergency stop mechanism.
270  */
271 contract Pausable is Ownable {
272   event Pause();
273   event Unpause();
274 
275   bool public paused = false;
276 
277 
278   /**
279    * @dev Modifier to make a function callable only when the contract is not paused.
280    */
281   modifier whenNotPaused() {
282     require(!paused);
283     _;
284   }
285 
286   /**
287    * @dev Modifier to make a function callable only when the contract is paused.
288    */
289   modifier whenPaused() {
290     require(paused);
291     _;
292   }
293 
294   /**
295    * @dev called by the owner to pause, triggers stopped state
296    */
297   function pause() onlyOwner whenNotPaused public {
298     paused = true;
299     Pause();
300   }
301 
302   /**
303    * @dev called by the owner to unpause, returns to normal state
304    */
305   function unpause() onlyOwner whenPaused public {
306     paused = false;
307     Unpause();
308   }
309 }
310 
311 
312 /**
313  * @title Pausable token
314  *
315  * @dev StandardToken modified with pausable transfers.
316  **/
317 
318 contract PausableToken is StandardToken, Pausable {
319 
320   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
321     return super.transfer(_to, _value);
322   }
323 
324   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
325     return super.transferFrom(_from, _to, _value);
326   }
327 
328   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
329     return super.approve(_spender, _value);
330   }
331 
332   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
333     return super.increaseApproval(_spender, _addedValue);
334   }
335 
336   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
337     return super.decreaseApproval(_spender, _subtractedValue);
338   }
339 }
340 
341 
342 /**
343 * @dev Main Bitcalve CAT token ERC20 contract
344 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
345 * 
346 */
347 contract CAToken is MintableToken, PausableToken {
348     
349     // Metadata
350     string public constant symbol = "CAT";
351     string public constant name = "Consumer Activity Token";
352     uint256 public constant decimals = 18;
353     string public constant version = "1.0";
354 
355 }