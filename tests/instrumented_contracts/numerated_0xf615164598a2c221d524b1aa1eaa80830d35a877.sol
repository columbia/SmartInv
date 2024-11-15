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
45 //
46 // Borrowed from MiniMeToken
47 // ----------------------------------------------------------------------------
48 contract ApproveAndCallFallBack {
49     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // ----------------------------------------------------------------------------
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     constructor() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 
82 
83 // ----------------------------------------------------------------------------
84 // ERC20 Token, with the addition of symbol, name and decimals and assisted
85 // token transfers
86 // ----------------------------------------------------------------------------
87 contract MyToken is ERC20Interface, Owned, SafeMath {
88     string public symbol;
89     string public  name;
90     uint8 public decimals;
91     uint public _totalSupply;
92 
93     mapping(address => uint) balances;
94     mapping(address => mapping(address => uint)) allowed;
95 
96 
97     // ------------------------------------------------------------------------
98     // Constructor
99     // ------------------------------------------------------------------------
100     constructor(
101         string tokenName,
102         string tokenSymbol,
103         uint8  tokenDecimals,
104         uint256 initialSupply
105     ) public {
106         name = tokenName;
107         symbol = tokenSymbol;
108         decimals = tokenDecimals;
109         _totalSupply = initialSupply * 10 ** uint256(tokenDecimals); 
110         balances[msg.sender] = _totalSupply;
111         emit Transfer(address(0), msg.sender, _totalSupply);
112     }
113 
114 
115     // ------------------------------------------------------------------------
116     // Total supply
117     // ------------------------------------------------------------------------
118     function totalSupply() public constant returns (uint) {
119         return _totalSupply  - balances[address(0)];
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Get the token balance for account tokenOwner
125     // ------------------------------------------------------------------------
126     function balanceOf(address tokenOwner) public constant returns (uint balance) {
127         return balances[tokenOwner];
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Transfer the balance from token owner's account to to account
133     // - Owner's account must have sufficient balance to transfer
134     // - 0 value transfers are allowed
135     // ------------------------------------------------------------------------
136     function transfer(address to, uint tokens) public returns (bool success) {
137         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
138         balances[to] = safeAdd(balances[to], tokens);
139         emit Transfer(msg.sender, to, tokens);
140         return true;
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Token owner can approve for spender to transferFrom(...) tokens
146     // from the token owner's account
147     //
148     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
149     // recommends that there are no checks for the approval double-spend attack
150     // as this should be implemented in user interfaces 
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
210     //function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
211     //    return ERC20Interface(tokenAddress).transfer(owner, tokens);
212     //}
213 }