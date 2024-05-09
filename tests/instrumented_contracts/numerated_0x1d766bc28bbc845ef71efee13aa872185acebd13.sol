1 pragma solidity 0.4.24;
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
25 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
26 // ----------------------------------------------------------------------------
27 contract ERC20Interface {
28     function totalSupply() public constant returns (uint);
29     function balanceOf(address tokenOwner) public constant returns (uint balance);
30     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
31     function transfer(address to, uint tokens) public returns (bool success);
32     function approve(address spender, uint tokens) public returns (bool success);
33     function transferFrom(address from, address to, uint tokens) public returns (bool success);
34 
35     event Transfer(address indexed from, address indexed to, uint tokens);
36     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // Contract function to receive approval and execute function in one call
42 //
43 // Borrowed from MiniMeToken
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
59     function Owned() public {
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
73         OwnershipTransferred(owner, newOwner);
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
84 contract Follor is ERC20Interface, Owned, SafeMath {
85     string public symbol;
86     string public  name;
87     uint8 public decimals;
88     uint public _totalSupply;
89 
90     mapping(address => uint) balances;
91     mapping(address => mapping(address => uint)) allowed;
92 
93 
94     function Follor() public {
95         symbol = "OLLO";
96         name = "FOLLOR";
97         decimals = 18;
98         _totalSupply = 700000000000000000000000000;
99         balances[0x0E00D8Bc271a6121CbDe6D542AbC7185C0F9D983] = _totalSupply;
100         Transfer(address(0), 0x0E00D8Bc271a6121CbDe6D542AbC7185C0F9D983, _totalSupply);
101     }
102 
103 
104     function totalSupply() public constant returns (uint) {
105         return _totalSupply  - balances[address(0)];
106     }
107 
108 
109     // ------------------------------------------------------------------------
110     // Get the token balance for account tokenOwner
111     // ------------------------------------------------------------------------
112     function balanceOf(address tokenOwner) public constant returns (uint balance) {
113         return balances[tokenOwner];
114     }
115 
116 
117     // ------------------------------------------------------------------------
118     // Transfer the balance from token owner's account to to account
119     // - Owner's account must have sufficient balance to transfer
120     // - 0 value transfers are allowed
121     // ------------------------------------------------------------------------
122     function transfer(address to, uint tokens) public returns (bool success) {
123         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
124         balances[to] = safeAdd(balances[to], tokens);
125         Transfer(msg.sender, to, tokens);
126         return true;
127     }
128 
129 
130     // ------------------------------------------------------------------------
131     // Token owner can approve for spender to transferFrom(...) tokens
132     // from the token owner's account
133     //
134     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
135     // recommends that there are no checks for the approval double-spend attack
136     // as this should be implemented in user interfaces 
137     // ------------------------------------------------------------------------
138     function approve(address spender, uint tokens) public returns (bool success) {
139         allowed[msg.sender][spender] = tokens;
140         Approval(msg.sender, spender, tokens);
141         return true;
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Transfer tokens from the from account to the to account
147     // 
148     // The calling account must already have sufficient tokens approve(...)-d
149     // for spending from the from account and
150     // - From account must have sufficient balance to transfer
151     // - Spender must have sufficient allowance to transfer
152     // - 0 value transfers are allowed
153     // ------------------------------------------------------------------------
154     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
155         balances[from] = safeSub(balances[from], tokens);
156         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
157         balances[to] = safeAdd(balances[to], tokens);
158         Transfer(from, to, tokens);
159         return true;
160     }
161 
162 
163     // ------------------------------------------------------------------------
164     // Returns the amount of tokens approved by the owner that can be
165     // transferred to the spender's account
166     // ------------------------------------------------------------------------
167     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
168         return allowed[tokenOwner][spender];
169     }
170 
171 
172     // ------------------------------------------------------------------------
173     // Token owner can approve for spender to transferFrom(...) tokens
174     // from the token owner's account. The spender contract function
175     // receiveApproval(...) is then executed
176     // ------------------------------------------------------------------------
177     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
178         allowed[msg.sender][spender] = tokens;
179         Approval(msg.sender, spender, tokens);
180         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
181         return true;
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Don't accept ETH
187     // ------------------------------------------------------------------------
188     function () public payable {
189         revert();
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Owner can transfer out any accidentally sent ERC20 tokens
195     // ------------------------------------------------------------------------
196     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
197         return ERC20Interface(tokenAddress).transfer(owner, tokens);
198     }
199 }