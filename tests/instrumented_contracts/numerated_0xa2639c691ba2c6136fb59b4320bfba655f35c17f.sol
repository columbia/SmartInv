1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'EBDC MEDICINAL TOKEN' is is an immutable, decentralize and trustable contract for Medicinal Cannabis Community 
5 //
6 // Symbol      : EBDC
7 // Name        : EBDC MEDICINAL CANNABIS 
8 // Total supply: 15000000000
9 // Decimals    : 18
10 //
11 // ----------------------------------------------------------------------------
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
51 // ----------------------------------------------------------------------------
52 // Contract function to receive approval and execute function in one call
53 //
54 // Borrowed from MiniMeToken
55 // ----------------------------------------------------------------------------
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
58 }
59 
60 // ----------------------------------------------------------------------------
61 // Owned contract
62 // ----------------------------------------------------------------------------
63 contract Owned {
64     address public owner;
65     address public newOwner;
66 
67     event OwnershipTransferred(address indexed _from, address indexed _to);
68 
69     constructor() public {
70         owner = msg.sender;
71     }
72 
73     modifier onlyOwner {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     function transferOwnership(address _newOwner) public onlyOwner {
79         newOwner = _newOwner;
80     }
81     function acceptOwnership() public {
82         require(msg.sender == newOwner);
83         emit OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85         newOwner = address(0);
86     }
87 }
88 
89 // ----------------------------------------------------------------------------
90 // ERC20 Token, with the addition of symbol, name and decimals and assisted
91 // token transfers
92 // ----------------------------------------------------------------------------
93 contract EBDCMedicinalCannabisToken is ERC20Interface, Owned, SafeMath {
94     string public symbol;
95     string public  name;
96     uint8 public decimals;
97     uint public _totalSupply;
98 
99     mapping(address => uint) balances;
100     mapping(address => mapping(address => uint)) allowed;
101 
102     // ------------------------------------------------------------------------
103     // Constructor
104     // ------------------------------------------------------------------------
105     constructor() public {
106         symbol = "EBDC";
107         name = "EBDC Medicinal Cannabis";
108         decimals = 18;
109         _totalSupply = 15000000000000000000000000000;
110         balances[0x2F0Ce6F55d8290f9f3F3D80B3a383d48aA5C4C1E] = _totalSupply;
111         emit Transfer(address(0), 0x2F0Ce6F55d8290f9f3F3D80B3a383d48aA5C4C1E, _totalSupply);
112     }
113 
114     // ------------------------------------------------------------------------
115     // Total supply
116     // ------------------------------------------------------------------------
117     function totalSupply() public constant returns (uint) {
118         return _totalSupply  - balances[address(0)];
119     }
120 
121     // ------------------------------------------------------------------------
122     // Get the token balance for account tokenOwner
123     // ------------------------------------------------------------------------
124     function balanceOf(address tokenOwner) public constant returns (uint balance) {
125         return balances[tokenOwner];
126     }
127 
128     // ------------------------------------------------------------------------
129     // Transfer the balance from token owner's account to to account
130     // - Owner's account must have sufficient balance to transfer
131     // - 0 value transfers are allowed
132     // ------------------------------------------------------------------------
133     function transfer(address to, uint tokens) public returns (bool success) {
134         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
135         balances[to] = safeAdd(balances[to], tokens);
136         emit Transfer(msg.sender, to, tokens);
137         return true;
138     }
139 
140     // ------------------------------------------------------------------------
141     // Token owner can approve for spender to transferFrom(...) tokens
142     // from the token owner's account
143     //
144     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
145     // recommends that there are no checks for the approval double-spend attack
146     // as this should be implemented in user interfaces 
147     // ------------------------------------------------------------------------
148     function approve(address spender, uint tokens) public returns (bool success) {
149         allowed[msg.sender][spender] = tokens;
150         emit Approval(msg.sender, spender, tokens);
151         return true;
152     }
153 
154     // ------------------------------------------------------------------------
155     // Transfer tokens from the from account to the to account
156     // 
157     // The calling account must already have sufficient tokens approve(...)-d
158     // for spending from the from account and
159     // - From account must have sufficient balance to transfer
160     // - Spender must have sufficient allowance to transfer
161     // - 0 value transfers are allowed
162     // ------------------------------------------------------------------------
163     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
164         balances[from] = safeSub(balances[from], tokens);
165         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
166         balances[to] = safeAdd(balances[to], tokens);
167         emit Transfer(from, to, tokens);
168         return true;
169     }
170 
171     // ------------------------------------------------------------------------
172     // Returns the amount of tokens approved by the owner that can be
173     // transferred to the spender's account
174     // ------------------------------------------------------------------------
175     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
176         return allowed[tokenOwner][spender];
177     }
178 
179     // ------------------------------------------------------------------------
180     // Token owner can approve for spender to transferFrom(...) tokens
181     // from the token owner's account. The spender contract function
182     // receiveApproval(...) is then executed
183     // ------------------------------------------------------------------------
184     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
185         allowed[msg.sender][spender] = tokens;
186         emit Approval(msg.sender, spender, tokens);
187         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
188         return true;
189     }
190 
191     // ------------------------------------------------------------------------
192     // Don't accept ETH
193     // ------------------------------------------------------------------------
194     function () public payable {
195         revert();
196     }
197 
198     // ------------------------------------------------------------------------
199     // Owner can transfer out any accidentally sent ERC20 tokens
200     // ------------------------------------------------------------------------
201     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
202         return ERC20Interface(tokenAddress).transfer(owner, tokens);
203     }
204 }