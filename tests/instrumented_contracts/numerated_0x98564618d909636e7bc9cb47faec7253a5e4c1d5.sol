1 pragma solidity ^0.4.17;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public constant returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 
49 
50 /**
51  * @title ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/20
53  */
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public constant returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 /**
63  * @title Ownable
64  * @dev The Ownable contract has an owner address, and provides basic authorization control
65  * functions, this simplifies the implementation of "user permissions".
66  */
67 contract Ownable {
68   address public owner;
69 
70 
71   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73 
74   /**
75    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76    * account.
77    */
78   function Ownable() {
79     owner = msg.sender;
80   }
81 
82 
83   /**
84    * @dev Throws if called by any account other than the owner.
85    */
86   modifier onlyOwner() {
87     require(msg.sender == owner);
88     _;
89   }
90 
91 
92   /**
93    * @dev Allows the current owner to transfer control of the contract to a newOwner.
94    * @param newOwner The address to transfer ownership to.
95    */
96   function transferOwnership(address newOwner) onlyOwner public {
97     require(newOwner != address(0));
98     OwnershipTransferred(owner, newOwner);
99     owner = newOwner;
100   }
101 
102 }
103 
104 
105 /**
106  * @title Pausable
107  * @dev Base contract which allows children to implement an emergency stop mechanism.
108  */
109 contract Pausable is Ownable {
110   event Pause();
111   event Unpause();
112 
113   bool public paused = false;
114 
115 
116   /**
117    * @dev Modifier to make a function callable only when the contract is not paused.
118    */
119   modifier whenNotPaused() {
120     require(!paused);
121     _;
122   }
123 
124   /**
125    * @dev Modifier to make a function callable only when the contract is paused.
126    */
127   modifier whenPaused() {
128     require(paused);
129     _;
130   }
131 
132   /**
133    * @dev called by the owner to pause, triggers stopped state
134    */
135   function pause() onlyOwner whenNotPaused public {
136     paused = true;
137     Pause();
138   }
139 
140   /**
141    * @dev called by the owner to unpause, returns to normal state
142    */
143   function unpause() onlyOwner whenPaused public {
144     paused = false;
145     Unpause();
146   }
147 }
148 
149 
150 
151 /**
152  * @title Basic token
153  * @dev Basic version of StandardToken, with no allowances.
154  */
155 contract BasicToken is ERC20Basic {
156   using SafeMath for uint256;
157 
158   mapping(address => uint256) balances;
159 
160   /**
161   * @dev transfer token for a specified address
162   * @param _to The address to transfer to.
163   * @param _value The amount to be transferred.
164   */
165   function transfer(address _to, uint256 _value) public returns (bool) {
166     require(_to != address(0));
167     require(_value <= balances[msg.sender]);
168 
169     // SafeMath.sub will throw if there is not enough balance.
170     balances[msg.sender] = balances[msg.sender].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     Transfer(msg.sender, _to, _value);
173     return true;
174   }
175 
176   /**
177   * @dev Gets the balance of the specified address.
178   * @param _owner The address to query the the balance of.
179   * @return An uint256 representing the amount owned by the passed address.
180   */
181   function balanceOf(address _owner) public constant returns (uint256 balance) {
182     return balances[_owner];
183   }
184 
185 }
186 
187 
188 /**
189  * @title Standard ERC20 token
190  *
191  * @dev Implementation of the basic standard token.
192  * @dev https://github.com/ethereum/EIPs/issues/20
193  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
194  */
195 contract StandardToken is ERC20, BasicToken {
196 
197   mapping (address => mapping (address => uint256)) internal allowed;
198 
199 
200   /**
201    * @dev Transfer tokens from one address to another
202    * @param _from address The address which you want to send tokens from
203    * @param _to address The address which you want to transfer to
204    * @param _value uint256 the amount of tokens to be transferred
205    */
206   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
207     require(_to != address(0));
208     require(_value <= balances[_from]);
209     require(_value <= allowed[_from][msg.sender]);
210 
211     balances[_from] = balances[_from].sub(_value);
212     balances[_to] = balances[_to].add(_value);
213     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
214     Transfer(_from, _to, _value);
215     return true;
216   }
217 
218   /**
219    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
220    *
221    * Beware that changing an allowance with this method brings the risk that someone may use both the old
222    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
223    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
224    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225    * @param _spender The address which will spend the funds.
226    * @param _value The amount of tokens to be spent.
227    */
228   function approve(address _spender, uint256 _value) public returns (bool) {
229     allowed[msg.sender][_spender] = _value;
230     Approval(msg.sender, _spender, _value);
231     return true;
232   }
233 
234   /**
235    * @dev Function to check the amount of tokens that an owner allowed to a spender.
236    * @param _owner address The address which owns the funds.
237    * @param _spender address The address which will spend the funds.
238    * @return A uint256 specifying the amount of tokens still available for the spender.
239    */
240   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
241     return allowed[_owner][_spender];
242   }
243 
244   /**
245    * approve should be called when allowed[_spender] == 0. To increment
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    */
250   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
251     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
252     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
257     uint oldValue = allowed[msg.sender][_spender];
258     if (_subtractedValue > oldValue) {
259       allowed[msg.sender][_spender] = 0;
260     } else {
261       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
262     }
263     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 
267 }
268 
269 
270 /**
271  * @title Pausable token
272  *
273  * @dev StandardToken modified with pausable transfers.
274  **/
275 
276 contract PausableToken is StandardToken, Pausable {
277 
278   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
279     return super.transfer(_to, _value);
280   }
281 
282   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
283     return super.transferFrom(_from, _to, _value);
284   }
285 
286   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
287     return super.approve(_spender, _value);
288   }
289 
290   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
291     return super.increaseApproval(_spender, _addedValue);
292   }
293 
294   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
295     return super.decreaseApproval(_spender, _subtractedValue);
296   }
297 }
298 
299 contract MetaToken is PausableToken {
300 
301     string public name = 'MetaMetaMeta! Token';
302     uint8 public decimals = 8;
303     string public symbol = 'M3T';
304     string public version = '0.4.0';
305 
306     uint256 public blockReward = 1 * (10**uint256(decimals));
307     uint32 public halvingInterval = 210000;
308     uint256 public blockNumber = 0; // how many blocks mined
309     uint256 public totalSupply = 0;
310     uint256 public target   = 0x0000ffff00000000000000000000000000000000000000000000000000000000; // i.e. difficulty. miner needs to find nonce, so that (hash(nonce+random) < target)
311     uint256 public powLimit = 0x0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
312     uint40 public lastMinedOn; // will be used to check how long did it take to mine
313     uint256 public randomness;
314 
315     address public newContractAddress;
316 
317     function MetaToken() Ownable() {
318         lastMinedOn = uint40(block.timestamp);
319         updateRandomness();
320     }
321 
322     /// update randomness, will be used to find next Nonce
323     function updateRandomness() internal {
324         randomness = uint256(sha3(sha3(uint256(block.blockhash(block.number-1)) + uint256(block.coinbase) + uint256(block.timestamp))));
325     }
326 
327     /// returns `randomness` used in PoW calculations
328     function getRamdomness() view returns (uint256 currentRandomness) {
329         return randomness;
330     }
331 
332     /// pure, accepts randomness & nonce and returns hash as int (which should be compared to target)
333     function hash(uint256 nonce, uint256 currentRandomness) pure returns (uint256){
334         return uint256(sha3(nonce+currentRandomness));
335     }
336 
337     /// pure, accepts randomness, nonce & target and returns boolian whether work is good
338     function checkProofOfWork(uint256 nonce, uint256 currentRandomness, uint256 currentTarget) pure returns (bool workAccepted){
339         return uint256(hash(nonce, currentRandomness)) < currentTarget;
340     }
341 
342     // accepts Nonce and tells whether it is good to mine
343     function checkMine(uint256 nonce) view returns (bool success) {
344         return checkProofOfWork(nonce, getRamdomness(), target);
345     }
346 
347     /*
348         accepts nonce aka "mining field", checks if it passess proof of work,
349         rewards if it does
350     */
351     function mine(uint256 nonce) whenNotPaused returns (bool success) {
352         require(checkMine(nonce));
353 
354         Mine(msg.sender, blockReward, uint40(block.timestamp) - uint40(lastMinedOn)); // issuing event to those who listens for it
355 
356         balances[msg.sender] += blockReward; // giving reward
357         blockNumber += 1;
358         totalSupply += blockReward; // increasing total supply
359         updateRandomness();
360 
361         // difficulty retarget:
362         var mul = (block.timestamp - lastMinedOn);
363         if (mul > (60*2.5*2)) {
364             mul = 60*2.5*2;
365         }
366         if (mul < (60*2.5/2)) {
367             mul = 60*2.5/2;
368         }
369         target *= mul;
370         target /= (60*2.5);
371 
372         if (target > powLimit) { // difficulty not lower than that
373             target = powLimit;
374         }
375 
376         lastMinedOn = uint40(block.timestamp); // tracking time to check how much PoW took in the future
377         if (blockNumber % halvingInterval == 0) { // time to halve reward?
378             blockReward /= 2;
379             RewardHalved();
380         }
381 
382         return true;
383     }
384 
385     function setNewContractAddress(address newAddress) onlyOwner {
386         newContractAddress = newAddress;
387     }
388 
389     event Mine(address indexed _miner, uint256 _reward, uint40 _seconds);
390     event RewardHalved();
391 }