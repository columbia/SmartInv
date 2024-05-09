1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 //'AdlerToken' token contract
5 //
6 //Deployed to : 0x53ec8175ab04d9b0AA4606aBFbe148EcbB6a2669
7 //Symbol      : ADLER
8 //Name        : Adler Token
9 //Total supply: 100000000
10 //Decimals    : 18
11 
12 
13 // ----------------------------------------------------------------------------
14 // Safe maths
15 // ----------------------------------------------------------------------------
16 contract SafeMath {
17     function safeAdd(uint a, uint b) public pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function safeSub(uint a, uint b) public pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function safeMul(uint a, uint b) public pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function safeDiv(uint a, uint b) public pure returns (uint c) {
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
72     constructor() public {
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
86         emit OwnershipTransferred(owner, newOwner);
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
97 contract AdlerToken is ERC20Interface, Owned, SafeMath {
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
111         symbol = "ADLER";
112         name = "AdlerToken";
113         decimals = 18;
114         _totalSupply = 100000000000000000000000000;
115         balances[0x53ec8175ab04d9b0AA4606aBFbe148EcbB6a2669] = _totalSupply;
116         emit Transfer(address(0), 0x53ec8175ab04d9b0AA4606aBFbe148EcbB6a2669, _totalSupply);
117     }
118 
119 
120     // ------------------------------------------------------------------------
121     // Total supply
122     // ------------------------------------------------------------------------
123     function totalSupply() public constant returns (uint) {
124         return _totalSupply  - balances[address(0)];
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Get the token balance for account tokenOwner
130     // ------------------------------------------------------------------------
131     function balanceOf(address tokenOwner) public constant returns (uint balance) {
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
144         emit Transfer(msg.sender, to, tokens);
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
159         emit Approval(msg.sender, spender, tokens);
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
177         emit Transfer(from, to, tokens);
178         return true;
179     }
180 
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
198         emit Approval(msg.sender, spender, tokens);
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