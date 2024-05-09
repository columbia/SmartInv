1 pragma solidity ^0.7.0;
2 
3 
4 // SPDX-License-Identifier: MIT
5 // ----------------------------------------------------------------------------
6 // 'GOGOLCOIN' token contract
7 //
8 // Deployed to : 0x17e0c9168ce75f8636b6B65982B400b32ef4452b
9 // Symbol      : GOL
10 // Name        : GOGOLCOIN
11 // Total supply: 295000000
12 // Decimals    : 4
13 //
14 // Enjoy.
15 //
16 // (c) by Ahmed Majdoubi 2021. The MIT Licence.
17 // ----------------------------------------------------------------------------
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
45 interface IERC20 {
46     /**
47      * @dev Returns the amount of tokens in existence.
48      */
49     function totalSupply() external view returns (uint256);
50 
51     function balanceOf(address account) external view returns (uint256);
52 
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     function allowance(address owner, address spender) external view returns (uint256);
56     
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60 
61     event Transfer(address indexed from, address indexed to, uint256 value);
62 
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 // ----------------------------------------------------------------------------
67 // Contract function to receive approval and execute function in one call
68 //
69 // Borrowed from MiniMeToken
70 // ----------------------------------------------------------------------------
71 abstract contract ApproveAndCallFallBack {
72     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) virtual public;
73 }
74 
75 
76 // ----------------------------------------------------------------------------
77 // Owned contract
78 // ----------------------------------------------------------------------------
79 contract Owned {
80     address public owner;
81     address public newOwner;
82 
83     event OwnershipTransferred(address indexed _from, address indexed _to);
84 
85     constructor()  {
86         owner = msg.sender;
87     }
88 
89     modifier onlyOwner {
90         require(msg.sender == owner);
91         _;
92     }
93 
94     function transferOwnership(address _newOwner) public onlyOwner {
95         newOwner = _newOwner;
96     }
97     function acceptOwnership() public {
98         require(msg.sender == newOwner);
99         emit OwnershipTransferred(owner, newOwner);
100         owner = newOwner;
101         newOwner = address(0);
102     }
103 }
104 
105 
106 // ----------------------------------------------------------------------------
107 // ERC20 Token, with the addition of symbol, name and decimals and assisted
108 // token transfers
109 // ----------------------------------------------------------------------------
110 contract GOGOLCOIN is IERC20, Owned, SafeMath {
111     string public symbol;
112     string public  name;
113     uint8 public decimals;
114     uint public _totalSupply;
115 
116     mapping(address => uint) balances;
117     mapping(address => mapping(address => uint)) allowed;
118 
119 
120     // ------------------------------------------------------------------------
121     // Constructor
122     // ------------------------------------------------------------------------
123  constructor() {
124         symbol = "GOL";
125         name = "GOGOLCOIN";
126         decimals = 4;
127         _totalSupply = 295000000 * (10 ** decimals);
128         address owner = 0x17e0c9168ce75f8636b6B65982B400b32ef4452b;
129         balances[owner] = _totalSupply;
130         emit Transfer(address(0), owner, _totalSupply);
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Total supply
136     // ------------------------------------------------------------------------
137     function totalSupply() public view override returns (uint) {
138         return _totalSupply;
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Get the token balance for account tokenOwner
144     // ------------------------------------------------------------------------
145     function balanceOf(address tokenOwner) public view override returns (uint balance) {
146         return balances[tokenOwner];
147     }
148 
149 
150     // ------------------------------------------------------------------------
151     // Transfer the balance from token owner's account to to account
152     // - Owner's account must have sufficient balance to transfer
153     // - 0 value transfers are allowed
154     // ------------------------------------------------------------------------
155     function transfer(address to, uint tokens) public override returns (bool success) {
156         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
157         balances[to] = safeAdd(balances[to], tokens);
158         Transfer(msg.sender, to, tokens);
159         return true;
160     }
161 
162 
163     // ------------------------------------------------------------------------
164     // Token owner can approve for spender to transferFrom(...) tokens
165     // from the token owner's account
166     //
167     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
168     // recommends that there are no checks for the approval double-spend attack
169     // as this should be implemented in user interfaces 
170     // ------------------------------------------------------------------------
171     function approve(address spender, uint tokens) public virtual override returns (bool success) {
172         allowed[msg.sender][spender] = tokens;
173         Approval(msg.sender, spender, tokens);
174         return true;
175     }
176 
177     // ------------------------------------------------------------------------
178     // Transfer tokens from the from account to the to account
179     // 
180     // The calling account must already have sufficient tokens approve(...)-d
181     // for spending from the from account and
182     // - From account must have sufficient balance to transfer
183     // - Spender must have sufficient allowance to transfer
184     // - 0 value transfers are allowed
185     // ------------------------------------------------------------------------
186     function transferFrom(address from, address to, uint tokens) public virtual override returns (bool success) {
187         balances[from] = safeSub(balances[from], tokens);
188         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
189         balances[to] = safeAdd(balances[to], tokens);
190         Transfer(from, to, tokens);
191         return true;
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Returns the amount of tokens approved by the owner that can be
197     // transferred to the spender's account
198     // ------------------------------------------------------------------------
199     function allowance(address tokenOwner, address spender) public view virtual override  returns (uint remaining) {
200         return allowed[tokenOwner][spender];
201     }
202 
203 
204     // ------------------------------------------------------------------------
205     // Token owner can approve for spender to transferFrom(...) tokens
206     // from the token owner's account. The spender contract function
207     // receiveApproval(...) is then executed
208     // ------------------------------------------------------------------------
209     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
210         allowed[msg.sender][spender] = tokens;
211         Approval(msg.sender, spender, tokens);
212         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
213         return true;
214     }
215 
216 
217     // ------------------------------------------------------------------------
218     // Don't accept ETH
219     // ------------------------------------------------------------------------
220     receive () external payable {
221         revert();
222     }
223 
224 
225     // ------------------------------------------------------------------------
226     // Owner can transfer out any accidentally sent ERC20 tokens
227     // ------------------------------------------------------------------------
228     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
229         return IERC20(tokenAddress).transfer(owner, tokens);
230     }
231 }