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
80 // File: zeppelin-solidity/contracts/lifecycle/Destructible.sol
81 
82 /**
83  * @title Destructible
84  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
85  */
86 contract Destructible is Ownable {
87 
88   function Destructible() payable { }
89 
90   /**
91    * @dev Transfers the current balance to the owner and terminates the contract.
92    */
93   function destroy() onlyOwner public {
94     selfdestruct(owner);
95   }
96 
97   function destroyAndSend(address _recipient) onlyOwner public {
98     selfdestruct(_recipient);
99   }
100 }
101 
102 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
103 
104 /**
105  * @title Pausable
106  * @dev Base contract which allows children to implement an emergency stop mechanism.
107  */
108 contract Pausable is Ownable {
109   event Pause();
110   event Unpause();
111 
112   bool public paused = false;
113 
114 
115   /**
116    * @dev Modifier to make a function callable only when the contract is not paused.
117    */
118   modifier whenNotPaused() {
119     require(!paused);
120     _;
121   }
122 
123   /**
124    * @dev Modifier to make a function callable only when the contract is paused.
125    */
126   modifier whenPaused() {
127     require(paused);
128     _;
129   }
130 
131   /**
132    * @dev called by the owner to pause, triggers stopped state
133    */
134   function pause() onlyOwner whenNotPaused public {
135     paused = true;
136     Pause();
137   }
138 
139   /**
140    * @dev called by the owner to unpause, returns to normal state
141    */
142   function unpause() onlyOwner whenPaused public {
143     paused = false;
144     Unpause();
145   }
146 }
147 
148 // File: zeppelin-solidity/contracts/math/SafeMath.sol
149 
150 /**
151  * @title SafeMath
152  * @dev Math operations with safety checks that throw on error
153  */
154 library SafeMath {
155   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
156     uint256 c = a * b;
157     assert(a == 0 || c / a == b);
158     return c;
159   }
160 
161   function div(uint256 a, uint256 b) internal constant returns (uint256) {
162     // assert(b > 0); // Solidity automatically throws when dividing by 0
163     uint256 c = a / b;
164     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
165     return c;
166   }
167 
168   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
169     assert(b <= a);
170     return a - b;
171   }
172 
173   function add(uint256 a, uint256 b) internal constant returns (uint256) {
174     uint256 c = a + b;
175     assert(c >= a);
176     return c;
177   }
178 }
179 
180 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
181 
182 /**
183  * @title Contactable token
184  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
185  * contact information.
186  */
187 contract Contactable is Ownable{
188 
189     string public contactInformation;
190 
191     /**
192      * @dev Allows the owner to set a string with their contact information.
193      * @param info The contact information to attach to the contract.
194      */
195     function setContactInformation(string info) onlyOwner public {
196          contactInformation = info;
197      }
198 }
199 
200 // File: contracts/MonethaGateway.sol
201 
202 /**
203  *  @title MonethaGateway
204  *
205  *  MonethaGateway forward funds from order payment to merchant's wallet and collects Monetha fee.
206  */
207 contract MonethaGateway is Pausable, Contactable, Destructible, Restricted {
208 
209     using SafeMath for uint256;
210     
211     string constant VERSION = "0.4";
212 
213     /**
214      *  Fee permille of Monetha fee.
215      *  1 permille (‰) = 0.1 percent (%)
216      *  15‰ = 1.5%
217      */
218     uint public constant FEE_PERMILLE = 15;
219     
220     /**
221      *  Address of Monetha Vault for fee collection
222      */
223     address public monethaVault;
224 
225     /**
226      *  Account for permissions managing
227      */
228     address public admin;
229 
230     event PaymentProcessed(address merchantWallet, uint merchantIncome, uint monethaIncome);
231 
232     /**
233      *  @param _monethaVault Address of Monetha Vault
234      */
235     function MonethaGateway(address _monethaVault, address _admin) public {
236         require(_monethaVault != 0x0);
237         monethaVault = _monethaVault;
238         
239         setAdmin(_admin);
240     }
241     
242     /**
243      *  acceptPayment accept payment from PaymentAcceptor, forwards it to merchant's wallet
244      *      and collects Monetha fee.
245      *  @param _merchantWallet address of merchant's wallet for fund transfer
246      *  @param _monethaFee is a fee collected by Monetha
247      */
248     function acceptPayment(address _merchantWallet, uint _monethaFee) external payable onlyMonetha whenNotPaused {
249         require(_merchantWallet != 0x0);
250         require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(msg.value).div(1000)); // Monetha fee cannot be greater than 1.5% of payment
251 
252         uint merchantIncome = msg.value.sub(_monethaFee);
253 
254         _merchantWallet.transfer(merchantIncome);
255         monethaVault.transfer(_monethaFee);
256 
257         PaymentProcessed(_merchantWallet, merchantIncome, _monethaFee);
258     }
259 
260     /**
261      *  changeMonethaVault allows owner to change address of Monetha Vault.
262      *  @param newVault New address of Monetha Vault
263      */
264     function changeMonethaVault(address newVault) external onlyOwner whenNotPaused {
265         monethaVault = newVault;
266     }
267 
268     /**
269      *  Allows other monetha account or contract to set new monetha address
270      */
271     function setMonethaAddress(address _address, bool _isMonethaAddress) public {
272         require(msg.sender == admin || msg.sender == owner);
273 
274         isMonethaAddress[_address] = _isMonethaAddress;
275 
276         MonethaAddressSet(_address, _isMonethaAddress);
277     }
278 
279     /**
280      *  setAdmin allows owner to change address of admin.
281      *  @param _admin New address of admin
282      */
283     function setAdmin(address _admin) public onlyOwner {
284         require(_admin != 0x0);
285         admin = _admin;
286     }
287 }