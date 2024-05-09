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
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60   address public owner;
61 
62 
63   event OwnershipRenounced(address indexed previousOwner);
64   event OwnershipTransferred(
65     address indexed previousOwner,
66     address indexed newOwner
67   );
68 
69 
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   constructor() public {
75     owner = msg.sender;
76   }
77 
78   /**
79    * @dev Throws if called by any account other than the owner.
80    */
81   modifier onlyOwner() {
82     require(msg.sender == owner);
83     _;
84   }
85 
86   /**
87    * @dev Allows the current owner to relinquish control of the contract.
88    * @notice Renouncing to ownership will leave the contract without an owner.
89    * It will not be possible to call the functions with the `onlyOwner`
90    * modifier anymore.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     _transferOwnership(_newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address _newOwner) internal {
110     require(_newOwner != address(0));
111     emit OwnershipTransferred(owner, _newOwner);
112     owner = _newOwner;
113   }
114 }
115 
116 contract ERC20 {
117     uint256 public totalSupply;
118     
119     function balanceOf(address tokenOwner) public view returns (uint256 balance);
120     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
121     function transfer(address to, uint256 tokens) public returns (bool success);
122     function approve(address spender, uint256 tokens) public returns (bool success);
123     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
124 
125     event Transfer(address indexed from, address indexed to, uint256 tokens);
126     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
127 }
128 
129 library SafeERC20 {
130     function safeTransfer(ERC20 token, address to, uint256 value) internal {
131         require(token.transfer(to, value));
132     }
133 
134     function safeTransferFrom(
135         ERC20 token,
136         address from,
137         address to,
138         uint256 value
139     )
140         internal
141     {
142         require(token.transferFrom(from, to, value));
143     }
144 
145     function safeApprove(ERC20 token, address spender, uint256 value) internal {
146         require(token.approve(spender, value));
147     }
148 }
149 
150 contract TokenVesting is Ownable {
151     using SafeMath for uint256;
152     using SafeERC20 for ERC20;
153 
154     event Released(uint256 amount);
155     event Revoked();
156 
157     // beneficiary of tokens after they are released
158     address public beneficiary;
159 
160     uint256 public cliff;
161     uint256 public start;
162     uint256 public duration;
163 
164     bool public revocable;
165 
166     mapping (address => uint256) public released;
167     mapping (address => bool) public revoked;
168 
169     /**
170      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
171      * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
172      * of the balance will have vested.
173      * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
174      * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
175      * @param _start the time (as Unix time) at which point vesting starts 
176      * @param _duration duration in seconds of the period in which the tokens will vest
177      * @param _revocable whether the vesting is revocable or not
178      */
179     constructor(
180         address _beneficiary,
181         uint256 _start,
182         uint256 _cliff,
183         uint256 _duration,
184         bool _revocable
185     )
186         public
187     {
188         require(_beneficiary != address(0));
189         require(_cliff <= _duration);
190 
191         beneficiary = _beneficiary;
192         revocable = _revocable;
193         duration = _duration;
194         cliff = _start.add(_cliff);
195         start = _start;
196     }
197 
198     /**
199      * @notice Transfers vested tokens to beneficiary.
200      * @param token ERC20 token which is being vested
201      */
202     function release(ERC20 token) public {
203         uint256 unreleased = releasableAmount(token);
204 
205         require(unreleased > 0);
206 
207         released[token] = released[token].add(unreleased);
208 
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
219     function revoke(ERC20 token) public onlyOwner {
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
239     function releasableAmount(ERC20 token) public view returns (uint256) {
240         return vestedAmount(token).sub(released[token]);
241     }
242 
243     /**
244      * @dev Calculates the amount that has already vested.
245      * @param token ERC20 token which is being vested
246      */
247     function vestedAmount(ERC20 token) public view returns (uint256) {
248         uint256 currentBalance = token.balanceOf(this);
249         uint256 totalBalance = currentBalance.add(released[token]);
250 
251         if (block.timestamp < cliff) {
252           return 0;
253         } else if (block.timestamp >= start.add(duration) || revoked[token]) {
254           return totalBalance;
255         } else {
256           uint256 gap = 86400 * 30;
257           uint256 start_gap = block.timestamp.sub(start).div(gap).mul(gap);
258           return totalBalance.mul(start_gap).div(duration);
259         }
260     }
261 
262     /**
263      * Don't accept ETH
264      */
265     function () public payable {
266         revert();
267     }
268 }