1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'WinCoin' token contract
5 //
6 // Deployed to : 0x054d9521CE94705D2BaB36Ffba8b0CdB69F04F3e
7 // Symbol      : WIN
8 // Name        : WinCoin
9 // Initial supply: 200000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // ----------------------------------------------------------------------------
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 contract SafeMath {
20     function safeAdd(uint a, uint b) public pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function safeSub(uint a, uint b) public pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function safeMul(uint a, uint b) public pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function safeDiv(uint a, uint b) public pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 
39 // ----------------------------------------------------------------------------
40 // ERC Token Standard #20 Interface
41 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
42 // ----------------------------------------------------------------------------
43 contract ERC20Interface {
44     function totalSupply() public constant returns (uint);
45     function balanceOf(address tokenOwner) public constant returns (uint balance);
46     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
47     function transfer(address to, uint tokens) public returns (bool success);
48     function approve(address spender, uint tokens) public returns (bool success);
49     function transferFrom(address from, address to, uint tokens) public returns (bool success);
50 
51     event Transfer(address indexed from, address indexed to, uint tokens);
52     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
53 }
54 
55 
56 // ----------------------------------------------------------------------------
57 // Contract function to receive approval and execute function in one call
58 //
59 // Borrowed from MiniMeToken
60 // ----------------------------------------------------------------------------
61 contract ApproveAndCallFallBack {
62     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
63 }
64 
65 
66 // ----------------------------------------------------------------------------
67 // Owned contract
68 // ----------------------------------------------------------------------------
69 contract Owned {
70     address public owner;
71     address public newOwner;
72 
73     event OwnershipTransferred(address indexed _from, address indexed _to);
74 
75     function Owned() public {
76         owner = msg.sender;
77     }
78 
79     modifier onlyOwner {
80         require(msg.sender == owner);
81         _;
82     }
83 
84     function transferOwnership(address _newOwner) public onlyOwner {
85         newOwner = _newOwner;
86     }
87     function acceptOwnership() public {
88         require(msg.sender == newOwner);
89         OwnershipTransferred(owner, newOwner);
90         owner = newOwner;
91         newOwner = address(0);
92     }
93 }
94 
95 
96 // ----------------------------------------------------------------------------
97 // ERC20 Token, with the addition of symbol, name and decimals and assisted
98 // token transfers
99 // ----------------------------------------------------------------------------
100 contract WinCoin is ERC20Interface, Owned, SafeMath {
101     string public symbol;
102     string public name;
103     uint8 public decimals;
104     uint public _totalSupply;
105 
106     mapping(address => uint) balances;
107     mapping(address => mapping(address => uint)) allowed;
108 
109 
110     // ------------------------------------------------------------------------
111     // Constructor
112     // ------------------------------------------------------------------------
113     function WinCoin() public {
114         symbol = "WIN";
115         name = "WinCoin";
116         decimals = 18;
117         _totalSupply = 200000000000000000000000;
118         balances[0x885be03f8538B6506a62A00769bB5F45EdCb9eDd] = _totalSupply;
119         Transfer(address(0), 0x885be03f8538B6506a62A00769bB5F45EdCb9eDd, _totalSupply);
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Total supply
125     // ------------------------------------------------------------------------
126     function totalSupply() public constant returns (uint) {
127         return _totalSupply - balances[address(0)];
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Get the token balance for account tokenOwner
133     // ------------------------------------------------------------------------
134     function balanceOf(address tokenOwner) public constant returns (uint balance) {
135         return balances[tokenOwner];
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Transfer the balance from token owner's account to to account
141     // - Owner's account must have sufficient balance to transfer
142     // - 0 value transfers are allowed
143     // ------------------------------------------------------------------------
144     function transfer(address to, uint tokens) public returns (bool success) {
145         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
146         balances[to] = safeAdd(balances[to], tokens);
147         Transfer(msg.sender, to, tokens);
148         return true;
149     }
150 
151     /**
152     * @dev Internal function that mints an amount of the token and assigns it to
153     * an account. This encapsulates the modification of balances such that the
154     * proper events are emitted.
155     * @param to The account that will receive the created tokens.
156     * @param amount The amount that will be created.
157     */
158     function mint(address to, uint256 amount) onlyOwner returns (bool success) {
159         require(to != 0);
160         _totalSupply = safeAdd(_totalSupply, amount);
161         balances[to] = safeAdd(balances[to], amount);
162         Transfer(address(0), to, amount);
163     }
164 
165 
166     // ------------------------------------------------------------------------
167     // Token owner can approve for spender to transferFrom(...) tokens
168     // from the token owner's account
169     //
170     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
171     // recommends that there are no checks for the approval double-spend attack
172     // as this should be implemented in user interfaces 
173     // ------------------------------------------------------------------------
174     function approve(address spender, uint tokens) public returns (bool success) {
175         allowed[msg.sender][spender] = tokens;
176         Approval(msg.sender, spender, tokens);
177         return true;
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Transfer tokens from the from account to the to account
183     // 
184     // The calling account must already have sufficient tokens approve(...)-d
185     // for spending from the from account and
186     // - From account must have sufficient balance to transfer
187     // - Spender must have sufficient allowance to transfer
188     // - 0 value transfers are allowed
189     // ------------------------------------------------------------------------
190     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
191         balances[from] = safeSub(balances[from], tokens);
192         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
193         balances[to] = safeAdd(balances[to], tokens);
194         Transfer(from, to, tokens);
195         return true;
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Returns the amount of tokens approved by the owner that can be
201     // transferred to the spender's account
202     // ------------------------------------------------------------------------
203     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
204         return allowed[tokenOwner][spender];
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Token owner can approve for spender to transferFrom(...) tokens
210     // from the token owner's account. The spender contract function
211     // receiveApproval(...) is then executed
212     // ------------------------------------------------------------------------
213     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
214         allowed[msg.sender][spender] = tokens;
215         Approval(msg.sender, spender, tokens);
216         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
217         return true;
218     }
219 
220 
221     // ------------------------------------------------------------------------
222     // Don't accept ETH
223     // ------------------------------------------------------------------------
224     function () public payable {
225         revert();
226     }
227 
228 
229     // ------------------------------------------------------------------------
230     // Owner can transfer out any accidentally sent ERC20 tokens
231     // ------------------------------------------------------------------------
232     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
233         return ERC20Interface(tokenAddress).transfer(owner, tokens);
234     }
235 }