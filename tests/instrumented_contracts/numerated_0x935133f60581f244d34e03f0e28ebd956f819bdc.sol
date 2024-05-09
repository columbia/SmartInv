1 // ----------------------------------------------------------------------------
2 // Issued by Solidus Limited
3 // Melbourne House Suite 301
4 // 11 Parliament Street
5 // Bermuda HM 11
6 // +4412972326
7 // info@solidus.bm
8 // ----------------------------------------------------------------------------
9 
10 
11 
12 // ----------------------------------------------------------------------------
13 // Safe maths
14 // ----------------------------------------------------------------------------
15 contract SafeMath {
16     function safeAdd(uint a, uint b) public pure returns (uint c) {
17         c = a + b;
18         require(c >= a);
19     }
20     function safeSub(uint a, uint b) public pure returns (uint c) {
21         require(b <= a);
22         c = a - b;
23     }
24     function safeMul(uint a, uint b) public pure returns (uint c) {
25         c = a * b;
26         require(a == 0 || c / a == b);
27     }
28     function safeDiv(uint a, uint b) public pure returns (uint c) {
29         require(b > 0);
30         c = a / b;
31     }
32 }
33 
34 
35 // ----------------------------------------------------------------------------
36 // ERC Token Standard #20 Interface
37 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
38 // ----------------------------------------------------------------------------
39 contract ERC20Interface {
40     function totalSupply() public view returns (uint);
41     function balanceOf(address tokenOwner) public view returns (uint balance);
42     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
43     function transfer(address to, uint tokens) public returns (bool success);
44     function approve(address spender, uint tokens) public returns (bool success);
45     function transferFrom(address from, address to, uint tokens) public returns (bool success);
46 
47     event Transfer(address indexed from, address indexed to, uint tokens);
48     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
49 }
50 
51 
52 // ----------------------------------------------------------------------------
53 // Contract function to receive approval and execute function in one call
54 //
55 // Borrowed from MiniMeToken
56 // ----------------------------------------------------------------------------
57 contract ApproveAndCallFallBack {
58     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
59 }
60 
61 
62 // ----------------------------------------------------------------------------
63 // Owned contract
64 // ----------------------------------------------------------------------------
65 contract Owned {
66     address public owner;
67     address public newOwner;
68 
69     event OwnershipTransferred(address indexed _from, address indexed _to);
70 
71     function Owned2() public {
72         owner = msg.sender;
73     }
74 
75     modifier onlyOwner {
76         require(msg.sender == owner);
77         _;
78     }
79 
80     function transferOwnership(address _newOwner) public onlyOwner {
81         newOwner = _newOwner;
82     }
83     function acceptOwnership() public {
84         require(msg.sender == newOwner);
85         OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87         newOwner = address(0);
88     }
89 }
90 
91 
92 // ----------------------------------------------------------------------------
93 // ERC20 Token, with the addition of symbol, name and decimals and assisted
94 // token transfers
95 // ----------------------------------------------------------------------------
96 contract MOTH is ERC20Interface, Owned, SafeMath {
97     string public symbol;
98     string public  name;
99     uint8 public decimals;
100     uint public _totalSupply;
101 
102     mapping(address => uint) balances;
103     mapping(address => mapping(address => uint)) allowed;
104 
105 
106     // ------------------------------------------------------------------------
107     // Constructor
108     // ------------------------------------------------------------------------
109     function MOTH() public {
110         symbol = "MOTH";
111         name = "Crypto MOTH";
112         decimals = 8;
113         _totalSupply = 	1000000000000000000;
114         balances[0x2a8F8e7C76eD23535673f03D7789d2a0e753Fc93] = _totalSupply;
115         Transfer(address(0), 0x2a8F8e7C76eD23535673f03D7789d2a0e753Fc93, _totalSupply);
116         
117     }
118 
119 
120     // ------------------------------------------------------------------------
121     // Total supply
122     // ------------------------------------------------------------------------
123     function totalSupply() public view returns (uint) {
124         return _totalSupply  - balances[address(0)];
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Get the token balance for account tokenOwner
130     // ------------------------------------------------------------------------
131     function balanceOf(address tokenOwner) public view returns (uint balance) {
132         return balances[tokenOwner];
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Transfer the balance from token owner's account to to account
138     // - Owner's account must have sufficient balance to transfer
139     // - 0 value transfers are allowed
140     // ------------------------------------------------------------------------
141     function transfer(address to, uint tokens) public returns (bool success) {
142         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
143         balances[to] = safeAdd(balances[to], tokens);
144         Transfer(msg.sender, to, tokens);
145         return true;
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Token owner can approve for spender to transferFrom(...) tokens
151     // from the token owner's account
152     //
153     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
154     // recommends that there are no checks for the approval double-spend attack
155     // as this should be implemented in user interfaces 
156     // ------------------------------------------------------------------------
157     function approve(address spender, uint tokens) public returns (bool success) {
158         allowed[msg.sender][spender] = tokens;
159         Approval(msg.sender, spender, tokens);
160         return true;
161     }
162 
163 
164     // ------------------------------------------------------------------------
165     // Transfer tokens from the from account to the to account
166     // 
167     // The calling account must already have sufficient tokens approve(...)-d
168     // for spending from the from account and
169     // - From account must have sufficient balance to transfer
170     // - Spender must have sufficient allowance to transfer
171     // - 0 value transfers are allowed
172     // ------------------------------------------------------------------------
173     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
174         balances[from] = safeSub(balances[from], tokens);
175         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
176         balances[to] = safeAdd(balances[to], tokens);
177         Transfer(from, to, tokens);
178         return true;
179     }
180 
181 
182     // ------------------------------------------------------------------------
183     // Returns the amount of tokens approved by the owner that can be
184     // transferred to the spender's account
185     // ------------------------------------------------------------------------
186     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
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