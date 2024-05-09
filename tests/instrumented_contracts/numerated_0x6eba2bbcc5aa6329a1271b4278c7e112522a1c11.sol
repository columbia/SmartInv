1 pragma solidity ^0.4.15;
2 
3 /**
4  * @contract Deal Token (DEAL)
5  * This has all the functions and events of a standard ERC20 Token as decribed here
6  * https://theethereum.wiki/w/index.php/ERC20_Token_Standard
7  * Along with them it also has one additional functionality 
8  * Burn - To burn existing coins
9  */
10 
11  /**
12  * Math operations with safety checks
13  */
14 library SafeMath {
15   function mul(uint a, uint b) internal returns (uint) {
16     uint c = a * b;
17     assert(a == 0 || c / a == b);
18     return c;
19   }
20 
21   function div(uint a, uint b) internal returns (uint) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint a, uint b) internal returns (uint) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint a, uint b) internal returns (uint) {
34     uint c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 
39   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
40     return a >= b ? a : b;
41   }
42 
43   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
44     return a < b ? a : b;
45   }
46 
47   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
48     return a >= b ? a : b;
49   }
50 
51   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
52     return a < b ? a : b;
53   }  
54 }
55 
56 /**
57  * @title Ownable
58  * @dev The Ownable contract has an owner address, and provides basic authorization control , transfering ownership
59  * functions, sets the contract creator as the owner who is also the central administrator
60  */
61 contract Ownable {
62   address public owner;
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() {
70   owner = msg.sender;
71   }
72 
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82 
83   /**
84    * @dev Allows the current owner to transfer control of the contract to a newOwner.
85    * @param newOwner The address to transfer ownership to.
86    */
87   function transferOwnership(address newOwner) onlyOwner {
88   if (newOwner != address(0)) {
89     owner = newOwner;
90   }
91   }
92 
93 }
94 
95 /**
96  * @title Pausable
97  * @dev Base contract which allows children to implement an emergency stop mechanism.
98  */
99 contract Pausable is Ownable {
100   event Pause();
101   event Unpause();
102   bool public paused = false;
103   /**
104    * @dev Modifier to make a function callable only when the contract is not paused.
105    */
106   modifier whenNotPaused() {
107     require(!paused);
108     _;
109   }
110   /**
111    * @dev Modifier to make a function callable only when the contract is paused.
112    */
113   modifier whenPaused() {
114     require(paused);
115     _;
116   }
117   /**
118    * @dev called by the owner to pause, triggers stopped state
119    */
120   function pause() onlyOwner whenNotPaused public {
121     paused = true;
122     Pause();
123   }
124   /**
125    * @dev called by the owner to unpause, returns to normal state
126    */
127   function unpause() onlyOwner whenPaused public {
128     paused = false;
129     Unpause();
130   }
131 }
132 
133 /**
134  * @title ERC20Basic
135  * @dev Simpler version of ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/20
137  */
138 contract ERC20Basic {
139   uint public totalSupply;
140   function balanceOf(address who) constant returns (uint);
141   function transfer(address to, uint value);
142   event Transfer(address indexed from, address indexed to, uint value);
143 }
144 
145 /**
146  * @title Basic token
147  * @dev Basic version of StandardToken, with no allowances.
148  */
149 contract BasicToken is ERC20Basic, Pausable {
150   using SafeMath for uint;
151 
152   mapping(address => uint) balances;
153 
154   /**
155    * @dev Fix for the ERC20 short address attack.
156    */
157   modifier onlyPayloadSize(uint size) {
158      assert(msg.data.length >= size + 4);      
159      _;
160   }
161 
162   /**
163   * @dev transfer token for a specified address
164   * @param _to The address to transfer to.
165   * @param _value The amount to be transferred.
166   */
167   function transfer(address _to, uint _value) whenNotPaused onlyPayloadSize(2 * 32) {
168     balances[msg.sender] = balances[msg.sender].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     Transfer(msg.sender, _to, _value);
171   }
172 
173   /**
174   * @dev Gets the balance of the specified address.
175   * @param _owner The address to query the the balance of.
176   * @return An uint representing the amount owned by the passed address.
177   */
178   function balanceOf(address _owner) constant returns (uint balance) {
179     return balances[_owner];
180   }
181 
182 }
183 
184 /**
185  * @title ERC20 interface
186  * @dev see https://github.com/ethereum/EIPs/issues/20
187  */
188 contract ERC20 is ERC20Basic {
189   function allowance(address owner, address spender) constant returns (uint);
190   function transferFrom(address from, address to, uint value);
191   function approve(address spender, uint value);
192   event Approval(address indexed owner, address indexed spender, uint value);
193 }
194 
195 
196 /**
197  * @title Standard ERC20 token
198  *
199  * @dev Implemantation of the basic standart token.
200  * @dev https://github.com/ethereum/EIPs/issues/20
201  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
202  */
203 contract StandardToken is BasicToken, ERC20 {
204 
205   mapping (address => mapping (address => uint)) allowed;
206 
207 
208   /**
209    * @dev Transfer tokens from one address to another
210    * @param _from address The address which you want to send tokens from
211    * @param _to address The address which you want to transfer to
212    * @param _value uint the amout of tokens to be transfered
213    */
214   function transferFrom(address _from, address _to, uint _value) whenNotPaused onlyPayloadSize(3 * 32) {
215     var _allowance = allowed[_from][msg.sender];
216 
217     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
218     // if (_value > _allowance) throw;
219 
220     balances[_to] = balances[_to].add(_value);
221     balances[_from] = balances[_from].sub(_value);
222     allowed[_from][msg.sender] = _allowance.sub(_value);
223     Transfer(_from, _to, _value);
224   }
225 
226   /**
227    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
228    * @param _spender The address which will spend the funds.
229    * @param _value The amount of tokens to be spent.
230    */
231   function approve(address _spender, uint _value) whenNotPaused {
232 
233     // To change the approve amount you first have to reduce the addresses`
234     //  allowance to zero by calling `approve(_spender, 0)` if it is not
235     //  already 0 to mitigate the race condition described here:
236     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
238 
239     allowed[msg.sender][_spender] = _value;
240     Approval(msg.sender, _spender, _value);
241   }
242 
243   /**
244    * @dev Function to check the amount of tokens than an owner allowed to a spender.
245    * @param _owner address The address which owns the funds.
246    * @param _spender address The address which will spend the funds.
247    * @return A uint specifing the amount of tokens still avaible for the spender.
248    */
249   function allowance(address _owner, address _spender) constant returns (uint remaining) {
250     return allowed[_owner][_spender];
251   }
252 
253 }
254 
255 /**
256  * @title Mintable token
257  * @dev Simple ERC20 Token example, with mintable token creation
258  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
259  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
260  */
261 
262 contract MintableToken is StandardToken {
263   using SafeMath for uint;
264 
265   event Mint(address indexed to, uint value);
266   event MintFinished();
267 
268   bool public mintingFinished = false;
269 
270 
271   modifier canMint() {
272     require(!mintingFinished);
273     _;
274   }
275 
276   /**
277    * @dev Function to mint tokens
278    * @param _to The address that will recieve the minted tokens.
279    * @param _amount The amount of tokens to mint.
280    * @return A boolean that indicates if the operation was successful.
281    */
282   function mint(address _to, uint _amount) whenNotPaused onlyOwner canMint returns (bool) {
283     totalSupply = totalSupply.add(_amount);
284     balances[_to] = balances[_to].add(_amount);
285     Mint(_to, _amount);
286     return true;
287   }
288 
289   /**
290    * @dev Function to stop minting new tokens.
291    * @return True if the operation was successful.
292    */
293   function finishMinting() whenNotPaused onlyOwner returns (bool) {
294     mintingFinished = true;
295     MintFinished();
296     return true;
297   }
298 }
299 
300 /**
301  * @title Burnable token
302  * @dev Simple ERC20 Token example, with token that can be burnt 
303  */
304 
305 contract BurnableToken is StandardToken {
306   using SafeMath for uint;
307 
308   event Burn(address indexed from, uint value);
309 
310   /**
311    * @dev Function to burn tokens
312    * @param _from The address from which the tokens will be burnt
313    * @param _amount The amount of tokens to burn.
314    * @return A boolean that indicates if the operation was successful.
315    */
316   function burn(address _from, uint _amount) whenNotPaused onlyOwner returns (bool) {    
317     totalSupply = totalSupply.sub(_amount);
318     balances[_from] = balances[_from].sub(_amount);
319     Burn(_from, _amount);
320     return true;
321   }  
322 }
323 
324 /**
325  * @title Deal Token
326  * @dev Deal Token contract
327  */
328 contract DealToken is MintableToken, BurnableToken {
329     using SafeMath for uint256;
330 
331     /*
332       Sets the name of the token
333     */
334     string public constant name = "Deal Token";
335 
336     /*
337       Sets the symbol of the token
338     */
339     string public constant symbol = "DEAL";
340 
341     uint8 public constant decimals = 8;
342 
343     function DealToken() public {
344     /**
345       * @dev Mint initial supply and assign those inital supply 
346       * @dev Send those tokens to the contract creator address
347     */
348     totalSupply = 40000000000000000; //400M
349     balances[msg.sender] = totalSupply;
350   }
351 
352 }