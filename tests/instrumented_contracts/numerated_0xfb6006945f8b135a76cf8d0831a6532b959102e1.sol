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
21 contract ERC20Interface {
22     function totalSupply() public constant returns (uint);
23     function balanceOf(address tokenOwner) public constant returns (uint balance);
24     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
25     function transfer(address to, uint tokens) public returns (bool success);
26     function approve(address spender, uint tokens) public returns (bool success);
27     function transferFrom(address from, address to, uint tokens) public returns (bool success);
28 
29     event Transfer(address indexed from, address indexed to, uint tokens);
30     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
31 }
32 
33 
34 // ----------------------------------------------------------------------------
35 // Contract function to receive approval and execute function in one call
36 //
37 // Borrowed from MiniMeToken
38 // ----------------------------------------------------------------------------
39 contract ApproveAndCallFallBack {
40     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
41 }
42 
43 
44 // ----------------------------------------------------------------------------
45 // Owned contract
46 // ----------------------------------------------------------------------------
47 contract Owned {
48     address public owner;
49     address public newOwner;
50 
51     event OwnershipTransferred(address indexed _from, address indexed _to);
52 
53     function Owned() public {
54         owner = msg.sender;
55     }
56 
57     modifier onlyOwner {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     function transferOwnership(address _newOwner) public onlyOwner {
63         newOwner = _newOwner;
64     }
65     function acceptOwnership() public {
66         require(msg.sender == newOwner);
67         OwnershipTransferred(owner, newOwner);
68         owner = newOwner;
69         newOwner = address(0);
70     }
71 }
72 
73 
74 // ----------------------------------------------------------------------------
75 // ERC20 Token, with the addition of symbol, name and decimals and assisted
76 // token transfers
77 // ----------------------------------------------------------------------------
78 contract VIETNAMTOKENTEST is ERC20Interface, Owned, SafeMath {
79     string public symbol;
80     string public  name;
81     uint8 public decimals;
82     uint public _totalSupply;
83 
84     mapping(address => uint) balances;
85     mapping(address => mapping(address => uint)) allowed;
86 
87 
88     // ------------------------------------------------------------------------
89     // Constructor
90     // ------------------------------------------------------------------------
91     function VIETNAMTOKENTEST() public {
92         symbol = "VNHN";
93         name = "VIETNAMTOKENTEST";
94         decimals = 18;
95         _totalSupply = 100000000000000000000000000;
96         balances[0x3C43885bF78E0F5CaDf4840B03bdd867a8069754] = _totalSupply;
97         Transfer(address(0), 0x3C43885bF78E0F5CaDf4840B03bdd867a8069754, _totalSupply);
98     }
99 
100 
101     // ------------------------------------------------------------------------
102     // Total supply
103     // ------------------------------------------------------------------------
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
186     // Don't accept ETHs
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