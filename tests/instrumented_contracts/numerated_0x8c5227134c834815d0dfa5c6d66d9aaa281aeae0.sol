1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // --- 'TSRX' 'tessr.credit' token contract
5 // --- Symbol      : TSRX
6 // --- Name        : tessr.credit
7 // --- Total supply: Generated from contributions
8 // --- Decimals    : 18
9 // --- @author EJS32 
10 // --- @title for 01101100 01101111 01110110 01100101
11 // --- (c) tessr.credit / tessr.io 2018. The MIT License.
12 // --- Version pragma solidity v0.4.21+commit.dfe3193c
13 // ----------------------------------------------------------------------------
14 
15 // ----------------------------------------------------------------------------
16 // --- Safe maths
17 // ----------------------------------------------------------------------------
18 contract SafeMath {
19     function safeAdd(uint a, uint b) public pure returns (uint c) {
20         c = a + b;
21         require(c >= a);
22     }
23     function safeSub(uint a, uint b) public pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function safeMul(uint a, uint b) public pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function safeDiv(uint a, uint b) public pure returns (uint c) {
32         c = a / b;
33         require(b > 0);
34     }
35 }
36 
37 // ----------------------------------------------------------------------------
38 // --- ERC Token Standard
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() public constant returns (uint);
42     function balanceOf(address tokenOwner) public constant returns (uint balance);
43     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
44     function transfer(address to, uint tokens) public returns (bool success);
45     function approve(address spender, uint tokens) public returns (bool success);
46     function transferFrom(address from, address to, uint tokens) public returns (bool success);
47     event Transfer(address indexed from, address indexed to, uint tokens);
48     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
49 }
50 
51 // ----------------------------------------------------------------------------
52 // --- Contract function to receive approval and execute function in one call
53 // ----------------------------------------------------------------------------
54 contract ApproveAndCallFallBack {
55     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
56 }
57 
58 // ----------------------------------------------------------------------------
59 // --- Contract Owned
60 // ----------------------------------------------------------------------------
61 contract Owned {
62     address public owner;
63     address public newOwner;
64     event OwnershipTransferred(address indexed _from, address indexed _to);
65     function Owned() public {
66         owner = msg.sender;
67     }
68 
69     modifier onlyOwner {
70         require(msg.sender == owner);
71         _;
72     }
73 
74     function transferOwnership(address _newOwner) public onlyOwner {
75         newOwner = _newOwner;
76     }
77 	
78     function acceptOwnership() public {
79         require(msg.sender == newOwner);
80          emit OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82         newOwner = address(0);
83     }
84 }
85 
86 // ----------------------------------------------------------------------------
87 // --- Contract tessrX
88 // ----------------------------------------------------------------------------
89 contract tessrX is ERC20Interface, Owned, SafeMath {
90     string public symbol;
91     string public  name;
92     uint8 public decimals;
93     uint public _totalSupply;
94     uint public startDate;
95     uint public bonusEnds;
96     uint public endDate;
97     mapping(address => uint) balances;
98     mapping(address => mapping(address => uint)) allowed;
99 
100 // ------------------------------------------------------------------------
101 // --- Constructor
102 // ------------------------------------------------------------------------
103     function tessrX() public {
104         symbol = "TSRX";
105         name = "tessr.credit";
106         decimals = 18;
107         _totalSupply = 400000000000000000000000000;
108         startDate = now;
109         bonusEnds = now + 7 days;
110         endDate = now + 38 days;
111         balances[owner] = _totalSupply;
112          emit Transfer(address(0), owner, _totalSupply);
113     }
114 
115 // ------------------------------------------------------------------------
116 // --- Total supply
117 // ------------------------------------------------------------------------
118     function totalSupply() public constant returns (uint) {
119         return _totalSupply  - balances[address(0)];
120     }
121 
122 // ------------------------------------------------------------------------
123 // --- Get the token balance for account `tokenOwner`
124 // ------------------------------------------------------------------------
125     function balanceOf(address tokenOwner) public constant returns (uint balance) {
126         return balances[tokenOwner];
127     }
128 
129 // ------------------------------------------------------------------------
130 // --- Transfer the balance from token owner's account to the `to` account
131 // --- Owner's account must have sufficient balance to transfer
132 // --- 0 value transfers are allowed
133 // ------------------------------------------------------------------------
134     function transfer(address to, uint tokens) public returns (bool success) {
135         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
136         balances[to] = safeAdd(balances[to], tokens);
137          emit Transfer(msg.sender, to, tokens);
138         return true;
139     }
140 
141 // ------------------------------------------------------------------------
142 // --- Token owner can approve for `spender` to transferFrom `tokens`
143 // ------------------------------------------------------------------------
144     function approve(address spender, uint tokens) public returns (bool success) {
145         allowed[msg.sender][spender] = tokens;
146          emit Approval(msg.sender, spender, tokens);
147         return true;
148     }
149 
150 // ------------------------------------------------------------------------
151 // --- Transfer `tokens` from the `from` account to the `to` account
152 // --- The calling account must already have sufficient tokens approved
153 // --- From account must have sufficient balance to transfer
154 // --- Spender must have sufficient allowance to transfer
155 // --- 0 value transfers are allowed
156 // ------------------------------------------------------------------------
157     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
158         balances[from] = safeSub(balances[from], tokens);
159         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
160         balances[to] = safeAdd(balances[to], tokens);
161          emit Transfer(from, to, tokens);
162         return true;
163     }
164 
165 // ------------------------------------------------------------------------
166 // --- Returns the amount of tokens approved by the owner that can be transferred
167 // ------------------------------------------------------------------------
168     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
169         return allowed[tokenOwner][spender];
170     }
171 
172 
173 // ------------------------------------------------------------------------
174 // --- Token owner can approve for `spender` to transferFrom `tokens`
175 // ------------------------------------------------------------------------
176     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
177         allowed[msg.sender][spender] = tokens;
178          emit Approval(msg.sender, spender, tokens);
179         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
180         return true;
181     }
182 
183 // ------------------------------------------------------------------------
184 // --- 5,000 tokens per 1 ETH, with 25% bonus
185 // ------------------------------------------------------------------------
186     function () public payable {
187         require(now >= startDate && now <= endDate);
188         uint tokens;
189         if (now <= bonusEnds) {
190             tokens = msg.value * 6250;
191         } else {
192             tokens = msg.value * 5000;
193         }
194         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
195         _totalSupply = safeAdd(_totalSupply, tokens);
196          emit Transfer(address(0), msg.sender, tokens);
197         owner.transfer(msg.value);
198     }
199 
200 // ------------------------------------------------------------------------
201 // --- Owner can transfer out any accidentally sent ERC20 tokens
202 // ------------------------------------------------------------------------
203     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
204         return ERC20Interface(tokenAddress).transfer(owner, tokens);
205     }
206 }