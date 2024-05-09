1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'BCAC' 'BCAChain Initial Token' ERC-20 token contract
5 //
6 // Symbol      : BCAC
7 // Name        : BCAChain Initial Token
8 // Total supply: 2,200,000,000.000000000000000000
9 // Decimals    : 18
10 //
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 library SafeMath {
18     function add(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function sub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function mul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function div(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint);
43     function balanceOf(address tokenOwner) public constant returns (uint balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Contract function to receive approval and execute function in one call
56 //
57 // Borrowed from MiniMeToken
58 // ----------------------------------------------------------------------------
59 contract ApproveAndCallFallBack {
60     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
61 }
62 
63 
64 // ----------------------------------------------------------------------------
65 // Owned contract
66 // ----------------------------------------------------------------------------
67 contract Owned {
68     address public owner;
69     address public newOwner;
70 
71     event OwnershipTransferred(address indexed _from, address indexed _to);
72 
73     constructor() public {
74         owner = msg.sender;
75     }
76 
77     modifier onlyOwner {
78         require(msg.sender == owner);
79         _;
80     }
81 
82     function transferOwnership(address _newOwner) public onlyOwner {
83         newOwner = _newOwner;
84     }
85     function acceptOwnership() public {
86         require(msg.sender == newOwner);
87         emit OwnershipTransferred(owner, newOwner);
88         owner = newOwner;
89         newOwner = address(0);
90     }
91 }
92 
93 
94 // ----------------------------------------------------------------------------
95 // ERC20 Token, with the addition of symbol, name and decimals and a
96 // fixed supply
97 // ----------------------------------------------------------------------------
98 contract BCAChainToken is ERC20Interface, Owned {
99     using SafeMath for uint;
100 
101     string public symbol;
102     string public  name;
103     uint8 public decimals;
104     uint _totalSupply;
105 
106     mapping(address => uint) balances;
107     mapping(address => mapping(address => uint)) allowed;
108 
109     mapping(address => string) mappingBCAChain;
110     event RegisterBCAChain(address user, string key);
111     
112     // ------------------------------------------------------------------------
113     // Constructor
114     // ------------------------------------------------------------------------
115     constructor() public {
116         symbol = "BCAC";
117         name = "BCAChain Initial Token";
118         decimals = 18;
119         _totalSupply = 2200000000 * 10**uint(decimals);
120         balances[owner] = _totalSupply;
121         emit Transfer(address(0), owner, _totalSupply);
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Total supply
127     // ------------------------------------------------------------------------
128     function totalSupply() public view returns (uint) {
129         return _totalSupply.sub(balances[address(0)]);
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Get the token balance for account `tokenOwner`
135     // ------------------------------------------------------------------------
136     function balanceOf(address tokenOwner) public view returns (uint balance) {
137         return balances[tokenOwner];
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Transfer the balance from token owner's account to `to` account
143     // - Owner's account must have sufficient balance to transfer
144     // - 0 value transfers are allowed
145     // ------------------------------------------------------------------------
146     function transfer(address to, uint tokens) public returns (bool success) {
147         balances[msg.sender] = balances[msg.sender].sub(tokens);
148         balances[to] = balances[to].add(tokens);
149         emit Transfer(msg.sender, to, tokens);
150         return true;
151     }
152 
153 
154     // ------------------------------------------------------------------------
155     // Token owner can approve for `spender` to transferFrom(...) `tokens`
156     // from the token owner's account
157     //
158     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
159     // recommends that there are no checks for the approval double-spend attack
160     // as this should be implemented in user interfaces 
161     // ------------------------------------------------------------------------
162     function approve(address spender, uint tokens) public returns (bool success) {
163         allowed[msg.sender][spender] = tokens;
164         emit Approval(msg.sender, spender, tokens);
165         return true;
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Transfer `tokens` from the `from` account to the `to` account
171     // 
172     // The calling account must already have sufficient tokens approve(...)-d
173     // for spending from the `from` account and
174     // - From account must have sufficient balance to transfer
175     // - Spender must have sufficient allowance to transfer
176     // - 0 value transfers are allowed
177     // ------------------------------------------------------------------------
178     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
179         balances[from] = balances[from].sub(tokens);
180         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
181         balances[to] = balances[to].add(tokens);
182         emit Transfer(from, to, tokens);
183         return true;
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Returns the amount of tokens approved by the owner that can be
189     // transferred to the spender's account
190     // ------------------------------------------------------------------------
191     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
192         return allowed[tokenOwner][spender];
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Token owner can approve for `spender` to transferFrom(...) `tokens`
198     // from the token owner's account. The `spender` contract function
199     // `receiveApproval(...)` is then executed
200     // ------------------------------------------------------------------------
201     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
202         allowed[msg.sender][spender] = tokens;
203         emit Approval(msg.sender, spender, tokens);
204         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
205         return true;
206     }
207 
208 
209     // ------------------------------------------------------------------------
210     // Don't accept ETH
211     // ------------------------------------------------------------------------
212     function () public payable {
213         revert();
214     }
215 
216 
217     // ------------------------------------------------------------------------
218     // Owner can transfer out any accidentally sent ERC20 tokens
219     // ------------------------------------------------------------------------
220     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
221         return ERC20Interface(tokenAddress).transfer(owner, tokens);
222     }
223 
224 
225     // ------------------------------------------------------------------------
226     // Value should be a public key.  Read full BCAChain key import policy.
227     // ------------------------------------------------------------------------
228     function register(string key) public returns (bool success){
229         assert(bytes(key).length <= 42);
230         mappingBCAChain[msg.sender] = key;
231         emit RegisterBCAChain(msg.sender, key);
232         return true;
233     }
234 
235 }