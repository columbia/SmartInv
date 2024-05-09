1 /**
2 * The Global Fintech Coin contract bases on the ERC20 standard token contracts
3 * Author : Gordon T. Asiranawin
4 * Orgura Inc. &
5 * Global Fintech
6 */
7 pragma solidity ^0.4.24;
8 
9 
10 /**
11  * Math operations with safety checks
12  */
13 library SafeMath {
14 
15     function mul(uint a, uint b) internal returns (uint) {
16         uint c = a * b;
17         assert(a == 0 || c / a == b);
18         return c;
19     }
20 
21     function div(uint a, uint b) internal returns (uint) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     function sub(uint a, uint b) internal returns (uint) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint a, uint b) internal returns (uint) {
34         uint c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 
39     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
40         return a >= b ? a : b;
41     }
42 
43     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
44         return a < b ? a : b;
45     }
46 
47     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
48         return a >= b ? a : b;
49     }
50 
51     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
52         return a < b ? a : b;
53     }
54 
55     function assert(bool assertion) internal {
56         if (!assertion) {
57             throw;
58         }
59     }
60 
61 }
62 
63 
64 /**
65  * @title ERC20Basic
66  * @dev Simpler version of ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20Basic {
70 
71     uint public totalSupply;
72     function balanceOf(address who) constant returns (uint);
73     function transfer(address to, uint value);
74     event Transfer(address indexed from, address indexed to, uint value);
75 
76 }
77 
78 
79 /**
80  * @title Basic token
81  * @dev Basic version of StandardToken, with no allowances.
82  */
83 contract BasicToken is ERC20Basic {
84 
85     using SafeMath for uint;
86 
87     mapping(address => uint) balances;
88 
89     /**
90     * @dev Fix for the ERC20 short address attack.
91     */
92     modifier onlyPayloadSize(uint size) {
93         if(msg.data.length < size + 4) {
94         throw;
95         }
96         _;
97     }
98 
99     /**
100     * @dev transfer token for a specified address
101     * @param _to The address to transfer to.
102     * @param _value The amount to be transferred.
103     */
104     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
105         balances[msg.sender] = balances[msg.sender].sub(_value);
106         balances[_to] = balances[_to].add(_value);
107         Transfer(msg.sender, _to, _value);
108     }
109 
110     /**
111     * @dev Gets the balance of the specified address.
112     * @param _owner The address to query the the balance of.
113     * @return An uint representing the amount owned by the passed address.
114     */
115     function balanceOf(address _owner) constant returns (uint balance) {
116         return balances[_owner];
117     }
118 
119 }
120 
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 is ERC20Basic {
127 
128     function allowance(address owner, address spender) constant returns (uint);
129     function transferFrom(address from, address to, uint value);
130     function approve(address spender, uint value);
131     event Approval(address indexed owner, address indexed spender, uint value);
132 
133 }
134 
135 
136 /**
137  * @title Standard ERC20 token
138  *
139  * @dev Implemantation of the basic standart token.
140  * @dev https://github.com/ethereum/EIPs/issues/20
141  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
142  */
143 contract StandardToken is BasicToken, ERC20 {
144 
145     mapping (address => mapping (address => uint)) allowed;
146 
147     /**
148     * @dev Transfer tokens from one address to another
149     * @param _from address The address which you want to send tokens from
150     * @param _to address The address which you want to transfer to
151     * @param _value uint the amout of tokens to be transfered
152     */
153     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
154         var _allowance = allowed[_from][msg.sender];
155 
156         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
157         // if (_value > _allowance) throw;
158 
159         balances[_to] = balances[_to].add(_value);
160         balances[_from] = balances[_from].sub(_value);
161         allowed[_from][msg.sender] = _allowance.sub(_value);
162         Transfer(_from, _to, _value);
163     }
164 
165     /**
166     * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
167     * @param _spender The address which will spend the funds.
168     * @param _value The amount of tokens to be spent.
169     */
170     function approve(address _spender, uint _value) {
171 
172         // To change the approve amount you first have to reduce the addresses`
173         //  allowance to zero by calling `approve(_spender, 0)` if it is not
174         //  already 0 to mitigate the race condition described here:
175         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
177 
178         allowed[msg.sender][_spender] = _value;
179         Approval(msg.sender, _spender, _value);
180     }
181 
182     /**
183     * @dev Function to check the amount of tokens than an owner allowed to a spender.
184     * @param _owner address The address which owns the funds.
185     * @param _spender address The address which will spend the funds.
186     * @return A uint specifing the amount of tokens still avaible for the spender.
187     */
188     function allowance(address _owner, address _spender) constant returns (uint remaining) {
189         return allowed[_owner][_spender];
190     }
191 
192 }
193 
194 
195 /**
196  * @title Ownable
197  * @dev The Ownable contract has an owner address, and provides basic authorization control
198  * functions, this simplifies the implementation of "user permissions".
199  */
200 contract Ownable {
201 
202     address public owner;
203 
204     /**
205     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
206     * account.
207     */
208     function Ownable() {
209         owner = msg.sender;
210     }
211 
212     /**
213     * @dev Throws if called by any account other than the owner.
214     */
215     modifier onlyOwner() {
216         if (msg.sender != owner) {
217             throw;
218         }
219         _;
220     }
221 
222     /**
223     * @dev Allows the current owner to transfer control of the contract to a newOwner.
224     * @param newOwner The address to transfer ownership to.
225     */
226     function transferOwnership(address newOwner) onlyOwner {
227         if (newOwner != address(0)) {
228             owner = newOwner;
229         }
230     }
231 
232 }
233 
234 
235 /**
236  * @title Mintable token
237  * @dev Simple ERC20 Token example, with mintable token creation
238  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
239  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
240  */
241 contract MintableToken is StandardToken, Ownable {
242 
243     event Mint(address indexed to, uint value);
244     event MintFinished();
245 
246     bool public mintingFinished = false;
247     uint public totalSupply = 0;
248 
249     modifier canMint() {
250         if(mintingFinished) throw;
251         _;
252     }
253 
254     /**
255     * @dev Function to mint tokens
256     * @param _to The address that will recieve the minted tokens.
257     * @param _amount The amount of tokens to mint.
258     * @return A boolean that indicates if the operation was successful.
259     */
260     function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
261         totalSupply = totalSupply.add(_amount);
262         balances[_to] = balances[_to].add(_amount);
263         Mint(_to, _amount);
264         return true;
265     }
266 
267     /**
268     * @dev Function to stop minting new tokens.
269     * @return True if the operation was successful.
270     */
271     function finishMinting() onlyOwner returns (bool) {
272         mintingFinished = true;
273         MintFinished();
274         return true;
275     }
276 
277 }
278 
279 
280 /**
281  * @title Pausable
282  * @dev Base contract which allows children to implement an emergency stop mechanism.
283  */
284 contract Pausable is Ownable {
285 
286     event Pause();
287     event Unpause();
288 
289     bool public paused = false;
290 
291     /**
292     * @dev modifier to allow actions only when the contract IS paused
293     */
294     modifier whenNotPaused() {
295         if (paused) throw;
296         _;
297     }
298 
299     /**
300     * @dev modifier to allow actions only when the contract IS NOT paused
301     */
302     modifier whenPaused {
303         if (!paused) throw;
304         _;
305     }
306 
307     /**
308     * @dev called by the owner to pause, triggers stopped state
309     */
310     function pause() onlyOwner whenNotPaused returns (bool) {
311         paused = true;
312         Pause();
313         return true;
314     }
315 
316     /**
317     * @dev called by the owner to unpause, returns to normal state
318     */
319     function unpause() onlyOwner whenPaused returns (bool) {
320         paused = false;
321         Unpause();
322         return true;
323     }
324 
325 }
326 
327 
328 /**
329  * Pausable token
330  *
331  * Simple ERC20 Token example, with pausable token creation
332  **/
333 contract PausableToken is StandardToken, Pausable {
334 
335     function transfer(address _to, uint _value) whenNotPaused {
336         super.transfer(_to, _value);
337     }
338 
339     function transferFrom(address _from, address _to, uint _value) whenNotPaused {
340         super.transferFrom(_from, _to, _value);
341     }
342 
343 }
344 
345 
346 /**
347  * @title TokenTimelock
348  * @dev TokenTimelock is a token holder contract that will allow a
349  * beneficiary to extract the tokens after a time has passed
350  */
351 contract TokenTimelock {
352 
353     // ERC20 basic token contract being held
354     ERC20Basic token;
355 
356     // beneficiary of tokens after they are released
357     address beneficiary;
358 
359     // timestamp where token release is enabled
360     uint releaseTime;
361 
362     function TokenTimelock(ERC20Basic _token, address _beneficiary, uint _releaseTime) {
363         require(_releaseTime > now);
364         token = _token;
365         beneficiary = _beneficiary;
366         releaseTime = _releaseTime;
367     }
368 
369     /**
370     * @dev beneficiary claims tokens held by time lock
371     */
372     function claim() {
373         require(msg.sender == beneficiary);
374         require(now >= releaseTime);
375 
376         uint amount = token.balanceOf(this);
377         require(amount > 0);
378 
379         token.transfer(beneficiary, amount);
380     }
381 
382 }
383 
384 
385 /**
386  * @title Burnable Token
387  * @dev Token that can be irreversibly burned (destroyed).
388  * Based on code by OpenZeppelin: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BurnableToken.sol
389  */
390 contract BurnableToken is BasicToken {
391 
392     event Burn(address indexed burner, uint256 value);
393 
394     /**
395     * @dev Burns a specific amount of tokens.
396     * @param _value The amount of token to be burned.
397     */
398     function burn(uint256 _value) public {
399         _burn(msg.sender, _value);
400     }
401 
402     function _burn(address _who, uint256 _value) internal {
403         require(_value <= balances[_who]);
404         // no need to require value <= totalSupply, since that would imply the
405         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
406 
407         balances[_who] = balances[_who].sub(_value);
408         totalSupply = totalSupply.sub(_value);
409         emit Burn(_who, _value);
410         emit Transfer(_who, address(0), _value);
411     }
412 
413 }
414 
415 
416 /**
417  * @title GlobalFintechCoin
418  * @dev GlobalFintechCoin contract
419  */
420 contract GlobalFintechCoin is PausableToken, MintableToken, BurnableToken {
421 
422     using SafeMath for uint256;
423 
424     string public name = "Global Fintech";
425     string public symbol = "GFIN";
426     uint public decimals = 18;
427 
428     /// Maximum tokens to be allocated.
429     uint256 public constant HARD_CAP = 1688000000 * 10**uint256(decimals);
430     /* Initial supply is  1,688,000,000 BIG */
431 
432     /**
433     * @dev mint timelocked tokens
434     */
435     function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime)
436         onlyOwner canMint returns (TokenTimelock) {
437 
438         TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
439         mint(timelock, _amount);
440 
441         return timelock;
442     }
443 
444 }