1 pragma solidity ^0.4.24;
2 
3 
4 contract SafeMath {
5     function safeAdd(uint a, uint b) public pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function safeSub(uint a, uint b) public pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function safeMul(uint a, uint b) public pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function safeDiv(uint a, uint b) public pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 
24 // ----------------------------------------------------------------------------
25 // ERC Token Standard #20 Interface
26 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
27 // ----------------------------------------------------------------------------
28 contract ERC20Interface {
29     function totalSupply() public constant returns (uint);
30     function balanceOf(address tokenOwner) public constant returns (uint balance);
31     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
32     function transfer(address to, uint tokens) public returns (bool success);
33     function approve(address spender, uint tokens) public returns (bool success);
34     function transferFrom(address from, address to, uint tokens) public returns (bool success);
35 
36     event Transfer(address indexed from, address indexed to, uint tokens);
37     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // Contract function to receive approval and execute function in one call
43 //
44 // Borrowed from MiniMeToken
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
85 contract PayanyToken is ERC20Interface, Owned, SafeMath {
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
99         symbol = "DPA";
100         name = "Payany Token";
101         decimals = 18;
102         _totalSupply = 500000000000000000000000000;
103         balances[0xd4F7537189200566e02CF967aCBaAbCE7e0297B8] = _totalSupply;
104         emit Transfer(address(0), 0xd4F7537189200566e02CF967aCBaAbCE7e0297B8, _totalSupply);
105     }
106 
107 
108     // ------------------------------------------------------------------------
109     // Total supply
110     // ------------------------------------------------------------------------
111     function totalSupply() public constant returns (uint) {
112         return _totalSupply  - balances[address(0)];
113     }
114 
115 
116     // ------------------------------------------------------------------------
117     // Get the token balance for account tokenOwner
118     // ------------------------------------------------------------------------
119     function balanceOf(address tokenOwner) public constant returns (uint balance) {
120         return balances[tokenOwner];
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Transfer the balance from token owner's account to to account
126     // - Owner's account must have sufficient balance to transfer
127     // - 0 value transfers are allowed
128     // ------------------------------------------------------------------------
129     function transfer(address to, uint tokens) public returns (bool success) {
130         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
131         balances[to] = safeAdd(balances[to], tokens);
132         emit Transfer(msg.sender, to, tokens);
133         return true;
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Token owner can approve for spender to transferFrom(...) tokens
139     // from the token owner's account
140     //
141     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
142     // recommends that there are no checks for the approval double-spend attack
143     // as this should be implemented in user interfaces 
144     // ------------------------------------------------------------------------
145     function approve(address spender, uint tokens) public returns (bool success) {
146         allowed[msg.sender][spender] = tokens;
147         emit Approval(msg.sender, spender, tokens);
148         return true;
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Transfer tokens from the from account to the to account
154     // 
155     // The calling account must already have sufficient tokens approve(...)-d
156     // for spending from the from account and
157     // - From account must have sufficient balance to transfer
158     // - Spender must have sufficient allowance to transfer
159     // - 0 value transfers are allowed
160     // ------------------------------------------------------------------------
161     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
162         balances[from] = safeSub(balances[from], tokens);
163         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
164         balances[to] = safeAdd(balances[to], tokens);
165         emit Transfer(from, to, tokens);
166         return true;
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Returns the amount of tokens approved by the owner that can be
172     // transferred to the spender's account
173     // ------------------------------------------------------------------------
174     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
175         return allowed[tokenOwner][spender];
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Token owner can approve for spender to transferFrom(...) tokens
181     // from the token owner's account. The spender contract function
182     // receiveApproval(...) is then executed
183     // ------------------------------------------------------------------------
184     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
185         allowed[msg.sender][spender] = tokens;
186         emit Approval(msg.sender, spender, tokens);
187         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
188         return true;
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Don't accept ETH
194     // ------------------------------------------------------------------------
195     function () public payable {
196         revert();
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Owner can transfer out any accidentally sent ERC20 tokens
202     // ------------------------------------------------------------------------
203     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
204         return ERC20Interface(tokenAddress).transfer(owner, tokens);
205     }
206 }