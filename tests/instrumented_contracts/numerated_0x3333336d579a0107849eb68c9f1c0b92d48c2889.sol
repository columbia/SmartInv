1 pragma solidity ^0.6.12;
2 
3 /* SPDX-License-Identifier: UNLICENSED */
4 
5 // ----------------------------------------------------------------------------
6 // Safe maths
7 // ----------------------------------------------------------------------------
8 library SafeMath {
9     function add(uint a, uint b) internal pure returns (uint c) {
10         c = a + b;
11         require(c >= a);
12     }
13     function sub(uint a, uint b) internal pure returns (uint c) {
14         require(b <= a);
15         c = a - b;
16     }
17     function mul(uint a, uint b) internal pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function div(uint a, uint b) internal pure returns (uint c) {
22         require(b > 0);
23         c = a / b;
24     }
25 }
26 
27 // ----------------------------------------------------------------------------
28 // Owned contract
29 // ----------------------------------------------------------------------------
30 contract Owned {
31     address public owner;
32     address public newOwner;
33 
34     event OwnershipTransferred(address indexed _from, address indexed _to);
35 
36     constructor() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address _newOwner) public onlyOwner {
46         newOwner = _newOwner;
47     }
48 
49     function acceptOwnership() public {
50         require(msg.sender == newOwner);
51         emit OwnershipTransferred(owner, newOwner);
52         owner = newOwner;
53         newOwner = address(0);
54     }
55 }
56 
57 // ----------------------------------------------------------------------------
58 // ERC Token Standard #20 Interface
59 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
60 // ----------------------------------------------------------------------------
61 abstract contract ERC20Interface {
62     function totalSupply() virtual public view returns (uint);
63     function balanceOf(address tokenOwner) virtual public view returns (uint balance);
64     function allowance(address tokenOwner, address spender) virtual public view returns (uint remaining);
65     function transfer(address to, uint tokens) virtual public returns (bool success);
66     function approve(address spender, uint tokens) virtual public returns (bool success);
67     function transferFrom(address from, address to, uint tokens) virtual public returns (bool success);
68 
69     event Transfer(address indexed from, address indexed to, uint tokens);
70     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
71 }
72 
73 
74 struct Schedule {
75     uint32  start;
76     uint32  length;
77     uint256 initial;
78     uint256 tokens;
79 }
80 
81 
82 contract Vesting is Owned, ERC20Interface {
83     using SafeMath for uint;
84 
85     string public symbol;
86     string public  name;
87     uint8 public decimals;
88 
89     mapping(address => Schedule) public schedules;
90     mapping(address => uint256) balances;
91     address public lockedTokenAddress;
92 
93 
94     // ------------------------------------------------------------------------
95     // Constructor
96     // ------------------------------------------------------------------------
97     constructor() public {
98         symbol = "VTLM";
99         name = "Vesting Alien Worlds Trilium";
100         decimals = 4;
101     }
102 
103     /* ERC-20 functions, null most of them */
104 
105     function balanceOf(address tokenOwner) override virtual public view returns (uint balance) {
106         return balances[tokenOwner];
107     }
108 
109     function totalSupply() override virtual public view returns (uint) {
110         return 0;
111     }
112 
113     function allowance(address tokenOwner, address spender) override virtual public view returns (uint remaining){
114         return 0;
115     }
116 
117     function transfer(address to, uint tokens) override virtual public returns (bool success) {
118         require(false, "Use the claim function, not transfer");
119     }
120 
121     function approve(address spender, uint tokens) override virtual public returns (bool success) {
122         require(false, "Cannot approve spending");
123     }
124 
125     function transferFrom(address from, address to, uint tokens) override virtual public returns (bool success) {
126         require(false, "Use the claim function, not transferFrom");
127     }
128 
129 
130     /* My functions */
131 
132     function vestedTotal(address user) private view returns (uint256){
133         uint256 time_now = block.timestamp;
134         uint256 vesting_seconds = 0;
135         Schedule memory s = schedules[user];
136 
137         uint256 vested_total = balances[user];
138 
139         if (s.start > 0) {
140             if (time_now >= s.start) {
141                 vesting_seconds = time_now - s.start;
142 
143                 uint256 vest_per_second_sats = s.tokens.sub(s.initial);
144                 vest_per_second_sats = vest_per_second_sats.div(s.length);
145                 
146                 vested_total = vesting_seconds.mul(vest_per_second_sats);
147                 vested_total = vested_total.add(s.initial); // amount they can withdraw
148             }
149             else {
150                 vested_total = 1;
151             }
152             
153             if (vested_total > s.tokens) {
154                 vested_total = s.tokens;
155             }
156         }
157 
158         return vested_total;
159     }
160 
161     function maxClaim(address user) public view returns (uint256) {
162         uint256 vested_total = vestedTotal(user);
163         Schedule memory s = schedules[user];
164         uint256 max = 0;
165 
166         if (s.start > 0){
167             uint256 claimed = s.tokens.sub(balances[user]);
168 
169             max = vested_total.sub(claimed);
170 
171             if (max > balances[user]){
172                 max = balances[user];
173             }
174         }
175 
176         return max;
177     }
178 
179     function claim(uint256 amount) public {
180         require(lockedTokenAddress != address(0x0), "Locked token contract has not been set");
181         require(amount > 0, "Must claim more than 0");
182         require(balances[msg.sender] > 0, "No vesting balance found");
183 
184         uint256 vested_total = vestedTotal(msg.sender);
185 
186         Schedule memory s = schedules[msg.sender];
187         if (s.start > 0){
188             uint256 remaining_balance = balances[msg.sender].sub(amount);
189 
190             if (vested_total < s.tokens) {
191                 uint min_balance = s.tokens.sub(vested_total);
192                 require(remaining_balance >= min_balance, "Cannot transfer this amount due to vesting locks");
193             }
194         }
195 
196         balances[msg.sender] = balances[msg.sender].sub(amount);
197         ERC20Interface(lockedTokenAddress).transfer(msg.sender, amount);
198     }
199 
200     function setSchedule(address user, uint32 start, uint32 length, uint256 initial, uint256 amount) public onlyOwner {
201         schedules[user].start = start;
202         schedules[user].length = length;
203         schedules[user].initial = initial;
204         schedules[user].tokens = amount;
205     }
206 
207     function addTokens(address newOwner, uint256 amount) public onlyOwner {
208         require(lockedTokenAddress != address(0x0), "Locked token contract has not been set");
209 
210         ERC20Interface tokenContract = ERC20Interface(lockedTokenAddress);
211 
212         uint256 userAllowance = tokenContract.allowance(msg.sender, address(this));
213         uint256 fromBalance = tokenContract.balanceOf(msg.sender);
214         require(fromBalance >= amount, "Sender has insufficient balance");
215         require(userAllowance >= amount, "Please allow tokens to be spent by this contract");
216         tokenContract.transferFrom(msg.sender, address(this), amount);
217 
218         balances[newOwner] = balances[newOwner].add(amount);
219         
220         emit Transfer(address(0x0), newOwner, amount);
221     }
222 
223     function removeTokens(address owner, uint256 amount) public onlyOwner {
224         ERC20Interface tokenContract = ERC20Interface(lockedTokenAddress);
225         tokenContract.transfer(owner, amount);
226         
227         balances[owner] = balances[owner].sub(amount);
228     }
229 
230     function setTokenContract(address _lockedTokenAddress) public onlyOwner {
231         lockedTokenAddress = _lockedTokenAddress;
232     }
233 
234     // ------------------------------------------------------------------------
235     // Don't accept ETH
236     // ------------------------------------------------------------------------
237     receive () external payable {
238         revert();
239     }
240 
241 
242     // ------------------------------------------------------------------------
243     // Owner can transfer out any accidentally sent ERC20 tokens
244     // ------------------------------------------------------------------------
245     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
246         return ERC20Interface(tokenAddress).transfer(owner, tokens);
247     }
248 }