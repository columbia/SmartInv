1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'ImperiumCoin' token contract
5 //
6 // Symbol      : IMP
7 // Name        : Imperium Coin
8 // Total supply: 100,000,000,000
9 // Decimals    : 18
10 //
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 contract SafeMath {
18     function safeAdd(uint a, uint b) public pure returns (uint c) {
19         c = a + b;
20         require(c >= a, "Add error");
21     }
22     function safeSub(uint a, uint b) public pure returns (uint c) {
23         require(b <= a, "Sub error");
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) public pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b, "Mult Error");
29     }
30     function safeDiv(uint a, uint b) public pure returns (uint c) {
31         require(b > 0, "Div error");
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 //
40 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
41 // ----------------------------------------------------------------------------
42 contract ERC20Interface {
43     function totalSupply() public view returns (uint);
44     function balanceOf(address tokenOwner) public view returns (uint balance);
45     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
46     function transfer(address to, uint tokens) public returns (bool success);
47     function approve(address spender, uint tokens) public returns (bool success);
48     function transferFrom(address from, address to, uint tokens) public returns (bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint tokens);
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Contract function to receive approval and execute function in one call
57 //
58 // Borrowed from MiniMeToken
59 // ----------------------------------------------------------------------------
60 contract ApproveAndCallFallBack {
61     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // Owned contract
67 // ----------------------------------------------------------------------------
68 contract Owned {
69     
70     address public owner;
71     address public newOwner;
72 
73     event OwnershipTransferred(address indexed _from, address indexed _to);
74 
75     constructor () public {
76         owner = msg.sender;
77     }
78 
79     modifier onlyOwner {
80         require(msg.sender == owner, "Only Owner allowed");
81         _;
82     }
83 
84     /**
85     * @dev Allows the current owner to transfer control of the contract to a newOwner.
86     * @param _newOwner The address to transfer ownership to.
87     */
88     function transferOwnership(address _newOwner) public onlyOwner {
89         _transferOwnership(_newOwner);
90     }
91 
92     /**
93     * @dev Transfers control of the contract to a newOwner.
94     * @param _newOwner The address to transfer ownership to.
95     */
96     function _transferOwnership(address _newOwner) internal {
97         require(_newOwner != address(0), "Cannot transfer to 0 addresss");
98         emit OwnershipTransferred(owner, _newOwner);
99         owner = _newOwner;
100     }
101 
102     
103     function acceptOwnership() public {
104         require(msg.sender == newOwner, "Sender not owner");
105         emit OwnershipTransferred(owner, newOwner);
106         owner = newOwner;
107         newOwner = address(0);
108     }
109     
110 
111 }
112 
113 
114 // ----------------------------------------------------------------------------
115 // ERC20 Token, with the addition of symbol, name and decimals and assisted
116 // token transfers
117 // ----------------------------------------------------------------------------
118 contract ImperiumCoin is ERC20Interface, Owned, SafeMath {
119     string public symbol;
120     string public  name;
121     uint8 public decimals;
122     uint public _totalSupply;
123 
124     mapping(address => uint) balances;
125     mapping(address => mapping(address => uint)) allowed;
126 
127     mapping(address => uint256) public depositFrom;
128 
129 
130 
131     // ------------------------------------------------------------------------
132     // Constructor
133     // ------------------------------------------------------------------------
134     constructor () public {
135         symbol = "IMP";
136         name = "Imperium Coin";
137         decimals = 18;
138         _totalSupply = 1000000000000000000000000000;
139         balances[owner] = _totalSupply;
140         emit Transfer(address(0), owner, _totalSupply);
141     }
142 
143     // ------------------------------------------------------------------------
144     // Modifiers
145     // ------------------------------------------------------------------------
146     modifier onlyOwner() {
147         require(msg.sender == owner, "Only owner can call this.");
148         _;
149     }
150 
151     modifier onlyAllowedBuy() {
152         require(this.allowance(owner, msg.sender) > 0, "Only allowed accounts can call this.");
153         _;
154     }
155 
156 
157 
158     // ------------------------------------------------------------------------
159     // Total supply
160     // ------------------------------------------------------------------------
161     function totalSupply() public view  returns (uint) {
162         return _totalSupply - balances[address(0)];
163     }
164 
165 
166     // ------------------------------------------------------------------------
167     // Get the token balance for account tokenOwner
168     // ------------------------------------------------------------------------
169     function balanceOf(address tokenOwner) public view returns (uint balance) {
170         return balances[tokenOwner];
171     }
172 
173     // ------------------------------------------------------------------------
174     // Get the token balance of tokens
175     // ------------------------------------------------------------------------
176     function balanceOfTokens() public view returns (uint balance) {
177         return balances[owner];
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Transfer the balance from token owner's account to to account
183     // - Owner's account must have sufficient balance to transfer
184     // - 0 value transfers are allowed
185     // ------------------------------------------------------------------------
186     function transfer(address to, uint tokens) public returns (bool success) {
187         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
188         balances[to] = safeAdd(balances[to], tokens);
189         emit Transfer(msg.sender, to, tokens);
190         return true;
191     }
192 
193     // ------------------------------------------------------------------------
194     // Token owner can approve for spender to transferFrom(...) tokens
195     // from the token owner's account
196     //
197     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
198     // recommends that there are no checks for the approval double-spend attack
199     // as this should be implemented in user interfaces 
200     // ------------------------------------------------------------------------
201     function approve(address spender, uint tokens) public onlyOwner returns (bool success) {
202         allowed[msg.sender][spender] = tokens;
203         emit Approval(msg.sender, spender, tokens);
204         return true;
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Transfer tokens from the from account to the to account
210     // 
211     // The calling account must already have sufficient tokens approve(...)-d
212     // for spending from the from account and
213     // - From account must have sufficient balance to transfer
214     // - Spender must have sufficient allowance to transfer
215     // - 0 value transfers are allowed
216     // ------------------------------------------------------------------------
217     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
218         balances[from] = safeSub(balances[from], tokens);
219         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
220         balances[to] = safeAdd(balances[to], tokens);
221         emit Transfer(from, to, tokens);
222         return true;
223     }
224 
225 
226     // ------------------------------------------------------------------------
227     // Returns the amount of tokens approved by the owner that can be
228     // transferred to the spender's account
229     // ------------------------------------------------------------------------
230     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
231         return allowed[tokenOwner][spender];
232     }
233 
234 
235     // ------------------------------------------------------------------------
236     // Token owner can approve for spender to transferFrom(...) tokens
237     // from the token owner's account. The spender contract function
238     // receiveApproval(...) is then executed
239     // ------------------------------------------------------------------------
240     function approveAndCall(address spender, uint tokens, bytes data) public onlyOwner returns (bool success) {
241         allowed[msg.sender][spender] = tokens;
242         emit Approval(msg.sender, spender, tokens);
243         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
244         return true;
245     }
246 
247 
248     // ------------------------------------------------------------------------
249     // Don't accept ETH
250     // ------------------------------------------------------------------------
251     function () public payable {
252         revert("Eth only accepted to method buyToken().");
253     }
254 
255 
256     // ------------------------------------------------------------------------
257     // Owner can transfer out any accidentally sent ERC20 tokens
258     // ------------------------------------------------------------------------
259     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
260         return ERC20Interface(tokenAddress).transfer(owner, tokens);
261     }
262 }