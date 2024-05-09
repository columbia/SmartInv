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
194 }
195 
196 contract MerkleClaim {
197     using SafeMath for uint256;
198 
199     bytes32 public root;
200     IDPR public dpr;
201     //system info
202     address public owner;
203     uint256 public total_release_periods = 276;
204     uint256 public start_time = 1620604800; //2021 年 05 月 10 日 08:00
205     // uer info 
206     mapping(address=>uint256) public total_lock_amount;
207     mapping(address=>uint256) public release_per_period;
208     mapping(address=>uint256) public user_released;
209     mapping(bytes32=>bool) public claimMap;
210     mapping(address=>bool) public userMap;
211     //=====events=======
212     event claim(address _addr, uint256 _amount);
213     event distribute(address _addr, uint256 _amount);
214     event OwnerTransfer(address _newOwner);
215 
216     //====modifiers====
217     modifier onlyOwner(){
218         require(owner == msg.sender);
219         _;
220     }
221 
222     constructor(bytes32 _root, address _token) public{
223         root = _root;
224         dpr = IDPR(_token);
225         owner = msg.sender;
226     }
227 
228     function transferOwnerShip(address _newOwner) onlyOwner external {
229         require(_newOwner != address(0), "MerkleClaim: Wrong owner");
230         owner = _newOwner;
231         emit OwnerTransfer(_newOwner);
232     }
233 
234     function setClaim(bytes32 node) private {
235         claimMap[node] = true;
236     }
237 
238     function distributeAndLock(address _addr, uint256 _amount, bytes32[]  memory proof) public{
239         require(!userMap[_addr], "MerkleClaim: Account is already claimed");
240         bytes32 node = keccak256(abi.encodePacked(_addr, _amount));
241         require(!claimMap[node], "MerkleClaim: Account is already claimed");
242         require(MerkleProof.verify(proof, root, node), "MerkleClaim: Verify failed");
243         //update status
244         setClaim(node);
245         lockTokens(_addr, _amount);
246         userMap[_addr] = true;
247         emit distribute(_addr, _amount);
248     }
249 
250     function lockTokens(address _addr, uint256 _amount) private{
251         total_lock_amount[_addr] = _amount;
252         release_per_period[_addr] = _amount.div(total_release_periods);
253     }
254 
255     function claimTokens() external {
256         require(total_lock_amount[msg.sender] != 0, "User does not have lock record");
257         require(total_lock_amount[msg.sender].sub(user_released[msg.sender]) > 0, "all token has been claimed");
258         uint256 periods = block.timestamp.sub(start_time).div(1 days);
259         uint256 total_release_amount = release_per_period[msg.sender].mul(periods);
260         
261         if(total_release_amount >= total_lock_amount[msg.sender]){
262             total_release_amount = total_lock_amount[msg.sender];
263         }
264 
265         uint256 release_amount = total_release_amount.sub(user_released[msg.sender]);
266         // update user info
267         user_released[msg.sender] = total_release_amount;
268         require(dpr.balanceOf(address(this)) >= release_amount, "MerkleClaim: Balance not enough");
269         require(dpr.transfer(msg.sender, release_amount), "MerkleClaim: Transfer Failed");    
270         emit claim(msg.sender, release_amount);
271     }
272 
273     function unreleased() external view returns(uint256){
274         return total_lock_amount[msg.sender].sub(user_released[msg.sender]);
275     }
276 
277     function withdraw(address _to) external onlyOwner{
278         require(dpr.transfer(_to, dpr.balanceOf(address(this))), "MerkleClaim: Transfer Failed");
279     }
280 
281     function pullTokens(uint256 _amount) external onlyOwner{
282         require(dpr.transferFrom(owner, address(this), _amount), "MerkleClaim: TransferFrom failed");
283     }
284 }