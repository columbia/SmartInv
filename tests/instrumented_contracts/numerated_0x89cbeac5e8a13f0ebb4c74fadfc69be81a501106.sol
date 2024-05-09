1 pragma solidity 0.4.24;
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
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56     function totalSupply() public view returns (uint256);
57     function balanceOf(address who) public view returns (uint256);
58     function transfer(address to, uint256 value) public returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67     using SafeMath for uint256;
68 
69     mapping(address => uint256) internal balances;
70 
71     uint256 internal totalSupply_;
72 
73     /**
74     * @dev total number of tokens in existence
75     */
76     function totalSupply() public view returns (uint256) {
77         return totalSupply_;
78     }
79 
80     /**
81     * @dev transfer token for a specified address
82     * @param _to The address to transfer to.
83     * @param _value The amount to be transferred.
84     */
85     function transfer(address _to, uint256 _value) public returns (bool) {
86         require(_to != address(0));
87         require(_value <= balances[msg.sender]);
88 
89         // SafeMath.sub will throw if there is not enough balance.
90         balances[msg.sender] = balances[msg.sender].sub(_value);
91         balances[_to] = balances[_to].add(_value);
92         emit Transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     /**
97     * @dev Gets the balance of the specified address.
98     * @param _owner The address to query the the balance of.
99     * @return An uint256 representing the amount owned by the passed address.
100     */
101     function balanceOf(address _owner) public view returns (uint256 balance) {
102         return balances[_owner];
103     }
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111     function allowance(address owner, address spender) public view returns (uint256);
112     function transferFrom(address from, address to, uint256 value) public returns (bool);
113     function approve(address spender, uint256 value) public returns (bool);
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126     mapping (address => mapping (address => uint256)) internal allowed;
127 
128     /**
129      * @dev Transfer tokens from one address to another
130      * @param _from address The address which you want to send tokens from
131      * @param _to address The address which you want to transfer to
132      * @param _value uint256 the amount of tokens to be transferred
133      */
134     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135         require(_to != address(0));
136         require(_value <= balances[_from]);
137         require(_value <= allowed[_from][msg.sender]);
138 
139         balances[_from] = balances[_from].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142         emit Transfer(_from, _to, _value);
143         return true;
144     }
145 
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      *
149      * Beware that changing an allowance with this method brings the risk that someone may use both the old
150      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      * @param _spender The address which will spend the funds.
154      * @param _value The amount of tokens to be spent.
155      */
156     function approve(address _spender, uint256 _value) public returns (bool) {
157         allowed[msg.sender][_spender] = _value;
158         emit Approval(msg.sender, _spender, _value);
159         return true;
160     }
161 
162     /**
163      * @dev Function to check the amount of tokens that an owner allowed to a spender.
164      * @param _owner address The address which owns the funds.
165      * @param _spender address The address which will spend the funds.
166      * @return A uint256 specifying the amount of tokens still available for the spender.
167      */
168     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
169         return allowed[_owner][_spender];
170     }
171 
172     /**
173      * approve should be called when allowed[_spender] == 0. To increment
174      * allowed value is better to use this function to avoid 2 calls (and wait until
175      * the first transaction is mined)
176      * From MonolithDAO Token.sol
177      */
178     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
179         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
180         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181         return true;
182     }
183 
184     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
185         uint oldValue = allowed[msg.sender][_spender];
186         if (_subtractedValue > oldValue) {
187             allowed[msg.sender][_spender] = 0;
188         } else {
189             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
190         }
191         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192         return true;
193     }
194 }
195 
196 /**
197  * @title SafeERC20
198  * @dev Wrappers around ERC20 operations that throw on failure.
199  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
200  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
201  */
202 library SafeERC20 {
203     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
204         assert(token.transfer(to, value));
205     }
206 
207     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
208         assert(token.transferFrom(from, to, value));
209     }
210 
211     function safeApprove(ERC20 token, address spender, uint256 value) internal {
212         assert(token.approve(spender, value));
213     }
214 }
215 
216 /**
217  * @title TokenTimelock
218  * @dev TokenTimelock is a token holder contract that will allow a
219  * beneficiary to extract the tokens after a given release time
220  */
221 contract TokenTimelock {
222     using SafeERC20 for ERC20Basic;
223 
224     // ERC20 basic token contract being held
225     ERC20Basic public token;
226 
227     // beneficiary of tokens after they are released
228     address public beneficiary;
229 
230     // timestamp when token release is enabled
231     uint64 public releaseTime;
232 
233     constructor(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {
234         require(_releaseTime > uint64(block.timestamp));
235         token = _token;
236         beneficiary = _beneficiary;
237         releaseTime = _releaseTime;
238     }
239 
240     /**
241      * @notice Transfers tokens held by timelock to beneficiary.
242      */
243     function release() public {
244         require(uint64(block.timestamp) >= releaseTime);
245 
246         uint256 amount = token.balanceOf(this);
247         require(amount > 0);
248 
249         token.safeTransfer(beneficiary, amount);
250     }
251 }
252 
253 /**
254  * @title Burnable Token
255  * @dev Token that can be irreversibly burned (destroyed).
256  */
257 contract BurnableToken is BasicToken {
258 
259   event Burn(address indexed burner, uint256 value);
260 
261   /**
262    * @dev Burns a specific amount of tokens.
263    * @param _value The amount of token to be burned.
264    */
265   function burn(uint256 _value) public {
266     _burn(msg.sender, _value);
267   }
268 
269   function _burn(address _who, uint256 _value) internal {
270     require(_value <= balances[_who]);
271     // no need to require value <= totalSupply, since that would imply the
272     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
273 
274     balances[_who] = balances[_who].sub(_value);
275     totalSupply_ = totalSupply_.sub(_value);
276     emit Burn(_who, _value);
277     emit Transfer(_who, address(0), _value);
278   }
279 }
280 
281 contract Owned {
282     address public owner;
283 
284     constructor() public {
285         owner = msg.sender;
286     }
287 
288     modifier onlyOwner {
289         require(msg.sender == owner);
290         _;
291     }
292 }
293 
294 contract DepoToken is StandardToken, BurnableToken, Owned {
295     string public constant name = "Depository Network Token";
296     string public constant symbol = "DEPO";
297     uint8 public constant decimals = 18;
298 
299     /// Maximum tokens to be allocated (3 billion DEPO)
300     uint256 public constant HARD_CAP = 3000000000 * 10**uint256(decimals);
301 
302     /// This address is used to keep the tokens for sale
303     address public saleTokensAddress;
304 
305     /// This address is used to keep the bounty and airdrop tokens
306     address public bountyTokensAddress;
307 
308     /// This address is used to keep the reserve tokens
309     address public reserveTokensAddress;
310 
311     /// This address will receive the team and founders tokens once they are unlocked
312     address public teamTokensAddress;
313 
314     /// This address is used to keep the advisors tokens
315     address public advisorsTokensAddress;
316 
317     /// This address will hold the locked team tokens
318     TokenTimelock public teamTokensLock;
319 
320     /// the trading will open when this is set to true
321     bool public saleClosed = false;
322 
323     /// Some addresses are whitelisted in order to be able to distribute bounty tokens before the trading is open
324     mapping(address => bool) public whitelisted;
325 
326     /// Only allowed to execute before the token sale is closed
327     modifier beforeEnd {
328         require(!saleClosed);
329         _;
330     }
331 
332     constructor(address _teamTokensAddress, address _advisorsTokensAddress, address _reserveTokensAddress,
333                 address _saleTokensAddress, address _bountyTokensAddress) public {
334         require(_teamTokensAddress != address(0));
335         require(_advisorsTokensAddress != address(0));
336         require(_reserveTokensAddress != address(0));
337         require(_saleTokensAddress != address(0));
338         require(_bountyTokensAddress != address(0));
339 
340         teamTokensAddress = _teamTokensAddress;
341         advisorsTokensAddress = _advisorsTokensAddress;
342         reserveTokensAddress = _reserveTokensAddress;
343         saleTokensAddress = _saleTokensAddress;
344         bountyTokensAddress = _bountyTokensAddress;
345 
346         whitelisted[saleTokensAddress] = true;
347         whitelisted[bountyTokensAddress] = true;
348 
349         /// Maximum tokens to be allocated on the sale
350         /// 1.5 billion DEPO
351         uint256 saleTokens = 1500000000 * 10**uint256(decimals);
352         totalSupply_ = saleTokens;
353         balances[saleTokensAddress] = saleTokens;
354         emit Transfer(address(0), saleTokensAddress, saleTokens);
355 
356         /// Bounty and airdrop tokens - 180 million DEPO
357         uint256 bountyTokens = 180000000 * 10**uint256(decimals);
358         totalSupply_ = totalSupply_.add(bountyTokens);
359         balances[bountyTokensAddress] = bountyTokens;
360         emit Transfer(address(0), bountyTokensAddress, bountyTokens);
361 
362         /// Reserve tokens - 780 million DEPO
363         uint256 reserveTokens = 780000000 * 10**uint256(decimals);
364         totalSupply_ = totalSupply_.add(reserveTokens);
365         balances[reserveTokensAddress] = reserveTokens;
366         emit Transfer(address(0), reserveTokensAddress, reserveTokens);
367 
368         /// Team tokens - 360 million DEPO
369         uint256 teamTokens = 360000000 * 10**uint256(decimals);
370         totalSupply_ = totalSupply_.add(teamTokens);
371         teamTokensLock = new TokenTimelock(this, teamTokensAddress, uint64(now + 2 * 365 days));
372         balances[address(teamTokensLock)] = teamTokens;
373         emit Transfer(address(0), address(teamTokensLock), teamTokens);
374 
375         /// Advisors tokens - 180 million DEPO
376         uint256 advisorsTokens = 180000000 * 10**uint256(decimals);
377         totalSupply_ = totalSupply_.add(advisorsTokens);
378         balances[advisorsTokensAddress] = advisorsTokens;
379         emit Transfer(address(0), advisorsTokensAddress, advisorsTokens);
380 
381         require(totalSupply_ <= HARD_CAP);
382     }
383 
384     /// @dev the trading will open when this is set to true
385     function close() public onlyOwner beforeEnd {
386         saleClosed = true;
387     }
388 
389     /// @dev whitelist an address so it's able to transfer
390     /// before the trading is opened
391     function whitelist(address _address) external onlyOwner {
392         whitelisted[_address] = true;
393     }
394 
395     /// @dev Trading limited - requires the token sale to have closed
396     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
397         if(!saleClosed) return false;
398         return super.transferFrom(_from, _to, _value);
399     }
400 
401     /// @dev Trading limited - requires the token sale to have closed
402     function transfer(address _to, uint256 _value) public returns (bool) {
403         if(!saleClosed && !whitelisted[msg.sender]) return false;
404         return super.transfer(_to, _value);
405     }
406 }