1 pragma solidity 0.4.24;
2 
3 /**
4  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11      * @dev Multiplies two numbers, throws on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     /**
27      * @dev Integer division of two numbers, truncating the quotient.
28      */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         assert(b > 0);
31         // uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return a / b;
34     }
35 
36     /**
37      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38      */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     /**
45      * @dev Adds two numbers, throws on overflow.
46      */
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 contract Owned {
55     address public owner;
56     address public newOwner;
57 
58     event OwnershipTransferred(address indexed _from, address indexed _to);
59 
60     constructor() public {
61         owner = msg.sender;
62     }
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function transferOwnership(address _newOwner) public onlyOwner {
70         newOwner = _newOwner;
71     }
72 
73     function acceptOwnership() public {
74         require(msg.sender == newOwner);
75         emit OwnershipTransferred(owner, newOwner);
76         owner = newOwner;
77         newOwner = address(0);
78     }
79 }
80 
81 contract ERC20 {
82     uint256 public totalSupply;
83     
84     function balanceOf(address tokenOwner) public view returns (uint256 balance);
85     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
86     function transfer(address to, uint256 tokens) public returns (bool success);
87     function approve(address spender, uint256 tokens) public returns (bool success);
88     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
89 
90     event Transfer(address indexed from, address indexed to, uint256 tokens);
91     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
92 }
93 
94 library SafeERC20 {
95     function safeTransfer(ERC20 token, address to, uint256 value) internal {
96         require(token.transfer(to, value));
97     }
98 
99     function safeTransferFrom(
100         ERC20 token,
101         address from,
102         address to,
103         uint256 value
104     )
105         internal
106     {
107         require(token.transferFrom(from, to, value));
108     }
109 
110     function safeApprove(ERC20 token, address spender, uint256 value) internal {
111         require(token.approve(spender, value));
112     }
113 }
114 
115 contract TokenVesting is Owned {
116     using SafeMath for uint256;
117     using SafeERC20 for ERC20;
118 
119     event Released(uint256 amount);
120     event Revoked();
121 
122     // beneficiary of tokens after they are released
123     address public beneficiary;
124 
125     uint256 public cliff;
126     uint256 public start;
127     uint256 public duration;
128 
129     bool public revocable;
130 
131     mapping (address => uint256) public released;
132     mapping (address => bool) public revoked;
133 
134     /**
135      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
136      * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
137      * of the balance will have vested.
138      * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
139      * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
140      * @param _start the time (as Unix time) at which point vesting starts 
141      * @param _duration duration in seconds of the period in which the tokens will vest
142      * @param _revocable whether the vesting is revocable or not
143      */
144     constructor(
145         address _beneficiary,
146         uint256 _start,
147         uint256 _cliff,
148         uint256 _duration,
149         bool _revocable
150     )
151         public
152     {
153         require(_beneficiary != address(0));
154         require(_cliff <= _duration);
155 
156         beneficiary = _beneficiary;
157         revocable = _revocable;
158         duration = _duration;
159         cliff = _start.add(_cliff);
160         start = _start;
161     }
162 
163     /**
164      * @notice Transfers vested tokens to beneficiary.
165      * @param token ERC20 token which is being vested
166      */
167     function release(ERC20 token) public {
168         uint256 unreleased = releasableAmount(token);
169 
170         require(unreleased > 0);
171 
172         released[token] = released[token].add(unreleased);
173 
174         token.safeTransfer(beneficiary, unreleased);
175 
176         emit Released(unreleased);
177     }
178 
179     /**
180      * @notice Allows the owner to revoke the vesting. Tokens already vested
181      * remain in the contract, the rest are returned to the owner.
182      * @param token ERC20 token which is being vested
183      */
184     function revoke(ERC20 token) public onlyOwner {
185         require(revocable);
186         require(!revoked[token]);
187 
188         uint256 balance = token.balanceOf(this);
189 
190         uint256 unreleased = releasableAmount(token);
191         uint256 refund = balance.sub(unreleased);
192 
193         revoked[token] = true;
194 
195         token.safeTransfer(owner, refund);
196 
197         emit Revoked();
198     }
199 
200     /**
201      * @dev Calculates the amount that has already vested but hasn't been released yet.
202      * @param token ERC20 token which is being vested
203      */
204     function releasableAmount(ERC20 token) public view returns (uint256) {
205         return vestedAmount(token).sub(released[token]);
206     }
207 
208     /**
209      * @dev Calculates the amount that has already vested.
210      * @param token ERC20 token which is being vested
211      */
212     function vestedAmount(ERC20 token) public view returns (uint256) {
213         uint256 currentBalance = token.balanceOf(this);
214         uint256 totalBalance = currentBalance.add(released[token]);
215 
216         if (block.timestamp < cliff) {
217           return 0;
218         } else if (block.timestamp >= start.add(duration) || revoked[token]) {
219           return totalBalance;
220         } else {
221           return totalBalance.mul(block.timestamp.sub(start)).div(duration);
222         }
223     }
224 
225     /**
226      * Don't accept ETH
227      */
228     function () public payable {
229         revert();
230     }
231 }