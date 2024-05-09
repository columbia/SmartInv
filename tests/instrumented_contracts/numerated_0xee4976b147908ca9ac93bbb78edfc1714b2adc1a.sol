1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
68 
69 /**
70  * @title Pausable
71  * @dev Base contract which allows children to implement an emergency stop mechanism.
72  */
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is not paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused);
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    */
91   modifier whenPaused() {
92     require(paused);
93     _;
94   }
95 
96   /**
97    * @dev called by the owner to pause, triggers stopped state
98    */
99   function pause() public onlyOwner whenNotPaused {
100     paused = true;
101     emit Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() public onlyOwner whenPaused {
108     paused = false;
109     emit Unpause();
110   }
111 }
112 
113 // File: openzeppelin-solidity/contracts/ownership/Contactable.sol
114 
115 /**
116  * @title Contactable token
117  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
118  * contact information.
119  */
120 contract Contactable is Ownable {
121 
122   string public contactInformation;
123 
124   /**
125     * @dev Allows the owner to set a string with their contact information.
126     * @param _info The contact information to attach to the contract.
127     */
128   function setContactInformation(string _info) public onlyOwner {
129     contactInformation = _info;
130   }
131 }
132 
133 // File: monetha-utility-contracts/contracts/Restricted.sol
134 
135 /** @title Restricted
136  *  Exposes onlyMonetha modifier
137  */
138 contract Restricted is Ownable {
139 
140     //MonethaAddress set event
141     event MonethaAddressSet(
142         address _address,
143         bool _isMonethaAddress
144     );
145 
146     mapping (address => bool) public isMonethaAddress;
147 
148     /**
149      *  Restrict methods in such way, that they can be invoked only by monethaAddress account.
150      */
151     modifier onlyMonetha() {
152         require(isMonethaAddress[msg.sender]);
153         _;
154     }
155 
156     /**
157      *  Allows owner to set new monetha address
158      */
159     function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {
160         isMonethaAddress[_address] = _isMonethaAddress;
161 
162         emit MonethaAddressSet(_address, _isMonethaAddress);
163     }
164 }
165 
166 // File: monetha-utility-contracts/contracts/SafeDestructible.sol
167 
168 /**
169  * @title SafeDestructible
170  * Base contract that can be destroyed by owner.
171  * Can be destructed if there are no funds on contract balance.
172  */
173 contract SafeDestructible is Ownable {
174     function destroy() onlyOwner public {
175         require(address(this).balance == 0);
176         selfdestruct(owner);
177     }
178 }
179 
180 // File: contracts/GenericERC20.sol
181 
182 /**
183 * @title GenericERC20 interface
184 */
185 contract GenericERC20 {
186     function totalSupply() public view returns (uint256);
187 
188     function decimals() public view returns(uint256);
189 
190     function balanceOf(address _who) public view returns (uint256);
191 
192     function allowance(address _owner, address _spender)
193         public view returns (uint256);
194         
195     // Return type not defined intentionally since not all ERC20 tokens return proper result type
196     function transfer(address _to, uint256 _value) public;
197 
198     function approve(address _spender, uint256 _value)
199         public returns (bool);
200 
201     function transferFrom(address _from, address _to, uint256 _value)
202         public returns (bool);
203 
204     event Transfer(
205         address indexed from,
206         address indexed to,
207         uint256 value
208     );
209 
210     event Approval(
211         address indexed owner,
212         address indexed spender,
213         uint256 value
214     );
215 }
216 
217 // File: contracts/MerchantWallet.sol
218 
219 /**
220  *  @title MerchantWallet
221  *  Serves as a public Merchant profile with merchant profile info,
222  *      payment settings and latest reputation value.
223  *  Also MerchantWallet accepts payments for orders.
224  */
225 
226 contract MerchantWallet is Pausable, SafeDestructible, Contactable, Restricted {
227 
228     string constant VERSION = "0.5";
229 
230     /// Address of merchant's account, that can withdraw from wallet
231     address public merchantAccount;
232 
233     /// Address of merchant's fund address.
234     address public merchantFundAddress;
235 
236     /// Unique Merchant identifier hash
237     bytes32 public merchantIdHash;
238 
239     /// profileMap stores general information about the merchant
240     mapping (string=>string) profileMap;
241 
242     /// paymentSettingsMap stores payment and order settings for the merchant
243     mapping (string=>string) paymentSettingsMap;
244 
245     /// compositeReputationMap stores composite reputation, that compraises from several metrics
246     mapping (string=>uint32) compositeReputationMap;
247 
248     /// number of last digits in compositeReputation for fractional part
249     uint8 public constant REPUTATION_DECIMALS = 4;
250 
251     /**
252      *  Restrict methods in such way, that they can be invoked only by merchant account.
253      */
254     modifier onlyMerchant() {
255         require(msg.sender == merchantAccount);
256         _;
257     }
258 
259     /**
260      *  Fund Address should always be Externally Owned Account and not a contract.
261      */
262     modifier isEOA(address _fundAddress) {
263         uint256 _codeLength;
264         assembly {_codeLength := extcodesize(_fundAddress)}
265         require(_codeLength == 0, "sorry humans only");
266         _;
267     }
268 
269     /**
270      *  Restrict methods in such way, that they can be invoked only by merchant account or by monethaAddress account.
271      */
272     modifier onlyMerchantOrMonetha() {
273         require(msg.sender == merchantAccount || isMonethaAddress[msg.sender]);
274         _;
275     }
276 
277     /**
278      *  @param _merchantAccount Address of merchant's account, that can withdraw from wallet
279      *  @param _merchantId Merchant identifier
280      *  @param _fundAddress Merchant's fund address, where amount will be transferred.
281      */
282     constructor(address _merchantAccount, string _merchantId, address _fundAddress) public isEOA(_fundAddress) {
283         require(_merchantAccount != 0x0);
284         require(bytes(_merchantId).length > 0);
285 
286         merchantAccount = _merchantAccount;
287         merchantIdHash = keccak256(abi.encodePacked(_merchantId));
288 
289         merchantFundAddress = _fundAddress;
290     }
291 
292     /**
293      *  Accept payment from MonethaGateway
294      */
295     function () external payable {
296     }
297 
298     /**
299      *  @return profile info by string key
300      */
301     function profile(string key) external constant returns (string) {
302         return profileMap[key];
303     }
304 
305     /**
306      *  @return payment setting by string key
307      */
308     function paymentSettings(string key) external constant returns (string) {
309         return paymentSettingsMap[key];
310     }
311 
312     /**
313      *  @return composite reputation value by string key
314      */
315     function compositeReputation(string key) external constant returns (uint32) {
316         return compositeReputationMap[key];
317     }
318 
319     /**
320      *  Set profile info by string key
321      */
322     function setProfile(
323         string profileKey,
324         string profileValue,
325         string repKey,
326         uint32 repValue
327     )
328         external onlyOwner
329     {
330         profileMap[profileKey] = profileValue;
331 
332         if (bytes(repKey).length != 0) {
333             compositeReputationMap[repKey] = repValue;
334         }
335     }
336 
337     /**
338      *  Set payment setting by string key
339      */
340     function setPaymentSettings(string key, string value) external onlyOwner {
341         paymentSettingsMap[key] = value;
342     }
343 
344     /**
345      *  Set composite reputation value by string key
346      */
347     function setCompositeReputation(string key, uint32 value) external onlyMonetha {
348         compositeReputationMap[key] = value;
349     }
350 
351     /**
352      *  Allows withdrawal of funds to beneficiary address
353      */
354     function doWithdrawal(address beneficiary, uint amount) private {
355         require(beneficiary != 0x0);
356         beneficiary.transfer(amount);
357     }
358 
359     /**
360      *  Allows merchant to withdraw funds to beneficiary address
361      */
362     function withdrawTo(address beneficiary, uint amount) public onlyMerchant whenNotPaused {
363         doWithdrawal(beneficiary, amount);
364     }
365 
366     /**
367      *  Allows merchant to withdraw funds to it's own account
368      */
369     function withdraw(uint amount) external onlyMerchant {
370         withdrawTo(msg.sender, amount);
371     }
372 
373     /**
374      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing funds to deposit address of the exchange
375      */
376     function withdrawToExchange(address depositAccount, uint amount) external onlyMerchantOrMonetha whenNotPaused {
377         doWithdrawal(depositAccount, amount);
378     }
379 
380     /**
381      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing all funds to deposit address of the exchange
382      */
383     function withdrawAllToExchange(address depositAccount, uint min_amount) external onlyMerchantOrMonetha whenNotPaused {
384         require (address(this).balance >= min_amount);
385         doWithdrawal(depositAccount, address(this).balance);
386     }
387 
388     /**
389      *  Allows merchant or Monetha to initiate exchange of tokens by withdrawing all tokens to deposit address of the exchange
390      */
391     function withdrawAllTokensToExchange(address _tokenAddress, address _depositAccount, uint _minAmount) external onlyMerchantOrMonetha whenNotPaused {
392         require(_tokenAddress != address(0));
393         
394         uint balance = GenericERC20(_tokenAddress).balanceOf(address(this));
395         
396         require(balance >= _minAmount);
397         
398         GenericERC20(_tokenAddress).transfer(_depositAccount, balance);
399     }
400 
401     /**
402      *  Allows merchant to change it's account address
403      */
404     function changeMerchantAccount(address newAccount) external onlyMerchant whenNotPaused {
405         merchantAccount = newAccount;
406     }
407 
408     /**
409      *  Allows merchant to change it's fund address.
410      */
411     function changeFundAddress(address newFundAddress) external onlyMerchant isEOA(newFundAddress) {
412         merchantFundAddress = newFundAddress;
413     }
414 }