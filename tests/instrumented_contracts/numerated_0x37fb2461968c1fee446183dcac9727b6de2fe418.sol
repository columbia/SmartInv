1 pragma solidity ^0.4.24;
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
28 // ----------------------------------------------------------------------------
29 contract ERC20Interface {
30     function totalSupply() public constant returns (uint);
31     function balanceOf(address tokenOwner) public constant returns (uint balance);
32     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
33     function transfer(address to, uint tokens) public returns (bool success);
34     function approve(address spender, uint tokens) public returns (bool success);
35     function transferFrom(address from, address to, uint tokens) public returns (bool success);
36 
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 
42 // ----------------------------------------------------------------------------
43 // Contract function to receive approval and execute function in one call
44 // ----------------------------------------------------------------------------
45 contract ApproveAndCallFallBack {
46     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
47 }
48 
49 
50 // ----------------------------------------------------------------------------
51 // Owned contract
52 // ----------------------------------------------------------------------------
53 contract Owned {
54     address public owner;
55     address public newOwner;
56 
57     event OwnershipTransferred(address indexed _from, address indexed _to);
58 
59     constructor() public {
60         owner = msg.sender;
61     }
62 
63     modifier onlyOwner {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     function transferOwnership(address _newOwner) public onlyOwner {
69         newOwner = _newOwner;
70     }
71     function acceptOwnership() public {
72         require(msg.sender == newOwner);
73         emit OwnershipTransferred(owner, newOwner);
74         owner = newOwner;
75         newOwner = address(0);
76     }
77 }
78 
79 
80 // ----------------------------------------------------------------------------
81 // ERC20 Token, with the addition of symbol, name and decimals and assisted
82 // token transfers
83 // ----------------------------------------------------------------------------
84 contract ZooggCoin is ERC20Interface, Owned, SafeMath {
85     string public symbol;
86     string public  name;
87     uint8 public decimals;
88     uint public _totalSupply;
89 
90     mapping(address => uint) balances;
91     mapping(address => mapping(address => uint)) allowed;
92 
93 
94     // ------------------------------------------------------------------------
95     // Constructor
96     // ------------------------------------------------------------------------
97     constructor() public {
98         symbol = "ZGG";
99         name = "Zoogg Coin";
100         decimals = 18;
101         _totalSupply = 180000000e18;
102         balances[0xd44437cac6B8544912710961F058113D58c506B2] = _totalSupply;
103         emit Transfer(address(0), 0xd44437cac6B8544912710961F058113D58c506B2, _totalSupply);
104     }
105 
106 
107     // ------------------------------------------------------------------------
108     // Total supply
109     // ------------------------------------------------------------------------
110     function totalSupply() public constant returns (uint) {
111         return _totalSupply  - balances[address(0)];
112     }
113 
114 
115     // ------------------------------------------------------------------------
116     // Get the token balance for account tokenOwner
117     // ------------------------------------------------------------------------
118     function balanceOf(address tokenOwner) public constant returns (uint balance) {
119         return balances[tokenOwner];
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Transfer the balance from token owner's account to to account
125     // - Owner's account must have sufficient balance to transfer
126     // - 0 value transfers are allowed
127     // ------------------------------------------------------------------------
128     function transfer(address to, uint tokens) public returns (bool success) {
129         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
130         balances[to] = safeAdd(balances[to], tokens);
131         emit Transfer(msg.sender, to, tokens);
132         return true;
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Token owner can approve for spender to transferFrom(...) tokens
138     // from the token owner's account
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
201 }