1 // ----------------------------------------------------------------------------
2 // 'TAGZ5' Token Contract
3 //
4 // Symbol      : TAGZ5
5 // Name        : TAGZ5
6 // Total supply: 500,000,000
7 // Decimals    : 8
8 //
9 // (c) Tagz Group Pty Ltd ABN#75 632 160 920.
10 // ----------------------------------------------------------------------------
11 
12 // ----------------------------------------------------------------------------
13 // Safe Math
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
37 // ----------------------------------------------------------------------------
38 contract ERC20Interface {
39     function totalSupply() public constant returns (uint);
40     function balanceOf(address tokenOwner) public constant returns (uint balance);
41     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
42     function transfer(address to, uint tokens) public returns (bool success);
43     function approve(address spender, uint tokens) public returns (bool success);
44     function transferFrom(address from, address to, uint tokens) public returns (bool success);
45 
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // Contract function to receive approval and execute function in one call
53 // ----------------------------------------------------------------------------
54 contract ApproveAndCallFallBack {
55     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
56 }
57 
58 
59 // ----------------------------------------------------------------------------
60 // Owned contract
61 // ----------------------------------------------------------------------------
62 contract Owned {
63     address public owner;
64     address public newOwner;
65 
66     event OwnershipTransferred(address indexed _from, address indexed _to);
67 
68     constructor() public {
69         owner = msg.sender;
70     }
71 
72     modifier onlyOwner {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     function transferOwnership(address _newOwner) public onlyOwner {
78         newOwner = _newOwner;
79     }
80     function acceptOwnership() public {
81         require(msg.sender == newOwner);
82         emit OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84         newOwner = address(0);
85     }
86 }
87 
88 
89 // ----------------------------------------------------------------------------
90 // ERC20 Token, with the addition of symbol, name and decimals and assisted
91 // token transfers
92 // ----------------------------------------------------------------------------
93 contract TAGZ5 is ERC20Interface, Owned, SafeMath {
94     string public symbol;
95     string public  name;
96     uint8 public decimals;
97     uint public _totalSupply;
98 
99     mapping(address => uint) balances;
100     mapping(address => mapping(address => uint)) allowed;
101 
102 
103 // ------------------------------------------------------------------------
104 // Constructor
105 // ------------------------------------------------------------------------
106     constructor() public {
107         symbol = "TAGZ5";
108         name = "TAGZ5";
109         decimals = 8;
110         _totalSupply = 50000000000000000;
111         balances[0xED8204345a0Cf4639D2dB61a4877128FE5Cf7599] = _totalSupply;
112         emit Transfer(address(0), 0xED8204345a0Cf4639D2dB61a4877128FE5Cf7599, _totalSupply);
113     }
114 
115 
116 // ------------------------------------------------------------------------
117 // Total Supply
118 // ------------------------------------------------------------------------
119     function totalSupply() public constant returns (uint) {
120         return _totalSupply  - balances[address(0)];
121     }
122 
123 
124 // ------------------------------------------------------------------------
125 // Get the token balance for account tokenOwner
126 // ------------------------------------------------------------------------
127     function balanceOf(address tokenOwner) public constant returns (uint balance) {
128         return balances[tokenOwner];
129     }
130 
131 
132 // ------------------------------------------------------------------------
133 // Transfer the balance from token owner's account to to account
134 // - Owner's account must have sufficient balance to transfer
135 // - 0 value transfers are allowed
136 // ------------------------------------------------------------------------
137     function transfer(address to, uint tokens) public returns (bool success) {
138         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
139         balances[to] = safeAdd(balances[to], tokens);
140         emit Transfer(msg.sender, to, tokens);
141         return true;
142     }
143 
144 
145 // ------------------------------------------------------------------------
146 // Token owner can approve for spender to transferFrom(...) tokens
147 // from the token owner's account
148 // ------------------------------------------------------------------------
149     function approve(address spender, uint tokens) public returns (bool success) {
150         allowed[msg.sender][spender] = tokens;
151         emit Approval(msg.sender, spender, tokens);
152         return true;
153     }
154 
155 
156 // ------------------------------------------------------------------------
157 // Transfer tokens from the from account to the to account
158 // 
159 // The calling account must already have sufficient tokens approve(...)-d
160 // for spending from the from account and
161 // - From account must have sufficient balance to transfer
162 // - Spender must have sufficient allowance to transfer
163 // - 0 value transfers are allowed
164 // ------------------------------------------------------------------------
165     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
166         balances[from] = safeSub(balances[from], tokens);
167         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
168         balances[to] = safeAdd(balances[to], tokens);
169         emit Transfer(from, to, tokens);
170         return true;
171     }
172 
173 
174 // ------------------------------------------------------------------------
175 // Returns the amount of tokens approved by the owner that can be
176 // transferred to the spender's account
177 // ------------------------------------------------------------------------
178     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
179         return allowed[tokenOwner][spender];
180     }
181 
182 
183 // ------------------------------------------------------------------------
184 // Token owner can approve for spender to transferFrom(...) tokens
185 // from the token owner's account. The spender contract function
186 // receiveApproval(...) is then executed
187 // ------------------------------------------------------------------------
188     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
189         allowed[msg.sender][spender] = tokens;
190         emit Approval(msg.sender, spender, tokens);
191         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
192         return true;
193     }
194 
195 
196 // ------------------------------------------------------------------------
197 // Owner can transfer out any accidentally sent ERC20 tokens
198 // ------------------------------------------------------------------------
199     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
200         return ERC20Interface(tokenAddress).transfer(owner, tokens);
201     }
202 
203 
204 // ------------------------------------------------------------------------
205 // Transfer balance to owner
206 // ------------------------------------------------------------------------
207 	function withdrawEther(uint256 amount) {
208 		if(msg.sender != owner)throw;
209 		owner.transfer(amount);
210 	}
211 	
212 // ------------------------------------------------------------------------
213 // Can accept ether
214 // ------------------------------------------------------------------------
215 	function() payable {
216     }
217 }