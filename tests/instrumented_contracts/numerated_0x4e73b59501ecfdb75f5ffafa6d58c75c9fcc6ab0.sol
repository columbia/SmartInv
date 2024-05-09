1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'OMSAIRAM' Distribution token contract
5 //
6 // Deployed to : 0x272f022a374fc7e9213b35952e167ea217303e18
7 // Symbol      : OMSAIRAM
8 // Name        : OMSAIRAM 2018 Token
9 // Total supply: 10,001
10 // Decimals    : 18
11 //
12 // (c) by Project OMSAIRAM WORLD 2018 https://omsairam.world . 
13 // ----------------------------------------------------------------------------
14 
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 contract SafeMath {
20     function safeAdd(uint a, uint b) internal pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function safeSub(uint a, uint b) internal pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function safeMul(uint a, uint b) internal pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function safeDiv(uint a, uint b) internal pure returns (uint c) {
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
73     function Owned() public {
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
87         OwnershipTransferred(owner, newOwner);
88         owner = newOwner;
89         newOwner = address(0);
90     }
91 }
92 
93 
94 // ----------------------------------------------------------------------------
95 // ERC20 Token, with the addition of symbol, name and decimals and assisted
96 // token transfers
97 // ----------------------------------------------------------------------------
98 contract omsairam18 is ERC20Interface, Owned, SafeMath {
99     string public symbol;
100     string public  name;
101     uint8 public decimals;
102     uint public _totalSupply;
103     uint public startDate;
104     uint public endDate;
105 
106     mapping(address => uint) balances;
107     mapping(address => mapping(address => uint)) allowed;
108 
109 
110     // ------------------------------------------------------------------------
111     // Constructor
112     // ------------------------------------------------------------------------
113     function omsairam18() public {
114         symbol = "OMSAIRAM";
115         name = "OMSAIRAM 2018 Token";
116         decimals = 18;
117         endDate = now + 30 weeks;
118 
119     }
120 
121 
122     // ------------------------------------------------------------------------
123     // Total supply
124     // ------------------------------------------------------------------------
125     function totalSupply() public constant returns (uint) {
126         return _totalSupply  - balances[address(0)];
127     }
128 
129 
130     // ------------------------------------------------------------------------
131     // Get the token balance for account `tokenOwner`
132     // ------------------------------------------------------------------------
133     function balanceOf(address tokenOwner) public constant returns (uint balance) {
134         return balances[tokenOwner];
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Transfer the balance from token owner's account to `to` account
140     // - Owner's account must have sufficient balance to transfer
141     // - 0 value transfers are allowed
142     // ------------------------------------------------------------------------
143     function transfer(address to, uint tokens) public returns (bool success) {
144         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
145         balances[to] = safeAdd(balances[to], tokens);
146         Transfer(msg.sender, to, tokens);
147         return true;
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Token owner can approve for `spender` to transferFrom(...) `tokens`
153     // from the token owner's account
154     //
155     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
156     // recommends that there are no checks for the approval double-spend attack
157     // as this should be implemented in user interfaces
158     // ------------------------------------------------------------------------
159     function approve(address spender, uint tokens) public returns (bool success) {
160         allowed[msg.sender][spender] = tokens;
161         Approval(msg.sender, spender, tokens);
162         return true;
163     }
164 
165 
166     // ------------------------------------------------------------------------
167     // Transfer `tokens` from the `from` account to the `to` account
168     //
169     // The calling account must already have sufficient tokens approve(...)-d
170     // for spending from the `from` account and
171     // - From account must have sufficient balance to transfer
172     // - Spender must have sufficient allowance to transfer
173     // - 0 value transfers are allowed
174     // ------------------------------------------------------------------------
175     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
176         balances[from] = safeSub(balances[from], tokens);
177         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
178         balances[to] = safeAdd(balances[to], tokens);
179         Transfer(from, to, tokens);
180         return true;
181     }
182 
183 
184     // ------------------------------------------------------------------------
185     // Returns the amount of tokens approved by the owner that can be
186     // transferred to the spender's account
187     // ------------------------------------------------------------------------
188     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
189         return allowed[tokenOwner][spender];
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Token owner can approve for `spender` to transferFrom(...) `tokens`
195     // from the token owner's account. The `spender` contract function
196     // `receiveApproval(...)` is then executed
197     // ------------------------------------------------------------------------
198     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
199         allowed[msg.sender][spender] = tokens;
200         Approval(msg.sender, spender, tokens);
201         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
202         return true;
203     }
204 
205     // ------------------------------------------------------------------------
206     // 1 OMSAIRAM 2018 Token per 1 ETH
207     // ------------------------------------------------------------------------
208     function () public payable {
209         require(now >= startDate && now <= endDate);
210         uint tokens;
211         if (msg.sender == owner) {
212             tokens = msg.value * 200000;
213         } else {
214             tokens = msg.value * 1;
215         }   
216         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
217         _totalSupply = safeAdd(_totalSupply, tokens);
218         Transfer(address(0), msg.sender, tokens);
219         owner.transfer(msg.value);
220     }
221 
222 
223 
224     // ------------------------------------------------------------------------
225     // Owner can transfer out any accidentally sent ERC20 tokens
226     // ------------------------------------------------------------------------
227     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
228         return ERC20Interface(tokenAddress).transfer(owner, tokens);
229     }
230 }