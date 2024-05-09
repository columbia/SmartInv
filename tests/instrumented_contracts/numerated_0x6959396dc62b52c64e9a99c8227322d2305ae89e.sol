1 pragma solidity ^0.4.23;
2 
3 // File: contracts/Ownable.sol
4 
5 /**
6      * @title Ownable
7      * @dev The Ownable contract has an owner address, and provides basic authorization control
8      * functions, this simplifies the implementation of "user permissions".
9      */
10     contract Ownable {
11       address public owner;
12     
13       event OwnershipRenounced(address indexed previousOwner);
14       event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15     
16       /**
17        * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18        * account.
19        */
20       //function Ownable() public {
21       constructor() public {
22         owner = msg.sender;
23       }
24     
25       /**
26        * @dev Throws if called by any account other than the owner.
27        */
28       modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31       }
32     
33       /**
34        * @dev Allows the current owner to transfer control of the contract to a newOwner.
35        * @param newOwner The address to transfer ownership to.
36        */
37       function transferOwnership(address newOwner) public onlyOwner {
38         require(newOwner != address(0));
39         emit OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41       }
42     
43       /**
44        * @dev Allows the current owner to relinquish control of the contract.
45        */
46       function renounceOwnership() public onlyOwner {
47         emit OwnershipRenounced(owner);
48         owner = address(0);
49       }
50     }
51 
52 // File: contracts/CeoOwner.sol
53 
54 contract CeoOwner is Ownable{
55 
56 	// The primary address which is permitted to interact with the contract
57 	// Address of wallet account on WEB3.js account.
58 	address public ceoAddress; 
59 
60 	modifier onlyCEO() {
61 		require(msg.sender == ceoAddress);
62 		_;
63 	}
64 
65 }
66 
67 // File: contracts/ReentrancyGuard.sol
68 
69 /**
70  * @title Helps contracts guard agains reentrancy attacks.
71  * @author Remco Bloemen <remco@2π.com>
72  * @notice If you mark a function `nonReentrant`, you should also
73  * mark it `external`.
74  */
75  contract ReentrancyGuard {
76 
77   /**
78    * @dev We use a single lock for the whole contract.
79    */
80    bool private reentrancyLock = false;
81 
82   /**
83    * @dev Prevents a contract from calling itself, directly or indirectly.
84    * @notice If you mark a function `nonReentrant`, you should also
85    * mark it `external`. Calling one nonReentrant function from
86    * another is not supported. Instead, you can implement a
87    * `private` function doing the actual work, and a `external`
88    * wrapper marked as `nonReentrant`.
89    */
90    modifier nonReentrant() {
91     require(!reentrancyLock);
92     reentrancyLock = true;
93     _;
94     reentrancyLock = false;
95   }
96 
97 }
98 
99 // File: contracts/SafeMath.sol
100 
101 /**
102      * @title SafeMath
103      * @dev Math operations with safety checks that throw on error
104      */
105      library SafeMath {
106       
107       /**
108       * @dev Multiplies two numbers, throws on overflow.
109       */
110       function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
111         if (a == 0) {
112           return 0;
113         }
114         c = a * b;
115         assert(c / a == b);
116         return c;
117       }
118       
119       /**
120       * @dev Integer division of two numbers, truncating the quotient.
121       */
122       function div(uint256 a, uint256 b) internal pure returns (uint256) {
123         // assert(b > 0); // Solidity automatically throws when dividing by 0
124         // uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126         return a / b;
127       }
128       
129       /**
130       * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
131       */
132       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133         assert(b <= a);
134         return a - b;
135       }
136       
137       /**
138       * @dev Adds two numbers, throws on overflow.
139       */
140       function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
141         c = a + b;
142         assert(c >= a);
143         return c;
144       }
145     }
146 
147 // File: contracts/CertificateCore.sol
148 
149 contract CertificateCore is CeoOwner, ReentrancyGuard { 
150    
151     using SafeMath for uint256; 
152 
153     uint256 public constant KEY_CREATION_LIMIT = 10000;
154     uint256 public totalSupplyOfKeys;
155     uint256 public totalReclaimedKeys;
156     
157     // Track who is making the deposits and the amount made
158     mapping(address => uint256) public balanceOf; 
159 
160     // Main data structure to hold all of the public keys   
161     mapping(address => bool) public allThePublicKeys;
162     
163     // A bonus deposit has been made
164     event DepositBonusEvent(address sender, uint256 amount); 
165     
166     // A new certificate has been successfully sold and a deposit added
167     event DepositCertificateSaleEvent(address sender, address publicKey, uint256 amount);
168 
169     // A certificate has been payed out.
170     event CertPayedOutEvent(address sender, address recpublicKey, uint256 payoutValue);
171     
172 
173     constructor(address _ceoAddress) public{
174         require(_ceoAddress != address(0));
175         owner = msg.sender;
176         ceoAddress = _ceoAddress;
177     }
178  
179     
180     /**
181      *
182      * Main function for creating certificates
183      * 
184      */
185     //function createANewCert(address _publicKey, uint256 _amount) external payable onlyCEO{
186     function depositCertificateSale(address _publicKey, uint256 _amount) external payable onlyCEO{
187         require(msg.sender != address(0));
188         require(_amount > 0);
189         require(msg.value == _amount);
190         require(_publicKey != address(0));
191         require(totalSupplyOfKeys < KEY_CREATION_LIMIT);
192         require(totalReclaimedKeys < KEY_CREATION_LIMIT);
193  
194         require(!allThePublicKeys[_publicKey]);
195 
196         allThePublicKeys[_publicKey]=true;
197         totalSupplyOfKeys ++;
198 
199         balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);
200         
201         emit DepositCertificateSaleEvent(msg.sender, _publicKey, _amount);
202     }
203     
204     /**
205      *  Allow the CEO to deposit ETH without creating a new certificate
206      * 
207      * */
208     //function deposit(uint256 _amount) external payable onlyCEO {
209     function depositBonus(uint256 _amount) external payable onlyCEO {
210         require(_amount > 0);
211         require(msg.value == _amount);
212       
213         require((totalSupplyOfKeys > 0) && (totalSupplyOfKeys < KEY_CREATION_LIMIT));
214         require(totalReclaimedKeys < KEY_CREATION_LIMIT);
215       
216         balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);
217         
218         emit DepositBonusEvent(msg.sender, _amount);
219     }
220     
221     /**
222      * Payout a certificate. 
223      * 
224      */
225     function payoutACert(bytes32 _msgHash, uint8 _v, bytes32 _r, bytes32 _s) external nonReentrant{
226         require(msg.sender != address(0));
227         require(address(this).balance > 0);
228         require(totalSupplyOfKeys > 0);
229         require(totalReclaimedKeys < KEY_CREATION_LIMIT);
230          
231         address _recoveredAddress = ecrecover(_msgHash, _v, _r, _s);
232         require(allThePublicKeys[_recoveredAddress]);
233     
234         allThePublicKeys[_recoveredAddress]=false;
235 
236         uint256 _validKeys = totalSupplyOfKeys.sub(totalReclaimedKeys);
237         uint256 _payoutValue = address(this).balance.div(_validKeys);
238 
239         msg.sender.transfer(_payoutValue);
240         emit CertPayedOutEvent(msg.sender, _recoveredAddress, _payoutValue);
241         
242         totalReclaimedKeys ++;
243     }
244  
245      /**
246      * Update payout value per certificate.
247      */
248      //
249      // debug only. remove in Live deploy.
250      // do this operation on the Dapp side.
251     function calculatePayout() view external returns(
252         uint256 _etherValue
253         ){
254         uint256 _validKeys = totalSupplyOfKeys.sub(totalReclaimedKeys);
255         // Last key has been paid out.
256         if(_validKeys == 0){
257             _etherValue = 0;
258         }else{
259             _etherValue = address(this).balance.div(_validKeys);
260         }
261     }
262  
263  
264     /**
265      * Check to see if a Key has been payed out or if it's still valid
266      */
267     function checkIfValidKey(address _publicKey) view external{ // external
268         require(_publicKey != address(0));
269         require(allThePublicKeys[_publicKey]);
270     }
271 
272     function getBalance() view external returns(
273          uint256 contractBalance
274     ){
275         contractBalance = address(this).balance;
276     }
277     
278     /**
279      * Saftey Mechanism
280      * 
281      */
282     function kill() external onlyOwner 
283     { 
284         selfdestruct(owner); 
285     }
286  
287     /**
288      * Payable fallback function.
289      * No Tipping! 
290      * 
291      */
292     //function () payable public{
293     //    throw;
294     //}
295     
296 }
297 
298 // File: contracts/Migrations.sol
299 
300 contract Migrations {
301   address public owner;
302   uint public last_completed_migration;
303 
304   modifier restricted() {
305     if (msg.sender == owner) _;
306   }
307 
308   //function Migrations() public {
309   constructor() public {
310     owner = msg.sender;
311   }
312 
313   function setCompleted(uint completed) public restricted {
314     last_completed_migration = completed;
315   }
316 
317   function upgrade(address new_address) public restricted {
318     Migrations upgraded = Migrations(new_address);
319     upgraded.setCompleted(last_completed_migration);
320   }
321 }