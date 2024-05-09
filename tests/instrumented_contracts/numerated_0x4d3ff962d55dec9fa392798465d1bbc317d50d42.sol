1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.1; 
3 library SafeMath {
4     /**
5      * @dev Returns the addition of two unsigned integers, with an overflow flag.
6      *
7      * _Available since v3.4._
8      */
9     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
10         unchecked {
11             uint256 c = a + b;
12             if (c < a) return (false, 0);
13             return (true, c);
14         }
15     }
16 
17     /**
18      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
19      *
20      * _Available since v3.4._
21      */
22     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
23         unchecked {
24             if (b > a) return (false, 0);
25             return (true, a - b);
26         }
27     }
28 
29     /**
30      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {
36             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
37             // benefit is lost if 'b' is also tested.
38             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
39             if (a == 0) return (true, 0);
40             uint256 c = a * b;
41             if (c / a != b) return (false, 0);
42             return (true, c);
43         }
44     }
45 
46     /**
47      * @dev Returns the division of two unsigned integers, with a division by zero flag.
48      *
49      * _Available since v3.4._
50      */
51     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             if (b == 0) return (false, 0);
54             return (true, a / b);
55         }
56     }
57 
58     /**
59      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
60      *
61      * _Available since v3.4._
62      */
63     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             if (b == 0) return (false, 0);
66             return (true, a % b);
67         }
68     }
69 
70     /**
71      * @dev Returns the addition of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `+` operator.
75      *
76      * Requirements:
77      *
78      * - Addition cannot overflow.
79      */
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         return a + b;
82     }
83 
84     /**
85      * @dev Returns the subtraction of two unsigned integers, reverting on
86      * overflow (when the result is negative).
87      *
88      * Counterpart to Solidity's `-` operator.
89      *
90      * Requirements:
91      *
92      * - Subtraction cannot overflow.
93      */
94     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a - b;
96     }
97 
98     /**
99      * @dev Returns the multiplication of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      *
106      * - Multiplication cannot overflow.
107      */
108     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a * b;
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers, reverting on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator.
117      *
118      * Requirements:
119      *
120      * - The divisor cannot be zero.
121      */
122     function div(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a / b;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * reverting when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a % b;
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
144      * overflow (when the result is negative).
145      *
146      * CAUTION: This function is deprecated because it requires allocating memory for the error
147      * message unnecessarily. For custom revert reasons use {trySub}.
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(
156         uint256 a,
157         uint256 b,
158         string memory errorMessage
159     ) internal pure returns (uint256) {
160         unchecked {
161             require(b <= a, errorMessage);
162             return a - b;
163         }
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(
179         uint256 a,
180         uint256 b,
181         string memory errorMessage
182     ) internal pure returns (uint256) {
183         unchecked {
184             require(b > 0, errorMessage);
185             return a / b;
186         }
187     }
188 
189     /**
190      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
191      * reverting with custom message when dividing by zero.
192      *
193      * CAUTION: This function is deprecated because it requires allocating memory for the error
194      * message unnecessarily. For custom revert reasons use {tryMod}.
195      *
196      * Counterpart to Solidity's `%` operator. This function uses a `revert`
197      * opcode (which leaves remaining gas untouched) while Solidity uses an
198      * invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function mod(
205         uint256 a,
206         uint256 b,
207         string memory errorMessage
208     ) internal pure returns (uint256) {
209         unchecked {
210             require(b > 0, errorMessage);
211             return a % b;
212         }
213     }
214 }
215 
216 contract payments {
217 
218     using SafeMath for uint256;
219     mapping(string => uint256) percent;
220     mapping(address => bool) private admins;
221     address public contractOwner = msg.sender; 
222     mapping(bytes32 => address) public receipts;
223     mapping(bytes32 => uint256) public amounts;
224     mapping(address => uint256) public balanceOf; 
225     mapping(string => address) public delegate;
226     mapping(string => bytes32) public IDrissHashes;
227 
228     constructor() {
229         delegate["IDriss"] = contractOwner;
230         percent["IDriss"] = 100;
231     }
232 
233     event PaymentDone(address indexed payer, uint256 amount, bytes32 paymentId_hash, string indexed IDrissHash, uint256 date);
234     event AdminAdded(address indexed admin);
235     event AdminDeleted(address indexed admin);
236     event DelegateAdded(string delegateHandle, address indexed delegateAddress);
237     event DelegateDeleted(string delegateHandle, address indexed delegateAddress);
238     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
239 
240     function addAdmin(address adminAddress) external {
241         require(msg.sender == contractOwner, "Only contractOwner can add admins.");
242         admins[adminAddress] = true;
243         emit AdminAdded(adminAddress);
244     }
245 
246     function deleteAdmin(address adminAddress) external {
247         require(msg.sender == contractOwner, "Only contractOwner can delete admins.");
248         admins[adminAddress] = false;
249         emit AdminDeleted(adminAddress);
250     }
251 
252     function addDelegateException(address delegateAddress, string memory delegateHandle, uint256 percentage) external {
253         require(msg.sender == contractOwner, "Only contractOwner can add special delegate partner.");
254         require(delegate[delegateHandle] == address(0), "Delegate handle exists.");
255         require(delegateAddress != address(0), "Ownable: delegateAddress is the zero address.");
256         delegate[delegateHandle] = delegateAddress;
257         percent[delegateHandle] = percentage;
258         emit DelegateAdded(delegateHandle, delegateAddress);
259     }
260 
261     // Anyone can create a delegate link for anyone
262     function addDelegate(address delegateAddress, string memory delegateHandle) external {
263         require(delegate[delegateHandle] == address(0), "Delegate handle exists.");
264         require(delegateAddress != address(0), "Ownable: delegateAddress is the zero address.");
265         delegate[delegateHandle] = delegateAddress;
266         percent[delegateHandle] = 20;
267         emit DelegateAdded(delegateHandle, delegateAddress);
268     }
269 
270     // Delete the delegation link if needed.
271     function deleteDelegate(string memory delegateHandle) external {
272         require(msg.sender == delegate[delegateHandle], "Only delegate can delete delegation link.");
273         address deletedDelegate = delegate[delegateHandle];
274         delete delegate[delegateHandle];
275         delete percent[delegateHandle];
276         emit DelegateDeleted(delegateHandle, deletedDelegate);
277     }
278 
279     // Payment function distributing the payment into two balances.
280     function payNative(bytes32 paymentId_hash, string memory IDrissHash, string memory delegateHandle) external payable {
281         require(receipts[paymentId_hash] == address(0), "Already paid this receipt.");
282         receipts[paymentId_hash] = msg.sender;
283         amounts[paymentId_hash] = msg.value;
284         IDrissHashes[IDrissHash] = paymentId_hash;
285         if (delegate[delegateHandle] != address(0)) {
286             balanceOf[contractOwner] += msg.value.sub((msg.value.mul(percent[delegateHandle])).div(100));
287             balanceOf[delegate[delegateHandle]] += (msg.value.mul(percent[delegateHandle])).div(100);
288         } else {
289             balanceOf[contractOwner] += msg.value;
290         }
291         emit PaymentDone(receipts[paymentId_hash], amounts[paymentId_hash], paymentId_hash, IDrissHash, block.timestamp);
292     }
293 
294     // Anyone can withraw funds to any participating delegate
295     function withdraw(uint256 amount, string memory delegateHandle) external returns (bytes memory) {
296         require(amount <= balanceOf[delegate[delegateHandle]]);
297         balanceOf[delegate[delegateHandle]] -= amount;
298         (bool sent, bytes memory data) = delegate[delegateHandle].call{value: amount, gas: 40000}("");
299         require(sent, "Failed to  withdraw");
300         return data;
301     }
302 
303     // commit payment hash creation
304     function hashReceipt(string memory receiptId, address paymAddr) public pure returns (bytes32) {
305         require(paymAddr != address(0), "Payment address cannot be null address.");
306         return keccak256(abi.encode(receiptId, paymAddr));
307     }
308 
309     // reveal payment hash
310     function verifyReceipt(string memory receiptId, address paymAddr) public view returns (bool) {
311         require(paymAddr != address(0), "Payment address cannot be null address.");
312         require(receipts[hashReceipt(receiptId, paymAddr)] == paymAddr);
313         return true;
314     }
315 
316     // Transfer contract ownership
317     function transferContractOwnership(address newOwner) public payable {
318         require(msg.sender == contractOwner, "Only contractOwner can change ownership of contract.");
319         require(newOwner != address(0), "Ownable: new contractOwner is the zero address.");
320         _transferOwnership(newOwner);
321     }
322 
323     // Helper function
324     function _transferOwnership(address newOwner) internal virtual {
325         address oldOwner = contractOwner;
326         // transfer balance of old owner to new owner
327         uint256 ownerAmount = balanceOf[oldOwner];
328         // delete balance of old owner
329         balanceOf[oldOwner] = 0;
330         contractOwner = newOwner;
331         // set new owner
332         delegate["IDriss"] = newOwner;
333         // set balance of new owner
334         balanceOf[newOwner] = ownerAmount;
335         emit OwnershipTransferred(oldOwner, newOwner);
336     }
337 }