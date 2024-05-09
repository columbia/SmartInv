1 pragma solidity 0.4.25;
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
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68     using SafeMath for uint256;
69 
70     mapping(address => uint256) balances;
71 
72     uint256 totalSupply_;
73 
74     /**
75     * @dev total number of tokens in existence
76     */
77     function totalSupply() public view returns (uint256) {
78         return totalSupply_;
79     }
80 
81     /**
82     * @dev transfer token for a specified address
83     * @param _to The address to transfer to.
84     * @param _value The amount to be transferred.
85     */
86     function transfer(address _to, uint256 _value) public returns (bool) {
87         require(_to != address(0));
88         require(_value <= balances[msg.sender]);
89 
90         // SafeMath.sub will throw if there is not enough balance.
91         balances[msg.sender] = balances[msg.sender].sub(_value);
92         balances[_to] = balances[_to].add(_value);
93         emit Transfer(msg.sender, _to, _value);
94         return true;
95     }
96 
97     /**
98     * @dev Gets the balance of the specified address.
99     * @param _owner The address to query the the balance of.
100     * @return An uint256 representing the amount owned by the passed address.
101     */
102     function balanceOf(address _owner) public view returns (uint256 balance) {
103         return balances[_owner];
104     }
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112     function allowance(address owner, address spender) public view returns (uint256);
113     function transferFrom(address from, address to, uint256 value) public returns (bool);
114     function approve(address spender, uint256 value) public returns (bool);
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implementation of the basic standard token.
122  * @dev https://github.com/ethereum/EIPs/issues/20
123  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract StandardToken is ERC20, BasicToken {
126 
127     mapping (address => mapping (address => uint256)) internal allowed;
128 
129     /**
130      * @dev Transfer tokens from one address to another
131      * @param _from address The address which you want to send tokens from
132      * @param _to address The address which you want to transfer to
133      * @param _value uint256 the amount of tokens to be transferred
134      */
135     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136         require(_to != address(0));
137         require(_value <= balances[_from]);
138         require(_value <= allowed[_from][msg.sender]);
139 
140         balances[_from] = balances[_from].sub(_value);
141         balances[_to] = balances[_to].add(_value);
142         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143         emit Transfer(_from, _to, _value);
144         return true;
145     }
146 
147     /**
148      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149      *
150      * Beware that changing an allowance with this method brings the risk that someone may use both the old
151      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154      * @param _spender The address which will spend the funds.
155      * @param _value The amount of tokens to be spent.
156      */
157     function approve(address _spender, uint256 _value) public returns (bool) {
158         allowed[msg.sender][_spender] = _value;
159         emit Approval(msg.sender, _spender, _value);
160         return true;
161     }
162 
163     /**
164      * @dev Function to check the amount of tokens that an owner allowed to a spender.
165      * @param _owner address The address which owns the funds.
166      * @param _spender address The address which will spend the funds.
167      * @return A uint256 specifying the amount of tokens still available for the spender.
168      */
169     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
170         return allowed[_owner][_spender];
171     }
172 
173     /**
174      * approve should be called when allowed[_spender] == 0. To increment
175      * allowed value is better to use this function to avoid 2 calls (and wait until
176      * the first transaction is mined)
177      * From MonolithDAO Token.sol
178      */
179     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
180         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
181         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182         return true;
183     }
184 
185     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
186         uint oldValue = allowed[msg.sender][_spender];
187         if (_subtractedValue > oldValue) {
188             allowed[msg.sender][_spender] = 0;
189         } else {
190             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
191         }
192         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193         return true;
194     }
195 }
196 
197 /**
198  * @title SafeERC20
199  * @dev Wrappers around ERC20 operations that throw on failure.
200  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
201  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
202  */
203 library SafeERC20 {
204     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
205         assert(token.transfer(to, value));
206     }
207 
208     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
209         assert(token.transferFrom(from, to, value));
210     }
211 
212     function safeApprove(ERC20 token, address spender, uint256 value) internal {
213         assert(token.approve(spender, value));
214     }
215 }
216 
217 /**
218  * @title TokenTimelock
219  * @dev TokenTimelock is a token holder contract that will allow a
220  * beneficiary to extract the tokens after a given release time
221  */
222 contract TokenTimelock {
223     using SafeERC20 for ERC20Basic;
224 
225     // ERC20 basic token contract being held
226     ERC20Basic public token;
227 
228     // beneficiary of tokens after they are released
229     address public beneficiary;
230 
231     // timestamp when token release is enabled
232     uint64 public releaseTime;
233 
234     constructor(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {
235         require(_releaseTime > uint64(block.timestamp));
236         token = _token;
237         beneficiary = _beneficiary;
238         releaseTime = _releaseTime;
239     }
240 
241     /**
242      * @notice Transfers tokens held by timelock to beneficiary.
243      */
244     function release() public {
245         require(uint64(block.timestamp) >= releaseTime);
246 
247         uint256 amount = token.balanceOf(this);
248         require(amount > 0);
249 
250         token.safeTransfer(beneficiary, amount);
251     }
252 }
253 
254 contract Owned {
255     address public owner;
256 
257     constructor() public {
258         owner = msg.sender;
259     }
260 
261     modifier onlyOwner {
262         require(msg.sender == owner);
263         _;
264     }
265 }
266 
267 /**
268  * @title Burnable Token
269  * @dev Token that can be irreversibly burned (destroyed).
270  */
271 contract BurnableToken is StandardToken {
272 
273     event Burn(address indexed burner, uint256 value);
274 
275     /**
276      * @dev Burns a specific amount of tokens.
277      * @param _value The amount of token to be burned.
278      */
279     function burn(uint256 _value) public {
280         require(_value > 0);
281         require(_value <= balances[msg.sender]);
282         // no need to require value <= totalSupply, since that would imply the
283         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
284 
285         address burner = msg.sender;
286         balances[burner] = balances[burner].sub(_value);
287         totalSupply_ = totalSupply_.sub(_value);
288         emit Burn(burner, _value);
289     }
290 }
291 
292 contract BitwingsToken is BurnableToken, Owned {
293     string public constant name = "BITWINGS TOKEN";
294     string public constant symbol = "BWN";
295     uint8 public constant decimals = 18;
296 
297     /// Maximum tokens to be allocated (300 million BWN)
298     uint256 public constant HARD_CAP = 300000000 * 10**uint256(decimals);
299 
300     /// This address will hold the Bitwings team and advisors tokens
301     address public teamAdvisorsTokensAddress;
302 
303     /// This address is used to keep the tokens for sale
304     address public saleTokensAddress;
305 
306     /// This address is used to keep the reserve tokens
307     address public reserveTokensAddress;
308 
309     /// This address is used to keep the tokens for Gold founder, bounty and airdrop
310     address public bountyAirdropTokensAddress;
311 
312     /// This address is used to keep the tokens for referrals
313     address public referralTokensAddress;
314 
315     /// when the token sale is closed, the unsold tokens are allocated to the reserve
316     bool public saleClosed = false;
317 
318     /// Some addresses are whitelisted in order to be able to distribute advisors tokens before the trading is open
319     mapping(address => bool) public whitelisted;
320 
321     /// Only allowed to execute before the token sale is closed
322     modifier beforeSaleClosed {
323         require(!saleClosed);
324         _;
325     }
326 
327     constructor(address _teamAdvisorsTokensAddress, address _reserveTokensAddress,
328                 address _saleTokensAddress, address _bountyAirdropTokensAddress, address _referralTokensAddress) public {
329         require(_teamAdvisorsTokensAddress != address(0));
330         require(_reserveTokensAddress != address(0));
331         require(_saleTokensAddress != address(0));
332         require(_bountyAirdropTokensAddress != address(0));
333         require(_referralTokensAddress != address(0));
334 
335         teamAdvisorsTokensAddress = _teamAdvisorsTokensAddress;
336         reserveTokensAddress = _reserveTokensAddress;
337         saleTokensAddress = _saleTokensAddress;
338         bountyAirdropTokensAddress = _bountyAirdropTokensAddress;
339         referralTokensAddress = _referralTokensAddress;
340 
341         /// Maximum tokens to be allocated on the sale
342         /// 189 million BWN
343         uint256 saleTokens = 189000000 * 10**uint256(decimals);
344         totalSupply_ = saleTokens;
345         balances[saleTokensAddress] = saleTokens;
346         emit Transfer(address(0), saleTokensAddress, balances[saleTokensAddress]);
347 
348         /// Team and advisors tokens - 15 million BWN
349         uint256 teamAdvisorsTokens = 15000000 * 10**uint256(decimals);
350         totalSupply_ = totalSupply_.add(teamAdvisorsTokens);
351         balances[teamAdvisorsTokensAddress] = teamAdvisorsTokens;
352         emit Transfer(address(0), teamAdvisorsTokensAddress, balances[teamAdvisorsTokensAddress]);
353 
354         /// Reserve tokens - 60 million BWN
355         uint256 reserveTokens = 60000000 * 10**uint256(decimals);
356         totalSupply_ = totalSupply_.add(reserveTokens);
357         balances[reserveTokensAddress] = reserveTokens;
358         emit Transfer(address(0), reserveTokensAddress, balances[reserveTokensAddress]);
359 
360         /// Gold founder, bounty and airdrop tokens - 31 million BWN
361         uint256 bountyAirdropTokens = 31000000 * 10**uint256(decimals);
362         totalSupply_ = totalSupply_.add(bountyAirdropTokens);
363         balances[bountyAirdropTokensAddress] = bountyAirdropTokens;
364         emit Transfer(address(0), bountyAirdropTokensAddress, balances[bountyAirdropTokensAddress]);
365 
366         /// Referral tokens - 5 million BWN
367         uint256 referralTokens = 5000000 * 10**uint256(decimals);
368         totalSupply_ = totalSupply_.add(referralTokens);
369         balances[referralTokensAddress] = referralTokens;
370         emit Transfer(address(0), referralTokensAddress, balances[referralTokensAddress]);
371 
372         whitelisted[saleTokensAddress] = true;
373         whitelisted[teamAdvisorsTokensAddress] = true;
374         whitelisted[bountyAirdropTokensAddress] = true;
375         whitelisted[referralTokensAddress] = true;
376 
377         require(totalSupply_ == HARD_CAP);
378     }
379 
380     /// @dev reallocates the unsold tokens
381     function closeSale() external onlyOwner beforeSaleClosed {
382         /// The unsold and unallocated bounty tokens are allocated to the reserve
383 
384         uint256 unsoldTokens = balances[saleTokensAddress];
385         balances[reserveTokensAddress] = balances[reserveTokensAddress].add(unsoldTokens);
386         balances[saleTokensAddress] = 0;
387         emit Transfer(saleTokensAddress, reserveTokensAddress, unsoldTokens);
388 
389         saleClosed = true;
390     }
391 
392     /// @dev whitelist an address so it's able to transfer
393     /// before the trading is opened
394     function whitelist(address _address) external onlyOwner {
395         whitelisted[_address] = true;
396     }
397 
398     /// @dev Trading limited
399     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
400         if(saleClosed) {
401             return super.transferFrom(_from, _to, _value);
402         }
403         return false;
404     }
405 
406     /// @dev Trading limited
407     function transfer(address _to, uint256 _value) public returns (bool) {
408         if(saleClosed || whitelisted[msg.sender]) {
409             return super.transfer(_to, _value);
410         }
411         return false;
412     }
413 }