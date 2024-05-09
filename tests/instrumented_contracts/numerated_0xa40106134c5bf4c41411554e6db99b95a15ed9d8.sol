1 pragma solidity ^0.4.20;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57     function totalSupply() public view returns (uint256);
58     function balanceOf(address who) public view returns (uint256);
59     function transfer(address to, uint256 value) public returns (bool);
60     event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20 is ERC20Basic {
69     function allowance(address owner, address spender) public view returns (uint256);
70     function transferFrom(address from, address to, uint256 value) public returns (bool);
71     function approve(address spender, uint256 value) public returns (bool);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 
76 /**
77  * @title Basic token
78  * @dev Basic version of StandardToken, with no allowances.
79  */
80 contract BasicToken is ERC20Basic {
81     using SafeMath for uint256;
82 
83     mapping(address => uint256) balances;
84 
85     uint256 totalSupply_;
86 
87     /**
88     * @dev total number of tokens in existence
89     */
90     function totalSupply() public view returns (uint256) {
91         return totalSupply_;
92     }
93 
94     /**
95     * @dev transfer token for a specified address
96     * @param _to The address to transfer to.
97     * @param _value The amount to be transferred.
98     */
99     function transfer(address _to, uint256 _value) public returns (bool) {
100         require(_to != address(0));
101         require(_value <= balances[msg.sender]);
102 
103         // SafeMath.sub will throw if there is not enough balance.
104         balances[msg.sender] = balances[msg.sender].sub(_value);
105         balances[_to] = balances[_to].add(_value);
106         Transfer(msg.sender, _to, _value);
107         return true;
108     }
109 
110     /**
111     * @dev Gets the balance of the specified address.
112     * @param _owner The address to query the the balance of.
113     * @return An uint256 representing the amount owned by the passed address.
114     */
115     function balanceOf(address _owner) public view returns (uint256 balance) {
116         return balances[_owner];
117     }
118 
119 }
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implementation of the basic standard token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is ERC20, BasicToken {
129 
130     mapping (address => mapping (address => uint256)) internal allowed;
131 
132 
133     /**
134      * @dev Transfer tokens from one address to another
135      * @param _from address The address which you want to send tokens from
136      * @param _to address The address which you want to transfer to
137      * @param _value uint256 the amount of tokens to be transferred
138      */
139     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140         require(_to != address(0));
141         require(_value <= balances[_from]);
142         require(_value <= allowed[_from][msg.sender]);
143 
144         balances[_from] = balances[_from].sub(_value);
145         balances[_to] = balances[_to].add(_value);
146         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147         Transfer(_from, _to, _value);
148         return true;
149     }
150 
151     /**
152      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153      *
154      * Beware that changing an allowance with this method brings the risk that someone may use both the old
155      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      * @param _spender The address which will spend the funds.
159      * @param _value The amount of tokens to be spent.
160      */
161     function approve(address _spender, uint256 _value) public returns (bool) {
162         allowed[msg.sender][_spender] = _value;
163         Approval(msg.sender, _spender, _value);
164         return true;
165     }
166 
167     /**
168      * @dev Function to check the amount of tokens that an owner allowed to a spender.
169      * @param _owner address The address which owns the funds.
170      * @param _spender address The address which will spend the funds.
171      * @return A uint256 specifying the amount of tokens still available for the spender.
172      */
173     function allowance(address _owner, address _spender) public view returns (uint256) {
174         return allowed[_owner][_spender];
175     }
176 
177     /**
178      * @dev Increase the amount of tokens that an owner allowed to a spender.
179      *
180      * approve should be called when allowed[_spender] == 0. To increment
181      * allowed value is better to use this function to avoid 2 calls (and wait until
182      * the first transaction is mined)
183      * From MonolithDAO Token.sol
184      * @param _spender The address which will spend the funds.
185      * @param _addedValue The amount of tokens to increase the allowance by.
186      */
187     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
188         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190         return true;
191     }
192 
193     /**
194      * @dev Decrease the amount of tokens that an owner allowed to a spender.
195      *
196      * approve should be called when allowed[_spender] == 0. To decrement
197      * allowed value is better to use this function to avoid 2 calls (and wait until
198      * the first transaction is mined)
199      * From MonolithDAO Token.sol
200      * @param _spender The address which will spend the funds.
201      * @param _subtractedValue The amount of tokens to decrease the allowance by.
202      */
203     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
204         uint oldValue = allowed[msg.sender][_spender];
205         if (_subtractedValue > oldValue) {
206             allowed[msg.sender][_spender] = 0;
207         } else {
208             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
209         }
210         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211         return true;
212     }
213 
214 }
215 
216 
217 /**
218  * @title Ownable
219  * @dev The Ownable contract has an owner address, and provides basic authorization control
220  * functions, this simplifies the implementation of "user permissions".
221  */
222 contract Ownable {
223     address public owner;
224 
225 
226     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
227 
228 
229     /**
230      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
231      * account.
232      */
233     function Ownable() public {
234         owner = msg.sender;
235     }
236 
237     /**
238      * @dev Throws if called by any account other than the owner.
239      */
240     modifier onlyOwner() {
241         require(msg.sender == owner);
242         _;
243     }
244 
245     /**
246      * @dev Allows the current owner to transfer control of the contract to a newOwner.
247      * @param newOwner The address to transfer ownership to.
248      */
249     function transferOwnership(address newOwner) public onlyOwner {
250         require(newOwner != address(0));
251         OwnershipTransferred(owner, newOwner);
252         owner = newOwner;
253     }
254 
255 }
256 
257 
258 /**
259  * @title Pausable
260  * @dev Base contract which allows children to implement an emergency stop mechanism.
261  */
262 contract Pausable is Ownable {
263     event Pause();
264 
265     event Unpause();
266 
267     bool public paused = false;
268 
269 
270     /**
271      * @dev Modifier to make a function callable only when the contract is not paused.
272      */
273     modifier whenNotPaused() {
274         require(!paused);
275         _;
276     }
277 
278     /**
279      * @dev Modifier to make a function callable only when the contract is paused.
280      */
281     modifier whenPaused() {
282         require(paused);
283         _;
284     }
285 
286     /**
287      * @dev called by the owner to pause, triggers stopped state
288      */
289     function pause() onlyOwner whenNotPaused public {
290         paused = true;
291         Pause();
292     }
293 
294     /**
295      * @dev called by the owner to unpause, returns to normal state
296      */
297     function unpause() onlyOwner whenPaused public {
298         paused = false;
299         Unpause();
300     }
301 }
302 
303 
304 contract MintableToken is StandardToken, Ownable, Pausable {
305 
306     event Mint(address indexed to, uint256 amount);
307 
308     event MintFinished();
309 
310     bool public mintingFinished = false;
311 
312     uint256 public maxTokensToMint = 25000000 ether;
313 
314     uint8 public currentRound = 1;
315 
316     struct Round {
317     uint256 total;
318     bool finished;
319     bool active;
320     uint256 issuedTokens;
321     uint256 startMinimumTime;
322     }
323 
324     Round[] rounds;
325 
326     modifier canMint() {
327         require(!mintingFinished);
328         require(rounds[currentRound-1].active);
329         _;
330     }
331 
332     /**
333     * @dev Function to mint tokens
334     * @param _to The address that will recieve the minted tokens.
335     * @param _amount The amount of tokens to mint.
336     * @return A boolean that indicates if the operation was successful.
337     */
338     function mint(address _to, uint256 _amount) whenNotPaused onlyOwner returns (bool) {
339         require(mintInternal(_to, _amount));
340         return true;
341     }
342 
343     /**
344     * @dev Function to stop minting new tokens.
345     * @return True if the operation was successful.
346     */
347     function finishMinting() whenNotPaused onlyOwner returns (bool) {
348         mintingFinished = true;
349         MintFinished();
350         return true;
351     }
352 
353     function mintInternal(address _to, uint256 _amount) internal canMint returns (bool) {
354         require(rounds[currentRound-1].issuedTokens.add(_amount) <= rounds[currentRound-1].total);
355         require(totalSupply_.add(_amount) <= maxTokensToMint);
356         totalSupply_ = totalSupply_.add(_amount);
357         rounds[currentRound-1].issuedTokens = rounds[currentRound-1].issuedTokens.add(_amount);
358         balances[_to] = balances[_to].add(_amount);
359         Mint(_to, _amount);
360         Transfer(address(0), _to, _amount);
361         return true;
362     }
363 }
364 
365 
366 contract Rock is MintableToken {
367 
368     string public constant name = "Rocket Token";
369 
370     string public constant symbol = "ROCK";
371 
372     bool public transferEnabled = false;
373 
374     uint8 public constant decimals = 18;
375 
376     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 amount);
377 
378     function Rock(){
379         Round memory roundone = Round({total : 4170000 ether, active: true, finished: false, issuedTokens : 0, startMinimumTime: 0});
380         Round memory roundtwo = Round({total : 6945000 ether, active: false, finished: false, issuedTokens : 0, startMinimumTime: 1534291200 });
381         Round memory roundthree = Round({total : 13885000 ether, active: false, finished: false, issuedTokens : 0, startMinimumTime: 0});
382         rounds.push(roundone);
383         rounds.push(roundtwo);
384         rounds.push(roundthree);
385     }
386 
387     /**
388     * @dev transfer token for a specified address
389     * @param _to The address to transfer to.
390     * @param _value The amount to be transferred.
391     */
392     function transfer(address _to, uint _value) whenNotPaused canTransfer returns (bool) {
393         require(_to != address(this));
394         return super.transfer(_to, _value);
395     }
396 
397     /**
398     * @dev Transfer tokens from one address to another
399     * @param _from address The address which you want to send tokens from
400     * @param _to address The address which you want to transfer to
401     * @param _value uint256 the amout of tokens to be transfered
402     */
403     function transferFrom(address _from, address _to, uint _value) whenNotPaused canTransfer returns (bool) {
404         require(_to != address(this));
405         return super.transferFrom(_from, _to, _value);
406     }
407 
408     /**
409      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
410      * @param _spender The address which will spend the funds.
411      * @param _value The amount of tokens to be spent.
412      */
413     function approve(address _spender, uint256 _value) whenNotPaused returns (bool) {
414         return super.approve(_spender, _value);
415     }
416 
417     /**
418      * @dev Modifier to make a function callable only when the transfer is enabled.
419      */
420     modifier canTransfer() {
421         require(transferEnabled);
422         _;
423     }
424 
425     /**
426     * @dev Function to start transfering tokens.
427     * @return True if the operation was successful.
428     */
429     function enableTransfer() onlyOwner returns (bool) {
430         transferEnabled = true;
431         return true;
432     }
433 
434     /**
435     * @dev Function to stop current round.
436     * @return True if the operation was successful.
437     */
438     function finishRound() onlyOwner returns (bool) {
439         require(currentRound - 1 < 3);
440         require(rounds[currentRound-1].active);
441 
442         uint256 tokensToBurn = rounds[currentRound-1].total.sub(rounds[currentRound-1].issuedTokens);
443 
444         rounds[currentRound-1].active = false;
445         rounds[currentRound-1].finished = true;
446         maxTokensToMint = maxTokensToMint.sub(tokensToBurn);
447 
448         return true;
449     }
450 
451     /**
452     * @dev Function to start new round.
453     * @return True if the operation was successful.
454     */
455     function startRound() onlyOwner returns (bool) {
456         require(currentRound - 1 < 2);
457         require(rounds[currentRound-1].finished);
458         if(rounds[currentRound].startMinimumTime > 0){
459             require(block.timestamp >= rounds[currentRound].startMinimumTime);
460         }
461 
462         currentRound ++;
463         rounds[currentRound-1].active = true;
464 
465         return true;
466     }
467 
468     function getCurrentRoundTotal() constant returns (uint256 total) {
469         return rounds[currentRound-1].total;
470     }
471 
472     function getCurrentRoundIsFinished() constant returns (bool) {
473         return rounds[currentRound-1].finished;
474     }
475 
476     function getCurrentRoundIsActive() constant returns (bool) {
477         return rounds[currentRound-1].active;
478     }
479 
480     function getCurrentRoundMinimumTime() constant returns (uint256) {
481         return rounds[currentRound-1].startMinimumTime;
482     }
483 
484     function getCurrentRoundIssued() constant returns (uint256 issued) {
485         return rounds[currentRound-1].issuedTokens;
486     }
487 
488 }