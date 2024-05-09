1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * SafeMath
6  * Math operations with safety checks that throw on error
7  */
8  
9 library SafeMath {
10   
11     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal constant returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25     assert(b <= a);
26     return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33     }
34     
35     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a >= b ? a : b;
37     }
38 
39     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41     }
42 
43     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
44     return a < b ? a : b;
45     }
46 
47     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
48     return a < b ? a : b;
49     }
50     
51 }
52 
53 /**
54  * title ERC20 interface
55  * dev see https://github.com/ethereum/EIPs/issues/20
56  */
57 contract ERC20 {
58     uint256 public totalSupply;
59     bool public transferlocked;
60     bool public wallocked;
61     function balanceOf(address who) constant returns (uint256 balance);
62     function transfer(address _to, uint256 _value) returns (bool success);
63     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
64     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
65     function approve(address spender, uint256 value) returns (bool success);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68     event Burn(address indexed burner, uint indexed value);
69 }
70 
71 /**
72  * Basic token
73  * Basic version of StandardToken, with no allowances.
74  */
75 
76  
77 contract BasicToken is ERC20 {
78     using SafeMath for uint256;
79 
80     mapping(address => uint256) balances;
81 
82     /**
83     * transfer token for a specified address
84     * _to The address to transfer to.
85     * _value The amount to be transferred.
86     */
87     function transfer(address _to, uint256 _value) returns (bool success) {
88         require(
89             balances[msg.sender] >= _value
90             && _value > 0
91             );
92         if (transferlocked) {
93             throw;
94         }
95         balances[msg.sender] = balances[msg.sender].sub(_value);
96         balances[_to] = balances[_to].add(_value);
97         Transfer(msg.sender, _to, _value);
98         return true;
99     }
100 
101     /**
102     *  Gets the balance of the specified address.
103     *  _owner The address to query the the balance of.
104     *  An uint256 representing the amount owned by the passed address.
105     */
106     function balanceOf(address _owner) constant returns (uint256 balance) {
107         return balances[_owner];
108     }
109 
110 }
111 
112 /**
113  *  Ownable
114  * The Ownable contract has an owner address, and provides basic authorization control
115  * functions, this simplifies the implementation of "user permissions".
116  * Thanks https://github.com/OpenZeppelin/zeppelin-solidity/
117  */
118 contract Ownable {
119     address public owner;
120 
121     /**
122      * The Ownable constructor sets the original `owner` of the contract to the sender
123      * account.
124      */
125     function Ownable() {
126         owner = msg.sender;
127     }
128 
129     /**
130      * Throws if called by any account other than the owner.
131      */
132     modifier onlyOwner() {
133         assert(msg.sender == owner);
134         _;
135     }
136 
137     /**
138      * Allows the current owner to transfer control of the contract to a newOwner.
139      * newOwner The address to transfer ownership to.
140      */
141     function transferOwnership(address newOwner) onlyOwner {
142         if (newOwner != address(0)) {
143             owner = newOwner;
144         }
145     }
146 }
147 
148 /**
149  * Standard ERC20 token
150  *
151  * Implementation of the basic standard token.
152  * https://github.com/ethereum/EIPs/issues/20
153  */
154 contract StandardToken is BasicToken {
155 
156     mapping (address => mapping (address => uint256)) allowed;
157 
158 
159     /**
160      * Transfer tokens from one address to another
161      * _from address The address which you want to send tokens from
162      * _to address The address which you want to transfer to
163      * _value uint256 the amout of tokens to be transfered
164      */
165     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
166         require(
167             allowed[_from][msg.sender] >=_value
168             && balances[_from] >= _value
169             && _value > 0
170             );
171         if (transferlocked) {
172             throw;
173         }
174 
175         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
176         // require (_value <= _allowed);
177 
178         balances[_to] = balances[_to].add(_value);
179         balances[_from] = balances[_from].sub(_value);
180         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
181         Transfer(_from, _to, _value);
182         return true;
183     }
184 
185     /**
186      * Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
187      * _spender The address which will spend the funds.
188      * _value The -amount of tokens to be spent.
189      */
190     function approve(address _spender, uint256 _value) returns (bool) {
191 
192         // To change the approve amount you first have to reduce the addresses`
193         //  allowance to zero by calling `approve(_spender, 0)` if it is not
194         //  already 0 to mitigate the race condition described here:
195         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
197         if (transferlocked) {
198             throw;
199         }
200         allowed[msg.sender][_spender] = _value;
201         Approval(msg.sender, _spender, _value);
202         return true;
203     }
204 
205     /**
206      * Function to check the amount of tokens that an owner allowed to a spender.
207      * _owner address The address which owns the funds.
208      * _spender address The address which will spend the funds.
209      * A uint256 specifing the amount of tokens still avaible for the spender.
210      */
211     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
212         return allowed[_owner][_spender];
213     }
214 
215 
216 }
217 
218 /**
219  * Mintable token
220  * Simple ERC20 Token example, with mintable token creation
221  * Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
222  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
223  */
224 
225 contract MintburnToken is StandardToken, Ownable {
226   event Mint(address indexed to, uint256 amount);
227   event MintFinished();
228 
229   bool public mintingFinished = false;
230 
231 
232   modifier canMint() {
233     require(!mintingFinished);
234     _;
235   }
236 
237   /**
238    * Function to mint tokens
239    * _to The address that will receive the minted tokens.
240    * _amount The amount of tokens to mint.
241    * A boolean that indicates if the operation was successful.
242    */
243    
244   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
245     totalSupply = totalSupply.add(_amount);
246     balances[_to] = balances[_to].add(_amount);
247     Mint(_to, _amount);
248     Transfer(0x0, _to, _amount);
249     return true;
250   }
251   
252   /**
253    *  Burn away the specified amount of CareerXon tokens
254   */
255   
256   function burn(uint256 _value) onlyOwner returns (bool) {
257     balances[msg.sender] = balances[msg.sender].sub(_value);
258     totalSupply = totalSupply.sub(_value);
259     Transfer(msg.sender, 0x0, _value);
260     return true;
261   }
262    function burnFrom(address _from, uint256 _value) onlyOwner returns (bool success) {
263         require(balances[_from] >= _value);                // Check if the targeted balance is enough
264         require(_value <= allowed[_from][msg.sender]);    // Check allowance
265         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
266         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
267         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
268         Burn(_from, _value);
269         return true;
270     }
271 
272   /**
273    * Function to stop minting new tokens.
274    * True if the operation was successful.
275    */
276    
277   function finishMinting() onlyOwner returns (bool) {
278     mintingFinished = true;
279     MintFinished();
280     return true;
281   }
282 }
283 
284 /**
285  * CRN (CareerXon) Token
286  *
287  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20 with the addition 
288  * of ownership, a lock and issuing.
289  *
290  * created 08/20/2017
291  * 
292  */
293 
294 contract CareerXonToken is MintburnToken{
295     string public constant name = "CareerXon";
296     string public constant symbol = "CRN";
297     uint public constant decimals = 18;
298     string public standard = "Token 0.1";
299     uint256 public maxSupply = 1500000000000000000000000;
300     //15,000,000 CareerXon tokens max supply
301 
302     // timestamps for first presale and ICO
303     uint public startPreSale;
304     uint public endPreSale;
305     uint public startICO;
306     uint public endICO;
307 
308 
309 
310     // how many token units a buyer gets per wei
311     uint256 public rate;
312 
313     uint256 public minTransactionAmount;
314 
315     uint256 public raisedForEther = 0;
316 
317     modifier inActivePeriod() {
318         require((startPreSale < now && now <= endPreSale) || (startICO < now && now <= endICO));
319         _;
320     }
321     
322     //prevent short address attack
323 
324     modifier onlyPayloadSize(uint size) {
325         if(msg.data.length < size + 4) revert();
326         _;
327 
328     }
329 
330     function CareerXonToken(uint _startP, uint _endP, uint _startI, uint _endI) {
331         require(_startP < _endP);
332         require(_startI < _endI);
333         
334 
335         //12,900,000 for eth supply
336         //2,000,000 for bitcoin and bitcoin cash sales supply minted
337         //100,000 for bounty and transalation minted
338         //After all these distribution, Remaining minted coins will be burned.
339         totalSupply = 12900000000000000000000000;
340 
341 
342         // 1 ETH = 1300 CareerXon + 50% bonus in presale on first day
343         rate = 1300;
344 
345         // minimal invest 0.01 ETH
346         minTransactionAmount = 0.01 ether;
347 
348         startPreSale = _startP;
349         endPreSale = _endP;
350         startICO = _startI;
351         endICO = _endI;
352         transferlocked = true;
353         // wallet withdrawal lock for protection
354         wallocked = true;
355 
356     }
357     
358     modifier onlyOwner() {
359         require(msg.sender == owner);
360         _;
361     }
362     
363     //Allows owner to stop & start presale.
364     //For PreSale starting date visit http://careerxon.com.
365     
366     function setupPeriodForPreSale(uint _start, uint _end) onlyOwner {
367         require(_start < _end);
368         startPreSale = _start;
369         endPreSale = _end;
370     }
371     
372     //For ICO and project details visit http://careerxon.com
373     //Total Amount to be sold 15,000,000
374     //Left over OR unsold coins will be burned.
375     
376     function setupPeriodForICO(uint _start, uint _end) onlyOwner {
377         require(_start < _end);
378         startICO = _start;
379         endICO = _end;
380     }
381 
382     // fallback function can be used to buy tokens
383     function () inActivePeriod payable {
384         buyTokens(msg.sender);
385     }
386 
387     // token auto purchase function
388     function buyTokens(address _youraddress) inActivePeriod payable {
389         require(_youraddress != 0x0);
390         require(msg.value >= minTransactionAmount);
391 
392         uint256 weiAmount = msg.value;
393 
394         raisedForEther = raisedForEther.add(weiAmount);
395 
396         // calculate token amount to be created
397         uint256 tokens = weiAmount.mul(rate);
398         tokens += getBonus(tokens);
399         tokens += getBonustwo(tokens);
400 
401         tokenReserved(_youraddress, tokens);
402 
403     }
404     
405     function withdraw(uint256 _value) onlyOwner returns (bool){
406         if (wallocked) {
407             throw;
408         }
409         owner.transfer(_value);
410         return true;
411     }
412     function walunlock() onlyOwner returns (bool success)  {
413         wallocked = false;
414         return true;
415     }
416     function wallock() onlyOwner returns (bool success)  {
417         wallocked = true;
418         return true;
419     }
420 
421     /*
422     *    PreSale:
423     *        Day 1: +50% bonus
424     *        Day 2: +33% bonus
425     *        Day 3: +20% bonus
426     *        Day 4: +10% bonus
427     */
428     function getBonus(uint256 _tokens) constant returns (uint256 bonus) {
429         require(_tokens != 0);
430         if (1 == getCurrentPeriod()) {
431             if (startPreSale <= now && now < startPreSale + 1 days) {
432                 return _tokens.div(2);
433             } else if (startPreSale + 1 days <= now && now < startPreSale + 2 days ) {
434                 return _tokens.div(3);
435             } else if (startPreSale + 2 days <= now && now < startPreSale + 3 days ) {
436                 return _tokens.div(5);
437             }else if (startPreSale + 3 days <= now && now < startPreSale + 4 days ) {
438                 return _tokens.div(10);
439             }
440         }
441         return 0;
442     }
443         
444     /*
445     *    ICO:
446     *        Day 1: +20% bonus
447     *        Day 2: +10% bonus
448     *        Day 3: +5% bonus
449     *        Day 4 & onwards: No bonuses
450     */
451     function getBonustwo(uint256 _tokens) constant returns (uint256 bonus) {
452         require(_tokens != 0);
453         if (2 == getCurrentPeriod()) {
454             if (startICO <= now && now < startICO + 1 days) {
455                 return _tokens.div(5);
456             } else if (startICO + 1 days <= now && now < startICO + 2 days ) {
457                 return _tokens.div(10);
458             } else if (startICO + 2 days <= now && now < startICO + 3 days ) {
459                 return _tokens.mul(5).div(100);
460             }
461         }
462     // Return 0 means token sales are closed
463         return 0;
464     }
465 
466     //start date & end date of presale and future ICO
467     function getCurrentPeriod() inActivePeriod constant returns (uint){
468         if ((startPreSale < now && now <= endPreSale)) {
469             return 1;
470         } else if ((startICO < now && now <= endICO)) {
471             return 2;
472         } else {
473             return 0;
474         }
475     }
476 
477     function tokenReserved(address _to, uint256 _value) internal returns (bool) {
478         balances[_to] = balances[_to].add(_value);
479         Transfer(msg.sender, _to, _value);
480         return true;
481     }
482     // token transfer lock. Unlock at end of Presale,ICO
483     
484     function transferunlock() onlyOwner returns (bool success)  {
485         transferlocked = false;
486         return true;
487     }
488     function transferlock() onlyOwner returns (bool success)  {
489         transferlocked = true;
490         return true;
491     }
492 }