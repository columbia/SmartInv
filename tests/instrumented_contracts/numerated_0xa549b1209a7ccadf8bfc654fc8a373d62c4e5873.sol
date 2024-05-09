1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Metadollar' token contract
5 //
6 // Deployed to : 0xeaBB4013f179E42c41468DB81eB1Bd420Da6cC47
7 // Symbol      : MTD
8 // Name        : Metadollar
9 // Total supply: 1000000000000000000000000000000
10 // Decimals    : 18
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 contract SafeMath {
18     function safeAdd(uint a, uint b) public pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function safeSub(uint a, uint b) public pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) public pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function safeDiv(uint a, uint b) public pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 contract ERC20Interface {
38     function totalSupply() public constant returns (uint);
39     function balanceOf(address tokenOwner) public constant returns (uint balance);
40     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
41     function transfer(address to, uint tokens) public returns (bool success);
42     function approve(address spender, uint tokens) public returns (bool success);
43     function transferFrom(address from, address to, uint tokens) public returns (bool success);
44 
45     event Transfer(address indexed from, address indexed to, uint tokens);
46     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
47 }
48 
49 
50 // ----------------------------------------------------------------------------
51 // Contract function to receive approval and execute function in one call
52 // ----------------------------------------------------------------------------
53 contract ApproveAndCallFallBack {
54     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
55 }
56 
57 
58 // ----------------------------------------------------------------------------
59 // Owned contract
60 // ----------------------------------------------------------------------------
61 contract Owned {
62     address public owner;
63     address public newOwner;
64 
65     event OwnershipTransferred(address indexed _from, address indexed _to);
66 
67     function Owned() public {
68         owner = msg.sender;
69     }
70 
71     modifier onlyOwner {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     function transferOwnership(address _newOwner) public onlyOwner {
77         newOwner = _newOwner;
78     }
79     function acceptOwnership() public {
80         require(msg.sender == newOwner);
81         OwnershipTransferred(owner, newOwner);
82         owner = newOwner;
83         newOwner = address(0);
84     }
85 }
86 
87 
88 // ----------------------------------------------------------------------------
89 // ERC20 Token, with the addition of symbol, name and decimals and assisted
90 // token transfers
91 // ----------------------------------------------------------------------------
92 contract Metadollar is ERC20Interface, Owned, SafeMath {
93     string public symbol;
94     string public  name;
95     uint8 public decimals;
96     uint public _totalSupply;
97 
98     mapping(address => uint) balances;
99     mapping(address => mapping(address => uint)) allowed;
100 
101 
102     // ------------------------------------------------------------------------
103     // Constructor
104     // ------------------------------------------------------------------------
105     function Metadollar() public {
106         symbol = "MTD";
107         name = "Metadollar";
108         decimals = 18;
109         _totalSupply = 1000000000000000000000000000000;
110         balances[0xeaBB4013f179E42c41468DB81eB1Bd420Da6cC47] = _totalSupply;
111         Transfer(address(0), 0xeaBB4013f179E42c41468DB81eB1Bd420Da6cC47, _totalSupply);
112     }
113 
114 
115     // ------------------------------------------------------------------------
116     // Total supply
117     // ------------------------------------------------------------------------
118     function totalSupply() public constant returns (uint) {
119         return _totalSupply  - balances[address(0)];
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Get the token balance for account tokenOwner
125     // ------------------------------------------------------------------------
126     function balanceOf(address tokenOwner) public constant returns (uint balance) {
127         return balances[tokenOwner];
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Transfer the balance from token owner's account to to account
133     // - Owner's account must have sufficient balance to transfer
134     // - 0 value transfers are allowed
135     // ------------------------------------------------------------------------
136     function transfer(address to, uint tokens) public returns (bool success) {
137         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
138         balances[to] = safeAdd(balances[to], tokens);
139         Transfer(msg.sender, to, tokens);
140         return true;
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Token owner can approve for spender to transferFrom(...) tokens
146     // from the token owner's account
147     //
148     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
149     // recommends that there are no checks for the approval double-spend attack
150     // as this should be implemented in user interfaces 
151     // ------------------------------------------------------------------------
152     function approve(address spender, uint tokens) public returns (bool success) {
153         allowed[msg.sender][spender] = tokens;
154         Approval(msg.sender, spender, tokens);
155         return true;
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Transfer tokens from the from account to the to account
161     // 
162     // The calling account must already have sufficient tokens approve(...)-d
163     // for spending from the from account and
164     // - From account must have sufficient balance to transfer
165     // - Spender must have sufficient allowance to transfer
166     // - 0 value transfers are allowed
167     // ------------------------------------------------------------------------
168     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
169         balances[from] = safeSub(balances[from], tokens);
170         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
171         balances[to] = safeAdd(balances[to], tokens);
172         Transfer(from, to, tokens);
173         return true;
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Returns the amount of tokens approved by the owner that can be
179     // transferred to the spender's account
180     // ------------------------------------------------------------------------
181     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
182         return allowed[tokenOwner][spender];
183     }
184 
185 
186     // ------------------------------------------------------------------------
187     // Token owner can approve for spender to transferFrom(...) tokens
188     // from the token owner's account. The spender contract function
189     // receiveApproval(...) is then executed
190     // ------------------------------------------------------------------------
191     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
192         allowed[msg.sender][spender] = tokens;
193         Approval(msg.sender, spender, tokens);
194         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
195         return true;
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Don't accept ETH
201     // ------------------------------------------------------------------------
202     function () public payable {
203         revert();
204     }
205 
206 
207     // ------------------------------------------------------------------------
208     // Owner can transfer out any accidentally sent ERC20 tokens
209     // ------------------------------------------------------------------------
210     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
211         return ERC20Interface(tokenAddress).transfer(owner, tokens);
212     }
213 }