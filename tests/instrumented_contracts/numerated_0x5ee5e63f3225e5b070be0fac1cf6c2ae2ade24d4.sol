1 /**
2  * Source Code first verified at https://etherscan.io on Thursday, August 16, 2018
3  (UTC) */
4 
5 pragma solidity ^0.4.24;
6 
7 
8 /**
9 *
10 */
11 
12 /**
13  * Math operations with safety checks
14  */
15 library SafeMath {
16 function mul(uint256 a, uint256 b) internal constant returns (uint256) {
17     uint256 c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal constant returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function add(uint256 a, uint256 b) internal constant returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 
40   function assert(bool assertion) internal {
41     if (!assertion) {
42       throw;
43     }
44   }
45 }
46 
47 
48 /**
49  * @title ERC20Basic
50  * @dev Simpler version of ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20Basic {
54   uint256 public totalSupply;
55   function balanceOf(address who) constant returns (uint256);
56   function transfer(address to, uint256 value);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   /**
71    * @dev Fix for the ERC20 short address attack.
72    */
73   modifier onlyPayloadSize(uint size) {
74      if(msg.data.length < size + 4) {
75        throw;
76      }
77      _;
78   }
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) {
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     Transfer(msg.sender, _to, _value);
89   }
90 
91   /**
92   * @dev Gets the balance of the specified address.
93   * @param _owner The address to query the the balance of.
94   * @return An uint representing the amount owned by the passed address.
95   */
96   function balanceOf(address _owner) constant returns (uint256 balance) {
97     return balances[_owner];
98   }
99 
100 }
101 
102 
103 /**
104  * @title ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20 is ERC20Basic {
108   function allowance(address owner, address spender) constant returns (uint256);
109   function transferFrom(address from, address to, uint256 value);
110   function approve(address spender, uint256 value);
111   event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 
115 /**
116  * @title Standard ERC20 token
117  *
118  * @dev Implemantation of the basic standart token.
119  * @dev https://github.com/ethereum/EIPs/issues/20
120  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
121  */
122 contract StandardToken is BasicToken, ERC20 {
123 
124   mapping (address => mapping (address => uint256)) allowed;
125 
126 
127   /**
128    * @dev Transfer tokens from one address to another
129    * @param _from address The address which you want to send tokens from
130    * @param _to address The address which you want to transfer to
131    * @param _value uint the amout of tokens to be transfered
132    */
133   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) {
134     var _allowance = allowed[_from][msg.sender];
135 
136     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
137     // if (_value > _allowance) throw;
138 
139     balances[_to] = balances[_to].add(_value);
140     balances[_from] = balances[_from].sub(_value);
141     allowed[_from][msg.sender] = _allowance.sub(_value);
142     Transfer(_from, _to, _value);
143   }
144 
145   /**
146    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
147    * @param _spender The address which will spend the funds.
148    * @param _value The amount of tokens to be spent.
149    */
150   function approve(address _spender, uint256 _value) {
151 
152     // To change the approve amount you first have to reduce the addresses`
153     //  allowance to zero by calling `approve(_spender, 0)` if it is not
154     //  already 0 to mitigate the race condition described here:
155     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
157 
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160   }
161 
162   /**
163    * @dev Function to check the amount of tokens than an owner allowed to a spender.
164    * @param _owner address The address which owns the funds.
165    * @param _spender address The address which will spend the funds.
166    * @return A uint specifing the amount of tokens still avaible for the spender.
167    */
168   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
169     return allowed[_owner][_spender];
170   }
171 
172 }
173 
174 
175 /**
176  * @title Ownable
177  * @dev The Ownable contract has an owner address, and provides basic authorization control
178  * functions, this simplifies the implementation of "user permissions".
179  */
180 contract Ownable {
181   address public owner;
182 
183 
184   /**
185    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
186    * account.
187    */
188   function Ownable() {
189     owner = msg.sender;
190   }
191 
192 
193   /**
194    * @dev Throws if called by any account other than the owner.
195    */
196   modifier onlyOwner() {
197     if (msg.sender != owner) {
198       throw;
199     }
200     _;
201   }
202 
203 
204   /**
205    * @dev Allows the current owner to transfer control of the contract to a newOwner.
206    * @param newOwner The address to transfer ownership to.
207    */
208   function transferOwnership(address newOwner) onlyOwner {
209     if (newOwner != address(0)) {
210       owner = newOwner;
211     }
212   }
213 
214 }
215 
216 
217 /**
218  * @title Mintable token
219  * @dev Simple ERC20 Token example, with mintable token creation
220  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
221  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
222  */
223 
224 contract MintableToken is StandardToken, Ownable {
225   event Mint(address indexed to, uint256 value);
226   event MintFinished();
227 
228   bool public mintingFinished = false;
229   uint256 public totalSupply = 0;
230 
231 
232   modifier canMint() {
233     if(mintingFinished) throw;
234     _;
235   }
236 
237   /**
238    * @dev Function to mint tokens
239    * @param _to The address that will recieve the minted tokens.
240    * @param _amount The amount of tokens to mint.
241    * @return A boolean that indicates if the operation was successful.
242    */
243   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
244     totalSupply = totalSupply.add(_amount);
245     balances[_to] = balances[_to].add(_amount);
246     Mint(_to, _amount);
247     return true;
248   }
249 
250   /**
251    * @dev Function to stop minting new tokens.
252    * @return True if the operation was successful.
253    */
254   function finishMinting() onlyOwner returns (bool) {
255     mintingFinished = true;
256     MintFinished();
257     return true;
258   }
259 }
260 
261 contract TimeLockToken is Ownable, MintableToken{
262   using SafeMath for uint256;
263   struct LockedBalance {  
264     uint256 releaseTime; 
265     uint256 amount;
266   }
267 
268   event MintLock(address indexed to, uint256 releaseTime, uint256 value);
269   mapping(address => LockedBalance) lockedBalances;
270   /**
271    * @dev mint timelocked tokens
272    */
273   function mintTimelocked(address _to, uint256 _releaseTime, uint256 _amount)
274     onlyOwner canMint returns (bool){
275     require(_releaseTime > now);
276     require(_amount > 0);
277     LockedBalance exist = lockedBalances[_to];
278     require(exist.amount == 0);
279     LockedBalance memory balance = LockedBalance(_releaseTime,_amount);
280     totalSupply = totalSupply.add(_amount);
281     lockedBalances[_to] = balance;
282     MintLock(_to, _releaseTime, _amount);
283     return true;
284   }
285 
286   /**
287    * @dev beneficiary claims tokens held by time lock
288    */
289   function claim() {
290     LockedBalance balance = lockedBalances[msg.sender];
291     require(balance.amount > 0);
292     require(now >= balance.releaseTime);
293     uint256 amount = balance.amount;
294     delete lockedBalances[msg.sender];
295     balances[msg.sender] = balances[msg.sender].add(amount);
296     Transfer(0, msg.sender, amount);
297   }
298 
299   /**
300   * @dev Gets the locked balance of the specified address.
301   * @param _owner The address to query the the locked balance of.
302   * @return An uint representing the amount owned by the passed address.
303   */
304   function lockedBalanceOf(address _owner) constant returns (uint256 lockedAmount) {
305     return lockedBalances[_owner].amount;
306   }
307 
308   /**
309   * @dev Gets the releaseTime of the specified address.
310   * @param _owner The address to query the the releaseTime of.
311   * @return An uint representing the amount owned by the passed address.
312   */
313   function releaseTimeOf(address _owner) constant returns (uint256 releaseTime) {
314     return lockedBalances[_owner].releaseTime;
315   }
316   
317 }
318 
319 
320 /**
321  * @title PRECT Token
322  */
323 contract PRECToken is TimeLockToken {
324   using SafeMath for uint256;
325   event Freeze(address indexed to, uint256 value);
326   event Unfreeze(address indexed to, uint256 value);
327   event Burn(address indexed to, uint256 value);
328   mapping (address => uint256) public freezeOf;
329   string public name = "PreCT token";
330   string public symbol = "PRECT";
331   uint public decimals = 8;
332 
333 
334   function burn(address _to,uint256 _value) onlyOwner returns (bool success) {
335     require(_value >= 0);
336     require(balances[_to] >= _value);
337     
338     balances[_to] = balances[_to].sub(_value);                      // Subtract from the sender
339     totalSupply = totalSupply.sub(_value);                                // Updates totalSupply
340     Burn(_to, _value);
341     return true;
342   }
343   
344   function freeze(address _to,uint256 _value) onlyOwner returns (bool success) {
345     require(_value >= 0);
346     require(balances[_to] >= _value);
347     balances[_to] = balances[_to].sub(_value);                      // Subtract from the sender
348     freezeOf[_to] = freezeOf[_to].add(_value);                                // Updates totalSupply
349     Freeze(_to, _value);
350     return true;
351   }
352   
353   function unfreeze(address _to,uint256 _value) onlyOwner returns (bool success) {
354     require(_value >= 0);
355     require(freezeOf[_to] >= _value);
356     freezeOf[_to] = freezeOf[_to].sub(_value);                      // Subtract from the sender
357     balances[_to] = balances[_to].add(_value);
358     Unfreeze(_to, _value);
359     return true;
360   }
361 
362 }