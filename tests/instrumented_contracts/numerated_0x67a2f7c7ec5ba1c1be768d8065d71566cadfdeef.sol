1 pragma solidity 0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         require(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         require(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a);
30         return c;
31     }
32 }
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40     uint256 public totalSupply;
41     function balanceOf(address who) public view returns (uint256);
42     function transfer(address to, uint256 value) public returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances.
49  */
50 contract BasicToken is ERC20Basic {
51     using SafeMath for uint256;
52 
53     mapping(address => uint256) public balances;
54 
55     /**
56     * @dev transfer token for a specified address
57     * @param _to The address to transfer to.
58     * @param _value The amount to be transferred.
59     */
60     function transfer(address _to, uint256 _value) public returns (bool) {
61         require(_to != address(0));
62         require(_value <= balances[msg.sender]);
63 
64         // SafeMath.sub will throw if there is not enough balance.
65         balances[msg.sender] = balances[msg.sender].sub(_value);
66         balances[_to] = balances[_to].add(_value);
67         emit Transfer(msg.sender, _to, _value);
68         return true;
69     }
70 
71     /**
72     * @dev Gets the balance of the specified address.
73     * @param _owner The address to query the the balance of.
74     * @return An uint256 representing the amount owned by the passed address.
75     */
76     function balanceOf(address _owner) public view returns (uint256 balance) {
77         return balances[_owner];
78     }
79 
80 }
81 
82 /**
83  * @title ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20 is ERC20Basic {
87     function allowance(address owner, address spender) public view returns (uint256);
88     function transferFrom(address from, address to, uint256 value) public returns (bool);
89     function approve(address spender, uint256 value) public returns (bool);
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * @dev https://github.com/ethereum/EIPs/issues/20
98  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract StandardToken is ERC20, BasicToken {
101 
102     mapping (address => mapping (address => uint256)) internal allowed;
103 
104 
105     /**
106      * @dev Transfer tokens from one address to another
107      * @param _from address The address which you want to send tokens from
108      * @param _to address The address which you want to transfer to
109      * @param _value uint256 the amount of tokens to be transferred
110      */
111     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112         require(_to != address(0));
113         require(_value <= balances[_from]);
114         require(_value <= allowed[_from][msg.sender]);
115 
116         balances[_from] = balances[_from].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119         emit Transfer(_from, _to, _value);
120         return true;
121     }
122 
123     /**
124      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125      *
126      * Beware that changing an allowance with this method brings the risk that someone may use both the old
127      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
128      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
129      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130      * @param _spender The address which will spend the funds.
131      * @param _value The amount of tokens to be spent.
132      */
133     function approve(address _spender, uint256 _value) public returns (bool) {
134         allowed[msg.sender][_spender] = _value;
135         emit Approval(msg.sender, _spender, _value);
136         return true;
137     }
138 
139     /**
140      * @dev Function to check the amount of tokens that an owner allowed to a spender.
141      * @param _owner address The address which owns the funds.
142      * @param _spender address The address which will spend the funds.
143      * @return A uint256 specifying the amount of tokens still available for the spender.
144      */
145     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
146         return allowed[_owner][_spender];
147     }
148 
149     /**
150      * approve should be called when allowed[_spender] == 0. To increment
151      * allowed value is better to use this function to avoid 2 calls (and wait until
152      * the first transaction is mined)
153      * From MonolithDAO Token.sol
154      */
155     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
156         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
157         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158         return true;
159     }
160 
161     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
162         uint oldValue = allowed[msg.sender][_spender];
163         if (_subtractedValue > oldValue) {
164             allowed[msg.sender][_spender] = 0;
165         } else {
166             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
167         }
168         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169         return true;
170     }
171 }
172 
173 /**
174  * @title Burnable Token
175  * @dev Token that can be irreversibly burned (destroyed).
176  */
177 contract BurnableToken is StandardToken {
178 
179     event Burn(address indexed burner, uint256 value);
180 
181     /**
182      * @dev Burns a specific amount of tokens.
183      * @param _value The amount of token to be burned.
184      */
185     function burn(uint256 _value) public {
186         require(_value > 0);
187         require(_value <= balances[msg.sender]);
188         // no need to require value <= totalSupply, since that would imply the
189         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
190 
191         address burner = msg.sender;
192         balances[burner] = balances[burner].sub(_value);
193         totalSupply = totalSupply.sub(_value);
194         emit Burn(burner, _value);
195         emit Transfer(burner, 0x0, _value);
196     }
197 }
198 
199 /**
200  * @title SafeERC20
201  * @dev Wrappers around ERC20 operations that throw on failure.
202  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
203  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
204  */
205 library SafeERC20 {
206     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
207         assert(token.transfer(to, value));
208     }
209 
210     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
211         assert(token.transferFrom(from, to, value));
212     }
213 
214     function safeApprove(ERC20 token, address spender, uint256 value) internal {
215         assert(token.approve(spender, value));
216     }
217 }
218 
219 /**
220  * @title Ownable
221  * @dev The Ownable contract has an owner address, and provides basic authorization control
222  * functions, this simplifies the implementation of "user permissions".
223  */
224 contract Ownable {
225     address public owner;
226 
227     /**
228      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
229      * account.
230      */
231     constructor() public {
232         owner = msg.sender;
233     }
234 
235     /**
236      * @dev Throws if called by any account other than the owner.
237      */
238     modifier onlyOwner {
239         assert(msg.sender == owner);
240         _;
241     }
242 }
243 
244 /**
245  * @title TokenVesting
246  * @dev A token holder contract that can release its token balance gradually like a
247  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
248  * owner.
249  */
250 contract TokenVesting is Ownable {
251     using SafeMath for uint256;
252     using SafeERC20 for ERC20Basic;
253 
254     event Released(uint256 amount);
255     event Revoked();
256 
257     // beneficiary of tokens after they are released
258     address public beneficiary;
259 
260     uint256 public cliff;
261     uint256 public start;
262     uint256 public duration;
263 
264     bool public revocable;
265 
266     mapping (address => uint256) public released;
267     mapping (address => bool) public revoked;
268 
269     /**
270      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
271      * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
272      * of the balance will have vested.
273      * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
274      * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
275      * @param _duration duration in seconds of the period in which the tokens will vest
276      * @param _revocable whether the vesting is revocable or not
277      */
278     constructor(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
279         require(_beneficiary != address(0));
280         require(_cliff <= _duration);
281 
282         beneficiary = _beneficiary;
283         revocable = _revocable;
284         duration = _duration;
285         cliff = _start.add(_cliff);
286         start = _start;
287     }
288 
289     /**
290      * @notice Transfers vested tokens to beneficiary.
291      * @param token ERC20 token which is being vested
292      */
293     function release(ERC20Basic token) public {
294         uint256 unreleased = releasableAmount(token);
295 
296         require(unreleased > 0);
297 
298         released[token] = released[token].add(unreleased);
299 
300         token.safeTransfer(beneficiary, unreleased);
301 
302         emit Released(unreleased);
303     }
304 
305     /**
306      * @notice Allows the owner to revoke the vesting. Tokens already vested
307      * remain in the contract, the rest are returned to the owner.
308      * @param token ERC20 token which is being vested
309      */
310     function revoke(ERC20Basic token) public onlyOwner {
311         require(revocable);
312         require(!revoked[token]);
313 
314         uint256 balance = token.balanceOf(this);
315 
316         uint256 unreleased = releasableAmount(token);
317         uint256 refund = balance.sub(unreleased);
318 
319         revoked[token] = true;
320 
321         token.safeTransfer(owner, refund);
322 
323         emit Revoked();
324     }
325 
326     /**
327      * @dev Calculates the amount that has already vested but hasn't been released yet.
328      * @param token ERC20 token which is being vested
329      */
330     function releasableAmount(ERC20Basic token) public view returns (uint256) {
331         return vestedAmount(token).sub(released[token]);
332     }
333 
334     /**
335      * @dev Calculates the amount that has already vested.
336      * @param token ERC20 token which is being vested
337      */
338     function vestedAmount(ERC20Basic token) public view returns (uint256) {
339         uint256 currentBalance = token.balanceOf(this);
340         uint256 totalBalance = currentBalance.add(released[token]);
341 
342         if (now < cliff) {
343             return 0;
344         } else if (now >= start.add(duration) || revoked[token]) {
345             return totalBalance;
346         } else {
347             return totalBalance.mul(now.sub(start)).div(duration);
348         }
349     }
350 }
351 
352 contract LccxToken is BurnableToken, Ownable {
353     string public constant name = "London Exchange Token";
354     string public constant symbol = "LXT";
355     uint8 public constant decimals = 18;
356 
357     /// Maximum tokens to be allocated (100 million)
358     uint256 public constant HARD_CAP = 100000000 * 10**uint256(decimals);
359 
360     /// This address is owned by the LCCX team
361     address public lccxTeamAddress;
362 
363     /// This address is used to keep the vested team tokens
364     address public lccxTeamTokensVesting;
365 
366     /// This address is used to keep the tokens for sale
367     address public saleTokensAddress;
368 
369     /// This address is used to keep the advisors and early investors tokens
370     address public advisorsTokensAddress;
371 
372     /// This address is used to keep the bounty and referral tokens
373     address public referralTokensAddress;
374 
375     /// when the token sale is closed, the unsold tokens are burnt
376     bool public saleClosed = false;
377 
378     /// Only allowed to execute before the token sale is closed
379     modifier beforeSaleClosed {
380         require(!saleClosed);
381         _;
382     }
383 
384     constructor(address _lccxTeamAddress, address _advisorsTokensAddress, 
385                         address _referralTokensAddress, address _saleTokensAddress) public {
386         require(_lccxTeamAddress != address(0));
387         require(_advisorsTokensAddress != address(0));
388         require(_referralTokensAddress != address(0));
389         require(_saleTokensAddress != address(0));
390 
391         lccxTeamAddress = _lccxTeamAddress;
392         advisorsTokensAddress = _advisorsTokensAddress;
393         saleTokensAddress = _saleTokensAddress;
394         referralTokensAddress = _referralTokensAddress;
395 
396         /// Maximum tokens to be allocated on the sale
397         /// 60M LXT
398         uint256 saleTokens = 60000000 * 10**uint256(decimals);
399         totalSupply = saleTokens;
400         balances[saleTokensAddress] = saleTokens;
401         emit Transfer(0x0, saleTokensAddress, saleTokens);
402 
403         /// Bounty and referral tokens - 8M LXT
404         uint256 referralTokens = 8000000 * 10**uint256(decimals);
405         totalSupply = totalSupply.add(referralTokens);
406         balances[referralTokensAddress] = referralTokens;
407         emit Transfer(0x0, referralTokensAddress, referralTokens);
408 
409         /// Advisors tokens - 14M LXT
410         uint256 advisorsTokens = 14000000 * 10**uint256(decimals);
411         totalSupply = totalSupply.add(advisorsTokens);
412         balances[advisorsTokensAddress] = advisorsTokens;
413         emit Transfer(0x0, advisorsTokensAddress, advisorsTokens);
414         
415         /// Team tokens - 18M LXT
416         uint256 teamTokens = 18000000 * 10**uint256(decimals);
417         totalSupply = totalSupply.add(teamTokens);
418         lccxTeamTokensVesting = address(new TokenVesting(lccxTeamAddress, now, 30 days, 540 days, false));
419         balances[lccxTeamTokensVesting] = teamTokens;
420         emit Transfer(0x0, lccxTeamTokensVesting, teamTokens);
421         
422         require(totalSupply <= HARD_CAP);
423     }
424 
425     /// @dev Close the token sale
426     function closeSale() external onlyOwner beforeSaleClosed {
427         uint256 unsoldTokens = balances[saleTokensAddress];
428 
429         if(unsoldTokens > 0) {
430             balances[saleTokensAddress] = 0;
431             totalSupply = totalSupply.sub(unsoldTokens);
432             emit Burn(saleTokensAddress, unsoldTokens);
433             emit Transfer(saleTokensAddress, 0x0, unsoldTokens);
434         }
435 
436         saleClosed = true;
437     }
438 }