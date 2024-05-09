1 /**
2  *Name: Litecoin SV 
3  *Symbol : LSV
4  *Total Supply : 25 Million
5  *Compiler Version v0.4.24+commit.e67f0147
6  *Optimization No
7 */
8 
9 pragma solidity 0.4.24;
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
40     function totalSupply() public constant returns (uint);
41     function balanceOf(address tokenOwner) public constant returns (uint balance);
42     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
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
55 // ----------------------------------------------------------------------------
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // Owned contract
63 // ----------------------------------------------------------------------------
64 contract Owned {
65     address public owner;
66     address public newOwner;
67 
68     event OwnershipTransferred(address indexed _from, address indexed _to);
69 
70     constructor() public {
71         owner = msg.sender;
72     }
73 
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     function transferOwnership(address _newOwner) public onlyOwner {
80         newOwner = _newOwner;
81     }
82     function acceptOwnership() public {
83         require(msg.sender == newOwner);
84         emit OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86         newOwner = address(0);
87     }
88 }
89 
90 
91 // ----------------------------------------------------------------------------
92 // ERC20 Token, with the addition of symbol, name and decimals and assisted
93 // token transfers
94 // ----------------------------------------------------------------------------
95 contract Litecoin_SV is ERC20Interface, Owned, SafeMath {
96     string public businessName;
97     string public businessCountry;
98     string public symbol;
99     string public  name;
100     uint8 public decimals;
101     uint public _totalSupply;
102 
103     mapping(address => uint) balances;
104     mapping(address => mapping(address => uint)) allowed;
105 
106 
107     // ------------------------------------------------------------------------
108     // Constructor
109     // ------------------------------------------------------------------------
110     constructor() public {
111         businessName = "Litecoin SV LLC.";
112         businessCountry = 'SG';
113         symbol = "LSV";
114         name = "Litecoin SV";
115         decimals = 18;
116         _totalSupply = 25000000000000000000000000;
117         balances[0x300183D6226353F45aE922Daf984c0f6d178B20b] = _totalSupply;
118         emit Transfer(address(0), 0x300183D6226353F45aE922Daf984c0f6d178B20b, _totalSupply);
119 
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Total supply
125     // ------------------------------------------------------------------------
126     function totalSupply() public constant returns (uint) {
127         return _totalSupply  - balances[address(0)];
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Get the token balance for account tokenOwner
133     // ------------------------------------------------------------------------
134     function balanceOf(address tokenOwner) public constant returns (uint balance) {
135         return balances[tokenOwner];
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Transfer the balance from token owner's account to to account
141     // - Owner's account must have sufficient balance to transfer
142     // - 0 value transfers are allowed
143     // ------------------------------------------------------------------------
144     function transfer(address to, uint tokens) public returns (bool success) {
145         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
146         balances[to] = safeAdd(balances[to], tokens);
147         emit Transfer(msg.sender, to, tokens);
148         return true;
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Token owner can approve for spender to transferFrom(...) tokens
154     // from the token owner's account
155     //
156     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
157     // recommends that there are no checks for the approval double-spend attack
158     // as this should be implemented in user interfaces 
159     // ------------------------------------------------------------------------
160     function approve(address spender, uint tokens) public returns (bool success) {
161         allowed[msg.sender][spender] = tokens;
162         emit Approval(msg.sender, spender, tokens);
163         return true;
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Transfer tokens from the from account to the to account
169     // 
170     // The calling account must already have sufficient tokens approve(...)-d
171     // for spending from the from account and
172     // - From account must have sufficient balance to transfer
173     // - Spender must have sufficient allowance to transfer
174     // - 0 value transfers are allowed
175     // ------------------------------------------------------------------------
176     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
177         balances[from] = safeSub(balances[from], tokens);
178         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
179         balances[to] = safeAdd(balances[to], tokens);
180         emit Transfer(from, to, tokens);
181         return true;
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Returns the amount of tokens approved by the owner that can be
187     // transferred to the spender's account
188     // ------------------------------------------------------------------------
189     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
190         return allowed[tokenOwner][spender];
191     }
192 
193 
194     // ------------------------------------------------------------------------
195     // Token owner can approve for spender to transferFrom(...) tokens
196     // from the token owner's account. The spender contract function
197     // receiveApproval(...) is then executed
198     // ------------------------------------------------------------------------
199     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
200         allowed[msg.sender][spender] = tokens;
201         emit Approval(msg.sender, spender, tokens);
202         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
203         return true;
204     }
205 
206 
207     // ------------------------------------------------------------------------
208     // 
209     // ------------------------------------------------------------------------
210     function () public payable {
211         revert();
212     }
213 
214 
215     // ------------------------------------------------------------------------
216     // Owner can transfer out any accidentally sent ERC20 tokens
217     // ------------------------------------------------------------------------
218     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
219         return ERC20Interface(tokenAddress).transfer(owner, tokens);
220     }
221 }