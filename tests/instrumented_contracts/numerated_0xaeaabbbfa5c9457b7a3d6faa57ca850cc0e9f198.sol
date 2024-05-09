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
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     Unpause();
88   }
89 }
90 
91 // File: zeppelin-solidity/contracts/math/SafeMath.sol
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103     if (a == 0) {
104       return 0;
105     }
106     uint256 c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return c;
119   }
120 
121   /**
122   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256) {
133     uint256 c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 // File: contracts/crowdsale/SaleTracker.sol
140 
141 /*
142  This is a simple contract that is used to track incoming payments.
143  As soon as a payment is received, an event is triggered to log the transaction.
144  All funds are immediately forwarded to the owner.
145  The sender must include a payment code as a payload and the contract can conditionally enforce the
146  sending address matches the payment code.
147  The payment code is the first 8 bytes of the keccak/sha3 hash of the address that the user has specified in the sale.
148 */
149 contract SaleTracker is Pausable {
150   using SafeMath for uint256;
151 
152   // Event to allow monitoring incoming payments
153   event PurchaseMade (address indexed _from, bytes8 _paymentCode, uint256 _value);
154 
155   // Tracking of purchase total in wei made per sending address
156   mapping(address => uint256) public purchases;
157 
158   // Tracking of purchaser addresses for lookup offline
159   address[] public purchaserAddresses;
160 
161   // Flag to enforce payments source address matching the payment code
162   bool public enforceAddressMatch;
163 
164   // Constructor to start the contract in a paused state
165   function SaleTracker(bool _enforceAddressMatch) public {
166     enforceAddressMatch = _enforceAddressMatch;
167     pause();
168   }
169 
170   // Setter for the enforce flag - only updatable by the owner
171   function setEnforceAddressMatch(bool _enforceAddressMatch) onlyOwner public {
172     enforceAddressMatch = _enforceAddressMatch;
173   }
174 
175   // Purchase function allows incoming payments when not paused - requires payment code
176   function purchase(bytes8 paymentCode) whenNotPaused public payable {
177 
178     // Verify they have sent ETH in
179     require(msg.value != 0);
180 
181     // Verify the payment code was included
182     require(paymentCode != 0);
183 
184     // If payment from addresses are being enforced, ensure the code matches the sender address
185     if (enforceAddressMatch) {
186 
187       // Get the first 8 bytes of the hash of the address
188       bytes8 calculatedPaymentCode = bytes8(keccak256(msg.sender));
189 
190       // Fail if the sender code does not match
191       require(calculatedPaymentCode == paymentCode);
192     }
193 
194     // Save off the existing purchase amount for this user
195     uint256 existingPurchaseAmount = purchases[msg.sender];
196 
197     // If they have not purchased before (0 value), then save it off
198     if (existingPurchaseAmount == 0) {
199       purchaserAddresses.push(msg.sender);
200     }
201 
202     // Add the new purchase value to the existing value already being tracked
203     purchases[msg.sender] = existingPurchaseAmount.add(msg.value);    
204 
205     // Transfer out to the owner wallet
206     owner.transfer(msg.value);
207 
208     // Trigger the event for a new purchase
209     PurchaseMade(msg.sender, paymentCode, msg.value);
210   }
211 
212   // Allows owner to sweep any ETH somehow trapped in the contract.
213   function sweep() onlyOwner public {
214     owner.transfer(this.balance);
215   }
216 
217   // Get the number of addresses that have contributed to the sale
218   function getPurchaserAddressCount() public constant returns (uint) {
219     return purchaserAddresses.length;
220   }
221 
222 }