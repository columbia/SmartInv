1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'wallcoin' CROWDSALE token contract
5 //
6 // Deployed to : 0x0d7b7b690d74253ffd9795409a6c603b912ae534
7 // Symbol      : WALL
8 // Name        : WallCoin Token
9 // Total supply: 
10 // Decimals    : 18
11 // ----------------------------------------------------------------------------
12 
13 // ----------------------------------------------------------------------------
14 // Safe math
15 // ----------------------------------------------------------------------------
16 contract SafeMath {
17     function safeAdd(uint a, uint b) internal pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21 
22     function safeSub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26 
27     function safeMul(uint a, uint b) internal pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31 
32     function safeDiv(uint a, uint b) internal pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 // ----------------------------------------------------------------------------
39 // ERC Token Standard #20 Interface
40 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
41 // ----------------------------------------------------------------------------
42 contract ERC20Interface {
43     function totalSupply() public constant returns (uint);
44     function balanceOf(address tokenOwner) public constant returns (uint balance);
45     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
46     function transfer(address to, uint tokens) public returns (bool success);
47     function approve(address spender, uint tokens) public returns (bool success);
48     function transferFrom(address from, address to, uint tokens) public returns (bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint tokens);
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 // ----------------------------------------------------------------------------
55 // Contract function to receive approval and execute function in one call
56 // ----------------------------------------------------------------------------
57 contract ApproveAndCallFallBack {
58     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
59 }
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
70     function Owned() public {
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
82 
83     function acceptOwnership() public {
84         require(msg.sender == newOwner);
85         OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87         newOwner = address(0);
88     }
89 }
90 
91 // ----------------------------------------------------------------------------
92 // ERC20 Token, with the addition of symbol, name and decimals and assisted
93 // token transfers
94 // ----------------------------------------------------------------------------
95 contract wallcoinToken is ERC20Interface, Owned, SafeMath {
96     string public symbol;
97     string public  name;
98     uint8 public decimals;
99     uint public _totalSupply;
100     uint public startDate;
101     uint public bonusEnds;
102     uint public endDate;
103 
104     mapping(address => uint) balances;
105     mapping(address => mapping(address => uint)) allowed;
106 
107     // ------------------------------------------------------------------------
108     // Constructor
109     // ------------------------------------------------------------------------
110     function wallcoinToken() public {
111         symbol = "WALL";
112         name = "WallCoin Token";
113         decimals = 18;
114         bonusEnds = now + 1 weeks;
115         endDate = now + 7 weeks;
116     }
117 
118     // ------------------------------------------------------------------------
119     // Total supply
120     // ------------------------------------------------------------------------
121     function totalSupply() public constant returns (uint) {
122         return _totalSupply  - balances[address(0)];
123     }
124 
125     // ------------------------------------------------------------------------
126     // Get the token balance for account `tokenOwner`
127     // ------------------------------------------------------------------------
128     function balanceOf(address tokenOwner) public constant returns (uint balance) {
129         return balances[tokenOwner];
130     }
131 
132     // ------------------------------------------------------------------------
133     // Transfer the balance from token owner's account to `to` account
134     // - Owner's account must have sufficient balance to transfer
135     // - 0 value transfers are allowed
136     // ------------------------------------------------------------------------
137     function transfer(address to, uint tokens) public returns (bool success) {
138         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
139         balances[to] = safeAdd(balances[to], tokens);
140         Transfer(msg.sender, to, tokens);
141         return true;
142     }
143 
144     // ------------------------------------------------------------------------
145     // Token owner can approve for `spender` to transferFrom(...) `tokens`
146     // from the token owner's account
147     //
148     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
149     // recommends that there are no checks for the approval double-spend attack
150     // as this should be implemented in user interfaces
151     // ------------------------------------------------------------------------
152     function approve(address spender, uint tokens) public returns (bool success) {
153         allowed[msg.sender][spender] = tokens;
154         Approval(msg.sender, spender, tokens);
155         return true;
156     }
157 
158     // ------------------------------------------------------------------------
159     // Transfer `tokens` from the `from` account to the `to` account
160     //
161     // The calling account must already have sufficient tokens approve(...)-d
162     // for spending from the `from` account and
163     // - From account must have sufficient balance to transfer
164     // - Spender must have sufficient allowance to transfer
165     // - 0 value transfers are allowed
166     // ------------------------------------------------------------------------
167     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
168         balances[from] = safeSub(balances[from], tokens);
169         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
170         balances[to] = safeAdd(balances[to], tokens);
171         Transfer(from, to, tokens);
172         return true;
173     }
174 
175     // ------------------------------------------------------------------------
176     // Returns the amount of tokens approved by the owner that can be
177     // transferred to the spender's account
178     // ------------------------------------------------------------------------
179     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
180         return allowed[tokenOwner][spender];
181     }
182 
183     // ------------------------------------------------------------------------
184     // Token owner can approve for `spender` to transferFrom(...) `tokens`
185     // from the token owner's account. The `spender` contract function
186     // `receiveApproval(...)` is then executed
187     // ------------------------------------------------------------------------
188     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
189         allowed[msg.sender][spender] = tokens;
190         Approval(msg.sender, spender, tokens);
191         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
192         return true;
193     }
194 
195     // ------------------------------------------------------------------------
196     // 1,000 WALL Tokens per 1 ETH
197     // ------------------------------------------------------------------------
198     function () public payable {
199         require(now >= startDate && now <= endDate);
200         uint tokens;
201         if (now <= bonusEnds) {
202             tokens = msg.value * 1200;
203         } else {
204             tokens = msg.value * 1000;
205         }
206         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
207         _totalSupply = safeAdd(_totalSupply, tokens);
208         Transfer(address(0), msg.sender, tokens);
209         owner.transfer(msg.value);
210     }
211 
212     // ------------------------------------------------------------------------
213     // Owner can transfer out any accidentally sent ERC20 tokens
214     // ------------------------------------------------------------------------
215     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
216         return ERC20Interface(tokenAddress).transfer(owner, tokens);
217     }
218 }