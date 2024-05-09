1 pragma solidity ^0.4.23;
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
207      * @dev Modifier to make a function callable only when the contract is paused.db.getCollection('transactions').find({})
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
236     uint256 public constant maxTokensToMint = 7320000000 ether;
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
273 contract Avatar is MintableToken {
274 
275     string public constant name = "AvataraCoin";
276 
277     string public constant symbol = "VTR";
278 
279     bool public transferEnabled = false;
280 
281     uint8 public constant decimals = 18;
282 
283     uint256 public rate = 100000;
284 
285     uint256 public constant hardCap = 30000 ether;
286 
287     uint256 public weiFounded = 0;
288 
289     address public approvedUser = 0x48BAa849622fb4481c0C4D9E7a68bcE6b63b0213;
290 
291     address public wallet = 0x231FA84139d9956Cc8135303701d738213D8D916;
292 
293     uint64 public dateStart = 1520348400;
294 
295     bool public icoFinished = false;
296 
297     uint256 public constant maxTokenToBuy = 4392000000 ether;
298 
299     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 amount);
300 
301 
302     /**
303     * @dev transfer token for a specified address
304     * @param _to The address to transfer to.
305     * @param _value The amount to be transferred.
306     */
307     function transfer(address _to, uint _value) whenNotPaused canTransfer returns (bool) {
308         require(_to != address(this) && _to != address(0));
309         return super.transfer(_to, _value);
310     }
311 
312     /**
313     * @dev Transfer tokens from one address to another
314     * @param _from address The address which you want to send tokens from
315     * @param _to address The address which you want to transfer to
316     * @param _value uint256 the amout of tokens to be transfered
317     */
318     function transferFrom(address _from, address _to, uint _value) whenNotPaused canTransfer returns (bool) {
319         require(_to != address(this) && _to != address(0));
320         return super.transferFrom(_from, _to, _value);
321     }
322 
323     /**
324      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
325      * @param _spender The address which will spend the funds.
326      * @param _value The amount of tokens to be spent.
327      */
328     function approve(address _spender, uint256 _value) whenNotPaused returns (bool) {
329         return super.approve(_spender, _value);
330     }
331 
332     /**
333      * @dev Modifier to make a function callable only when the transfer is enabled.
334      */
335     modifier canTransfer() {
336         require(transferEnabled);
337         _;
338     }
339 
340     modifier onlyOwnerOrApproved() {
341         require(msg.sender == owner || msg.sender == approvedUser);
342         _;
343     }
344 
345     /**
346     * @dev Function to stop transfering tokens.
347     * @return True if the operation was successful.
348     */
349     function enableTransfer() onlyOwner returns (bool) {
350         transferEnabled = true;
351         return true;
352     }
353 
354     function finishIco() onlyOwner returns (bool) {
355         icoFinished = true;
356         return true;
357     }
358 
359     modifier canBuyTokens() {
360         require(!icoFinished && weiFounded <= hardCap);
361         _;
362     }
363 
364     function setApprovedUser(address _user) onlyOwner returns (bool) {
365         require(_user != address(0));
366         approvedUser = _user;
367         return true;
368     }
369 
370 
371     function changeRate(uint256 _rate) onlyOwnerOrApproved returns (bool) {
372         require(_rate > 0);
373         rate = _rate;
374         return true;
375     }
376 
377     function () payable {
378         buyTokens(msg.sender);
379     }
380 
381     function buyTokens(address beneficiary) canBuyTokens whenNotPaused payable {
382         require(beneficiary != 0x0);
383         require(msg.value >= 100 finney);
384 
385         uint256 weiAmount = msg.value;
386         uint256 bonus = 0;
387         uint256 totalWei = weiAmount.add(weiFounded);
388 
389         if (weiAmount >= 30 ether){
390             bonus = 75;
391         }else if (weiAmount >= 15 ether){
392             bonus = 70;
393         }if (weiAmount >= 6 ether){
394             bonus = 60;
395         }else if (weiAmount >= 3 ether){
396             bonus = 51;
397         }else if (weiAmount >= 1500 finney){
398             bonus = 45;
399         }else if (weiAmount >= 1 ether){
400             bonus = 42;
401         }else if (weiAmount >= 500 finney){
402             bonus = 30;
403         }else if (weiAmount >= 300 finney){
404             bonus = 20;
405         }else if(weiAmount >= 100 finney){
406             bonus = 5;
407         }
408 
409         uint256 tokens = weiAmount.mul(rate);
410 
411         if(bonus > 0){
412             tokens += tokens.mul(bonus).div(100);
413         }
414 
415         require(totalSupply.add(tokens) <= maxTokenToBuy);
416 
417         mintInternal(beneficiary, tokens);
418         weiFounded = totalWei;
419         TokenPurchase(msg.sender, beneficiary, tokens);
420         forwardFunds();
421     }
422 
423     // send ether to the fund collection wallet
424     function forwardFunds() internal {
425         wallet.transfer(msg.value);
426     }
427 
428     function changeWallet(address _newWallet) onlyOwner returns (bool) {
429         require(_newWallet != 0x0);
430         wallet = _newWallet;
431         return true;
432     }
433 
434 
435 }