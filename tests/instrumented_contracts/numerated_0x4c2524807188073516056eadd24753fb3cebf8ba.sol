1 pragma solidity 0.4.25;
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
175 // File: contracts/interface/ERC20Token.sol
176 
177 interface ERC20Token {
178     function transferFrom(address from_, address to_, uint value_) external returns (bool);
179     function transfer(address to_, uint value_) external returns (bool);
180     function balanceOf(address owner_) external returns (uint);
181 }
182 
183 // File: contracts/base/BaseAirdrop.sol
184 
185 contract BaseAirdrop is Lockable {
186     using SafeMath for uint;
187 
188     ERC20Token public token;
189 
190     address public tokenHolder;
191 
192     mapping(address => bool) public users;
193 
194     event AirdropToken(address indexed to, uint amount);
195 
196     constructor(address _token, address _tokenHolder) public {
197         require(_token != address(0) && _tokenHolder != address(0));
198         token = ERC20Token(_token);
199         tokenHolder = _tokenHolder;
200     }
201 
202     function airdrop(uint8 v, bytes32 r, bytes32 s, uint amount) public whenNotLocked {
203         if (users[msg.sender] || ecrecover(prefixedHash(amount), v, r, s) != owner) {
204             revert();
205         }
206         users[msg.sender] = true;
207         token.transferFrom(tokenHolder, msg.sender, amount);
208         emit AirdropToken(msg.sender, amount);
209     }
210 
211     function getAirdropStatus(address user) public constant returns (bool success) {
212         return users[user];
213     }
214 
215     function originalHash(uint amount) internal view returns (bytes32) {
216         return keccak256(abi.encodePacked(
217                 "Signed for Airdrop",
218                 address(this),
219                 address(token),
220                 msg.sender,
221                 amount
222             ));
223     }
224 
225     function prefixedHash(uint amount) internal view returns (bytes32) {
226         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
227         return keccak256(abi.encodePacked(prefix, originalHash(amount)));
228     }
229 }
230 
231 // File: contracts/flavours/Withdrawal.sol
232 
233 /**
234  * @title Withdrawal
235  * @dev The Withdrawal contract has an owner address, and provides method for withdraw funds and tokens, if any
236  */
237 contract Withdrawal is Ownable {
238 
239     // withdraw funds, if any, only for owner
240     function withdraw() public onlyOwner {
241         owner.transfer(address(this).balance);
242     }
243 
244     // withdraw stuck tokens, if any, only for owner
245     function withdrawTokens(address _someToken) public onlyOwner {
246         ERC20Token someToken = ERC20Token(_someToken);
247         uint balance = someToken.balanceOf(address(this));
248         someToken.transfer(owner, balance);
249     }
250 }
251 
252 // File: contracts/flavours/SelfDestructible.sol
253 
254 /**
255  * @title SelfDestructible
256  * @dev The SelfDestructible contract has an owner address, and provides selfDestruct method
257  * in case of deployment error.
258  */
259 contract SelfDestructible is Ownable {
260 
261     function selfDestruct(uint8 v, bytes32 r, bytes32 s) public onlyOwner {
262         if (ecrecover(prefixedHash(), v, r, s) != owner) {
263             revert();
264         }
265         selfdestruct(owner);
266     }
267 
268     function originalHash() internal view returns (bytes32) {
269         return keccak256(abi.encodePacked(
270                 "Signed for Selfdestruct",
271                 address(this),
272                 msg.sender
273             ));
274     }
275 
276     function prefixedHash() internal view returns (bytes32) {
277         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
278         return keccak256(abi.encodePacked(prefix, originalHash()));
279     }
280 }
281 
282 // File: contracts/ICHXAirdrop.sol
283 
284 /**
285  * @title ICHX token airdrop contract.
286  */
287 contract ICHXAirdrop is BaseAirdrop, Withdrawal, SelfDestructible {
288 
289     constructor(address _token, address _tokenHolder) public BaseAirdrop(_token, _tokenHolder) {
290         locked = true;
291     }
292 
293     // Disable direct payments
294     function() external payable {
295         revert();
296     }
297 }