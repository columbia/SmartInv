1 pragma solidity ^0.4.18;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) public pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint a, uint b) public pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint a, uint b) public pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint a, uint b) public pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 
23 // ----------------------------------------------------------------------------
24 // ERC Token Standard #20 Interface
25 // ----------------------------------------------------------------------------
26 contract ERC20Interface {
27     function totalSupply() public constant returns (uint);
28     function balanceOf(address tokenOwner) public constant returns (uint balance);
29     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
30     function transfer(address to, uint tokens) public returns (bool success);
31     function approve(address spender, uint tokens) public returns (bool success);
32     function transferFrom(address from, address to, uint tokens) public returns (bool success);
33 
34     event Transfer(address indexed from, address indexed to, uint tokens);
35     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36 }
37 
38 contract ApproveAndCallFallBack {
39     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // Owned contract
45 // ----------------------------------------------------------------------------
46 contract Owned {
47     address public owner;
48     address public newOwner;
49 
50     event OwnershipTransferred(address indexed _from, address indexed _to);
51 
52     function Owned() public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address _newOwner) public onlyOwner {
62         newOwner = _newOwner;
63     }
64     function acceptOwnership() public {
65         require(msg.sender == newOwner);
66         OwnershipTransferred(owner, newOwner);
67         owner = newOwner;
68         newOwner = address(0);
69     }
70 }
71 
72 
73 // ----------------------------------------------------------------------------
74 // ERC20 Token, with the addition of symbol, name and decimals and assisted
75 // token transfers
76 // ----------------------------------------------------------------------------
77 contract BTRS is ERC20Interface, Owned, SafeMath {
78     string public symbol;
79     string public  name;
80     uint8 public decimals;
81     uint public _totalSupply;
82 
83     mapping(address => uint) balances;
84     mapping(address => mapping(address => uint)) allowed;
85 
86 
87     // ------------------------------------------------------------------------
88     // Constructor
89     // ------------------------------------------------------------------------
90     function BTRS() public {
91         symbol = "BTRS";
92         name = "BitBall Treasure";
93         decimals = 18;
94         _totalSupply = 1000000000000000000000000;
95         balances[0x6a29063DD421Bf38a18b5a7455Fb6fE5f36F7992] = _totalSupply;
96         Transfer(address(0), 0x6a29063DD421Bf38a18b5a7455Fb6fE5f36F7992, _totalSupply);
97     }
98 
99 
100     // ------------------------------------------------------------------------
101     // Total supply
102     // ------------------------------------------------------------------------
103     function totalSupply() public constant returns (uint) {
104         return _totalSupply  - balances[address(0)];
105     }
106 
107 
108     // ------------------------------------------------------------------------
109     // Get the token balance for account tokenOwner
110     // ------------------------------------------------------------------------
111     function balanceOf(address tokenOwner) public constant returns (uint balance) {
112         return balances[tokenOwner];
113     }
114 
115 
116     // ------------------------------------------------------------------------
117     // Transfer the balance from token owner's account to to account
118     // - Owner's account must have sufficient balance to transfer
119     // - 0 value transfers are allowed
120     // ------------------------------------------------------------------------
121     function transfer(address to, uint tokens) public returns (bool success) {
122         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
123         balances[to] = safeAdd(balances[to], tokens);
124         Transfer(msg.sender, to, tokens);
125         return true;
126     }
127 
128     function approve(address spender, uint tokens) public returns (bool success) {
129         allowed[msg.sender][spender] = tokens;
130         Approval(msg.sender, spender, tokens);
131         return true;
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Transfer tokens from the from account to the to account
137     // 
138     // The calling account must already have sufficient tokens approve(...)-d
139     // for spending from the from account and
140     // - From account must have sufficient balance to transfer
141     // - Spender must have sufficient allowance to transfer
142     // - 0 value transfers are allowed
143     // ------------------------------------------------------------------------
144     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
145         balances[from] = safeSub(balances[from], tokens);
146         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
147         balances[to] = safeAdd(balances[to], tokens);
148         Transfer(from, to, tokens);
149         return true;
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Returns the amount of tokens approved by the owner that can be
155     // transferred to the spender's account
156     // ------------------------------------------------------------------------
157     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
158         return allowed[tokenOwner][spender];
159     }
160 
161 
162     // ------------------------------------------------------------------------
163     // Token owner can approve for spender to transferFrom(...) tokens
164     // from the token owner's account. The spender contract function
165     // receiveApproval(...) is then executed
166     // ------------------------------------------------------------------------
167     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
168         allowed[msg.sender][spender] = tokens;
169         Approval(msg.sender, spender, tokens);
170         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
171         return true;
172     }
173 
174 
175     // ------------------------------------------------------------------------
176     // Don't accept ETH
177     // ------------------------------------------------------------------------
178     function () public payable {
179         revert();
180     }
181 
182 
183     // ------------------------------------------------------------------------
184     // Owner can transfer out any accidentally sent ERC20 tokens
185     // ------------------------------------------------------------------------
186     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
187         return ERC20Interface(tokenAddress).transfer(owner, tokens);
188     }
189 }