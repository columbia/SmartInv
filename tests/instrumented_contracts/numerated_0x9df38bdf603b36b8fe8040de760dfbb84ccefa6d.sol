1 /**
2  * Token recurring billing smart contract, which enable recurring billing feature for DREAM token.
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
49  * Smart contract for recurring billing in ERC20-compatible tokens. This smart contract defines workflow between
50  * a merchant and a customer. Workflow:
51  * 1. Merchant registers theirselves in this smart contract using `registerNewMerchant`.
52  *   1.1. Merchant specifies `beneficiary` address, which receives tokens.
53  *   1.2. Merchant specifies `merchant` address, which is able to change `merchant` and `beneficiary` addresses.
54  *   1.3. Merchant specified an address that is authorized to call `charge` related to this merchant.
55  *     1.3.1. Later, merchant can (de)authorize another addresses to call `charge` using `changeMerchantChargingAccount`.
56  *   1.4. As a result, merchant gets `merchantId`, which is used to initialize recurring billing by customers.
57  *   1.5. Merchant account can change their `beneficiary`, `merchant` and authorized charging addresses by calling:
58  *     1.4.1. Function `changeMerchantAccount`, which changes account that can control this merchant (`merchantId`).
59  *     1.4.2. Function `changeMerchantBeneficiaryAddress`, which changes merchant's `beneficiary`.
60  *     1.4.3. Function `changeMerchantChargingAccount`, which (de)authorizes addresses to call `charge` on behalf of this merchant.
61  * 2. According to an off-chain agreement with merchant, customer calls `allowRecurringBilling` and:
62  *   2.1. Specifies `billingId`, which is given off-chain by merchant (merchant will listen blockchain Event on this ID).
63  *   2.2. Specifies `merchantId`, the merchant which will receive tokens.
64  *   2.3. Specifies `period` in seconds, during which only one charge can occur.
65  *   2.4. Specifies `value`, amount in tokens which can be charged each `period`.
66  *     2.4.1. If the customer doesn't have at least `value` tokens, `allowRecurringBilling` errors.
67  *     2.4.2. If the customer haven't approved at least `value` tokens for a smart contract, `allowRecurringBilling` errors.
68  *   2.5. `billingId` is then used by merchant to charge customer each `period`.
69  * 3. Merchant use authorized accounts (1.3) to call the `charge` function each `period` to charge agreed amount from a customer.
70  *   3.1. It is impossible to call `charge` if the date of the last charge is less than `period`.
71  *   3.2. Calling `charge` cancels billing when called after 2 `period`s from the last charge.
72  *   3.3. Thus, to successfully charge an account, `charge` must be strictly called within 1 and 2 `period`s after the last charge.
73  *   3.4. Calling `charge` errors if any of the following occur:
74  *     3.4.1. Customer canceled recurring billing with `cancelRecurringBilling`.
75  *     3.4.2. Customer's balance is lower than the chargeable amount.
76  *     3.4.3. Customer's allowance to the smart contract is less than the chargable amount.
77  *     3.4.4. Specified `billingId` does not exists.
78  *     3.4.5. There's no `period` passed since the last charge.
79  *   3.5. Next charge date increments strictly by `period` each charge, thus, there's no need to exec `charge` strictly on time.
80  * 4. Customer can cancel further billing by calling `cancelRecurringBilling` and passing `billingId`.
81  * 5. TokenRecurringBilling smart contract implements `receiveApproval` function for allowing/cancelling billing within one call from
82  *    the token smart contract. Parameter `data` is encoded as tightly-packed (uint256 metadata, uint256 billingId).
83  *   5.1. `metadata` is encoded using `encodeBillingMetadata`.
84  *   5.2. As for `receiveApproval`, `lastChargeAt` in `metadata` is used as an action identifier.
85  *      5.2.1. `lastChargeAt=0` specifies that customer wants to allow new recurring billing.
86  *      5.2.2. `lastChargeAt=1` specifies that customer wants to cancel existing recurring billing.
87  *   5.3. Make sure that passed `bytes` parameter is exactly 64 bytes in length.
88  */
89 contract TokenRecurringBilling {
90 
91     using SafeMath for uint256;
92 
93     event BillingAllowed(uint256 indexed billingId, address customer, uint256 merchantId, uint256 timestamp, uint256 period, uint256 value);
94     event BillingCharged(uint256 indexed billingId, uint256 timestamp, uint256 nextChargeTimestamp);
95     event BillingCanceled(uint256 indexed billingId);
96     event MerchantRegistered(uint256 indexed merchantId, address merchantAccount, address beneficiaryAddress);
97     event MerchantAccountChanged(uint256 indexed merchantId, address merchantAccount);
98     event MerchantBeneficiaryAddressChanged(uint256 indexed merchantId, address beneficiaryAddress);
99     event MerchantChargingAccountAllowed(uint256 indexed merchantId, address chargingAccount, bool allowed);
100 
101     struct BillingRecord {
102         address customer; // Billing address (those who pay).
103         uint256 metadata; // Metadata packs 5 values to save on storage. Metadata spec (from first to last byte):
104                           //   + uint32 period;       // Billing period in seconds; configurable period of up to 136 years.
105                           //   + uint32 merchantId;   // Merchant ID; up to ~4.2 Milliard IDs.
106                           //   + uint48 lastChargeAt; // When the last charge occurred; up to year 999999+.
107                           //   + uint144 value;       // Billing value charrged each period; up to ~22 septillion tokens with 18 decimals
108     }
109 
110     struct Merchant {
111         address merchant;    // Merchant admin address that can change all merchant struct properties.
112         address beneficiary; // Address receiving tokens.
113     }
114 
115     enum receiveApprovalAction { // In receiveApproval, `lastChargeAt` in passed `metadata` specifies an action to execute.
116         allowRecurringBilling,   // == 0
117         cancelRecurringBilling   // == 1
118     }
119 
120     uint256 public lastMerchantId;     // This variable increments on each new merchant registered, generating unique ids for merchant.
121     ERC20CompatibleToken public token; // Token address.
122 
123     mapping(uint256 => BillingRecord) public billingRegistry;                           // List of all billings registered by ID.
124     mapping(uint256 => Merchant) public merchantRegistry;                               // List of all merchants registered by ID.
125     mapping(uint256 => mapping(address => bool)) public merchantChargingAccountAllowed; // Accounts that are allowed to charge customers.
126 
127     // Checks whether {merchant} owns {merchantId}
128     modifier isMerchant (uint256 merchantId) {
129         require(merchantRegistry[merchantId].merchant == msg.sender, "Sender is not a merchant");
130         _;
131     }
132 
133     // Checks whether {customer} owns {billingId}
134     modifier isCustomer (uint256 billingId) {
135         require(billingRegistry[billingId].customer == msg.sender, "Sender is not a customer");
136         _;
137     }
138 
139     // Guarantees that the transaction is sent by token smart contract only.
140     modifier tokenOnly () {
141         require(msg.sender == address(token), "Sender is not a token");
142         _;
143     }
144 
145     /// ======================================================== Constructor ========================================================= \\\
146 
147     // Creates a recurring billing smart contract for particular token.
148     constructor (address tokenAddress) public {
149         token = ERC20CompatibleToken(tokenAddress);
150     }
151 
152     /// ====================================================== Public Functions ====================================================== \\\
153 
154     // Enables merchant with {merchantId} to charge transaction signer's account according to specified {value} and {period}.
155     function allowRecurringBilling (uint256 billingId, uint256 merchantId, uint256 value, uint256 period) public {
156         allowRecurringBillingInternal(msg.sender, merchantId, billingId, value, period);
157     }
158 
159     // Enables anyone to become a merchant, charging tokens for their services.
160     function registerNewMerchant (address beneficiary, address chargingAccount) public returns (uint256 merchantId) {
161 
162         merchantId = ++lastMerchantId;
163         Merchant storage record = merchantRegistry[merchantId];
164         record.merchant = msg.sender;
165         record.beneficiary = beneficiary;
166         emit MerchantRegistered(merchantId, msg.sender, beneficiary);
167 
168         changeMerchantChargingAccount(merchantId, chargingAccount, true);
169 
170     }
171 
172     /// =========================================== Public Functions with Restricted Access =========================================== \\\
173 
174     // Calcels recurring billing with id {billingId} if it is owned by a transaction signer.
175     function cancelRecurringBilling (uint256 billingId) public isCustomer(billingId) {
176         cancelRecurringBillingInternal(billingId);
177     }
178 
179     // Charges customer's account according to defined {billingId} billing rules. Only merchant's authorized accounts can charge the customer.
180     function charge (uint256 billingId) public {
181 
182         BillingRecord storage billingRecord = billingRegistry[billingId];
183         (uint256 value, uint256 lastChargeAt, uint256 merchantId, uint256 period) = decodeBillingMetadata(billingRecord.metadata);
184 
185         require(merchantChargingAccountAllowed[merchantId][msg.sender], "Sender is not allowed to charge");
186         require(merchantId != 0, "Billing does not exist");
187         require(lastChargeAt.add(period) <= now, "Charged too early");
188 
189         // If 2 periods have already passed since the last charge (or beginning), no further charges are possible
190         // and recurring billing is canceled in case of a charge.
191         if (now > lastChargeAt.add(period.mul(2))) {
192             cancelRecurringBillingInternal(billingId);
193             return;
194         }
195 
196         require(
197             token.transferFrom(billingRecord.customer, merchantRegistry[merchantId].beneficiary, value),
198             "Unable to charge customer"
199         );
200 
201         billingRecord.metadata = encodeBillingMetadata(value, lastChargeAt.add(period), merchantId, period);
202 
203         emit BillingCharged(billingId, now, lastChargeAt.add(period.mul(2)));
204 
205     }
206 
207     /**
208      * Invoked by a token smart contract on approveAndCall. Allows or cancels recurring billing.
209      * @param sender - Address that approved some tokens for this smart contract.
210      * @param data - Tightly-packed (uint256,uint256) values of (metadata, billingId). Metadata's `lastChargeAt`
211      *               specifies an action to perform (see `receiveApprovalAction` enum).
212      */
213     function receiveApproval (address sender, uint, address, bytes calldata data) external tokenOnly {
214 
215         // The token contract MUST guarantee that "sender" is actually the token owner, and metadata is signed by a token owner.
216         require(data.length == 64, "Invalid data length");
217 
218         // `action` is used instead of `lastCahrgeAt` to save some space.
219         (uint256 value, uint256 action, uint256 merchantId, uint256 period) = decodeBillingMetadata(bytesToUint256(data, 0));
220         uint256 billingId = bytesToUint256(data, 32);
221 
222         if (action == uint256(receiveApprovalAction.allowRecurringBilling)) {
223             allowRecurringBillingInternal(sender, merchantId, billingId, value, period);
224         } else if (action == uint256(receiveApprovalAction.cancelRecurringBilling)) {
225             require(billingRegistry[billingId].customer == sender, "Unable to cancel recurring billing of another customer");
226             cancelRecurringBillingInternal(billingId);
227         } else {
228             revert("Unknown action provided");
229         }
230 
231     }
232 
233     // Changes merchant account with id {merchantId} to {newMerchantAccount}.
234     function changeMerchantAccount (uint256 merchantId, address newMerchantAccount) public isMerchant(merchantId) {
235         merchantRegistry[merchantId].merchant = newMerchantAccount;
236         emit MerchantAccountChanged(merchantId, newMerchantAccount);
237     }
238 
239     // Changes merchant's beneficiary address (address that receives charged tokens) to {newBeneficiaryAddress}.
240     function changeMerchantBeneficiaryAddress (uint256 merchantId, address newBeneficiaryAddress) public isMerchant(merchantId) {
241         merchantRegistry[merchantId].beneficiary = newBeneficiaryAddress;
242         emit MerchantBeneficiaryAddressChanged(merchantId, newBeneficiaryAddress);
243     }
244 
245     // Allows or disallows particular {account} to charge customers related to this merchant.
246     function changeMerchantChargingAccount (uint256 merchantId, address account, bool allowed) public isMerchant(merchantId) {
247         merchantChargingAccountAllowed[merchantId][account] = allowed;
248         emit MerchantChargingAccountAllowed(merchantId, account, allowed);
249     }
250 
251     /// ================================================== Public Utility Functions ================================================== \\\
252 
253     // Used to encode 5 values into one uint256 value. This is primarily made for cheaper storage.
254     function encodeBillingMetadata (
255         uint256 value,
256         uint256 lastChargeAt,
257         uint256 merchantId,
258         uint256 period
259     ) public pure returns (uint256 result) {
260 
261         require(
262             value < 2 ** 144
263             && lastChargeAt < 2 ** 48
264             && merchantId < 2 ** 32
265             && period < 2 ** 32,
266             "Invalid input sizes to encode"
267         );
268 
269         result = value;
270         result |= lastChargeAt << (144);
271         result |= merchantId << (144 + 48);
272         result |= period << (144 + 48 + 32);
273 
274         return result;
275 
276     }
277 
278     // Used to decode 5 values from one uint256 value encoded by `encodeBillingMetadata` function.
279     function decodeBillingMetadata (uint256 encodedData) public pure returns (
280         uint256 value,
281         uint256 lastChargeAt,
282         uint256 merchantId,
283         uint256 period
284     ) {
285         value = uint144(encodedData);
286         lastChargeAt = uint48(encodedData >> (144));
287         merchantId = uint32(encodedData >> (144 + 48));
288         period = uint32(encodedData >> (144 + 48 + 32));
289     }
290 
291     /// ================================================ Internal (Private) Functions ================================================ \\\
292 
293     // Allows recurring billing. Noone but this contract can call this function.
294     function allowRecurringBillingInternal (
295         address customer,
296         uint256 merchantId,
297         uint256 billingId,
298         uint256 value,
299         uint256 period
300     ) internal {
301 
302         require(merchantId <= lastMerchantId && merchantId != 0, "Invalid merchant specified");
303         require(period < now, "Invalid period specified");
304         require(token.balanceOf(customer) >= value, "Not enough tokens for the first charge");
305         require(token.allowance(customer, address(this)) >= value, "Tokens are not approved for this smart contract");
306         require(billingRegistry[billingId].customer == address(0x0), "Recurring billing with this ID is already registered");
307 
308         BillingRecord storage newRecurringBilling = billingRegistry[billingId];
309         newRecurringBilling.metadata = encodeBillingMetadata(value, now.sub(period), merchantId, period);
310         newRecurringBilling.customer = customer;
311 
312         emit BillingAllowed(billingId, customer, merchantId, now, period, value);
313 
314     }
315 
316     // Cancels recurring billing. Noone but this contract can call this function.
317     function cancelRecurringBillingInternal (uint256 billingId) internal {
318         delete billingRegistry[billingId];
319         emit BillingCanceled(billingId);
320     }
321 
322     // Utility function to convert bytes type to uint256. Noone but this contract can call this function.
323     function bytesToUint256(bytes memory input, uint offset) internal pure returns (uint256 output) {
324         assembly { output := mload(add(add(input, 32), offset)) }
325     }
326 
327 }