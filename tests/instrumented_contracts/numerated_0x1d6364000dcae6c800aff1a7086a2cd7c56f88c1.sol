1 pragma solidity 0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // 'RideNode' CROWDSALE token contract
5 //
6 // Deployed to : Bayride Inc
7 // Symbol      : RIDE
8 // Name        : RideNode Token
9 // Total supply: 25000000000
10 // Decimals    : 18
11 //
12 // ----------------------------------------------------------------------------
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 contract SafeMath {
18     function safeAdd(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function safeSub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function safeDiv(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 // ----------------------------------------------------------------------------
37 // ERC Token Standard #20 Interface
38 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() public view returns (uint);
42     function balanceOf(address tokenOwner) public view returns (uint balance);
43     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
44     function transfer(address to, uint tokens) public returns (bool success);
45     function approve(address spender, uint tokens) public returns (bool success);
46     function transferFrom(address from, address to, uint tokens) public returns (bool success);
47 
48     event Transfer(address indexed from, address indexed to, uint tokens);
49     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
50 }
51 
52 // ----------------------------------------------------------------------------
53 // Contract function to receive approval and execute function in one call
54 //
55 // ----------------------------------------------------------------------------
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, string memory data) public;
58 }
59 
60 // ----------------------------------------------------------------------------
61 // Owned contract
62 // ----------------------------------------------------------------------------
63 contract Owned {
64     address payable public owner;
65     address payable public newOwner;
66 
67     event OwnershipTransferred(address indexed _from, address indexed _to);
68 
69     constructor() public {
70         owner = msg.sender;
71     }
72 
73     modifier onlyOwner {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     function transferOwnership(address payable _newOwner) public onlyOwner {
79         newOwner = _newOwner;
80     }
81     
82     function acceptOwnership() public {
83         require(msg.sender == newOwner);
84         emit OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86         newOwner = address(0);
87     }
88 }
89 
90 // ----------------------------------------------------------------------------
91 // ERC20 Token, with the addition of symbol, name and decimals and assisted
92 // token transfers
93 // ----------------------------------------------------------------------------
94 contract RideNode is ERC20Interface, Owned, SafeMath {
95     string public symbol;
96     string public  name;
97     uint8 public decimals;
98     uint public curSale;
99     uint public maxSale;
100     uint public _totalSupply;
101     uint public startDate;
102     uint public bonusEnds;
103     uint public endDate;
104     
105     address internal bayRide;
106 
107     mapping(address => uint) internal balances;
108     mapping(address => mapping(address => uint)) internal allowed;
109 
110     // ------------------------------------------------------------------------
111     // Constructor
112     // ------------------------------------------------------------------------
113     constructor() public {
114         symbol = "RIDE";
115         name = "RideNode";
116         _totalSupply = 25000000000000000000000000000;
117         maxSale = 10000000000000000000000000000;
118         
119         decimals = 18;
120         bonusEnds = now + 2 weeks;
121         endDate = now + 10 weeks;
122         
123         bayRide = 0x5Eca4569E7B239f72A919F12E883E01428B17036;
124         balances[bayRide] = _totalSupply;
125         emit Transfer(address(0), bayRide, _totalSupply);
126     }
127 
128     // ------------------------------------------------------------------------
129     // Total supply
130     // ------------------------------------------------------------------------
131     function totalSupply() public view returns (uint) {
132         return _totalSupply  - balances[address(0)];
133     }
134 
135     // ------------------------------------------------------------------------
136     // Get the token balance for account `tokenOwner`
137     // ------------------------------------------------------------------------
138     function balanceOf(address tokenOwner) public view returns (uint balance) {
139         return balances[tokenOwner];
140     }
141 
142     // ------------------------------------------------------------------------
143     // Transfer the balance from token owner's account to `to` account
144     // - Owner's account must have sufficient balance to transfer
145     // - 0 value transfers are allowed
146     // ------------------------------------------------------------------------
147     function transfer(address to, uint tokens) public returns (bool success) {
148         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
149         balances[to] = safeAdd(balances[to], tokens);
150         emit Transfer(msg.sender, to, tokens);
151         return true;
152     }
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
168     // ------------------------------------------------------------------------
169     // Transfer `tokens` from the `from` account to the `to` account
170     //
171     // The calling account must already have sufficient tokens approve(...)-d
172     // for spending from the `from` account and
173     // - From account must have sufficient balance to transfer
174     // - Spender must have sufficient allowance to transfer
175     // - 0 value transfers are allowed
176     // ------------------------------------------------------------------------
177     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
178         balances[from] = safeSub(balances[from], tokens);
179         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
180         balances[to] = safeAdd(balances[to], tokens);
181         emit Transfer(from, to, tokens);
182         return true;
183     }
184 
185     // ------------------------------------------------------------------------
186     // Returns the amount of tokens approved by the owner that can be
187     // transferred to the spender's account
188     // ------------------------------------------------------------------------
189     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
190         return allowed[tokenOwner][spender];
191     }
192 
193     // ------------------------------------------------------------------------
194     // Token owner can approve for `spender` to transferFrom(...) `tokens`
195     // from the token owner's account. The `spender` contract function
196     // `receiveApproval(...)` is then executed
197     // ------------------------------------------------------------------------
198     function approveAndCall(address spender, uint tokens, string memory data) public returns (bool success) {
199         allowed[msg.sender][spender] = tokens;
200         emit Approval(msg.sender, spender, tokens);
201         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
202         return true;
203     }
204 
205     // ------------------------------------------------------------------------
206     // 4,000 RIDE Tokens per 1 ETH
207     // ------------------------------------------------------------------------
208     function () external payable {
209         require(now >= startDate && now <= endDate);
210         uint tokens;
211         if (now <= bonusEnds) {
212             tokens = msg.value * 5000;
213         } else {
214             tokens = msg.value * 4000;
215         }
216         
217         curSale = safeAdd(curSale, tokens);
218         require(curSale <= maxSale, "SOLD OUT!!!");
219         
220         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
221         balances[bayRide] = safeSub(balances[bayRide], tokens);
222         emit Transfer(bayRide, msg.sender, tokens);
223 
224         owner.transfer(msg.value);
225     }
226 
227     // ------------------------------------------------------------------------
228     // Owner can transfer out any accidentally sent ERC20 tokens
229     // ------------------------------------------------------------------------
230     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
231         return ERC20Interface(tokenAddress).transfer(owner, tokens);
232     }
233 }