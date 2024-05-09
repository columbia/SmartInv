1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // WaZoBia Blockchain Technology token contract 'WZB'
5 // http://www.wazobiacoin.com
6 // 
7 // WZB tokens are mintable by the owner until the `disableMinting()` function
8 // is executed. Tokens can be burnt by sending them to address 0x0
9 // ----------------------------------------------------------------------------
10 
11 
12 // ----------------------------------------------------------------------------
13 // Safe maths
14 // ----------------------------------------------------------------------------
15 library SafeMath {
16     function add(uint a, uint b) public pure returns (uint c) {
17         c = a + b;
18         require(c >= a);
19     }
20     function sub(uint a, uint b) public pure returns (uint c) {
21         require(b <= a);
22         c = a - b;
23     }
24     function mul(uint a, uint b) public pure returns (uint c) {
25         c = a * b;
26         require(a == 0 || c / a == b);
27     }
28     function div(uint a, uint b) public pure returns (uint c) {
29         require(b > 0);
30         c = a / b;
31     }
32 }
33 
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
71     function Owned() public {
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
83 
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
97 contract WazobiaToken is ERC20Interface, Owned {
98     using SafeMath for uint;
99 
100     string public symbol;
101     string public  name;
102     uint8 public decimals;
103     uint public _totalSupply;
104     bool public mintable;
105 
106     mapping(address => uint) balances;
107     mapping(address => mapping(address => uint)) allowed;
108 
109     event MintingDisabled();
110 
111 
112     // ------------------------------------------------------------------------
113     // Constructor
114     // ------------------------------------------------------------------------
115     function WazobiaToken() public {
116         symbol = "WZB";
117         name = "WaZoBiaCoin";
118         decimals = 18;
119         mintable = true;
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Total supply
125     // ------------------------------------------------------------------------
126     function totalSupply() public constant returns (uint) {
127         return _totalSupply  - balances[address(0)];
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Disable minting
133     // ------------------------------------------------------------------------
134     function disableMinting() public onlyOwner {
135         require(mintable);
136         mintable = false;
137         MintingDisabled();
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Get the token balance for account `tokenOwner`
143     // ------------------------------------------------------------------------
144     function balanceOf(address tokenOwner) public constant returns (uint balance) {
145         return balances[tokenOwner];
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Transfer the balance from token owner's account to `to` account
151     // - Owner's account must have sufficient balance to transfer
152     // - 0 value transfers are allowed
153     // ------------------------------------------------------------------------
154     function transfer(address to, uint tokens) public returns (bool success) {
155         balances[msg.sender] = balances[msg.sender].sub(tokens);
156         balances[to] = balances[to].add(tokens);
157         Transfer(msg.sender, to, tokens);
158         return true;
159     }
160 
161 
162     // ------------------------------------------------------------------------
163     // Token owner can approve for `spender` to transferFrom(...) `tokens`
164     // from the token owner's account
165     //
166     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
167     // recommends that there are no checks for the approval double-spend attack
168     // as this should be implemented in user interfaces 
169     // ------------------------------------------------------------------------
170     function approve(address spender, uint tokens) public returns (bool success) {
171         allowed[msg.sender][spender] = tokens;
172         Approval(msg.sender, spender, tokens);
173         return true;
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Transfer `tokens` from the `from` account to the `to` account
179     // 
180     // The calling account must already have sufficient tokens approve(...)-d
181     // for spending from the `from` account and
182     // - From account must have sufficient balance to transfer
183     // - Spender must have sufficient allowance to transfer
184     // - 0 value transfers are allowed
185     // ------------------------------------------------------------------------
186     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
187         balances[from] = balances[from].sub(tokens);
188         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
189         balances[to] = balances[to].add(tokens);
190         Transfer(from, to, tokens);
191         return true;
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Returns the amount of tokens approved by the owner that can be
197     // transferred to the spender's account
198     // ------------------------------------------------------------------------
199     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
200         return allowed[tokenOwner][spender];
201     }
202 
203 
204     // ------------------------------------------------------------------------
205     // Token owner can approve for `spender` to transferFrom(...) `tokens`
206     // from the token owner's account. The `spender` contract function
207     // `receiveApproval(...)` is then executed
208     // ------------------------------------------------------------------------
209     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
210         allowed[msg.sender][spender] = tokens;
211         Approval(msg.sender, spender, tokens);
212         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
213         return true;
214     }
215 
216 
217     // ------------------------------------------------------------------------
218     // Mint tokens
219     // ------------------------------------------------------------------------
220     function mint(address tokenOwner, uint tokens) public onlyOwner returns (bool success) {
221         require(mintable);
222         balances[tokenOwner] = balances[tokenOwner].add(tokens);
223         _totalSupply = _totalSupply.add(tokens);
224         Transfer(address(0), tokenOwner, tokens);
225         return true;
226     }
227 
228 
229     // ------------------------------------------------------------------------
230     // Don't accept ethers
231     // ------------------------------------------------------------------------
232     function () public payable {
233         revert();
234     }
235 
236 
237     // ------------------------------------------------------------------------
238     // Owner can transfer out any accidentally sent ERC20 tokens
239     // ------------------------------------------------------------------------
240     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
241         return ERC20Interface(tokenAddress).transfer(owner, tokens);
242     }
243 }