1 pragma solidity ^0.4.24;
2 
3 
4 // Deployed to : 0x5A86f0cafD4ef3ba4f0344C138afcC84bd1ED222
5 // Symbol      : FLYD
6 // Name        : Floyd Token
7 // Total supply: 612612612
8 // Decimals    : 18
9 
10 // Math
11 contract SafeMath {
12     function safeAdd(uint a, uint b) public pure returns (uint c) {
13         c = a + b;
14         require(c >= a);
15     }
16     function safeSub(uint a, uint b) public pure returns (uint c) {
17         require(b <= a);
18         c = a - b;
19     }
20     function safeMul(uint a, uint b) public pure returns (uint c) {
21         c = a * b;
22         require(a == 0 || c / a == b);
23     }
24     function safeDiv(uint a, uint b) public pure returns (uint c) {
25         require(b > 0);
26         c = a / b;
27     }
28 }
29 
30 
31 
32 // ERC Standard 
33 contract ERC20Interface {
34     function totalSupply() public view returns (uint);
35     function balanceOf(address tokenOwner) public view returns (uint balance);
36     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
37     function transfer(address to, uint tokens) public returns (bool success);
38     function approve(address spender, uint tokens) public returns (bool success);
39     function transferFrom(address from, address to, uint tokens) public returns (bool success);
40 
41     event Transfer(address indexed from, address indexed to, uint tokens);
42     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
43 }
44 
45 
46 // ----------------------------------------------------------------------------
47 // Contract function to receive approval and execute function in one call
48 //
49 // Borrowed from MiniMeToken
50 // ----------------------------------------------------------------------------
51 contract ApproveAndCallFallBack {
52     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
53 }
54 
55 
56 // ----------------------------------------------------------------------------
57 // Owned contract
58 // ----------------------------------------------------------------------------
59 contract Owned {
60     address public owner;
61     address public newOwner;
62 
63     event OwnershipTransferred(address indexed _from, address indexed _to);
64 
65     constructor() public {
66         owner = msg.sender;
67     }
68 
69     modifier onlyOwner {
70         require(msg.sender == owner);
71         _;
72     }
73 
74     function transferOwnership(address _newOwner) public onlyOwner {
75         newOwner = _newOwner;
76     }
77     function acceptOwnership() public {
78         require(msg.sender == newOwner);
79         emit OwnershipTransferred(owner, newOwner);
80         owner = newOwner;
81         newOwner = address(0);
82     }
83 }
84 
85 
86 // ----------------------------------------------------------------------------
87 // ERC20 Token, with the addition of symbol, name and decimals and assisted
88 // token transfers
89 // ----------------------------------------------------------------------------
90 contract FloydToken is ERC20Interface, Owned, SafeMath {
91     string public symbol;
92     string public  name;
93     uint8 public decimals;
94     uint public _totalSupply;
95 
96     mapping(address => uint) balances;
97     mapping(address => mapping(address => uint)) allowed;
98 
99 
100     // ------------------------------------------------------------------------
101     // Constructor
102     // ------------------------------------------------------------------------
103     constructor() public {
104         symbol = "FLYD";
105         name = "George Floyd Token";
106         decimals = 18;
107         _totalSupply = 612000000000000000000000000;
108         balances[0x13F28e33888141d7DFE81c5061d237C8320768ed] = _totalSupply;
109         emit Transfer(address(0), 0x13F28e33888141d7DFE81c5061d237C8320768ed, _totalSupply);
110     }
111 
112 
113     // ------------------------------------------------------------------------
114     // Total supply
115     // ------------------------------------------------------------------------
116     function totalSupply() public view returns (uint) {
117         return _totalSupply  - balances[address(0)];
118     }
119 
120 
121     // ------------------------------------------------------------------------
122     // Get the token balance for account tokenOwner
123     // ------------------------------------------------------------------------
124     function balanceOf(address tokenOwner) public view returns (uint balance) {
125         return balances[tokenOwner];
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Transfer the balance from token owner's account to to account
131     // - Owner's account must have sufficient balance to transfer
132     // - 0 value transfers are allowed
133     // ------------------------------------------------------------------------
134     function transfer(address to, uint tokens) public returns (bool success) {
135         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
136         balances[to] = safeAdd(balances[to], tokens);
137         emit Transfer(msg.sender, to, tokens);
138         return true;
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Token owner can approve for spender to transferFrom(...) tokens
144     // from the token owner's account
145     //
146     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
147     // recommends that there are no checks for the approval double-spend attack
148     // as this should be implemented in user interfaces 
149     // ------------------------------------------------------------------------
150     function approve(address spender, uint tokens) public returns (bool success) {
151         allowed[msg.sender][spender] = tokens;
152         emit Approval(msg.sender, spender, tokens);
153         return true;
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Transfer tokens from the from account to the to account
159     // 
160     // The calling account must already have sufficient tokens approve(...)-d
161     // for spending from the from account and
162     // - From account must have sufficient balance to transfer
163     // - Spender must have sufficient allowance to transfer
164     // - 0 value transfers are allowed
165     // ------------------------------------------------------------------------
166     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
167         balances[from] = safeSub(balances[from], tokens);
168         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
169         balances[to] = safeAdd(balances[to], tokens);
170         emit Transfer(from, to, tokens);
171         return true;
172     }
173 
174 
175     // ------------------------------------------------------------------------
176     // Returns the amount of tokens approved by the owner that can be
177     // transferred to the spender's account
178     // ------------------------------------------------------------------------
179     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
180         return allowed[tokenOwner][spender];
181     }
182 
183 
184     // ------------------------------------------------------------------------
185     // Token owner can approve for spender to transferFrom(...) tokens
186     // from the token owner's account. The spender contract function
187     // receiveApproval(...) is then executed
188     // ------------------------------------------------------------------------
189     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
190         allowed[msg.sender][spender] = tokens;
191         emit Approval(msg.sender, spender, tokens);
192         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
193         return true;
194     }
195 
196 
197     // ------------------------------------------------------------------------
198     // Don't accept ETH
199     // ------------------------------------------------------------------------
200     function () public payable {
201         revert();
202     }
203 
204 
205     // ------------------------------------------------------------------------
206     // Owner can transfer out any accidentally sent ERC20 tokens
207     // ------------------------------------------------------------------------
208     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
209         return ERC20Interface(tokenAddress).transfer(owner, tokens);
210     }
211 }