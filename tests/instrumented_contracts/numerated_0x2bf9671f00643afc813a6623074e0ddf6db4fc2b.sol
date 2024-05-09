1 pragma solidity >=0.4.22 <0.6.0;
2 
3 // ----------------------------------------------------------------------------
4 // PSQ fixed supply amount token contract
5 //
6 // Symbol      : PSQ
7 // Name        : PSQ
8 // Total supply: 500,000,000.000000000000000000
9 // Decimals    : 18
10 //
11 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
18 library SafeMath {
19     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         c = a + b;
21         require(c >= a);
22     }
23     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
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
43     function totalSupply() public view returns (uint256);
44     function balanceOf(address tokenOwner) public view returns (uint256 balance);
45     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
46     function transfer(address to, uint256 tokens) public returns (bool success);
47     function approve(address spender, uint256 tokens) public returns (bool success);
48     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint256 tokens);
51     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Contract function to receive approval and execute function in one call
57 //
58 // Borrowed from MiniMeToken
59 // ----------------------------------------------------------------------------
60 contract ApproveAndCallFallBack {
61     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // Owned contract
67 // ----------------------------------------------------------------------------
68 contract Owned {
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
86     function acceptOwnership() public {
87         require(msg.sender == newOwner);
88         emit OwnershipTransferred(owner, newOwner);
89         owner = newOwner;
90         newOwner = address(0);
91     }
92 }
93 
94 
95 // ----------------------------------------------------------------------------
96 // ERC20 Token, with the addition of symbol, name and decimals and a
97 // fixed supply
98 // ----------------------------------------------------------------------------
99 contract PSQ is ERC20Interface, Owned {
100     using SafeMath for uint256;
101 
102     string public symbol;
103     string public  name;
104     uint8 public decimals;
105     uint256 _totalSupply;
106 
107     mapping(address => uint256) balances;
108     mapping(address => mapping(address => uint256)) allowed;
109 
110 
111     // ------------------------------------------------------------------------
112     // Constructor
113     // ------------------------------------------------------------------------
114     constructor(    	
115     ) public {
116         symbol = "PSQ";
117         name = "PSQ";
118         decimals = 18;
119         _totalSupply = 500000000 * 10**uint256(decimals);
120         balances[owner] = _totalSupply;
121         emit Transfer(address(0), owner, _totalSupply);
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Total supply
127     // ------------------------------------------------------------------------
128     function totalSupply() public view returns (uint256) {
129         return _totalSupply.sub(balances[address(0)]);
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Get the token balance for account `tokenOwner`
135     // ------------------------------------------------------------------------
136     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
137         return balances[tokenOwner];
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Transfer the balance from token owner's account to `to` account
143     // - Owner's account must have sufficient balance to transfer
144     // - 0 value transfers are allowed
145     // ------------------------------------------------------------------------
146     function transfer(address to, uint256 tokens) public returns (bool success) {
147         balances[msg.sender] = balances[msg.sender].sub(tokens);
148         balances[to] = balances[to].add(tokens);
149         emit Transfer(msg.sender, to, tokens);
150         return true;
151     }
152 
153 
154     // ------------------------------------------------------------------------
155     // Token owner can approve for `spender` to transferFrom(...) `tokens`
156     // from the token owner's account
157     //
158     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
159     // recommends that there are no checks for the approval double-spend attack
160     // as this should be implemented in user interfaces
161     // ------------------------------------------------------------------------
162     function approve(address spender, uint256 tokens) public returns (bool success) {
163         allowed[msg.sender][spender] = tokens;
164         emit Approval(msg.sender, spender, tokens);
165         return true;
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Transfer `tokens` from the `from` account to the `to` account
171     //
172     // The calling account must already have sufficient tokens approve(...)-d
173     // for spending from the `from` account and
174     // - From account must have sufficient balance to transfer
175     // - Spender must have sufficient allowance to transfer
176     // - 0 value transfers are allowed
177     // ------------------------------------------------------------------------
178     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
179         balances[from] = balances[from].sub(tokens);
180         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
181         balances[to] = balances[to].add(tokens);
182         emit Transfer(from, to, tokens);
183         return true;
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Returns the amount of tokens approved by the owner that can be
189     // transferred to the spender's account
190     // ------------------------------------------------------------------------
191     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) {
192         return allowed[tokenOwner][spender];
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Token owner can approve for `spender` to transferFrom(...) `tokens`
198     // from the token owner's account. The `spender` contract function
199     // `receiveApproval(...)` is then executed
200     // ------------------------------------------------------------------------
201     function approveAndCall(address spender, uint256 tokens, bytes memory data) public returns (bool success) {
202         allowed[msg.sender][spender] = tokens;
203         emit Approval(msg.sender, spender, tokens);
204         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
205         return true;
206     }
207 
208 
209     // ------------------------------------------------------------------------
210     // Don't accept ETH
211     // ------------------------------------------------------------------------
212     function () external payable {
213         revert();
214     }
215 
216 
217     // ------------------------------------------------------------------------
218     // Owner can transfer out any accidentally sent ERC20 tokens
219     // ------------------------------------------------------------------------
220     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
221         return ERC20Interface(tokenAddress).transfer(owner, tokens);
222     }
223 }