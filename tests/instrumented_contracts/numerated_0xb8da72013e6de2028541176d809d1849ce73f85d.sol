1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Desenvolvido por Dynamic Serviços Digitais
5 //
6 // Desenvolvido para: 0x1F1E2225169Cc20Df4697AeAf1bE5073FaEE4cF5 
7 // Símbolo: DMI
8 // Nome: DYNAMIC
9 // Quantidade Total: 1000000000
10 // Decimais: 18
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
35 
36 // ----------------------------------------------------------------------------
37 // ERC Token Standard #20 Interface
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
55 // Borrowed from MiniMeToken
56 // ----------------------------------------------------------------------------
57 contract ApproveAndCallFallBack {
58     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
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
71     constructor() public {
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
85         emit OwnershipTransferred(owner, newOwner);
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
96 contract DYNAMIC is ERC20Interface, Owned, SafeMath {
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
109     constructor() public {
110         symbol = "DMI";
111         name = "DYNAMIC";
112         decimals = 18;
113         _totalSupply = 1000000000000000000000000000;
114         balances[0x1F1E2225169Cc20Df4697AeAf1bE5073FaEE4cF5] = _totalSupply;
115         emit Transfer(address(0), 0x1F1E2225169Cc20Df4697AeAf1bE5073FaEE4cF5, _totalSupply);
116     }
117 
118 
119     // ------------------------------------------------------------------------
120     // Total supply
121     // ------------------------------------------------------------------------
122     function totalSupply() public constant returns (uint) {
123         return _totalSupply  - balances[address(0)];
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Get the token balance for account tokenOwner
129     // ------------------------------------------------------------------------
130     function balanceOf(address tokenOwner) public constant returns (uint balance) {
131         return balances[tokenOwner];
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Transfer the balance from token owner's account to to account
137     // - Owner's account must have sufficient balance to transfer
138     // - 0 value transfers are allowed
139     // ------------------------------------------------------------------------
140     function transfer(address to, uint tokens) public returns (bool success) {
141         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
142         balances[to] = safeAdd(balances[to], tokens);
143         emit Transfer(msg.sender, to, tokens);
144         return true;
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Token owner can approve for spender to transferFrom(...) tokens
150     // from the token owner's account
151    
152     // ------------------------------------------------------------------------
153     function approve(address spender, uint tokens) public returns (bool success) {
154         allowed[msg.sender][spender] = tokens;
155         emit Approval(msg.sender, spender, tokens);
156         return true;
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Transfer tokens from the from account to the to account
162     // 
163     // The calling account must already have sufficient tokens approve(...)-d
164     // for spending from the from account and
165     // - From account must have sufficient balance to transfer
166     // - Spender must have sufficient allowance to transfer
167     // - 0 value transfers are allowed
168     // ------------------------------------------------------------------------
169     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
170         balances[from] = safeSub(balances[from], tokens);
171         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
172         balances[to] = safeAdd(balances[to], tokens);
173         emit Transfer(from, to, tokens);
174         return true;
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Returns the amount of tokens approved by the owner that can be
180     // transferred to the spender's account
181     // ------------------------------------------------------------------------
182     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
183         return allowed[tokenOwner][spender];
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Token owner can approve for spender to transferFrom(...) tokens
189     // from the token owner's account. The spender contract function
190     // receiveApproval(...) is then executed
191     // ------------------------------------------------------------------------
192     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
193         allowed[msg.sender][spender] = tokens;
194         emit Approval(msg.sender, spender, tokens);
195         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
196         return true;
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Don't accept ETH
202     // ------------------------------------------------------------------------
203     function () public payable {
204         revert();
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Owner can transfer out any accidentally sent ERC20 tokens
210     // ------------------------------------------------------------------------
211     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
212         return ERC20Interface(tokenAddress).transfer(owner, tokens);
213     }
214 }