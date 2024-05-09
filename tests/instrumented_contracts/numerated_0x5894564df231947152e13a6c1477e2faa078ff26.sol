1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title Math
37  * @dev Assorted math operations
38  */
39 
40 library Math {
41   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
42     return a >= b ? a : b;
43   }
44 
45   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
46     return a < b ? a : b;
47   }
48 
49   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
50     return a >= b ? a : b;
51   }
52 
53   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
54     return a < b ? a : b;
55   }
56 }
57 
58 
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65 
66   address public owner;
67 
68   /**
69    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70    * account.
71    */
72   function Ownable() internal {
73     owner = msg.sender;
74   }
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 }
84 
85 
86 /**
87  * @title Pausable
88  * @dev Base contract which allows children to implement an emergency stop mechanism.
89  */
90 contract Pausable is Ownable {
91 
92   event Pause();
93   event Unpause();
94 
95   bool public paused = false;
96 
97   /**
98    * @dev modifier to allow actions only when the contract IS paused
99    */
100   modifier whenNotPaused() {
101     require(!paused);
102     _;
103   }
104 
105   /**
106    * @dev modifier to allow actions only when the contract IS NOT paused
107    */
108   modifier whenPaused() {
109     require(paused);
110     _;
111   }
112 
113   /**
114    * @dev called by the owner to pause, triggers stopped state
115    */
116   function pause() external onlyOwner whenNotPaused {
117     paused = true;
118     Pause();
119   }
120 
121   /**
122    * @dev called by the owner to unpause, returns to normal state
123    */
124   function unpause() external onlyOwner whenPaused {
125     paused = false;
126     Unpause();
127   }
128 }
129 
130 
131 /**
132  * @title ERC20Basic
133  * @dev Simpler version of ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/179
135  */
136 contract ERC20Basic {
137   uint256 public totalSupply;
138   function balanceOf(address who) public constant returns (uint256);
139   function transfer(address to, uint256 value) public returns (bool);
140   event Transfer(address indexed from, address indexed to, uint256 value);
141 }
142 
143 
144 /**
145  * @title ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/20
147  */
148 contract ERC20 is ERC20Basic {
149   function allowance(address owner, address spender) public constant returns (uint256);
150   function transferFrom(address from, address to, uint256 value) public returns (bool);
151   function approve(address spender, uint256 value) public returns (bool);
152   event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 
156 /**
157  * @title Basic token
158  * @dev Basic version of StandardToken, with no allowances.
159  */
160 contract BasicToken is ERC20Basic {
161 
162   using SafeMath for uint256;
163 
164   mapping(address => uint256) internal balances;
165 
166   /**
167   * @dev transfer token for a specified address
168   * @param _to The address to transfer to.
169   * @param _value The amount to be transferred.
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
183   * @dev Gets the balance of the specified address.
184   * @param _owner The address to query the the balance of.
185   * @return An uint256 representing the amount owned by the passed address.
186   */
187   function balanceOf(address _owner) public constant returns (uint256 balance) {
188     return balances[_owner];
189   }
190 }
191 
192 
193 /**
194  * @title Standard ERC20 token
195  *
196  * @dev Implementation of the basic standard token.
197  * @dev https://github.com/ethereum/EIPs/issues/20
198  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
199  */
200 contract StandardToken is ERC20, BasicToken {
201 
202   mapping (address => mapping (address => uint256)) internal allowed;
203 
204   /**
205    * @dev Transfer tokens from one address to another
206    * @param _from address The address which you want to send tokens from
207    * @param _to address The address which you want to transfer to
208    * @param _value uint256 the amount of tokens to be transferred
209    */
210   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
211     require(_to != address(0));
212     require(_value <= balances[_from]);
213     require(_value <= allowed[_from][msg.sender]);
214 
215     balances[_from] = balances[_from].sub(_value);
216     balances[_to] = balances[_to].add(_value);
217     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
218     Transfer(_from, _to, _value);
219     return true;
220   }
221 
222   /**
223    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
224    *
225    * Beware that changing an allowance with this method brings the risk that someone may use both the old
226    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
227    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
228    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229    * @param _spender The address which will spend the funds.
230    * @param _value The amount of tokens to be spent.
231    */
232   function approve(address _spender, uint256 _value) public returns (bool) {
233     allowed[msg.sender][_spender] = _value;
234     Approval(msg.sender, _spender, _value);
235     return true;
236   }
237 
238   /**
239    * @dev Function to check the amount of tokens that an owner allowed to a spender.
240    * @param _owner address The address which owns the funds.
241    * @param _spender address The address which will spend the funds.
242    * @return A uint256 specifying the amount of tokens still available for the spender.
243    */
244   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
245     return allowed[_owner][_spender];
246   }
247 }
248 
249 
250 /**
251  * @title Pausable token
252  *
253  * @dev StandardToken modified with pausable transfers.
254  **/
255 
256 contract PausableToken is StandardToken, Pausable {
257 
258   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
259     return super.transfer(_to, _value);
260   }
261 
262   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
263     return super.transferFrom(_from, _to, _value);
264   }
265 
266   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
267     return super.approve(_spender, _value);
268   }
269 }
270 
271 
272 /**
273  * Alvalor token
274  *
275  * The Alvalor Token is a simple ERC20 token with an initial supply equivalent to the maximum value
276  * of an unsigned 64-bit integer, credited to the creator which represents the Alvalor foundation.
277  *
278  * It is pausible so that transfers can be frozen when we create the snapshot of balances, which
279  * will be used to transfer balances to the Alvalor genesis block.
280  **/
281 
282 contract AlvalorToken is PausableToken {
283 
284   using SafeMath for uint256;
285 
286   // the details of the token for wallets
287   string public constant name = "Alvalor";
288   string public constant symbol = "TVAL";
289   uint8 public constant decimals = 12;
290 
291   // when frozen, the supply of the token cannot change anymore
292   bool public frozen = false;
293 
294   // defines the maximum total supply and the maximum number of tokens
295   // claimable through the airdrop mechanism
296   uint256 public constant maxSupply = 18446744073709551615;
297   uint256 public constant dropSupply = 3689348814741910323;
298 
299   // keeps track of the total supply already claimed through the airdrop
300   uint256 public claimedSupply = 0;
301 
302   // keeps track of how much each address can claim in the airdrop
303   mapping(address => uint256) private claims;
304 
305   // events emmitted by the contract
306   event Freeze();
307   event Drop(address indexed receiver, uint256 value);
308   event Mint(address indexed receiver, uint256 value);
309   event Claim(address indexed receiver, uint256 value);
310   event Burn(address indexed receiver, uint256 value);
311 
312   // the not frozen modifier guards functions modifying the supply of the token
313   // from being called after the token supply has been frozen
314   modifier whenNotFrozen() {
315     require(!frozen);
316     _;
317   }
318 
319   modifier whenFrozen() {
320     require(frozen);
321     _;
322   }
323 
324   // AlvalorToken will make sure the owner can claim any unclaimed drop at any
325   // point.
326   function AlvalorToken() public {
327     claims[owner] = dropSupply;
328   }
329 
330   // freeze will irrevocably stop all modifications to the supply of the token,
331   // effectively freezing the supply of the token (transfers are still possible)
332   function freeze() external onlyOwner whenNotFrozen {
333     frozen = true;
334     Freeze();
335   }
336 
337   // mint can be called by the owner to create tokens for a certain receiver
338   // it will no longer work once the token supply has been frozen
339   function mint(address _receiver, uint256 _value) onlyOwner whenNotFrozen public returns (bool) {
340     require(_value > 0);
341     require(_value <= maxSupply.sub(totalSupply).sub(dropSupply));
342     totalSupply = totalSupply.add(_value);
343     balances[_receiver] = balances[_receiver].add(_value);
344     Mint(_receiver, _value);
345     return true;
346   }
347 
348   function claimable(address _receiver) constant public returns (uint256) {
349     if (claimedSupply >= dropSupply) {
350       return 0;
351     }
352     return claims[_receiver];
353   }
354 
355   // drop will create a new allowance for claimable tokens of the airdrop
356   // it will no longer work once the token supply has been frozen
357   function drop(address _receiver, uint256 _value) onlyOwner whenNotFrozen public returns (bool) {
358     require(claimedSupply < dropSupply);
359     require(_receiver != owner);
360     claims[_receiver] = _value;
361     Drop(_receiver, _value);
362     return true;
363   }
364 
365   // claim will allow any sender to retrieve the airdrop tokens assigned to him
366   // it will only work until the maximum number of airdrop tokens are redeemed
367   function claim() whenNotPaused whenFrozen public returns (bool) {
368     require(claimedSupply < dropSupply);
369     uint value = Math.min256(claims[msg.sender], dropSupply.sub(claimedSupply));
370     claims[msg.sender] = claims[msg.sender].sub(value);
371     claimedSupply = claimedSupply.add(value);
372     totalSupply = totalSupply.add(value);
373     balances[msg.sender] = balances[msg.sender].add(value);
374     Claim(msg.sender, value);
375     return true;
376   }
377 }