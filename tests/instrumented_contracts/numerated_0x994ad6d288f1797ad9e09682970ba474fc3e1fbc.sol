1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8     function mul(uint a, uint b) internal pure returns (uint) {
9         uint c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint a, uint b) internal pure returns (uint) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint a, uint b) internal pure returns (uint) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint a, uint b) internal pure returns (uint) {
27         uint c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 
32     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
33         return a >= b ? a : b;
34     }
35 
36     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
37         return a < b ? a : b;
38     }
39 
40     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
41         return a >= b ? a : b;
42     }
43 
44     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
45         return a < b ? a : b;
46     }
47 }
48 
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/20
54  */
55 contract ERC20Basic {
56     uint public totalSupply;
57 
58     function balanceOf(address who) public view returns (uint);
59 
60     function transfer(address to, uint value) public;
61 
62     event Transfer(address indexed from, address indexed to, uint value);
63 }
64 
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract BasicToken is ERC20Basic {
71     using SafeMath for uint;
72 
73     mapping(address => uint) balances;
74 
75     /**
76      * @dev Fix for the ERC20 short address attack.
77      */
78     modifier onlyPayloadSize(uint size) {
79         require(msg.data.length == size + 4, "payload size does not match");
80         _;
81     }
82 
83     /**
84     * @dev transfer token for a specified address
85     * @param _to The address to transfer to.
86     * @param _value The amount to be transferred.
87     */
88     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public {
89         balances[msg.sender] = balances[msg.sender].sub(_value);
90         balances[_to] = balances[_to].add(_value);
91         emit Transfer(msg.sender, _to, _value);
92     }
93 
94     /**
95     * @dev Gets the balance of the specified address.
96     * @param _owner The address to query the the balance of.
97     * @return An uint representing the amount owned by the passed address.
98     */
99     function balanceOf(address _owner) public view returns (uint balance)  {
100         return balances[_owner];
101     }
102 
103 }
104 
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111     function allowance(address owner, address spender) public view returns (uint);
112 
113     function transferFrom(address from, address to, uint value) public;
114 
115     function approve(address spender, uint value) public;
116 
117     event Approval(address indexed owner, address indexed spender, uint value);
118 }
119 
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implemantation of the basic standart token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is BasicToken, ERC20 {
129 
130     mapping(address => mapping(address => uint)) allowed;
131 
132 
133     /**
134      * @dev Transfer tokens from one address to another
135      * @param _from address The address which you want to send tokens from
136      * @param _to address The address which you want to transfer to
137      * @param _value uint the amout of tokens to be transfered
138      */
139     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) public {
140 
141         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
142         // if (_value > _allowance) throw;
143 
144         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145         balances[_from] = balances[_from].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         emit Transfer(_from, _to, _value);
148     }
149 
150     /**
151      * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
152      * @param _spender The address which will spend the funds.
153      * @param _value The amount of tokens to be spent.
154      */
155     function approve(address _spender, uint _value) public {
156 
157         // To change the approve amount you first have to reduce the addresses`
158         //  allowance to zero by calling `approve(_spender, 0)` if it is not
159         //  already 0 to mitigate the race condition described here:
160         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
162 
163         allowed[msg.sender][_spender] = _value;
164         emit Approval(msg.sender, _spender, _value);
165     }
166 
167     /**
168      * @dev Function to check the amount of tokens than an owner allowed to a spender.
169      * @param _owner address The address which owns the funds.
170      * @param _spender address The address which will spend the funds.
171      * @return A uint specifing the amount of tokens still avaible for the spender.
172      */
173     function allowance(address _owner, address _spender) public view returns (uint remaining) {
174         return allowed[_owner][_spender];
175     }
176 
177 }
178 
179 
180 /**
181  * @title Ownable
182  * @dev The Ownable contract has an owner address, and provides basic authorization control
183  * functions, this simplifies the implementation of "user permissions".
184  */
185 contract Ownable {
186     address public owner;
187 
188 
189     /**
190      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
191      * account.
192      */
193     constructor() public {
194         owner = msg.sender;
195     }
196 
197 
198     /**
199      * @dev Throws if called by any account other than the owner.
200      */
201     modifier onlyOwner() {
202         require(msg.sender == owner, "only owner can call");
203         _;
204     }
205 
206 
207     /**
208      * @dev Allows the current owner to transfer control of the contract to a newOwner.
209      * @param newOwner The address to transfer ownership to.
210      */
211     function transferOwnership(address newOwner) onlyOwner public {
212         if (newOwner != address(0)) {
213             owner = newOwner;
214         }
215     }
216 
217 }
218 
219 
220 /**
221  * @title Mintable token
222  * @dev Simple ERC20 Token example, with mintable token creation
223  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
224  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
225  */
226 
227 contract MintableToken is StandardToken, Ownable {
228     event Mint(address indexed to, uint value);
229     event MintFinished();
230 
231     bool public mintingFinished = false;
232     uint public totalSupply = 0;
233 
234 
235     modifier canMint() {
236         require(!mintingFinished, "mint finished.");
237         _;
238     }
239 
240     /**
241      * @dev Function to mint tokens
242      * @param _to The address that will recieve the minted tokens.
243      * @param _amount The amount of tokens to mint.
244      * @return A boolean that indicates if the operation was successful.
245      */
246     function mint(address _to, uint _amount) onlyOwner canMint public returns (bool) {
247         totalSupply = totalSupply.add(_amount);
248         balances[_to] = balances[_to].add(_amount);
249         emit Mint(_to, _amount);
250         emit Transfer(0x0, _to, _amount);
251         return true;
252     }
253 
254     /**
255      * @dev Function to stop minting new tokens.
256      * @return True if the operation was successful.
257      */
258     function finishMinting() onlyOwner public returns (bool) {
259         mintingFinished = true;
260         emit MintFinished();
261         return true;
262     }
263 }
264 
265 
266 /**
267  * @title Pausable
268  * @dev Base contract which allows children to implement an emergency stop mechanism.
269  */
270 contract Pausable is Ownable {
271     event Pause();
272     event Unpause();
273 
274     bool public paused = false;
275 
276 
277     /**
278      * @dev modifier to allow actions only when the contract IS paused
279      */
280     modifier whenNotPaused() {
281         require(!paused, "contract not paused");
282         _;
283     }
284 
285     /**
286      * @dev modifier to allow actions only when the contract IS NOT paused
287      */
288     modifier whenPaused {
289         require(paused, "contract paused");
290         _;
291     }
292 
293     /**
294      * @dev called by the owner to pause, triggers stopped state
295      */
296     function pause() onlyOwner whenNotPaused public returns (bool) {
297         paused = true;
298         emit Pause();
299         return true;
300     }
301 
302     /**
303      * @dev called by the owner to unpause, returns to normal state
304      */
305     function unpause() onlyOwner whenPaused public returns (bool) {
306         paused = false;
307         emit Unpause();
308         return true;
309     }
310 }
311 
312 
313 /**
314  * Pausable token
315  *
316  * Simple ERC20 Token example, with pausable token creation
317  **/
318 
319 contract PausableToken is StandardToken, Pausable {
320 
321     function transfer(address _to, uint _value) whenNotPaused public {
322         super.transfer(_to, _value);
323     }
324 
325     function transferFrom(address _from, address _to, uint _value) whenNotPaused public {
326         super.transferFrom(_from, _to, _value);
327     }
328 }
329 
330 
331 /**
332  * @title TokenTimelock
333  * @dev TokenTimelock is a token holder contract that will allow a
334  * beneficiary to extract the tokens after a time has passed
335  */
336 contract TokenTimelock {
337 
338     // ERC20 basic token contract being held
339     ERC20Basic token;
340 
341     // beneficiary of tokens after they are released
342     address beneficiary;
343 
344     // timestamp where token release is enabled
345     uint releaseTime;
346 
347     constructor(ERC20Basic _token, address _beneficiary, uint _releaseTime) public {
348         require(_releaseTime > now);
349         token = _token;
350         beneficiary = _beneficiary;
351         releaseTime = _releaseTime;
352     }
353 
354     /**
355      * @dev beneficiary claims tokens held by time lock
356      */
357     function claim() public {
358         require(msg.sender == beneficiary);
359         require(now >= releaseTime);
360 
361         uint amount = token.balanceOf(this);
362         require(amount > 0);
363 
364         token.transfer(beneficiary, amount);
365     }
366 }
367 
368 
369 /**
370  * @title Token
371  * @dev An ERC20 compilable Token contract
372  */
373 contract Token is PausableToken, MintableToken {
374     using SafeMath for uint256;
375 
376     string public name;
377     string public symbol;
378     uint8 public decimals;
379 
380     constructor(
381         string tokenName,
382         string tokenSymbol,
383         address tokenOwner,
384         uint256 initialSupply,
385         uint8 decimalUnits
386     ) public {
387         // Set the name for display purposes
388         name = tokenName;
389         // Set the symbol for display purposes
390         symbol = tokenSymbol;
391         // Amount of decimals for display purposes
392         decimals = decimalUnits;
393         // Set token owner
394         owner = tokenOwner;
395         // mint token for initial supply
396         totalSupply = initialSupply;
397         balances[tokenOwner] = initialSupply;
398         emit Mint(tokenOwner, initialSupply);
399         emit Transfer(0x0, tokenOwner, initialSupply);
400     }
401 
402     /**
403      * @dev mint timelocked tokens
404      */
405     function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime)
406     onlyOwner canMint public returns (TokenTimelock) {
407 
408         TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
409         mint(timelock, _amount);
410 
411         return timelock;
412     }
413 
414     /**
415      * @dev transfer balance to owner
416      */
417     function withdrawEther(uint256 amount) onlyOwner public {
418         owner.transfer(amount);
419     }
420 
421     /**
422      * @dev can accept ether
423      */
424     function() payable public {
425     }
426 
427 }