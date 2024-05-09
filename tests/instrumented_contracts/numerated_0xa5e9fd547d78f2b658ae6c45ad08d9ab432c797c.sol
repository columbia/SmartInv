1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal constant returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41     address public owner;
42 
43 
44     /**
45      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46      * account.
47      */
48     function Ownable() {
49         owner = msg.sender;
50     }
51 
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address newOwner) onlyOwner {
67         if (newOwner != address(0)) {
68             owner = newOwner;
69         }
70     }
71 
72 }
73 
74 
75 /*
76  * Haltable
77  *
78  * Abstract contract that allows children to implement an
79  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
80  *
81  *
82  * Originally envisioned in FirstBlood ICO contract.
83  */
84 contract Haltable is Ownable {
85     bool public halted;
86 
87     modifier stopInEmergency {
88         require(!halted);
89         _;
90     }
91 
92     modifier onlyInEmergency {
93         require(halted);
94         _;
95     }
96 
97     // called by the owner on emergency, triggers stopped state
98     function halt() external onlyOwner {
99         halted = true;
100     }
101 
102     // called by the owner on end of emergency, returns to normal state
103     function unhalt() external onlyOwner onlyInEmergency {
104         halted = false;
105     }
106 
107 }
108 
109 
110 /**
111  * @title ERC20Basic
112  * @dev Simpler version of ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/179
114  */
115 contract ERC20Basic {
116     uint256 public totalSupply;
117 
118     function balanceOf(address who) constant returns (uint256);
119 
120     function transfer(address to, uint256 value) returns (bool);
121 
122     event Transfer(address indexed from, address indexed to, uint256 value);
123 }
124 
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131     function allowance(address owner, address spender) constant returns (uint256);
132 
133     function transferFrom(address from, address to, uint256 value) returns (bool);
134 
135     function approve(address spender, uint256 value) returns (bool);
136 
137     event Approval(address indexed owner, address indexed spender, uint256 value);
138 }
139 
140 
141 /**
142  * @title Basic token
143  * @dev Basic version of StandardToken, with no allowances.
144  */
145 contract BasicToken is ERC20Basic {
146     using SafeMath for uint256;
147 
148     mapping (address => uint256) balances;
149 
150     /**
151     * @dev transfer token for a specified address
152     * @param _to The address to transfer to.
153     * @param _value The amount to be transferred.
154     */
155     function transfer(address _to, uint256 _value) returns (bool) {
156         balances[msg.sender] = balances[msg.sender].sub(_value);
157         balances[_to] = balances[_to].add(_value);
158         Transfer(msg.sender, _to, _value);
159         return true;
160     }
161 
162     /**
163     * @dev Gets the balance of the specified address.
164     * @param _owner The address to query the the balance of.
165     * @return An uint256 representing the amount owned by the passed address.
166     */
167     function balanceOf(address _owner) constant returns (uint256 balance) {
168         return balances[_owner];
169     }
170 
171 }
172 
173 
174 /**
175  * @title Standard ERC20 token
176  *
177  * @dev Implementation of the basic standard token.
178  * @dev https://github.com/ethereum/EIPs/issues/20
179  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
180  */
181 contract StandardToken is ERC20, BasicToken {
182 
183     mapping (address => mapping (address => uint256)) allowed;
184 
185 
186     /**
187      * @dev Transfer tokens from one address to another
188      * @param _from address The address which you want to send tokens from
189      * @param _to address The address which you want to transfer to
190      * @param _value uint256 the amout of tokens to be transfered
191      */
192     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
193         var _allowance = allowed[_from][msg.sender];
194 
195         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
196         // require (_value <= _allowance);
197 
198         balances[_to] = balances[_to].add(_value);
199         balances[_from] = balances[_from].sub(_value);
200         allowed[_from][msg.sender] = _allowance.sub(_value);
201         Transfer(_from, _to, _value);
202         return true;
203     }
204 
205     /**
206      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
207      * @param _spender The address which will spend the funds.
208      * @param _value The amount of tokens to be spent.
209      */
210     function approve(address _spender, uint256 _value) returns (bool) {
211 
212         // To change the approve amount you first have to reduce the addresses`
213         //  allowance to zero by calling `approve(_spender, 0)` if it is not
214         //  already 0 to mitigate the race condition described here:
215         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
216         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
217 
218         allowed[msg.sender][_spender] = _value;
219         Approval(msg.sender, _spender, _value);
220         return true;
221     }
222 
223     /**
224      * @dev Function to check the amount of tokens that an owner allowed to a spender.
225      * @param _owner address The address which owns the funds.
226      * @param _spender address The address which will spend the funds.
227      * @return A uint256 specifing the amount of tokens still avaible for the spender.
228      */
229     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
230         return allowed[_owner][_spender];
231     }
232 
233 }
234 
235 
236 /**
237  * @title VeraCoin
238  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
239  * Note they can later distribute these tokens as they wish using `transfer` and other
240  * `StandardToken` functions.
241  */
242 contract VeraCoin is StandardToken {
243 
244     string public name = "VeraCoin";
245 
246     string public symbol = "Vera";
247 
248     uint256 public decimals = 18;
249 
250     uint256 public INITIAL_SUPPLY = 15700000 * 1 ether;
251 
252     /**
253     * @dev Contructor that gives msg.sender all of existing tokens.
254     */
255     function VeraCoin() {
256         totalSupply = INITIAL_SUPPLY;
257         balances[msg.sender] = INITIAL_SUPPLY;
258     }
259 }
260 
261 
262 contract VeraCoinPreSale is Haltable {
263     using SafeMath for uint;
264 
265     string public name = "VeraCoin PreSale";
266 
267     VeraCoin public token;
268 
269     address public beneficiary;
270 
271     uint256 public hardCap;
272 
273     uint256 public softCap;
274 
275     uint256 public collected;
276 
277     uint256 public price;
278 
279     uint256 public tokensSold = 0;
280 
281     uint256 public weiRaised = 0;
282 
283     uint256 public investorCount = 0;
284 
285     uint256 public weiRefunded = 0;
286 
287     uint256 public startTime;
288 
289     uint256 public endTime;
290 
291     bool public softCapReached = false;
292 
293     bool public crowdsaleFinished = false;
294 
295     mapping (address => bool) refunded;
296 
297     event GoalReached(uint256 amountRaised);
298 
299     event SoftCapReached(uint256 softCap);
300 
301     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
302 
303     event Refunded(address indexed holder, uint256 amount);
304 
305     modifier onlyAfter(uint256 time) {
306         require(now >= time);
307         _;
308     }
309 
310     modifier onlyBefore(uint256 time) {
311         require(now <= time);
312         _;
313     }
314 
315     function VeraCoinPreSale(
316     uint256 _hardCapUSD,
317     uint256 _softCapUSD,
318     address _token,
319     address _beneficiary,
320     uint256 _totalTokens,
321     uint256 _priceETH,
322 
323     uint256 _startTime,
324     uint256 _duration
325     ) {
326         hardCap = _hardCapUSD * 1 ether / _priceETH;
327         softCap = _softCapUSD * 1 ether / _priceETH;
328         price = _totalTokens * 1 ether / hardCap;
329 
330         token = VeraCoin(_token);
331         beneficiary = _beneficiary;
332 
333         startTime = _startTime;
334         endTime = _startTime + _duration * 1 hours;
335     }
336 
337     function() payable stopInEmergency {
338         require(msg.value >= 0.01 * 1 ether);
339         doPurchase(msg.sender);
340     }
341 
342     function refund() external onlyAfter(endTime) {
343         require(!softCapReached);
344         require(!refunded[msg.sender]);
345 
346         uint256 balance = token.balanceOf(msg.sender);
347         require(balance > 0);
348 
349         uint256 refund = balance / price;
350         if (refund > this.balance) {
351             refund = this.balance;
352         }
353 
354         require(msg.sender.send(refund));
355         refunded[msg.sender] = true;
356         weiRefunded = weiRefunded.add(refund);
357         Refunded(msg.sender, refund);
358     }
359 
360     function withdraw() onlyOwner {
361         require(softCapReached);
362         require(beneficiary.send(collected));
363         token.transfer(beneficiary, token.balanceOf(this));
364         crowdsaleFinished = true;
365     }
366 
367     function doPurchase(address _owner) private onlyAfter(startTime) onlyBefore(endTime) {
368         require(!crowdsaleFinished);
369         require(collected.add(msg.value) <= hardCap);
370 
371         if (!softCapReached && collected < softCap && collected.add(msg.value) >= softCap) {
372             softCapReached = true;
373             SoftCapReached(softCap);
374         }
375 
376         uint256 tokens = msg.value * price;
377 
378         if (token.balanceOf(msg.sender) == 0) investorCount++;
379 
380         collected = collected.add(msg.value);
381 
382         token.transfer(msg.sender, tokens);
383 
384         weiRaised = weiRaised.add(msg.value);
385         tokensSold = tokensSold.add(tokens);
386 
387         NewContribution(_owner, tokens, msg.value);
388 
389         if (collected == hardCap) {
390             GoalReached(hardCap);
391         }
392     }
393 }