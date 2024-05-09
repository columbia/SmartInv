1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7     function safeAdd(uint a, uint b) public pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint a, uint b) public pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint a, uint b) public pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint a, uint b) public pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // ----------------------------------------------------------------------------
29 
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
45 // Borrowed from MiniMeToken
46 // ----------------------------------------------------------------------------
47 contract ApproveAndCallFallBack {
48     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
49 }
50 
51 // ----------------------------------------------------------------------------
52 // Owned contract
53 // ----------------------------------------------------------------------------
54 contract Owned {
55     address public owner;
56     address public newOwner;
57 
58     event OwnershipTransferred(address indexed _from, address indexed _to);
59 
60     function Owned() public {
61         owner = msg.sender;
62     }
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function transferOwnership(address _newOwner) public onlyOwner {
70         newOwner = _newOwner;
71     }
72     function acceptOwnership() public {
73         require(msg.sender == newOwner);
74         OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76         newOwner = address(0);
77     }
78 }
79 
80 
81 // ----------------------------------------------------------------------------
82 // ERC20 Token, with the addition of symbol, name and decimals and assisted
83 // token transfers
84 // ----------------------------------------------------------------------------
85 
86 contract Uptrennd is ERC20Interface, Owned, SafeMath {
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
99 
100     function Uptrennd() public {
101         symbol = "1UP";
102         name = "Uptrennd";
103         decimals = 18;
104         _totalSupply = 10000000000000000000000000000;
105         balances[0x596023cEAb4529f7002Fab33AE030a062e43a516] = _totalSupply;
106         Transfer(address(0), 0x596023cEAb4529f7002Fab33AE030a062e43a516, _totalSupply);
107     }
108 
109 
110     // ------------------------------------------------------------------------
111     // Total supply
112     // ------------------------------------------------------------------------
113 
114     function totalSupply() public constant returns (uint) {
115         return _totalSupply  - balances[address(0)];
116     }
117 
118    
119     // ------------------------------------------------------------------------
120     // Get the token balance for account tokenOwner
121     // ------------------------------------------------------------------------
122 
123     function balanceOf(address tokenOwner) public constant returns (uint balance) {
124         return balances[tokenOwner];
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Transfer the balance from token owner's account to to account
130     // - Owner's account must have sufficient balance to transfer
131     // - 0 value transfers are allowed
132     // ------------------------------------------------------------------------
133 
134     function transfer(address to, uint tokens) public returns (bool success) {
135         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
136         balances[to] = safeAdd(balances[to], tokens);
137         Transfer(msg.sender, to, tokens);
138         return true;
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Token owner can approve for spender to transferFrom(...) tokens
144     // from the token owner's account
145     // recommends that there are no checks for the approval double-spend attack
146     // as this should be implemented in user interfaces 
147     // ------------------------------------------------------------------------
148 
149     function approve(address spender, uint tokens) public returns (bool success) {
150         allowed[msg.sender][spender] = tokens;
151         Approval(msg.sender, spender, tokens);
152         return true;
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Transfer tokens from the from account to the to account
158     // 
159     // The calling account must already have sufficient tokens approve(...)-d
160     // for spending from the from account and
161     // - From account must have sufficient balance to transfer
162     // - Spender must have sufficient allowance to transfer
163     // - 0 value transfers are allowed
164     // ------------------------------------------------------------------------
165     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
166         balances[from] = safeSub(balances[from], tokens);
167         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
168         balances[to] = safeAdd(balances[to], tokens);
169         Transfer(from, to, tokens);
170         return true;
171     }
172  // ---------------------------------------------------------------------------
173     // Burn token
174     // ---------------------------------------------------------------------------
175 
176     function burn(uint256 _value , uint tokens) public returns (bool success) {
177         balances[msg.sender] = safeSub(balances[msg.sender], tokens);  // Check if the sender has enough
178         _totalSupply -= _value;                      // Updates totalSupply
179         return true;
180     }
181 
182     // ------------------------------------------------------------------------
183     // Returns the amount of tokens approved by the owner that can be
184     // transferred to the spender's account
185     // ------------------------------------------------------------------------
186     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
187         return allowed[tokenOwner][spender];
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Token owner can approve for spender to transferFrom(...) tokens
193     // from the token owner's account. The spender contract function
194     // receiveApproval(...) is then executed
195     // ------------------------------------------------------------------------
196     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
197         allowed[msg.sender][spender] = tokens;
198         Approval(msg.sender, spender, tokens);
199         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
200         return true;
201     }
202 
203 
204     // ------------------------------------------------------------------------
205     // Don't accept ETH
206     // ------------------------------------------------------------------------
207     function () public payable {
208         revert();
209     }
210 
211 
212     // ------------------------------------------------------------------------
213     // Owner can transfer out any accidentally sent ERC20 tokens
214     // ------------------------------------------------------------------------
215     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
216         return ERC20Interface(tokenAddress).transfer(owner, tokens);
217     }
218 }