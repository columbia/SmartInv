1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Symbol      : CCIE
5 // Name        : CryptoCCIE Token
6 // Total supply: 1000000000.000000
7 // Decimals    : 18
8 // ----------------------------------------------------------------------------
9 
10 
11 // ----------------------------------------------------------------------------
12 // Safe maths
13 // ----------------------------------------------------------------------------
14 contract SafeMath {
15     function safeAdd(uint a, uint b) internal pure returns (uint c) {
16         c = a + b;
17         require(c >= a);
18     }
19     function safeSub(uint a, uint b) internal pure returns (uint c) {
20         require(b <= a);
21         c = a - b;
22     }
23     function safeMul(uint a, uint b) internal pure returns (uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b);
26     }
27     function safeDiv(uint a, uint b) internal pure returns (uint c) {
28         require(b > 0);
29         c = a / b;
30     }
31 }
32 
33 
34 // ----------------------------------------------------------------------------
35 // ERC Token Standard #20 Interface
36 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
37 // ----------------------------------------------------------------------------
38 contract ERC20Interface {
39     function totalSupply() public constant returns (uint);
40     function balanceOf(address tokenOwner) public constant returns (uint balance);
41     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
42     function transfer(address to, uint tokens) public returns (bool success);
43     function approve(address spender, uint tokens) public returns (bool success);
44     function transferFrom(address from, address to, uint tokens) public returns (bool success);
45 
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // Contract function to receive approval and execute function in one call
53 //
54 // Borrowed from MiniMeToken
55 // ----------------------------------------------------------------------------
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // Owned contract
63 // ----------------------------------------------------------------------------
64 contract Owned {
65     address public owner;
66     address public newOwner;
67 
68     event OwnershipTransferred(address indexed _from, address indexed _to);
69 
70     constructor() public {
71         owner = msg.sender;
72     }
73 
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     function transferOwnership(address _newOwner) public onlyOwner {
80         newOwner = _newOwner;
81     }
82 }
83 
84 // ----------------------------------------------------------------------------
85 // ERC20 Token, with the addition of symbol, name and decimals and assisted
86 // token transfers
87 // ----------------------------------------------------------------------------
88 contract CryptoCCIE is ERC20Interface, Owned, SafeMath  {
89     string public symbol;
90     string public  name;
91     uint8  public decimals;
92     uint   public _totalSupply;
93     uint   public startDate;
94     uint   public bonusEnds;
95     uint   public endDate;
96 
97     mapping(address => uint) balances;
98     mapping(address => mapping(address => uint)) allowed;
99 
100 
101     // ------------------------------------------------------------------------
102     // Constructor
103     // ------------------------------------------------------------------------
104     constructor() public {
105         symbol = "CCIE";
106         name = "CryptoCCIE";
107         decimals = 18;
108         bonusEnds = now + 4 weeks;
109         endDate = now + 8 weeks;
110         _totalSupply = 1000000000 * 10**uint(decimals);
111         balances[owner] = _totalSupply;
112         emit Transfer(address(0), owner, _totalSupply);
113 
114     }
115 
116 
117     // ------------------------------------------------------------------------
118     // Total supply
119     // ------------------------------------------------------------------------
120     function totalSupply() public constant returns (uint) {
121         return  _totalSupply;
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Get the token balance for account `tokenOwner`
127     // ------------------------------------------------------------------------
128     function balanceOf(address tokenOwner) public constant returns (uint balance) {
129         return balances[tokenOwner];
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Transfer the balance from token owner's account to `to` account
135     // - Owner's account must have sufficient balance to transfer
136     // - 0 value transfers are allowed
137     // ------------------------------------------------------------------------
138     function transfer(address to, uint tokens) public returns (bool success) {
139         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
140         balances[to] = safeAdd(balances[to], tokens);
141         emit Transfer(msg.sender, to, tokens);
142         return true;
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Token owner can approve for `spender` to transferFrom(...) `tokens`
148     // from the token owner's account
149     //
150     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
151     // recommends that there are no checks for the approval double-spend attack
152     // as this should be implemented in user interfaces
153     // ------------------------------------------------------------------------
154     function approve(address spender, uint tokens) public returns (bool success) {
155         allowed[msg.sender][spender] = tokens;
156         emit Approval(msg.sender, spender, tokens);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Transfer `tokens` from the `from` account to the `to` account
163     //
164     // The calling account must already have sufficient tokens approve(...)-d
165     // for spending from the `from` account and
166     // - From account must have sufficient balance to transfer
167     // - Spender must have sufficient allowance to transfer
168     // - 0 value transfers are allowed
169     // ------------------------------------------------------------------------
170     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
171         balances[from] = safeSub(balances[from], tokens);
172         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
173         balances[to] = safeAdd(balances[to], tokens);
174         emit Transfer(from, to, tokens);
175         return true;
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Returns the amount of tokens approved by the owner that can be
181     // transferred to the spender's account
182     // ------------------------------------------------------------------------
183     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
184         return allowed[tokenOwner][spender];
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Token owner can approve for `spender` to transferFrom(...) `tokens`
190     // from the token owner's account. The `spender` contract function
191     // `receiveApproval(...)` is then executed
192     // ------------------------------------------------------------------------
193     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
194         allowed[msg.sender][spender] = tokens;
195         emit Approval(msg.sender, spender, tokens);
196         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
197         return true;
198     }
199 
200     // ------------------------------------------------------------------------
201     // CrowdSale Function 10,000 FWD Tokens per 1 ETH
202     // ------------------------------------------------------------------------
203     function () public payable {
204         require(now >= startDate && now <= endDate);
205         uint tokens;
206         if (now <= bonusEnds) {
207             tokens = msg.value * 12000;
208         } else {
209             tokens = msg.value * 10000;
210         }
211         balances[owner] = safeSub(balances[owner], tokens);
212         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
213         emit Transfer(owner, msg.sender, tokens);
214         owner.transfer(msg.value);
215     }
216 
217     // ------------------------------------------------------------------------
218     // Bounty Transfer Function Owner only
219     // ------------------------------------------------------------------------
220 
221     function transferBounty(address to, uint tokens) public returns (bool success) {
222         require(msg.sender==owner);
223         balances[owner] = safeSub(balances[owner], tokens);
224         balances[to] = safeAdd(balances[to], tokens);
225         emit Transfer(owner, to, tokens);
226         return true;
227     }
228 
229 
230     // ------------------------------------------------------------------------
231     // Owner can transfer out any accidentally sent ERC20 tokens
232     // ------------------------------------------------------------------------
233     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
234         require(msg.sender==owner);
235         return ERC20Interface(tokenAddress).transfer(owner, tokens);
236     }
237 }