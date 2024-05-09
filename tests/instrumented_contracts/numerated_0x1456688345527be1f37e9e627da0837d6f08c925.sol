1 // File: contracts/VaultParameters.sol
2 
3 /*
4   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
5 */
6 pragma solidity ^0.7.1;
7 
8 
9 /**
10  * @title Auth
11  * @author Unit Protocol: Ivan Zakharov (@34x4p08)
12  * @dev Manages USDP's system access
13  **/
14 contract Auth {
15 
16     // address of the the contract with vault parameters
17     VaultParameters public vaultParameters;
18 
19     constructor(address _parameters) public {
20         vaultParameters = VaultParameters(_parameters);
21     }
22 
23     // ensures tx's sender is a manager
24     modifier onlyManager() {
25         require(vaultParameters.isManager(msg.sender), "Unit Protocol: AUTH_FAILED");
26         _;
27     }
28 
29     // ensures tx's sender is able to modify the Vault
30     modifier hasVaultAccess() {
31         require(vaultParameters.canModifyVault(msg.sender), "Unit Protocol: AUTH_FAILED");
32         _;
33     }
34 
35     // ensures tx's sender is the Vault
36     modifier onlyVault() {
37         require(msg.sender == vaultParameters.vault(), "Unit Protocol: AUTH_FAILED");
38         _;
39     }
40 }
41 
42 
43 /**
44  * @title VaultParameters
45  * @author Unit Protocol: Ivan Zakharov (@34x4p08)
46  **/
47 contract VaultParameters is Auth {
48 
49     // map token to stability fee percentage; 3 decimals
50     mapping(address => uint) public stabilityFee;
51 
52     // map token to liquidation fee percentage, 0 decimals
53     mapping(address => uint) public liquidationFee;
54 
55     // map token to USDP mint limit
56     mapping(address => uint) public tokenDebtLimit;
57 
58     // permissions to modify the Vault
59     mapping(address => bool) public canModifyVault;
60 
61     // managers
62     mapping(address => bool) public isManager;
63 
64     // enabled oracle types
65     mapping(uint => mapping (address => bool)) public isOracleTypeEnabled;
66 
67     // address of the Vault
68     address payable public vault;
69 
70     // The foundation address
71     address public foundation;
72 
73     /**
74      * The address for an Ethereum contract is deterministically computed from the address of its creator (sender)
75      * and how many transactions the creator has sent (nonce). The sender and nonce are RLP encoded and then
76      * hashed with Keccak-256.
77      * Therefore, the Vault address can be pre-computed and passed as an argument before deployment.
78     **/
79     constructor(address payable _vault, address _foundation) public Auth(address(this)) {
80         require(_vault != address(0), "Unit Protocol: ZERO_ADDRESS");
81         require(_foundation != address(0), "Unit Protocol: ZERO_ADDRESS");
82 
83         isManager[msg.sender] = true;
84         vault = _vault;
85         foundation = _foundation;
86     }
87 
88     /**
89      * @notice Only manager is able to call this function
90      * @dev Grants and revokes manager's status of any address
91      * @param who The target address
92      * @param permit The permission flag
93      **/
94     function setManager(address who, bool permit) external onlyManager {
95         isManager[who] = permit;
96     }
97 
98     /**
99      * @notice Only manager is able to call this function
100      * @dev Sets the foundation address
101      * @param newFoundation The new foundation address
102      **/
103     function setFoundation(address newFoundation) external onlyManager {
104         require(newFoundation != address(0), "Unit Protocol: ZERO_ADDRESS");
105         foundation = newFoundation;
106     }
107 
108     /**
109      * @notice Only manager is able to call this function
110      * @dev Sets ability to use token as the main collateral
111      * @param asset The address of the main collateral token
112      * @param stabilityFeeValue The percentage of the year stability fee (3 decimals)
113      * @param liquidationFeeValue The liquidation fee percentage (0 decimals)
114      * @param usdpLimit The USDP token issue limit
115      * @param oracles The enables oracle types
116      **/
117     function setCollateral(
118         address asset,
119         uint stabilityFeeValue,
120         uint liquidationFeeValue,
121         uint usdpLimit,
122         uint[] calldata oracles
123     ) external onlyManager {
124         setStabilityFee(asset, stabilityFeeValue);
125         setLiquidationFee(asset, liquidationFeeValue);
126         setTokenDebtLimit(asset, usdpLimit);
127         for (uint i=0; i < oracles.length; i++) {
128             setOracleType(oracles[i], asset, true);
129         }
130     }
131 
132     /**
133      * @notice Only manager is able to call this function
134      * @dev Sets a permission for an address to modify the Vault
135      * @param who The target address
136      * @param permit The permission flag
137      **/
138     function setVaultAccess(address who, bool permit) external onlyManager {
139         canModifyVault[who] = permit;
140     }
141 
142     /**
143      * @notice Only manager is able to call this function
144      * @dev Sets the percentage of the year stability fee for a particular collateral
145      * @param asset The address of the main collateral token
146      * @param newValue The stability fee percentage (3 decimals)
147      **/
148     function setStabilityFee(address asset, uint newValue) public onlyManager {
149         stabilityFee[asset] = newValue;
150     }
151 
152     /**
153      * @notice Only manager is able to call this function
154      * @dev Sets the percentage of the liquidation fee for a particular collateral
155      * @param asset The address of the main collateral token
156      * @param newValue The liquidation fee percentage (0 decimals)
157      **/
158     function setLiquidationFee(address asset, uint newValue) public onlyManager {
159         require(newValue <= 100, "Unit Protocol: VALUE_OUT_OF_RANGE");
160         liquidationFee[asset] = newValue;
161     }
162 
163     /**
164      * @notice Only manager is able to call this function
165      * @dev Enables/disables oracle types
166      * @param _type The type of the oracle
167      * @param asset The address of the main collateral token
168      * @param enabled The control flag
169      **/
170     function setOracleType(uint _type, address asset, bool enabled) public onlyManager {
171         isOracleTypeEnabled[_type][asset] = enabled;
172     }
173 
174     /**
175      * @notice Only manager is able to call this function
176      * @dev Sets USDP limit for a specific collateral
177      * @param asset The address of the main collateral token
178      * @param limit The limit number
179      **/
180     function setTokenDebtLimit(address asset, uint limit) public onlyManager {
181         tokenDebtLimit[asset] = limit;
182     }
183 }
184 
185 // File: contracts/helpers/SafeMath.sol
186 
187 /*
188   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
189 */
190 pragma solidity ^0.7.1;
191 
192 
193 /**
194  * @title SafeMath
195  * @dev Math operations with safety checks that throw on error
196  */
197 library SafeMath {
198 
199     /**
200     * @dev Multiplies two numbers, throws on overflow.
201     */
202     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
203         if (a == 0) {
204             return 0;
205         }
206         c = a * b;
207         assert(c / a == b);
208         return c;
209     }
210 
211     /**
212     * @dev Integer division of two numbers, truncating the quotient.
213     */
214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
215         require(b != 0, "SafeMath: division by zero");
216         return a / b;
217     }
218 
219     /**
220     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
221     */
222     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223         assert(b <= a);
224         return a - b;
225     }
226 
227     /**
228     * @dev Adds two numbers, throws on overflow.
229     */
230     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
231         c = a + b;
232         assert(c >= a);
233         return c;
234     }
235 }
236 
237 // File: contracts/USDP.sol
238 
239 /*
240   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
241 */
242 pragma solidity ^0.7.1;
243 
244 
245 
246 
247 /**
248  * @title USDP token implementation
249  * @author Unit Protocol: Ivan Zakharov (@34x4p08)
250  * @dev ERC20 token
251  **/
252 contract USDP is Auth {
253     using SafeMath for uint;
254 
255     // name of the token
256     string public constant name = "USDP Stablecoin";
257 
258     // symbol of the token
259     string public constant symbol = "USDP";
260 
261     // version of the token
262     string public constant version = "1";
263 
264     // number of decimals the token uses
265     uint8 public constant decimals = 18;
266 
267     // total token supply
268     uint public totalSupply;
269 
270     // balance information map
271     mapping(address => uint) public balanceOf;
272 
273     // token allowance mapping
274     mapping(address => mapping(address => uint)) public allowance;
275 
276     /**
277      * @dev Trigger on any successful call to approve(address spender, uint amount)
278     **/
279     event Approval(address indexed owner, address indexed spender, uint value);
280 
281     /**
282      * @dev Trigger when tokens are transferred, including zero value transfers
283     **/
284     event Transfer(address indexed from, address indexed to, uint value);
285 
286     /**
287       * @param _parameters The address of system parameters contract
288      **/
289     constructor(address _parameters) public Auth(_parameters) {}
290 
291     /**
292       * @notice Only Vault can mint USDP
293       * @dev Mints 'amount' of tokens to address 'to', and MUST fire the
294       * Transfer event
295       * @param to The address of the recipient
296       * @param amount The amount of token to be minted
297      **/
298     function mint(address to, uint amount) external onlyVault {
299         require(to != address(0), "Unit Protocol: ZERO_ADDRESS");
300 
301         balanceOf[to] = balanceOf[to].add(amount);
302         totalSupply = totalSupply.add(amount);
303 
304         emit Transfer(address(0), to, amount);
305     }
306 
307     /**
308       * @notice Only manager can burn tokens from manager's balance
309       * @dev Burns 'amount' of tokens, and MUST fire the Transfer event
310       * @param amount The amount of token to be burned
311      **/
312     function burn(uint amount) external onlyManager {
313         _burn(msg.sender, amount);
314     }
315 
316     /**
317       * @notice Only Vault can burn tokens from any balance
318       * @dev Burns 'amount' of tokens from 'from' address, and MUST fire the Transfer event
319       * @param from The address of the balance owner
320       * @param amount The amount of token to be burned
321      **/
322     function burn(address from, uint amount) external onlyVault {
323         _burn(from, amount);
324     }
325 
326     /**
327       * @dev Transfers 'amount' of tokens to address 'to', and MUST fire the Transfer event. The
328       * function SHOULD throw if the _from account balance does not have enough tokens to spend.
329       * @param to The address of the recipient
330       * @param amount The amount of token to be transferred
331      **/
332     function transfer(address to, uint amount) external returns (bool) {
333         return transferFrom(msg.sender, to, amount);
334     }
335 
336     /**
337       * @dev Transfers 'amount' of tokens from address 'from' to address 'to', and MUST fire the
338       * Transfer event
339       * @param from The address of the sender
340       * @param to The address of the recipient
341       * @param amount The amount of token to be transferred
342      **/
343     function transferFrom(address from, address to, uint amount) public returns (bool) {
344         require(to != address(0), "Unit Protocol: ZERO_ADDRESS");
345         require(balanceOf[from] >= amount, "Unit Protocol: INSUFFICIENT_BALANCE");
346 
347         if (from != msg.sender) {
348             require(allowance[from][msg.sender] >= amount, "Unit Protocol: INSUFFICIENT_ALLOWANCE");
349             _approve(from, msg.sender, allowance[from][msg.sender].sub(amount));
350         }
351         balanceOf[from] = balanceOf[from].sub(amount);
352         balanceOf[to] = balanceOf[to].add(amount);
353 
354         emit Transfer(from, to, amount);
355         return true;
356     }
357 
358     /**
359       * @dev Allows 'spender' to withdraw from your account multiple times, up to the 'amount' amount. If
360       * this function is called again it overwrites the current allowance with 'amount'.
361       * @param spender The address of the account able to transfer the tokens
362       * @param amount The amount of tokens to be approved for transfer
363      **/
364     function approve(address spender, uint amount) external returns (bool) {
365         _approve(msg.sender, spender, amount);
366         return true;
367     }
368 
369     /**
370      * @dev Atomically increases the allowance granted to `spender` by the caller.
371      *
372      * This is an alternative to `approve` that can be used as a mitigation for
373      * problems described in `IERC20.approve`.
374      *
375      * Emits an `Approval` event indicating the updated allowance.
376      *
377      * Requirements:
378      *
379      * - `spender` cannot be the zero address.
380      */
381     function increaseAllowance(address spender, uint addedValue) public virtual returns (bool) {
382         _approve(msg.sender, spender, allowance[msg.sender][spender].add(addedValue));
383         return true;
384     }
385 
386     /**
387      * @dev Atomically decreases the allowance granted to `spender` by the caller.
388      *
389      * This is an alternative to `approve` that can be used as a mitigation for
390      * problems described in `IERC20.approve`.
391      *
392      * Emits an `Approval` event indicating the updated allowance.
393      *
394      * Requirements:
395      *
396      * - `spender` cannot be the zero address.
397      * - `spender` must have allowance for the caller of at least
398      * `subtractedValue`.
399      */
400     function decreaseAllowance(address spender, uint subtractedValue) public virtual returns (bool) {
401         _approve(msg.sender, spender, allowance[msg.sender][spender].sub(subtractedValue));
402         return true;
403     }
404 
405     function _approve(address owner, address spender, uint amount) internal virtual {
406         require(owner != address(0), "Unit Protocol: approve from the zero address");
407         require(spender != address(0), "Unit Protocol: approve to the zero address");
408 
409         allowance[owner][spender] = amount;
410         emit Approval(owner, spender, amount);
411     }
412 
413     function _burn(address from, uint amount) internal virtual {
414         balanceOf[from] = balanceOf[from].sub(amount);
415         totalSupply = totalSupply.sub(amount);
416 
417         emit Transfer(from, address(0), amount);
418     }
419 }