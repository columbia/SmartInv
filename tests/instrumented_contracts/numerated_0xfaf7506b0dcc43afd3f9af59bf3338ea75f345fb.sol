1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev see https://github.com/ethereum/EIPs/issues/179 */
6 contract ERC20Basic {
7     function totalSupply() public view returns (uint256);
8     function balanceOf(address who) public view returns (uint256);
9     function transfer(address to, uint256 value) public returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 /**
14  * @title ERC20 interface
15  * @dev see https://github.com/ethereum/EIPs/issues/20 */
16 contract ERC20 is ERC20Basic {
17     function allowance(address owner, address spender) public view returns (uint256);
18     function transferFrom(address from, address to, uint256 value) public returns (bool);
19     function approve(address spender, uint256 value) public returns (bool);
20     event Approval(
21         address indexed owner,
22         address indexed spender,
23         uint256 value
24     );
25 }
26 
27 /**
28  * @title SafeERC20
29  * @dev Wrappers around ERC20 operations that throw on failure. */
30 library SafeERC20 {
31     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
32         require(token.transfer(to, value));
33     }
34 
35     function safeTransferFrom(
36         ERC20 token,
37         address from,
38         address to,
39         uint256 value
40     ) internal {
41         require(token.transferFrom(from, to, value));
42     }
43 
44     function safeApprove(ERC20 token, address spender, uint256 value) internal {
45         require(token.approve(spender, value));
46     }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control */
52 contract Ownable {
53     address public owner;
54 
55     event OwnershipTransferred(
56         address indexed previousOwner,
57         address indexed newOwner
58     );
59 
60     constructor() public {
61         owner = msg.sender;
62     }
63 
64     modifier onlyOwner() {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function transferOwnership(address newOwner) public onlyOwner {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73     }
74 }
75 
76 /**
77  * @title SafeMath
78  * @dev Math operations with safety checks that throw on error */
79 library SafeMath {
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
82         if (a == 0) {
83             return 0;
84         }
85         c = a * b;
86         assert(c / a == b);
87         return c;
88     }
89 
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91 
92         return a / b;
93     }
94 
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         assert(b <= a);
97         return a - b;
98     }
99 
100     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
101         c = a + b;
102         assert(c >= a);
103         return c;
104     }
105 }
106 
107 /**
108  * @title TokenVesting
109  * @dev A token holder contract that can release its token balance gradually like a
110  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the owner.*/
111 contract TokenVesting is Ownable {
112     using SafeMath for uint256;
113     using SafeERC20 for ERC20Basic;
114 
115     event Released(uint256 amount);
116     event Revoked();
117 
118     address public beneficiary;
119 
120     uint256 public cliff;
121     uint256 public start;
122     uint256 public duration;
123 
124     bool public revocable;
125 
126     mapping (address => uint256) public released;
127     mapping (address => bool) public revoked;
128 
129     constructor(
130         address _beneficiary,
131         uint256 _start,
132         uint256 _cliff,
133         uint256 _duration,
134         bool _revocable
135     )
136     public {
137         require(_beneficiary != address(0));
138         require(_cliff <= _duration);
139         beneficiary = _beneficiary;
140         revocable = _revocable;
141         duration = _duration;
142         cliff = _start.add(_cliff);
143         start = _start;
144     }
145 
146     function release(ERC20Basic token) public {
147         uint256 unreleased = releasableAmount(token);
148 
149         require(unreleased > 0);
150 
151         released[token] = released[token].add(unreleased);
152 
153         token.safeTransfer(beneficiary, unreleased);
154 
155         emit Released(unreleased);
156     }
157 
158     function revoke(ERC20Basic token) public onlyOwner {
159         require(revocable);
160         require(!revoked[token]);
161 
162         uint256 balance = token.balanceOf(this);
163 
164         uint256 unreleased = releasableAmount(token);
165         uint256 refund = balance.sub(unreleased);
166 
167         revoked[token] = true;
168 
169         token.safeTransfer(owner, refund);
170 
171         emit Revoked();
172     }
173 
174     function releasableAmount(ERC20Basic token) public view returns (uint256) {
175         return vestedAmount(token).sub(released[token]);
176     }
177 
178     function vestedAmount(ERC20Basic token) public view returns (uint256) {
179         uint256 currentBalance = token.balanceOf(this);
180         uint256 totalBalance = currentBalance.add(released[token]);
181 
182         if (block.timestamp < cliff) {
183             return 0;
184         } else if (block.timestamp >= start.add(duration) || revoked[token]) {
185             return totalBalance;
186         } else {
187             return totalBalance.mul(block.timestamp.sub(start)).div(duration);
188         }
189     }
190 }