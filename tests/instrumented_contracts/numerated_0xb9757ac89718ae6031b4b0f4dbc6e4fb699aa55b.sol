1 pragma solidity ^0.4.11;
2 
3 
4 
5 library SafeMath {
6   function mul(uint a, uint b) internal returns (uint) {
7     uint c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11   
12 
13   function div(uint a, uint b) internal returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47   function assert(bool assertion) internal {
48     if (!assertion) {
49       throw;
50     }
51   }
52 }
53 
54 
55 contract ERC20Basic {
56   uint public totalSupply;
57   function balanceOf(address who) constant returns (uint);
58   function transfer(address to, uint value);
59   event Transfer(address indexed from, address indexed to, uint value);
60 }
61 
62 contract ERC20 is ERC20Basic {
63   function allowance(address owner, address spender) constant returns (uint);
64   function transferFrom(address from, address to, uint value);
65   function approve(address spender, uint value);
66   event Approval(address indexed owner, address indexed spender, uint value);
67 }
68 
69 
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint;
72 
73   mapping(address => uint) balances;
74 
75   /**
76    * @dev Fix for the ERC20 short address attack.
77    */
78   modifier onlyPayloadSize(uint size) {
79      if(msg.data.length < size + 4) {
80        throw;
81      }
82      _;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of. 
99   * @return An uint representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) constant returns (uint balance) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 
108 contract StandardToken is BasicToken, ERC20 {
109 
110   mapping (address => mapping (address => uint)) allowed;
111 
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint the amout of tokens to be transfered
118    */
119   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
120     var _allowance = allowed[_from][msg.sender];
121 
122     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
123     // if (_value > _allowance) throw;
124 
125     balances[_to] = balances[_to].add(_value);
126     balances[_from] = balances[_from].sub(_value);
127     allowed[_from][msg.sender] = _allowance.sub(_value);
128     Transfer(_from, _to, _value);
129   }
130 
131   /**
132    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
133    * @param _spender The address which will spend the funds.
134    * @param _value The amount of tokens to be spent.
135    */
136   function approve(address _spender, uint _value) {
137 
138     // To change the approve amount you first have to reduce the addresses`
139     //  allowance to zero by calling `approve(_spender, 0)` if it is not
140     //  already 0 to mitigate the race condition described here:
141     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
143 
144     allowed[msg.sender][_spender] = _value;
145     Approval(msg.sender, _spender, _value);
146   }
147 
148   /**
149    * @dev Function to check the amount of tokens than an owner allowed to a spender.
150    * @param _owner address The address which owns the funds.
151    * @param _spender address The address which will spend the funds.
152    * @return A uint specifing the amount of tokens still avaible for the spender.
153    */
154   function allowance(address _owner, address _spender) constant returns (uint remaining) {
155     return allowed[_owner][_spender];
156   }
157 
158 }
159 
160 
161 
162 contract EFFCoin is StandardToken {
163     string public constant NAME = "EFFCoin";
164     string public constant SYMBOL = "EFF";
165     uint public constant DECIMALS = 8;
166 
167 
168     uint8[10] public bonusPercentages = [
169         40,
170         15,
171         10,
172         5
173     ];
174 
175     uint public constant NUM_OF_PHASE = 4;
176   
177    
178 
179     uint public constant BLOCKS_PER_PHASE = 84000;
180 
181   
182     /// Note: this will be initialized during the contract deployment.
183     address public target;
184 
185     /// `firstblock` specifies from which block our token sale starts.
186     /// This can only be modified once by the owner of `target` address.
187     uint public firstblock = 0;
188 
189     /// Indicates whether unsold token have been issued. This part of EFF token
190     /// is managed by the project team and is issued directly to `target`.
191     bool public unsoldTokenIssued = false;
192 
193     /// SOFTCAP Minimum amount of funds to be raised for the sale to succeed. 
194     uint256 public constant GOAL = 86132 ether;
195 
196     /// HARDCAP Maximum amount of fund to be raised, the sale ends on reaching this amount.
197     uint256 public constant HARD_CAP = 689061 ether;
198 
199     /// Base exchange rate is set to 1 ETH = 59 EFF i.e 1 token = 0.017approx.
200     uint256 public constant BASE_RATE = 59;
201 
202     /// A simple stat for emitting events.
203     uint public totalEthReceived = 0;
204 
205     /// Issue event index starting from 0.
206     uint public issueIndex = 0;
207 
208     /* 
209      * EVENTS
210      */
211 
212     /// Emitted only once after token sale starts.
213     event SaleStarted();
214 
215     /// Emitted only once after token sale ended (all token issued).
216     event SaleEnded();
217 
218     /// Emitted when a function is invocated by unauthorized addresses.
219     event InvalidCaller(address caller);
220 
221     /// Emitted when a function is invocated without the specified preconditions.
222     /// This event will not come alone with an exception.
223     event InvalidState(bytes msg);
224 
225     /// Emitted for each sucuessful token purchase.
226     event Issue(uint issueIndex, address addr, uint ethAmount, uint tokenAmount);
227 
228     /// Emitted if the token sale succeeded.
229     event SaleSucceeded();
230 
231     /// Emitted if the token sale failed.
232     /// When token sale failed, all Ether will be return to the original purchasing
233     /// address with a minor deduction of transaction fee（gas)
234     event SaleFailed();
235 
236     /*
237      * MODIFIERS
238      */
239 
240     modifier onlyOwner {
241         if (target == msg.sender) {
242             _;
243         } else {
244             InvalidCaller(msg.sender);
245             throw;
246         }
247     }
248 
249     modifier beforeStart {
250         if (!saleStarted()) {
251             _;
252         } else {
253             InvalidState("Sale has not started yet");
254             throw;
255         }
256     }
257 
258     modifier inProgress {
259         if (saleStarted() && !saleEnded()) {
260             _;
261         } else {
262             InvalidState("Sale is not in progress");
263             throw;
264         }
265     }
266 
267     modifier afterEnd {
268         if (saleEnded()) {
269             _;
270         } else {
271             InvalidState("Sale is not ended yet");
272             throw;
273         }
274     }
275 
276     /**
277      * CONSTRUCTOR 
278      * 
279      * @dev Initialize the EFF Token
280      * @param _target The escrow account address, all ethers will
281      * be sent to this address.
282      *
283      */
284     function EFFCoin(address _target) {
285         target = _target;
286         totalSupply = 10 ** 16;
287         balances[target] = totalSupply;
288     }
289 
290     function increaseSupply(uint value) public onlyOwner returns (bool) {
291         totalSupply = totalSupply.add(value);
292         balances[target] = balances[target].add(value);
293         return true;
294     }
295 
296     function decreaseSupply(uint value) public onlyOwner returns (bool) {
297         balances[target] = balances[target].sub(value);
298         totalSupply = totalSupply.sub(value);  
299         return true;
300     }
301     /*
302      * PUBLIC FUNCTIONS
303      */
304 
305     /// @dev Start the token sale.
306     /// @param _firstblock The block from which the sale will start.
307     function start(uint _firstblock) public onlyOwner beforeStart {
308         if (_firstblock <= block.number) {
309             // Must specify a block in the future.
310             throw;
311         }
312 
313         firstblock = _firstblock;
314         SaleStarted();
315     }
316 
317     /// @dev Triggers unsold tokens to be issued to `target` address.
318     function close() public onlyOwner afterEnd {
319         if (totalEthReceived < GOAL) {
320             SaleFailed();
321         } else {
322             SaleSucceeded();
323         }
324     }
325 
326     /// @dev Returns the current price.
327     function price() public constant returns (uint tokens) {
328         return computeTokenAmount(1 ether);
329     }
330 
331     /// @dev This default function allows token to be purchased by directly
332     /// sending ether to this smart contract.
333     function () payable {
334         issueToken(msg.sender);
335     }
336 
337     /// @dev Issue token based on Ether received.
338     /// @param recipient Address that newly issued token will be sent to.
339     function issueToken(address recipient) payable inProgress {
340         // We only accept minimum purchase of 0.01 ETH.
341         assert(msg.value >= 0.01 ether);
342 
343         // We only accept maximum purchase of 35 ETH.
344         assert(msg.value <= 35 ether);
345 
346         // We only accept totalEthReceived < HARD_CAP
347         uint ethReceived = totalEthReceived + msg.value;
348         assert(ethReceived <= HARD_CAP);
349 
350         uint tokens = computeTokenAmount(msg.value);
351         totalEthReceived = totalEthReceived.add(msg.value);
352         
353         balances[msg.sender] = balances[msg.sender].add(tokens);
354         balances[target] = balances[target].sub(tokens);
355 
356         Issue(
357             issueIndex++,
358             recipient,
359             msg.value,
360             tokens
361         );
362 
363         if (!target.send(msg.value)) {
364             throw;
365         }
366     }
367 
368     /*
369      * INTERNAL FUNCTIONS
370      */
371   
372     /// @dev Compute the amount of EFF token that can be purchased.
373     /// @param ethAmount Amount of Ether to purchase EFF.
374     /// @return Amount of EFF token to purchase
375     function computeTokenAmount(uint ethAmount) internal constant returns (uint tokens) {
376         uint phase = (block.number - firstblock).div(BLOCKS_PER_PHASE);
377 
378         // A safe check
379         if (phase >= bonusPercentages.length) {
380             phase = bonusPercentages.length - 1;
381         }
382 
383         uint tokenBase = ethAmount.mul(BASE_RATE);
384         uint tokenBonus = tokenBase.mul(bonusPercentages[phase]).div(100);
385 
386         tokens = tokenBase.add(tokenBonus);
387     }
388 
389     /// @return true if sale has started, false otherwise.
390     function saleStarted() constant returns (bool) {
391         return (firstblock > 0 && block.number >= firstblock);
392     }
393 
394     /// @return true if sale has ended, false otherwise.
395     function saleEnded() constant returns (bool) {
396         return firstblock > 0 && (saleDue() || hardCapReached());
397     }
398 
399     /// @return true if sale is due when the last phase is finished.
400     function saleDue() constant returns (bool) {
401         return block.number >= firstblock + BLOCKS_PER_PHASE * NUM_OF_PHASE;
402     }
403 
404     /// @return true if the hard cap is reached.
405     function hardCapReached() constant returns (bool) {
406         return totalEthReceived >= HARD_CAP;
407     }
408 }