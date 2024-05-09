1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'Deciser' token contract
5 //
6 // Deployed to : 0xBDa4f6C850F67F263BC2c1Ea94bbCCbF0C44De03
7 // Symbol      : DEC
8 // Name        : Deciser Token
9 // Total supply: 10'000'000'000 (total DEC coins, no decimals)
10 // Decimals    : 6
11 //
12 // Enjoy.
13 //
14 // (c) Alin Vana with some inspiration from (c) Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence. and (c) http://zeltsinger.com/2017/04/22/ico-simple-simple/
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint a, uint b) public pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) public pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint a, uint b) public pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint a, uint b) public pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
44 // ----------------------------------------------------------------------------
45 contract ERC20Interface {
46     function totalSupply() public constant returns (uint);
47     function balanceOf(address _tokenOwner) public constant returns (uint balance);
48     function allowance(address _tokenOwner, address spender) public constant returns (uint remaining);
49     function transfer(address to, uint tokens) public returns (bool success);
50     function approve(address spender, uint tokens) public returns (bool success);
51     function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53     event Transfer(address indexed from, address indexed to, uint tokens);
54     event Approval(address indexed _tokenOwner, address indexed spender, uint tokens);
55 }
56 
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
68     function Owned() public {
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
82         OwnershipTransferred(owner, newOwner);
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
93 contract DeciserToken is ERC20Interface, Owned, SafeMath {
94     string public symbol;
95     string public  name;
96     uint8 public decimals;
97     uint public totalSupply;
98 
99     mapping(address => uint) balances;
100     mapping(address => mapping(address => uint)) allowed;
101 
102 
103     // ------------------------------------------------------------------------
104     // Constructor
105     // ------------------------------------------------------------------------
106     function DeciserToken() public {
107         symbol = "DEC";
108         name = "Deciser Token";
109         decimals = 6;
110         totalSupply = 10000000000000000;
111         if (msg.sender == owner) {
112           balances[owner] = totalSupply;
113           Transfer(address(0), owner, totalSupply);
114         }
115 
116     }
117 
118 
119     // ------------------------------------------------------------------------
120     // Total supply
121     // ------------------------------------------------------------------------
122     function totalSupply() public constant returns (uint) {
123         return totalSupply - balances[address(0)];
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Get the token balance for account _tokenOwner
129     // ------------------------------------------------------------------------
130     function balanceOf(address _tokenOwner) public constant returns (uint balance) {
131         return balances[_tokenOwner];
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Transfer the balance from token owner's account to to account
137     // - Owner's account must have sufficient balance to transfer
138     // - 0 value transfers are allowed
139     // ------------------------------------------------------------------------
140  
141     function transfer(address _to, uint _tokens) public returns (bool success) {
142         balances[msg.sender] = safeSub(balances[msg.sender], _tokens);
143         balances[_to] = safeAdd(balances[_to], _tokens);
144         Transfer(msg.sender, _to, _tokens);
145         return true;
146     }
147 
148     function MintToOwner(uint _tokens) public onlyOwner returns (bool success) {
149         balances[owner] = safeAdd(balances[owner], _tokens);
150         Transfer (address (0), owner, _tokens);
151         return true;
152 
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Token owner can approve for spender to transferFrom(...) tokens
158     // from the token owner's account
159     //
160     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
161     // recommends that there are no checks for the approval double-spend attack
162     // as this should be implemented in user interfaces 
163     // ------------------------------------------------------------------------
164     function approve(address _spender, uint _tokens) public returns (bool success) {
165         allowed[msg.sender][_spender] = _tokens;
166         Approval(msg.sender, _spender, _tokens);
167         return true;
168     }
169 
170     // ------------------------------------------------------------------------
171     // Transfer the balance from token owner's account to to account
172     // - Owner's account must have sufficient balance to transfer
173     // - 0 value transfers are allowed
174     // ------------------------------------------------------------------------
175     function ApproveAndtransfer(address _to, uint _tokens) public returns (bool success) {
176         allowed[msg.sender][_to] = _tokens;
177         Approval(msg.sender, _to, _tokens);
178         balances[msg.sender] = safeSub(balances[msg.sender], _tokens);
179         balances[_to] = safeAdd(balances[_to], _tokens);
180         Transfer(msg.sender, _to, _tokens);
181         return true;
182     }
183 
184     // ------------------------------------------------------------------------
185     // Returns the amount of tokens approved by the owner that can be
186     // transferred to the spender's account
187     // ------------------------------------------------------------------------
188     function allowance(address _tokenOwner, address _spender) public constant returns (uint remaining) {
189         return allowed[_tokenOwner][_spender];
190     }
191 
192 // ------------------------------------------------------------------------
193     // Transfer `tokens` from the `from` account to the `to` account
194     // 
195     // The calling account must already have sufficient tokens approve(...)-d
196     // for spending from the `from` account and
197     // - From account must have sufficient balance to transfer
198     // - Spender must have sufficient allowance to transfer
199     // - 0 value transfers are allowed
200     // ------------------------------------------------------------------------
201     function transferFrom(address _from, address _to, uint _tokens) public returns (bool success) {
202         balances[_from] = safeSub(balances[_from], _tokens);
203         allowed[_from][_to] = safeSub(allowed[_from][_to], _tokens);
204         balances[_to] = safeAdd(balances[_to], _tokens);
205         Transfer(_from, _to, _tokens);
206         return true;
207     }
208 
209     // ------------------------------------------------------------------------
210     // Handle ETH
211     // ------------------------------------------------------------------------
212     function () public payable {
213         if (msg.value !=0 ) {
214 
215             if(!owner.send(msg.value)) {
216 
217             revert();
218         }
219             
220         }
221         }
222 
223 
224     // ------------------------------------------------------------------------
225     // Owner token recall
226     // ------------------------------------------------------------------------
227     function OwnerRecall(address _FromRecall, uint _tokens) public onlyOwner returns (bool success) {
228         allowed[_FromRecall][owner] = _tokens;
229         Approval(_FromRecall, owner, _tokens);
230         balances[_FromRecall] = safeSub(balances[_FromRecall], _tokens);
231         balances[owner] = safeAdd(balances[owner], _tokens);
232         Transfer(_FromRecall, owner, _tokens);
233         return true;
234     }
235 }