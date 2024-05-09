1 /* solium-disable security/no-block-members */
2 
3 pragma solidity ^0.4.23;
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11     function totalSupply() public view returns (uint256);
12     function balanceOf(address who) public view returns (uint256);
13     function transfer(address to, uint256 value) public returns (bool);
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22     function allowance(address owner, address spender)
23         public view returns (uint256);
24 
25     function transferFrom(address from, address to, uint256 value)
26         public returns (bool);
27 
28     function approve(address spender, uint256 value) public returns (bool);
29     event Approval(
30             address indexed owner,
31             address indexed spender,
32             uint256 value
33             );
34 }
35 
36 
37 /**
38  * @title SafeERC20
39  * @dev Wrappers around ERC20 operations that throw on failure.
40  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
41  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
42  */
43 library SafeERC20 {
44     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
45         require(token.transfer(to, value));
46     }
47 
48     function safeTransferFrom(
49             ERC20 token,
50             address from,
51             address to,
52             uint256 value
53             )
54         internal
55         {
56             require(token.transferFrom(from, to, value));
57         }
58 
59     function safeApprove(ERC20 token, address spender, uint256 value) internal {
60         require(token.approve(spender, value));
61     }
62 }
63 
64 
65 /**
66  * @title Ownable
67  * @dev The Ownable contract has an owner address, and provides basic authorization control
68  * functions, this simplifies the implementation of "user permissions".
69  */
70 contract Ownable {
71     address public owner;
72 
73 
74     event OwnershipRenounced(address indexed previousOwner);
75     event OwnershipTransferred(
76             address indexed previousOwner,
77             address indexed newOwner
78             );
79 
80 
81     /**
82      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83      * account.
84      */
85     constructor() public {
86         owner = msg.sender;
87     }
88 
89     /**
90      * @dev Throws if called by any account other than the owner.
91      */
92     modifier onlyOwner() {
93         require(msg.sender == owner);
94         _;
95     }
96 
97     /**
98      * @dev Allows the current owner to transfer control of the contract to a newOwner.
99      * @param newOwner The address to transfer ownership to.
100      */
101     function transferOwnership(address newOwner) public onlyOwner {
102         require(newOwner != address(0));
103         emit OwnershipTransferred(owner, newOwner);
104         owner = newOwner;
105     }
106 
107     /**
108      * @dev Allows the current owner to relinquish control of the contract.
109      */
110     // function renounceOwnership() public onlyOwner {
111     //   emit OwnershipRenounced(owner);
112     //   owner = address(0);
113     // }
114 }
115 
116 
117 /**
118  * @title SafeMath
119  * @dev Math operations with safety checks that throw on error
120  */
121 library SafeMath {
122 
123     /**
124      * @dev Multiplies two numbers, throws on overflow.
125      */
126     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
127         if (a == 0) {
128             return 0;
129         }
130         c = a * b;
131         assert(c / a == b);
132         return c;
133     }
134 
135     /**
136      * @dev Integer division of two numbers, truncating the quotient.
137      */
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         // assert(b > 0); // Solidity automatically throws when dividing by 0
140         // uint256 c = a / b;
141         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
142         return a / b;
143     }
144 
145     /**
146      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
147      */
148     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149         assert(b <= a);
150         return a - b;
151     }
152 
153     /**
154      * @dev Adds two numbers, throws on overflow.
155      */
156     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
157         c = a + b;
158         assert(c >= a);
159         return c;
160     }
161 }
162 
163 
164 
165 /**
166  * @title TokenVesting
167  * @dev A token holder contract that can release its token balance gradually like a
168  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
169  * owner.
170  */
171 contract TokenVesting is Ownable {
172     using SafeMath for uint256;
173     using SafeERC20 for ERC20Basic;
174 
175     event Released(uint256 amount);
176     event Revoked();
177 
178     // beneficiary of tokens after they are released
179     //一下写死的数据会在上线的时候，根据实际情况替换
180     address public beneficiary;    //最终受益人地址
181     uint256 public cliff;                                          //第一次收益时间
182     uint256 public start;                                          //合约开始时间
183     uint256 public duration;                                       //最后一次收益时间
184     bool public revocable;                                               //是否可以召回
185 
186     mapping (address => uint256) public released;
187     mapping (address => bool) public revoked;
188 
189     /**
190      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
191      * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
192      * of the balance will have vested.
193      * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
194      * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
195      * @param _duration duration in seconds of the period in which the tokens will vest
196      * @param _revocable whether the vesting is revocable or not
197      */
198     constructor(
199             address _beneficiary,
200             uint256 _start,
201             uint256 _cliff,
202             uint256 _duration,
203             bool _revocable
204             )
205         public
206         {
207             require(_beneficiary != address(0));
208             require(_cliff <= _duration);
209 
210             beneficiary = _beneficiary;
211             revocable = _revocable;
212             duration = _duration;
213             cliff = _start.add(_cliff);
214             start = _start;
215         }
216 
217     /**
218      * @notice Transfers vested tokens to beneficiary.
219      * @param token ERC20 token which is being vested
220      */
221     function release(ERC20Basic token) public {
222         uint256 unreleased = releasableAmount(token);
223 
224         require(unreleased > 0);
225 
226         released[token] = released[token].add(unreleased);
227 
228         token.safeTransfer(beneficiary, unreleased);
229 
230         emit Released(unreleased);
231     }
232 
233     /**
234      * @notice Allows the owner to revoke the vesting. Tokens already vested
235      * remain in the contract, the rest are returned to the owner.
236      * @param token ERC20 token which is being vested
237      */
238     function revoke(ERC20Basic token) public onlyOwner {
239         require(revocable);
240         require(!revoked[token]);
241 
242         uint256 balance = token.balanceOf(this);
243 
244         uint256 unreleased = releasableAmount(token);
245         uint256 refund = balance.sub(unreleased);
246 
247         revoked[token] = true;
248 
249         token.safeTransfer(owner, refund);
250 
251         emit Revoked();
252     }
253 
254     /**
255      * @dev Calculates the amount that has already vested but hasn't been released yet.
256      * @param token ERC20 token which is being vested
257      */
258     function releasableAmount(ERC20Basic token) public view returns (uint256) {
259         return vestedAmount(token).sub(released[token]);
260     }
261 
262     /**
263      * @dev Calculates the amount that has already vested.
264      * @param token ERC20 token which is being vested
265      */
266     function vestedAmount(ERC20Basic token) public view returns (uint256) {
267         uint256 currentBalance = token.balanceOf(this);
268         uint256 totalBalance = currentBalance.add(released[token]);
269 
270         if (block.timestamp < cliff) {
271             return 0;
272         } else if (block.timestamp >= start.add(duration) || revoked[token]) {
273             return totalBalance;
274         } else {
275             return totalBalance.mul(block.timestamp.sub(start)).div(duration);
276         }
277     }
278 }