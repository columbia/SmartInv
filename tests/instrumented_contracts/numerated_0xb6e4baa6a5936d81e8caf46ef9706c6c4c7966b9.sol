1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() {
54     owner = msg.sender;
55   }
56 
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) onlyOwner public {
72     require(newOwner != address(0));
73     OwnershipTransferred(owner, newOwner);
74     owner = newOwner;
75   }
76 
77 }
78 
79 // File: zeppelin-solidity/contracts/lifecycle/Destructible.sol
80 
81 /**
82  * @title Destructible
83  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
84  */
85 contract Destructible is Ownable {
86 
87   function Destructible() payable { }
88 
89   /**
90    * @dev Transfers the current balance to the owner and terminates the contract.
91    */
92   function destroy() onlyOwner public {
93     selfdestruct(owner);
94   }
95 
96   function destroyAndSend(address _recipient) onlyOwner public {
97     selfdestruct(_recipient);
98   }
99 }
100 
101 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
102 
103 /**
104  * @title Pausable
105  * @dev Base contract which allows children to implement an emergency stop mechanism.
106  */
107 contract Pausable is Ownable {
108   event Pause();
109   event Unpause();
110 
111   bool public paused = false;
112 
113 
114   /**
115    * @dev Modifier to make a function callable only when the contract is not paused.
116    */
117   modifier whenNotPaused() {
118     require(!paused);
119     _;
120   }
121 
122   /**
123    * @dev Modifier to make a function callable only when the contract is paused.
124    */
125   modifier whenPaused() {
126     require(paused);
127     _;
128   }
129 
130   /**
131    * @dev called by the owner to pause, triggers stopped state
132    */
133   function pause() onlyOwner whenNotPaused public {
134     paused = true;
135     Pause();
136   }
137 
138   /**
139    * @dev called by the owner to unpause, returns to normal state
140    */
141   function unpause() onlyOwner whenPaused public {
142     paused = false;
143     Unpause();
144   }
145 }
146 
147 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
148 
149 /**
150  * @title Contactable token
151  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
152  * contact information.
153  */
154 contract Contactable is Ownable{
155 
156     string public contactInformation;
157 
158     /**
159      * @dev Allows the owner to set a string with their contact information.
160      * @param info The contact information to attach to the contract.
161      */
162     function setContactInformation(string info) onlyOwner public {
163          contactInformation = info;
164      }
165 }
166 
167 // File: contracts/Restricted.sol
168 
169 /** @title Restricted
170  *  Exposes onlyMonetha modifier
171  */
172 contract Restricted is Ownable {
173 
174     //MonethaAddress set event
175     event MonethaAddressSet(
176         address _address,
177         bool _isMonethaAddress
178     );
179 
180     mapping (address => bool) public isMonethaAddress;
181 
182     /**
183      *  Restrict methods in such way, that they can be invoked only by monethaAddress account.
184      */
185     modifier onlyMonetha() {
186         require(isMonethaAddress[msg.sender]);
187         _;
188     }
189 
190     /**
191      *  Allows owner to set new monetha address
192      */
193     function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {
194         isMonethaAddress[_address] = _isMonethaAddress;
195 
196         MonethaAddressSet(_address, _isMonethaAddress);
197     }
198 }
199 
200 // File: contracts/ERC20.sol
201 
202 /**
203 * @title ERC20 interface
204 */
205 contract ERC20 {
206     function totalSupply() public view returns (uint256);
207 
208     function decimals() public view returns(uint256);
209 
210     function balanceOf(address _who) public view returns (uint256);
211 
212     function allowance(address _owner, address _spender)
213         public view returns (uint256);
214 
215     function transfer(address _to, uint256 _value) public returns (bool);
216 
217     function approve(address _spender, uint256 _value)
218         public returns (bool);
219 
220     function transferFrom(address _from, address _to, uint256 _value)
221         public returns (bool);
222 
223     event Transfer(
224         address indexed from,
225         address indexed to,
226         uint256 value
227     );
228 
229     event Approval(
230         address indexed owner,
231         address indexed spender,
232         uint256 value
233     );
234 }
235 
236 // File: contracts/MonethaGateway.sol
237 
238 /**
239  *  @title MonethaGateway
240  *
241  *  MonethaGateway forward funds from order payment to merchant's wallet and collects Monetha fee.
242  */
243 contract MonethaGateway is Pausable, Contactable, Destructible, Restricted {
244 
245     using SafeMath for uint256;
246     
247     string constant VERSION = "0.5";
248 
249     /**
250      *  Fee permille of Monetha fee.
251      *  1 permille (‰) = 0.1 percent (%)
252      *  15‰ = 1.5%
253      */
254     uint public constant FEE_PERMILLE = 15;
255     
256     /**
257      *  Address of Monetha Vault for fee collection
258      */
259     address public monethaVault;
260 
261     /**
262      *  Account for permissions managing
263      */
264     address public admin;
265 
266     event PaymentProcessedEther(address merchantWallet, uint merchantIncome, uint monethaIncome);
267     event PaymentProcessedToken(address tokenAddress, address merchantWallet, uint merchantIncome, uint monethaIncome);
268 
269     /**
270      *  @param _monethaVault Address of Monetha Vault
271      */
272     constructor(address _monethaVault, address _admin) public {
273         require(_monethaVault != 0x0);
274         monethaVault = _monethaVault;
275         
276         setAdmin(_admin);
277     }
278     
279     /**
280      *  acceptPayment accept payment from PaymentAcceptor, forwards it to merchant's wallet
281      *      and collects Monetha fee.
282      *  @param _merchantWallet address of merchant's wallet for fund transfer
283      *  @param _monethaFee is a fee collected by Monetha
284      */
285     function acceptPayment(address _merchantWallet, uint _monethaFee) external payable onlyMonetha whenNotPaused {
286         require(_merchantWallet != 0x0);
287         require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(msg.value).div(1000)); // Monetha fee cannot be greater than 1.5% of payment
288         
289         uint merchantIncome = msg.value.sub(_monethaFee);
290 
291         _merchantWallet.transfer(merchantIncome);
292         monethaVault.transfer(_monethaFee);
293 
294         emit PaymentProcessedEther(_merchantWallet, merchantIncome, _monethaFee);
295     }
296 
297     /**
298      *  acceptTokenPayment accept token payment from PaymentAcceptor, forwards it to merchant's wallet
299      *      and collects Monetha fee.
300      *  @param _merchantWallet address of merchant's wallet for fund transfer
301      *  @param _monethaFee is a fee collected by Monetha
302      *  @param _tokenAddress is the token address
303      *  @param _value is the order value
304      */
305     function acceptTokenPayment(
306         address _merchantWallet,
307         uint _monethaFee,
308         address _tokenAddress,
309         uint _value
310     )
311         external onlyMonetha whenNotPaused
312     {
313         require(_merchantWallet != 0x0);
314 
315         // Monetha fee cannot be greater than 1.5% of payment
316         require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(_value).div(1000));
317 
318         uint merchantIncome = _value.sub(_monethaFee);
319         
320         ERC20(_tokenAddress).transfer(_merchantWallet, merchantIncome);
321         ERC20(_tokenAddress).transfer(monethaVault, _monethaFee);
322         
323         emit PaymentProcessedToken(_tokenAddress, _merchantWallet, merchantIncome, _monethaFee);
324     }
325 
326     /**
327      *  changeMonethaVault allows owner to change address of Monetha Vault.
328      *  @param newVault New address of Monetha Vault
329      */
330     function changeMonethaVault(address newVault) external onlyOwner whenNotPaused {
331         monethaVault = newVault;
332     }
333 
334     /**
335      *  Allows other monetha account or contract to set new monetha address
336      */
337     function setMonethaAddress(address _address, bool _isMonethaAddress) public {
338         require(msg.sender == admin || msg.sender == owner);
339 
340         isMonethaAddress[_address] = _isMonethaAddress;
341 
342         emit MonethaAddressSet(_address, _isMonethaAddress);
343     }
344 
345     /**
346      *  setAdmin allows owner to change address of admin.
347      *  @param _admin New address of admin
348      */
349     function setAdmin(address _admin) public onlyOwner {
350         require(_admin != 0x0);
351         admin = _admin;
352     }
353 }