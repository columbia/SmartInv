1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.13;
3 
4 /**
5 @title Dola Borrow Rights
6 @notice The DolaBorrowRights contract is a non-standard ERC20 token, that gives the right of holders to borrow DOLA at 0% interest.
7  As a borrower takes on DOLA debt, their DBR balance will be exhausted at 1 DBR per 1 DOLA borrowed per year.
8 */
9 contract DolaBorrowingRights {
10 
11     string public name;
12     string public symbol;
13     uint8 public constant decimals = 18;
14     uint256 public _totalSupply;
15     address public operator;
16     address public pendingOperator;
17     uint public totalDueTokensAccrued;
18     uint public replenishmentPriceBps;
19     mapping(address => uint256) public balances;
20     mapping(address => mapping(address => uint256)) public allowance;
21     uint256 internal immutable INITIAL_CHAIN_ID;
22     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
23     mapping(address => uint256) public nonces;
24     mapping (address => bool) public minters;
25     mapping (address => bool) public markets;
26     mapping (address => uint) public debts; // user => debt across all tracked markets
27     mapping (address => uint) public dueTokensAccrued; // user => amount of due tokens accrued
28     mapping (address => uint) public lastUpdated; // user => last update timestamp
29 
30     constructor(
31         uint _replenishmentPriceBps,
32         string memory _name,
33         string memory _symbol,
34         address _operator
35     ) {
36         replenishmentPriceBps = _replenishmentPriceBps;
37         name = _name;
38         symbol = _symbol;
39         operator = _operator;
40         INITIAL_CHAIN_ID = block.chainid;
41         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
42     }
43 
44     modifier onlyOperator {
45         require(msg.sender == operator, "ONLY OPERATOR");
46         _;
47     }
48     
49     /**
50     @notice Sets pending operator of the contract. Operator role must be claimed by the new oprator. Only callable by Operator.
51     @param newOperator_ The address of the newOperator
52     */
53     function setPendingOperator(address newOperator_) public onlyOperator {
54         pendingOperator = newOperator_;
55     }
56 
57     /**
58     @notice Sets the replenishment price in basis points. Replenishment price denotes the increase in DOLA debt upon forced replenishments.
59      At 10000, the cost of replenishing 1 DBR is 1 DOLA in debt. Only callable by Operator.
60     @param newReplenishmentPriceBps_ The new replen
61     */
62     function setReplenishmentPriceBps(uint newReplenishmentPriceBps_) public onlyOperator {
63         require(newReplenishmentPriceBps_ > 0, "replenishment price must be over 0");
64         require(newReplenishmentPriceBps_ <= 1_000_000, "Replenishment price cannot exceed 100 DOLA per DBR");
65         replenishmentPriceBps = newReplenishmentPriceBps_;
66     }
67     
68     /**
69     @notice claims the Operator role if set as pending operator.
70     */
71     function claimOperator() public {
72         require(msg.sender == pendingOperator, "ONLY PENDING OPERATOR");
73         operator = pendingOperator;
74         pendingOperator = address(0);
75         emit ChangeOperator(operator);
76     }
77 
78     /**
79     @notice Add a minter to the set of addresses allowed to mint DBR tokens. Only callable by Operator.
80     @param minter_ The address of the new minter.
81     */
82     function addMinter(address minter_) public onlyOperator {
83         minters[minter_] = true;
84         emit AddMinter(minter_);
85     }
86 
87     /**
88     @notice Removes a minter from the set of addresses allowe to mint DBR tokens. Only callable by Operator.
89     @param minter_ The address to be removed from the minter set.
90     */
91     function removeMinter(address minter_) public onlyOperator {
92         minters[minter_] = false;
93         emit RemoveMinter(minter_);
94     }
95     /**
96     @notice Adds a market to the set of active markets. Only callable by Operator.
97     @dev markets can be added but cannot be removed. A removed market would result in unrepayable debt for some users.
98     @param market_ The address of the new market contract to be added.
99     */
100     function addMarket(address market_) public onlyOperator {
101         markets[market_] = true;
102         emit AddMarket(market_);
103     }
104 
105     /**
106     @notice Get the total supply of DBR tokens.
107     @dev The total supply is calculated as the difference between total DBR minted and total DBR accrued.
108     @return uint representing the total supply of DBR.
109     */
110     function totalSupply() public view returns (uint) {
111         if(totalDueTokensAccrued > _totalSupply) return 0;
112         return _totalSupply - totalDueTokensAccrued;
113     }
114 
115     /**
116     @notice Get the DBR balance of an address. Will return 0 if the user has zero DBR or a deficit.
117     @dev The balance of a user is calculated as the difference between the user's balance and the user's accrued DBR debt + due DBR debt.
118     @param user Address of the user.
119     @return uint representing the balance of the user.
120     */
121     function balanceOf(address user) public view returns (uint) {
122         uint debt = debts[user];
123         uint accrued = (block.timestamp - lastUpdated[user]) * debt / 365 days;
124         if(dueTokensAccrued[user] + accrued > balances[user]) return 0;
125         return balances[user] - dueTokensAccrued[user] - accrued;
126     }
127 
128     /**
129     @notice Get the DBR deficit of an address. Will return 0 if th user has zero DBR or more.
130     @dev The deficit of a user is calculated as the difference between the user's accrued DBR deb + due DBR debt and their balance.
131     @param user Address of the user.
132     @return uint representing the deficit of the user.
133     */
134     function deficitOf(address user) public view returns (uint) {
135         uint debt = debts[user];
136         uint accrued = (block.timestamp - lastUpdated[user]) * debt / 365 days;
137         if(dueTokensAccrued[user] + accrued < balances[user]) return 0;
138         return dueTokensAccrued[user] + accrued - balances[user];
139     }
140     
141     /**
142     @notice Get the signed DBR balance of an address.
143     @dev This function will revert if a user has a balance of more than 2^255-1 DBR
144     @param user Address of the user.
145     @return Returns a signed int of the user's balance
146     */
147     function signedBalanceOf(address user) public view returns (int) {
148         uint debt = debts[user];
149         uint accrued = (block.timestamp - lastUpdated[user]) * debt / 365 days;
150         return int(balances[user]) - int(dueTokensAccrued[user]) - int(accrued);
151     }
152 
153     /**
154     @notice Approves spender to spend amount of DBR on behalf of the message sender.
155     @param spender Address of the spender to be approved
156     @param amount Amount to be approved to spend
157     @return Always returns true, will revert if not successful.
158     */
159     function approve(address spender, uint256 amount) public virtual returns (bool) {
160         allowance[msg.sender][spender] = amount;
161         emit Approval(msg.sender, spender, amount);
162         return true;
163     }
164 
165     /**
166     @notice Transfers amount to address to from message sender.
167     @param to The address to transfer to
168     @param amount The amount of DBR to transfer
169     @return Always returns true, will revert if not successful.
170     */
171     function transfer(address to, uint256 amount) public virtual returns (bool) {
172         require(balanceOf(msg.sender) >= amount, "Insufficient balance");
173         balances[msg.sender] -= amount;
174         unchecked {
175             balances[to] += amount;
176         }
177         emit Transfer(msg.sender, to, amount);
178         return true;
179     }
180 
181     /**
182     @notice Transfer amount of DBR  on behalf of address from to address to. Message sender must have a sufficient allowance from the from address.
183     @dev Allowance is reduced by the amount transferred.
184     @param from Address to transfer from.
185     @param to Address to transfer to.
186     @param amount Amount of DBR to transfer.
187     @return Always returns true, will revert if not successful.
188     */
189     function transferFrom(
190         address from,
191         address to,
192         uint256 amount
193     ) public virtual returns (bool) {
194         uint256 allowed = allowance[from][msg.sender];
195         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
196         require(balanceOf(from) >= amount, "Insufficient balance");
197         balances[from] -= amount;
198         unchecked {
199             balances[to] += amount;
200         }
201         emit Transfer(from, to, amount);
202         return true;
203     }
204 
205     /**
206     @notice Permits an address to spend on behalf of another address via a signed message.
207     @dev Can be bundled with a transferFrom call, to reduce transaction load on users.
208     @param owner Address of the owner permitting the spending
209     @param spender Address allowed to spend on behalf of owner.
210     @param value Amount to be allowed to spend.
211     @param deadline Timestamp after which the signed message is no longer valid.
212     @param v The v param of the ECDSA signature
213     @param r The r param of the ECDSA signature
214     @param s The s param of the ECDSA signature
215     */
216     function permit(
217         address owner,
218         address spender,
219         uint256 value,
220         uint256 deadline,
221         uint8 v,
222         bytes32 r,
223         bytes32 s
224     ) public virtual {
225         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
226         unchecked {
227             address recoveredAddress = ecrecover(
228                 keccak256(
229                     abi.encodePacked(
230                         "\x19\x01",
231                         DOMAIN_SEPARATOR(),
232                         keccak256(
233                             abi.encode(
234                                 keccak256(
235                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
236                                 ),
237                                 owner,
238                                 spender,
239                                 value,
240                                 nonces[owner]++,
241                                 deadline
242                             )
243                         )
244                     )
245                 ),
246                 v,
247                 r,
248                 s
249             );
250             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
251             allowance[recoveredAddress][spender] = value;
252         }
253         emit Approval(owner, spender, value);
254     }
255 
256     /**
257     @notice Function for invalidating the nonce of a signed message.
258     */
259     function invalidateNonce() public {
260         nonces[msg.sender]++;
261     }
262 
263     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
264         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
265     }
266 
267     function computeDomainSeparator() internal view virtual returns (bytes32) {
268         return
269             keccak256(
270                 abi.encode(
271                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
272                     keccak256(bytes(name)),
273                     keccak256("1"),
274                     block.chainid,
275                     address(this)
276                 )
277             );
278     }
279 
280     /**
281     @notice Accrue due DBR debt of user
282     @dev DBR debt is accrued at a rate of 1 DBR per 1 DOLA of debt per year.
283     @param user The address of the user to accrue DBR debt to.
284     */
285     function accrueDueTokens(address user) public {
286         uint debt = debts[user];
287         if(lastUpdated[user] == block.timestamp) return;
288         uint accrued = (block.timestamp - lastUpdated[user]) * debt / 365 days;
289         if(accrued > 0 || lastUpdated[user] == 0){
290             dueTokensAccrued[user] += accrued;
291             totalDueTokensAccrued += accrued;
292             lastUpdated[user] = block.timestamp;
293             emit Transfer(user, address(0), accrued);
294         }
295     }
296 
297     /**
298     @notice Function to be called by markets when a borrow occurs.
299     @dev Accrues due tokens on behalf of the user, before increasing their debt.
300     @param user The address of the borrower
301     @param additionalDebt The additional amount of DOLA the user is borrowing
302     */
303     function onBorrow(address user, uint additionalDebt) public {
304         require(markets[msg.sender], "Only markets can call onBorrow");
305         accrueDueTokens(user);
306         require(deficitOf(user) == 0, "DBR Deficit");
307         debts[user] += additionalDebt;
308     }
309 
310     /**
311     @notice Function to be called by markets when a repayment occurs.
312     @dev Accrues due tokens on behalf of the user, before reducing their debt.
313     @param user The address of the borrower having their debt repaid
314     @param repaidDebt The amount of DOLA repaid
315     */
316     function onRepay(address user, uint repaidDebt) public {
317         require(markets[msg.sender], "Only markets can call onRepay");
318         accrueDueTokens(user);
319         debts[user] -= repaidDebt;
320     }
321 
322     /**
323     @notice Function to be called by markets when a force replenish occurs. This function can only be called if the user has a DBR deficit.
324     @dev Accrues due tokens on behalf of the user, before increasing their debt by the replenishment price and minting them new DBR.
325     @param user The user to be force replenished.
326     @param amount The amount of DBR the user will be force replenished.
327     */
328     function onForceReplenish(address user, address replenisher, uint amount, uint replenisherReward) public {
329         require(markets[msg.sender], "Only markets can call onForceReplenish");
330         uint deficit = deficitOf(user);
331         require(deficit > 0, "No deficit");
332         require(deficit >= amount, "Amount > deficit");
333         uint replenishmentCost = amount * replenishmentPriceBps / 10000;
334         accrueDueTokens(user);
335         debts[user] += replenishmentCost;
336         _mint(user, amount);
337         emit ForceReplenish(user, replenisher, msg.sender, amount, replenishmentCost, replenisherReward);
338     }
339 
340     /**
341     @notice Function for burning DBR from message sender, reducing supply.
342     @param amount Amount to be burned
343     */
344     function burn(uint amount) public {
345         _burn(msg.sender, amount);
346     }
347 
348     /**
349     @notice Function for minting new DBR, increasing supply. Only callable by minters and the operator.
350     @param to Address to mint DBR to.
351     @param amount Amount of DBR to mint.
352     */
353     function mint(address to, uint amount) public {
354         require(minters[msg.sender] == true || msg.sender == operator, "ONLY MINTERS OR OPERATOR");
355         _mint(to, amount);
356     }
357 
358     /**
359     @notice Internal function for minting DBR.
360     @param to Address to mint DBR to.
361     @param amount Amount of DBR to mint.
362     */
363     function _mint(address to, uint256 amount) internal virtual {
364         _totalSupply += amount;
365         unchecked {
366             balances[to] += amount;
367         }
368         emit Transfer(address(0), to, amount);
369     }
370 
371     /**
372     @notice Internal function for burning DBR.
373     @param from Address to burn DBR from.
374     @param amount Amount of DBR to be burned.
375     */
376     function _burn(address from, uint256 amount) internal virtual {
377         require(balanceOf(from) >= amount, "Insufficient balance");
378         balances[from] -= amount;
379         unchecked {
380             _totalSupply -= amount;
381         }
382         emit Transfer(from, address(0), amount);
383     }
384 
385     event Transfer(address indexed from, address indexed to, uint256 amount);
386     event Approval(address indexed owner, address indexed spender, uint256 amount);
387     event AddMinter(address indexed minter);
388     event RemoveMinter(address indexed minter);
389     event AddMarket(address indexed market);
390     event ChangeOperator(address indexed newOperator);
391     event ForceReplenish(address indexed account, address indexed replenisher, address indexed market, uint deficit, uint replenishmentCost, uint replenisherReward);
392 
393 }