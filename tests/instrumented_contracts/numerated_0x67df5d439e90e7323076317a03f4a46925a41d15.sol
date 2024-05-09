1 pragma solidity ^0.4.24;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Safe maths
6 // ----------------------------------------------------------------------------
7 contract SafeMath {
8     function safeAdd(uint a, uint b) internal pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function safeSub(uint a, uint b) internal pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function safeMul(uint a, uint b) internal pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function safeDiv(uint a, uint b) internal pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 
27 // ----------------------------------------------------------------------------
28 // ERC Token Standard #20 Interface
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address tokenOwner) public constant returns (uint balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // Contract function to receive approval and execute function in one call
45 //
46 // Borrowed from MiniMeToken
47 // ----------------------------------------------------------------------------
48 contract ApproveAndCallFallBack {
49     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // ----------------------------------------------------------------------------
56 contract Owned {
57     address public owner;
58 
59     event OwnershipTransferred(address indexed _from, address indexed _to);
60 
61     constructor() public {
62         owner = msg.sender;
63     }
64 
65     modifier onlyOwner {
66         require(msg.sender == owner);
67         _;
68     }
69 
70 
71 
72 }
73 
74 
75 // ----------------------------------------------------------------------------
76 // ERC20 Token, with the addition of symbol, name and decimals and assisted
77 // token transfers
78 // ----------------------------------------------------------------------------
79 contract Eruptcrypt is ERC20Interface, Owned, SafeMath {
80     string public symbol;
81     string public  name;
82     uint public decimals;
83     uint private _totalSupply;
84 
85     mapping(address => uint) balances;
86     mapping(address => mapping(address => uint)) allowed;
87 
88 
89     // ------------------------------------------------------------------------
90     // Constructor
91     // ------------------------------------------------------------------------
92     constructor() public {
93         symbol = "ERUPT";
94         name = "Eruptcrypt";
95         decimals = 0;
96         _totalSupply = 10000000;
97         _totalSupply = _totalSupply * 10 ** decimals;
98         balances[0xA977725C6093bf34Ad9FFE8949347217ec0d43F7] = _totalSupply;
99         emit Transfer(address(0), owner, _totalSupply);
100     }
101 
102     // ------------------------------------------------------------------------
103     // Total supply
104     // ------------------------------------------------------------------------
105     function totalSupply() public constant returns (uint) {
106         return _totalSupply;
107     }
108     
109     // ------------------------------------------------------------------------
110     // Get the token balance for account tokenOwner
111     // ------------------------------------------------------------------------
112     function balanceOf(address tokenOwner) public constant returns (uint balance) {
113         return balances[tokenOwner];
114     }
115 
116 
117     // ------------------------------------------------------------------------
118     // Transfer the balance from token owner's account to to account
119     // - Owner's account must have sufficient balance to transfer
120     // - 0 value transfers are allowed
121     // ------------------------------------------------------------------------
122     function transfer(address to, uint _tokens) public returns (bool success) {
123         
124         uint tokensBurn =  (_tokens/200);
125         uint readyTokens = safeSub(_tokens, tokensBurn);
126         burn(owner, tokensBurn);
127         
128         balances[msg.sender] = safeSub(balances[msg.sender], _tokens);
129         balances[to] = safeAdd(balances[to], readyTokens);
130         emit Transfer(msg.sender, to, readyTokens);
131         return true;
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Token owner can approve for spender to transferFrom(...) tokens
137     // from the token owner's account
138     //
139     // recommends that there are no checks for the approval double-spend attack
140     // as this should be implemented in user interfaces
141     // ------------------------------------------------------------------------
142     function approve(address spender, uint tokens) public returns (bool success) {
143         allowed[msg.sender][spender] = tokens;
144         emit Approval(msg.sender, spender, tokens);
145         return true;
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Transfer tokens from the from account to the to account
151     //
152     // The calling account must already have sufficient tokens approve(...)-d
153     // for spending from the from account and
154     // - From account must have sufficient balance to transfer
155     // - Spender must have sufficient allowance to transfer
156     // - 0 value transfers are allowed
157     // ------------------------------------------------------------------------
158     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
159         balances[from] = safeSub(balances[from], tokens);
160         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
161         balances[to] = safeAdd(balances[to], tokens);
162         emit Transfer(from, to, tokens);
163         return true;
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Returns the amount of tokens approved by the owner that can be
169     // transferred to the spender's account
170     // ------------------------------------------------------------------------
171     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
172         return allowed[tokenOwner][spender];
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Token owner can approve for spender to transferFrom(...) tokens
178     // from the token owner's account. The spender contract function
179     // receiveApproval(...) is then executed
180     // ------------------------------------------------------------------------
181     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
182         allowed[msg.sender][spender] = tokens;
183         emit Approval(msg.sender, spender, tokens);
184         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
185         return true;
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Don't accept ETH
191     // ------------------------------------------------------------------------
192     function () public payable {
193         revert();
194     }
195 
196 
197     function transferOwnership(address _newOwner) public onlyOwner {
198         owner = _newOwner;
199     }
200 
201 
202     /**
203      * @dev Internal function that burns an amount of the token of a given
204      * account.
205      * @param account The account whose tokens will be burnt.
206      * @param value The amount that will be burnt.
207      */
208     function burn(address account, uint256 value) private {
209         require(account != address(0)); 
210 
211         _totalSupply = safeSub(_totalSupply, value);
212         balances[account] = safeSub(balances[account], value);
213     }
214 }