1 pragma solidity ^0.5.12;
2 
3 
4 /**
5  * @dev These functions deal with verification of Merkle trees (hash trees),
6  */
7 library MerkleProof {
8     /**
9      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
10      * defined by `root`. For this, a `proof` must be provided, containing
11      * sibling hashes on the branch from the leaf to the root of the tree. Each
12      * pair of leaves and each pair of pre-images are assumed to be sorted.
13      */
14     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
15         bytes32 computedHash = leaf;
16 
17         for (uint256 i = 0; i < proof.length; i++) {
18             bytes32 proofElement = proof[i];
19 
20             if (computedHash <= proofElement) {
21                 // Hash(current computed hash + current element of the proof)
22                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
23             } else {
24                 // Hash(current element of the proof + current computed hash)
25                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
26             }
27         }
28 
29         // Check if the computed hash (root) is equal to the provided root
30         return computedHash == root;
31     }
32 }
33 
34 /**
35  * @dev Wrappers over Solidity's arithmetic operations with added overflow
36  * checks.
37  *
38  * Arithmetic operations in Solidity wrap on overflow. This can easily result
39  * in bugs, because programmers usually assume that an overflow raises an
40  * error, which is the standard behavior in high level programming languages.
41  * `SafeMath` restores this intuition by reverting the transaction when an
42  * operation overflows.
43  *
44  * Using this library instead of the unchecked operations eliminates an entire
45  * class of bugs, so it's recommended to use it always.
46  */
47 library SafeMath {
48     /**
49      * @dev Returns the addition of two unsigned integers, reverting on
50      * overflow.
51      *
52      * Counterpart to Solidity's `+` operator.
53      *
54      * Requirements:
55      * - Addition cannot overflow.
56      */
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         require(c >= a, "SafeMath: addition overflow");
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the subtraction of two unsigned integers, reverting on
66      * overflow (when the result is negative).
67      *
68      * Counterpart to Solidity's `-` operator.
69      *
70      * Requirements:
71      * - Subtraction cannot overflow.
72      */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         return sub(a, b, "SafeMath: subtraction overflow");
75     }
76 
77     /**
78      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
79      * overflow (when the result is negative).
80      *
81      * Counterpart to Solidity's `-` operator.
82      *
83      * Requirements:
84      * - Subtraction cannot overflow.
85      *
86      * _Available since v2.4.0._
87      */
88     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         require(b <= a, errorMessage);
90         uint256 c = a - b;
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the multiplication of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `*` operator.
100      *
101      * Requirements:
102      * - Multiplication cannot overflow.
103      */
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
106         // benefit is lost if 'b' is also tested.
107         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
108         if (a == 0) {
109             return 0;
110         }
111 
112         uint256 c = a * b;
113         require(c / a == b, "SafeMath: multiplication overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the integer division of two unsigned integers. Reverts on
120      * division by zero. The result is rounded towards zero.
121      *
122      * Counterpart to Solidity's `/` operator. Note: this function uses a
123      * `revert` opcode (which leaves remaining gas untouched) while Solidity
124      * uses an invalid opcode to revert (consuming all remaining gas).
125      *
126      * Requirements:
127      * - The divisor cannot be zero.
128      */
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         return div(a, b, "SafeMath: division by zero");
131     }
132 
133     /**
134      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
135      * division by zero. The result is rounded towards zero.
136      *
137      * Counterpart to Solidity's `/` operator. Note: this function uses a
138      * `revert` opcode (which leaves remaining gas untouched) while Solidity
139      * uses an invalid opcode to revert (consuming all remaining gas).
140      *
141      * Requirements:
142      * - The divisor cannot be zero.
143      *
144      * _Available since v2.4.0._
145      */
146     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         // Solidity only automatically asserts when dividing by 0
148         require(b > 0, errorMessage);
149         uint256 c = a / b;
150         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
157      * Reverts when dividing by zero.
158      *
159      * Counterpart to Solidity's `%` operator. This function uses a `revert`
160      * opcode (which leaves remaining gas untouched) while Solidity uses an
161      * invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      * - The divisor cannot be zero.
165      */
166     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
167         return mod(a, b, "SafeMath: modulo by zero");
168     }
169 
170     /**
171      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
172      * Reverts with custom message when dividing by zero.
173      *
174      * Counterpart to Solidity's `%` operator. This function uses a `revert`
175      * opcode (which leaves remaining gas untouched) while Solidity uses an
176      * invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      * - The divisor cannot be zero.
180      *
181      * _Available since v2.4.0._
182      */
183     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
184         require(b != 0, errorMessage);
185         return a % b;
186     }
187 }
188 
189 //TODO add safemath
190 interface IDPR {
191     function transferFrom(address _spender, address _to, uint256 _amount) external returns(bool);
192     function transfer(address _to, uint256 _amount) external returns(bool);
193     function balanceOf(address _owner) external view returns(uint256);
194     function approve(address _spender, uint256 _amount) external returns(bool);
195 }
196 
197 interface ILockingContract {
198     function lock(address _addr, uint256 _amount) external;
199 }
200 
201 contract InstanceClaim {
202     using SafeMath for uint256;
203 
204     bytes32 public root;
205     IDPR public dpr;
206     //system info
207     address public owner;
208     ILockingContract new_locking_contract;
209     mapping(bytes32=>bool) public claimMap;
210     mapping(address=>bool) public userMap;
211     //=====events=======
212     event distribute(address _addr, uint256 _amount);
213     event OwnerTransfer(address _newOwner);
214 
215     //====modifiers====
216     modifier onlyOwner(){
217         require(owner == msg.sender);
218         _;
219     }
220 
221     constructor(address _token) public{
222         dpr = IDPR(_token);
223         owner = msg.sender;
224     }
225 
226     function transferOwnerShip(address _newOwner) onlyOwner external {
227         require(_newOwner != address(0), "MerkleClaim: Wrong owner");
228         owner = _newOwner;
229         emit OwnerTransfer(_newOwner);
230     }
231 
232     function setRoot(bytes32 _root) external onlyOwner{
233         root = _root;
234     }
235 
236     function setClaim(bytes32 node) private {
237         claimMap[node] = true;
238     }
239 
240 
241     function setLockContract(ILockingContract lockContract) external onlyOwner{
242         require(address(lockContract) != address(0), "DPRBridge: Zero address");
243         dpr.approve(address(lockContract), uint256(-1));
244         new_locking_contract = lockContract;
245     }
246     function distributeAndLock(uint256 _amount, bytes32[]  memory proof, bool need_move) public{
247         require(!userMap[msg.sender], "MerkleClaim: Account is already claimed");
248         bytes32 node = keccak256(abi.encodePacked(msg.sender, _amount));
249         require(!claimMap[node], "MerkleClaim: Account is already claimed");
250         require(MerkleProof.verify(proof, root, node), "MerkleClaim: Verify failed");
251         //update status
252         setClaim(node);
253         // uint256 half_amount = _amount.div(2);
254         // choose the choice
255         if(need_move){
256             new_locking_contract.lock(msg.sender, _amount);
257         }else{
258             dpr.transfer(msg.sender, _amount);
259         }
260         //lockTokens(_addr, _amount.sub(half_amount));
261         userMap[msg.sender] = true;
262         emit distribute(msg.sender, _amount);
263     }
264 
265     function withdraw(address _to) external onlyOwner{
266         require(dpr.transfer(_to, dpr.balanceOf(address(this))), "MerkleClaim: Transfer Failed");
267     }
268 
269     function pullTokens(uint256 _amount) external{
270         require(dpr.transferFrom(msg.sender, address(this), _amount), "MerkleClaim: TransferFrom failed");
271     }
272 }