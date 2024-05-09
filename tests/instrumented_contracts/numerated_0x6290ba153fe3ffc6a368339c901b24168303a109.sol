1 pragma solidity 0.4.24;
2 
3 // File: contracts/commons/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, reverts on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         uint256 c = a * b;
23         require(c / a == b);
24 
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b > 0); // Solidity only automatically asserts when dividing by 0
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two numbers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: contracts/flavours/Ownable.sol
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions". It has two-stage ownership transfer.
75  */
76 contract Ownable {
77 
78     address public owner;
79     address public pendingOwner;
80 
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     /**
84      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85      * account.
86      */
87     constructor() public {
88         owner = msg.sender;
89     }
90 
91     /**
92      * @dev Throws if called by any account other than the owner.
93      */
94     modifier onlyOwner() {
95         require(msg.sender == owner);
96         _;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyPendingOwner() {
103         require(msg.sender == pendingOwner);
104         _;
105     }
106 
107     /**
108      * @dev Allows the current owner to prepare transfer control of the contract to a newOwner.
109      * @param newOwner The address to transfer ownership to.
110      */
111     function transferOwnership(address newOwner) public onlyOwner {
112         require(newOwner != address(0));
113         pendingOwner = newOwner;
114     }
115 
116     /**
117      * @dev Allows the pendingOwner address to finalize the transfer.
118      */
119     function claimOwnership() public onlyPendingOwner {
120         emit OwnershipTransferred(owner, pendingOwner);
121         owner = pendingOwner;
122         pendingOwner = address(0);
123     }
124 }
125 
126 // File: contracts/flavours/Lockable.sol
127 
128 /**
129  * @title Lockable
130  * @dev Base contract which allows children to
131  *      implement main operations locking mechanism.
132  */
133 contract Lockable is Ownable {
134     event Lock();
135     event Unlock();
136 
137     bool public locked = false;
138 
139     /**
140      * @dev Modifier to make a function callable
141     *       only when the contract is not locked.
142      */
143     modifier whenNotLocked() {
144         require(!locked);
145         _;
146     }
147 
148     /**
149      * @dev Modifier to make a function callable
150      *      only when the contract is locked.
151      */
152     modifier whenLocked() {
153         require(locked);
154         _;
155     }
156 
157     /**
158      * @dev called by the owner to locke, triggers locked state
159      */
160     function lock() public onlyOwner whenNotLocked {
161         locked = true;
162         emit Lock();
163     }
164 
165     /**
166      * @dev called by the owner
167      *      to unlock, returns to unlocked state
168      */
169     function unlock() public onlyOwner whenLocked {
170         locked = false;
171         emit Unlock();
172     }
173 }
174 
175 // File: contracts/interface/SNPCToken.sol
176 
177 interface SNPCToken {
178     function owner() external returns (address);
179     function pendingOwner() external returns (address);
180     function transferFrom(address from_, address to_, uint value_) external returns (bool);
181     function transfer(address to_, uint value_) external returns (bool);
182     function balanceOf(address owner_) external returns (uint);
183     function transferOwnership(address newOwner) external;
184     function claimOwnership() external;
185     function assignReserved(address to_, uint8 group_, uint amount_) external;
186 }
187 
188 // File: contracts/base/BaseAirdrop.sol
189 
190 contract BaseAirdrop is Lockable {
191     using SafeMath for uint;
192 
193     SNPCToken public token;
194 
195     mapping(address => bool) public users;
196 
197     event AirdropToken(address indexed to, uint amount);
198 
199     constructor(address _token) public {
200         require(_token != address(0));
201         token = SNPCToken(_token);
202     }
203 
204     function airdrop(uint8 v, bytes32 r, bytes32 s, uint amount) public;
205 
206     function getAirdropStatus(address user) public constant returns (bool success) {
207         return users[user];
208     }
209 
210     function originalHash(uint amount) internal view returns (bytes32) {
211         return keccak256(abi.encodePacked(
212                 "Signed for Airdrop",
213                 address(this),
214                 address(token),
215                 msg.sender,
216                 amount
217             ));
218     }
219 
220     function prefixedHash(uint amount) internal view returns (bytes32) {
221         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
222         return keccak256(abi.encodePacked(prefix, originalHash(amount)));
223     }
224 }
225 
226 // File: contracts/interface/ERC20Token.sol
227 
228 interface ERC20Token {
229     function transferFrom(address from_, address to_, uint value_) external returns (bool);
230     function transfer(address to_, uint value_) external returns (bool);
231     function balanceOf(address owner_) external returns (uint);
232 }
233 
234 // File: contracts/flavours/Withdrawal.sol
235 
236 /**
237  * @title Withdrawal
238  * @dev The Withdrawal contract has an owner address, and provides method for withdraw funds and tokens, if any
239  */
240 contract Withdrawal is Ownable {
241 
242     // withdraw funds, if any, only for owner
243     function withdraw() public onlyOwner {
244         owner.transfer(address(this).balance);
245     }
246 
247     // withdraw stuck tokens, if any, only for owner
248     function withdrawTokens(address _someToken) public onlyOwner {
249         ERC20Token someToken = ERC20Token(_someToken);
250         uint balance = someToken.balanceOf(address(this));
251         someToken.transfer(owner, balance);
252     }
253 }
254 
255 // File: contracts/flavours/SelfDestructible.sol
256 
257 /**
258  * @title SelfDestructible
259  * @dev The SelfDestructible contract has an owner address, and provides selfDestruct method
260  * in case of deployment error.
261  */
262 contract SelfDestructible is Ownable {
263 
264     function selfDestruct(uint8 v, bytes32 r, bytes32 s) public onlyOwner {
265         if (ecrecover(prefixedHash(), v, r, s) != owner) {
266             revert();
267         }
268         selfdestruct(owner);
269     }
270 
271     function originalHash() internal view returns (bytes32) {
272         return keccak256(abi.encodePacked(
273                 "Signed for Selfdestruct",
274                 address(this),
275                 msg.sender
276             ));
277     }
278 
279     function prefixedHash() internal view returns (bytes32) {
280         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
281         return keccak256(abi.encodePacked(prefix, originalHash()));
282     }
283 }
284 
285 // File: contracts/SNPCAirdrop.sol
286 
287 /**
288  * @title SNPC token airdrop contract.
289  */
290 contract SNPCAirdrop is BaseAirdrop, Withdrawal, SelfDestructible {
291 
292     constructor(address _token) public BaseAirdrop(_token) {
293         locked = true;
294     }
295 
296     function getTokenOwnership() public onlyOwner {
297         require(token.pendingOwner() == address(this));
298         token.claimOwnership();
299         require(token.owner() == address(this));
300     }
301 
302     function releaseTokenOwnership(address newOwner) public onlyOwner {
303         require(newOwner != address(0));
304         token.transferOwnership(newOwner);
305         require(token.pendingOwner() == newOwner);
306     }
307 
308     function airdrop(uint8 v, bytes32 r, bytes32 s, uint amount) public whenNotLocked {
309         if (users[msg.sender] || ecrecover(prefixedHash(amount), v, r, s) != owner) {
310             revert();
311         }
312         users[msg.sender] = true;
313         token.assignReserved(msg.sender, uint8(0x2), amount);
314         emit AirdropToken(msg.sender, amount);
315     }
316 
317     // Disable direct payments
318     function() external payable {
319         revert();
320     }
321 }