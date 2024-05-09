1 pragma solidity 0.6.9;
2 
3 /**
4  * @title Ownable
5  *
6  * @notice Ownership related functions
7  */
8 contract Ownable {
9     address public _OWNER_;
10     address public _NEW_OWNER_;
11 
12     // ============ Events ============
13 
14     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
15 
16     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18     // ============ Modifiers ============
19 
20     modifier onlyOwner() {
21         require(msg.sender == _OWNER_, "NOT_OWNER");
22         _;
23     }
24 
25     // ============ Functions ============
26 
27     constructor() internal {
28         _OWNER_ = msg.sender;
29         emit OwnershipTransferred(address(0), _OWNER_);
30     }
31 
32     function transferOwnership(address newOwner) external onlyOwner {
33         require(newOwner != address(0), "INVALID_OWNER");
34         emit OwnershipTransferPrepared(_OWNER_, newOwner);
35         _NEW_OWNER_ = newOwner;
36     }
37 
38     function claimOwnership() external {
39         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
40         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
41         _OWNER_ = _NEW_OWNER_;
42         _NEW_OWNER_ = address(0);
43     }
44 }
45 
46 /**
47  * @title SafeMath
48  *
49  * @notice Math operations with safety checks that revert on error
50  */
51 library SafeMath {
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) {
54             return 0;
55         }
56 
57         uint256 c = a * b;
58         require(c / a == b, "MUL_ERROR");
59 
60         return c;
61     }
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b > 0, "DIVIDING_ERROR");
65         return a / b;
66     }
67 
68     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 quotient = div(a, b);
70         uint256 remainder = a - quotient * b;
71         if (remainder > 0) {
72             return quotient + 1;
73         } else {
74             return quotient;
75         }
76     }
77 
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         require(b <= a, "SUB_ERROR");
80         return a - b;
81     }
82 
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a + b;
85         require(c >= a, "ADD_ERROR");
86         return c;
87     }
88 
89     function sqrt(uint256 x) internal pure returns (uint256 y) {
90         uint256 z = x / 2 + 1;
91         y = x;
92         while (z < y) {
93             y = z;
94             z = (x / z + z) / 2;
95         }
96     }
97 }
98 
99 interface IERC20 {
100     /**
101      * @dev Returns the amount of tokens in existence.
102      */
103     function totalSupply() external view returns (uint256);
104 
105     function decimals() external view returns (uint8);
106 
107     function name() external view returns (string memory);
108 
109     /**
110      * @dev Returns the amount of tokens owned by `account`.
111      */
112     function balanceOf(address account) external view returns (uint256);
113 
114     /**
115      * @dev Moves `amount` tokens from the caller's account to `recipient`.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transfer(address recipient, uint256 amount) external returns (bool);
122 
123     /**
124      * @dev Returns the remaining number of tokens that `spender` will be
125      * allowed to spend on behalf of `owner` through {transferFrom}. This is
126      * zero by default.
127      *
128      * This value changes when {approve} or {transferFrom} are called.
129      */
130     function allowance(address owner, address spender) external view returns (uint256);
131 
132     /**
133      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * IMPORTANT: Beware that changing an allowance with this method brings the risk
138      * that someone may use both the old and the new allowance by unfortunate
139      * transaction ordering. One possible solution to mitigate this race
140      * condition is to first reduce the spender's allowance to 0 and set the
141      * desired value afterwards:
142      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143      *
144      * Emits an {Approval} event.
145      */
146     function approve(address spender, uint256 amount) external returns (bool);
147 
148     /**
149      * @dev Moves `amount` tokens from `sender` to `recipient` using the
150      * allowance mechanism. `amount` is then deducted from the caller's
151      * allowance.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * Emits a {Transfer} event.
156      */
157     function transferFrom(
158         address sender,
159         address recipient,
160         uint256 amount
161     ) external returns (bool);
162 }
163 
164 /**
165 * code by tt
166 * evm version must after baizhanting
167 */
168 contract InvitePool is Ownable {
169 
170     using SafeMath for uint256;
171 
172     //user 用户、superior 上级
173     event Bind(address indexed user, address indexed superior);
174 
175     uint256  public BASE = 10000;
176     uint256 public firstPercent = 500;
177     uint256 public secondPercent = 500;
178 
179     constructor() public {
180         _OWNER_ = msg.sender;
181         god[0x2Be4dF32CB716Cc3BFb066e26B6590A014a02875] = true;
182         emit OwnershipTransferred(address(0), _OWNER_);
183     }
184 
185     struct User {
186         address superUser; //上级
187         address[] levelOne; //直推下级
188     }
189 
190     mapping(address => User) public userInfo;
191     mapping(address => bool) god;
192 
193     /**
194     *关系绑定由用户直接调用直接调用
195     */
196     //绑定关系
197     function bind(address _superUser) public {
198         require(msg.sender != address(0) || _superUser != address(0), "0x0 not allowed");
199 
200         //为了可以给测试事件抛出方便，允许重复绑定
201         require(userInfo[msg.sender].superUser == address(0), "already bind");
202         require(msg.sender != _superUser, "do not bind yourself");
203 
204         //上级邀请人必须已绑定上级（创世地址除外）
205         if (!god[_superUser]) {
206             require(userInfo[_superUser].superUser != address(0), "invalid inviter");
207         }
208 
209         userInfo[msg.sender].superUser = _superUser;
210         if (_superUser != address(this)) {
211             userInfo[_superUser].levelOne.push(msg.sender);
212         }
213 
214         emit Bind(msg.sender, _superUser);
215     }
216 
217     //获取用户信息
218     function getUserInfo(address userAddr) public view returns (address superOne, uint256 first){
219         return (userInfo[userAddr].superUser, userInfo[userAddr].levelOne.length);
220     }
221 
222     //获取直推和间推关系
223     function getInvited(address _user) public view returns (address[] memory){
224         address[] memory one = userInfo[_user].levelOne;
225         return one;
226     }
227 
228     function compareStr(string memory _str, string memory str) public pure returns (bool) {
229         if (keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str))) {
230             return true;
231         }
232         return false;
233     }
234 
235     //设置创世地址
236     function setGOD(address addr, bool on) public onlyOwner {
237         god[addr] = on;
238     }
239 }