1 pragma solidity ^0.4.18;
2  // ----------------------------------------------------------------------------
3 // 'FeniXCoin' token contract
4 //
5 // Deployed to : 0xabc4B357D7419cfD3747DC1338e9e6308612D87c
6 // Symbol      : FEX
7 // Name        : FeniXCoin
8 // Total supply: 15000000
9 // Decimals    : 18
10 //
11 // Enjoy.
12 //
13 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
14 // ----------------------------------------------------------------------------
15  // ----------------------------------------------------------------------------
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
36  // ----------------------------------------------------------------------------
37 // ERC Token Standard #20 Interface
38 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() public constant returns (uint);
42     function balanceOf(address tokenOwner) public constant returns (uint balance);
43     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
44     function transfer(address to, uint tokens) public returns (bool success);
45     function approve(address spender, uint tokens) public returns (bool success);
46     function transferFrom(address from, address to, uint tokens) public returns (bool success);
47      event Transfer(address indexed from, address indexed to, uint tokens);
48     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
49 }
50  // ----------------------------------------------------------------------------
51 // Contract function to receive approval and execute function in one call
52 //
53 // Borrowed from MiniMeToken
54 // ----------------------------------------------------------------------------
55 contract ApproveAndCallFallBack {
56     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
57 }
58  // ----------------------------------------------------------------------------
59 // Owned contract
60 // ----------------------------------------------------------------------------
61 contract Owned {
62     address public owner;
63     address public newOwner;
64      event OwnershipTransferred(address indexed _from, address indexed _to);
65      constructor() public {
66         owner = msg.sender;
67     }
68      modifier onlyOwner {
69         require(msg.sender == owner);
70         _;
71     }
72      function transferOwnership(address _newOwner) public onlyOwner {
73         newOwner = _newOwner;
74     }
75     function acceptOwnership() public {
76         require(msg.sender == newOwner);
77         emit OwnershipTransferred(owner, newOwner);
78         owner = newOwner;
79         newOwner = address(0);
80     }
81 }
82  // ----------------------------------------------------------------------------
83 // ERC20 Token, with the addition of symbol, name and decimals and assisted
84 // token transfers
85 // ----------------------------------------------------------------------------
86 contract FeniXCoin is ERC20Interface, Owned, SafeMath {
87     string public symbol;
88     string public  name;
89     uint8 public decimals;
90     uint public _totalSupply;
91      mapping(address => uint) balances;
92     mapping(address => mapping(address => uint)) allowed;
93      // ------------------------------------------------------------------------
94     // Constructor
95     // ------------------------------------------------------------------------
96     constructor() public {
97         symbol = "FEX";
98         name = "FeniXCoin";
99         decimals = 18;
100         _totalSupply = 15000000000000000000000000;
101         balances[0xabc4B357D7419cfD3747DC1338e9e6308612D87c] = _totalSupply;
102         emit Transfer(address(0), 0xabc4B357D7419cfD3747DC1338e9e6308612D87c, _totalSupply);
103     }
104      // ------------------------------------------------------------------------
105     // Total supply
106     // ------------------------------------------------------------------------
107     function totalSupply() public constant returns (uint) {
108         return _totalSupply  - balances[address(0)];
109     }
110      // ------------------------------------------------------------------------
111     // Get the token balance for account tokenOwner
112     // ------------------------------------------------------------------------
113     function balanceOf(address tokenOwner) public constant returns (uint balance) {
114         return balances[tokenOwner];
115     }
116      // ------------------------------------------------------------------------
117     // Transfer the balance from token owner's account to to account
118     // - Owner's account must have sufficient balance to transfer
119     // - 0 value transfers are allowed
120     // ------------------------------------------------------------------------
121     function transfer(address to, uint tokens) public returns (bool success) {
122         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
123         balances[to] = safeAdd(balances[to], tokens);
124         emit Transfer(msg.sender, to, tokens);
125         return true;
126     }
127      // ------------------------------------------------------------------------
128     // Token owner can approve for spender to transferFrom(...) tokens
129     // from the token owner's account
130     //
131     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
132     // recommends that there are no checks for the approval double-spend attack
133     // as this should be implemented in user interfaces 
134     // ------------------------------------------------------------------------
135     function approve(address spender, uint tokens) public returns (bool success) {
136         allowed[msg.sender][spender] = tokens;
137         emit Approval(msg.sender, spender, tokens);
138         return true;
139     }
140      // ------------------------------------------------------------------------
141     // Transfer tokens from the from account to the to account
142     // 
143     // The calling account must already have sufficient tokens approve(...)-d
144     // for spending from the from account and
145     // - From account must have sufficient balance to transfer
146     // - Spender must have sufficient allowance to transfer
147     // - 0 value transfers are allowed
148     // ------------------------------------------------------------------------
149     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
150         balances[from] = safeSub(balances[from], tokens);
151         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
152         balances[to] = safeAdd(balances[to], tokens);
153         emit Transfer(from, to, tokens);
154         return true;
155     }
156      // ------------------------------------------------------------------------
157     // Returns the amount of tokens approved by the owner that can be
158     // transferred to the spender's account
159     // ------------------------------------------------------------------------
160     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
161         return allowed[tokenOwner][spender];
162     }
163      // ------------------------------------------------------------------------
164     // Token owner can approve for spender to transferFrom(...) tokens
165     // from the token owner's account. The spender contract function
166     // receiveApproval(...) is then executed
167     // ------------------------------------------------------------------------
168     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
169         allowed[msg.sender][spender] = tokens;
170         emit Approval(msg.sender, spender, tokens);
171         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
172         return true;
173     }
174      // ------------------------------------------------------------------------
175     // Don't accept ETH
176     // ------------------------------------------------------------------------
177     function () public payable {
178         revert();
179     }
180      // ------------------------------------------------------------------------
181     // Owner can transfer out any accidentally sent ERC20 tokens
182     // ------------------------------------------------------------------------
183     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
184         return ERC20Interface(tokenAddress).transfer(owner, tokens);
185     }
186 }