1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     require(newOwner != address(0));
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 
76 /**
77  * @title Pausable
78  * @dev Base contract which allows children to implement an emergency stop mechanism.
79  */
80 contract Pausable is Ownable {
81   event Pause();
82   event Unpause();
83 
84   bool public paused = false;
85 
86 
87   /**
88    * @dev Modifier to make a function callable only when the contract is not paused.
89    */
90   modifier whenNotPaused() {
91     require(!paused);
92     _;
93   }
94 
95   /**
96    * @dev Modifier to make a function callable only when the contract is paused.
97    */
98   modifier whenPaused() {
99     require(paused);
100     _;
101   }
102 
103   /**
104    * @dev called by the owner to pause, triggers stopped state
105    */
106   function pause() onlyOwner whenNotPaused public {
107     paused = true;
108     Pause();
109   }
110 
111   /**
112    * @dev called by the owner to unpause, returns to normal state
113    */
114   function unpause() onlyOwner whenPaused public {
115     paused = false;
116     Unpause();
117   }
118 }
119 
120 
121 
122 
123 
124 
125 
126 
127 
128 /*
129  This is a simple contract that is used to track incoming payments.
130  As soon as a payment is received, an event is triggered to log the transaction.
131  All funds are immediately forwarded to the owner.
132  The sender must include a payment code as a payload and the contract can conditionally enforce the
133  sending address matches the payment code.
134  The payment code is the first 8 bytes of the keccak/sha3 hash of the address that the user has specified in the sale.
135 */
136 contract SaleTracker is Pausable {
137   using SafeMath for uint256;
138 
139   // Event to allow monitoring incoming payments
140   event PurchaseMade (address indexed _from, bytes8 _paymentCode, uint256 _value);
141 
142   // Tracking of purchase total in wei made per sending address
143   mapping(address => uint256) public purchases;
144 
145   // Tracking of purchaser addresses for lookup offline
146   address[] public purchaserAddresses;
147 
148   // Flag to enforce payments source address matching the payment code
149   bool public enforceAddressMatch;
150 
151   // Constructor to start the contract in a paused state
152   function SaleTracker(bool _enforceAddressMatch) {
153     enforceAddressMatch = _enforceAddressMatch;
154     pause();
155   }
156 
157   // Setter for the enforce flag - only updatable by the owner
158   function setEnforceAddressMatch(bool _enforceAddressMatch) onlyOwner public {
159     enforceAddressMatch = _enforceAddressMatch;
160   }
161 
162   // Purchase function allows incoming payments when not paused - requires payment code
163   function purchase(bytes8 paymentCode) whenNotPaused public payable {
164 
165     // Verify they have sent ETH in
166     require(msg.value != 0);
167 
168     // Verify the payment code was included
169     require(paymentCode != 0);
170 
171     // If payment from addresses are being enforced, ensure the code matches the sender address
172     if (enforceAddressMatch) {
173 
174       // Get the first 8 bytes of the hash of the address
175       bytes8 calculatedPaymentCode = bytes8(sha3(msg.sender));
176 
177       // Fail if the sender code does not match
178       require(calculatedPaymentCode == paymentCode);
179     }
180 
181     // Save off the existing purchase amount for this user
182     uint256 existingPurchaseAmount = purchases[msg.sender];
183 
184     // If they have not purchased before (0 value), then save it off
185     if (existingPurchaseAmount == 0) {
186       purchaserAddresses.push(msg.sender);
187     }
188 
189     // Add the new purchase value to the existing value already being tracked
190     purchases[msg.sender] = existingPurchaseAmount.add(msg.value);    
191 
192     // Transfer out to the owner wallet
193     owner.transfer(msg.value);
194 
195     // Trigger the event for a new purchase
196     PurchaseMade(msg.sender, paymentCode, msg.value);
197   }
198 
199   // Allows owner to sweep any ETH somehow trapped in the contract.
200   function sweep() onlyOwner public {
201     owner.transfer(this.balance);
202   }
203 
204   // Get the number of addresses that have contributed to the sale
205   function getPurchaserAddressCount() public constant returns (uint) {
206     return purchaserAddresses.length;
207   }
208 
209 }