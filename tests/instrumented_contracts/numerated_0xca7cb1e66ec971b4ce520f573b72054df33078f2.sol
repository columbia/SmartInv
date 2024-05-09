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
175     function transfer(address _to, uint256 _value) public returns (bool);
176 
177     function approve(address _spender, uint256 _value)
178         public returns (bool);
179 
180     function transferFrom(address _from, address _to, uint256 _value)
181         public returns (bool);
182 
183     event Transfer(
184         address indexed from,
185         address indexed to,
186         uint256 value
187     );
188 
189     event Approval(
190         address indexed owner,
191         address indexed spender,
192         uint256 value
193     );
194 }
195 
196 // File: contracts/MerchantWallet.sol
197 
198 /**
199  *  @title MerchantWallet
200  *  Serves as a public Merchant profile with merchant profile info,
201  *      payment settings and latest reputation value.
202  *  Also MerchantWallet accepts payments for orders.
203  */
204 
205 contract MerchantWallet is Pausable, SafeDestructible, Contactable, Restricted {
206 
207     string constant VERSION = "0.5";
208 
209     /// Address of merchant's account, that can withdraw from wallet
210     address public merchantAccount;
211 
212     /// Address of merchant's fund address.
213     address public merchantFundAddress;
214 
215     /// Unique Merchant identifier hash
216     bytes32 public merchantIdHash;
217 
218     /// profileMap stores general information about the merchant
219     mapping (string=>string) profileMap;
220 
221     /// paymentSettingsMap stores payment and order settings for the merchant
222     mapping (string=>string) paymentSettingsMap;
223 
224     /// compositeReputationMap stores composite reputation, that compraises from several metrics
225     mapping (string=>uint32) compositeReputationMap;
226 
227     /// number of last digits in compositeReputation for fractional part
228     uint8 public constant REPUTATION_DECIMALS = 4;
229 
230     /**
231      *  Restrict methods in such way, that they can be invoked only by merchant account.
232      */
233     modifier onlyMerchant() {
234         require(msg.sender == merchantAccount);
235         _;
236     }
237 
238     /**
239      *  Fund Address should always be Externally Owned Account and not a contract.
240      */
241     modifier isEOA(address _fundAddress) {
242         uint256 _codeLength;
243         assembly {_codeLength := extcodesize(_fundAddress)}
244         require(_codeLength == 0, "sorry humans only");
245         _;
246     }
247 
248     /**
249      *  Restrict methods in such way, that they can be invoked only by merchant account or by monethaAddress account.
250      */
251     modifier onlyMerchantOrMonetha() {
252         require(msg.sender == merchantAccount || isMonethaAddress[msg.sender]);
253         _;
254     }
255 
256     /**
257      *  @param _merchantAccount Address of merchant's account, that can withdraw from wallet
258      *  @param _merchantId Merchant identifier
259      *  @param _fundAddress Merchant's fund address, where amount will be transferred.
260      */
261     constructor(address _merchantAccount, string _merchantId, address _fundAddress) public isEOA(_fundAddress) {
262         require(_merchantAccount != 0x0);
263         require(bytes(_merchantId).length > 0);
264 
265         merchantAccount = _merchantAccount;
266         merchantIdHash = keccak256(_merchantId);
267 
268         merchantFundAddress = _fundAddress;
269     }
270 
271     /**
272      *  Accept payment from MonethaGateway
273      */
274     function () external payable {
275     }
276 
277     /**
278      *  @return profile info by string key
279      */
280     function profile(string key) external constant returns (string) {
281         return profileMap[key];
282     }
283 
284     /**
285      *  @return payment setting by string key
286      */
287     function paymentSettings(string key) external constant returns (string) {
288         return paymentSettingsMap[key];
289     }
290 
291     /**
292      *  @return composite reputation value by string key
293      */
294     function compositeReputation(string key) external constant returns (uint32) {
295         return compositeReputationMap[key];
296     }
297 
298     /**
299      *  Set profile info by string key
300      */
301     function setProfile(
302         string profileKey,
303         string profileValue,
304         string repKey,
305         uint32 repValue
306     )
307         external onlyOwner
308     {
309         profileMap[profileKey] = profileValue;
310 
311         if (bytes(repKey).length != 0) {
312             compositeReputationMap[repKey] = repValue;
313         }
314     }
315 
316     /**
317      *  Set payment setting by string key
318      */
319     function setPaymentSettings(string key, string value) external onlyOwner {
320         paymentSettingsMap[key] = value;
321     }
322 
323     /**
324      *  Set composite reputation value by string key
325      */
326     function setCompositeReputation(string key, uint32 value) external onlyMonetha {
327         compositeReputationMap[key] = value;
328     }
329 
330     /**
331      *  Allows withdrawal of funds to beneficiary address
332      */
333     function doWithdrawal(address beneficiary, uint amount) private {
334         require(beneficiary != 0x0);
335         beneficiary.transfer(amount);
336     }
337 
338     /**
339      *  Allows merchant to withdraw funds to beneficiary address
340      */
341     function withdrawTo(address beneficiary, uint amount) public onlyMerchant whenNotPaused {
342         doWithdrawal(beneficiary, amount);
343     }
344 
345     /**
346      *  Allows merchant to withdraw funds to it's own account
347      */
348     function withdraw(uint amount) external onlyMerchant {
349         withdrawTo(msg.sender, amount);
350     }
351 
352     /**
353      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing funds to deposit address of the exchange
354      */
355     function withdrawToExchange(address depositAccount, uint amount) external onlyMerchantOrMonetha whenNotPaused {
356         doWithdrawal(depositAccount, amount);
357     }
358 
359     /**
360      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing all funds to deposit address of the exchange
361      */
362     function withdrawAllToExchange(address depositAccount, uint min_amount) external onlyMerchantOrMonetha whenNotPaused {
363         require (address(this).balance >= min_amount);
364         doWithdrawal(depositAccount, address(this).balance);
365     }
366 
367     /**
368      *  Allows merchant or Monetha to initiate exchange of tokens by withdrawing all tokens to deposit address of the exchange
369      */
370     function withdrawAllTokensToExchange(address _tokenAddress, address _depositAccount, uint _minAmount) external onlyMerchantOrMonetha whenNotPaused {
371         require(_tokenAddress != address(0));
372         
373         uint balance = ERC20(_tokenAddress).balanceOf(address(this));
374         
375         require(balance >= _minAmount);
376         
377         ERC20(_tokenAddress).transfer(_depositAccount, balance);
378     }
379 
380     /**
381      *  Allows merchant to change it's account address
382      */
383     function changeMerchantAccount(address newAccount) external onlyMerchant whenNotPaused {
384         merchantAccount = newAccount;
385     }
386 
387     /**
388      *  Allows merchant to change it's fund address.
389      */
390     function changeFundAddress(address newFundAddress) external onlyMerchant isEOA(newFundAddress) {
391         merchantFundAddress = newFundAddress;
392     }
393 }