1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10      * SafeMath mul function
11      * @dev function for safe multiply, throws on overflow.
12      **/
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
23   	 * SafeMath div function
24   	 * @dev function for safe devide, throws on overflow.
25   	 **/
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a / b;
28         return c;
29     }
30 
31     /**
32   	 * SafeMath sub function
33   	 * @dev function for safe subtraction, throws on overflow.
34   	 **/
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41   	 * SafeMath add function
42   	 * @dev Adds two numbers, throws on overflow.
43   	 */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 
50 }
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58 
59     address public owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67     constructor() public {
68         owner = msg.sender;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier isOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     /**
80      * @dev Allows the current owner to transfer control of the contract to a newOwner.
81      * @param newOwner The address to transfer ownership to.
82      */
83     function transferOwnership(address newOwner) public isOwner {
84         require(newOwner != address(0));
85         emit OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87     }
88 
89 }
90 /**
91  * @title Pausable
92  * @dev Base contract which allows children to implement an emergency stop mechanism.
93  */
94 contract Pausable is Ownable {
95   event Pause();
96   event Unpause();
97   event NotPausable();
98 
99   bool public paused = false;
100   bool public canPause = true;
101 
102   /**
103    * @dev Modifier to make a function callable only when the contract is not paused.
104    */
105   modifier whenNotPaused() {
106     require(!paused || msg.sender == owner);
107     _;
108   }
109 
110   /**
111    * @dev Modifier to make a function callable only when the contract is paused.
112    */
113   modifier whenPaused() {
114     require(paused);
115     _;
116   }
117 
118   /**
119      * @dev called by the owner to pause, triggers stopped state
120      **/
121     function pause() isOwner whenNotPaused public {
122         require(canPause == true);
123         paused = true;
124         emit Pause();
125     }
126 
127   /**
128    * @dev called by the owner to unpause, returns to normal state
129    */
130   function unpause() isOwner whenPaused public {
131     require(paused == true);
132     paused = false;
133     emit Unpause();
134   }
135 
136   /**
137      * @dev Prevent the token from ever being paused again
138      **/
139     function notPausable() isOwner public{
140         paused = false;
141         canPause = false;
142         emit NotPausable();
143     }
144 }
145 
146 /**
147  * @title Pausable token
148  * @dev StandardToken modified with pausable transfers.
149  **/
150 
151 contract StandardToken is Pausable {
152 
153     using SafeMath for uint256;
154 
155     event Transfer(address indexed _from, address indexed _to, uint256 _value);
156     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
157 
158     mapping (address => uint256) balances;
159     mapping (address => mapping (address => uint256)) allowed;
160 
161     uint256 public totalSupply;
162 
163     /**
164      * @dev Returns the total supply of the token
165      **/
166     function totalSupply() public constant returns (uint256 supply) {
167         return totalSupply;
168     }
169 
170     /**
171      * @dev Transfer tokens when not paused
172      **/
173     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
174         if (balances[msg.sender] >= _value && _value > 0) {
175             balances[msg.sender] = balances[msg.sender].sub(_value);
176             balances[_to] = balances[_to].add(_value);
177             emit Transfer(msg.sender, _to, _value);
178             return true;
179         } else { return false; }
180     }
181 
182     /**
183      * @dev transferFrom function to tansfer tokens when token is not paused
184      **/
185     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
186         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
187             balances[_to] = balances[_to].add(_value);
188             balances[_from] = balances[_from].sub(_value);
189             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190             emit Transfer(_from, _to, _value);
191             return true;
192         } else { return false; }
193     }
194 
195     /**
196      * @dev returns balance of the owner
197      **/
198     function balanceOf(address _owner) public constant returns (uint256 balance) {
199         return balances[_owner];
200     }
201 
202     /**
203      * @dev approve spender when not paused
204      **/
205     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
206         allowed[msg.sender][_spender] = _value;
207         emit Approval(msg.sender, _spender, _value);
208         return true;
209     }
210 
211     /**
212      * @dev Function to check the amount of tokens that an owner allowed to a spender.
213      * @param _owner address The address which owns the funds.
214      * @param _spender address The address which will spend the funds.
215      * @return A uint256 specifying the amount of tokens still available for the spender.
216      */
217     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
218         return allowed[_owner][_spender];
219     }
220 
221     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
222      * the total supply.
223      *
224      * Emits a {Transfer} event with `from` set to the zero address.
225      *
226      * Requirements
227      *
228      * - `to` cannot be the zero address.
229      */
230     function mint(address account, uint256 amount) internal {
231         require(account != address(0), "ERC20: mint to the zero address");
232 
233         totalSupply = totalSupply.add(amount);
234         balances[account] = balances[account].add(amount);
235         emit Transfer(address(0), account, amount);
236     }
237 
238 }
239 
240 /**
241  * @title ERC20Basic
242  * @dev Simpler version of ERC20 interface with the features of the above declared standard token
243  * @dev see https://github.com/ethereum/EIPs/issues/179
244  */
245 contract POFI is StandardToken  {
246 
247     using SafeMath for uint256;
248 
249     string public name;
250     string public symbol;
251     string public version = '1.0';
252     uint8 public decimals;
253     uint16 public exchangeRate;
254     uint256 public lockedTime;
255     uint256 public othersLockedTime;
256     uint256 public marketingLockedTime;
257 
258     event TokenNameChanged(string indexed previousName, string indexed newName);
259     event TokenSymbolChanged(string indexed previousSymbol, string indexed newSymbol);
260     event ExchangeRateChanged(uint16 indexed previousRate, uint16 indexed newRate);
261 
262     /**
263    * ERC20 Token Constructor
264    * @dev Create and issue tokens to msg.sender.
265    */
266     constructor (address privatesale, address presale, address marketing) public {
267         decimals        = 18;
268         exchangeRate    = 12566;
269         lockedTime     = 1632031991; // 1 year locked
270         othersLockedTime = 1609528192; // 3 months locked
271         marketingLockedTime = 1614625792; // 6 months locked
272         symbol          = "POFI";
273         name            = "PoFi Network";
274 
275         mint(privatesale, 15000000 * 10**uint256(decimals)); // Privatesale 15% of the tokens
276         mint(presale, 10000000 * 10**uint256(decimals)); // Presale 10% of the tokens
277         mint(marketing, 5000000 * 10**uint256(decimals)); // Marketing/partnership/uniswap liquidity (5% of the tokens, the other 5% is locked for 6 months)
278         mint(address(this), 70000000 * 10**uint256(decimals)); // Team 10% of tokens locked for 1 year, Others(Audit/Dev) 5% of tokens locked for 3 months, marketing 5% of tokens locked for 6 months, rewards 50% of the total token supply is locked for 3 months
279 
280 
281 
282     }
283 
284     /**
285      * @dev Function to change token name.
286      * @return A boolean.
287      */
288     function changeTokenName(string newName) public isOwner returns (bool success) {
289         emit TokenNameChanged(name, newName);
290         name = newName;
291         return true;
292     }
293 
294     /**
295      * @dev Function to change token symbol.
296      * @return A boolean.
297      */
298     function changeTokenSymbol(string newSymbol) public isOwner returns (bool success) {
299         emit TokenSymbolChanged(symbol, newSymbol);
300         symbol = newSymbol;
301         return true;
302     }
303 
304     /**
305      * @dev Function to check the exchangeRate.
306      * @return A boolean.
307      */
308     function changeExchangeRate(uint16 newRate) public isOwner returns (bool success) {
309         emit ExchangeRateChanged(exchangeRate, newRate);
310         exchangeRate = newRate;
311         return true;
312     }
313 
314     function () public payable {
315         fundTokens();
316     }
317 
318     /**
319      * @dev Function to fund tokens
320      */
321     function fundTokens() public payable {
322         require(msg.value > 0);
323         uint256 tokens = msg.value.mul(exchangeRate);
324         require(balances[owner].sub(tokens) > 0);
325         balances[msg.sender] = balances[msg.sender].add(tokens);
326         balances[owner] = balances[owner].sub(tokens);
327         emit Transfer(msg.sender, owner, tokens);
328         forwardFunds();
329     }
330     /**
331      * @dev Function to forward funds internally.
332      */
333     function forwardFunds() internal {
334         owner.transfer(msg.value);
335     }
336 
337     /**
338      * @notice Release locked tokens of team.
339      */
340     function releaseTeamLockedPOFI() public isOwner returns(bool){
341         require(block.timestamp >= lockedTime, "Tokens are locked in the smart contract until respective release Time ");
342 
343         uint256 amount = balances[address(this)];
344         require(amount > 0, "TokenTimelock: no tokens to release");
345 
346         emit Transfer(address(this), msg.sender, amount);
347 
348         return true;
349     }
350     
351     /**
352      * @notice Release locked tokens of Others(Dev/Audit).
353      */
354     function releaseOthersLockedPOFI() public isOwner returns(bool){
355         require(block.timestamp >= othersLockedTime, "Tokens are locked in the smart contract until respective release time");
356 
357         uint256 amount = 5000000; // 5M others locked tokens which will be released after 3 months
358 
359         emit Transfer(address(this), msg.sender, amount);
360 
361         return true;
362     }
363     
364     /**
365      * @notice Release locked tokens of Marketing.
366      */
367     function releaseMarketingLockedPOFI() public isOwner returns(bool){
368         require(block.timestamp >= marketingLockedTime, "Tokens are locked in the smart contract until respective release time");
369 
370         uint256 amount = 5000000; // 5M others locked tokens which will be released after 3 months
371 
372         emit Transfer(address(this), msg.sender, amount);
373 
374         return true;
375     }
376     
377     /**
378      * @notice Release locked tokens of Rewards(Staking/Liqudity incentive mining).
379      */
380     function releaseRewardsLockedPOFI() public isOwner returns(bool){
381         require(block.timestamp >= othersLockedTime, "Tokens are locked in the smart contract until respective release time");
382 
383         uint256 amount = 50000000; // 50M rewards locked tokens which will be released after 3 months
384 
385         emit Transfer(address(this), msg.sender, amount);
386 
387         return true;
388     }
389     
390     
391     
392 
393     /**
394      * @dev User to perform {approve} of token and {transferFrom} in one function call.
395      *
396      *
397      * Requirements
398      *
399      * - `spender' must have implemented {receiveApproval} function.
400      */
401     function approveAndCall(
402         address _spender,
403         uint256 _value,
404         bytes _extraData
405     ) public returns (bool success) {
406         allowed[msg.sender][_spender] = _value;
407         emit Approval(msg.sender, _spender, _value);
408         if(!_spender.call(
409             bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))),
410             msg.sender,
411             _value,
412             this,
413             _extraData
414         )) { revert(); }
415         return true;
416     }
417 
418 }