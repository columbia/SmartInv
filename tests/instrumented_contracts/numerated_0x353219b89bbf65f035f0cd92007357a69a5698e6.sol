1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'GOLDBARTOKEN' CROWDSALE token contract
5 //
6 // Deployed to : 0xD0FDf2ECd4CadE671a7EE1063393eC0eB90816FD
7 // Symbol      : GBT
8 // Name        : GOLD Token
9 // Total supply: 2000000000
10 // Decimals    : 18
11 
12 
13 // ----------------------------------------------------------------------------
14 // Safe maths
15 // ----------------------------------------------------------------------------
16 contract SafeMath {
17     function safeAdd(uint a, uint b) internal pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function safeSub(uint a, uint b) internal pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function safeMul(uint a, uint b) internal pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function safeDiv(uint a, uint b) internal pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32     }
33 }
34 
35 
36 // ----------------------------------------------------------------------------
37 // ERC Token Standard #20 Interface
38 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() public constant returns (uint);
42     function balanceOf(address tokenOwner) public constant returns (uint balance);
43     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
44     function transfer(address to, uint tokens) public returns (bool success);
45     function approve(address spender, uint tokens) public returns (bool success);
46     function transferFrom(address from, address to, uint tokens) public returns (bool success);
47 
48     event Transfer(address indexed from, address indexed to, uint tokens);
49     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Contract function to receive approval and execute function in one call
55 //
56 // Borrowed from MiniMeToken
57 // ----------------------------------------------------------------------------
58 contract ApproveAndCallFallBack {
59     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
60 }
61 
62 
63 // ----------------------------------------------------------------------------
64 // Owned contract
65 // ----------------------------------------------------------------------------
66 contract Owned {
67     address public owner;
68     address public newOwner;
69 
70     event OwnershipTransferred(address indexed _from, address indexed _to);
71 
72     function Owned() public {
73         owner = msg.sender;
74     }
75 
76     modifier onlyOwner {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     function transferOwnership(address _newOwner) public onlyOwner {
82         newOwner = _newOwner;
83     }
84     function acceptOwnership() public {
85         require(msg.sender == newOwner);
86         OwnershipTransferred(owner, newOwner);
87         owner = newOwner;
88         newOwner = address(0);
89     }
90 }
91 
92 
93 // ----------------------------------------------------------------------------
94 // ERC20 Token, with the addition of symbol, name and decimals and assisted
95 // token transfers
96 // ----------------------------------------------------------------------------
97 contract GOLDBARToken is ERC20Interface, Owned, SafeMath {
98     string public symbol;
99     string public  name;
100     uint8 public decimals;
101     uint public _totalSupply;
102     uint public startDate;
103     uint public endDate;
104 
105     mapping(address => uint) balances;
106     mapping(address => mapping(address => uint)) allowed;
107 
108 
109     // ------------------------------------------------------------------------
110     // Constructor
111     // ------------------------------------------------------------------------
112     function GOLDBARToken() public {
113         symbol = "GBT";
114         name = "GOLDBAR Token";
115         decimals = 18;
116         endDate = now + 7 weeks;
117 
118     }
119 
120 
121     // ------------------------------------------------------------------------
122     // Total supply
123     // ------------------------------------------------------------------------
124     function totalSupply() public constant returns (uint) {
125         return _totalSupply  - balances[address(0)];
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Get the token balance for account `tokenOwner`
131     // ------------------------------------------------------------------------
132     function balanceOf(address tokenOwner) public constant returns (uint balance) {
133         return balances[tokenOwner];
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Transfer the balance from token owner's account to `to` account
139     // - Owner's account must have sufficient balance to transfer
140     // - 0 value transfers are allowed
141     // ------------------------------------------------------------------------
142     function transfer(address to, uint tokens) public returns (bool success) {
143         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
144         balances[to] = safeAdd(balances[to], tokens);
145         Transfer(msg.sender, to, tokens);
146         return true;
147     }
148 
149 
150     // ------------------------------------------------------------------------
151     // Token owner can approve for `spender` to transferFrom(...) `tokens`
152     // from the token owner's account
153     //
154     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
155     // recommends that there are no checks for the approval double-spend attack
156     // as this should be implemented in user interfaces
157     // ------------------------------------------------------------------------
158     function approve(address spender, uint tokens) public returns (bool success) {
159         allowed[msg.sender][spender] = tokens;
160         Approval(msg.sender, spender, tokens);
161         return true;
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Transfer `tokens` from the `from` account to the `to` account
167     //
168     // The calling account must already have sufficient tokens approve(...)-d
169     // for spending from the `from` account and
170     // - From account must have sufficient balance to transfer
171     // - Spender must have sufficient allowance to transfer
172     // - 0 value transfers are allowed
173     // ------------------------------------------------------------------------
174     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
175         balances[from] = safeSub(balances[from], tokens);
176         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
177         balances[to] = safeAdd(balances[to], tokens);
178         Transfer(from, to, tokens);
179         return true;
180     }
181 
182 
183     // ------------------------------------------------------------------------
184     // Returns the amount of tokens approved by the owner that can be
185     // transferred to the spender's account
186     // ------------------------------------------------------------------------
187     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
188         return allowed[tokenOwner][spender];
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Token owner can approve for `spender` to transferFrom(...) `tokens`
194     // from the token owner's account. The `spender` contract function
195     // `receiveApproval(...)` is then executed
196     // ------------------------------------------------------------------------
197     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
198         allowed[msg.sender][spender] = tokens;
199         Approval(msg.sender, spender, tokens);
200         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
201         return true;
202     }
203 
204     // ------------------------------------------------------------------------
205     // 2,000,000 GBT Tokens per 0.02 ETH
206     // ------------------------------------------------------------------------
207     function () public payable {
208         require(now >= startDate && now <= endDate);
209         uint tokens;
210           {
211             tokens = msg.value *2000000;
212             }
213         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
214         _totalSupply = safeAdd(_totalSupply, tokens);
215         Transfer(address(0), msg.sender, tokens);
216         owner.transfer(msg.value);
217     } 
218      function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
219         return ERC20Interface(tokenAddress).transfer(owner, tokens);
220     }
221 }