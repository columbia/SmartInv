1 pragma solidity 0.4.24;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Safe maths
6 // ----------------------------------------------------------------------------
7 contract SafeMath {
8     function safeAdd(uint a, uint b) public pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function safeSub(uint a, uint b) public pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function safeMul(uint a, uint b) public pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function safeDiv(uint a, uint b) public pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 
27 // ----------------------------------------------------------------------------
28 // ERC Token Standard #20 Interface
29 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
30 // ----------------------------------------------------------------------------
31 contract ERC20Interface {
32     function totalSupply() public constant returns (uint);
33     function balanceOf(address tokenOwner) public constant returns (uint balance);
34     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
35     function transfer(address to, uint tokens) public returns (bool success);
36     function approve(address spender, uint tokens) public returns (bool success);
37     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38 
39     event Transfer(address indexed from, address indexed to, uint tokens);
40     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41 }
42 
43 
44 // ----------------------------------------------------------------------------
45 // Contract function to receive approval and execute function in one call
46 //
47 // Borrowed from MiniMeToken
48 // ----------------------------------------------------------------------------
49 contract ApproveAndCallFallBack {
50     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Owned contract
56 // ----------------------------------------------------------------------------
57 contract Owned {
58     address public owner;
59     address public newOwner;
60 
61     event OwnershipTransferred(address indexed _from, address indexed _to);
62 
63     constructor() public {
64         owner = msg.sender;
65     }
66 
67     modifier onlyOwner {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     function transferOwnership(address _newOwner) public onlyOwner {
73         newOwner = _newOwner;
74     }
75     function acceptOwnership() public {
76         require(msg.sender == newOwner);
77         emit OwnershipTransferred(owner, newOwner);
78         owner = newOwner;
79         newOwner = address(0);
80     }
81 }
82 
83 
84 // ----------------------------------------------------------------------------
85 // ERC20 Token, with the addition of symbol, name and decimals and assisted
86 // token transfers
87 // ----------------------------------------------------------------------------
88 contract UniverseCoin is ERC20Interface, Owned, SafeMath {
89     string public businessName;
90     string public businessCountry;
91     string public businessRegistryNumber;
92     string public symbol;
93     string public  name;
94     uint8 public decimals;
95     uint public _totalSupply;
96 
97     mapping(address => uint) balances;
98     mapping(address => mapping(address => uint)) allowed;
99 
100 
101     // ------------------------------------------------------------------------
102     // Constructor
103     // ------------------------------------------------------------------------
104     constructor() public {
105         businessName = "LATTITUDEMUNDI UNIPESSOAL LDA.";
106         businessCountry = 'PORTUGAL';
107         businessRegistryNumber = '513761926';
108         symbol = "UNIS";
109         name = "Universe Coin";
110         decimals = 18;
111         _totalSupply = 10000000000000000000000000000;
112         balances[0x8257d6BB72e0D92bc8aF19cfAFE99847351a8503] = _totalSupply;
113         emit Transfer(address(0), 0x8257d6BB72e0D92bc8aF19cfAFE99847351a8503, _totalSupply);
114 
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Total supply
120     // ------------------------------------------------------------------------
121     function totalSupply() public constant returns (uint) {
122         return _totalSupply  - balances[address(0)];
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Get the token balance for account tokenOwner
128     // ------------------------------------------------------------------------
129     function balanceOf(address tokenOwner) public constant returns (uint balance) {
130         return balances[tokenOwner];
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Transfer the balance from token owner's account to to account
136     // - Owner's account must have sufficient balance to transfer
137     // - 0 value transfers are allowed
138     // ------------------------------------------------------------------------
139     function transfer(address to, uint tokens) public returns (bool success) {
140         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
141         balances[to] = safeAdd(balances[to], tokens);
142         emit Transfer(msg.sender, to, tokens);
143         return true;
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Token owner can approve for spender to transferFrom(...) tokens
149     // from the token owner's account
150     //
151     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
152     // recommends that there are no checks for the approval double-spend attack
153     // as this should be implemented in user interfaces 
154     // ------------------------------------------------------------------------
155     function approve(address spender, uint tokens) public returns (bool success) {
156         allowed[msg.sender][spender] = tokens;
157         emit Approval(msg.sender, spender, tokens);
158         return true;
159     }
160 
161 
162     // ------------------------------------------------------------------------
163     // Transfer tokens from the from account to the to account
164     // 
165     // The calling account must already have sufficient tokens approve(...)-d
166     // for spending from the from account and
167     // - From account must have sufficient balance to transfer
168     // - Spender must have sufficient allowance to transfer
169     // - 0 value transfers are allowed
170     // ------------------------------------------------------------------------
171     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
172         balances[from] = safeSub(balances[from], tokens);
173         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
174         balances[to] = safeAdd(balances[to], tokens);
175         emit Transfer(from, to, tokens);
176         return true;
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Returns the amount of tokens approved by the owner that can be
182     // transferred to the spender's account
183     // ------------------------------------------------------------------------
184     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
185         return allowed[tokenOwner][spender];
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Token owner can approve for spender to transferFrom(...) tokens
191     // from the token owner's account. The spender contract function
192     // receiveApproval(...) is then executed
193     // ------------------------------------------------------------------------
194     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
195         allowed[msg.sender][spender] = tokens;
196         emit Approval(msg.sender, spender, tokens);
197         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
198         return true;
199     }
200 
201 
202     // ------------------------------------------------------------------------
203     // Don't accept ETH
204     // ------------------------------------------------------------------------
205     function () public payable {
206         revert();
207     }
208 
209 
210     // ------------------------------------------------------------------------
211     // Owner can transfer out any accidentally sent ERC20 tokens
212     // ------------------------------------------------------------------------
213     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
214         return ERC20Interface(tokenAddress).transfer(owner, tokens);
215     }
216 }