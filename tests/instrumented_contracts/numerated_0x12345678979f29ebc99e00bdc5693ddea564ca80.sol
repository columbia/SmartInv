1 pragma solidity ^0.5.3;
2 
3 // counter.market smart contracts:
4 //  1) Proxy - delegatecalls into current exchange code, maintains storage of exchange state
5 //  2) Registry - stores information on the latest exchange contract version and user approvals
6 //  3) Treasury (this one) - takes custody of funds, moves them between token accounts, authorizing exchange code via Registry
7 
8 // Counter contracts are deployed at predefined addresses which can be hardcoded.
9 contract FixedAddress {
10     address constant ProxyAddress = 0x1234567896326230a28ee368825D11fE6571Be4a;
11     address constant TreasuryAddress = 0x12345678979f29eBc99E00bdc5693ddEa564cA80;
12     address constant RegistryAddress = 0x12345678982cB986Dd291B50239295E3Cb10Cdf6;
13 
14     function getRegistry() internal pure returns (RegistryInterface) {
15         return RegistryInterface(RegistryAddress);
16     }
17 }
18 
19 // External contracts access Registry via one of these methods
20 interface RegistryInterface {
21     function getOwner() external view returns (address);
22     function getExchangeContract() external view returns (address);
23     function contractApproved(address traderAddr) external view returns (bool);
24     function contractApprovedBoth(address traderAddr1, address traderAddr2) external view returns (bool);
25     function acceptNextExchangeContract() external;
26 }
27 
28 // Access modifiers on restricted Treasury methods
29 contract AccessModifiers is FixedAddress {
30 
31     // Only the owner of the Registry contract may invoke this method.
32     modifier onlyRegistryOwner() {
33         require (msg.sender == getRegistry().getOwner(), "onlyRegistryOwner() method called by non-owner.");
34         _;
35     }
36 
37     // Method should be called by the current exchange (by delegatecall from Proxy), and trader should have approved
38     // the latest Exchange code.
39     modifier onlyApprovedExchange(address trader) {
40         require (msg.sender == ProxyAddress, "onlyApprovedExchange() called not by exchange proxy.");
41         require (getRegistry().contractApproved(trader), "onlyApprovedExchange() requires approval of the latest contract code by trader.");
42         _;
43     }
44 
45     // The same as above, but checks approvals of two traders simultaneously.
46     modifier onlyApprovedExchangeBoth(address trader1, address trader2) {
47         require (msg.sender == ProxyAddress, "onlyApprovedExchange() called not by exchange proxy.");
48         require (getRegistry().contractApprovedBoth(trader1, trader2), "onlyApprovedExchangeBoth() requires approval of the latest contract code by both traders.");
49         _;
50     }
51 
52 }
53 
54 // External contracts access Treasury via one of these methods
55 interface TreasuryInterface {
56     function withdrawEther(address traderAddr, address payable withdrawalAddr, uint amount) external;
57     function withdrawERC20Token(uint16 tokenCode, address traderAddr, address withdrawalAddr, uint amount) external;
58     function transferTokens(uint16 tokenCode, address fromAddr, address toAddr, uint amount) external;
59     function transferTokensTwice(uint16 tokenCode, address fromAddr, address toAddr1, uint amount1, address toAddr2, uint amount2) external;
60     function exchangeTokens(uint16 tokenCode1, uint16 tokenCode2, address addr1, address addr2, address addrFee, uint amount1, uint fee1, uint amount2, uint fee2) external;
61 }
62 
63 // Treasury responsibilities:
64 //  - storing the mapping of token codes to token contract addresses
65 //  - processing deposits to/withdrawals from/transfers between token accounts within itself
66 //  - processing emergency releases
67 
68 // Treasury is required because Counter is not a wallet-to-wallet exchange, and requires deposits and
69 // withdrawals in order to be able to trade. Having full control over settlement order enables Counter
70 // to be responsive on its UI by settling trades and withdrawals in background. The former
71 // operations are authorized by ECDSA signatures collected from users and effected on-chain by the
72 // Counter arbiter services.
73 
74 // Because user signatures are effected on the contract via an intermediary (the Counter arbiter),
75 // there is inherent trust issue where a trader may assume that the Counter may refuse to apply some
76 // operations on-chain (especially withdrawals), or may simply experience prolonged downtime. Hence
77 // the need for the emergency release (ER) feature, which is an ability to withdraw funds from Counter
78 // directly. It works as follows:
79 //  1) any trader may initiate a cooldown of two days for all token accounts of the same address
80 //  2) this cooldown is reset by invoking withdrawal or exchange on this address - these are the
81 //     operations which require explicit consent in the form of digital signature and thus mean
82 //     that a) exchange is operational b) the user trusts it
83 //  3) in case the cooldown have not been reset by any means within two day period, the user may withdraw
84 //     the entirety of their funds from Treasury.
85 //
86 // A note should be made regarding 2) - Counter does _not_ have an ability to reset the ER cooldown
87 // arbitrarily long, as trade signatures contain an explicit expiration date, and withdrawals have a
88 // nonce which makes them eligible to be applied once.
89 
90 contract Treasury is AccessModifiers, TreasuryInterface {
91     // *** Constants.
92 
93     uint constant EMERGENCY_RELEASE_CHALLENGE_PERIOD = 2 days;
94 
95     // *** Variables.
96 
97     // Treasury can be "paused" by the registry owner to effectively freeze fund movement
98     // (sans emergency releases).
99     bool active = false;
100 
101     // Mapping from token codes (uint16) into corresponding ERC-20 contract addresses.
102     // Each token code can only be assigned once for security reasons. Token code 0 is
103     // always Ether.
104     mapping (uint16 => address) public tokenContracts;
105 
106     // Balance of a specific token account, in lowest denomination (wei for Ether).
107     // uint176 key is composite of u16 token code (bits 160..175) and address (bits 0..159).
108     mapping (uint176 => uint) public tokenAmounts;
109 
110     // *** Events
111 
112     event SetActive(bool active);
113     event ChangeTokenInfo(uint16 tokenCode, address tokenContract);
114     event StartEmergencyRelease(address account);
115     event Deposit(uint16 tokenCode, address account, uint amount);
116     event Withdrawal(uint16 tokenCode, address traderAddr, address withdrawalAddr, uint amount);
117     event EmergencyRelease(uint16 tokenCode, address account, uint amount);
118 
119     // Emergency release status for an address (_not_ for the token account):
120     //     == 0 - escape release challenge inactive
121     //     != 0 - timestamp after which ER can be executed
122     mapping (address => uint) public emergencyReleaseSince;
123 
124     // *** Constructor
125 
126     constructor () public {
127     }
128 
129     // *** Modifiers
130 
131     modifier onlyActive() {
132         require (active, "Inactive treasury only allows withdrawals.");
133         _;
134     }
135 
136     modifier emergencyReleasePossible(address trader) {
137         uint deadline = emergencyReleaseSince[trader];
138         require (deadline > 0 && block.timestamp > deadline, "Challenge should be active and deadline expired.");
139         _;
140     }
141 
142     // *** Admin methods (mostly self-explanatory)
143 
144     function setActive(bool _active) external onlyRegistryOwner() {
145         active = _active;
146 
147         emit SetActive(active);
148     }
149 
150     function changeTokenInfo(uint16 tokenCode, address tokenContract) external onlyRegistryOwner() {
151         require (tokenCode != 0,
152                  "Token code of zero is reserved for Ether.");
153 
154         require (tokenContracts[tokenCode] == address(0),
155                  "Token contract address can be assigned only once.");
156 
157         tokenContracts[tokenCode] = tokenContract;
158 
159         emit ChangeTokenInfo(tokenCode, tokenContract);
160     }
161 
162     // *** Emergency release initiation and reset
163 
164     // This method is invoked by the user to start the ER cooldown
165     function startEmergencyRelease() external {
166         emergencyReleaseSince[msg.sender] = block.timestamp + EMERGENCY_RELEASE_CHALLENGE_PERIOD;
167 
168         emit StartEmergencyRelease(msg.sender);
169     }
170 
171     // This private method resets the UR cooldown for when executing successful trades/withdrawals
172     function resetEmergencyRelease(address traderAddr) private {
173         if (emergencyReleaseSince[traderAddr] != 0) {
174             emergencyReleaseSince[traderAddr] = 0;
175         }
176     }
177 
178     // *** Fund movement methods
179 
180     // * Deposits (initiated by and paid for by the trader)
181 
182     function depositEther(address account) external payable {
183         emit Deposit(0, account, msg.value);
184 
185         addBalance(0, account, msg.value);
186     }
187 
188     function depositERC20Token(uint176 tokenAccount, uint amount) external {
189         uint16 tokenCode = uint16(tokenAccount >> 160);
190         address tokenContract = tokenContracts[tokenCode];
191 
192         require (tokenContract != address(0), "Registered token contract.");
193 
194         // Need a preliminary .approve() call
195         require (safeTransferFrom(tokenContract, msg.sender, address(this), amount),
196                  "Could not transfer ERC-20 tokens using transferFrom.");
197 
198         address account = address(tokenAccount);
199         emit Deposit(tokenCode, account, amount);
200 
201         addBalance(tokenCode, account, amount);
202     }
203 
204     // * Emergency release (initiated by and paid for by the trader)
205 
206     function emergencyReleaseEther() external emergencyReleasePossible(msg.sender) {
207         uint amount = deductFullBalance(0, msg.sender);
208 
209         emit EmergencyRelease(0, msg.sender, amount);
210 
211         msg.sender.transfer(amount);
212     }
213 
214     function emergencyReleaseERC20Token(uint16 tokenCode) external emergencyReleasePossible(msg.sender) {
215         uint amount = deductFullBalance(tokenCode, msg.sender);
216 
217         emit EmergencyRelease(tokenCode, msg.sender, amount);
218 
219         address tokenContract = tokenContracts[tokenCode];
220         require (tokenContract != address(0), "Registered token contract.");
221 
222         require (safeTransfer(tokenContract, msg.sender, amount),
223                  "Could not transfer ERC-20 tokens using transfer.");
224     }
225 
226     // * Regular withdrawal (authorized by the trader, initiated and paid for by Counter)
227     //   Requires trader approval of exchange contract.
228     //   Resets ER.
229 
230     function withdrawEther(address traderAddr, address payable withdrawalAddr, uint amount) external
231         onlyActive()
232         onlyApprovedExchange(traderAddr) {
233 
234         deductBalance(0, traderAddr, amount);
235         resetEmergencyRelease(traderAddr);
236 
237         emit Withdrawal(0, traderAddr, withdrawalAddr, amount);
238 
239         withdrawalAddr.transfer(amount);
240     }
241 
242     function withdrawERC20Token(uint16 tokenCode, address traderAddr, address withdrawalAddr, uint amount) external
243         onlyActive()
244         onlyApprovedExchange(traderAddr) {
245 
246         deductBalance(tokenCode, traderAddr, amount);
247         resetEmergencyRelease(traderAddr);
248 
249         address tokenContract = tokenContracts[tokenCode];
250         require (tokenContract != address(0), "Registered token contract.");
251 
252         require (safeTransfer(tokenContract, withdrawalAddr, amount),
253                  "Could not transfer ERC-20 tokens using transfer.");
254 
255         emit Withdrawal(tokenCode, traderAddr, withdrawalAddr, amount);
256     }
257 
258     // * Funds transfer between token accounts within Treasury
259     //   Initiated and paid for by Counter as part of trade or withdrawal fee collection.
260     //   Requires trader approval of exchange contract.
261     //   There are three specializations to save gas on inter-contract method calls.
262     //   Resets ER.
263 
264     // Case 1 - transfer tokens from one account to another
265     // Example usecase: withdrawal fee collection
266     function transferTokens(uint16 tokenCode, address fromAddr, address toAddr, uint amount) external
267         onlyActive() onlyApprovedExchange(fromAddr) {
268 
269         resetEmergencyRelease(fromAddr);
270 
271         deductBalance(tokenCode, fromAddr, amount);
272         addBalance(tokenCode, toAddr, amount);
273     }
274 
275     // Case 2 - transfer tokens from one account to two accounts, splitting arbitrarily.
276     function transferTokensTwice(uint16 tokenCode, address fromAddr, address toAddr1, uint amount1, address toAddr2, uint amount2) external
277         onlyActive() onlyApprovedExchange(fromAddr) {
278 
279         resetEmergencyRelease(fromAddr);
280 
281         deductBalance(tokenCode, fromAddr, amount1 + amount2);
282 
283         addBalance(tokenCode, toAddr1, amount1);
284         addBalance(tokenCode, toAddr2, amount2);
285     }
286 
287     // Case 3 - transfer tokens of one type from A to B, tokens of another type from B to A,
288     //          and deduct a fee from both transfers to a third account C.
289     // Example usecase: any trade on Counter
290     function exchangeTokens(
291         uint16 tokenCode1, uint16 tokenCode2,
292         address addr1, address addr2, address addrFee,
293         uint amount1, uint fee1,
294         uint amount2, uint fee2) external onlyActive() onlyApprovedExchangeBoth(addr1, addr2) {
295 
296         resetEmergencyRelease(addr1);
297         resetEmergencyRelease(addr2);
298 
299         deductBalance(tokenCode1, addr1, amount1 + fee1);
300         deductBalance(tokenCode2, addr2, amount2 + fee2);
301 
302         addBalance(tokenCode1, addr2, amount1);
303         addBalance(tokenCode2, addr1, amount2);
304         addBalance(tokenCode1, addrFee, fee1);
305         addBalance(tokenCode2, addrFee, fee2);
306     }
307 
308     // * Token account balance management routines.
309     //   Construct uint176 ids, check for over- and underflows.
310 
311     function deductBalance(uint tokenCode, address addr, uint amount) private {
312         uint176 tokenAccount = uint176(tokenCode) << 160 | uint176(addr);
313         uint before = tokenAmounts[tokenAccount];
314         require (before >= amount, "Enough funds.");
315         tokenAmounts[tokenAccount] = before - amount;
316     }
317 
318     function deductFullBalance(uint tokenCode, address addr) private returns (uint amount) {
319         uint176 tokenAccount = uint176(tokenCode) << 160 | uint176(addr);
320         amount = tokenAmounts[tokenAccount];
321         tokenAmounts[tokenAccount] = 0;
322     }
323 
324     function addBalance(uint tokenCode, address addr, uint amount) private {
325         uint176 tokenAccount = uint176(tokenCode) << 160 | uint176(addr);
326         uint before = tokenAmounts[tokenAccount];
327         require (before + amount >= before, "No overflow.");
328         tokenAmounts[tokenAccount] = before + amount;
329     }
330 
331     // * Safe ERC-20 transfer() and transferFrom() invocations
332     //   Work correctly with those tokens that do not return (bool success) and thus are not
333     //   strictly speaking ERC-20 compatible, but unfortunately are quite widespread.
334 
335     function safeTransfer(address tokenContract, address to, uint value) internal returns (bool success)
336     {
337         // bytes4(keccak256("transfer(address,uint256)")) = 0xa9059cbb
338         (bool call_success, bytes memory return_data) = tokenContract.call(abi.encodeWithSelector(0xa9059cbb, to, value));
339 
340         success = false;
341 
342         if (call_success) {
343             if (return_data.length == 0) {
344                 // transfer() doesn't have a return value
345                 success = true;
346 
347             } else if (return_data.length == 32) {
348                 // check returned bool
349                 assembly { success := mload(add(return_data, 0x20)) }
350             }
351 
352         }
353     }
354 
355     function safeTransferFrom(address tokenContract, address from, address to, uint value) internal returns (bool success)
356     {
357         // bytes4(keccak256("transferFrom(address,address,uint256)")) = 0x23b872dd
358         (bool call_success, bytes memory return_data) = tokenContract.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
359 
360         success = false;
361 
362         if (call_success) {
363             if (return_data.length == 0) {
364                 success = true;
365 
366             } else if (return_data.length == 32) {
367                 assembly { success := mload(add(return_data, 0x20)) }
368             }
369 
370         }
371     }
372 
373 }