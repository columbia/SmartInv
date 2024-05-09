1 pragma solidity ^0.4.11;
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
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20Basic {
62   uint public totalSupply;
63   function balanceOf(address who) constant returns (uint);
64   function transfer(address to, uint value);
65   event Transfer(address indexed from, address indexed to, uint value);
66 }
67 
68 
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances. 
73  */
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint;
76 
77   mapping(address => uint) balances;
78 
79   /**
80    * @dev Fix for the ERC20 short address attack.
81    */
82   modifier onlyPayloadSize(uint size) {
83      if(msg.data.length < size + 4) {
84        throw;
85      }
86      _;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of. 
103   * @return An uint representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) constant returns (uint balance) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 
112 
113 
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120   function allowance(address owner, address spender) constant returns (uint);
121   function transferFrom(address from, address to, uint value);
122   function approve(address spender, uint value);
123   event Approval(address indexed owner, address indexed spender, uint value);
124 }
125 
126 
127 
128 
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implemantation of the basic standart token.
134  * @dev https://github.com/ethereum/EIPs/issues/20
135  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  */
137 contract StandardToken is BasicToken, ERC20 {
138 
139   mapping (address => mapping (address => uint)) allowed;
140 
141 
142   /**
143    * @dev Transfer tokens from one address to another
144    * @param _from address The address which you want to send tokens from
145    * @param _to address The address which you want to transfer to
146    * @param _value uint the amout of tokens to be transfered
147    */
148   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
149     var _allowance = allowed[_from][msg.sender];
150 
151     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
152     // if (_value > _allowance) throw;
153 
154     balances[_to] = balances[_to].add(_value);
155     balances[_from] = balances[_from].sub(_value);
156     allowed[_from][msg.sender] = _allowance.sub(_value);
157     Transfer(_from, _to, _value);
158   }
159 
160   /**
161    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint _value) {
166 
167     // To change the approve amount you first have to reduce the addresses`
168     //  allowance to zero by calling `approve(_spender, 0)` if it is not
169     //  already 0 to mitigate the race condition described here:
170     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
172 
173     allowed[msg.sender][_spender] = _value;
174     Approval(msg.sender, _spender, _value);
175   }
176 
177   /**
178    * @dev Function to check the amount of tokens than an owner allowed to a spender.
179    * @param _owner address The address which owns the funds.
180    * @param _spender address The address which will spend the funds.
181    * @return A uint specifing the amount of tokens still avaible for the spender.
182    */
183   function allowance(address _owner, address _spender) constant returns (uint remaining) {
184     return allowed[_owner][_spender];
185   }
186 
187 }
188 
189 
190 
191 
192 
193 
194 /// @title SHC Protocol Token.
195 /// For more information about this token sale, please visit https://gxn.io
196 /// @author Arnold - <arnold@gxn.io>, Bob - <bob@gxn.io>.
197 contract SHCToken is StandardToken {
198     string public constant NAME = "商会币";
199     string public constant SYMBOL = "SHC";
200     uint public constant DECIMALS = 18;
201 
202     /// During token sale, we use one consistent price: 1000 SHC/ETH.
203     /// We split the entire token sale period into 3 phases, each
204     /// phase has a different bonus setting as specified in `bonusPercentages`.
205     /// The real price for phase i is `(1 + bonusPercentages[i]/100.0) * BASE_RATE`.
206     /// The first phase or early-bird phase has a much higher bonus.
207     uint8[10] public bonusPercentages = [
208         20,
209         10,
210         0
211     ];
212 
213     uint public constant NUM_OF_PHASE = 3;
214   
215     /// Each phase contains exactly 29000 Ethereum blocks, which is roughly 7 days,
216     /// which makes this 3-phase sale period roughly 21 days.
217     /// See https://www.ethereum.org/crowdsale#scheduling-a-call
218     uint16 public constant BLOCKS_PER_PHASE = 29000;
219 
220     /// This is where we hold ETH during this token sale. We will not transfer any Ether
221     /// out of this address before we invocate the `close` function to finalize the sale. 
222     /// This promise is not guanranteed by smart contract by can be verified with public
223     /// Ethereum transactions data available on several blockchain browsers.
224     /// This is the only address from which `start` and `close` can be invocated.
225     ///
226     /// Note: this will be initialized during the contract deployment.
227     address public target;
228 
229     /// `firstblock` specifies from which block our token sale starts.
230     /// This can only be modified once by the owner of `target` address.
231     uint public firstblock = 0;
232 
233     /// Indicates whether unsold token have been issued. This part of SHC token
234     /// is managed by the project team and is issued directly to `target`.
235     bool public unsoldTokenIssued = false;
236 
237     /// Minimum amount of funds to be raised for the sale to succeed. 
238     uint256 public constant GOAL = 3000 ether;
239 
240     /// Maximum amount of fund to be raised, the sale ends on reaching this amount.
241     uint256 public constant HARD_CAP = 4500 ether;
242 
243     /// Base exchange rate is set to 1 ETH = 1050 SHC.
244     uint256 public constant BASE_RATE = 1050;
245 
246     /// A simple stat for emitting events.
247     uint public totalEthReceived = 0;
248 
249     /// Issue event index starting from 0.
250     uint public issueIndex = 0;
251 
252     /* 
253      * EVENTS
254      */
255 
256     /// Emitted only once after token sale starts.
257     event SaleStarted();
258 
259     /// Emitted only once after token sale ended (all token issued).
260     event SaleEnded();
261 
262     /// Emitted when a function is invocated by unauthorized addresses.
263     event InvalidCaller(address caller);
264 
265     /// Emitted when a function is invocated without the specified preconditions.
266     /// This event will not come alone with an exception.
267     event InvalidState(bytes msg);
268 
269     /// Emitted for each sucuessful token purchase.
270     event Issue(uint issueIndex, address addr, uint ethAmount, uint tokenAmount);
271 
272     /// Emitted if the token sale succeeded.
273     event SaleSucceeded();
274 
275     /// Emitted if the token sale failed.
276     /// When token sale failed, all Ether will be return to the original purchasing
277     /// address with a minor deduction of transaction fee锛坓as)
278     event SaleFailed();
279 
280     /*
281      * MODIFIERS
282      */
283 
284     modifier onlyOwner {
285         if (target == msg.sender) {
286             _;
287         } else {
288             InvalidCaller(msg.sender);
289             throw;
290         }
291     }
292 
293     modifier beforeStart {
294         if (!saleStarted()) {
295             _;
296         } else {
297             InvalidState("Sale has not started yet");
298             throw;
299         }
300     }
301 
302     modifier inProgress {
303         if (saleStarted() && !saleEnded()) {
304             _;
305         } else {
306             InvalidState("Sale is not in progress");
307             throw;
308         }
309     }
310 
311     modifier afterEnd {
312         if (saleEnded()) {
313             _;
314         } else {
315             InvalidState("Sale is not ended yet");
316             throw;
317         }
318     }
319 
320     /**
321      * CONSTRUCTOR 
322      * 
323      * @dev Initialize the SHC Token
324      * @param _target The escrow account address, all ethers will
325      * be sent to this address.
326      * This address will be : 0xe597c5ab87e9d20ad445976d9b016c37f864da2b
327      */
328     function SHCToken(address _target) {
329         target = _target;
330         totalSupply = 10 ** 26;
331         balances[target] = totalSupply;
332     }
333 
334     /*
335      * PUBLIC FUNCTIONS
336      */
337 
338     /// @dev Start the token sale.
339     /// @param _firstblock The block from which the sale will start.
340     function start(uint _firstblock) public onlyOwner beforeStart {
341         if (_firstblock <= block.number) {
342             // Must specify a block in the future.
343             throw;
344         }
345 
346         firstblock = _firstblock;
347         SaleStarted();
348     }
349 
350     /// @dev Triggers unsold tokens to be issued to `target` address.
351     function close() public onlyOwner afterEnd {
352         if (totalEthReceived < GOAL) {
353             SaleFailed();
354         } else {
355             SaleSucceeded();
356         }
357     }
358 
359     /// @dev Returns the current price.
360     function price() public constant returns (uint tokens) {
361         return computeTokenAmount(1 ether);
362     }
363 
364     /// @dev This default function allows token to be purchased by directly
365     /// sending ether to this smart contract.
366     function () payable {
367         issueToken(msg.sender);
368     }
369 
370     /// @dev Issue token based on Ether received.
371     /// @param recipient Address that newly issued token will be sent to.
372     function issueToken(address recipient) payable inProgress {
373         // We only accept minimum purchase of 0.01 ETH.
374         assert(msg.value >= 0.01 ether);
375 
376         // We only accept maximum purchase of 35 ETH.
377         assert(msg.value <= 35 ether);
378 
379         // We only accept totalEthReceived < HARD_CAP
380         uint ethReceived = totalEthReceived + msg.value;
381         assert(ethReceived <= HARD_CAP);
382 
383         uint tokens = computeTokenAmount(msg.value);
384         totalEthReceived = totalEthReceived.add(msg.value);
385         
386         balances[msg.sender] = balances[msg.sender].add(tokens);
387         balances[target] = balances[target].sub(tokens);
388 
389         Issue(
390             issueIndex++,
391             recipient,
392             msg.value,
393             tokens
394         );
395 
396         if (!target.send(msg.value)) {
397             throw;
398         }
399     }
400 
401     /*
402      * INTERNAL FUNCTIONS
403      */
404   
405     /// @dev Compute the amount of SHC token that can be purchased.
406     /// @param ethAmount Amount of Ether to purchase SHC.
407     /// @return Amount of SHC token to purchase
408     function computeTokenAmount(uint ethAmount) internal constant returns (uint tokens) {
409         uint phase = (block.number - firstblock).div(BLOCKS_PER_PHASE);
410 
411         // A safe check
412         if (phase >= bonusPercentages.length) {
413             phase = bonusPercentages.length - 1;
414         }
415 
416         uint tokenBase = ethAmount.mul(BASE_RATE);
417         uint tokenBonus = tokenBase.mul(bonusPercentages[phase]).div(100);
418 
419         tokens = tokenBase.add(tokenBonus);
420     }
421 
422     /// @return true if sale has started, false otherwise.
423     function saleStarted() constant returns (bool) {
424         return (firstblock > 0 && block.number >= firstblock);
425     }
426 
427     /// @return true if sale has ended, false otherwise.
428     function saleEnded() constant returns (bool) {
429         return firstblock > 0 && (saleDue() || hardCapReached());
430     }
431 
432     /// @return true if sale is due when the last phase is finished.
433     function saleDue() constant returns (bool) {
434         return block.number >= firstblock + BLOCKS_PER_PHASE * NUM_OF_PHASE;
435     }
436 
437     /// @return true if the hard cap is reached.
438     function hardCapReached() constant returns (bool) {
439         return totalEthReceived >= HARD_CAP;
440     }
441 }