1 pragma solidity ^0.4.18;
2 
3 /**
4  * @contract Deal Token (DEAL)
5  * This has all the functions and events of a standard ERC20 Token as decribed here
6  * https://theethereum.wiki/w/index.php/ERC20_Token_Standard
7  */
8 
9 /**
10  * Math operations with safety checks
11  */
12 library SafeMath {
13   function mul(uint a, uint b) pure internal returns (uint) {
14     uint c = a * b;
15     assert(a == 0 || c / a == b);
16     return c;
17   }
18 
19   function div(uint a, uint b) pure internal returns (uint) {    
20     uint c = a / b;    
21     return c;
22   }
23 
24   function sub(uint a, uint b) pure internal returns (uint) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint a, uint b) pure internal returns (uint) {
30     uint c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 
35   function max64(uint64 a, uint64 b) pure internal returns (uint64) {
36     return a >= b ? a : b;
37   }
38 
39   function min64(uint64 a, uint64 b) pure internal returns (uint64) {
40     return a < b ? a : b;
41   }
42 
43   function max256(uint256 a, uint256 b) pure internal returns (uint256) {
44     return a >= b ? a : b;
45   }
46 
47   function min256(uint256 a, uint256 b) pure internal returns (uint256) {
48     return a < b ? a : b;
49   }  
50 }
51 
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/20
57  */
58 contract ERC20Basic {
59   uint public totalSupply;
60   function balanceOf(address who) public constant returns (uint);
61   function transfer(address to, uint value) public;
62   event Transfer(address indexed from, address indexed to, uint value);
63 }
64 
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint;
72 
73   mapping(address => uint) public balances;
74 
75   /**
76    * @dev Fix for the ERC20 short address attack.
77    */
78   modifier onlyPayloadSize(uint size) {
79      assert(msg.data.length >= size + 4);
80      _;
81   }
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92   }
93 
94   /**
95   * @dev Gets the balance of the specified address.
96   * @param _owner The address to query the the balance of.
97   * @return An uint representing the amount owned by the passed address.
98   */
99   function balanceOf(address _owner) public constant returns (uint balance) {
100     return balances[_owner];
101   }
102 
103 }
104 
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public constant returns (uint);
112   function transferFrom(address from, address to, uint value) public;
113   function approve(address spender, uint value) public;
114   event Approval(address indexed owner, address indexed spender, uint value);
115 }
116 
117 
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implemantation of the basic standart token.
122  * @dev https://github.com/ethereum/EIPs/issues/20
123  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract StandardToken is BasicToken, ERC20 {
126 
127   mapping (address => mapping (address => uint)) allowed;
128 
129 
130   /**
131    * @dev Transfer tokens from one address to another
132    * @param _from address The address which you want to send tokens from
133    * @param _to address The address which you want to transfer to
134    * @param _value uint the amout of tokens to be transfered
135    */
136   function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
137     var _allowance = allowed[_from][msg.sender];
138 
139     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
140     // if (_value > _allowance) throw;
141 
142     balances[_to] = balances[_to].add(_value);
143     balances[_from] = balances[_from].sub(_value);
144     allowed[_from][msg.sender] = _allowance.sub(_value);
145     Transfer(_from, _to, _value);
146   }
147 
148   /**
149    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint _value) public {
154 
155     // To change the approve amount you first have to reduce the addresses`
156     //  allowance to zero by calling `approve(_spender, 0)` if it is not
157     //  already 0 to mitigate the race condition described here:
158     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
160 
161     allowed[msg.sender][_spender] = _value;
162     Approval(msg.sender, _spender, _value);
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens than an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint specifing the amount of tokens still avaible for the spender.
170    */
171   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
172     return allowed[_owner][_spender];
173   }
174 
175 }
176 
177 
178 /**
179  * @title Ownable
180  * @dev The Ownable contract has an owner address, and provides basic authorization control
181  * functions, this simplifies the implementation of "user permissions".
182  */
183 contract Ownable {
184   address public owner;
185 
186 
187   /**
188    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
189    * account.
190    */
191   function Ownable() public {
192     owner = msg.sender;
193   }
194 
195 
196   /**
197    * @dev Throws if called by any account other than the owner.
198    */
199   modifier onlyOwner() {
200     require (msg.sender == owner);
201     _;
202   }
203 
204 
205   /**
206    * @dev Allows the current owner to transfer control of the contract to a newOwner.
207    * @param newOwner The address to transfer ownership to.
208    */
209   function transferOwnership(address newOwner) public onlyOwner {
210     if (newOwner != address(0)) {
211       owner = newOwner;
212     }
213   }
214 
215 }
216 
217 /**
218  * @title Pausable
219  * @dev Base contract which allows children to implement an emergency stop mechanism.
220  */
221 contract Pausable is Ownable {
222   event Pause();
223   event Unpause();
224 
225   bool public paused = false;
226 
227 
228   /**
229    * @dev modifier to allow actions only when the contract IS paused
230    */
231   modifier whenNotPaused() {
232     require(!paused);
233     _;
234   }
235 
236   /**
237    * @dev modifier to allow actions only when the contract IS NOT paused
238    */
239   modifier whenPaused {
240     require(paused);
241     _;
242   }
243 
244   /**
245    * @dev called by the owner to pause, triggers stopped state
246    */
247   function pause() public onlyOwner whenNotPaused returns (bool) {
248     paused = true;
249     Pause();
250     return true;
251   }
252 
253   /**
254    * @dev called by the owner to unpause, returns to normal state
255    */
256   function unpause() public onlyOwner whenPaused returns (bool) {
257     paused = false;
258     Unpause();
259     return true;
260   }
261 }
262 
263 
264 /**
265  * Pausable token
266  *
267  * Simple ERC20 Token example, with pausable token creation
268  **/
269 
270 contract PausableToken is StandardToken, Pausable {
271 
272   function transfer(address _to, uint _value) public whenNotPaused {
273     super.transfer(_to, _value);
274   }
275 
276   function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
277     super.transferFrom(_from, _to, _value);
278   }
279 }
280 
281 /**
282  * @title Mintable token
283  * @dev Simple ERC20 Token example, with mintable token creation
284  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
285  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
286  */
287 
288 contract MintableToken is StandardToken, PausableToken {
289   event Mint(address indexed to, uint value);
290   event MintFinished();
291 
292   bool public mintingFinished = false;
293 
294   modifier canMint() {
295     require(!mintingFinished);
296     _;
297   }
298 
299   /**
300    * @dev Function to mint tokens
301    * @param _to The address that will recieve the minted tokens.
302    * @param _amount The amount of tokens to mint.
303    * @return A boolean that indicates if the operation was successful.
304    */
305   function mint(address _to, uint _amount) public onlyOwner canMint returns (bool) {
306     totalSupply = totalSupply.add(_amount);
307     balances[_to] = balances[_to].add(_amount);
308     Mint(_to, _amount);
309     return true;
310   }
311 
312   /**
313    * @dev Function to stop minting new tokens.
314    * @return True if the operation was successful.
315    */
316   function finishMinting() public onlyOwner returns (bool) {
317     mintingFinished = true;
318     MintFinished();
319     return true;
320   }
321 }
322 
323 /**
324  * @title Burnable token
325  * @dev Simple ERC20 Token example, with token that can be burnt 
326  */
327 
328 contract BurnableToken is StandardToken, PausableToken {
329   using SafeMath for uint;
330 
331   event Burn(address indexed from, uint value);
332 
333   /**
334    * @dev Function to burn tokens
335    * @param _from The address from which the tokens will be burnt
336    * @param _amount The amount of tokens to burn.
337    * @return A boolean that indicates if the operation was successful.
338    */
339   function burn(address _from, uint _amount) public onlyOwner returns (bool) {
340     totalSupply = totalSupply.sub(_amount);
341     balances[_from] = balances[_from].sub(_amount);
342     Burn(_from, _amount);
343     return true;
344   }  
345 }
346 
347 /**
348  * @title Deal Token
349  * @dev Deal Token contract
350  */
351 contract DealToken is MintableToken, BurnableToken {
352     using SafeMath for uint256;
353 
354     /*
355       Sets the name of the token
356     */
357     string public constant name = "Deal Token";
358 
359     /*
360       Sets the symbol of the token
361     */
362     string public constant symbol = "DEAL";
363 
364     uint8 public constant decimals = 8;
365     uint public constant initialSupply = 30000000000000000; //300M
366 
367     function DealToken() public {
368       totalSupply = initialSupply;
369       balances[msg.sender] = totalSupply;
370     }
371 
372 }