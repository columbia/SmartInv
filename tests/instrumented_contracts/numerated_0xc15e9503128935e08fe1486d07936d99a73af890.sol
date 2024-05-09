1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39     address public owner;
40 
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45     /**
46      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47      * account.
48      */
49     function Ownable() {
50         owner = msg.sender;
51     }
52 
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62 
63     /**
64      * @dev Allows the current owner to transfer control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function transferOwnership(address newOwner) onlyOwner public {
68         require(newOwner != address(0));
69         OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71     }
72 
73 }
74 
75 /**
76  * @title Pausable
77  * @dev Base contract which allows children to implement an emergency stop mechanism.
78  */
79 contract Pausable is Ownable {
80     event Pause();
81     event Unpause();
82 
83     bool public paused = false;
84 
85 
86     /**
87      * @dev Modifier to make a function callable only when the contract is not paused.
88      */
89     modifier whenNotPaused() {
90         require(!paused);
91         _;
92     }
93 
94     /**
95      * @dev Modifier to make a function callable only when the contract is paused.
96      */
97     modifier whenPaused() {
98         require(paused);
99         _;
100     }
101 
102     /**
103      * @dev called by the owner to pause, triggers stopped state
104      */
105     function pause() onlyOwner whenNotPaused public {
106         paused = true;
107         Pause();
108     }
109 
110     /**
111      * @dev called by the owner to unpause, returns to normal state
112      */
113     function unpause() onlyOwner whenPaused public {
114         paused = false;
115         Unpause();
116     }
117 }
118 
119 /**
120  * @title ERC20Basic
121  * @dev Simpler version of ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/179
123  */
124 contract ERC20Basic {
125     uint256 public totalSupply;
126     function balanceOf(address who) public constant returns (uint256);
127     function transfer(address to, uint256 value) public returns (bool);
128     event Transfer(address indexed from, address indexed to, uint256 value);
129 }
130 
131 /**
132  * @title Basic token
133  * @dev Basic version of StandardToken, with no allowances.
134  */
135 contract BasicToken is ERC20Basic {
136     using SafeMath for uint256;
137 
138     mapping(address => uint256) balances;
139 
140     /**
141     * @dev transfer token for a specified address
142     * @param _to The address to transfer to.
143     * @param _value The amount to be transferred.
144     */
145     function transfer(address _to, uint256 _value) public returns (bool) {
146         require(_to != address(0));
147         require(_value <= balances[msg.sender]);
148 
149         // SafeMath.sub will throw if there is not enough balance.
150         balances[msg.sender] = balances[msg.sender].sub(_value);
151         balances[_to] = balances[_to].add(_value);
152         Transfer(msg.sender, _to, _value);
153         return true;
154     }
155 
156     /**
157     * @dev Gets the balance of the specified address.
158     * @param _owner The address to query the the balance of.
159     * @return An uint256 representing the amount owned by the passed address.
160     */
161     function balanceOf(address _owner) public constant returns (uint256 balance) {
162         return balances[_owner];
163     }
164 
165 }
166 
167 /**
168  * @title ERC20 interface
169  * @dev see https://github.com/ethereum/EIPs/issues/20
170  */
171 contract ERC20 is ERC20Basic {
172     function allowance(address owner, address spender) public constant returns (uint256);
173     function transferFrom(address from, address to, uint256 value) public returns (bool);
174     function approve(address spender, uint256 value) public returns (bool);
175     event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * @dev https://github.com/ethereum/EIPs/issues/20
183  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  */
185 contract StandardToken is ERC20, BasicToken {
186 
187     mapping (address => mapping (address => uint256)) internal allowed;
188 
189 
190     /**
191      * @dev Transfer tokens from one address to another
192      * @param _from address The address which you want to send tokens from
193      * @param _to address The address which you want to transfer to
194      * @param _value uint256 the amount of tokens to be transferred
195      */
196     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
197         require(_to != address(0));
198         require(_value <= balances[_from]);
199         require(_value <= allowed[_from][msg.sender]);
200 
201         balances[_from] = balances[_from].sub(_value);
202         balances[_to] = balances[_to].add(_value);
203         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
204         Transfer(_from, _to, _value);
205         return true;
206     }
207 
208     /**
209      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
210      *
211      * Beware that changing an allowance with this method brings the risk that someone may use both the old
212      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
213      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
214      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215      * @param _spender The address which will spend the funds.
216      * @param _value The amount of tokens to be spent.
217      */
218     function approve(address _spender, uint256 _value) public returns (bool) {
219         allowed[msg.sender][_spender] = _value;
220         Approval(msg.sender, _spender, _value);
221         return true;
222     }
223 
224     /**
225      * @dev Function to check the amount of tokens that an owner allowed to a spender.
226      * @param _owner address The address which owns the funds.
227      * @param _spender address The address which will spend the funds.
228      * @return A uint256 specifying the amount of tokens still available for the spender.
229      */
230     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
231         return allowed[_owner][_spender];
232     }
233 
234     /**
235      * approve should be called when allowed[_spender] == 0. To increment
236      * allowed value is better to use this function to avoid 2 calls (and wait until
237      * the first transaction is mined)
238      * From MonolithDAO Token.sol
239      */
240     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
241         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
242         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243         return true;
244     }
245 
246     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
247         uint oldValue = allowed[msg.sender][_spender];
248         if (_subtractedValue > oldValue) {
249             allowed[msg.sender][_spender] = 0;
250         } else {
251             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252         }
253         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254         return true;
255     }
256 
257 }
258 
259 contract IRateOracle {
260     function converted(uint256 weis) external constant returns (uint256);
261 }
262 
263 contract PynToken is StandardToken, Ownable {
264 
265     string public constant name = "Paycentos Token";
266     string public constant symbol = "PYN";
267     uint256 public constant decimals = 18;
268     uint256 public totalSupply = 450000000 * (uint256(10) ** decimals);
269 
270     mapping(address => bool) public specialAccounts;
271 
272     function PynToken(address wallet) public {
273         balances[wallet] = totalSupply;
274         specialAccounts[wallet]=true;
275         Transfer(0x0, wallet, totalSupply);
276     }
277 
278     function addSpecialAccount(address account) external onlyOwner {
279         specialAccounts[account] = true;
280     }
281 
282     bool public firstSaleComplete;
283 
284     function markFirstSaleComplete() public {
285         if (specialAccounts[msg.sender]) {
286             firstSaleComplete = true;
287         }
288     }
289 
290     function isOpen() public constant returns (bool) {
291         return firstSaleComplete || specialAccounts[msg.sender];
292     }
293 
294     function transfer(address _to, uint _value) public returns (bool) {
295         return isOpen() && super.transfer(_to, _value);
296     }
297 
298     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
299         return isOpen() && super.transferFrom(_from, _to, _value);
300     }
301 
302 
303     event Burn(address indexed burner, uint256 value);
304 
305     /**
306      * @dev Burns a specific amount of tokens.
307      * @param _value The amount of token to be burned.
308      */
309     function burn(uint256 _value) public {
310         require(_value >= 0);
311         require(_value <= balances[msg.sender]);
312         // no need to require value <= totalSupply, since that would imply the
313         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
314 
315         address burner = msg.sender;
316         balances[burner] = balances[burner].sub(_value);
317         totalSupply = totalSupply.sub(_value);
318         Burn(burner, _value);
319     }
320 
321 }
322 
323 
324 contract PynTokenCrowdsale is Pausable {
325     using SafeMath for uint256;
326 
327     uint256 public totalRaised;
328     //Crowdsale start
329     uint256 public startTimestamp;
330     //Crowdsale duration: 30 days
331     uint256 public duration = 28 days;
332     //adress of Oracle with ETH to PYN rate
333     IRateOracle public rateOracle;
334     //Address of wallet
335     address public fundsWallet;
336     // token contract
337     PynToken public token;
338     // bonus applied: 127 means additional 27%
339     uint16 public bonus1;
340     uint16 public bonus2;
341     uint16 public bonus3;
342     // if true bonus applied to every purchase, otherwise only if msg.sender already has some PYN tokens
343     bool public bonusForEveryone;
344 
345     function PynTokenCrowdsale(
346     address _fundsWallet,
347     address _pynToken,
348     uint256 _startTimestamp,
349     address _rateOracle,
350     uint16 _bonus1,
351     uint16 _bonus2,
352     uint16 _bonus3,
353     bool _bonusForEveryone) public {
354         fundsWallet = _fundsWallet;
355         token = PynToken(_pynToken);
356         startTimestamp = _startTimestamp;
357         rateOracle = IRateOracle(_rateOracle);
358         bonus1 = _bonus1;
359         bonus2 = _bonus2;
360         bonus3 = _bonus3;
361         bonusForEveryone = _bonusForEveryone;
362     }
363 
364     bool internal capReached;
365 
366     function isCrowdsaleOpen() public constant returns (bool) {
367         return !capReached && now >= startTimestamp && now <= startTimestamp + duration;
368     }
369 
370     modifier isOpen() {
371         require(isCrowdsaleOpen());
372         _;
373     }
374 
375 
376     function() public payable {
377         buyTokens();
378     }
379 
380     function buyTokens() public isOpen whenNotPaused payable {
381 
382         uint256 payedEther = msg.value;
383         uint256 acceptedEther = 0;
384         uint256 refusedEther = 0;
385 
386         uint256 expected = calculateTokenAmount(payedEther);
387         uint256 available = token.balanceOf(this);
388         uint256 transfered = 0;
389 
390         if (available < expected) {
391             acceptedEther = payedEther.mul(available).div(expected);
392             refusedEther = payedEther.sub(acceptedEther);
393             transfered = available;
394             capReached = true;
395         } else {
396             acceptedEther = payedEther;
397             transfered = expected;
398         }
399 
400         totalRaised = totalRaised.add(acceptedEther);
401 
402         token.transfer(msg.sender, transfered);
403         fundsWallet.transfer(acceptedEther);
404         if (refusedEther > 0) {
405             msg.sender.transfer(refusedEther);
406         }
407     }
408 
409     function calculateTokenAmount(uint256 weiAmount) public constant returns (uint256) {
410         uint256 converted = rateOracle.converted(weiAmount);
411         if (bonusForEveryone || token.balanceOf(msg.sender) > 0) {
412 
413             if (now <= startTimestamp + 10 days) {
414                 if (now <= startTimestamp + 5 days) {
415                     if (now <= startTimestamp + 2 days) {
416                         //+27% bonus during first 2 days
417                         return converted.mul(bonus1).div(100);
418                     }
419                     //+18% bonus during day 3 - 5
420                     return converted.mul(bonus2).div(100);
421                 }
422                 //+12% bonus during day 6 - 10
423                 return converted.mul(bonus3).div(100);
424             }
425         }
426         return converted;
427     }
428 
429     function success() public returns (bool) {
430         require(now > startTimestamp);
431         uint256 balance = token.balanceOf(this);
432         if (balance == 0) {
433             capReached = true;
434             token.markFirstSaleComplete();
435             return true;
436         }
437 
438         if (now >= startTimestamp + duration) {
439             token.burn(balance);
440             capReached = true;
441             token.markFirstSaleComplete();
442             return true;
443         }
444 
445         return false;
446     }
447 }