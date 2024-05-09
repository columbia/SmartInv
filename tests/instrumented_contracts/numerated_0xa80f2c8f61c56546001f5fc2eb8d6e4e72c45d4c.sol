1 pragma solidity 0.8.3;
2 
3 // SPDX-License-Identifier: MIT
4 
5 // ----------------------------------------------------------------------------
6 // Safe maths
7 // ----------------------------------------------------------------------------
8 
9 contract SafeMath {
10     function safeAdd(uint a, uint b) public pure returns (uint c) {
11         c = a + b;
12         require(c >= a);
13     }
14     function safeSub(uint a, uint b) public pure returns (uint c) {
15         require(b <= a);
16         c = a - b;
17     }
18     function safeMul(uint a, uint b) public pure returns (uint c) {
19         c = a * b;
20         require(a == 0 || c / a == b);
21     }
22     function safeDiv(uint a, uint b) public pure returns (uint c) {
23         require(b > 0);
24         c = a / b;
25     }
26 }
27 
28 
29 // ----------------------------------------------------------------------------
30 // ERC Token Standard #20 Interface
31 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
32 // ----------------------------------------------------------------------------
33 
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     function balanceOf(address account) external view returns (uint256);
41 
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     function allowance(address owner, address spender) external view returns (uint256);
45     
46     function approve(address spender, uint256 amount) external returns (bool);
47 
48     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
49 
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 // ----------------------------------------------------------------------------
56 // Contract function to receive approval and execute function in one call
57 //
58 // Borrowed from MiniMeToken
59 // ----------------------------------------------------------------------------
60 abstract contract ApproveAndCallFallBack {
61     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) virtual public;
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
74     constructor()  {
75         owner = 0xC7781bf45EE2C64AA6E330Bd0e35522C1d7BA6b3;
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
96 // ERC20 Token, with the addition of symbol, name and decimals and assisted
97 // token transfers
98 // ----------------------------------------------------------------------------
99 
100 contract UniqueUtilityToken is IERC20, Owned, SafeMath {
101     string public symbol;
102     string public  name;
103     uint8 public decimals;
104     uint public _totalSupply;
105 
106     mapping(address => uint) balances;
107     mapping(address => mapping(address => uint)) allowed;
108 
109 
110     // ------------------------------------------------------------------------
111     // Constructor
112     // ------------------------------------------------------------------------
113     
114  constructor() {
115         name = "Unique Utility Token";
116         symbol = "UNQT";
117         decimals = 18;
118         _totalSupply = 100000000e18;         // 100,000,000 UNQT
119         address owner = owner;
120         balances[owner] = _totalSupply;
121         emit Transfer(address(0), owner, _totalSupply);
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Total supply
127     // ------------------------------------------------------------------------
128     function totalSupply() public view override returns (uint) {
129         return _totalSupply;
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Get the token balance for account tokenOwner
135     // ------------------------------------------------------------------------
136     function balanceOf(address tokenOwner) public view override returns (uint balance) {
137         return balances[tokenOwner];
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Transfer the balance from token owner's account to to account
143     // - Owner's account must have sufficient balance to transfer
144     // - 0 value transfers are allowed
145     // ------------------------------------------------------------------------
146     function transfer(address to, uint tokens) public override returns (bool success) {
147         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
148         balances[to] = safeAdd(balances[to], tokens);
149         Transfer(msg.sender, to, tokens);
150         return true;
151     }
152 
153 
154     // ------------------------------------------------------------------------
155     // Token owner can approve for spender to transferFrom(...) tokens
156     // from the token owner's account
157     //
158     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
159     // recommends that there are no checks for the approval double-spend attack
160     // as this should be implemented in user interfaces 
161     // ------------------------------------------------------------------------
162     function approve(address spender, uint tokens) public virtual override returns (bool success) {
163         allowed[msg.sender][spender] = tokens;
164         Approval(msg.sender, spender, tokens);
165         return true;
166     }
167 
168     // ------------------------------------------------------------------------
169     // Transfer tokens from the from account to the to account
170     // 
171     // The calling account must already have sufficient tokens approve(...)-d
172     // for spending from the from account and
173     // - From account must have sufficient balance to transfer
174     // - Spender must have sufficient allowance to transfer
175     // - 0 value transfers are allowed
176     // ------------------------------------------------------------------------
177     function transferFrom(address from, address to, uint tokens) public virtual override returns (bool success) {
178         balances[from] = safeSub(balances[from], tokens);
179         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
180         balances[to] = safeAdd(balances[to], tokens);
181         Transfer(from, to, tokens);
182         return true;
183     }
184 
185 
186     // ------------------------------------------------------------------------
187     // Returns the amount of tokens approved by the owner that can be
188     // transferred to the spender's account
189     // ------------------------------------------------------------------------
190     function allowance(address tokenOwner, address spender) public view virtual override  returns (uint remaining) {
191         return allowed[tokenOwner][spender];
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Token owner can approve for spender to transferFrom(...) tokens
197     // from the token owner's account. The spender contract function
198     // receiveApproval(...) is then executed
199     // ------------------------------------------------------------------------
200     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
201         allowed[msg.sender][spender] = tokens;
202         Approval(msg.sender, spender, tokens);
203         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
204         return true;
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Don't accept ETH
210     // ------------------------------------------------------------------------
211     receive () external payable {
212         revert();
213     }
214 
215 
216     // ------------------------------------------------------------------------
217     // Owner can transfer out any accidentally sent ERC20 tokens
218     // ------------------------------------------------------------------------
219     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
220         return IERC20(tokenAddress).transfer(owner, tokens);
221     }
222 }