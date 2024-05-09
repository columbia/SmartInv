1 pragma solidity 0.4.18;
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
171     string constant VERSION = "0.3";
172 
173     /// Address of merchant's account, that can withdraw from wallet
174     address public merchantAccount;
175 
176     /// Unique Merchant identifier hash
177     bytes32 public merchantIdHash;
178 
179     /// profileMap stores general information about the merchant
180     mapping (string=>string) profileMap;
181 
182     /// paymentSettingsMap stores payment and order settings for the merchant
183     mapping (string=>string) paymentSettingsMap;
184 
185     /// compositeReputationMap stores composite reputation, that compraises from several metrics
186     mapping (string=>uint32) compositeReputationMap;
187 
188     /// number of last digits in compositeReputation for fractional part
189     uint8 public constant REPUTATION_DECIMALS = 4;
190 
191     modifier onlyMerchant() {
192         require(msg.sender == merchantAccount);
193         _;
194     }
195 
196     /**
197      *  @param _merchantAccount Address of merchant's account, that can withdraw from wallet
198      *  @param _merchantId Merchant identifier
199      */
200     function MerchantWallet(address _merchantAccount, string _merchantId) public {
201         require(_merchantAccount != 0x0);
202         require(bytes(_merchantId).length > 0);
203 
204         merchantAccount = _merchantAccount;
205         merchantIdHash = keccak256(_merchantId);
206     }
207 
208     /**
209      *  Accept payment from MonethaGateway
210      */
211     function () external payable {
212     }
213 
214     /**
215      *  @return profile info by string key
216      */
217     function profile(string key) external constant returns (string) {
218         return profileMap[key];
219     }
220 
221     /**
222      *  @return payment setting by string key
223      */
224     function paymentSettings(string key) external constant returns (string) {
225         return paymentSettingsMap[key];
226     }
227 
228     /**
229      *  @return composite reputation value by string key
230      */
231     function compositeReputation(string key) external constant returns (uint32) {
232         return compositeReputationMap[key];
233     }
234 
235     /**
236      *  Set profile info by string key
237      */
238     function setProfile(
239         string profileKey,
240         string profileValue,
241         string repKey,
242         uint32 repValue
243     ) external onlyOwner
244     {
245         profileMap[profileKey] = profileValue;
246 
247         if (bytes(repKey).length != 0) {
248             compositeReputationMap[repKey] = repValue;
249         }
250     }
251 
252     /**
253      *  Set payment setting by string key
254      */
255     function setPaymentSettings(string key, string value) external onlyOwner {
256         paymentSettingsMap[key] = value;
257     }
258 
259     /**
260      *  Set composite reputation value by string key
261      */
262     function setCompositeReputation(string key, uint32 value) external onlyMonetha {
263         compositeReputationMap[key] = value;
264     }
265 
266     /**
267      *  Allows withdrawal of funds to beneficiary address
268      */
269     function doWithdrawal(address beneficiary, uint amount) private {
270         require(beneficiary != 0x0);
271         beneficiary.transfer(amount);
272     }
273 
274     /**
275      *  Allows merchant to withdraw funds to beneficiary address
276      */
277     function withdrawTo(address beneficiary, uint amount) public onlyMerchant whenNotPaused {
278         doWithdrawal(beneficiary, amount);
279     }
280 
281     /**
282      *  Allows merchant to withdraw funds to it's own account
283      */
284     function withdraw(uint amount) external {
285         withdrawTo(msg.sender, amount);
286     }
287 
288     /**
289      *  Allows merchant to withdraw funds to beneficiary address with a transaction
290      */
291     function sendTo(address beneficiary, uint amount) external onlyMerchant whenNotPaused {
292         doWithdrawal(beneficiary, amount);
293     }
294 
295     /**
296      *  Allows merchant to change it's account address
297      */
298     function changeMerchantAccount(address newAccount) external onlyMerchant whenNotPaused {
299         merchantAccount = newAccount;
300     }
301 }