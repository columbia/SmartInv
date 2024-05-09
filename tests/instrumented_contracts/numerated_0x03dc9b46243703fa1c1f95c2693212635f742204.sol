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
73 // File: zeppelin-solidity/contracts/lifecycle/Destructible.sol
74 
75 /**
76  * @title Destructible
77  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
78  */
79 contract Destructible is Ownable {
80 
81   function Destructible() payable { }
82 
83   /**
84    * @dev Transfers the current balance to the owner and terminates the contract.
85    */
86   function destroy() onlyOwner public {
87     selfdestruct(owner);
88   }
89 
90   function destroyAndSend(address _recipient) onlyOwner public {
91     selfdestruct(_recipient);
92   }
93 }
94 
95 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
96 
97 /**
98  * @title Pausable
99  * @dev Base contract which allows children to implement an emergency stop mechanism.
100  */
101 contract Pausable is Ownable {
102   event Pause();
103   event Unpause();
104 
105   bool public paused = false;
106 
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is not paused.
110    */
111   modifier whenNotPaused() {
112     require(!paused);
113     _;
114   }
115 
116   /**
117    * @dev Modifier to make a function callable only when the contract is paused.
118    */
119   modifier whenPaused() {
120     require(paused);
121     _;
122   }
123 
124   /**
125    * @dev called by the owner to pause, triggers stopped state
126    */
127   function pause() onlyOwner whenNotPaused public {
128     paused = true;
129     Pause();
130   }
131 
132   /**
133    * @dev called by the owner to unpause, returns to normal state
134    */
135   function unpause() onlyOwner whenPaused public {
136     paused = false;
137     Unpause();
138   }
139 }
140 
141 // File: zeppelin-solidity/contracts/math/SafeMath.sol
142 
143 /**
144  * @title SafeMath
145  * @dev Math operations with safety checks that throw on error
146  */
147 library SafeMath {
148   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
149     uint256 c = a * b;
150     assert(a == 0 || c / a == b);
151     return c;
152   }
153 
154   function div(uint256 a, uint256 b) internal constant returns (uint256) {
155     // assert(b > 0); // Solidity automatically throws when dividing by 0
156     uint256 c = a / b;
157     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
158     return c;
159   }
160 
161   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
162     assert(b <= a);
163     return a - b;
164   }
165 
166   function add(uint256 a, uint256 b) internal constant returns (uint256) {
167     uint256 c = a + b;
168     assert(c >= a);
169     return c;
170   }
171 }
172 
173 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
174 
175 /**
176  * @title Contactable token
177  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
178  * contact information.
179  */
180 contract Contactable is Ownable{
181 
182     string public contactInformation;
183 
184     /**
185      * @dev Allows the owner to set a string with their contact information.
186      * @param info The contact information to attach to the contract.
187      */
188     function setContactInformation(string info) onlyOwner public {
189          contactInformation = info;
190      }
191 }
192 
193 // File: contracts/MonethaGateway.sol
194 
195 /**
196  *  @title MonethaGateway
197  *
198  *  MonethaGateway forward funds from order payment to merchant's wallet and collects Monetha fee.
199  */
200 contract MonethaGateway is Pausable, Contactable, Destructible, Restricted {
201 
202     using SafeMath for uint256;
203     
204     string constant VERSION = "0.3";
205 
206     /**
207      *  Fee permille of Monetha fee.
208      *  1 permille (‰) = 0.1 percent (%)
209      *  15‰ = 1.5%
210      */
211     uint public constant FEE_PERMILLE = 15;
212     
213     /**
214      *  Address of Monetha Vault for fee collection
215      */
216     address public monethaVault;
217 
218     /**
219      *  Account for permissions managing
220      */
221     address public admin;
222 
223     event PaymentProcessed(address merchantWallet, uint merchantIncome, uint monethaIncome);
224 
225     /**
226      *  @param _monethaVault Address of Monetha Vault
227      */
228     function MonethaGateway(address _monethaVault, address _admin) public {
229         require(_monethaVault != 0x0);
230         monethaVault = _monethaVault;
231         
232         setAdmin(_admin);
233     }
234     
235     /**
236      *  acceptPayment accept payment from PaymentAcceptor, forwards it to merchant's wallet
237      *      and collects Monetha fee.
238      *  @param _merchantWallet address of merchant's wallet for fund transfer
239      */
240     function acceptPayment(address _merchantWallet) external payable onlyMonetha whenNotPaused {
241         require(_merchantWallet != 0x0);
242 
243         uint merchantIncome = msg.value.sub(FEE_PERMILLE.mul(msg.value).div(1000));
244         uint monethaIncome = msg.value.sub(merchantIncome);
245 
246         _merchantWallet.transfer(merchantIncome);
247         monethaVault.transfer(monethaIncome);
248 
249         PaymentProcessed(_merchantWallet, merchantIncome, monethaIncome);
250     }
251 
252     /**
253      *  changeMonethaVault allows owner to change address of Monetha Vault.
254      *  @param newVault New address of Monetha Vault
255      */
256     function changeMonethaVault(address newVault) external onlyOwner whenNotPaused {
257         monethaVault = newVault;
258     }
259 
260     /**
261      *  Allows other monetha account or contract to set new monetha address
262      */
263     function setMonethaAddress(address _address, bool _isMonethaAddress) public {
264         require(msg.sender == admin || msg.sender == owner);
265 
266         isMonethaAddress[_address] = _isMonethaAddress;
267     }
268 
269     /**
270      *  setAdmin allows owner to change address of admin.
271      *  @param _admin New address of admin
272      */
273     function setAdmin(address _admin) public onlyOwner {
274         require(_admin != 0x0);
275         admin = _admin;
276     }
277 }