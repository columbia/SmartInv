1 pragma solidity ^0.4.11;
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
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39     uint256 public totalSupply;
40     function balanceOf(address who) constant returns (uint256);
41     function transfer(address to, uint256 value) returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50     function allowance(address owner, address spender) constant returns (uint256);
51     function transferFrom(address from, address to, uint256 value) returns (bool);
52     function approve(address spender, uint256 value) returns (bool);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61     using SafeMath for uint256;
62 
63     mapping(address => uint256) balances;
64 
65     /**
66     * @dev transfer token for a specified address
67     * @param _to The address to transfer to.
68     * @param _value The amount to be transferred.
69     */
70     function transfer(address _to, uint256 _value) returns (bool) {
71         balances[msg.sender] = balances[msg.sender].sub(_value);
72         balances[_to] = balances[_to].add(_value);
73         Transfer(msg.sender, _to, _value);
74         return true;
75     }
76 
77     /**
78     * @dev Gets the balance of the specified address.
79     * @param _owner The address to query the the balance of.
80     * @return An uint256 representing the amount owned by the passed address.
81     */
82     function balanceOf(address _owner) constant returns (uint256 balance) {
83         return balances[_owner];
84     }
85 
86 }
87 
88 /**
89  * @title Standard ERC20 token
90  *
91  * @dev Implementation of the basic standard token.
92  * @dev https://github.com/ethereum/EIPs/issues/20
93  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
94  */
95 contract StandardToken is ERC20, BasicToken {
96 
97     mapping (address => mapping (address => uint256)) allowed;
98 
99 
100     /**
101      * @dev Transfer tokens from one address to another
102      * @param _from address The address which you want to send tokens from
103      * @param _to address The address which you want to transfer to
104      * @param _value uint256 the amout of tokens to be transfered
105      */
106     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
107         var _allowance = allowed[_from][msg.sender];
108 
109         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
110         // require (_value <= _allowance);
111 
112         balances[_to] = balances[_to].add(_value);
113         balances[_from] = balances[_from].sub(_value);
114         allowed[_from][msg.sender] = _allowance.sub(_value);
115         Transfer(_from, _to, _value);
116         return true;
117     }
118 
119     /**
120      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
121      * @param _spender The address which will spend the funds.
122      * @param _value The amount of tokens to be spent.
123      */
124     function approve(address _spender, uint256 _value) returns (bool) {
125 
126         // To change the approve amount you first have to reduce the addresses`
127         //  allowance to zero by calling `approve(_spender, 0)` if it is not
128         //  already 0 to mitigate the race condition described here:
129         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131 
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137     /**
138      * @dev Function to check the amount of tokens that an owner allowed to a spender.
139      * @param _owner address The address which owns the funds.
140      * @param _spender address The address which will spend the funds.
141      * @return A uint256 specifing the amount of tokens still available for the spender.
142      */
143     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144         return allowed[_owner][_spender];
145     }
146 
147 }
148 
149 /**
150  * @title Ownable
151  * @dev The Ownable contract has an owner address, and provides basic authorization control
152  * functions, this simplifies the implementation of "user permissions".
153  */
154 contract Ownable {
155     address public owner;
156 
157 
158     /**
159      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160      * account.
161      */
162     function Ownable() {
163         owner = msg.sender;
164     }
165 
166 
167     /**
168      * @dev Throws if called by any account other than the owner.
169      */
170     modifier onlyOwner() {
171         require(msg.sender == owner);
172         _;
173     }
174 
175 
176     /**
177      * @dev Allows the current owner to transfer control of the contract to a newOwner.
178      * @param newOwner The address to transfer ownership to.
179      */
180     function transferOwnership(address newOwner) onlyOwner {
181         require(newOwner != address(0));
182         owner = newOwner;
183     }
184 
185 }
186 
187 /**
188  * @title Pausable
189  * @dev Base contract which allows children to implement an emergency stop mechanism.
190  */
191 contract Pausable is Ownable {
192     event Pause();
193     event Unpause();
194 
195     bool public paused = false;
196 
197 
198     /**
199      * @dev Modifier to make a function callable only when the contract is not paused.
200      */
201     modifier whenNotPaused() {
202         require(!paused);
203         _;
204     }
205 
206     /**
207      * @dev Modifier to make a function callable only when the contract is paused.
208      */
209     modifier whenPaused() {
210         require(paused);
211         _;
212     }
213 
214     /**
215      * @dev called by the owner to pause, triggers stopped state
216      */
217     function pause() onlyOwner whenNotPaused public {
218         paused = true;
219         Pause();
220     }
221 
222     /**
223      * @dev called by the owner to unpause, returns to normal state
224      */
225     function unpause() onlyOwner whenPaused public {
226         paused = false;
227         Unpause();
228     }
229 }
230 
231 contract MintableToken is StandardToken, Ownable, Pausable {
232     event Mint(address indexed to, uint256 amount);
233     event MintFinished();
234 
235     bool public mintingFinished = false;
236     uint256 public constant maxTokensToMint = 13600000 ether;
237 
238     modifier canMint() {
239         require(!mintingFinished);
240         _;
241     }
242 
243     /**
244     * @dev Function to mint tokens
245     * @param _to The address that will recieve the minted tokens.
246     * @param _amount The amount of tokens to mint.
247     * @return A boolean that indicates if the operation was successful.
248     */
249     function mint(address _to, uint256 _amount) whenNotPaused onlyOwner returns (bool) {
250         return mintInternal(_to, _amount);
251     }
252 
253     /**
254     * @dev Function to stop minting new tokens.
255     * @return True if the operation was successful.
256     */
257     function finishMinting() whenNotPaused onlyOwner returns (bool) {
258         mintingFinished = true;
259         MintFinished();
260         return true;
261     }
262 
263     function mintInternal(address _to, uint256 _amount) internal canMint returns (bool) {
264         require(totalSupply.add(_amount) <= maxTokensToMint);
265         totalSupply = totalSupply.add(_amount);
266         balances[_to] = balances[_to].add(_amount);
267         Mint(_to, _amount);
268         Transfer(this, _to, _amount);
269         return true;
270     }
271 }
272 
273 contract Tomb is MintableToken {
274 
275     string public constant name = "Token Care";
276 
277     string public constant symbol = "CARE";
278 
279     bool public transferEnabled = false;
280 
281     uint8 public constant decimals = 18;
282 
283     uint256 public rate = 5000;
284 
285     address public approvedUser = 0xE3baA70Ba9F7947a43fb01D349bBbe666c2833a5;
286 
287     address public wallet = 0xE3baA70Ba9F7947a43fb01D349bBbe666c2833a5;
288 
289     uint64 public dateStart = 1511987870;
290 
291     uint256 public constant maxTokenToBuy = 10000000 ether;
292 
293     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 amount);
294 
295 
296     /**
297     * @dev transfer token for a specified address
298     * @param _to The address to transfer to.
299     * @param _value The amount to be transferred.
300     */
301     function transfer(address _to, uint _value) whenNotPaused canTransfer returns (bool) {
302         require(_to != address(this) && _to != address(0));
303         return super.transfer(_to, _value);
304     }
305 
306     /**
307     * @dev Transfer tokens from one address to another
308     * @param _from address The address which you want to send tokens from
309     * @param _to address The address which you want to transfer to
310     * @param _value uint256 the amout of tokens to be transfered
311     */
312     function transferFrom(address _from, address _to, uint _value) whenNotPaused canTransfer returns (bool) {
313         require(_to != address(this) && _to != address(0));
314         return super.transferFrom(_from, _to, _value);
315     }
316 
317     /**
318      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
319      * @param _spender The address which will spend the funds.
320      * @param _value The amount of tokens to be spent.
321      */
322     function approve(address _spender, uint256 _value) whenNotPaused returns (bool) {
323         return super.approve(_spender, _value);
324     }
325 
326     /**
327      * @dev Modifier to make a function callable only when the transfer is enabled.
328      */
329     modifier canTransfer() {
330         require(transferEnabled);
331         _;
332     }
333 
334     modifier onlyOwnerOrApproved() {
335         require(msg.sender == owner || msg.sender == approvedUser);
336         _;
337     }
338 
339     /**
340     * @dev Function to stop transfering tokens.
341     * @return True if the operation was successful.
342     */
343     function enableTransfer() onlyOwner returns (bool) {
344         transferEnabled = true;
345         return true;
346     }
347 
348     function setApprovedUser(address _user) onlyOwner returns (bool) {
349         require(_user != address(0));
350         approvedUser = _user;
351         return true;
352     }
353 
354 
355     function changeRate(uint256 _rate) onlyOwnerOrApproved returns (bool) {
356         require(_rate > 0);
357         rate = _rate;
358         return true;
359     }
360 
361     function () payable {
362         buyTokens(msg.sender);
363     }
364 
365     function buyTokens(address beneficiary) whenNotPaused payable {
366         require(beneficiary != 0x0);
367         require(msg.value > 0);
368 
369         uint256 weiAmount = msg.value;
370 
371         // calculate token amount to be created
372         uint256 tokens = weiAmount.mul(rate);
373 
374         uint8 bonusDate = getBonusPercents();   //check date bonus
375         uint8 bonusSum = getSumBonusPercents(tokens);  //check summ bonus
376 
377         uint8 bonus = bonusDate + bonusSum;
378 
379         if(bonus > 0){
380             tokens += tokens * bonus / 100;    // add bonus
381         }
382 
383         require(totalSupply.add(tokens) <= maxTokenToBuy);
384 
385         mintInternal(beneficiary, tokens);
386 
387 
388         forwardFunds();
389     }
390 
391     // send ether to the fund collection wallet
392     function forwardFunds() internal {
393         wallet.transfer(msg.value);
394     }
395 
396 
397     function changeWallet(address _newWallet) onlyOwner returns (bool) {
398         require(_newWallet != 0x0);
399         wallet = _newWallet;
400         return true;
401     }
402 
403     function getBonusPercents() internal returns(uint8){
404         uint8 percents = 0;
405 
406         if(block.timestamp - dateStart < 7 days){  // first week
407             percents = 20;
408         }
409 
410         if(block.timestamp - dateStart < 1 days){   //first day
411             percents = 30;
412         }
413 
414 
415         return percents;
416     }
417 
418     function getSumBonusPercents(uint256 _tokens) internal returns(uint8){
419         uint8 percents = 0;
420 
421         if(_tokens >= 1000000 ether){
422             percents = 30;
423         }
424 
425         return percents;
426     }
427 
428 }