1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'Nautcoins' token contract
5 //
6 // Deployed to : 0x535b3a7011fB46D8D65E6Cd550b780f6557c06f1
7 // Symbol      : NAUT
8 // Name        : Nautcoins
9 // Total supply: 10000000000
10 // Decimals    : 18
11 // Juntes a revolução: Nautcoins
12 // 
13 // https://nautcoins.com/    
14 //
15 // Primeiro portal que une vendedores e compradores de criptomoedas garantido a transação.
16 //
17 // Não interferimos no valor da moeda, você negocia e nós garantimos a transação com seguraça.
18 //
19 // A primeira plataforma de intermediação de compra e venda de moedas entre pessoas com segurança.
20 //
21 // Agora ficou fácil obter mais lucros vendendo sua criptomoeda, com a proteção da NautCoins
22 //
23 //
24 // 
25 // ----------------------------------------------------------------------------
26 
27 
28 // ----------------------------------------------------------------------------
29 // Safe maths
30 // ----------------------------------------------------------------------------
31 contract SafeMath {
32     function safeAdd(uint a, uint b) public pure returns (uint c) {
33         c = a + b;
34         require(c >= a);
35     }
36     function safeSub(uint a, uint b) public pure returns (uint c) {
37         require(b <= a);
38         c = a - b;
39     }
40     function safeMul(uint a, uint b) public pure returns (uint c) {
41         c = a * b;
42         require(a == 0 || c / a == b);
43     }
44     function safeDiv(uint a, uint b) public pure returns (uint c) {
45         require(b > 0);
46         c = a / b;
47     }
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // ERC Token Standard #20 Interface
53 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
54 // ----------------------------------------------------------------------------
55 contract ERC20Interface {
56     function totalSupply() public constant returns (uint);
57     function balanceOf(address tokenOwner) public constant returns (uint balance);
58     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
59     function transfer(address to, uint tokens) public returns (bool success);
60     function approve(address spender, uint tokens) public returns (bool success);
61     function transferFrom(address from, address to, uint tokens) public returns (bool success);
62 
63     event Transfer(address indexed from, address indexed to, uint tokens);
64     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // Contract function to receive approval and execute function in one call
70 //
71 // Borrowed from MiniMeToken
72 // ----------------------------------------------------------------------------
73 contract ApproveAndCallFallBack {
74     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
75 }
76 
77 
78 // ----------------------------------------------------------------------------
79 // Owned contract
80 // ----------------------------------------------------------------------------
81 contract Owned {
82     address public owner;
83     address public newOwner;
84 
85     event OwnershipTransferred(address indexed _from, address indexed _to);
86 
87     constructor() public {
88         owner = msg.sender;
89     }
90 
91     modifier onlyOwner {
92         require(msg.sender == owner);
93         _;
94     }
95 
96     function transferOwnership(address _newOwner) public onlyOwner {
97         newOwner = _newOwner;
98     }
99     function acceptOwnership() public {
100         require(msg.sender == newOwner);
101         emit OwnershipTransferred(owner, newOwner);
102         owner = newOwner;
103         newOwner = address(0);
104     }
105 }
106 
107 
108 // ----------------------------------------------------------------------------
109 // ERC20 Token, with the addition of symbol, name and decimals and assisted
110 // token transfers
111 // ----------------------------------------------------------------------------
112     contract Nautcoins is ERC20Interface, Owned, SafeMath {
113     string public symbol;
114     string public  name;
115     uint8 public decimals;
116     uint public _totalSupply;
117 
118     mapping(address => uint) balances;
119     mapping(address => mapping(address => uint)) allowed;
120 
121 
122     // ------------------------------------------------------------------------
123     // Constructor
124     // ------------------------------------------------------------------------
125     constructor() public {
126         symbol = "NAUT";
127         name = "Nautcoins";
128         decimals = 18;
129         _totalSupply = 10000000000000000000000000000;
130         balances[0x535b3a7011fB46D8D65E6Cd550b780f6557c06f1] = _totalSupply;
131         emit Transfer(address(0),0x535b3a7011fB46D8D65E6Cd550b780f6557c06f1, _totalSupply);
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Total supply
137     // ------------------------------------------------------------------------
138     function totalSupply() public constant returns (uint) {
139         return _totalSupply  - balances[address(0)];
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Get the token balance for account tokenOwner
145     // ------------------------------------------------------------------------
146     function balanceOf(address tokenOwner) public constant returns (uint balance) {
147         return balances[tokenOwner];
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Transfer the balance from token owner's account to to account
153     // - Owner's account must have sufficient balance to transfer
154     // - 0 value transfers are allowed
155     // ------------------------------------------------------------------------
156     function transfer(address to, uint tokens) public returns (bool success) {
157         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
158         balances[to] = safeAdd(balances[to], tokens);
159         emit Transfer(msg.sender, to, tokens);
160         return true;
161     }
162 
163 
164     // ------------------------------------------------------------------------
165     // Token owner can approve for spender to transferFrom(...) tokens
166     // from the token owner's account
167     //
168     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
169     // recommends that there are no checks for the approval double-spend attack
170     // as this should be implemented in user interfaces 
171     // ------------------------------------------------------------------------
172     function approve(address spender, uint tokens) public returns (bool success) {
173         allowed[msg.sender][spender] = tokens;
174         emit Approval(msg.sender, spender, tokens);
175         return true;
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Transfer tokens from the from account to the to account
181     // 
182     // The calling account must already have sufficient tokens approve(...)-d
183     // for spending from the from account and
184     // - From account must have sufficient balance to transfer
185     // - Spender must have sufficient allowance to transfer
186     // - 0 value transfers are allowed
187     // ------------------------------------------------------------------------
188     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
189         balances[from] = safeSub(balances[from], tokens);
190         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
191         balances[to] = safeAdd(balances[to], tokens);
192         emit Transfer(from, to, tokens);
193         return true;
194     }
195 
196 
197     // ------------------------------------------------------------------------
198     // Returns the amount of tokens approved by the owner that can be
199     // transferred to the spender's account
200     // ------------------------------------------------------------------------
201     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
202         return allowed[tokenOwner][spender];
203     }
204 
205 
206     // ------------------------------------------------------------------------
207     // Token owner can approve for spender to transferFrom(...) tokens
208     // from the token owner's account. The spender contract function
209     // receiveApproval(...) is then executed
210     // ------------------------------------------------------------------------
211     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
212         allowed[msg.sender][spender] = tokens;
213         emit Approval(msg.sender, spender, tokens);
214         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
215         return true;
216     }
217 
218 
219     // ------------------------------------------------------------------------
220     // Don't accept ETH
221     // ------------------------------------------------------------------------
222     function () public payable {
223         revert();
224     }
225 
226 
227     // ------------------------------------------------------------------------
228     // Owner can transfer out any accidentally sent ERC20 tokens
229     // ------------------------------------------------------------------------
230     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
231         return ERC20Interface(tokenAddress).transfer(owner, tokens);
232     }
233 }