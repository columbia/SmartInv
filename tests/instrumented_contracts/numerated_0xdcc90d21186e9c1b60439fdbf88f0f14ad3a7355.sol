1 /**
2  * Token recurring billing smart contracts, which enable recurring billing feature for ERC20-compatible tokens.
3  * Developed by DreamTeam.GG contributors. Visit dreamteam.gg and github.com/dreamteam-gg/smart-contracts for more info.
4  * Copyright © 2019 DREAMTEAM.
5  * Licensed under the Apache License, Version 2.0 (the "License").
6  */
7 
8 pragma solidity 0.5.2;
9 
10 interface ERC20CompatibleToken {
11     function balanceOf(address tokenOwner) external view returns (uint balance);
12     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
13     function transfer (address to, uint tokens) external returns (bool success);
14     function transferFrom (address from, address to, uint tokens) external returns (bool success);
15 }
16 
17 /**
18  * Math operations with safety checks that throw on overflows.
19  */
20 library SafeMath {
21 
22     function mul (uint256 a, uint256 b) internal pure returns (uint256 c) {
23         if (a == 0) {
24             return 0;
25         }
26         c = a * b;
27         require(c / a == b);
28         return c;
29     }
30 
31     function div (uint256 a, uint256 b) internal pure returns (uint256) {
32         return a / b;
33     }
34 
35     function sub (uint256 a, uint256 b) internal pure returns (uint256) {
36         require(b <= a);
37         return a - b;
38     }
39 
40     function add (uint256 a, uint256 b) internal pure returns (uint256 c) {
41         c = a + b;
42         require(c >= a);
43         return c;
44     }
45 
46 }
47 
48 /**
49  * Factory that creates recurring billing smart contracts for specified token.
50  * You can enable recurring billing for your own ERC20-compatible tokens!
51  * Find the documentation here: https://github.com/dreamteam-gg/smart-contracts#smart-contracts-documentation
52  */
53 contract RecurringBillingContractFactory {
54 
55     event NewRecurringBillingContractCreated(address token, address recurringBillingContract);
56 
57     function newRecurringBillingContract (address tokenAddress) public returns (address recurringBillingContractAddress) {
58         TokenRecurringBilling rb = new TokenRecurringBilling(tokenAddress);
59         emit NewRecurringBillingContractCreated(tokenAddress, address(rb));
60         return address(rb);
61     }
62 
63 }
64  		   	  				  	  	      		 			  		 	  	 		 	 		 		 	  	 			 	   		    	  	 			  			 	   		 	 		
65 /**
66  * Smart contract for recurring billing in ERC20-compatible tokens. This smart contract defines workflow between
67  * a merchant and a customer. Workflow:
68  * 1. Merchant registers theirselves in this smart contract using `registerNewMerchant`.
69  *   1.1. Merchant specifies `beneficiary` address, which receives tokens.
70  *   1.2. Merchant specifies `merchant` address, which is able to change `merchant` and `beneficiary` addresses.
71  *   1.3. Merchant specified an address that is authorized to call `charge` related to this merchant.
72  *     1.3.1. Later, merchant can (de)authorize another addresses to call `charge` using `changeMerchantChargingAccount`.
73  *   1.4. As a result, merchant gets `merchantId`, which is used to initialize recurring billing by customers.
74  *   1.5. Merchant account can change their `beneficiary`, `merchant` and authorized charging addresses by calling:
75  *     1.4.1. Function `changeMerchantAccount`, which changes account that can control this merchant (`merchantId`).
76  *     1.4.2. Function `changeMerchantBeneficiaryAddress`, which changes merchant's `beneficiary`.
77  *     1.4.3. Function `changeMerchantChargingAccount`, which (de)authorizes addresses to call `charge` on behalf of this merchant.
78  * 2. According to an off-chain agreement with merchant, customer calls `allowRecurringBilling` and:
79  *   2.1. Specifies `billingId`, which is given off-chain by merchant (merchant will listen blockchain Event on this ID).
80  *   2.2. Specifies `merchantId`, the merchant which will receive tokens.
81  *   2.3. Specifies `period` in seconds, during which only one charge can occur.
82  *   2.4. Specifies `value`, amount in tokens which can be charged each `period`.
83  *     2.4.1. If the customer doesn't have at least `value` tokens, `allowRecurringBilling` errors.
84  *     2.4.2. If the customer haven't approved at least `value` tokens for a smart contract, `allowRecurringBilling` errors.
85  *   2.5. `billingId` is then used by merchant to charge customer each `period`.
86  * 3. Merchant use authorized accounts (1.3) to call the `charge` function each `period` to charge agreed amount from a customer.
87  *   3.1. It is impossible to call `charge` if the date of the last charge is less than `period`.
88  *   3.2. Calling `charge` cancels billing when called after 2 `period`s from the last charge.
89  *   3.3. Thus, to successfully charge an account, `charge` must be strictly called within 1 and 2 `period`s after the last charge.
90  *   3.4. Calling `charge` errors if any of the following occur:
91  *     3.4.1. Customer canceled recurring billing with `cancelRecurringBilling`.
92  *     3.4.2. Customer's balance is lower than the chargeable amount.
93  *     3.4.3. Customer's allowance to the smart contract is less than the chargable amount.
94  *     3.4.4. Specified `billingId` does not exists.
95  *     3.4.5. There's no `period` passed since the last charge.
96  *   3.5. Next charge date increments strictly by `period` each charge, thus, there's no need to exec `charge` strictly on time.
97  * 4. Customer can cancel further billing by calling `cancelRecurringBilling` and passing `billingId`.
98  * 5. TokenRecurringBilling smart contract implements `receiveApproval` function for allowing/cancelling billing within one call from
99  *    the token smart contract. Parameter `data` is encoded as tightly-packed (uint256 metadata, uint256 billingId).
100  *   5.1. `metadata` is encoded using `encodeBillingMetadata`.
101  *   5.2. As for `receiveApproval`, `lastChargeAt` in `metadata` is used as an action identifier.
102  *      5.2.1. `lastChargeAt=0` specifies that customer wants to allow new recurring billing.
103  *      5.2.2. `lastChargeAt=1` specifies that customer wants to cancel existing recurring billing.
104  *   5.3. Make sure that passed `bytes` parameter is exactly 64 bytes in length.
105  */
106 contract TokenRecurringBilling {
107 
108     using SafeMath for uint256;
109 
110     event BillingAllowed(uint256 indexed billingId, address customer, uint256 merchantId, uint256 timestamp, uint256 period, uint256 value);
111     event BillingCharged(uint256 indexed billingId, uint256 timestamp, uint256 nextChargeTimestamp);
112     event BillingCanceled(uint256 indexed billingId);
113     event MerchantRegistered(uint256 indexed merchantId, address merchantAccount, address beneficiaryAddress);
114     event MerchantAccountChanged(uint256 indexed merchantId, address merchantAccount);
115     event MerchantBeneficiaryAddressChanged(uint256 indexed merchantId, address beneficiaryAddress);
116     event MerchantChargingAccountAllowed(uint256 indexed merchantId, address chargingAccount, bool allowed);
117 
118     struct BillingRecord {
119         address customer; // Billing address (those who pay).
120         uint256 metadata; // Metadata packs 5 values to save on storage. Metadata spec (from first to last byte):
121                           //   + uint32 period;       // Billing period in seconds; configurable period of up to 136 years.
122                           //   + uint32 merchantId;   // Merchant ID; up to ~4.2 Milliard IDs.
123                           //   + uint48 lastChargeAt; // When the last charge occurred; up to year 999999+.
124                           //   + uint144 value;       // Billing value charrged each period; up to ~22 septillion tokens with 18 decimals
125     }
126 
127     struct Merchant {
128         address merchant;    // Merchant admin address that can change all merchant struct properties.
129         address beneficiary; // Address receiving tokens.
130     }
131 
132     enum receiveApprovalAction { // In receiveApproval, `lastChargeAt` in passed `metadata` specifies an action to execute.
133         allowRecurringBilling,   // == 0
134         cancelRecurringBilling   // == 1
135     }
136 
137     uint256 public lastMerchantId;     // This variable increments on each new merchant registered, generating unique ids for merchant.
138     ERC20CompatibleToken public token; // Token address.
139 
140     mapping(uint256 => BillingRecord) public billingRegistry;                           // List of all billings registered by ID.
141     mapping(uint256 => Merchant) public merchantRegistry;                               // List of all merchants registered by ID.
142     mapping(uint256 => mapping(address => bool)) public merchantChargingAccountAllowed; // Accounts that are allowed to charge customers.
143 
144     // Checks whether {merchant} owns {merchantId}
145     modifier isMerchant (uint256 merchantId) {
146         require(merchantRegistry[merchantId].merchant == msg.sender, "Sender is not a merchant");
147         _;
148     }
149 
150     // Checks whether {customer} owns {billingId}
151     modifier isCustomer (uint256 billingId) {
152         require(billingRegistry[billingId].customer == msg.sender, "Sender is not a customer");
153         _;
154     }
155 
156     // Guarantees that the transaction is sent by token smart contract only.
157     modifier tokenOnly () {
158         require(msg.sender == address(token), "Sender is not a token");
159         _;
160     }
161 
162     /// ======================================================== Constructor ========================================================= \\\
163 
164     // Creates a recurring billing smart contract for particular token.
165     constructor (address tokenAddress) public {
166         token = ERC20CompatibleToken(tokenAddress);
167     }
168 
169     /// ====================================================== Public Functions ====================================================== \\\
170 
171     // Enables merchant with {merchantId} to charge transaction signer's account according to specified {value} and {period}.
172     function allowRecurringBilling (uint256 billingId, uint256 merchantId, uint256 value, uint256 period) public {
173         allowRecurringBillingInternal(msg.sender, merchantId, billingId, value, period);
174     }
175 
176     // Enables anyone to become a merchant, charging tokens for their services.
177     function registerNewMerchant (address beneficiary, address chargingAccount) public returns (uint256 merchantId) {
178 
179         merchantId = ++lastMerchantId;
180         Merchant storage record = merchantRegistry[merchantId];
181         record.merchant = msg.sender;
182         record.beneficiary = beneficiary;
183         emit MerchantRegistered(merchantId, msg.sender, beneficiary);
184 
185         changeMerchantChargingAccount(merchantId, chargingAccount, true);
186 
187     }
188 
189     /// =========================================== Public Functions with Restricted Access =========================================== \\\
190 
191     // Calcels recurring billing with id {billingId} if it is owned by a transaction signer.
192     function cancelRecurringBilling (uint256 billingId) public isCustomer(billingId) {
193         cancelRecurringBillingInternal(billingId);
194     }
195 
196     // Charges customer's account according to defined {billingId} billing rules. Only merchant's authorized accounts can charge the customer.
197     function charge (uint256 billingId) public {
198 
199         BillingRecord storage billingRecord = billingRegistry[billingId];
200         (uint256 value, uint256 lastChargeAt, uint256 merchantId, uint256 period) = decodeBillingMetadata(billingRecord.metadata);
201 
202         require(merchantChargingAccountAllowed[merchantId][msg.sender], "Sender is not allowed to charge");
203         require(merchantId != 0, "Billing does not exist");
204         require(lastChargeAt.add(period) <= now, "Charged too early");
205 
206         // If 2 periods have already passed since the last charge (or beginning), no further charges are possible
207         // and recurring billing is canceled in case of a charge.
208         if (now > lastChargeAt.add(period.mul(2))) {
209             cancelRecurringBillingInternal(billingId);
210             return;
211         }
212 
213         require(
214             token.transferFrom(billingRecord.customer, merchantRegistry[merchantId].beneficiary, value),
215             "Unable to charge customer"
216         );
217 
218         billingRecord.metadata = encodeBillingMetadata(value, lastChargeAt.add(period), merchantId, period);
219 
220         emit BillingCharged(billingId, now, lastChargeAt.add(period.mul(2)));
221 
222     }
223 
224     /**
225      * Invoked by a token smart contract on approveAndCall. Allows or cancels recurring billing.
226      * @param sender - Address that approved some tokens for this smart contract.
227      * @param data - Tightly-packed (uint256,uint256) values of (metadata, billingId). Metadata's `lastChargeAt`
228      *               specifies an action to perform (see `receiveApprovalAction` enum).
229      */
230     function receiveApproval (address sender, uint, address, bytes calldata data) external tokenOnly {
231 
232         // The token contract MUST guarantee that "sender" is actually the token owner, and metadata is signed by a token owner.
233         require(data.length == 64, "Invalid data length");
234 
235         // `action` is used instead of `lastCahrgeAt` to save some space.
236         (uint256 value, uint256 action, uint256 merchantId, uint256 period) = decodeBillingMetadata(bytesToUint256(data, 0));
237         uint256 billingId = bytesToUint256(data, 32);
238 
239         if (action == uint256(receiveApprovalAction.allowRecurringBilling)) {
240             allowRecurringBillingInternal(sender, merchantId, billingId, value, period);
241         } else if (action == uint256(receiveApprovalAction.cancelRecurringBilling)) {
242             require(billingRegistry[billingId].customer == sender, "Unable to cancel recurring billing of another customer");
243             cancelRecurringBillingInternal(billingId);
244         } else {
245             revert("Unknown action provided");
246         }
247 
248     }
249 
250     // Changes merchant account with id {merchantId} to {newMerchantAccount}.
251     function changeMerchantAccount (uint256 merchantId, address newMerchantAccount) public isMerchant(merchantId) {
252         merchantRegistry[merchantId].merchant = newMerchantAccount;
253         emit MerchantAccountChanged(merchantId, newMerchantAccount);
254     }
255 
256     // Changes merchant's beneficiary address (address that receives charged tokens) to {newBeneficiaryAddress}.
257     function changeMerchantBeneficiaryAddress (uint256 merchantId, address newBeneficiaryAddress) public isMerchant(merchantId) {
258         merchantRegistry[merchantId].beneficiary = newBeneficiaryAddress;
259         emit MerchantBeneficiaryAddressChanged(merchantId, newBeneficiaryAddress);
260     }
261 
262     // Allows or disallows particular {account} to charge customers related to this merchant.
263     function changeMerchantChargingAccount (uint256 merchantId, address account, bool allowed) public isMerchant(merchantId) {
264         merchantChargingAccountAllowed[merchantId][account] = allowed;
265         emit MerchantChargingAccountAllowed(merchantId, account, allowed);
266     }
267 
268     /// ================================================== Public Utility Functions ================================================== \\\
269 
270     // Used to encode 5 values into one uint256 value. This is primarily made for cheaper storage.
271     function encodeBillingMetadata (
272         uint256 value,
273         uint256 lastChargeAt,
274         uint256 merchantId,
275         uint256 period
276     ) public pure returns (uint256 result) {
277 
278         require(
279             value < 2 ** 144
280             && lastChargeAt < 2 ** 48
281             && merchantId < 2 ** 32
282             && period < 2 ** 32,
283             "Invalid input sizes to encode"
284         );
285 
286         result = value;
287         result |= lastChargeAt << (144);
288         result |= merchantId << (144 + 48);
289         result |= period << (144 + 48 + 32);
290 
291         return result;
292 
293     }
294 
295     // Used to decode 5 values from one uint256 value encoded by `encodeBillingMetadata` function.
296     function decodeBillingMetadata (uint256 encodedData) public pure returns (
297         uint256 value,
298         uint256 lastChargeAt,
299         uint256 merchantId,
300         uint256 period
301     ) {
302         value = uint144(encodedData);
303         lastChargeAt = uint48(encodedData >> (144));
304         merchantId = uint32(encodedData >> (144 + 48));
305         period = uint32(encodedData >> (144 + 48 + 32));
306     }
307 
308     /// ================================================ Internal (Private) Functions ================================================ \\\
309 
310     // Allows recurring billing. Noone but this contract can call this function.
311     function allowRecurringBillingInternal (
312         address customer,
313         uint256 merchantId,
314         uint256 billingId,
315         uint256 value,
316         uint256 period
317     ) internal {
318 
319         require(merchantId <= lastMerchantId && merchantId != 0, "Invalid merchant specified");
320         require(period < now, "Invalid period specified");
321         require(token.balanceOf(customer) >= value, "Not enough tokens for the first charge");
322         require(token.allowance(customer, address(this)) >= value, "Tokens are not approved for this smart contract");
323         require(billingRegistry[billingId].customer == address(0x0), "Recurring billing with this ID is already registered");
324 
325         BillingRecord storage newRecurringBilling = billingRegistry[billingId];
326         newRecurringBilling.metadata = encodeBillingMetadata(value, now.sub(period), merchantId, period);
327         newRecurringBilling.customer = customer;
328 
329         emit BillingAllowed(billingId, customer, merchantId, now, period, value);
330 
331     }
332 
333     // Cancels recurring billing. Noone but this contract can call this function.
334     function cancelRecurringBillingInternal (uint256 billingId) internal {
335         delete billingRegistry[billingId];
336         emit BillingCanceled(billingId);
337     }
338 
339     // Utility function to convert bytes type to uint256. Noone but this contract can call this function.
340     function bytesToUint256(bytes memory input, uint offset) internal pure returns (uint256 output) {
341         assembly { output := mload(add(add(input, 32), offset)) }
342     }
343 
344 }