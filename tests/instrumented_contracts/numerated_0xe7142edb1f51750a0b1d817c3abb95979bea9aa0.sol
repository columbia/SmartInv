1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     if (msg.sender != owner) {
26       throw;
27     }
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) onlyOwner {
37     if (newOwner != address(0)) {
38       owner = newOwner;
39     }
40   }
41 
42 }
43 
44 
45 /**
46  * @title Pausable
47  * @dev Base contract which allows children to implement an emergency stop mechanism.
48  */
49 contract Pausable is Ownable {
50   event Pause();
51   event Unpause();
52 
53   bool public paused = false;
54 
55 
56   /**
57    * @dev modifier to allow actions only when the contract IS paused
58    */
59   modifier whenNotPaused() {
60     if (paused) throw;
61     _;
62   }
63 
64   /**
65    * @dev modifier to allow actions only when the contract IS NOT paused
66    */
67   modifier whenPaused {
68     if (!paused) throw;
69     _;
70   }
71 
72   /**
73    * @dev called by the owner to pause, triggers stopped state
74    */
75   function pause() onlyOwner whenNotPaused returns (bool) {
76     paused = true;
77     Pause();
78     return true;
79   }
80 
81   /**
82    * @dev called by the owner to unpause, returns to normal state
83    */
84   function unpause() onlyOwner whenPaused returns (bool) {
85     paused = false;
86     Unpause();
87     return true;
88   }
89 }
90 
91 
92 
93 /**
94  * @title ERC20Basic
95  * @dev Simpler version of ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/20
97  */
98 contract ERC20Basic {
99   uint256 public totalSupply;
100   function balanceOf(address who) constant returns (uint256);
101   function transfer(address to, uint256 value);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 
106 /**
107  * Math operations with safety checks
108  */
109 library SafeMath {
110   function mul(uint256 a, uint256 b) internal returns (uint256) {
111     uint256 c = a * b;
112     assert(a == 0 || c / a == b);
113     return c;
114   }
115 
116   function div(uint256 a, uint256 b) internal returns (uint256) {
117     // assert(b > 0); // Solidity automatically throws when dividing by 0
118     uint256 c = a / b;
119     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120     return c;
121   }
122 
123   function sub(uint256 a, uint256 b) internal returns (uint256) {
124     assert(b <= a);
125     return a - b;
126   }
127 
128   function add(uint256 a, uint256 b) internal returns (uint256) {
129     uint256 c = a + b;
130     assert(c >= a);
131     return c;
132   }
133 
134   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
135     return a >= b ? a : b;
136   }
137 
138   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
139     return a < b ? a : b;
140   }
141 
142   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
143     return a >= b ? a : b;
144   }
145 
146   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
147     return a < b ? a : b;
148   }
149 
150 }
151 
152 
153 
154 /**
155  * @title Basic token
156  * @dev Basic version of StandardToken, with no allowances.
157  */
158 contract BasicToken is ERC20Basic {
159   using SafeMath for uint256;
160 
161   mapping(address => uint256) balances;
162 
163   /**
164    * @dev Fix for the ERC20 short address attack.
165    */
166   modifier onlyPayloadSize(uint256 size) {
167      if(msg.data.length < size + 4) {
168        throw;
169      }
170      _;
171   }
172 
173   /**
174   * @dev transfer token for a specified address
175   * @param _to The address to transfer to.
176   * @param _value The amount to be transferred.
177   */
178   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) {
179     balances[msg.sender] = balances[msg.sender].sub(_value);
180     balances[_to] = balances[_to].add(_value);
181     Transfer(msg.sender, _to, _value);
182   }
183 
184   /**
185   * @dev Gets the balance of the specified address.
186   * @param _owner The address to query the the balance of.
187   * @return An uint256 representing the amount owned by the passed address.
188   */
189   function balanceOf(address _owner) constant returns (uint256 balance) {
190     return balances[_owner];
191   }
192 
193 }
194 
195 
196 
197 /**
198  * @title Helps contracts guard agains rentrancy attacks.
199  * @author Remco Bloemen <remco@2π.com>
200  * @notice If you mark a function `nonReentrant`, you should also
201  * mark it `external`.
202  */
203 contract ReentrancyGuard {
204 
205   /**
206    * @dev We use a single lock for the whole contract.
207    */
208   bool private rentrancy_lock = false;
209 
210   /**
211    * @dev Prevents a contract from calling itself, directly or indirectly.
212    * @notice If you mark a function `nonReentrant`, you should also
213    * mark it `external`. Calling one nonReentrant function from
214    * another is not supported. Instead, you can implement a
215    * `private` function doing the actual work, and a `external`
216    * wrapper marked as `nonReentrant`.
217    */
218   modifier nonReentrant() {
219     if(rentrancy_lock == false) {
220       rentrancy_lock = true;
221       _;
222       rentrancy_lock = false;
223     } else {
224       throw;
225     }
226   }
227 
228 }
229 
230 contract EtchReward is Pausable, BasicToken, ReentrancyGuard {
231 
232     // address public owner;                // Ownable
233     // bool public paused = false;          // Pausable
234     // mapping(address => uint) balances;   // BasicToken
235     // uint public totalSupply;             // ERC20Basic
236     // bool private rentrancy_lock = false; // ReentrancyGuard
237 
238     //
239     // @dev constants
240     //
241     string public constant name   = "Etch Reward Token";
242     string public constant symbol = "ETCHR";
243     uint public constant decimals = 18;
244 
245     //
246     // @dev the main address to be forwarded all ether
247     //
248     address public constant BENEFICIARY = 0x651A3731f717a17777c9D8d6f152Aa9284978Ea3;
249 
250     // @dev number of tokens one receives for every 1 ether they send
251     uint public constant PRICE = 8;
252 
253     // avg block time = 17.20 https://etherscan.io
254     uint public constant AVG_BLOCKS_24H = 5023;  // 3600 * 24 / 17.20
255     uint public constant AVG_BLOCKS_02W = 70325; // 3600 * 24 * 14 / 17.20
256 
257     uint public constant MAX_ETHER_24H = 40 ether;
258     uint public constant ETHER_CAP     = 2660 ether;
259 
260     uint public totalEther = 0;
261     uint public blockStart = 0;
262     uint public block24h   = 0;
263     uint public block02w   = 0;
264 
265     // @dev address of the actual ICO contract to be deployed later
266     address public icoContract = 0x0;
267 
268     //
269     // @dev owner authorized addresses to participate in this pre-ico
270     //
271     mapping(address => bool) contributors;
272 
273 
274     // @dev constructor function
275     function EtchReward(uint _blockStart) {
276         blockStart  = _blockStart;
277         block24h = blockStart + AVG_BLOCKS_24H;
278         block02w = blockStart + AVG_BLOCKS_02W;
279     }
280 
281     //
282     // @notice the ability to transfer tokens is disabled
283     //
284     function transfer(address, uint) {
285         throw;
286     }
287 
288     //
289     // @notice we DO allow sending ether directly to the contract address
290     //
291     function () payable {
292         buy();
293     }
294 
295     //
296     // @dev modifiers
297     //
298     modifier onlyContributors() {
299         if(contributors[msg.sender] != true) {
300             throw;
301         }
302         _;
303     }
304 
305     modifier onlyIcoContract() {
306         if(icoContract == 0x0 || msg.sender != icoContract) {
307             throw;
308         }
309         _;
310     }
311 
312     //
313     // @dev call this to authorize participants to this pre-ico sale
314     // @param the authorized participant address
315     //
316     function addContributor(address _who) public onlyOwner {
317         contributors[_who] = true;
318     }
319 
320     // @dev useful for contributor to check before sending ether
321     function isContributor(address _who) public constant returns(bool) {
322         return contributors[_who];
323     }
324 
325     //
326     // @dev this will be later set by the owner of this contract
327     //
328     function setIcoContract(address _contract) public onlyOwner {
329         icoContract = _contract;
330     }
331 
332     //
333     // @dev function called by the ICO contract to transform the tokens into ETCH tokens
334     //
335     function migrate(address _contributor) public
336     onlyIcoContract
337     whenNotPaused {
338 
339         if(getBlock() < block02w) {
340             throw;
341         }
342         totalSupply = totalSupply.sub(balances[_contributor]);
343         balances[_contributor] = 0;
344     }
345 
346     function buy() payable
347     nonReentrant
348     onlyContributors
349     whenNotPaused {
350 
351         address _recipient = msg.sender;
352         uint blockNow = getBlock();
353 
354         // are we before or after the sale period?
355         if(blockNow < blockStart || block02w <= blockNow) {
356             throw;
357         }
358 
359         if (blockNow < block24h) {
360 
361             // only one transaction is authorized
362             if (balances[_recipient] > 0) {
363                 throw;
364             }
365 
366             // only allowed to buy a certain amount
367             if (msg.value > MAX_ETHER_24H) {
368                 throw;
369             }
370         }
371 
372         // make sure we don't go over the ether cap
373         if (totalEther.add(msg.value) > ETHER_CAP) {
374             throw;
375         }
376 
377         uint tokens = msg.value.mul(PRICE);
378         totalSupply = totalSupply.add(tokens);
379 
380         balances[_recipient] = balances[_recipient].add(tokens);
381         totalEther.add(msg.value);
382 
383         if (!BENEFICIARY.send(msg.value)) {
384             throw;
385         }
386     }
387 
388     function getBlock() public constant returns (uint) {
389         return block.number;
390     }
391 
392 }