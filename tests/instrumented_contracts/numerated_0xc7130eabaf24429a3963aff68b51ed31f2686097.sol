1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // --- 'TSRX' 'TessrX' token contract
5 // --- Symbol      : TSRX
6 // --- Name        : TessrX
7 // --- Total supply: Generated from contributions
8 // --- Decimals    : 18
9 // --- @author EJS32 
10 // --- @title for 01101101 01111001 01101100 01101111 01110110 01100101
11 // --- (c) Tessr8RT / tessr.io 2018. The MIT License.
12 // ----------------------------------------------------------------------------
13 
14 // ----------------------------------------------------------------------------
15 // --- Safe maths
16 // ----------------------------------------------------------------------------
17 contract SafeMath {
18     function safeAdd(uint a, uint b) public pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function safeSub(uint a, uint b) public pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) public pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function safeDiv(uint a, uint b) public pure returns (uint c) {
31         c = a / b;
32         require(b > 0);
33     }
34 }
35 
36 // ----------------------------------------------------------------------------
37 // --- ERC Token Standard #20 Interface
38 // --- https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() public constant returns (uint);
42     function balanceOf(address tokenOwner) public constant returns (uint balance);
43     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
44     function transfer(address to, uint tokens) public returns (bool success);
45     function approve(address spender, uint tokens) public returns (bool success);
46     function transferFrom(address from, address to, uint tokens) public returns (bool success);
47 
48     event Transfer(address indexed from, address indexed to, uint tokens);
49     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // --- Contract function to receive approval and execute function in one call
55 // ----------------------------------------------------------------------------
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // --- Owned contract
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
82     function acceptOwnership() public {
83         require(msg.sender == newOwner);
84          emit OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86         newOwner = address(0);
87     }
88 }
89 
90 // ----------------------------------------------------------------------------
91 // --- ERC20 Token, with the addition of symbol, name and decimals
92 // --- Receives ETH and generates tokens
93 // ----------------------------------------------------------------------------
94 contract TessrX is ERC20Interface, Owned, SafeMath {
95     string public symbol;
96     string public  name;
97     uint8 public decimals;
98     uint public _totalSupply;
99     uint public startDate;
100     uint public bonusEnds;
101     uint public endDate;
102 
103     mapping(address => uint) balances;
104     mapping(address => mapping(address => uint)) allowed;
105 
106 
107 // ------------------------------------------------------------------------
108 // --- Constructor
109 // ------------------------------------------------------------------------
110     function TessrX() public {
111         symbol = "TSRX";
112         name = "TessrX";
113         decimals = 18;
114         _totalSupply = 400000000000000000000000000;
115         startDate = now;
116         bonusEnds = now + 1 weeks;
117         endDate = now + 4 weeks;
118         balances[owner] = _totalSupply;
119         emit Transfer(address(0), owner, _totalSupply);
120     }
121 
122 
123 // ------------------------------------------------------------------------
124 // --- Total supply
125 // ------------------------------------------------------------------------
126     function totalSupply() public constant returns (uint) {
127         return _totalSupply  - balances[address(0)];
128     }
129 
130 
131 // ------------------------------------------------------------------------
132 // --- Get the token balance for account `tokenOwner`
133 // ------------------------------------------------------------------------
134     function balanceOf(address tokenOwner) public constant returns (uint balance) {
135         return balances[tokenOwner];
136     }
137 
138 // ------------------------------------------------------------------------
139 // --- Transfer the balance from token owner's account to `to` account
140 // --- Owner's account must have sufficient balance to transfer
141 // --- 0 value transfers are allowed
142 // ------------------------------------------------------------------------
143     function transfer(address to, uint tokens) public returns (bool success) {
144         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
145         balances[to] = safeAdd(balances[to], tokens);
146          emit Transfer(msg.sender, to, tokens);
147         return true;
148     }
149 
150 // ------------------------------------------------------------------------
151 // --- Token owner can approve for `spender` to transferFrom(...) `tokens`
152 // --- from the token owner's account
153 // --- https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
154 // --- recommends that there are no checks for the approval double-spend attack
155 // --- as this should be implemented in user interfaces 
156 // ------------------------------------------------------------------------
157     function approve(address spender, uint tokens) public returns (bool success) {
158         allowed[msg.sender][spender] = tokens;
159         emit Approval(msg.sender, spender, tokens);
160         return true;
161     }
162 
163 // ------------------------------------------------------------------------
164 // --- Transfer `tokens` from the `from` account to the `to` account
165 // --- The calling account must already have sufficient tokens approve(...)-d
166 // --- for spending from the `from` account and
167 // --- From account must have sufficient balance to transfer
168 // --- Spender must have sufficient allowance to transfer
169 // --- 0 value transfers are allowed
170 // ------------------------------------------------------------------------
171     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
172         balances[from] = safeSub(balances[from], tokens);
173         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
174         balances[to] = safeAdd(balances[to], tokens);
175          emit Transfer(from, to, tokens);
176         return true;
177     }
178 
179 // ------------------------------------------------------------------------
180 // --- Returns the amount of tokens approved by the owner that can be
181 // --- transferred to the spender's account
182 // ------------------------------------------------------------------------
183     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
184         return allowed[tokenOwner][spender];
185     }
186 
187 
188 // ------------------------------------------------------------------------
189 // --- Token owner can approve for `spender` to transferFrom(...) `tokens`
190 // --- from the token owner's account. The `spender` contract function
191 // --- `receiveApproval(...)` is then executed
192 // ------------------------------------------------------------------------
193     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
194         allowed[msg.sender][spender] = tokens;
195          emit Approval(msg.sender, spender, tokens);
196         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
197         return true;
198     }
199 
200 
201 // ------------------------------------------------------------------------
202 // --- 6,000 tokens per 1 ETH, with 0% bonus
203 // ------------------------------------------------------------------------
204     function () public payable {
205         require(now >= startDate && now <= endDate);
206         uint tokens;
207         if (now <= bonusEnds) {
208             tokens = msg.value * 6000;
209         } else {
210             tokens = msg.value * 6000;
211         }
212         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
213         _totalSupply = safeAdd(_totalSupply, tokens);
214          emit Transfer(address(0), msg.sender, tokens);
215         owner.transfer(msg.value);
216     }
217 
218 
219 // ------------------------------------------------------------------------
220 // --- Owner can transfer out any accidentally sent ERC20 tokens
221 // ------------------------------------------------------------------------
222     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
223         return ERC20Interface(tokenAddress).transfer(owner, tokens);
224     }
225 }