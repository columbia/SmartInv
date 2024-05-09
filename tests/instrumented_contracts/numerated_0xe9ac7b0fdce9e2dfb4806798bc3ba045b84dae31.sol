1 pragma solidity ^0.4.18;
2 
3 // File: contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     emit OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: contracts/token/ERC20.sol
97 
98 /**
99  * @title ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/20
101  */
102 contract ERC20 is ERC20Basic {
103   function allowance(address owner, address spender) public view returns (uint256);
104   function transferFrom(address from, address to, uint256 value) public returns (bool);
105   function approve(address spender, uint256 value) public returns (bool);
106   event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 // File: contracts/token/SafeERC20.sol
110 
111 /**
112  * @title SafeERC20
113  * @dev Wrappers around ERC20 operations that throw on failure.
114  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
115  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
116  */
117 library SafeERC20 {
118   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
119     assert(token.transfer(to, value));
120   }
121 
122   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
123     assert(token.transferFrom(from, to, value));
124   }
125 
126   function safeApprove(ERC20 token, address spender, uint256 value) internal {
127     assert(token.approve(spender, value));
128   }
129 }
130 
131 // File: contracts/token/TokenVesting.sol
132 
133 /* solium-disable security/no-block-members */
134 
135 pragma solidity ^0.4.21;
136 
137 
138 
139 
140 
141 
142 
143 
144 /**
145  * @title TokenVesting
146  * @dev A token holder contract that can release its token balance gradually like a
147  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
148  * owner.
149  */
150 contract TokenVesting is Ownable {
151     using SafeMath for uint256;
152     using SafeERC20 for ERC20Basic;
153 
154     event Released(uint256 amount);
155 
156     event Revoked();
157 
158     // beneficiary of tokens after they are released
159     address public beneficiary;
160 
161     uint256 public cliff;
162 
163     uint256 public start;
164 
165     uint256 public duration;
166 
167     bool public revocable;
168 
169     mapping (address => uint256) public released;
170 
171     mapping (address => bool) public revoked;
172 
173     /**
174      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
175      * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
176      * of the balance will have vested.
177      * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
178      * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
179      * @param _duration duration in seconds of the period in which the tokens will vest
180      * @param _revocable whether the vesting is revocable or not
181      */
182     function TokenVesting(
183     address _beneficiary,
184     uint256 _start,
185     uint256 _cliff,
186     uint256 _duration,
187     bool _revocable
188     )
189     public
190     {
191         require(_beneficiary != address(0));
192         require(_cliff <= _duration);
193 
194         beneficiary = _beneficiary;
195         revocable = _revocable;
196         duration = _duration;
197         cliff = _start.add(_cliff);
198         start = _start;
199     }
200 
201     /**
202      * @notice Transfers vested tokens to beneficiary.
203      * @param token ERC20 token which is being vested
204      */
205     function release(ERC20Basic token) public {
206         uint256 unreleased = releasableAmount(token);
207         require(unreleased > 0);
208         released[token] = released[token].add(unreleased);
209         token.safeTransfer(beneficiary, unreleased);
210 
211         emit Released(unreleased);
212     }
213 
214     /**
215      * @notice Allows the owner to revoke the vesting. Tokens already vested
216      * remain in the contract, the rest are returned to the owner.
217      * @param token ERC20 token which is being vested
218      */
219     function revoke(ERC20Basic token) public onlyOwner {
220         require(revocable);
221         require(!revoked[token]);
222 
223         uint256 balance = token.balanceOf(this);
224 
225         uint256 unreleased = releasableAmount(token);
226         uint256 refund = balance.sub(unreleased);
227 
228         revoked[token] = true;
229 
230         token.safeTransfer(owner, refund);
231 
232         emit Revoked();
233     }
234 
235     /**
236      * @dev Calculates the amount that has already vested but hasn't been released yet.
237      * @param token ERC20 token which is being vested
238      */
239     function releasableAmount(ERC20Basic token) public view returns (uint256) {
240         return vestedAmount(token).sub(released[token]);
241     }
242 
243     /**
244      * @dev Calculates the amount that has already vested.
245      * @param token ERC20 token which is being vested
246      */
247     function vestedAmount(ERC20Basic token) public view returns (uint256) {
248         uint256 currentBalance = token.balanceOf(this);
249         uint256 totalBalance = currentBalance.add(released[token]);
250 
251         if (block.timestamp < cliff) {
252             return 0;
253         }
254         else if (block.timestamp >= start.add(duration) || revoked[token]) {
255             return totalBalance;
256         }
257         else {
258             return totalBalance.mul(block.timestamp.sub(start)).div(duration);
259         }
260     }
261 }