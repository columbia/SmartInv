1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7     function safeAdd(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address tokenOwner) public constant returns (uint balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // Contract function to receive approval and execute function in one call
45 //
46 // Borrowed from MiniMeToken
47 // ----------------------------------------------------------------------------
48 contract ApproveAndCallFallBack {
49     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // ----------------------------------------------------------------------------
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     function Owned() public {
63         owner = 0xfDC65371153A94b092fe59B45aD4Ef733C3b9f6b;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 
82 
83 // ----------------------------------------------------------------------------
84 // ERC20 Token, with the addition of symbol, name and decimals and assisted
85 // token transfers
86 // ----------------------------------------------------------------------------
87 contract Token is ERC20Interface, Owned, SafeMath {
88     string public symbol;
89     string public  name;
90     uint8 public decimals;
91     uint public _totalSupply;
92 
93     mapping(address => uint) balances;
94     mapping(address => mapping(address => uint)) allowed;
95 
96 
97     // ------------------------------------------------------------------------
98     // Constructor
99     // ------------------------------------------------------------------------
100     function Token() public {
101         symbol = "MUSD";
102         name = "Mintoken";
103         _totalSupply = 10*10**23;
104         balances[msg.sender] = safeAdd(balances[msg.sender],_totalSupply);
105         decimals = 18;
106         
107     }
108 
109 
110     // ------------------------------------------------------------------------
111     // Total supply
112     // ------------------------------------------------------------------------
113     function totalSupply() public constant returns (uint) {
114         return _totalSupply  - balances[address(0)];
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Get the token balance for account `tokenOwner`
120     // ------------------------------------------------------------------------
121     function balanceOf(address tokenOwner) public constant returns (uint balance) {
122         return balances[tokenOwner];
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Transfer the balance from token owner's account to `to` account
128     // - Owner's account must have sufficient balance to transfer
129     // - 0 value transfers are allowed
130     // ------------------------------------------------------------------------
131     function transfer(address to, uint tokens) public returns (bool success) {
132         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
133         balances[to] = safeAdd(balances[to], tokens);
134         Transfer(msg.sender, to, tokens);
135         return true;
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Token owner can approve for `spender` to transferFrom(...) `tokens`
141     // from the token owner's account
142     //
143     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
144     // recommends that there are no checks for the approval double-spend attack
145     // as this should be implemented in user interfaces
146     // ------------------------------------------------------------------------
147     function approve(address spender, uint tokens) public returns (bool success) {
148         allowed[msg.sender][spender] = tokens;
149         Approval(msg.sender, spender, tokens);
150         return true;
151     }
152 
153 
154     // ------------------------------------------------------------------------
155     // Transfer `tokens` from the `from` account to the `to` account
156     //
157     // The calling account must already have sufficient tokens approve(...)-d
158     // for spending from the `from` account and
159     // - From account must have sufficient balance to transfer
160     // - Spender must have sufficient allowance to transfer
161     // - 0 value transfers are allowed
162     // ------------------------------------------------------------------------
163     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
164         balances[from] = safeSub(balances[from], tokens);
165         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
166         balances[to] = safeAdd(balances[to], tokens);
167         Transfer(from, to, tokens);
168         return true;
169     }
170 
171 
172     // ------------------------------------------------------------------------
173     // Returns the amount of tokens approved by the owner that can be
174     // transferred to the spender's account
175     // ------------------------------------------------------------------------
176     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
177         return allowed[tokenOwner][spender];
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Token owner can approve for `spender` to transferFrom(...) `tokens`
183     // from the token owner's account. The `spender` contract function
184     // `receiveApproval(...)` is then executed
185     // ------------------------------------------------------------------------
186     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
187         allowed[msg.sender][spender] = tokens;
188         Approval(msg.sender, spender, tokens);
189         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
190         return true;
191     }
192 
193     
194 
195     // ------------------------------------------------------------------------
196     // Only OWNER Section Starts Here
197     // ------------------------------------------------------------------------
198     //
199     // ------------------------------------------------------------------------
200     // Owner can transfer out any accidentally sent ERC20 tokens
201     // ------------------------------------------------------------------------
202     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
203         return ERC20Interface(tokenAddress).transfer(owner, tokens);
204     }
205 
206     // ------------------------------------------------------------------------
207     // INCREASE token supply
208     // ------------------------------------------------------------------------
209     function increaseSupply(uint value, address to) public onlyOwner returns (bool) {
210         require(value > 0);
211         _totalSupply = safeAdd(_totalSupply, value);
212         balances[to] = safeAdd(balances[to], value);
213         Transfer(0, to, value);
214         return true;
215     }
216 
217     // ------------------------------------------------------------------------
218     // DECREASE token supply
219     // ------------------------------------------------------------------------
220     function Burn(uint value, address from) public onlyOwner returns (bool) {
221         require(value > 0);
222         require(balances[from] >= value);
223         balances[from] = safeSub(balances[from], value);
224         _totalSupply = safeSub(_totalSupply, value);
225         Transfer(from, 0, value);
226         return true;
227     }
228 
229     // ------------------------------------------------------------------------
230     // Transact the balance 'from' account to `to` account
231     // - From account must have sufficient balance to transfer
232     // - 0 value transfers are not allowed allowed
233     // ------------------------------------------------------------------------
234     function transact(address from, address to, uint tokens) public onlyOwner returns (bool success) {
235         require(tokens > 0);
236         require(balances[from] >= tokens);
237         balances[from] = safeSub(balances[from], tokens);
238         balances[to] = safeAdd(balances[to], tokens);
239         Transfer(from, to, tokens);
240         return true;
241     }
242 
243 }