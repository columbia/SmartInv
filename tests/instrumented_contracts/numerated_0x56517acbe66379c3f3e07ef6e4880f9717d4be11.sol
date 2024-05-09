1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'HiroyukiCoin' token contract
5 //
6 // Deployed to : 0x56517aCbE66379C3f3e07EF6e4880F9717d4be11
7 // Symbol      : HRYK
8 // Name        : HiroyukiCoin
9 // Total supply: 20000000000000
10 // Decimals    : 18
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 library SafeMath {
18     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
19         if (a == 0) {
20             return 0;
21         }
22         c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b > 0); // Solidity automatically throws when dividing by 0
29         // uint256 c = a / b;
30         // assert(a == b * c + a % b);
31         return a / b;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
40         c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 }
45 
46 
47 
48 contract ERC20Interface {
49     function totalSupply() public constant returns (uint256);
50     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
51     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
52     function transfer(address to, uint256 tokens) public returns (bool success);
53     function approve(address spender, uint256 tokens) public returns (bool success);
54     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
55     event Transfer(address indexed from, address indexed to, uint256 tokens);
56     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
57     event Burn(address indexed from, uint256 tokens);
58 }
59 
60 
61 
62 contract ApproveAndCallFallBack {
63     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
64 }
65 
66 
67 
68 contract Owned {
69     address public owner;
70     address public newOwner;
71 
72     event OwnershipTransferred(address indexed _from, address indexed _to);
73 
74     function Owned() public {
75         owner = msg.sender;
76     }
77 
78     modifier onlyOwner {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     function transferOwnership(address _newOwner) public onlyOwner {
84         newOwner = _newOwner;
85     }
86     function acceptOwnership() public {
87         require(msg.sender == newOwner);
88         OwnershipTransferred(owner, newOwner);
89         owner = newOwner;
90         newOwner = address(0);
91     }
92 }
93 
94 
95 
96 contract HiroyukiCoin is ERC20Interface, Owned {
97     using SafeMath for uint;
98 
99     address public owner;
100     string public symbol;
101     string public  name;
102     uint8 public decimals;
103     
104     uint256 public _totalSupply;
105     uint256 public _currentSupply;
106 
107     uint public startDate;
108     uint public endDate;
109 
110     mapping (address => uint256) balances;
111     mapping (address => mapping (address => uint256)) allowed;
112 
113 
114     // ------------------------------------------------------------------------
115     // Constructor
116     // ------------------------------------------------------------------------
117     function HiroyukiCoin() public {
118         owner = msg.sender;
119 
120         symbol = "HRYK";
121         name = "HiroyukiCoin";
122         decimals = 18;
123 
124         _totalSupply = 20000000000000000000000000000000;
125         _currentSupply = 0;
126 
127         startDate = now;
128         endDate = now + 8 weeks;
129 
130         balances[owner] = _totalSupply;
131         Transfer(address(0), owner, _totalSupply);
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Total supply
137     // ------------------------------------------------------------------------
138     function totalSupply() public constant returns (uint256) {
139         return _totalSupply - balances[address(0)];
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Get the token balance for account `tokenOwner`
145     // ------------------------------------------------------------------------
146     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
147         return balances[tokenOwner];
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Transfer the balance from token owner's account to `to` account
153     // - Owner's account must have sufficient balance to transfer
154     // - 0 value transfers are allowed
155     // ------------------------------------------------------------------------
156     function transfer(address to, uint256 tokens) public returns (bool success) {
157         require(to != address(0));
158         require(tokens <= balances[msg.sender]);
159         balances[msg.sender] = SafeMath.sub(balances[msg.sender], tokens);
160         balances[to] = SafeMath.add(balances[to], tokens);
161         Transfer(msg.sender, to, tokens);
162         return true;
163     }
164 
165 
166     // ------------------------------------------------------------------------
167     // Token owner can approve for `spender` to transferFrom(...) `tokens`
168     // from the token owner's account
169     //
170     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
171     // recommends that there are no checks for the approval double-spend attack
172     // as this should be implemented in user interfaces
173     // ------------------------------------------------------------------------
174     function approve(address spender, uint256 tokens) public returns (bool success) {
175         allowed[msg.sender][spender] = tokens;
176         Approval(msg.sender, spender, tokens);
177         return true;
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Transfer `tokens` from the `from` account to the `to` account
183     //
184     // The calling account must already have sufficient tokens approve(...)-d
185     // for spending from the `from` account and
186     // - From account must have sufficient balance to transfer
187     // - Spender must have sufficient allowance to transfer
188     // - 0 value transfers are allowed
189     // ------------------------------------------------------------------------
190     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
191         require(to != address(0));
192         require(tokens <= balances[from]);
193         require(tokens <= allowed[from][msg.sender]);
194         balances[from] = SafeMath.sub(balances[from], tokens);
195         allowed[from][msg.sender] = SafeMath.sub(allowed[from][msg.sender], tokens);
196         balances[to] = SafeMath.add(balances[to], tokens);
197         Transfer(from, to, tokens);
198         return true;
199     }
200 
201     function burn(uint256 tokens) public returns (bool success) {
202         require(tokens <= balances[msg.sender]);
203         balances[msg.sender] = SafeMath.sub(balances[msg.sender], tokens);
204         _totalSupply = SafeMath.sub(_totalSupply, tokens);
205         Burn(msg.sender, tokens);
206         return true;
207     }
208 
209     // ------------------------------------------------------------------------
210     // Returns the amount of tokens approved by the owner that can be
211     // transferred to the spender's account
212     // ------------------------------------------------------------------------
213     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
214         return allowed[tokenOwner][spender];
215     }
216 
217 
218     // ------------------------------------------------------------------------
219     // Token owner can approve for `spender` to transferFrom(...) `tokens`
220     // from the token owner's account. The `spender` contract function
221     // `receiveApproval(...)` is then executed
222     // ------------------------------------------------------------------------
223     function approveAndCall(address spender, uint256 tokens, bytes data) public returns (bool success) {
224         allowed[msg.sender][spender] = tokens;
225         Approval(msg.sender, spender, tokens);
226         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
227         return true;
228     }
229 
230 
231     // ------------------------------------------------------------------------
232     // Owner can transfer out any accidentally sent ERC20 tokens
233     // ------------------------------------------------------------------------
234     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
235         return ERC20Interface(tokenAddress).transfer(owner, tokens);
236     }
237 }