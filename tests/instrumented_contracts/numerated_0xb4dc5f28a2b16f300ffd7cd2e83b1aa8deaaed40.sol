1 pragma solidity ^0.4.23;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint a, uint b) internal pure returns (uint c) {
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
28     function balanceOf(address tokenOwner) public constant returns
29 (uint balance);
30     function allowance(address tokenOwner, address spender) public
31 constant returns (uint remaining);
32     function transfer(address to, uint tokens) public returns (bool success);
33     function approve(address spender, uint tokens) public returns
34 (bool success);
35     function transferFrom(address from, address to, uint tokens)
36 public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed
40 spender, uint tokens);
41 }
42 
43 
44 // ----------------------------------------------------------------------------
45 // Contract function to receive approval and execute function in one call
46 // ----------------------------------------------------------------------------
47 contract ApproveAndCallFallBack {
48     function receiveApproval(address from, uint256 tokens, address
49 token, bytes data) public;
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
87 contract FutureToken is ERC20Interface, Owned, SafeMath {
88     string public symbol;
89     string public  name;
90     uint8 public decimals;
91     uint256 public _totalSupply=3000000000;
92     uint256 public startDate;
93     uint256 public bonusEnds;
94     uint256 public endDate;
95     uint256 public rate=5000000;
96 
97 
98     mapping(address => uint) balances;
99     mapping(address => mapping(address => uint)) allowed;
100 
101 
102     // ------------------------------------------------------------------------
103     // Constructor
104     // ------------------------------------------------------------------------
105     constructor() public {
106         symbol = "FTT";
107         name = "FutureToken";
108         decimals = 18;
109         bonusEnds = now + 1 hours;
110         endDate = now + 7 weeks;
111         _totalSupply=_totalSupply*10**uint256(decimals); 
112         Owned(msg.sender);
113         balances[owner]=safeDiv(_totalSupply,3);
114         _totalSupply=safeSub(_totalSupply,balances[owner]);
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Total supply
120     // ------------------------------------------------------------------------
121     function totalSupply() public constant returns (uint) {
122         return _totalSupply;
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Get the token balance for account `tokenOwner`
128     // ------------------------------------------------------------------------
129     function balanceOf(address owner) public constant returns(uint256 balance) {
130         return balances[owner];
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Transfer the balance from token owner's account to `to` account
136     // - Owner's account must have sufficient balance to transfer
137     // - 0 value transfers are allowed
138     // ------------------------------------------------------------------------
139     function transfer(address to, uint tokens) public returns (bool success) {
140         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
141         balances[to] = safeAdd(balances[to], tokens);
142         emit Transfer(msg.sender, to, tokens);
143         return true;
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Token owner can approve for `spender` to transferFrom(...) `tokens`
149     // from the token owner's account
150     // ------------------------------------------------------------------------
151     function approve(address spender, uint tokens) public returns
152 (bool success) {
153         allowed[msg.sender][spender] = tokens;
154         emit Approval(msg.sender, spender, tokens);
155         return true;
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Transfer `tokens` from the `from` account to the `to` account
161     //
162     // The calling account must already have sufficient tokens approve(...)-d
163     // for spending from the `from` account and
164     // - From account must have sufficient balance to transfer
165     // - Spender must have sufficient allowance to transfer
166     // ------------------------------------------------------------------------
167     function transferFrom(address from, address to, uint tokens)public returns (bool success) {
168         balances[from] = safeSub(balances[from], tokens);
169         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
170         balances[to] = safeAdd(balances[to], tokens);
171         emit Transfer(from, to, tokens);
172         return true;
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Returns the amount of tokens approved by the owner that can be
178     // transferred to the spender's account
179     // ------------------------------------------------------------------------
180     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
181         return allowed[tokenOwner][spender];
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Token owner can approve for `spender` to transferFrom(...) `tokens`
187     // from the token owner's account. The `spender` contract function
188     // `receiveApproval(...)` is then executed
189     // ------------------------------------------------------------------------
190     function approveAndCall(address spender, uint tokens, bytes data)public returns (bool success) {
191         allowed[msg.sender][spender] = tokens;
192         emit Approval(msg.sender, spender, tokens);
193         ApproveAndCallFallBack(spender).receiveApproval(msg.sender,tokens, this, data);
194         return true;
195     }
196 
197     // ------------------------------------------------------------------------
198     // 25000 SHPC Tokens per 0.005 ETH
199     // ------------------------------------------------------------------------
200     function () public payable {
201         require(msg.value >= 0.005 ether);
202         uint256 tokens=safeMul(msg.value,rate); 
203         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
204         _totalSupply = safeSub(_totalSupply, tokens);
205         owner.transfer(msg.value);
206         emit Transfer(address(0), msg.sender, tokens);
207         //
208     }
209 
210 
211 
212     // ------------------------------------------------------------------------
213     // Owner can transfer out any accidentally sent ERC20 tokens
214     // ------------------------------------------------------------------------
215     function transferAnyERC20Token(address tokenAddress, uint tokens)public onlyOwner returns (bool success) {
216         return ERC20Interface(tokenAddress).transfer(owner, tokens);
217     }
218 }