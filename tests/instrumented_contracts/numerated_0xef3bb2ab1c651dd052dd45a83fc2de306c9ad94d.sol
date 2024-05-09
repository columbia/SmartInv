1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: IRole
8 
9 interface IRole {
10     function getRoleMemberCount(bytes32 role) external view returns (uint256);
11     function hasRole(bytes32 role, address account) external view returns (bool);
12 }
13 
14 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/Context
15 
16 /*
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with GSN meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address payable) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes memory) {
32         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33         return msg.data;
34     }
35 }
36 
37 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/SafeMath
38 
39 /**
40  * @dev Wrappers over Solidity's arithmetic operations with added overflow
41  * checks.
42  *
43  * Arithmetic operations in Solidity wrap on overflow. This can easily result
44  * in bugs, because programmers usually assume that an overflow raises an
45  * error, which is the standard behavior in high level programming languages.
46  * `SafeMath` restores this intuition by reverting the transaction when an
47  * operation overflows.
48  *
49  * Using this library instead of the unchecked operations eliminates an entire
50  * class of bugs, so it's recommended to use it always.
51  */
52 library SafeMath {
53     /**
54      * @dev Returns the addition of two unsigned integers, reverting on
55      * overflow.
56      *
57      * Counterpart to Solidity's `+` operator.
58      *
59      * Requirements:
60      *
61      * - Addition cannot overflow.
62      */
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         require(c >= a, "SafeMath: addition overflow");
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the subtraction of two unsigned integers, reverting on
72      * overflow (when the result is negative).
73      *
74      * Counterpart to Solidity's `-` operator.
75      *
76      * Requirements:
77      *
78      * - Subtraction cannot overflow.
79      */
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         return sub(a, b, "SafeMath: subtraction overflow");
82     }
83 
84     /**
85      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
86      * overflow (when the result is negative).
87      *
88      * Counterpart to Solidity's `-` operator.
89      *
90      * Requirements:
91      *
92      * - Subtraction cannot overflow.
93      */
94     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
95         require(b <= a, errorMessage);
96         uint256 c = a - b;
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the multiplication of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `*` operator.
106      *
107      * Requirements:
108      *
109      * - Multiplication cannot overflow.
110      */
111     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
113         // benefit is lost if 'b' is also tested.
114         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
115         if (a == 0) {
116             return 0;
117         }
118 
119         uint256 c = a * b;
120         require(c / a == b, "SafeMath: multiplication overflow");
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers. Reverts on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return div(a, b, "SafeMath: division by zero");
139     }
140 
141     /**
142      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
143      * division by zero. The result is rounded towards zero.
144      *
145      * Counterpart to Solidity's `/` operator. Note: this function uses a
146      * `revert` opcode (which leaves remaining gas untouched) while Solidity
147      * uses an invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b > 0, errorMessage);
155         uint256 c = a / b;
156         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
163      * Reverts when dividing by zero.
164      *
165      * Counterpart to Solidity's `%` operator. This function uses a `revert`
166      * opcode (which leaves remaining gas untouched) while Solidity uses an
167      * invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      *
171      * - The divisor cannot be zero.
172      */
173     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
174         return mod(a, b, "SafeMath: modulo by zero");
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * Reverts with custom message when dividing by zero.
180      *
181      * Counterpart to Solidity's `%` operator. This function uses a `revert`
182      * opcode (which leaves remaining gas untouched) while Solidity uses an
183      * invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         require(b != 0, errorMessage);
191         return a % b;
192     }
193 }
194 
195 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/Ownable
196 
197 /**
198  * @dev Contract module which provides a basic access control mechanism, where
199  * there is an account (an owner) that can be granted exclusive access to
200  * specific functions.
201  *
202  * By default, the owner account will be the one that deploys the contract. This
203  * can later be changed with {transferOwnership}.
204  *
205  * This module is used through inheritance. It will make available the modifier
206  * `onlyOwner`, which can be applied to your functions to restrict their use to
207  * the owner.
208  */
209 abstract contract Ownable is Context {
210     address private _owner;
211 
212     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
213 
214     /**
215      * @dev Initializes the contract setting the deployer as the initial owner.
216      */
217     constructor () internal {
218         address msgSender = _msgSender();
219         _owner = msgSender;
220         emit OwnershipTransferred(address(0), msgSender);
221     }
222 
223     /**
224      * @dev Returns the address of the current owner.
225      */
226     function owner() public view returns (address) {
227         return _owner;
228     }
229 
230     /**
231      * @dev Throws if called by any account other than the owner.
232      */
233     modifier onlyOwner() {
234         require(_owner == _msgSender(), "Ownable: caller is not the owner");
235         _;
236     }
237 
238     /**
239      * @dev Leaves the contract without owner. It will not be possible to call
240      * `onlyOwner` functions anymore. Can only be called by the current owner.
241      *
242      * NOTE: Renouncing ownership will leave the contract without an owner,
243      * thereby removing any functionality that is only available to the owner.
244      */
245     function renounceOwnership() public virtual onlyOwner {
246         emit OwnershipTransferred(_owner, address(0));
247         _owner = address(0);
248     }
249 
250     /**
251      * @dev Transfers ownership of the contract to a new account (`newOwner`).
252      * Can only be called by the current owner.
253      */
254     function transferOwnership(address newOwner) public virtual onlyOwner {
255         require(newOwner != address(0), "Ownable: new owner is the zero address");
256         emit OwnershipTransferred(_owner, newOwner);
257         _owner = newOwner;
258     }
259 }
260 
261 // File: BurnProposal.sol
262 
263 contract BurnProposal is Ownable{
264 
265     using SafeMath for uint;
266 
267     struct Proposal {
268         string ethHash;
269         string btcHash;
270         uint256 voteCount;
271         bool finished;
272         bool isExist;
273         mapping(address=>bool) voteState;
274     }
275 
276     mapping(string => Proposal) public proposals;
277     IRole public trustee;
278     uint256 public diff=1;
279 
280     constructor(address _boringdao) public {
281         trustee = IRole(_boringdao);
282     }
283 
284     function setTrustee(address _trustee) public onlyOwner{
285         trustee = IRole(_trustee);
286     }
287 
288     function setDiff(uint256 _diff) public onlyOwner {
289         diff = _diff;
290     }
291 
292     function approve(string memory ethHash, string memory btcHash, bytes32 _tunnelKey) public onlyTrustee(_tunnelKey) {
293         string memory key = string(abi.encodePacked(ethHash, btcHash, _tunnelKey));
294         if (proposals[key].isExist == false) {
295             Proposal memory p = Proposal({
296                 ethHash: ethHash,
297                 btcHash: btcHash,
298                 voteCount: 1,
299                 finished: false,
300                 isExist: true
301             });
302             proposals[key] = p;
303             proposals[key].voteState[msg.sender] = true;
304             emit VoteBurnProposal(_tunnelKey, ethHash, btcHash, msg.sender, p.voteCount);
305         } else {
306             Proposal storage p = proposals[key];
307             if(p.voteState[msg.sender] == true) {
308                 return;
309             }
310             if(p.finished) {
311                 return;
312             }
313             p.voteCount = p.voteCount.add(1);
314             p.voteState[msg.sender] = true;
315             emit VoteBurnProposal(_tunnelKey, ethHash, btcHash, msg.sender, p.voteCount);
316         }
317         Proposal storage p = proposals[key];
318         uint trusteeCount = getTrusteeCount(_tunnelKey);
319         uint threshold = trusteeCount.mod(3) == 0 ? trusteeCount.mul(2).div(3) : trusteeCount.mul(2).div(3).add(diff);
320         if (p.voteCount >= threshold) {
321             p.finished = true;
322             emit BurnProposalSuccess(_tunnelKey, ethHash, btcHash);
323         }
324     }
325 
326     function getTrusteeCount(bytes32 _tunnelKey) internal view returns(uint){
327         return trustee.getRoleMemberCount(_tunnelKey);
328     }
329 
330 
331     modifier onlyTrustee(bytes32 _tunnelKey) {
332         require(trustee.hasRole(_tunnelKey, msg.sender), "Caller is not trustee");
333         _;
334     }
335 
336     event BurnProposalSuccess(
337         bytes32 _tunnelKey,
338         string ethHash,
339         string btcHash
340     );
341 
342     event VoteBurnProposal(
343         bytes32 _tunnelKey,
344         string ethHash,
345         string btcHash,
346         address voter,
347         uint256 voteCount
348     );
349 }
