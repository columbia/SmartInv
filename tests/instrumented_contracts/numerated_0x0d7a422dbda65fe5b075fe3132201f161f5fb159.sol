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
54     mapping (address => bool) public isMonethaAddress;
55 
56     /**
57      *  Restrict methods in such way, that they can be invoked only by monethaAddress account.
58      */
59     modifier onlyMonetha() {
60         require(isMonethaAddress[msg.sender]);
61         _;
62     }
63 
64     /**
65      *  Allows owner to set new monetha address
66      */
67     function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {
68         isMonethaAddress[_address] = _isMonethaAddress;
69     }
70 
71 }
72 
73 // File: contracts/SafeDestructible.sol
74 
75 /**
76  * @title SafeDestructible
77  * Base contract that can be destroyed by owner.
78  * Can be destructed if there are no funds on contract balance.
79  */
80 contract SafeDestructible is Ownable {
81     function destroy() onlyOwner public {
82         require(this.balance == 0);
83         selfdestruct(owner);
84     }
85 }
86 
87 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
88 
89 /**
90  * @title Pausable
91  * @dev Base contract which allows children to implement an emergency stop mechanism.
92  */
93 contract Pausable is Ownable {
94   event Pause();
95   event Unpause();
96 
97   bool public paused = false;
98 
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is not paused.
102    */
103   modifier whenNotPaused() {
104     require(!paused);
105     _;
106   }
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is paused.
110    */
111   modifier whenPaused() {
112     require(paused);
113     _;
114   }
115 
116   /**
117    * @dev called by the owner to pause, triggers stopped state
118    */
119   function pause() onlyOwner whenNotPaused public {
120     paused = true;
121     Pause();
122   }
123 
124   /**
125    * @dev called by the owner to unpause, returns to normal state
126    */
127   function unpause() onlyOwner whenPaused public {
128     paused = false;
129     Unpause();
130   }
131 }
132 
133 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
134 
135 /**
136  * @title Contactable token
137  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
138  * contact information.
139  */
140 contract Contactable is Ownable{
141 
142     string public contactInformation;
143 
144     /**
145      * @dev Allows the owner to set a string with their contact information.
146      * @param info The contact information to attach to the contract.
147      */
148     function setContactInformation(string info) onlyOwner public {
149          contactInformation = info;
150      }
151 }
152 
153 // File: contracts/MerchantWallet.sol
154 
155 /**
156  *  @title MerchantWallet
157  *  Serves as a public Merchant profile with merchant profile info, 
158  *      payment settings and latest reputation value.
159  *  Also MerchantWallet accepts payments for orders.
160  */
161 
162 contract MerchantWallet is Pausable, SafeDestructible, Contactable, Restricted {
163     
164     string constant VERSION = "0.3";
165 
166     /// Address of merchant's account, that can withdraw from wallet
167     address public merchantAccount;
168     
169     /// Unique Merchant identifier hash
170     bytes32 public merchantIdHash;
171 
172     /// profileMap stores general information about the merchant
173     mapping (string=>string) profileMap;
174 
175     /// paymentSettingsMap stores payment and order settings for the merchant
176     mapping (string=>string) paymentSettingsMap;
177 
178     /// compositeReputationMap stores composite reputation, that compraises from several metrics
179     mapping (string=>uint32) compositeReputationMap;
180 
181     /// number of last digits in compositeReputation for fractional part
182     uint8 public constant REPUTATION_DECIMALS = 4;
183 
184     modifier onlyMerchant() {
185         require(msg.sender == merchantAccount);
186         _;
187     }
188 
189     /**
190      *  @param _merchantAccount Address of merchant's account, that can withdraw from wallet
191      *  @param _merchantId Merchant identifier
192      */
193     function MerchantWallet(address _merchantAccount, string _merchantId) public {
194         require(_merchantAccount != 0x0);
195         require(bytes(_merchantId).length > 0);
196         
197         merchantAccount = _merchantAccount;
198         merchantIdHash = keccak256(_merchantId);
199     }
200 
201     /**
202      *  Accept payment from MonethaGateway
203      */
204     function () external payable {
205     }
206 
207     /**
208      *  @return profile info by string key
209      */
210     function profile(string key) external constant returns (string) {
211         return profileMap[key];
212     }
213 
214     /**
215      *  @return payment setting by string key
216      */
217     function paymentSettings(string key) external constant returns (string) {
218         return paymentSettingsMap[key];
219     }
220 
221     /**
222      *  @return composite reputation value by string key
223      */
224     function compositeReputation(string key) external constant returns (uint32) {
225         return compositeReputationMap[key];
226     }
227 
228     /**
229      *  Set profile info by string key
230      */
231     function setProfile(
232         string profileKey,
233         string profileValue,
234         string repKey,
235         uint32 repValue
236     ) external onlyOwner
237     {
238         profileMap[profileKey] = profileValue;
239         
240         if (bytes(repKey).length != 0) {
241             compositeReputationMap[repKey] = repValue;
242         }
243     }
244 
245     /**
246      *  Set payment setting by string key
247      */
248     function setPaymentSettings(string key, string value) external onlyOwner {
249         paymentSettingsMap[key] = value;
250     }
251 
252     /**
253      *  Set composite reputation value by string key
254      */
255     function setCompositeReputation(string key, uint32 value) external onlyMonetha {
256         compositeReputationMap[key] = value;
257     }
258 
259     /**
260      *  Allows merchant to withdraw funds to beneficiary address
261      */
262     function withdrawTo(address beneficiary, uint amount) public onlyMerchant whenNotPaused {
263         require(beneficiary != 0x0);
264         beneficiary.transfer(amount);
265     }
266 
267     /**
268      *  Allows merchant to withdraw funds to it's own account
269      */
270     function withdraw(uint amount) external {
271         withdrawTo(msg.sender, amount);
272     }
273 
274     /**
275      *  Allows merchant to change it's account address
276      */
277     function changeMerchantAccount(address newAccount) external onlyMerchant whenNotPaused {
278         merchantAccount = newAccount;
279     }
280 }