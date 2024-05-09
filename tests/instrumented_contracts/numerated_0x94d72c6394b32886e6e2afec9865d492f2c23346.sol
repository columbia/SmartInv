1 pragma solidity ^0.5.2;
2 
3 // ----------------------------------------------------------------------------
4 // Fixed Supply Utility Token
5 // Symbol      : KLX
6 // Name        : Klixio
7 // Total supply: 1,000,000,000.000000000000000000
8 // Decimals    : 18
9 //
10 // Based on Fixed Supply Token contract by
11 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
18 library SafeMath {
19     function add(uint a, uint b) internal pure returns (uint c) {
20         c = a + b;
21         require(c >= a);
22     }
23     function sub(uint a, uint b) internal pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function mul(uint a, uint b) internal pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function div(uint a, uint b) internal pure returns (uint c) {
32         require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 
38 // ----------------------------------------------------------------------------
39 // ERC Token Standard #20 Interface
40 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
41 // ----------------------------------------------------------------------------
42 contract ERC20Interface {
43     function totalSupply() public view returns (uint);
44     function balanceOf(address tokenOwner) public view returns (uint balance);
45     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
46     function transfer(address to, uint tokens) public returns (bool success);
47     function approve(address spender, uint tokens) public returns (bool success);
48     function transferFrom(address from, address to, uint tokens) public returns (bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint tokens);
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Contract function to receive approval and execute function in one call
57 //
58 // Borrowed from MiniMeToken
59 // ----------------------------------------------------------------------------
60 contract KlixioApproveCallFallBack {
61     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // Owned contract
67 // ----------------------------------------------------------------------------
68 contract KlixioOwnership {
69     address public owner;
70     address public newOwner;
71 
72     event OwnershipTransferred(address indexed _from, address indexed _to);
73 
74     constructor() public {
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
86 	
87     function acceptOwnership() public {
88         require(msg.sender == newOwner);
89         emit OwnershipTransferred(owner, newOwner);
90         owner = newOwner;
91         newOwner = address(0);
92     }
93 
94 }
95 
96 
97 // ----------------------------------------------------------------------------
98 // ERC20 Token, with the addition of symbol, name and decimals and a
99 // fixed supply
100 // ----------------------------------------------------------------------------
101 contract Klixio is ERC20Interface, KlixioOwnership {
102     using SafeMath for uint;
103 
104     string public symbol;
105     string public  name;
106     uint8 public decimals;
107     uint _totalSupply;
108 
109     mapping(address => uint) balances;
110     mapping(address => mapping(address => uint)) allowed;
111 
112 
113     // ------------------------------------------------------------------------
114     // Constructor
115     // ------------------------------------------------------------------------
116     constructor() public {
117         symbol = "KLX";
118         name = "Klixio";
119         decimals = 18;
120         _totalSupply = 1000000000 * 10**uint(decimals);
121         balances[owner] = _totalSupply;
122         emit Transfer(address(0), owner, _totalSupply);
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Total supply
128     // ------------------------------------------------------------------------
129     function totalSupply() public view returns (uint) {
130         return _totalSupply.sub(balances[address(0)]);
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Get the token balance for account `tokenOwner`
136     // ------------------------------------------------------------------------
137     function balanceOf(address tokenOwner) public view returns (uint balance) {
138         return balances[tokenOwner];
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Transfer the balance from token owner's account to `to` account
144     // - Owner's account must have sufficient balance to transfer
145     // - 0 value transfers are allowed
146     // ------------------------------------------------------------------------
147     function transfer(address to, uint tokens) public returns (bool success) {
148         balances[msg.sender] = balances[msg.sender].sub(tokens);
149         balances[to] = balances[to].add(tokens);
150         emit Transfer(msg.sender, to, tokens);
151         return true;
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Token owner can approve for `spender` to transferFrom(...) `tokens`
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
171     // Transfer `tokens` from the `from` account to the `to` account
172     //
173     // The calling account must already have sufficient tokens approve(...)-d
174     // for spending from the `from` account and
175     // - From account must have sufficient balance to transfer
176     // - Spender must have sufficient allowance to transfer
177     // - 0 value transfers are allowed
178     // ------------------------------------------------------------------------
179     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
180         balances[from] = balances[from].sub(tokens);
181         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
182         balances[to] = balances[to].add(tokens);
183         emit Transfer(from, to, tokens);
184         return true;
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Returns the amount of tokens approved by the owner that can be
190     // transferred to the spender's account
191     // ------------------------------------------------------------------------
192     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
193         return allowed[tokenOwner][spender];
194     }
195 
196 
197     // ------------------------------------------------------------------------
198     // Token owner can approve for `spender` to transferFrom(...) `tokens`
199     // from the token owner's account. The `spender` contract function
200     // `receiveApproval(...)` is then executed
201     // ------------------------------------------------------------------------
202     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
203         allowed[msg.sender][spender] = tokens;
204         emit Approval(msg.sender, spender, tokens);
205         KlixioApproveCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
206         return true;
207     }
208 
209 
210     // ------------------------------------------------------------------------
211     // Don't accept ETH
212     // ------------------------------------------------------------------------
213     function () external payable {
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