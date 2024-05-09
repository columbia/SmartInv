1 pragma solidity ^0.4.11;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal returns (uint256) {
26     uint256 c = a + b;
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
47 }
48 
49 /*
50  * Ownable
51  *
52  * Base contract with an owner.
53  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
54  */
55 contract Ownable {
56   address public owner;
57 
58   function Ownable() {
59     owner = msg.sender;
60   }
61 
62   modifier onlyOwner() {
63     if (msg.sender != owner) {
64       throw;
65     }
66     _;
67   }
68 
69   function transferOwnership(address newOwner) onlyOwner {
70     if (newOwner != address(0)) {
71       owner = newOwner;
72     }
73   }
74 
75 }
76 
77 
78 /*
79  * Haltable
80  *
81  * Abstract contract that allows children to implement an
82  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
83  *
84  *
85  * Originally envisioned in FirstBlood ICO contract.
86  */
87 contract Haltable is Ownable {
88   bool public halted;
89 
90   modifier stopInEmergency {
91     if (halted) throw;
92     _;
93   }
94 
95   modifier onlyInEmergency {
96     if (!halted) throw;
97     _;
98   }
99 
100   // called by the owner on emergency, triggers stopped state
101   function halt() external onlyOwner {
102     halted = true;
103   }
104 
105   // called by the owner on end of emergency, returns to normal state
106   function unhalt() external onlyOwner onlyInEmergency {
107     halted = false;
108   }
109 
110 }
111 
112 /**
113  * @title ERC20Basic
114  * @dev Simpler version of ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20Basic {
118   uint256 public totalSupply;
119   function balanceOf(address who) constant returns (uint256);
120   function transfer(address to, uint256 value);
121   event Transfer(address indexed from, address indexed to, uint256 value);
122 }
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender) constant returns (uint256);
130   function transferFrom(address from, address to, uint256 value);
131   function approve(address spender, uint256 value);
132   event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134 
135 
136 /**
137  * @title Basic token
138  * @dev Basic version of StandardToken, with no allowances. 
139  */
140 contract BasicToken is ERC20Basic {
141   using SafeMath for uint256;
142 
143   mapping(address => uint256) balances;
144 
145   /**
146    * @dev Fix for the ERC20 short address attack.
147    */
148   modifier onlyPayloadSize(uint256 size) {
149      if(msg.data.length < size + 4) {
150        throw;
151      }
152      _;
153   }
154 
155   /**
156   * @dev transfer token for a specified address
157   * @param _to The address to transfer to.
158   * @param _value The amount to be transferred.
159   */
160   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) {
161     balances[msg.sender] = balances[msg.sender].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     Transfer(msg.sender, _to, _value);
164   }
165 
166   /**
167   * @dev Gets the balance of the specified address.
168   * @param _owner The address to query the the balance of. 
169   * @return An uint256 representing the amount owned by the passed address.
170   */
171   function balanceOf(address _owner) constant returns (uint256 balance) {
172     return balances[_owner];
173   }
174 
175 }
176 
177 /**
178  * @title Standard ERC20 token
179  *
180  * @dev Implemantation of the basic standart token.
181  * @dev https://github.com/ethereum/EIPs/issues/20
182  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
183  */
184 contract StandardToken is BasicToken, ERC20 {
185 
186   mapping (address => mapping (address => uint256)) allowed;
187 
188 
189   /**
190    * @dev Transfer tokens from one address to another
191    * @param _from address The address which you want to send tokens from
192    * @param _to address The address which you want to transfer to
193    * @param _value uint256 the amout of tokens to be transfered
194    */
195   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) {
196     var _allowance = allowed[_from][msg.sender];
197 
198     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
199     // if (_value > _allowance) throw;
200 
201     balances[_to] = balances[_to].add(_value);
202     balances[_from] = balances[_from].sub(_value);
203     allowed[_from][msg.sender] = _allowance.sub(_value);
204     Transfer(_from, _to, _value);
205   }
206 
207   /**
208    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
209    * @param _spender The address which will spend the funds.
210    * @param _value The amount of tokens to be spent.
211    */
212   function approve(address _spender, uint256 _value) {
213 
214     // To change the approve amount you first have to reduce the addresses`
215     //  allowance to zero by calling `approve(_spender, 0)` if it is not
216     //  already 0 to mitigate the race condition described here:
217     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
219 
220     allowed[msg.sender][_spender] = _value;
221     Approval(msg.sender, _spender, _value);
222   }
223 
224   /**
225    * @dev Function to check the amount of tokens that an owner allowed to a spender.
226    * @param _owner address The address which owns the funds.
227    * @param _spender address The address which will spend the funds.
228    * @return A uint256 specifing the amount of tokens still avaible for the spender.
229    */
230   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
231     return allowed[_owner][_spender];
232   }
233 
234 }
235 
236 /**
237  * @title SimpleToken
238  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator. 
239  * Note they can later distribute these tokens as they wish using `transfer` and other
240  * `StandardToken` functions.
241  */
242 contract AhooleeToken is StandardToken {
243 
244   string public name = "Ahoolee Token";
245   string public symbol = "AHT";
246   uint256 public decimals = 18;
247   uint256 public INITIAL_SUPPLY = 100000000 * 1 ether;
248 
249   /**
250    * @dev Contructor that gives msg.sender all of existing tokens. 
251    */
252   function AhooleeToken() {
253     totalSupply = INITIAL_SUPPLY;
254     balances[msg.sender] = INITIAL_SUPPLY;
255   }
256 
257 }
258 
259 
260 contract AhooleeTokenPreSale is Haltable {
261     using SafeMath for uint;
262 
263     string public name = "Ahoolee Token PreSale";
264 
265     AhooleeToken public token;
266     address public beneficiary;
267 
268     uint public hardCap;
269     uint public softCap;
270     uint public collected;
271     uint public price;
272     uint public purchaseLimit;
273 
274     uint public tokensSold = 0;
275     uint public weiRaised = 0;
276     uint public investorCount = 0;
277     uint public weiRefunded = 0;
278 
279     uint public startTime;
280     uint public endTime;
281 
282     bool public softCapReached = false;
283     bool public crowdsaleFinished = false;
284 
285     mapping (address => bool) refunded;
286 
287     event GoalReached(uint amountRaised);
288     event SoftCapReached(uint softCap);
289     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
290     event Refunded(address indexed holder, uint256 amount);
291 
292     modifier onlyAfter(uint time) {
293         if (now < time) throw;
294         _;
295     }
296 
297     modifier onlyBefore(uint time) {
298         if (now > time) throw;
299         _;
300     }
301 
302     function AhooleeTokenPreSale(
303         uint _hardCapUSD,
304         uint _softCapUSD,
305         address _token,
306         address _beneficiary,
307         uint _totalTokens,
308         uint _priceETH,
309         uint _purchaseLimitUSD,
310 
311         uint _startTime,
312         uint _duration
313     ) {
314         hardCap = _hardCapUSD  * 1 ether / _priceETH;
315         softCap = _softCapUSD * 1 ether / _priceETH;
316         price = _totalTokens * 1 ether / hardCap;
317 
318         purchaseLimit = _purchaseLimitUSD * 1 ether / _priceETH * price;
319         token = AhooleeToken(_token);
320         beneficiary = _beneficiary;
321 
322         startTime = _startTime;
323         endTime = _startTime + _duration * 1 hours;
324     }
325 
326     function () payable stopInEmergency{
327         if (msg.value < 0.01 * 1 ether) throw;
328         doPurchase(msg.sender);
329     }
330 
331     function refund() external onlyAfter(endTime) {
332         if (softCapReached) throw;
333         if (refunded[msg.sender]) throw;
334 
335         uint balance = token.balanceOf(msg.sender);
336         if (balance == 0) throw;
337 
338         uint refund = balance / price;
339         if (refund > this.balance) {
340             refund = this.balance;
341         }
342 
343         if (!msg.sender.send(refund)) throw;
344         refunded[msg.sender] = true;
345         weiRefunded = weiRefunded.add(refund);
346         Refunded(msg.sender, refund);
347     }
348 
349     function withdraw() onlyOwner {
350         if (!softCapReached) throw;
351         if (!beneficiary.send(collected)) throw;
352         token.transfer(beneficiary, token.balanceOf(this));
353         crowdsaleFinished = true;
354     }
355 
356     function doPurchase(address _owner) private onlyAfter(startTime) onlyBefore(endTime) {
357         
358         assert(crowdsaleFinished == false);
359 
360         if (collected.add(msg.value) > hardCap) throw;
361 
362         if (!softCapReached && collected < softCap && collected.add(msg.value) >= softCap) {
363             softCapReached = true;
364             SoftCapReached(softCap);
365         }
366 
367         uint tokens = msg.value * price;
368         if (token.balanceOf(msg.sender) + tokens > purchaseLimit) throw;
369 
370         if (token.balanceOf(msg.sender) == 0) investorCount++;
371       
372         collected = collected.add(msg.value);
373 
374         token.transfer(msg.sender, tokens);
375 
376         weiRaised = weiRaised.add(msg.value);
377         tokensSold = tokensSold.add(tokens);
378 
379         NewContribution(_owner, tokens, msg.value);
380 
381         if (collected == hardCap) {
382             GoalReached(hardCap);
383         }
384     }
385 }