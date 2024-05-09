1 pragma solidity ^0.4.24;
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
47 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
48 
49 /**
50  * @title Pausable
51  * @dev Base contract which allows children to implement an emergency stop mechanism.
52  */
53 contract Pausable is Ownable {
54   event Pause();
55   event Unpause();
56 
57   bool public paused = false;
58 
59 
60   /**
61    * @dev Modifier to make a function callable only when the contract is not paused.
62    */
63   modifier whenNotPaused() {
64     require(!paused);
65     _;
66   }
67 
68   /**
69    * @dev Modifier to make a function callable only when the contract is paused.
70    */
71   modifier whenPaused() {
72     require(paused);
73     _;
74   }
75 
76   /**
77    * @dev called by the owner to pause, triggers stopped state
78    */
79   function pause() onlyOwner whenNotPaused public {
80     paused = true;
81     Pause();
82   }
83 
84   /**
85    * @dev called by the owner to unpause, returns to normal state
86    */
87   function unpause() onlyOwner whenPaused public {
88     paused = false;
89     Unpause();
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
94 
95 /**
96  * @title Contactable token
97  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
98  * contact information.
99  */
100 contract Contactable is Ownable{
101 
102     string public contactInformation;
103 
104     /**
105      * @dev Allows the owner to set a string with their contact information.
106      * @param info The contact information to attach to the contract.
107      */
108     function setContactInformation(string info) onlyOwner public {
109          contactInformation = info;
110      }
111 }
112 
113 // File: contracts/Restricted.sol
114 
115 /** @title Restricted
116  *  Exposes onlyMonetha modifier
117  */
118 contract Restricted is Ownable {
119 
120     //MonethaAddress set event
121     event MonethaAddressSet(
122         address _address,
123         bool _isMonethaAddress
124     );
125 
126     mapping (address => bool) public isMonethaAddress;
127 
128     /**
129      *  Restrict methods in such way, that they can be invoked only by monethaAddress account.
130      */
131     modifier onlyMonetha() {
132         require(isMonethaAddress[msg.sender]);
133         _;
134     }
135 
136     /**
137      *  Allows owner to set new monetha address
138      */
139     function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {
140         isMonethaAddress[_address] = _isMonethaAddress;
141 
142         MonethaAddressSet(_address, _isMonethaAddress);
143     }
144 }
145 
146 // File: contracts/SafeDestructible.sol
147 
148 /**
149  * @title SafeDestructible
150  * Base contract that can be destroyed by owner.
151  * Can be destructed if there are no funds on contract balance.
152  */
153 contract SafeDestructible is Ownable {
154     function destroy() onlyOwner public {
155         require(this.balance == 0);
156         selfdestruct(owner);
157     }
158 }
159 
160 // File: contracts/ERC20.sol
161 
162 /**
163 * @title ERC20 interface
164 */
165 contract ERC20 {
166     function totalSupply() public view returns (uint256);
167 
168     function decimals() public view returns(uint256);
169 
170     function balanceOf(address _who) public view returns (uint256);
171 
172     function allowance(address _owner, address _spender)
173         public view returns (uint256);
174         
175     // Return type not defined intentionally since not all ERC20 tokens return proper result type
176     function transfer(address _to, uint256 _value) public;
177 
178     function approve(address _spender, uint256 _value)
179         public returns (bool);
180 
181     function transferFrom(address _from, address _to, uint256 _value)
182         public returns (bool);
183 
184     event Transfer(
185         address indexed from,
186         address indexed to,
187         uint256 value
188     );
189 
190     event Approval(
191         address indexed owner,
192         address indexed spender,
193         uint256 value
194     );
195 }
196 
197 // File: contracts/MerchantWallet.sol
198 
199 /**
200  *  @title MerchantWallet
201  *  Serves as a public Merchant profile with merchant profile info,
202  *      payment settings and latest reputation value.
203  *  Also MerchantWallet accepts payments for orders.
204  */
205 
206 contract MerchantWallet is Pausable, SafeDestructible, Contactable, Restricted {
207 
208     string constant VERSION = "0.5";
209 
210     /// Address of merchant's account, that can withdraw from wallet
211     address public merchantAccount;
212 
213     /// Address of merchant's fund address.
214     address public merchantFundAddress;
215 
216     /// Unique Merchant identifier hash
217     bytes32 public merchantIdHash;
218 
219     /// profileMap stores general information about the merchant
220     mapping (string=>string) profileMap;
221 
222     /// paymentSettingsMap stores payment and order settings for the merchant
223     mapping (string=>string) paymentSettingsMap;
224 
225     /// compositeReputationMap stores composite reputation, that compraises from several metrics
226     mapping (string=>uint32) compositeReputationMap;
227 
228     /// number of last digits in compositeReputation for fractional part
229     uint8 public constant REPUTATION_DECIMALS = 4;
230 
231     /**
232      *  Restrict methods in such way, that they can be invoked only by merchant account.
233      */
234     modifier onlyMerchant() {
235         require(msg.sender == merchantAccount);
236         _;
237     }
238 
239     /**
240      *  Fund Address should always be Externally Owned Account and not a contract.
241      */
242     modifier isEOA(address _fundAddress) {
243         uint256 _codeLength;
244         assembly {_codeLength := extcodesize(_fundAddress)}
245         require(_codeLength == 0, "sorry humans only");
246         _;
247     }
248 
249     /**
250      *  Restrict methods in such way, that they can be invoked only by merchant account or by monethaAddress account.
251      */
252     modifier onlyMerchantOrMonetha() {
253         require(msg.sender == merchantAccount || isMonethaAddress[msg.sender]);
254         _;
255     }
256 
257     /**
258      *  @param _merchantAccount Address of merchant's account, that can withdraw from wallet
259      *  @param _merchantId Merchant identifier
260      *  @param _fundAddress Merchant's fund address, where amount will be transferred.
261      */
262     constructor(address _merchantAccount, string _merchantId, address _fundAddress) public isEOA(_fundAddress) {
263         require(_merchantAccount != 0x0);
264         require(bytes(_merchantId).length > 0);
265 
266         merchantAccount = _merchantAccount;
267         merchantIdHash = keccak256(_merchantId);
268 
269         merchantFundAddress = _fundAddress;
270     }
271 
272     /**
273      *  Accept payment from MonethaGateway
274      */
275     function () external payable {
276     }
277 
278     /**
279      *  @return profile info by string key
280      */
281     function profile(string key) external constant returns (string) {
282         return profileMap[key];
283     }
284 
285     /**
286      *  @return payment setting by string key
287      */
288     function paymentSettings(string key) external constant returns (string) {
289         return paymentSettingsMap[key];
290     }
291 
292     /**
293      *  @return composite reputation value by string key
294      */
295     function compositeReputation(string key) external constant returns (uint32) {
296         return compositeReputationMap[key];
297     }
298 
299     /**
300      *  Set profile info by string key
301      */
302     function setProfile(
303         string profileKey,
304         string profileValue,
305         string repKey,
306         uint32 repValue
307     )
308         external onlyOwner
309     {
310         profileMap[profileKey] = profileValue;
311 
312         if (bytes(repKey).length != 0) {
313             compositeReputationMap[repKey] = repValue;
314         }
315     }
316 
317     /**
318      *  Set payment setting by string key
319      */
320     function setPaymentSettings(string key, string value) external onlyOwner {
321         paymentSettingsMap[key] = value;
322     }
323 
324     /**
325      *  Set composite reputation value by string key
326      */
327     function setCompositeReputation(string key, uint32 value) external onlyMonetha {
328         compositeReputationMap[key] = value;
329     }
330 
331     /**
332      *  Allows withdrawal of funds to beneficiary address
333      */
334     function doWithdrawal(address beneficiary, uint amount) private {
335         require(beneficiary != 0x0);
336         beneficiary.transfer(amount);
337     }
338 
339     /**
340      *  Allows merchant to withdraw funds to beneficiary address
341      */
342     function withdrawTo(address beneficiary, uint amount) public onlyMerchant whenNotPaused {
343         doWithdrawal(beneficiary, amount);
344     }
345 
346     /**
347      *  Allows merchant to withdraw funds to it's own account
348      */
349     function withdraw(uint amount) external onlyMerchant {
350         withdrawTo(msg.sender, amount);
351     }
352 
353     /**
354      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing funds to deposit address of the exchange
355      */
356     function withdrawToExchange(address depositAccount, uint amount) external onlyMerchantOrMonetha whenNotPaused {
357         doWithdrawal(depositAccount, amount);
358     }
359 
360     /**
361      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing all funds to deposit address of the exchange
362      */
363     function withdrawAllToExchange(address depositAccount, uint min_amount) external onlyMerchantOrMonetha whenNotPaused {
364         require (address(this).balance >= min_amount);
365         doWithdrawal(depositAccount, address(this).balance);
366     }
367 
368     /**
369      *  Allows merchant or Monetha to initiate exchange of tokens by withdrawing all tokens to deposit address of the exchange
370      */
371     function withdrawAllTokensToExchange(address _tokenAddress, address _depositAccount, uint _minAmount) external onlyMerchantOrMonetha whenNotPaused {
372         require(_tokenAddress != address(0));
373         
374         uint balance = ERC20(_tokenAddress).balanceOf(address(this));
375         
376         require(balance >= _minAmount);
377         
378         ERC20(_tokenAddress).transfer(_depositAccount, balance);
379     }
380 
381     /**
382      *  Allows merchant to change it's account address
383      */
384     function changeMerchantAccount(address newAccount) external onlyMerchant whenNotPaused {
385         merchantAccount = newAccount;
386     }
387 
388     /**
389      *  Allows merchant to change it's fund address.
390      */
391     function changeFundAddress(address newFundAddress) external onlyMerchant isEOA(newFundAddress) {
392         merchantFundAddress = newFundAddress;
393     }
394 }