1 pragma solidity 0.4.23;
2 
3 
4 
5 contract Ownable {
6   address public owner;
7 
8 
9   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10 
11 
12   
13   constructor () public {
14     owner = msg.sender;
15   }
16 
17   
18   modifier onlyOwner() {
19     require(msg.sender == owner);
20     _;
21   }
22 
23   
24   function transferOwnership(address newOwner) public onlyOwner {
25     require(newOwner != address(0));
26     emit OwnershipTransferred(owner, newOwner);
27     owner = newOwner;
28   }
29 
30 }
31 
32 contract ERC20Basic {
33   function totalSupply() public view returns (uint256);
34   function balanceOf(address who) public view returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 
40 contract ERC20 is ERC20Basic {
41   function allowance(address owner, address spender) public view returns (uint256);
42   function transferFrom(address from, address to, uint256 value) public returns (bool);
43   function approve(address spender, uint256 value) public returns (bool);
44   event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 library SafeERC20 {
48   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
49     assert(token.transfer(to, value));
50   }
51 
52   function safeTransferFrom(
53     ERC20 token,
54     address from,
55     address to,
56     uint256 value
57   )
58     internal
59   {
60     assert(token.transferFrom(from, to, value));
61   }
62 
63   function safeApprove(ERC20 token, address spender, uint256 value) internal {
64     assert(token.approve(spender, value));
65   }
66 }
67 
68 library SafeMath {
69 
70   
71   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
72     if (a == 0) {
73       return 0;
74     }
75     c = a * b;
76     assert(c / a == b);
77     return c;
78   }
79 
80   
81   function div(uint256 a, uint256 b) internal pure returns (uint256) {
82     // assert(b > 0); // Solidity automatically throws when dividing by 0
83     // uint256 c = a / b;
84     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85     return a / b;
86   }
87 
88   
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90     assert(b <= a);
91     return a - b;
92   }
93 
94   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
95     c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 
101 
102 
103 contract TokenVestingTimelock is Ownable {
104     using SafeMath for uint256;
105     using SafeERC20 for ERC20Basic;
106 
107     event Released(uint256 amount);
108     event Revoked();
109     // beneficiary of tokens after they are released
110     address public beneficiary;
111 
112     uint256 public start;
113     uint256 public duration;
114 
115     bool public revocable;
116     // ERC20 basic token contract being held
117     ERC20Basic public token;
118 
119     // timestamp when token release is enabled
120     uint256 public releaseTime;
121 
122     uint256 public released;
123     bool public revoked;
124 
125   
126     constructor(
127         ERC20Basic _token,
128         address _beneficiary,
129         uint256 _start,
130         uint256 _duration,
131         bool _revokable,
132         uint256 _releaseTime
133     )
134     public
135     {
136         require(_beneficiary != address(0));
137         if (_releaseTime > 0) {
138             // solium-disable-next-line security/no-block-members
139             require(_releaseTime > block.timestamp);
140         }
141 
142         beneficiary = _beneficiary;
143         revocable = _revokable;
144         duration = _duration;
145         start = _start;
146         token = _token;
147         releaseTime = _releaseTime;
148     }
149 
150   
151     function release() public returns(bool) {
152         uint256 unreleased = releasableAmount();
153 
154         require(unreleased > 0);
155 
156         if (releaseTime > 0) {
157         // solium-disable-next-line security/no-block-members
158             require(block.timestamp >= releaseTime);
159         }
160 
161         released = released.add(unreleased);
162 
163         token.safeTransfer(beneficiary, unreleased);
164 
165         emit Released(unreleased);
166 
167         return true;
168     }
169 
170  
171     function revoke() public onlyOwner returns(bool) {
172         require(revocable);
173         require(!revoked);
174 
175         uint256 balance = token.balanceOf(this);
176 
177         uint256 unreleased = releasableAmount();
178         uint256 refund = balance.sub(unreleased);
179 
180         revoked = true;
181 
182         token.safeTransfer(owner, refund);
183 
184         emit Revoked();
185 
186         return true;
187     }
188 
189  
190     function releasableAmount() public view returns (uint256) {
191         return vestedAmount().sub(released);
192     }
193 
194  
195     function vestedAmount() public view returns (uint256) {
196         uint256 currentBalance = token.balanceOf(this);
197         uint256 totalBalance = currentBalance.add(released);
198         // solium-disable-next-line security/no-block-members
199         if (block.timestamp < start) {
200             return 0;
201           // solium-disable-next-line security/no-block-members
202         } else if (block.timestamp >= start.add(duration) || revoked) {
203             return totalBalance;
204         } else {
205             // solium-disable-next-line security/no-block-members
206             return totalBalance.mul(block.timestamp.sub(start)).div(duration);
207         }
208     }
209 }