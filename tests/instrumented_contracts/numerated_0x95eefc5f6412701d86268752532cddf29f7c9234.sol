1 pragma solidity ^0.4.21;
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
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       throw;
51     }
52   }
53 }
54 
55 
56 /**
57  * @title ERC20Basic
58  * @dev Simpler version of ERC20 interface
59  */
60 contract ERC20Basic {
61   uint public totalSupply;
62   function balanceOf(address who) constant returns (uint);
63   function transfer(address to, uint value);
64   event Transfer(address indexed from, address indexed to, uint value);
65 }
66 
67 
68 
69 /**
70  * @title Basic token
71  * @dev Basic version of StandardToken, with no allowances. 
72  */
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint;
75 
76   mapping(address => uint) balances;
77 
78   /**
79    * @dev Fix for the ERC20 short address attack.
80    */
81   modifier onlyPayloadSize(uint size) {
82      if(msg.data.length < size + 4) {
83        throw;
84      }
85      _;
86   }
87 
88   /**
89   * @dev transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of. 
102   * @return An uint representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) constant returns (uint balance) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 
111 
112 
113 
114 /**
115  * @title ERC20 interface
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender) constant returns (uint);
119   function transferFrom(address from, address to, uint value);
120   function approve(address spender, uint value);
121   event Approval(address indexed owner, address indexed spender, uint value);
122 }
123 
124 
125 
126 
127 
128 /**
129  * @title Standard ERC20 token
130  * @dev Implemantation of the basic standart token.
131  */
132 contract StandardToken is BasicToken, ERC20 {
133 
134   mapping (address => mapping (address => uint)) allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint the amout of tokens to be transfered
142    */
143   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
144     var _allowance = allowed[_from][msg.sender];
145 
146     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
147     // if (_value > _allowance) throw;
148 
149     balances[_to] = balances[_to].add(_value);
150     balances[_from] = balances[_from].sub(_value);
151     allowed[_from][msg.sender] = _allowance.sub(_value);
152     Transfer(_from, _to, _value);
153   }
154 
155   /**
156    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
157    * @param _spender The address which will spend the funds.
158    * @param _value The amount of tokens to be spent.
159    */
160   function approve(address _spender, uint _value) {
161 
162     // To change the approve amount you first have to reduce the addresses`
163     //  allowance to zero by calling `approve(_spender, 0)` if it is not
164     //  already 0 to mitigate the race condition described here:
165     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
167 
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens than an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint specifing the amount of tokens still avaible for the spender.
177    */
178   function allowance(address _owner, address _spender) constant returns (uint remaining) {
179     return allowed[_owner][_spender];
180   }
181 
182 }
183 
184 
185 
186 
187 
188 
189 /// @title SUC Protocol Token.
190 contract SUCToken is StandardToken {
191     string public constant NAME = "SUPPLYCHAIN";
192     string public constant SYMBOL = "SUC";
193     uint public constant DECIMALS = 18;
194 
195     /// During token sale, we use one consistent price: 50000 SUC/ETH.
196     /// We split the entire token sale period into 3 phases, each
197     /// phase has a different bonus setting as specified in `bonusPercentages`.
198     /// The real price for phase i is `(1 + bonusPercentages[i]/100.0) * BASE_RATE`.
199     /// The first phase or early-bird phase has a much higher bonus.
200     uint8[10] public bonusPercentages = [
201         20,
202         10,
203         0
204     ];
205 
206     uint public constant NUM_OF_PHASE = 3;
207   
208     /// Each phase contains exactly 29000 Ethereum blocks, which is roughly 7 days,
209     /// which makes this 3-phase sale period roughly 21 days.
210     uint16 public constant BLOCKS_PER_PHASE = 29000;
211 
212     /// This is where we hold ETH during this token sale. We will not transfer any Ether
213     /// out of this address before we invocate the `close` function to finalize the sale. 
214     /// This promise is not guanranteed by smart contract by can be verified with public
215     /// Ethereum transactions data available on several blockchain browsers.
216     /// This is the only address from which `start` and `close` can be invocated.
217     /// Note: this will be initialized during the contract deployment.
218     address public target;
219 
220     /// `firstblock` specifies from which block our token sale starts.
221     /// This can only be modified once by the owner of `target` address.
222     uint public firstblock = 0;
223 
224     /// Indicates whether unsold token have been issued. This part of SUC token
225     /// is managed by the project team and is issued directly to `target`.
226     bool public unsoldTokenIssued = false;
227 
228     /// Minimum amount of funds to be raised for the sale to succeed. 
229     uint256 public constant GOAL = 5000 ether;
230 
231     /// Maximum amount of fund to be raised, the sale ends on reaching this amount.
232     uint256 public constant HARD_CAP = 10000 ether;
233 
234     /// Base exchange rate is set to 1 ETH = 50000 SUC.
235     uint256 public constant BASE_RATE = 50000;
236 
237     /// A simple stat for emitting events.
238     uint public totalEthReceived = 0;
239 
240     /// Issue event index starting from 0.
241     uint public issueIndex = 0;
242 
243     /* 
244      * EVENTS
245      */
246 
247     /// Emitted only once after token sale starts.
248     event SaleStarted();
249 
250     /// Emitted only once after token sale ended (all token issued).
251     event SaleEnded();
252 
253     /// Emitted when a function is invocated by unauthorized addresses.
254     event InvalidCaller(address caller);
255 
256     /// Emitted when a function is invocated without the specified preconditions.
257     /// This event will not come alone with an exception.
258     event InvalidState(bytes msg);
259 
260     /// Emitted for each sucuessful token purchase.
261     event Issue(uint issueIndex, address addr, uint ethAmount, uint tokenAmount);
262 
263     /// Emitted if the token sale succeeded.
264     event SaleSucceeded();
265 
266     /// Emitted if the token sale failed.
267     /// When token sale failed, all Ether will be return to the original purchasing
268     /// address with a minor deduction of transaction fee（gas)
269     event SaleFailed();
270 
271     /*
272      * MODIFIERS
273      */
274 
275     modifier onlyOwner {
276         if (target == msg.sender) {
277             _;
278         } else {
279             InvalidCaller(msg.sender);
280             throw;
281         }
282     }
283 
284     modifier beforeStart {
285         if (!saleStarted()) {
286             _;
287         } else {
288             InvalidState("Sale has not started yet");
289             throw;
290         }
291     }
292 
293     modifier inProgress {
294         if (saleStarted() && !saleEnded()) {
295             _;
296         } else {
297             InvalidState("Sale is not in progress");
298             throw;
299         }
300     }
301 
302     modifier afterEnd {
303         if (saleEnded()) {
304             _;
305         } else {
306             InvalidState("Sale is not ended yet");
307             throw;
308         }
309     }
310 
311     /**
312      * CONSTRUCTOR 
313      * 
314      * @dev Initialize the SUC Token
315      * @param _target The escrow account address
316      */
317     function SUCToken(address _target) {
318         target = _target;
319         totalSupply = 10 ** 27;
320         balances[target] = totalSupply;
321     }
322 
323     /*
324      * PUBLIC FUNCTIONS
325      */
326 
327     /// @dev Start the token sale.
328     /// @param _firstblock The block from which the sale will start.
329     function start(uint _firstblock) public onlyOwner beforeStart {
330         if (_firstblock <= block.number) {
331             // Must specify a block in the future.
332             throw;
333         }
334 
335         firstblock = _firstblock;
336         SaleStarted();
337     }
338 
339     /// @dev Triggers unsold tokens to be issued to `target` address.
340     function close() public onlyOwner afterEnd {
341         if (totalEthReceived < GOAL) {
342             SaleFailed();
343         } else {
344             SaleSucceeded();
345         }
346     }
347 
348     /// @dev Returns the current price.
349     function price() public constant returns (uint tokens) {
350         return computeTokenAmount(1 ether);
351     }
352 
353     /// @dev This default function allows token to be purchased by directly
354     /// sending ether to this smart contract.
355     function () payable {
356         issueToken(msg.sender);
357     }
358 
359     /// @dev Issue token based on Ether received.
360     /// @param recipient Address that newly issued token will be sent to.
361     function issueToken(address recipient) payable inProgress {
362         // We only accept minimum purchase of 0.01 ETH.
363         assert(msg.value >= 0.01 ether);
364 
365         // We only accept maximum purchase of 10000 ETH.
366         assert(msg.value <= 10000 ether);
367 
368         // We only accept totalEthReceived < HARD_CAP
369         uint ethReceived = totalEthReceived + msg.value;
370         assert(ethReceived <= HARD_CAP);
371 
372         uint tokens = computeTokenAmount(msg.value);
373         totalEthReceived = totalEthReceived.add(msg.value);
374         
375         balances[msg.sender] = balances[msg.sender].add(tokens);
376         balances[target] = balances[target].sub(tokens);
377 
378         Issue(
379             issueIndex++,
380             recipient,
381             msg.value,
382             tokens
383         );
384 
385         if (!target.send(msg.value)) {
386             throw;
387         }
388     }
389 
390     /*
391      * INTERNAL FUNCTIONS
392      */
393   
394     /// @dev Compute the amount of SUC token that can be purchased.
395     /// @param ethAmount Amount of Ether to purchase SUC.
396     /// @return Amount of SUC token to purchase
397     function computeTokenAmount(uint ethAmount) internal constant returns (uint tokens) {
398         uint phase = (block.number - firstblock).div(BLOCKS_PER_PHASE);
399 
400         // A safe check
401         if (phase >= bonusPercentages.length) {
402             phase = bonusPercentages.length - 1;
403         }
404 
405         uint tokenBase = ethAmount.mul(BASE_RATE);
406         uint tokenBonus = tokenBase.mul(bonusPercentages[phase]).div(100);
407 
408         tokens = tokenBase.add(tokenBonus);
409     }
410 
411     /// @return true if sale has started, false otherwise.
412     function saleStarted() constant returns (bool) {
413         return (firstblock > 0 && block.number >= firstblock);
414     }
415 
416     /// @return true if sale has ended, false otherwise.
417     function saleEnded() constant returns (bool) {
418         return firstblock > 0 && (saleDue() || hardCapReached());
419     }
420 
421     /// @return true if sale is due when the last phase is finished.
422     function saleDue() constant returns (bool) {
423         return block.number >= firstblock + BLOCKS_PER_PHASE * NUM_OF_PHASE;
424     }
425 
426     /// @return true if the hard cap is reached.
427     function hardCapReached() constant returns (bool) {
428         return totalEthReceived >= HARD_CAP;
429     }
430 }