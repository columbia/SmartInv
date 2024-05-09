1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'Windhan' token contract
5 //
6 // Deployed to : 0x8957889835caFe59F30650eaB3360798aF332074
7 // Symbol      : WHN
8 // Name        : Windhan
9 // Total supply: 250000000e18
10 // Decimals    : 18
11 //
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
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
32         require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 
38 // ----------------------------------------------------------------------------
39 // ERC Token Standard #20 Interface
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint);
43     function balanceOf(address tokenOwner) public constant returns (uint balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Contract function to receive approval and execute function in one call
56 // ----------------------------------------------------------------------------
57 contract ApproveAndCallFallBack {
58     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
59 }
60 
61 
62 // ----------------------------------------------------------------------------
63 // Owned contract
64 // ----------------------------------------------------------------------------
65 contract Owned {
66     address public owner;
67     address public newOwner;
68 
69     event OwnershipTransferred(address indexed _from, address indexed _to);
70 
71     constructor() public {
72         owner = msg.sender;
73     }
74 
75     modifier onlyOwner {
76         require(msg.sender == owner);
77         _;
78     }
79 
80     function transferOwnership(address _newOwner) public onlyOwner {
81         newOwner = _newOwner;
82     }
83     function acceptOwnership() public {
84         require(msg.sender == newOwner);
85         emit OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87         newOwner = address(0);
88     }
89 }
90 
91 
92 // ----------------------------------------------------------------------------
93 // ERC20 Token, with the addition of symbol, name and decimals and assisted
94 // token transfers
95 // ----------------------------------------------------------------------------
96 contract Windhan is ERC20Interface, Owned, SafeMath {
97     string public symbol;
98     string public  name;
99     uint8 public decimals;
100     uint public _totalSupply;
101 
102     mapping(address => uint) balances;
103     mapping(address => mapping(address => uint)) allowed;
104 
105 
106     // ------------------------------------------------------------------------
107     // Constructor
108     // ------------------------------------------------------------------------
109     constructor() public {
110         symbol = "WHN";
111         name = "Windhan";
112         decimals = 18;
113         _totalSupply = 250000000e18; 
114         balances[0x8957889835caFe59F30650eaB3360798aF332074] = _totalSupply;
115         emit Transfer(address(0), 0x8957889835caFe59F30650eaB3360798aF332074, _totalSupply);
116     }
117 
118 
119     // ------------------------------------------------------------------------
120     // Total supply
121     // ------------------------------------------------------------------------
122     function totalSupply() public constant returns (uint) {
123         return _totalSupply  - balances[address(0)];
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Get the token balance for account tokenOwner
129     // ------------------------------------------------------------------------
130     function balanceOf(address tokenOwner) public constant returns (uint balance) {
131         return balances[tokenOwner];
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Transfer the balance from token owner's account to to account
137     // - Owner's account must have sufficient balance to transfer
138     // - 0 value transfers are allowed
139     // ------------------------------------------------------------------------
140     function transfer(address to, uint tokens) public returns (bool success) {
141         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
142         balances[to] = safeAdd(balances[to], tokens);
143         emit Transfer(msg.sender, to, tokens);
144         return true;
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Token owner can approve for spender to transferFrom(...) tokens
150     // from the token owner's account
151     // ------------------------------------------------------------------------
152     function approve(address spender, uint tokens) public returns (bool success) {
153         allowed[msg.sender][spender] = tokens;
154         emit Approval(msg.sender, spender, tokens);
155         return true;
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Transfer tokens from the from account to the to account
161     // 
162     // The calling account must already have sufficient tokens approve(...)-d
163     // for spending from the from account and
164     // - From account must have sufficient balance to transfer
165     // - Spender must have sufficient allowance to transfer
166     // - 0 value transfers are allowed
167     // ------------------------------------------------------------------------
168     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
169         balances[from] = safeSub(balances[from], tokens);
170         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
171         balances[to] = safeAdd(balances[to], tokens);
172         emit Transfer(from, to, tokens);
173         return true;
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Returns the amount of tokens approved by the owner that can be
179     // transferred to the spender's account
180     // ------------------------------------------------------------------------
181     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
182         return allowed[tokenOwner][spender];
183     }
184 
185 
186     // ------------------------------------------------------------------------
187     // Token owner can approve for spender to transferFrom(...) tokens
188     // from the token owner's account. The spender contract function
189     // receiveApproval(...) is then executed
190     // ------------------------------------------------------------------------
191     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
192         allowed[msg.sender][spender] = tokens;
193         emit Approval(msg.sender, spender, tokens);
194         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
195         return true;
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Don't accept ETH
201     // ------------------------------------------------------------------------
202     function () public payable {
203         revert();
204     }
205 
206 
207     // ------------------------------------------------------------------------
208     // Owner can transfer out any accidentally sent ERC20 tokens
209     // ------------------------------------------------------------------------
210     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
211         return ERC20Interface(tokenAddress).transfer(owner, tokens);
212     }
213 }