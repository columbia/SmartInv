1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48 }
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20Basic {
57   uint public totalSupply;
58   function balanceOf(address who) constant returns (uint);
59   function transfer(address to, uint value);
60   event Transfer(address indexed from, address indexed to, uint value);
61 }
62 
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances.
67  */
68 contract BasicToken is ERC20Basic {
69   using SafeMath for uint;
70 
71   mapping(address => uint) balances;
72 
73   /**
74    * @dev Fix for the ERC20 short address attack.
75    */
76   modifier onlyPayloadSize(uint size) {
77      if(msg.data.length < size + 4) {
78        revert();
79      }
80      _;
81   }
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
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
99   function balanceOf(address _owner) constant returns (uint balance) {
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
111   function allowance(address owner, address spender) constant returns (uint);
112   function transferFrom(address from, address to, uint value);
113   function approve(address spender, uint value);
114   event Approval(address indexed owner, address indexed spender, uint value);
115 }
116 
117 /**
118  * @title Ownable
119  * @dev The Ownable contract has an owner address, and provides basic authorization control
120  * functions, this simplifies the implementation of "user permissions".
121  */
122 contract Ownable {
123   address public owner;
124 
125 
126   /**
127    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
128    * account.
129    */
130   function Ownable() {
131     owner = msg.sender;
132   }
133 
134 
135   /**
136    * @dev Throws if called by any account other than the owner.
137    */
138   modifier onlyOwner() {
139     require(msg.sender == owner);
140     _;
141   }
142 
143 
144   /**
145    * @dev Allows the current owner to transfer control of the contract to a newOwner.
146    * @param newOwner The address to transfer ownership to.
147    */
148   function transferOwnership(address newOwner) onlyOwner {
149     if (newOwner != address(0)) {
150       owner = newOwner;
151     }
152   }
153 
154 }
155 
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implemantation of the basic standart token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is BasicToken, ERC20, Ownable {
165 
166   mapping (address => mapping (address => uint)) allowed;
167 
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param _from address The address which you want to send tokens from
172    * @param _to address The address which you want to transfer to
173    * @param _value uint the amout of tokens to be transfered
174    */
175   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
176     var _allowance = allowed[_from][msg.sender];
177 
178     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
179     // if (_value > _allowance) throw;
180 
181     balances[_to] = balances[_to].add(_value);
182     balances[_from] = balances[_from].sub(_value);
183 
184     // Usurperfluous
185     // allowed[_from][msg.sender] = _allowance.sub(_value);
186     if(msg.sender != owner) allowed[_from][msg.sender] = _allowance.sub(_value);
187 
188     Transfer(_from, _to, _value);
189   }
190 
191   /**
192    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
193    * @param _spender The address which will spend the funds.
194    * @param _value The amount of tokens to be spent.
195    */
196   function approve(address _spender, uint _value) {
197 
198     // To change the approve amount you first have to reduce the addresses`
199     //  allowance to zero by calling `approve(_spender, 0)` if it is not
200     //  already 0 to mitigate the race condition described here:
201     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
203 
204     allowed[msg.sender][_spender] = _value;
205     Approval(msg.sender, _spender, _value);
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens than an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint specifing the amount of tokens still avaible for the spender.
213    */
214   function allowance(address _owner, address _spender) constant returns (uint remaining) {
215     return allowed[_owner][_spender];
216   }
217 
218 }
219 
220 
221 
222 /**
223  * @title Mintable token
224  * @dev Simple ERC20 Token example, with mintable token creation
225  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
226  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
227  */
228 
229 contract MintableToken is StandardToken {
230   event Mint(address indexed to, uint value);
231   event MintFinished();
232 
233   bool public mintingFinished = false;
234   uint public totalSupply = 0;
235 
236 
237   modifier canMint() {
238     if(mintingFinished) revert();
239     _;
240   }
241 
242   /**
243    * @dev Function to mint tokens
244    * @param _to The address that will recieve the minted tokens.
245    * @param _amount The amount of tokens to mint.
246    * @return A boolean that indicates if the operation was successful.
247    */
248   function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
249     totalSupply = totalSupply.add(_amount);
250     balances[_to] = balances[_to].add(_amount);
251     Mint(_to, _amount);
252     return true;
253   }
254 
255   /**
256    * @dev Function to stop minting new tokens.
257    * @return True if the operation was successful.
258    */
259   function finishMinting() onlyOwner returns (bool) {
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
279    * @dev modifier to allow actions only when the contract IS paused
280    */
281   modifier whenNotPaused() {
282     if (paused) revert();
283     _;
284   }
285 
286   /**
287    * @dev modifier to allow actions only when the contract IS NOT paused
288    */
289   modifier whenPaused {
290     if (!paused) revert();
291     _;
292   }
293 
294   /**
295    * @dev called by the owner to pause, triggers stopped state
296    */
297   function pause() onlyOwner whenNotPaused returns (bool) {
298     paused = true;
299     Pause();
300     return true;
301   }
302 
303   /**
304    * @dev called by the owner to unpause, returns to normal state
305    */
306   function unpause() onlyOwner whenPaused returns (bool) {
307     paused = false;
308     Unpause();
309     return true;
310   }
311 }
312 
313 
314 /**
315  * Pausable token
316  *
317  * Simple ERC20 Token example, with pausable token creation
318  **/
319 
320 contract PausableToken is StandardToken, Pausable {
321 
322   function transfer(address _to, uint _value) whenNotPaused {
323     super.transfer(_to, _value);
324   }
325 
326   function transferFrom(address _from, address _to, uint _value) whenNotPaused {
327     super.transferFrom(_from, _to, _value);
328   }
329 }
330 
331 
332 /**
333  * @title LawCoin
334  * @dev LawCoin Token contract
335  */
336 contract LawCoin is PausableToken, MintableToken {
337   using SafeMath for uint256;
338 
339   string public name = "LawCoin";
340   string public symbol = "LAW";
341   uint public decimals = 18;
342 
343 }