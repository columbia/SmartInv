1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // '0Fucks' token contract
5 //
6 // Deployed to : 0xfeb53a79008aff53C8AE7b80e001446C0Fa1b5b2
7 // Symbol      :   COP
8 // Name        :   CoinCopyTrade
9 // Total supply: 2000000
10 // Decimals    :  18
11 //
12 // Enjoy.
13 //
14 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint a, uint b) public pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) public pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint a, uint b) public pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint a, uint b) public pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
44 // ----------------------------------------------------------------------------
45 contract ERC20Interface {
46     function totalSupply() public constant returns (uint);
47     function balanceOf(address tokenOwner) public constant returns (uint balance);
48     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
49     function transfer(address to, uint tokens) public returns (bool success);
50     function approve(address spender, uint tokens) public returns (bool success);
51     function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53     event Transfer(address indexed from, address indexed to, uint tokens);
54     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
55 }
56 
57 
58 // ----------------------------------------------------------------------------
59 // Contract function to receive approval and execute function in one call
60 //
61 // Borrowed from MiniMeToken
62 // ----------------------------------------------------------------------------
63 contract ApproveAndCallFallBack {
64     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // Owned contract
70 // ----------------------------------------------------------------------------
71 contract Owned {
72     address public owner;
73     address public newOwner;
74 
75     event OwnershipTransferred(address indexed _from, address indexed _to);
76 
77     constructor() public {
78         owner = msg.sender;
79     }
80 
81     modifier onlyOwner {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     function transferOwnership(address _newOwner) public onlyOwner {
87         newOwner = _newOwner;
88     }
89     function acceptOwnership() public {
90         require(msg.sender == newOwner);
91         emit OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93         newOwner = address(0);
94     }
95 }
96 
97 
98 // ----------------------------------------------------------------------------
99 // ERC20 Token, with the addition of symbol, name and decimals and assisted
100 // token transfers
101 // ----------------------------------------------------------------------------
102 contract CoinCopyTrade is ERC20Interface, Owned, SafeMath {
103     string public symbol;
104     string public  name;
105     uint8 public decimals;
106     uint public _totalSupply;
107 
108     mapping(address => uint) balances;
109     mapping(address => mapping(address => uint)) allowed;
110 
111 
112     // ------------------------------------------------------------------------
113     // Constructor
114     // ------------------------------------------------------------------------
115     constructor() public {
116         symbol = "COP";
117         name = "CoinCopyTrade";
118         decimals = 18;
119         _totalSupply =2000000000000000000000000;
120 		//after 100000000 fill 18 zero 18 is digits
121         balances[0xfeb53a79008aff53C8AE7b80e001446C0Fa1b5b2] = _totalSupply;
122         emit Transfer(address(0), 0xfeb53a79008aff53C8AE7b80e001446C0Fa1b5b2, _totalSupply);
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
150         emit Transfer(msg.sender, to, tokens);
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
165         emit Approval(msg.sender, spender, tokens);
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
183         emit Transfer(from, to, tokens);
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
204         emit Approval(msg.sender, spender, tokens);
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