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
38 
39 // ----------------------------------------------------------------------------
40 // Contract function to receive approval and execute function in one call
41 // ----------------------------------------------------------------------------
42 contract ApproveAndCallFallBack {
43     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
44 }
45 
46 
47 // ----------------------------------------------------------------------------
48 // Owned contract
49 // ----------------------------------------------------------------------------
50 contract Owned {
51     address public owner;
52     address public newOwner;
53 
54     event OwnershipTransferred(address indexed _from, address indexed _to);
55 
56     function Owned() public {
57         owner = msg.sender;
58     }
59 
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     function transferOwnership(address _newOwner) public onlyOwner {
66         newOwner = _newOwner;
67     }
68     function acceptOwnership() public {
69         require(msg.sender == newOwner);
70         OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72         newOwner = address(0);
73     }
74 }
75 
76 
77 // ----------------------------------------------------------------------------
78 // ERC20 Token, with the addition of symbol, name and decimals and assisted
79 // token transfers
80 // ----------------------------------------------------------------------------
81 contract BitBall is ERC20Interface, Owned, SafeMath {
82     string public symbol;
83     string public  name;
84     uint8 public decimals;
85     uint public _totalSupply;
86 
87     mapping(address => uint) balances;
88     mapping(address => mapping(address => uint)) allowed;
89 
90 
91     // ------------------------------------------------------------------------
92     // Constructor
93     // ------------------------------------------------------------------------
94     function BitBall() public {
95         symbol = "BTB";
96         name = "BitBall";
97         decimals = 18;
98         _totalSupply = 1000000000000000000000000000;
99         balances[0x6a29063DD421Bf38a18b5a7455Fb6fE5f36F7992] = _totalSupply;
100         Transfer(address(0), 0x6a29063DD421Bf38a18b5a7455Fb6fE5f36F7992, _totalSupply);
101     }
102 
103 
104     // ------------------------------------------------------------------------
105     // Total supply
106     // ------------------------------------------------------------------------
107     function totalSupply() public constant returns (uint) {
108         return _totalSupply  - balances[address(0)];
109     }
110 
111 
112     // ------------------------------------------------------------------------
113     // Get the token balance for account tokenOwner
114     // ------------------------------------------------------------------------
115     function balanceOf(address tokenOwner) public constant returns (uint balance) {
116         return balances[tokenOwner];
117     }
118 
119 
120     // ------------------------------------------------------------------------
121     // Transfer the balance from token owner's account to to account
122     // - Owner's account must have sufficient balance to transfer
123     // - 0 value transfers are allowed
124     // ------------------------------------------------------------------------
125     function transfer(address to, uint tokens) public returns (bool success) {
126         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
127         balances[to] = safeAdd(balances[to], tokens);
128         Transfer(msg.sender, to, tokens);
129         return true;
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Token owner can approve for spender to transferFrom(...) tokens
135     // ------------------------------------------------------------------------
136     function approve(address spender, uint tokens) public returns (bool success) {
137         allowed[msg.sender][spender] = tokens;
138         Approval(msg.sender, spender, tokens);
139         return true;
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Transfer tokens from the from account to the to account
145     // 
146     // The calling account must already have sufficient tokens approve(...)-d
147     // for spending from the from account and
148     // - From account must have sufficient balance to transfer
149     // - Spender must have sufficient allowance to transfer
150     // - 0 value transfers are allowed
151     // ------------------------------------------------------------------------
152     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
153         balances[from] = safeSub(balances[from], tokens);
154         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
155         balances[to] = safeAdd(balances[to], tokens);
156         Transfer(from, to, tokens);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Returns the amount of tokens approved by the owner that can be
163     // transferred to the spender's account
164     // ------------------------------------------------------------------------
165     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
166         return allowed[tokenOwner][spender];
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Token owner can approve for spender to transferFrom(...) tokens
172     // from the token owner's account. The spender contract function
173     // receiveApproval(...) is then executed
174     // ------------------------------------------------------------------------
175     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
176         allowed[msg.sender][spender] = tokens;
177         Approval(msg.sender, spender, tokens);
178         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
179         return true;
180     }
181 
182 
183     // ------------------------------------------------------------------------
184     // Don't accept ETH
185     // ------------------------------------------------------------------------
186     function () public payable {
187         revert();
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Owner can transfer out any accidentally sent ERC20 tokens
193     // ------------------------------------------------------------------------
194     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
195         return ERC20Interface(tokenAddress).transfer(owner, tokens);
196     }
197 }