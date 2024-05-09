1 // 'GeXCHANGE' token contract
2 //
3 // Deployed to : 0xf82bd0F91D4b5A9f96287363A3534C81Cdb94afA
4 // Symbol      : GEXEC
5 // Name        : GeXCHANGE
6 // Total supply: 400000000
7 // Decimals    : 18
8 
9 
10 
11 
12 // Safe maths
13 
14 contract SafeMath {
15     function safeAdd(uint a, uint b) public pure returns (uint c) {
16         c = a + b;
17         require(c >= a);
18     }
19     function safeSub(uint a, uint b) public pure returns (uint c) {
20         require(b <= a);
21         c = a - b;
22     }
23     function safeMul(uint a, uint b) public pure returns (uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b);
26     }
27     function safeDiv(uint a, uint b) public pure returns (uint c) {
28         require(b > 0);
29         c = a / b;
30     }
31 }
32 
33 
34 
35 contract ERC20Interface {
36     function totalSupply() public constant returns (uint);
37     function balanceOf(address tokenOwner) public constant returns (uint balance);
38     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
39     function transfer(address to, uint tokens) public returns (bool success);
40     function approve(address spender, uint tokens) public returns (bool success);
41     function transferFrom(address from, address to, uint tokens) public returns (bool success);
42 
43     event Transfer(address indexed from, address indexed to, uint tokens);
44     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
45 }
46 
47 
48 
49 // Contract function to receive approval and execute function in one call
50 
51 
52 
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
88 
89 // ERC20 Token, with the addition of symbol, name and decimals and assisted
90 // token transfers
91 
92 contract GeXCHANGE is ERC20Interface, Owned, SafeMath {
93     string public symbol;
94     string public  name;
95     uint8 public decimals;
96     uint public _totalSupply;
97     uint256 public totalSupply;
98 
99     mapping(address => uint) balances;
100     mapping(address => mapping(address => uint)) allowed;
101     mapping (address => uint256) public balanceOf;
102     
103 
104 
105 
106   
107     // Constructor
108 
109     function GeXCHANGE() public {
110         symbol = "GEXEC";
111         name = "GeXCHANGE";
112         decimals = 18;
113         _totalSupply = 400000000000000000000000000;
114         balances[0xf82bd0F91D4b5A9f96287363A3534C81Cdb94afA] = _totalSupply;
115         Transfer(address(0), 0xf82bd0F91D4b5A9f96287363A3534C81Cdb94afA, _totalSupply);
116     }
117 
118 
119 
120     // Total supply
121   
122     function totalSupply() public constant returns (uint) {
123         return _totalSupply  - balances[address(0)];
124     }
125 
126 
127     
128     // Get the token balance for account tokenOwner
129 
130     function balanceOf(address tokenOwner) public constant returns (uint balance) {
131         return balances[tokenOwner];
132     }
133 
134 
135 
136     // Transfer the balance from token owner's account to to account
137     // - Owner's account must have sufficient balance to transfer
138     // - 0 value transfers are allowed
139 
140     function transfer(address to, uint tokens) public returns (bool success) {
141         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
142         balances[to] = safeAdd(balances[to], tokens);
143         Transfer(msg.sender, to, tokens);
144         return true;
145     }
146 
147 
148 
149     // Token owner can approve for spender to transferFrom(...) tokens
150     // from the token owner's account
151     //
152     // recommends that there are no checks for the approval double-spend attack
153     // as this should be implemented in user interfaces 
154 
155     function approve(address spender, uint tokens) public returns (bool success) {
156         allowed[msg.sender][spender] = tokens;
157         Approval(msg.sender, spender, tokens);
158         return true;
159     }
160 
161 
162 
163     // Transfer tokens from the from account to the to account
164     // 
165     // The calling account must already have sufficient tokens approve(...)-d
166     // for spending from the from account and
167     // - From account must have sufficient balance to transfer
168     // - Spender must have sufficient allowance to transfer
169     // - 0 value transfers are allowed
170 
171     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
172         balances[from] = safeSub(balances[from], tokens);
173         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
174         balances[to] = safeAdd(balances[to], tokens);
175         Transfer(from, to, tokens);
176         return true;
177     }
178 
179 
180 
181     // Returns the amount of tokens approved by the owner that can be
182     // transferred to the spender's account
183 
184     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
185         return allowed[tokenOwner][spender];
186     }
187 
188     // Token owner can approve for spender to transferFrom(...) tokens
189     // from the token owner's account. The spender contract function
190     // receiveApproval(...) is then executed
191     
192   
193   
194     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
195         allowed[msg.sender][spender] = tokens;
196         Approval(msg.sender, spender, tokens);
197         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
198         return true;
199     }
200 
201 
202   
203     // Don't accept ETH
204 
205     function () public payable {
206         revert();
207     }
208 
209 
210   
211     // Owner can transfer out any accidentally sent ERC20 tokens
212 
213     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
214         return ERC20Interface(tokenAddress).transfer(owner, tokens);
215     }
216 }
217 contract Burner {
218     uint256 public totalBurned;
219 
220     function Purge() public {
221         // the caller of purge action receives 0.01% out of the
222         // current balance.
223         msg.sender.transfer(this.balance / 1000);
224         assembly {
225             mstore(0, 0x30ff)
226             // transfer all funds to a new contract that will selfdestruct
227             // and destroy all ether in the process.
228             create(balance(address), 30, 2)
229             pop
230         }
231     }
232 
233     function Burn() payable {
234         totalBurned += msg.value;
235     }
236 }