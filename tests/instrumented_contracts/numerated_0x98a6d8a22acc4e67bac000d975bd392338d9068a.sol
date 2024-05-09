1 pragma solidity ^0.4.18;
2 // ----------------------------------------------------------------------------
3 // Safe maths
4 // ----------------------------------------------------------------------------
5 contract SafeMath {
6     function safeAdd(uint a, uint b) public pure returns (uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function safeSub(uint a, uint b) public pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function safeMul(uint a, uint b) public pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function safeDiv(uint a, uint b) public pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21     }
22 }
23 
24 
25 // ----------------------------------------------------------------------------
26 // ERC Token Standard #20 Interface
27 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
28 // ----------------------------------------------------------------------------
29 contract ERC20Interface {
30     function totalSupply() public constant returns (uint);
31     function balanceOf(address tokenOwner) public constant returns (uint balance);
32     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
33     function transfer(address to, uint tokens) public returns (bool success);
34     function approve(address spender, uint tokens) public returns (bool success);
35     function transferFrom(address from, address to, uint tokens) public returns (bool success);
36 
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 
42 // ----------------------------------------------------------------------------
43 // Contract function to receive approval and execute function in one call
44 //
45 // Borrowed from MiniMeToken
46 // ----------------------------------------------------------------------------
47 contract ApproveAndCallFallBack {
48     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
49 }
50 
51 
52 // ----------------------------------------------------------------------------
53 // Owned contract
54 // ----------------------------------------------------------------------------
55 contract Owned {
56     address public owner;
57     address public newOwner;
58 
59     event OwnershipTransferred(address indexed _from, address indexed _to);
60 
61     function Owned() public {
62         owner = msg.sender;
63     }
64 
65     modifier onlyOwner {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     function transferOwnership(address _newOwner) public onlyOwner {
71         newOwner = _newOwner;
72     }
73     function acceptOwnership() public {
74         require(msg.sender == newOwner);
75         OwnershipTransferred(owner, newOwner);
76         owner = newOwner;
77         newOwner = address(0);
78     }
79 }
80 
81 
82 // ----------------------------------------------------------------------------
83 // ERC20 Token, with the addition of symbol, name and decimals and assisted
84 // token transfers
85 // ----------------------------------------------------------------------------
86 contract RedBlue is ERC20Interface, Owned, SafeMath {
87     string public symbol;
88     string public  name;
89     uint8 public decimals;
90     uint public _totalSupply;
91 
92     mapping(address => uint) balances;
93     mapping(address => mapping(address => uint)) allowed;
94 
95 
96     // ------------------------------------------------------------------------
97     // Constructor
98     // ------------------------------------------------------------------------
99     function RedBlue() public {
100         symbol = "RB";
101         name = "RedBlue";
102         decimals = 18;
103         _totalSupply = 78000000000000000000000000000;
104         balances[msg.sender] = _totalSupply;
105         Transfer(address(0), msg.sender, _totalSupply);
106     }
107 
108 
109     // ------------------------------------------------------------------------
110     // Total supply
111     // ------------------------------------------------------------------------
112     function totalSupply() public constant returns (uint) {
113         return _totalSupply  - balances[address(0)];
114     }
115 
116 
117     // ------------------------------------------------------------------------
118     // Get the token balance for account tokenOwner
119     // ------------------------------------------------------------------------
120     function balanceOf(address tokenOwner) public constant returns (uint balance) {
121         return balances[tokenOwner];
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Transfer the balance from token owner's account to to account
127     // - Owner's account must have sufficient balance to transfer
128     // - 0 value transfers are allowed
129     // ------------------------------------------------------------------------
130     function transfer(address to, uint tokens) public returns (bool success) {
131         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
132         balances[to] = safeAdd(balances[to], tokens);
133         Transfer(msg.sender, to, tokens);
134         return true;
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Token owner can approve for spender to transferFrom(...) tokens
140     // from the token owner's account
141     //
142     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
143     // recommends that there are no checks for the approval double-spend attack
144     // as this should be implemented in user interfaces 
145     // ------------------------------------------------------------------------
146     function approve(address spender, uint tokens) public returns (bool success) {
147         allowed[msg.sender][spender] = tokens;
148         Approval(msg.sender, spender, tokens);
149         return true;
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Transfer tokens from the from account to the to account
155     // 
156     // The calling account must already have sufficient tokens approve(...)-d
157     // for spending from the from account and
158     // - From account must have sufficient balance to transfer
159     // - Spender must have sufficient allowance to transfer
160     // - 0 value transfers are allowed
161     // ------------------------------------------------------------------------
162     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
163         balances[from] = safeSub(balances[from], tokens);
164         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
165         balances[to] = safeAdd(balances[to], tokens);
166         Transfer(from, to, tokens);
167         return true;
168     }
169 
170 
171     // ------------------------------------------------------------------------
172     // Returns the amount of tokens approved by the owner that can be
173     // transferred to the spender's account
174     // ------------------------------------------------------------------------
175     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
176         return allowed[tokenOwner][spender];
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Token owner can approve for spender to transferFrom(...) tokens
182     // from the token owner's account. The spender contract function
183     // receiveApproval(...) is then executed
184     // ------------------------------------------------------------------------
185     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
186         allowed[msg.sender][spender] = tokens;
187         Approval(msg.sender, spender, tokens);
188         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
189         return true;
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Don't accept ETH
195     // ------------------------------------------------------------------------
196     function () public payable {
197         revert();
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Owner can transfer out any accidentally sent ERC20 tokens
203     // ------------------------------------------------------------------------
204     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
205         return ERC20Interface(tokenAddress).transfer(owner, tokens);
206     }
207 }