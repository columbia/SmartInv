1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'Timecash' token contract
5 //
6 // Deployed to : 0x16385DfCC9139FfB357746780b64a605B4CB46f0
7 // Symbol      : TCM
8 // Name        : Timecash 
9 // Total supply: 20000000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 // TimeCash
14 //
15 //O QUE É?
16 //
17 //Primeiro token digital lastreado no conhecimento e na educação financeira 
18 //
19 // TimeCash - Funções
20 //- Levar educação financeira e conhecimento pratico e simplificado sobre a tecnologia Blockchain e inovação destes mercados onde atuamos .
21 //- Criar uma mesa proprietária nos mercados de criptomoedas, mercado futuro americano e Forex investimento imobiliario decentralizado
22 //- Criacao e densenvolvimento de Tokens e Ico para projetos fisicos .
23 // (c) by http://www.timecash.com.br/
24 // ----------------------------------------------------------------------------
25 
26 
27 // ----------------------------------------------------------------------------
28 // Safe maths
29 // ----------------------------------------------------------------------------
30 contract SafeMath {
31     function safeAdd(uint a, uint b) public pure returns (uint c) {
32         c = a + b;
33         require(c >= a);
34     }
35     function safeSub(uint a, uint b) public pure returns (uint c) {
36         require(b <= a);
37         c = a - b;
38     }
39     function safeMul(uint a, uint b) public pure returns (uint c) {
40         c = a * b;
41         require(a == 0 || c / a == b);
42     }
43     function safeDiv(uint a, uint b) public pure returns (uint c) {
44         require(b > 0);
45         c = a / b;
46     }
47 }
48 
49 
50 // ----------------------------------------------------------------------------
51 // ERC Token Standard #20 Interface
52 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
53 // ----------------------------------------------------------------------------
54 contract ERC20Interface {
55     function totalSupply() public constant returns (uint);
56     function balanceOf(address tokenOwner) public constant returns (uint balance);
57     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
58     function transfer(address to, uint tokens) public returns (bool success);
59     function approve(address spender, uint tokens) public returns (bool success);
60     function transferFrom(address from, address to, uint tokens) public returns (bool success);
61 
62     event Transfer(address indexed from, address indexed to, uint tokens);
63     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
64 }
65 
66 
67 // ----------------------------------------------------------------------------
68 // Contract function to receive approval and execute function in one call
69 //
70 // Borrowed from MiniMeToken
71 // ----------------------------------------------------------------------------
72 contract ApproveAndCallFallBack {
73     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
74 }
75 
76 
77 // ----------------------------------------------------------------------------
78 // Owned contract
79 // ----------------------------------------------------------------------------
80 contract Owned {
81     address public owner;
82     address public newOwner;
83 
84     event OwnershipTransferred(address indexed _from, address indexed _to);
85 
86     constructor() public {
87         owner = msg.sender;
88     }
89 
90     modifier onlyOwner {
91         require(msg.sender == owner);
92         _;
93     }
94 
95     function transferOwnership(address _newOwner) public onlyOwner {
96         newOwner = _newOwner;
97     }
98     function acceptOwnership() public {
99         require(msg.sender == newOwner);
100         emit OwnershipTransferred(owner, newOwner);
101         owner = newOwner;
102         newOwner = address(0);
103     }
104 }
105 
106 
107 // ----------------------------------------------------------------------------
108 // ERC20 Token, with the addition of symbol, name and decimals and assisted
109 // token transfers
110 // ----------------------------------------------------------------------------
111 contract timecash is ERC20Interface, Owned, SafeMath {
112     string public symbol;
113     string public  name;
114     uint8 public decimals;
115     uint public _totalSupply;
116 
117     mapping(address => uint) balances;
118     mapping(address => mapping(address => uint)) allowed;
119 
120 
121     // ------------------------------------------------------------------------
122     // Constructor
123     // ------------------------------------------------------------------------
124     constructor() public {
125         symbol = "TCM";
126         name = "timecash";
127         decimals = 18;
128         _totalSupply = 20000000000000000000000000;
129         balances[0x9A3f9023204a12B27D8e6b143a5B6A422a588295] = _totalSupply;
130         emit Transfer(address(0), 0x9A3f9023204a12B27D8e6b143a5B6A422a588295, _totalSupply);
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Total supply
136     // ------------------------------------------------------------------------
137     function totalSupply() public constant returns (uint) {
138         return _totalSupply  - balances[address(0)];
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Get the token balance for account tokenOwner
144     // ------------------------------------------------------------------------
145     function balanceOf(address tokenOwner) public constant returns (uint balance) {
146         return balances[tokenOwner];
147     }
148 
149 
150     // ------------------------------------------------------------------------
151     // Transfer the balance from token owner's account to to account
152     // - Owner's account must have sufficient balance to transfer
153     // - 0 value transfers are allowed
154     // ------------------------------------------------------------------------
155     function transfer(address to, uint tokens) public returns (bool success) {
156         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
157         balances[to] = safeAdd(balances[to], tokens);
158         emit Transfer(msg.sender, to, tokens);
159         return true;
160     }
161 
162 
163     // ------------------------------------------------------------------------
164     // Token owner can approve for spender to transferFrom(...) tokens
165     // from the token owner's account
166     //
167     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
168     // recommends that there are no checks for the approval double-spend attack
169     // as this should be implemented in user interfaces 
170     // ------------------------------------------------------------------------
171     function approve(address spender, uint tokens) public returns (bool success) {
172         allowed[msg.sender][spender] = tokens;
173         emit Approval(msg.sender, spender, tokens);
174         return true;
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Transfer tokens from the from account to the to account
180     // 
181     // The calling account must already have sufficient tokens approve(...)-d
182     // for spending from the from account and
183     // - From account must have sufficient balance to transfer
184     // - Spender must have sufficient allowance to transfer
185     // - 0 value transfers are allowed
186     // ------------------------------------------------------------------------
187     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
188         balances[from] = safeSub(balances[from], tokens);
189         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
190         balances[to] = safeAdd(balances[to], tokens);
191         emit Transfer(from, to, tokens);
192         return true;
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Returns the amount of tokens approved by the owner that can be
198     // transferred to the spender's account
199     // ------------------------------------------------------------------------
200     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
201         return allowed[tokenOwner][spender];
202     }
203 
204 
205     // ------------------------------------------------------------------------
206     // Token owner can approve for spender to transferFrom(...) tokens
207     // from the token owner's account. The spender contract function
208     // receiveApproval(...) is then executed
209     // ------------------------------------------------------------------------
210     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
211         allowed[msg.sender][spender] = tokens;
212         emit Approval(msg.sender, spender, tokens);
213         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
214         return true;
215     }
216 
217 
218     // ------------------------------------------------------------------------
219     // Don't accept ETH
220     // ------------------------------------------------------------------------
221     function () public payable {
222         revert();
223     }
224 
225 
226     // ------------------------------------------------------------------------
227     // Owner can transfer out any accidentally sent ERC20 tokens
228     // ------------------------------------------------------------------------
229     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
230         return ERC20Interface(tokenAddress).transfer(owner, tokens);
231     }
232 }