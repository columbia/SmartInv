1 pragma solidity 0.4.23;
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
294 contract HashcardToken is StandardToken, BurnableToken, Owned {
295     string public constant name = "Hash Card";
296     string public constant symbol = "HSHC";
297     uint8 public constant decimals = 18;
298 
299     /// Maximum tokens to be allocated (150 million)
300     uint256 public constant HARD_CAP = 150000000 * 10**uint256(decimals);
301 
302     /// This address is used to keep the tokens for sale
303     address public saleTokensAddress;
304 
305     /// This address is used to keep the bounty tokens
306     address public bountyTokensAddress;
307 
308     /// This address is used to keep the reserve tokens
309     address public reserveTokensAddress;
310 
311     /// This address will receive the team tokens once they are unlocked
312     address public teamTokensAddress;
313 
314     /// This address will receive the advisors tokens once they are unlocked
315     address public advisorsTokensAddress;
316 
317     /// This address will hold the locked Team tokens
318     TokenTimelock public teamTokensLock;
319 
320     /// This address will hold the locked Advisors tokens
321     TokenTimelock public advisorsTokensLock;
322 
323     /// Team and Advisors unlock date (01 Nov 2019)
324     uint64 private constant date01Nov2019 = 1572566400;
325 
326     /// the trading will open when this is set to true
327     bool public saleClosed = false;
328 
329     /// Only the team is allowed to execute
330     modifier onlySaleTeam {
331         require(msg.sender == saleTokensAddress || msg.sender == bountyTokensAddress);
332         _;
333     }
334 
335     /// Only allowed to execute before the token sale is closed
336     modifier beforeEnd {
337         require(!saleClosed);
338         _;
339     }
340 
341     constructor(address _teamTokensAddress, address _advisorsTokensAddress, address _reserveTokensAddress,
342                 address _saleTokensAddress, address _bountyTokensAddress) public {
343         require(_teamTokensAddress != address(0));
344         require(_advisorsTokensAddress != address(0));
345         require(_reserveTokensAddress != address(0));
346         require(_saleTokensAddress != address(0));
347         require(_bountyTokensAddress != address(0));
348 
349         teamTokensAddress = _teamTokensAddress;
350         advisorsTokensAddress = _advisorsTokensAddress;
351         reserveTokensAddress = _reserveTokensAddress;
352         saleTokensAddress = _saleTokensAddress;
353         bountyTokensAddress = _bountyTokensAddress;
354 
355         /// Maximum tokens to be allocated on the sale
356         /// 90 million HSHC
357         uint256 saleTokens = 90000000 * 10**uint256(decimals);
358         totalSupply_ = saleTokens;
359         balances[saleTokensAddress] = saleTokens;
360         emit Transfer(address(0), saleTokensAddress, saleTokens);
361 
362         /// Bounty tokens - 6 million HSHC
363         uint256 bountyTokens = 6000000 * 10**uint256(decimals);
364         totalSupply_ = totalSupply_.add(bountyTokens);
365         balances[bountyTokensAddress] = bountyTokens;
366         emit Transfer(address(0), bountyTokensAddress, bountyTokens);
367 
368         /// Reserve tokens - 24 million HSHC
369         uint256 reserveTokens = 24000000 * 10**uint256(decimals);
370         totalSupply_ = totalSupply_.add(reserveTokens);
371         balances[reserveTokensAddress] = reserveTokens;
372         emit Transfer(address(0), reserveTokensAddress, reserveTokens);
373 
374         /// Team tokens - 22.5M HSHC
375         uint256 teamTokens = 22500000 * 10**uint256(decimals);
376         totalSupply_ = totalSupply_.add(teamTokens);
377         teamTokensLock = new TokenTimelock(this, teamTokensAddress, date01Nov2019);
378         balances[address(teamTokensLock)] = teamTokens;
379         emit Transfer(address(0), address(teamTokensLock), teamTokens);
380 
381         /// Advisors tokens - 7.5M HSHC
382         uint256 advisorsTokens = 7500000 * 10**uint256(decimals);
383         totalSupply_ = totalSupply_.add(advisorsTokens);
384         advisorsTokensLock = new TokenTimelock(this, advisorsTokensAddress, date01Nov2019);
385         balances[address(advisorsTokensLock)] = advisorsTokens;
386         emit Transfer(address(0), address(advisorsTokensLock), advisorsTokens);
387     }
388 
389     function close() public onlyOwner beforeEnd {
390         /// The unsold and unallocated bounty tokens are burnt
391 
392         _burn(saleTokensAddress, balances[saleTokensAddress]);
393         _burn(bountyTokensAddress, balances[bountyTokensAddress]);
394 
395         saleClosed = true;
396     }
397 
398     /// @dev Trading limited - requires the token sale to have closed
399     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
400         if(!saleClosed) return false;
401         return super.transferFrom(_from, _to, _value);
402     }
403 
404     /// @dev Trading limited - requires the token sale to have closed
405     function transfer(address _to, uint256 _value) public returns (bool) {
406         if(!saleClosed && msg.sender != saleTokensAddress && msg.sender != bountyTokensAddress) return false;
407         return super.transfer(_to, _value);
408     }
409 }