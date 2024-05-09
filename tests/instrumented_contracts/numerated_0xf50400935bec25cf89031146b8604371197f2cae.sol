1 pragma solidity 0.4.19;
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
67         Transfer(msg.sender, _to, _value);
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
94  * @title SafeERC20
95  * @dev Wrappers around ERC20 operations that throw on failure.
96  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
97  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
98  */
99 library SafeERC20 {
100     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
101         assert(token.transfer(to, value));
102     }
103 
104     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
105         assert(token.transferFrom(from, to, value));
106     }
107 
108     function safeApprove(ERC20 token, address spender, uint256 value) internal {
109         assert(token.approve(spender, value));
110     }
111 }
112 
113 /**
114  * @title TokenTimelock
115  * @dev TokenTimelock is a token holder contract that will allow a
116  * beneficiary to extract the tokens after a given release time
117  */
118 contract TokenTimelock {
119     using SafeERC20 for ERC20Basic;
120 
121     // ERC20 basic token contract being held
122     ERC20Basic public token;
123 
124     // beneficiary of tokens after they are released
125     address public beneficiary;
126 
127     // timestamp when token release is enabled
128     uint64 public releaseTime;
129 
130     function TokenTimelock(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {
131         require(_releaseTime > uint64(block.timestamp));
132         token = _token;
133         beneficiary = _beneficiary;
134         releaseTime = _releaseTime;
135     }
136 
137     /**
138      * @notice Transfers tokens held by timelock to beneficiary.
139      */
140     function release() public {
141         require(uint64(block.timestamp) >= releaseTime);
142 
143         uint256 amount = token.balanceOf(this);
144         require(amount > 0);
145 
146         token.safeTransfer(beneficiary, amount);
147     }
148 }
149 
150 /**
151  * @title Standard ERC20 token
152  *
153  * @dev Implementation of the basic standard token.
154  * @dev https://github.com/ethereum/EIPs/issues/20
155  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
156  */
157 contract StandardToken is ERC20, BasicToken {
158 
159     mapping (address => mapping (address => uint256)) internal allowed;
160 
161 
162     /**
163      * @dev Transfer tokens from one address to another
164      * @param _from address The address which you want to send tokens from
165      * @param _to address The address which you want to transfer to
166      * @param _value uint256 the amount of tokens to be transferred
167      */
168     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
169         require(_to != address(0));
170         require(_value <= balances[_from]);
171         require(_value <= allowed[_from][msg.sender]);
172 
173         balances[_from] = balances[_from].sub(_value);
174         balances[_to] = balances[_to].add(_value);
175         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
176         Transfer(_from, _to, _value);
177         return true;
178     }
179 
180     /**
181      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
182      *
183      * Beware that changing an allowance with this method brings the risk that someone may use both the old
184      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
185      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
186      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187      * @param _spender The address which will spend the funds.
188      * @param _value The amount of tokens to be spent.
189      */
190     function approve(address _spender, uint256 _value) public returns (bool) {
191         allowed[msg.sender][_spender] = _value;
192         Approval(msg.sender, _spender, _value);
193         return true;
194     }
195 
196     /**
197      * @dev Function to check the amount of tokens that an owner allowed to a spender.
198      * @param _owner address The address which owns the funds.
199      * @param _spender address The address which will spend the funds.
200      * @return A uint256 specifying the amount of tokens still available for the spender.
201      */
202     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
203         return allowed[_owner][_spender];
204     }
205 
206     /**
207      * approve should be called when allowed[_spender] == 0. To increment
208      * allowed value is better to use this function to avoid 2 calls (and wait until
209      * the first transaction is mined)
210      * From MonolithDAO Token.sol
211      */
212     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
213         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
214         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217 
218     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
219         uint oldValue = allowed[msg.sender][_spender];
220         if (_subtractedValue > oldValue) {
221             allowed[msg.sender][_spender] = 0;
222         } else {
223             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224         }
225         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226         return true;
227     }
228 }
229 
230 /**
231  * @title Burnable Token
232  * @dev Token that can be irreversibly burned (destroyed).
233  */
234 contract BurnableToken is StandardToken {
235 
236     event Burn(address indexed burner, uint256 value);
237 
238     /**
239      * @dev Burns a specific amount of tokens.
240      * @param _value The amount of token to be burned.
241      */
242     function burn(uint256 _value) public {
243         require(_value > 0);
244         require(_value <= balances[msg.sender]);
245         // no need to require value <= totalSupply, since that would imply the
246         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
247 
248         address burner = msg.sender;
249         balances[burner] = balances[burner].sub(_value);
250         totalSupply = totalSupply.sub(_value);
251         Burn(burner, _value);
252     }
253 }
254 
255 contract Owned {
256     address public owner;
257 
258     function Owned() public {
259         owner = msg.sender;
260     }
261 
262     modifier onlyOwner {
263         require(msg.sender == owner);
264         _;
265     }
266 }
267 
268 contract MobilinkToken is BurnableToken, Owned {
269     string public constant name = "Mobilink";
270     string public constant symbol = "MBX";
271     uint8 public constant decimals = 18;
272 
273     /// Maximum tokens to be allocated (9 billion)
274     uint256 public constant HARD_CAP = 9000000000 * 10**uint256(decimals);
275 
276     /// The owner of this address is the Mobilink team
277     address public mobilinkTeamAddress;
278 
279     /// The owner of this address is the Mobilink Reserve
280     address public reserveAddress;
281 
282     /// Time lock contract that holds the team tokens for 90 days
283     address public teamTokensLockAddress;
284 
285     /// This is the Build Out address
286     address public buildOutAddress;
287 
288     /// This address is used to keep the tokens for sale
289     address public saleTokensVault;
290 
291     /// when stage 1 is closed, the trading is open
292     bool public stageOneClosed = false;
293 
294     /// no tokens can be ever issued when this is set to "true"
295     bool public stageTwoClosed = false;
296 
297     /// Only allowed to execute before the first stage is closed
298     modifier beforeStageOneClosed {
299         require(!stageOneClosed && !stageTwoClosed);
300         _;
301     }
302 
303     /// Only allowed to execute after the first stage is closed
304     modifier afterStageOneClosed {
305         require(stageOneClosed && !stageTwoClosed);
306         _;
307     }
308 
309     function MobilinkToken(address _mobilinkTeamAddress, address _reserveAddress,
310                            address _buildOutAddress, address _saleTokensVault) public {
311         require(_mobilinkTeamAddress != address(0));
312         require(_reserveAddress != address(0));
313         require(_buildOutAddress != address(0));
314         require(_saleTokensVault != address(0));
315 
316         mobilinkTeamAddress = _mobilinkTeamAddress;
317         reserveAddress = _reserveAddress;
318         buildOutAddress = _buildOutAddress;
319         saleTokensVault = _saleTokensVault;
320 
321         /// Maximum tokens to be allocated on the sale
322         /// (4.14 billion = 0.144 bounty + 0.9 private sale + 3.096 public sale)
323         uint256 saleTokens = 4140000000 * 10**uint256(decimals);
324         totalSupply = saleTokens;
325         balances[saleTokensVault] = saleTokens;
326 
327         /// Reserve tokens - 2.61 billion
328         uint256 reserveTokens = 2610000000 * 10**uint256(decimals);
329         totalSupply = totalSupply.add(reserveTokens);
330         balances[reserveAddress] = reserveTokens;
331 
332         /// Build Out tokens - 0.9 billion
333         uint256 buildOutTokens = 900000000 * 10**uint256(decimals);
334         totalSupply = totalSupply.add(buildOutTokens);
335         balances[buildOutAddress] = buildOutTokens;
336     }
337 
338     /// @dev Close the first stage; issue reserve and team tokens
339     function closeStageOne() public onlyOwner beforeStageOneClosed {
340         stageOneClosed = true;
341     }
342 
343     /// @dev Close the second stage and overall sale
344     function closeStageTwo() public onlyOwner afterStageOneClosed {
345         stageTwoClosed = true;
346     }
347 
348     /// @dev Issue the team tokens
349     /// and lock them for 90 days from the day the token is listed on an exchange
350     function lockTeamTokens() public onlyOwner afterStageOneClosed {
351         require(teamTokensLockAddress == address(0) && totalSupply < HARD_CAP);
352  
353         /// Team tokens : 1.35 billion
354         uint256 teamTokens = 1350000000 * 10**uint256(decimals);
355 
356         /// team tokens are locked for 90 days
357         TokenTimelock teamTokensLock = new TokenTimelock(this, mobilinkTeamAddress, uint64(block.timestamp) + 60 * 60 * 24 * 90);
358         teamTokensLockAddress = address(teamTokensLock);
359         totalSupply = totalSupply.add(teamTokens);
360         balances[teamTokensLockAddress] = teamTokens;
361     }
362 
363     /// @dev Trading limited - requires the first stage to have closed
364     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
365         if(stageOneClosed) {
366             return super.transferFrom(_from, _to, _value);
367         }
368         return false;
369     }
370 
371     /// @dev Trading limited - requires the first stage to have closed
372     function transfer(address _to, uint256 _value) public returns (bool) {
373         if(stageOneClosed || msg.sender == owner || (msg.sender == saleTokensVault && _to == owner)) {
374             return super.transfer(_to, _value);
375         }
376         return false;
377     }
378 }