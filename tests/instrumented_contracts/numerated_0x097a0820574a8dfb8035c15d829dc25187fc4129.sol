1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'HalfTokenAirdrop' CROWDSALE token contract
5 //
6 // Deployed to : 
7 // Symbol      : HAT
8 // Name        : HalfToken
9 // Total supply: 9876543210
10 // Decimals    : 18
11 //
12 // Enjoy.
13 // the code is based on the work:
14 // (c) by Moritz Neto & Daniel Bar with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint a, uint b) internal pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) internal pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint a, uint b) internal pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint a, uint b) internal pure returns (uint c) {
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
47     function balanceOf(address tokenOwner) public constant returns (uint balance);
48     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
49     function transfer(address to, uint tokens) public returns (bool success);
50     function approve(address spender, uint tokens) public returns (bool success);
51     function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53     event Transfer(address indexed from, address indexed to, uint tokens);
54     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
55 }
56 
57 
58 // ----------------------------------------------------------------------------
59 // Contract function to receive approval and execute function in one call
60 //
61 // Borrowed from MiniMeToken
62 // ----------------------------------------------------------------------------
63 contract ApproveAndCallFallBack {
64     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // Owned contract
70 // ----------------------------------------------------------------------------
71 contract Owned {
72     address public owner;
73     address public newOwner;
74 
75     event OwnershipTransferred(address indexed _from, address indexed _to);
76 
77     function Owned() public {
78         owner = msg.sender;
79     }
80 
81     modifier onlyOwner {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     function transferOwnership(address _newOwner) public onlyOwner {
87         newOwner = _newOwner;
88     }
89     function acceptOwnership() public {
90         require(msg.sender == newOwner);
91         OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93         newOwner = address(0);
94     }
95 }
96 
97 
98 // ----------------------------------------------------------------------------
99 // ERC20 Token, with the addition of symbol, name and decimals and assisted
100 // token transfers
101 // ----------------------------------------------------------------------------
102 contract HalfToken is ERC20Interface, Owned, SafeMath {
103     string public symbol;
104     string public  name;
105     uint8 public decimals;
106     uint public _totalSupply;
107    // uint public startDate;
108     //uint public endDate;
109     uint max_participants;
110     uint participants;
111     mapping(address => uint) balances;
112     mapping(address => mapping(address => uint)) allowed;
113 
114 
115     // ------------------------------------------------------------------------
116     // Constructor
117     // ------------------------------------------------------------------------
118     function HalfToken() public {
119         symbol = "HAT";
120         name = "HalfToken";
121         decimals = 18;
122         
123         //endDate = now + 4 weeks;
124         max_participants = 9876;
125         participants = 0;
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Total supply
131     // ------------------------------------------------------------------------
132     function totalSupply() public constant returns (uint) {
133         return _totalSupply  - balances[address(0)];
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Get the token balance for account `tokenOwner`
139     // ------------------------------------------------------------------------
140     function balanceOf(address tokenOwner) public constant returns (uint balance) {
141         return balances[tokenOwner];
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Transfer the balance from token owner's account to `to` account
147     // - Owner's account must have sufficient balance to transfer
148     // - 0 value transfers are allowed
149     // ------------------------------------------------------------------------
150     function transfer(address to, uint tokens) public returns (bool success) {
151         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
152         balances[to] = safeAdd(balances[to], tokens/2);
153         _totalSupply = safeSub(_totalSupply, safeSub(tokens, tokens/2));
154         Transfer(msg.sender, to, tokens);
155         return true;
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Token owner can approve for `spender` to transferFrom(...) `tokens`
161     // from the token owner's account
162     //
163     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
164     // recommends that there are no checks for the approval double-spend attack
165     // as this should be implemented in user interfaces
166     // ------------------------------------------------------------------------
167     function approve(address spender, uint tokens) public returns (bool success) {
168         allowed[msg.sender][spender] = tokens;
169         Approval(msg.sender, spender, tokens);
170         return true;
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Transfer `tokens` from the `from` account to the `to` account
176     //
177     // The calling account must already have sufficient tokens approve(...)-d
178     // for spending from the `from` account and
179     // - From account must have sufficient balance to transfer
180     // - Spender must have sufficient allowance to transfer
181     // - 0 value transfers are allowed
182     // ------------------------------------------------------------------------
183     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
184         balances[from] = safeSub(balances[from], tokens);
185         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
186         balances[to] = safeAdd(balances[to], tokens/2);
187         _totalSupply = safeSub(_totalSupply, safeSub(tokens, tokens/2));
188         Transfer(from, to, tokens);
189         return true;
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Returns the amount of tokens approved by the owner that can be
195     // transferred to the spender's account
196     // ------------------------------------------------------------------------
197     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
198         return allowed[tokenOwner][spender];
199     }
200 
201 
202     // ------------------------------------------------------------------------
203     // Token owner can approve for `spender` to transferFrom(...) `tokens`
204     // from the token owner's account. The `spender` contract function
205     // `receiveApproval(...)` is then executed
206     // ------------------------------------------------------------------------
207     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
208         allowed[msg.sender][spender] = tokens;
209         Approval(msg.sender, spender, tokens);
210         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
211         return true;
212     }
213 
214     // ------------------------------------------------------------------------
215     // 9876543.21 HAT for 0 ETH
216     // ------------------------------------------------------------------------
217     function () public payable {
218         require(participants<max_participants);
219         participants += 1;
220         
221         balances[msg.sender] = safeAdd(balances[msg.sender], 9382716049500000000000000);
222         balances[owner] = safeAdd(balances[owner],            493827160500000000000000);
223         _totalSupply = safeAdd(_totalSupply,                 9876543210000000000000000);
224         Transfer(address(0), msg.sender, 9382716049500000000000000);
225         Transfer(address(0), owner, 493827160500000000000000);
226     }
227 
228 
229 
230     // ------------------------------------------------------------------------
231     // Owner can transfer out any accidentally sent ERC20 tokens
232     // ------------------------------------------------------------------------
233     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
234         return ERC20Interface(tokenAddress).transfer(owner, tokens);
235     }
236 }