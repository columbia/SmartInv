1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: contracts/Restricted.sol
48 
49 /** @title Restricted
50  *  Exposes onlyMonetha modifier
51  */
52 contract Restricted is Ownable {
53 
54     //MonethaAddress set event
55     event MonethaAddressSet(
56         address _address,
57         bool _isMonethaAddress
58     );
59 
60     mapping (address => bool) public isMonethaAddress;
61 
62     /**
63      *  Restrict methods in such way, that they can be invoked only by monethaAddress account.
64      */
65     modifier onlyMonetha() {
66         require(isMonethaAddress[msg.sender]);
67         _;
68     }
69 
70     /**
71      *  Allows owner to set new monetha address
72      */
73     function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {
74         isMonethaAddress[_address] = _isMonethaAddress;
75 
76         MonethaAddressSet(_address, _isMonethaAddress);
77     }
78 }
79 
80 // File: contracts/SafeDestructible.sol
81 
82 /**
83  * @title SafeDestructible
84  * Base contract that can be destroyed by owner.
85  * Can be destructed if there are no funds on contract balance.
86  */
87 contract SafeDestructible is Ownable {
88     function destroy() onlyOwner public {
89         require(this.balance == 0);
90         selfdestruct(owner);
91     }
92 }
93 
94 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
95 
96 /**
97  * @title Pausable
98  * @dev Base contract which allows children to implement an emergency stop mechanism.
99  */
100 contract Pausable is Ownable {
101   event Pause();
102   event Unpause();
103 
104   bool public paused = false;
105 
106 
107   /**
108    * @dev Modifier to make a function callable only when the contract is not paused.
109    */
110   modifier whenNotPaused() {
111     require(!paused);
112     _;
113   }
114 
115   /**
116    * @dev Modifier to make a function callable only when the contract is paused.
117    */
118   modifier whenPaused() {
119     require(paused);
120     _;
121   }
122 
123   /**
124    * @dev called by the owner to pause, triggers stopped state
125    */
126   function pause() onlyOwner whenNotPaused public {
127     paused = true;
128     Pause();
129   }
130 
131   /**
132    * @dev called by the owner to unpause, returns to normal state
133    */
134   function unpause() onlyOwner whenPaused public {
135     paused = false;
136     Unpause();
137   }
138 }
139 
140 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
141 
142 /**
143  * @title Contactable token
144  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
145  * contact information.
146  */
147 contract Contactable is Ownable{
148 
149     string public contactInformation;
150 
151     /**
152      * @dev Allows the owner to set a string with their contact information.
153      * @param info The contact information to attach to the contract.
154      */
155     function setContactInformation(string info) onlyOwner public {
156          contactInformation = info;
157      }
158 }
159 
160 // File: contracts/MerchantWallet.sol
161 
162 /**
163  *  @title MerchantWallet
164  *  Serves as a public Merchant profile with merchant profile info,
165  *      payment settings and latest reputation value.
166  *  Also MerchantWallet accepts payments for orders.
167  */
168 
169 contract MerchantWallet is Pausable, SafeDestructible, Contactable, Restricted {
170 
171     string constant VERSION = "0.4";
172 
173     /// Address of merchant's account, that can withdraw from wallet
174     address public merchantAccount;
175 
176     /// Address of merchant's fund address.
177     address public merchantFundAddress;
178 
179     /// Unique Merchant identifier hash
180     bytes32 public merchantIdHash;
181 
182     /// profileMap stores general information about the merchant
183     mapping (string=>string) profileMap;
184 
185     /// paymentSettingsMap stores payment and order settings for the merchant
186     mapping (string=>string) paymentSettingsMap;
187 
188     /// compositeReputationMap stores composite reputation, that compraises from several metrics
189     mapping (string=>uint32) compositeReputationMap;
190 
191     /// number of last digits in compositeReputation for fractional part
192     uint8 public constant REPUTATION_DECIMALS = 4;
193 
194     /**
195      *  Restrict methods in such way, that they can be invoked only by merchant account.
196      */
197     modifier onlyMerchant() {
198         require(msg.sender == merchantAccount);
199         _;
200     }
201 
202     /**
203      *  Fund Address should always be Externally Owned Account and not a contract.
204      */
205     modifier isEOA(address _fundAddress) {
206         uint256 _codeLength;
207         assembly {_codeLength := extcodesize(_fundAddress)}
208         require(_codeLength == 0, "sorry humans only");
209         _;
210     }
211 
212     /**
213      *  Restrict methods in such way, that they can be invoked only by merchant account or by monethaAddress account.
214      */
215     modifier onlyMerchantOrMonetha() {
216         require(msg.sender == merchantAccount || isMonethaAddress[msg.sender]);
217         _;
218     }
219 
220     /**
221      *  @param _merchantAccount Address of merchant's account, that can withdraw from wallet
222      *  @param _merchantId Merchant identifier
223      *  @param _fundAddress Merchant's fund address, where amount will be transferred.
224      */
225     function MerchantWallet(address _merchantAccount, string _merchantId, address _fundAddress) public isEOA(_fundAddress) {
226         require(_merchantAccount != 0x0);
227         require(bytes(_merchantId).length > 0);
228 
229         merchantAccount = _merchantAccount;
230         merchantIdHash = keccak256(_merchantId);
231 
232         merchantFundAddress = _fundAddress;
233     }
234 
235     /**
236      *  Accept payment from MonethaGateway
237      */
238     function () external payable {
239     }
240 
241     /**
242      *  @return profile info by string key
243      */
244     function profile(string key) external constant returns (string) {
245         return profileMap[key];
246     }
247 
248     /**
249      *  @return payment setting by string key
250      */
251     function paymentSettings(string key) external constant returns (string) {
252         return paymentSettingsMap[key];
253     }
254 
255     /**
256      *  @return composite reputation value by string key
257      */
258     function compositeReputation(string key) external constant returns (uint32) {
259         return compositeReputationMap[key];
260     }
261 
262     /**
263      *  Set profile info by string key
264      */
265     function setProfile(
266         string profileKey,
267         string profileValue,
268         string repKey,
269         uint32 repValue
270     ) external onlyOwner
271     {
272         profileMap[profileKey] = profileValue;
273 
274         if (bytes(repKey).length != 0) {
275             compositeReputationMap[repKey] = repValue;
276         }
277     }
278 
279     /**
280      *  Set payment setting by string key
281      */
282     function setPaymentSettings(string key, string value) external onlyOwner {
283         paymentSettingsMap[key] = value;
284     }
285 
286     /**
287      *  Set composite reputation value by string key
288      */
289     function setCompositeReputation(string key, uint32 value) external onlyMonetha {
290         compositeReputationMap[key] = value;
291     }
292 
293     /**
294      *  Allows withdrawal of funds to beneficiary address
295      */
296     function doWithdrawal(address beneficiary, uint amount) private {
297         require(beneficiary != 0x0);
298         beneficiary.transfer(amount);
299     }
300 
301     /**
302      *  Allows merchant to withdraw funds to beneficiary address
303      */
304     function withdrawTo(address beneficiary, uint amount) public onlyMerchant whenNotPaused {
305         doWithdrawal(beneficiary, amount);
306     }
307 
308     /**
309      *  Allows merchant to withdraw funds to it's own account
310      */
311     function withdraw(uint amount) external onlyMerchant {
312         withdrawTo(msg.sender, amount);
313     }
314 
315     /**
316      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing funds to deposit address of the exchange
317      */
318     function withdrawToExchange(address depositAccount, uint amount) external onlyMerchantOrMonetha whenNotPaused {
319         doWithdrawal(depositAccount, amount);
320     }
321 
322     /**
323      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing all funds to deposit address of the exchange
324      */
325     function withdrawAllToExchange(address depositAccount, uint min_amount) external onlyMerchantOrMonetha whenNotPaused {
326         require (address(this).balance >= min_amount);
327         doWithdrawal(depositAccount, address(this).balance);
328     }
329 
330     /**
331      *  Allows merchant to change it's account address
332      */
333     function changeMerchantAccount(address newAccount) external onlyMerchant whenNotPaused {
334         merchantAccount = newAccount;
335     }
336 
337     /**
338      *  Allows merchant to change it's fund address.
339      */
340     function changeFundAddress(address newFundAddress) external onlyMerchant isEOA(newFundAddress) {
341         merchantFundAddress = newFundAddress;
342     }
343 }