1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7     function safeAdd(uint a, uint b) public pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint a, uint b) public pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint a, uint b) public pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint a, uint b) public pure returns (uint c) {
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
45 // ----------------------------------------------------------------------------
46 contract ApproveAndCallFallBack {
47     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // Owned contract
53 // ----------------------------------------------------------------------------
54 contract Owned {
55     address public owner;
56     address public newOwner;
57 
58     event OwnershipTransferred(address indexed _from, address indexed _to);
59 
60     constructor() public {
61         owner = msg.sender;
62     }
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function transferOwnership(address _newOwner) public onlyOwner {
70         newOwner = _newOwner;
71     }
72     function acceptOwnership() public {
73         require(msg.sender == newOwner);
74         emit OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76         newOwner = address(0);
77     }
78 }
79 
80 
81 // ----------------------------------------------------------------------------
82 // ERC20 Token, with the addition of symbol, name and decimals and assisted
83 // token transfers
84 // ----------------------------------------------------------------------------
85 contract Orectic is ERC20Interface, Owned, SafeMath {
86     string public symbol;
87     string public  name;
88     uint8 public decimals;
89     uint public _totalSupply;
90 
91     mapping(address => uint) balances;
92     mapping(address => mapping(address => uint)) allowed;
93 
94 
95     // ------------------------------------------------------------------------
96     // Constructor
97     // ------------------------------------------------------------------------
98     constructor() public {
99         symbol = "ORE"; // v8
100         name = "Orectic";
101         decimals = 8;
102         _totalSupply = 50000000000000000;
103         balances[msg.sender] = _totalSupply;
104         emit Transfer(address(0), msg.sender, _totalSupply);
105     }
106 
107     // ------------------------------------------------------------------------
108     // Total supply
109     // ------------------------------------------------------------------------
110     function totalSupply() public constant returns (uint) {
111         return _totalSupply  - balances[address(0)];
112     }
113 
114     // ------------------------------------------------------------------------
115     // Get the token balance for account tokenOwner
116     // ------------------------------------------------------------------------
117     function balanceOf(address tokenOwner) public constant returns (uint balance) {
118         return balances[tokenOwner];
119     }
120 
121     // ------------------------------------------------------------------------
122     // Transfer the balance from token owner's account to to account
123     // - Owner's account must have sufficient balance to transfer
124     // ------------------------------------------------------------------------
125     function transfer(address to, uint tokens) public returns (bool success) {
126         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
127         balances[to] = safeAdd(balances[to], tokens);
128         emit Transfer(msg.sender, to, tokens);
129         return true;
130     }
131 
132     // ------------------------------------------------------------------------
133     // Token owner can approve for spender to transferFrom(...) tokens
134     // from the token owner's account
135     //
136     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
137     // recommends that there are no checks for the approval double-spend attack
138     // as this should be implemented in user interfaces 
139     // ------------------------------------------------------------------------
140     function approve(address spender, uint tokens) public returns (bool success) {
141         allowed[msg.sender][spender] = tokens;
142         emit Approval(msg.sender, spender, tokens);
143         return true;
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Transfer tokens from the from account to the to account
149     // 
150     // The calling account must already have sufficient tokens approve(...)-d
151     // for spending from the from account and
152     // - From account must have sufficient balance to transfer
153     // - Spender must have sufficient allowance to transfer
154     // - 0 value transfers are allowed
155     // ------------------------------------------------------------------------
156     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
157         balances[from] = safeSub(balances[from], tokens);
158         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
159         balances[to] = safeAdd(balances[to], tokens);
160         emit Transfer(from, to, tokens);
161         return true;
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Returns the amount of tokens approved by the owner that can be
167     // transferred to the spender's account
168     // ------------------------------------------------------------------------
169     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
170         return allowed[tokenOwner][spender];
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Token owner can approve for spender to transferFrom(...) tokens
176     // from the token owner's account. The spender contract function
177     // receiveApproval(...) is then executed
178     // ------------------------------------------------------------------------
179     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
180         allowed[msg.sender][spender] = tokens;
181         emit Approval(msg.sender, spender, tokens);
182         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
183         return true;
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Don't accept ETH
189     // ------------------------------------------------------------------------
190     function () public payable {
191         revert();
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Owner can transfer out any accidentally sent ERC20 tokens
197     // ------------------------------------------------------------------------
198     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
199         return ERC20Interface(tokenAddress).transfer(owner, tokens);
200     }
201 
202     function multisend(address[] dests, uint256[] values) public onlyOwner returns (bool success) {
203         require (dests.length == values.length);
204         uint256 bal = balances[msg.sender];
205         for (uint i = 0; i < values.length; i++){
206             require(values[i] <= bal);
207             bal = bal - values[i];
208             balances[dests[i]] = balances[dests[i]] + values[i];
209             emit Transfer(msg.sender, dests[i], values[i]);
210         }
211         balances[msg.sender] = bal;
212         return true;
213     }
214 }