1 /**
2 * The Arezzo Gold Coin contract bases on the ERC20 standard token contracts
3 * Author : Gordon T. Asiranawin
4 * Arezzo Gold Coin
5 */
6 pragma solidity ^0.4.24;
7 
8 
9 /**
10  * Math operations with safety checks
11  */
12 library SafeMath {
13 
14     function mul(uint a, uint b) internal returns (uint) {
15         uint c = a * b;
16         assert(a == 0 || c / a == b);
17         return c;
18     }
19 
20     function div(uint a, uint b) internal returns (uint) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     function sub(uint a, uint b) internal returns (uint) {
28         assert(b <= a);
29         return a - b;
30     }
31 
32     function add(uint a, uint b) internal returns (uint) {
33         uint c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 
38     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
39         return a >= b ? a : b;
40     }
41 
42     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
43         return a < b ? a : b;
44     }
45 
46     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
47         return a >= b ? a : b;
48     }
49 
50     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
51         return a < b ? a : b;
52     }
53 
54     function assert(bool assertion) internal {
55         if (!assertion) {
56             throw;
57         }
58     }
59 
60 }
61 
62 
63 /**
64  * @title ERC20Basic
65  * @dev Simpler version of ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20Basic {
69 
70     uint public totalSupply;
71     function balanceOf(address who) constant returns (uint);
72     function transfer(address to, uint value);
73     event Transfer(address indexed from, address indexed to, uint value);
74 
75 }
76 
77 
78 /**
79  * @title Basic token
80  * @dev Basic version of StandardToken, with no allowances.
81  */
82 contract BasicToken is ERC20Basic {
83 
84     using SafeMath for uint;
85 
86     mapping(address => uint) balances;
87 
88     /**
89     * @dev Fix for the ERC20 short address attack.
90     */
91     modifier onlyPayloadSize(uint size) {
92         if(msg.data.length < size + 4) {
93         throw;
94         }
95         _;
96     }
97 
98     /**
99     * @dev transfer token for a specified address
100     * @param _to The address to transfer to.
101     * @param _value The amount to be transferred.
102     */
103     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
104         balances[msg.sender] = balances[msg.sender].sub(_value);
105         balances[_to] = balances[_to].add(_value);
106         Transfer(msg.sender, _to, _value);
107     }
108 
109     /**
110     * @dev Gets the balance of the specified address.
111     * @param _owner The address to query the the balance of.
112     * @return An uint representing the amount owned by the passed address.
113     */
114     function balanceOf(address _owner) constant returns (uint balance) {
115         return balances[_owner];
116     }
117 
118 }
119 
120 
121 /**
122  * @title ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/20
124  */
125 contract ERC20 is ERC20Basic {
126 
127     function allowance(address owner, address spender) constant returns (uint);
128     function transferFrom(address from, address to, uint value);
129     function approve(address spender, uint value);
130     event Approval(address indexed owner, address indexed spender, uint value);
131 
132 }
133 
134 
135 /**
136  * @title Standard ERC20 token
137  *
138  * @dev Implemantation of the basic standart token.
139  * @dev https://github.com/ethereum/EIPs/issues/20
140  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  */
142 contract StandardToken is BasicToken, ERC20 {
143 
144     mapping (address => mapping (address => uint)) allowed;
145 
146     /**
147     * @dev Transfer tokens from one address to another
148     * @param _from address The address which you want to send tokens from
149     * @param _to address The address which you want to transfer to
150     * @param _value uint the amout of tokens to be transfered
151     */
152     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
153         var _allowance = allowed[_from][msg.sender];
154 
155         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
156         // if (_value > _allowance) throw;
157 
158         balances[_to] = balances[_to].add(_value);
159         balances[_from] = balances[_from].sub(_value);
160         allowed[_from][msg.sender] = _allowance.sub(_value);
161         Transfer(_from, _to, _value);
162     }
163 
164     /**
165     * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
166     * @param _spender The address which will spend the funds.
167     * @param _value The amount of tokens to be spent.
168     */
169     function approve(address _spender, uint _value) {
170 
171         // To change the approve amount you first have to reduce the addresses`
172         //  allowance to zero by calling `approve(_spender, 0)` if it is not
173         //  already 0 to mitigate the race condition described here:
174         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
176 
177         allowed[msg.sender][_spender] = _value;
178         Approval(msg.sender, _spender, _value);
179     }
180 
181     /**
182     * @dev Function to check the amount of tokens than an owner allowed to a spender.
183     * @param _owner address The address which owns the funds.
184     * @param _spender address The address which will spend the funds.
185     * @return A uint specifing the amount of tokens still avaible for the spender.
186     */
187     function allowance(address _owner, address _spender) constant returns (uint remaining) {
188         return allowed[_owner][_spender];
189     }
190 
191 }
192 
193 
194 /**
195  * @title Ownable
196  * @dev The Ownable contract has an owner address, and provides basic authorization control
197  * functions, this simplifies the implementation of "user permissions".
198  */
199 contract Ownable {
200 
201     address public owner;
202 
203     /**
204     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
205     * account.
206     */
207     function Ownable() {
208         owner = msg.sender;
209     }
210 
211     /**
212     * @dev Throws if called by any account other than the owner.
213     */
214     modifier onlyOwner() {
215         if (msg.sender != owner) {
216             throw;
217         }
218         _;
219     }
220 
221     /**
222     * @dev Allows the current owner to transfer control of the contract to a newOwner.
223     * @param newOwner The address to transfer ownership to.
224     */
225     function transferOwnership(address newOwner) onlyOwner {
226         if (newOwner != address(0)) {
227             owner = newOwner;
228         }
229     }
230 
231 }
232 
233 
234 /**
235  * @title Mintable token
236  * @dev Simple ERC20 Token example, with mintable token creation
237  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
238  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
239  */
240 contract MintableToken is StandardToken, Ownable {
241 
242     event Mint(address indexed to, uint value);
243     event MintFinished();
244 
245     bool public mintingFinished = false;
246     uint public totalSupply = 0;
247 
248     modifier canMint() {
249         if(mintingFinished) throw;
250         _;
251     }
252 
253     /**
254     * @dev Function to mint tokens
255     * @param _to The address that will recieve the minted tokens.
256     * @param _amount The amount of tokens to mint.
257     * @return A boolean that indicates if the operation was successful.
258     */
259     function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
260         totalSupply = totalSupply.add(_amount);
261         balances[_to] = balances[_to].add(_amount);
262         Mint(_to, _amount);
263         return true;
264     }
265 
266     /**
267     * @dev Function to stop minting new tokens.
268     * @return True if the operation was successful.
269     */
270     function finishMinting() onlyOwner returns (bool) {
271         mintingFinished = true;
272         MintFinished();
273         return true;
274     }
275 
276 }
277 
278 
279 /**
280  * @title Pausable
281  * @dev Base contract which allows children to implement an emergency stop mechanism.
282  */
283 contract Pausable is Ownable {
284 
285     event Pause();
286     event Unpause();
287 
288     bool public paused = false;
289 
290     /**
291     * @dev modifier to allow actions only when the contract IS paused
292     */
293     modifier whenNotPaused() {
294         if (paused) throw;
295         _;
296     }
297 
298     /**
299     * @dev modifier to allow actions only when the contract IS NOT paused
300     */
301     modifier whenPaused {
302         if (!paused) throw;
303         _;
304     }
305 
306     /**
307     * @dev called by the owner to pause, triggers stopped state
308     */
309     function pause() onlyOwner whenNotPaused returns (bool) {
310         paused = true;
311         Pause();
312         return true;
313     }
314 
315     /**
316     * @dev called by the owner to unpause, returns to normal state
317     */
318     function unpause() onlyOwner whenPaused returns (bool) {
319         paused = false;
320         Unpause();
321         return true;
322     }
323 
324 }
325 
326 
327 /**
328  * Pausable token
329  *
330  * Simple ERC20 Token example, with pausable token creation
331  **/
332 contract PausableToken is StandardToken, Pausable {
333 
334     function transfer(address _to, uint _value) whenNotPaused {
335         super.transfer(_to, _value);
336     }
337 
338     function transferFrom(address _from, address _to, uint _value) whenNotPaused {
339         super.transferFrom(_from, _to, _value);
340     }
341 
342 }
343 
344 
345 /**
346  * @title TokenTimelock
347  * @dev TokenTimelock is a token holder contract that will allow a
348  * beneficiary to extract the tokens after a time has passed
349  */
350 contract TokenTimelock {
351 
352     // ERC20 basic token contract being held
353     ERC20Basic token;
354 
355     // beneficiary of tokens after they are released
356     address beneficiary;
357 
358     // timestamp where token release is enabled
359     uint releaseTime;
360 
361     function TokenTimelock(ERC20Basic _token, address _beneficiary, uint _releaseTime) {
362         require(_releaseTime > now);
363         token = _token;
364         beneficiary = _beneficiary;
365         releaseTime = _releaseTime;
366     }
367 
368     /**
369     * @dev beneficiary claims tokens held by time lock
370     */
371     function claim() {
372         require(msg.sender == beneficiary);
373         require(now >= releaseTime);
374 
375         uint amount = token.balanceOf(this);
376         require(amount > 0);
377 
378         token.transfer(beneficiary, amount);
379     }
380 
381 }
382 
383 
384 /**
385  * @title Burnable Token
386  * @dev Token that can be irreversibly burned (destroyed).
387  * Based on code by OpenZeppelin: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BurnableToken.sol
388  */
389 contract BurnableToken is BasicToken {
390 
391     event Burn(address indexed burner, uint256 value);
392 
393     /**
394     * @dev Burns a specific amount of tokens.
395     * @param _value The amount of token to be burned.
396     */
397     function burn(uint256 _value) public {
398         _burn(msg.sender, _value);
399     }
400 
401     function _burn(address _who, uint256 _value) internal {
402         require(_value <= balances[_who]);
403         // no need to require value <= totalSupply, since that would imply the
404         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
405 
406         balances[_who] = balances[_who].sub(_value);
407         totalSupply = totalSupply.sub(_value);
408         emit Burn(_who, _value);
409         emit Transfer(_who, address(0), _value);
410     }
411 
412 }
413 
414 
415 /**
416  * @title ArezzoGoldCoin
417  * @dev ArezzoGoldCoin contract
418  */
419 contract ArezzoGoldCoin is PausableToken, MintableToken, BurnableToken {
420 
421     using SafeMath for uint256;
422 
423     string public name = "Arezzo Gold Coin";
424     string public symbol = "AGC";
425     uint public decimals = 18;
426 
427     /// Maximum tokens to be allocated.
428     uint256 public constant HARD_CAP = 1000000000* 10**uint256(decimals);
429     /* Initial supply is 1,000,000,000 AGC */
430 
431     /**
432     * @dev mint timelocked tokens
433     */
434     function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime)
435         onlyOwner canMint returns (TokenTimelock) {
436 
437         TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
438         mint(timelock, _amount);
439 
440         return timelock;
441     }
442 
443 }