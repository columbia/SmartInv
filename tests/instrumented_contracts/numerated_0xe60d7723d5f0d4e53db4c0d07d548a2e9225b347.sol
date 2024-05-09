1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 contract ERC20Basic {
70   uint256 public totalSupply;
71   function balanceOf(address who) public view returns (uint256);
72   function transfer(address to, uint256 value) public returns (bool);
73   event Transfer(address indexed from, address indexed to, uint256 value);
74 }
75 
76 contract ERC20 is ERC20Basic {
77   function allowance(address owner, address spender) public view returns (uint256);
78   function transferFrom(address from, address to, uint256 value) public returns (bool);
79   function approve(address spender, uint256 value) public returns (bool);
80   event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 library SafeERC20 {
84   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
85     assert(token.transfer(to, value));
86   }
87 
88   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
89     assert(token.transferFrom(from, to, value));
90   }
91 
92   function safeApprove(ERC20 token, address spender, uint256 value) internal {
93     assert(token.approve(spender, value));
94   }
95 }
96 
97 contract TokenVesting is Ownable {
98     using SafeMath for uint256;
99     using SafeERC20 for ERC20Basic;
100 
101     event Released(uint256 amount);
102     event Revoked();
103 
104     // beneficiary of tokens after they are released
105     address public beneficiary;
106 
107     uint256 public cliff;
108     uint256 public start;
109     uint256 public duration;
110 
111     bool public revocable;
112 
113     mapping (address => uint256) public released;
114     mapping (address => bool) public revoked;
115 
116     /**
117     * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
118     * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
119     * of the balance will have vested.
120     * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
121     * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
122     * @param _duration duration in seconds of the period in which the tokens will vest
123     * @param _revocable whether the vesting is revocable or not
124     */
125     function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
126         require(_beneficiary != address(0));
127         require(_cliff <= _duration);
128 
129         beneficiary = _beneficiary;
130         revocable = _revocable;
131         duration = _duration;
132         cliff = _start.add(_cliff);
133         start = _start;
134     }
135 
136     /**
137     * @notice Transfers vested tokens to beneficiary.
138     * @param token ERC20 token which is being vested
139     */
140     function release(ERC20Basic token) public {
141         uint256 unreleased = releasableAmount(token);
142 
143         require(unreleased > 0);
144 
145         released[token] = released[token].add(unreleased);
146 
147         token.safeTransfer(beneficiary, unreleased);
148 
149         Released(unreleased);
150     }
151 
152     /**
153     * @notice Allows the owner to revoke the vesting. Tokens already vested
154     * remain in the contract, the rest are returned to the owner.
155     * @param token ERC20 token which is being vested
156     */
157     function revoke(ERC20Basic token) public onlyOwner {
158         require(revocable);
159         require(!revoked[token]);
160 
161         uint256 balance = token.balanceOf(this);
162 
163         uint256 unreleased = releasableAmount(token);
164         uint256 refund = balance.sub(unreleased);
165 
166         revoked[token] = true;
167 
168         token.safeTransfer(owner, refund);
169 
170         Revoked();
171     }
172 
173     /**
174     * @dev Calculates the amount that has already vested but hasn't been released yet.
175     * @param token ERC20 token which is being vested
176     */
177     function releasableAmount(ERC20Basic token) public view returns (uint256) {
178         return vestedAmount(token).sub(released[token]);
179     }
180 
181     /**
182     * @dev Calculates the amount that has already vested.
183     * @param token ERC20 token which is being vested
184     */
185     function vestedAmount(ERC20Basic token) public view returns (uint256) {
186         uint256 currentBalance = token.balanceOf(this);
187         uint256 totalBalance = currentBalance.add(released[token]);
188 
189         if (now < cliff) {
190             return 0;
191         } else if (now >= start.add(duration) || revoked[token]) {
192             return totalBalance;
193         } else {
194             return totalBalance.mul(now.sub(start)).div(duration);
195         }
196     }
197 }
198 
199 contract TokenVestingFactory is Ownable {
200 
201     event Created(TokenVesting vesting);
202 
203     function create(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) onlyOwner public returns (TokenVesting) {
204 
205         TokenVesting vesting = new TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable);
206 
207         Created(vesting);
208 
209         return vesting;
210     }
211 
212 }