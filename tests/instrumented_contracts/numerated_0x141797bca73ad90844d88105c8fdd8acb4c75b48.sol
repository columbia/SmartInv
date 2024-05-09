1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'DIYTubeCoin' token contract
5 //
6 // Deployed to : 0x5ED41f370f7eE3BE272FBC7f242fa3db08521eC3
7 // Symbol      : DIYT
8 // Name        : DIY Tube Coin
9 // Total supply: 249500000
10 // Decimals    : 18
11 //
12 // http://www.diytubecoin.com
13 // DIY Tube Video sharing site: https://www.diytube.video
14 // A division of The Do It Yourself World LLC
15 //
16 // DIY Tube is a community and video sharing site which pays you to interact
17 // with one another using DIY Tube Coins
18 // ----------------------------------------------------------------------------
19 
20 
21 // ----------------------------------------------------------------------------
22 // Safe maths
23 // ----------------------------------------------------------------------------
24 contract SafeMath {
25     function safeAdd(uint a, uint b) public pure returns (uint c) {
26         c = a + b;
27         require(c >= a);
28     }
29     function safeSub(uint a, uint b) public pure returns (uint c) {
30         require(b <= a);
31         c = a - b;
32     }
33     function safeMul(uint a, uint b) public pure returns (uint c) {
34         c = a * b;
35         require(a == 0 || c / a == b);
36     }
37     function safeDiv(uint a, uint b) public pure returns (uint c) {
38         require(b > 0);
39         c = a / b;
40     }
41 }
42 
43 
44 // ----------------------------------------------------------------------------
45 // ERC Token Standard #20 Interface
46 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
47 // ----------------------------------------------------------------------------
48 contract ERC20Interface {
49     function totalSupply() public constant returns (uint);
50     function balanceOf(address tokenOwner) public constant returns (uint balance);
51     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
52     function transfer(address to, uint tokens) public returns (bool success);
53     function approve(address spender, uint tokens) public returns (bool success);
54     function transferFrom(address from, address to, uint tokens) public returns (bool success);
55 
56     event Transfer(address indexed from, address indexed to, uint tokens);
57     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // Contract function to receive approval and execute function in one call
63 // ----------------------------------------------------------------------------
64 contract ApproveAndCallFallBack {
65     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
66 }
67 
68 
69 // ----------------------------------------------------------------------------
70 // Owned contract
71 // ----------------------------------------------------------------------------
72 contract Owned {
73     address public owner;
74     address public newOwner;
75 
76     event OwnershipTransferred(address indexed _from, address indexed _to);
77 
78     function Owned() public {
79         owner = msg.sender;
80     }
81 
82     modifier onlyOwner {
83         require(msg.sender == owner);
84         _;
85     }
86 
87     function transferOwnership(address _newOwner) public onlyOwner {
88         newOwner = _newOwner;
89     }
90     function acceptOwnership() public {
91         require(msg.sender == newOwner);
92         OwnershipTransferred(owner, newOwner);
93         owner = newOwner;
94         newOwner = address(0);
95     }
96 }
97 
98 
99 // ----------------------------------------------------------------------------
100 // ERC20 Token, with the addition of symbol, name and decimals and assisted
101 // token transfers
102 // ----------------------------------------------------------------------------
103 contract DIYTubeCoin is ERC20Interface, Owned, SafeMath {
104     string public symbol;
105     string public  name;
106     uint8 public decimals;
107     uint public _totalSupply;
108 
109     mapping(address => uint) balances;
110     mapping(address => mapping(address => uint)) allowed;
111 
112 
113     // ------------------------------------------------------------------------
114     // Constructor
115     // ------------------------------------------------------------------------
116     function DIYTubeCoin() public {
117         symbol = "DIYT";
118         name = "DIY Tube Coin";
119         decimals = 18;
120         _totalSupply = 249500000000000000000000000;
121         balances[0x5ED41f370f7eE3BE272FBC7f242fa3db08521eC3] = _totalSupply;
122         Transfer(address(0), 0x5ED41f370f7eE3BE272FBC7f242fa3db08521eC3, _totalSupply);
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Total supply
128     // ------------------------------------------------------------------------
129     function totalSupply() public constant returns (uint) {
130         return _totalSupply  - balances[address(0)];
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Get the token balance for account tokenOwner
136     // ------------------------------------------------------------------------
137     function balanceOf(address tokenOwner) public constant returns (uint balance) {
138         return balances[tokenOwner];
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Transfer the balance from token owner's account to to account
144     // - Owner's account must have sufficient balance to transfer
145     // - 0 value transfers are allowed
146     // ------------------------------------------------------------------------
147     function transfer(address to, uint tokens) public returns (bool success) {
148         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
149         balances[to] = safeAdd(balances[to], tokens);
150         Transfer(msg.sender, to, tokens);
151         return true;
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Token owner can approve for spender to transferFrom(...) tokens
157     // from the token owner's account
158     //
159     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
160     // recommends that there are no checks for the approval double-spend attack
161     // as this should be implemented in user interfaces 
162     // ------------------------------------------------------------------------
163     function approve(address spender, uint tokens) public returns (bool success) {
164         allowed[msg.sender][spender] = tokens;
165         Approval(msg.sender, spender, tokens);
166         return true;
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Transfer tokens from the from account to the to account
172     // 
173     // The calling account must already have sufficient tokens approve(...)-d
174     // for spending from the from account and
175     // - From account must have sufficient balance to transfer
176     // - Spender must have sufficient allowance to transfer
177     // - 0 value transfers are allowed
178     // ------------------------------------------------------------------------
179     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
180         balances[from] = safeSub(balances[from], tokens);
181         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
182         balances[to] = safeAdd(balances[to], tokens);
183         Transfer(from, to, tokens);
184         return true;
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Returns the amount of tokens approved by the owner that can be
190     // transferred to the spender's account
191     // ------------------------------------------------------------------------
192     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
193         return allowed[tokenOwner][spender];
194     }
195 
196 
197     // ------------------------------------------------------------------------
198     // Token owner can approve for spender to transferFrom(...) tokens
199     // from the token owner's account. The spender contract function
200     // receiveApproval(...) is then executed
201     // ------------------------------------------------------------------------
202     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
203         allowed[msg.sender][spender] = tokens;
204         Approval(msg.sender, spender, tokens);
205         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
206         return true;
207     }
208 
209 
210     // ------------------------------------------------------------------------
211     // Don't accept ETH
212     // ------------------------------------------------------------------------
213     function () public payable {
214         revert();
215     }
216 
217 
218     // ------------------------------------------------------------------------
219     // Owner can transfer out any accidentally sent ERC20 tokens
220     // ------------------------------------------------------------------------
221     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
222         return ERC20Interface(tokenAddress).transfer(owner, tokens);
223     }
224 }