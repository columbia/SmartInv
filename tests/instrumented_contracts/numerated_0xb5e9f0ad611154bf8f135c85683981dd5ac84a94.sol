1 pragma solidity 0.5.8;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b > 0); // Solidity only automatically asserts when dividing by 0
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49     * @dev Adds two numbers, reverts on overflow.
50     */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60     * reverts when dividing by zero.
61     */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75     address payable public owner;
76 
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     /**
80      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81      * account.
82      */
83     constructor () internal {
84         owner = msg.sender;
85         emit OwnershipTransferred(address(0), owner);
86     }
87 
88 
89     /**
90      * @dev Throws if called by any account other than the owner.
91      */
92     modifier onlyOwner() {
93         require(isOwner());
94         _;
95     }
96 
97     /**
98      * @return true if `msg.sender` is the owner of the contract.
99      */
100     function isOwner() public view returns (bool) {
101         return msg.sender == owner;
102     }
103 
104     /**
105      * @dev Allows the current owner to transfer control of the contract to a newOwner.
106      * @param newOwner The address to transfer ownership to.
107      */
108     function transferOwnership(address payable newOwner) public onlyOwner {
109         _transferOwnership(newOwner);
110     }
111 
112     /**
113      * @dev Transfers control of the contract to a newOwner.
114      * @param newOwner The address to transfer ownership to.
115      */
116     function _transferOwnership(address payable newOwner) internal {
117         require(newOwner != address(0));
118         emit OwnershipTransferred(owner, newOwner);
119         owner = newOwner;
120     }
121 }
122 
123 
124 contract x2 is Ownable {
125     using SafeMath for uint256;
126 
127     uint public depositAmount = 1000000000000000000; // 1 eth
128     uint public currentPaymentIndex;
129     uint public percent = 150;
130 
131     uint public amountRaised;
132     uint public depositorsCount;
133 
134 
135     struct Deposit {
136         address payable depositor;
137         uint amount;
138         uint payout;
139         uint depositTime;
140         uint paymentTime;
141     }
142 
143     // list of all deposites
144     Deposit[] public deposits;
145     // list of user deposits
146     mapping (address => uint[]) public depositors;
147 
148     event OnDepositReceived(address investorAddress, uint value);
149     event OnPaymentSent(address investorAddress, uint value);
150 
151 
152     constructor () public {
153 
154     }
155 
156 
157     function () external payable {
158         makeDeposit();
159     }
160 
161     function makeDeposit() internal {
162         require(msg.value == depositAmount);
163 
164         Deposit memory newDeposit = Deposit(msg.sender, msg.value, msg.value.mul(percent).div(100), now, 0);
165         deposits.push(newDeposit);
166 
167         if (depositors[msg.sender].length == 0) depositorsCount += 1;
168 
169         depositors[msg.sender].push(deposits.length - 1);
170 
171         amountRaised = amountRaised.add(msg.value);
172 
173         emit OnDepositReceived(msg.sender, msg.value);
174 
175         owner.transfer(msg.value.mul(10).div(100));
176 
177         if (address(this).balance >= deposits[currentPaymentIndex].payout && deposits[currentPaymentIndex].paymentTime == 0) {
178             deposits[currentPaymentIndex].paymentTime = now;
179             deposits[currentPaymentIndex].depositor.send(deposits[currentPaymentIndex].payout);
180             emit OnPaymentSent(deposits[currentPaymentIndex].depositor, deposits[currentPaymentIndex].payout);
181             currentPaymentIndex += 1;
182         }
183     }
184 
185 
186     function getDepositsCount() public view returns (uint) {
187         return deposits.length;
188     }
189 
190     function lastDepositId() public view returns (uint) {
191         return deposits.length - 1;
192     }
193 
194     function getDeposit(uint _id) public view returns (address, uint, uint, uint, uint){
195         return (deposits[_id].depositor, deposits[_id].amount, deposits[_id].payout,
196         deposits[_id].depositTime, deposits[_id].paymentTime);
197     }
198 
199     function getUserDepositsCount(address depositor) public view returns (uint) {
200         return depositors[depositor].length;
201     }
202 
203     // lastIndex from the end of payments lest (0 - last payment), returns: address of depositor, payment time, payment amount
204     function getLastPayments(uint lastIndex) public view returns (address, uint, uint, uint, uint) {
205         uint depositIndex = currentPaymentIndex.sub(lastIndex + 1);
206 
207         return (deposits[depositIndex].depositor,
208         deposits[depositIndex].amount,
209         deposits[depositIndex].payout,
210         deposits[depositIndex].depositTime,
211         deposits[depositIndex].paymentTime);
212     }
213 
214     function getUserDeposit(address depositor, uint depositNumber) public view returns(uint, uint, uint, uint) {
215         return (deposits[depositors[depositor][depositNumber]].amount,
216         deposits[depositors[depositor][depositNumber]].payout,
217         deposits[depositors[depositor][depositNumber]].depositTime,
218         deposits[depositors[depositor][depositNumber]].paymentTime);
219     }
220 
221 }