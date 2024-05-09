1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title SafeERC20
51  * @dev Wrappers around ERC20 operations that throw on failure.
52  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
53  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
54  */
55 library SafeERC20 {
56     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
57         assert(token.transfer(to, value));
58     }
59 
60     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
61         assert(token.transferFrom(from, to, value));
62     }
63 
64     function safeApprove(ERC20 token, address spender, uint256 value) internal {
65         assert(token.approve(spender, value));
66     }
67 }
68 
69 /**
70  * @title ERC20Basic
71  * @dev Simpler version of ERC20 interface
72  * @dev see https://github.com/ethereum/EIPs/issues/179
73  */
74 contract ERC20Basic {
75     function totalSupply() public view returns (uint256);
76     function balanceOf(address who) public view returns (uint256);
77     function transfer(address to, uint256 value) public returns (bool);
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances.
84  */
85 contract BasicToken is ERC20Basic {
86     using SafeMath for uint256;
87 
88     mapping(address => uint256) balances;
89 
90     uint256 totalSupply_;
91 
92     /**
93     * @dev total number of tokens in existence
94     */
95     function totalSupply() public view returns (uint256) {
96         return totalSupply_;
97     }
98 
99     /**
100     * @dev transfer token for a specified address
101     * @param _to The address to transfer to.
102     * @param _value The amount to be transferred.
103     */
104     function transfer(address _to, uint256 _value) public returns (bool) {
105         require(_to != address(0));
106         require(_value <= balances[msg.sender]);
107 
108         // SafeMath.sub will throw if there is not enough balance.
109         balances[msg.sender] = balances[msg.sender].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         emit Transfer(msg.sender, _to, _value);
112         return true;
113     }
114 
115     /**
116     * @dev Gets the balance of the specified address.
117     * @param _owner The address to query the the balance of.
118     * @return An uint256 representing the amount owned by the passed address.
119     */
120     function balanceOf(address _owner) public view returns (uint256 balance) {
121         return balances[_owner];
122     }
123 
124 }
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131     function allowance(address owner, address spender) public view returns (uint256);
132     function transferFrom(address from, address to, uint256 value) public returns (bool);
133     function approve(address spender, uint256 value) public returns (bool);
134     event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * @dev https://github.com/ethereum/EIPs/issues/20
142  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146     mapping (address => mapping (address => uint256)) internal allowed;
147 
148 
149     /**
150      * @dev Transfer tokens from one address to another
151      * @param _from address The address which you want to send tokens from
152      * @param _to address The address which you want to transfer to
153      * @param _value uint256 the amount of tokens to be transferred
154      */
155     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156         require(_to != address(0));
157         require(_value <= balances[_from]);
158         require(_value <= allowed[_from][msg.sender]);
159 
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163         emit Transfer(_from, _to, _value);
164         return true;
165     }
166 
167     /**
168      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169      *
170      * Beware that changing an allowance with this method brings the risk that someone may use both the old
171      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174      * @param _spender The address which will spend the funds.
175      * @param _value The amount of tokens to be spent.
176      */
177     function approve(address _spender, uint256 _value) public returns (bool) {
178         allowed[msg.sender][_spender] = _value;
179         emit Approval(msg.sender, _spender, _value);
180         return true;
181     }
182 
183     /**
184      * @dev Function to check the amount of tokens that an owner allowed to a spender.
185      * @param _owner address The address which owns the funds.
186      * @param _spender address The address which will spend the funds.
187      * @return A uint256 specifying the amount of tokens still available for the spender.
188      */
189     function allowance(address _owner, address _spender) public view returns (uint256) {
190         return allowed[_owner][_spender];
191     }
192 
193     /**
194      * @dev Increase the amount of tokens that an owner allowed to a spender.
195      *
196      * approve should be called when allowed[_spender] == 0. To increment
197      * allowed value is better to use this function to avoid 2 calls (and wait until
198      * the first transaction is mined)
199      * From MonolithDAO Token.sol
200      * @param _spender The address which will spend the funds.
201      * @param _addedValue The amount of tokens to increase the allowance by.
202      */
203     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
204         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
205         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206         return true;
207     }
208 
209     /**
210      * @dev Decrease the amount of tokens that an owner allowed to a spender.
211      *
212      * approve should be called when allowed[_spender] == 0. To decrement
213      * allowed value is better to use this function to avoid 2 calls (and wait until
214      * the first transaction is mined)
215      * From MonolithDAO Token.sol
216      * @param _spender The address which will spend the funds.
217      * @param _subtractedValue The amount of tokens to decrease the allowance by.
218      */
219     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
220         uint oldValue = allowed[msg.sender][_spender];
221         if (_subtractedValue > oldValue) {
222             allowed[msg.sender][_spender] = 0;
223         } else {
224             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
225         }
226         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227         return true;
228     }
229 
230 }
231 
232 /**
233  * @title Ownable
234  * @dev The Ownable contract has an owner address, and provides basic authorization control
235  * functions, this simplifies the implementation of "user permissions".
236  */
237 contract Ownable {
238     address public owner;
239 
240 
241     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
242 
243 
244     /**
245      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
246      * account.
247      */
248     function Ownable() public {
249         owner = msg.sender;
250     }
251 
252     /**
253      * @dev Throws if called by any account other than the owner.
254      */
255     modifier onlyOwner() {
256         require(msg.sender == owner);
257         _;
258     }
259 
260     /**
261      * @dev Allows the current owner to transfer control of the contract to a newOwner.
262      * @param newOwner The address to transfer ownership to.
263      */
264     function transferOwnership(address newOwner) public onlyOwner {
265         require(newOwner != address(0));
266         emit OwnershipTransferred(owner, newOwner);
267         owner = newOwner;
268     }
269 
270 }
271 
272 /**
273  * @title TokenVesting
274  * @dev A token holder contract that can release its token balance gradually like a
275  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
276  * owner.
277  */
278 contract TokenVesting is Ownable {
279     using SafeMath for uint256;
280     using SafeERC20 for ERC20Basic;
281 
282     event Released(uint256 amount);
283     event Revoked();
284 
285     // beneficiary of tokens after they are released
286     address public beneficiary;
287 
288     uint256 public cliff;
289     uint256 public start;
290     uint256 public duration;
291 
292     bool public revocable;
293 
294     mapping (address => uint256) public released;
295     mapping (address => bool) public revoked;
296 
297     /**
298      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
299      * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
300      * of the balance will have vested.
301      * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
302      * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
303      * @param _duration duration in seconds of the period in which the tokens will vest
304      * @param _revocable whether the vesting is revocable or not
305      */
306     function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
307         require(_beneficiary != address(0));
308         require(_cliff <= _duration);
309 
310         beneficiary = _beneficiary;
311         revocable = _revocable;
312         duration = _duration;
313         cliff = _start.add(_cliff);
314         start = _start;
315     }
316 
317     /**
318      * @notice Transfers vested tokens to beneficiary.
319      * @param token ERC20 token which is being vested
320      */
321     function release(ERC20Basic token) public {
322         uint256 unreleased = releasableAmount(token);
323 
324         require(unreleased > 0);
325 
326         released[token] = released[token].add(unreleased);
327 
328         token.safeTransfer(beneficiary, unreleased);
329 
330         emit Released(unreleased);
331     }
332 
333     /**
334      * @notice Allows the owner to revoke the vesting. Tokens already vested
335      * remain in the contract, the rest are returned to the owner.
336      * @param token ERC20 token which is being vested
337      */
338     function revoke(ERC20Basic token) public onlyOwner {
339         require(revocable);
340         require(!revoked[token]);
341 
342         uint256 balance = token.balanceOf(this);
343 
344         uint256 unreleased = releasableAmount(token);
345         uint256 refund = balance.sub(unreleased);
346 
347         revoked[token] = true;
348 
349         token.safeTransfer(owner, refund);
350 
351         emit Revoked();
352     }
353 
354     /**
355      * @dev Calculates the amount that has already vested but hasn't been released yet.
356      * @param token ERC20 token which is being vested
357      */
358     function releasableAmount(ERC20Basic token) public view returns (uint256) {
359         return vestedAmount(token).sub(released[token]);
360     }
361 
362     /**
363      * @dev Calculates the amount that has already vested.
364      * @param token ERC20 token which is being vested
365      */
366     function vestedAmount(ERC20Basic token) public view returns (uint256) {
367         uint256 currentBalance = token.balanceOf(this);
368         uint256 totalBalance = currentBalance.add(released[token]);
369 
370         if (now < cliff) {
371             return 0;
372         } else if (now >= start.add(duration) || revoked[token]) {
373             return totalBalance;
374         } else {
375             return totalBalance.mul(now.sub(start)).div(duration);
376         }
377     }
378 }
379 
380 /**
381  * @title TokenTimelock
382  * @dev TokenTimelock is a token holder contract that will allow a
383  * beneficiary to extract the tokens after a given release time
384  */
385 contract TokenTimelock {
386     using SafeERC20 for ERC20Basic;
387 
388     // ERC20 basic token contract being held
389     ERC20Basic public token;
390 
391     // beneficiary of tokens after they are released
392     address public beneficiary;
393 
394     // timestamp when token release is enabled
395     uint256 public releaseTime;
396 
397     function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
398         require(_releaseTime > now);
399         token = _token;
400         beneficiary = _beneficiary;
401         releaseTime = _releaseTime;
402     }
403 
404     /**
405      * @notice Transfers tokens held by timelock to beneficiary.
406      */
407     function release() public {
408         require(now >= releaseTime);
409 
410         uint256 amount = token.balanceOf(this);
411         require(amount > 0);
412 
413         token.safeTransfer(beneficiary, amount);
414     }
415 }
416 
417 contract FloraFicToken is StandardToken, Ownable {
418 
419     string public name = 'Flora Fic';
420     string public symbol = 'FIC';
421     uint8 public decimals = 6;
422 
423     uint256 public constant INITIAL_SUPPLY = 5400000000000000;
424 
425     event Vesting(address _indexed);
426     event Timelock(address _indexed);
427 
428     /**
429      * @dev Constructor that gives msg.sender all of existing tokens.
430      */
431     function FloraFicToken() public {
432         totalSupply_ = INITIAL_SUPPLY;
433         balances[msg.sender] = INITIAL_SUPPLY;
434         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
435     }
436 
437     function transferVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration) public
438     onlyOwner returns (TokenVesting) {
439         TokenVesting tokenVesting = new TokenVesting(_beneficiary, _start, _cliff, _duration, true);
440         tokenVesting.transferOwnership(owner);
441         emit Vesting(tokenVesting);
442         return tokenVesting;
443     }
444 
445     function transferTimelocked(address _to, uint256 _releaseTime) public
446     onlyOwner returns (TokenTimelock) {
447         TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
448         emit Timelock(timelock);
449         return timelock;
450     }
451 
452 }