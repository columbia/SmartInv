1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // Deployed to : 0xE1037050846E68E54D23Ff72efEF716e4A958Afa
6 // Symbol      : TBT
7 // Name        : The Best Token
8 // Total supply: 89000000000000000000000000
9 // Decimals    : 18
10 //
11 
12 // ----------------------------------------------------------------------------
13 // Safe maths
14 // ----------------------------------------------------------------------------
15 contract SafeMath {
16     function safeAdd(uint a, uint b) public pure returns (uint c) {
17         c = a + b;
18         require(c >= a);
19     }
20     function safeSub(uint a, uint b) public pure returns (uint c) {
21         require(b <= a);
22         c = a - b;
23     }
24     function safeMul(uint a, uint b) public pure returns (uint c) {
25         c = a * b;
26         require(a == 0 || c / a == b);
27     }
28     function safeDiv(uint a, uint b) public pure returns (uint c) {
29         require(b > 0);
30         c = a / b;
31     }
32 }
33 
34 
35 // ----------------------------------------------------------------------------
36 // ERC Token Standard #20 Interface
37 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
38 // ----------------------------------------------------------------------------
39 contract ERC20Interface {
40     function totalSupply() public constant returns (uint);
41     function balanceOf(address tokenOwner) public constant returns (uint balance);
42     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
43     function transfer(address to, uint tokens) public returns (bool success);
44     function approve(address spender, uint tokens) public returns (bool success);
45     function transferFrom(address from, address to, uint tokens) public returns (bool success);
46 
47     event Transfer(address indexed from, address indexed to, uint tokens);
48     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
49 }
50 
51 
52 // ----------------------------------------------------------------------------
53 // Contract function to receive approval and execute function in one call
54 //
55 // Borrowed from MiniMeToken
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
96 contract TheBestToken is ERC20Interface, Owned, SafeMath {
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
110         symbol = "TBT";
111         name = "The Best Token";
112         decimals = 18;
113         _totalSupply = 89000000000000000000000000;
114         balances[0xE1037050846E68E54D23Ff72efEF716e4A958Afa] = _totalSupply;
115         emit Transfer(address(0), 0xE1037050846E68E54D23Ff72efEF716e4A958Afa, _totalSupply);
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
151     //
152     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
153     // recommends that there are no checks for the approval double-spend attack
154     // as this should be implemented in user interfaces 
155     // ------------------------------------------------------------------------
156     function approve(address spender, uint tokens) public returns (bool success) {
157         allowed[msg.sender][spender] = tokens;
158         emit Approval(msg.sender, spender, tokens);
159         return true;
160     }
161 
162 
163     // ------------------------------------------------------------------------
164     // Transfer tokens from the from account to the to account
165     // 
166     // The calling account must already have sufficient tokens approve(...)-d
167     // for spending from the from account and
168     // - From account must have sufficient balance to transfer
169     // - Spender must have sufficient allowance to transfer
170     // - 0 value transfers are allowed
171     // ------------------------------------------------------------------------
172     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
173         balances[from] = safeSub(balances[from], tokens);
174         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
175         balances[to] = safeAdd(balances[to], tokens);
176         emit Transfer(from, to, tokens);
177         return true;
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Returns the amount of tokens approved by the owner that can be
183     // transferred to the spender's account
184     // ------------------------------------------------------------------------
185     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
186         return allowed[tokenOwner][spender];
187     }
188 
189 
190     // ------------------------------------------------------------------------
191     // Token owner can approve for spender to transferFrom(...) tokens
192     // from the token owner's account. The spender contract function
193     // receiveApproval(...) is then executed
194     // ------------------------------------------------------------------------
195     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
196         allowed[msg.sender][spender] = tokens;
197         emit Approval(msg.sender, spender, tokens);
198         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
199         return true;
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Don't accept ETH
205     // ------------------------------------------------------------------------
206     function () public payable {
207         revert();
208     }
209 
210 
211     // ------------------------------------------------------------------------
212     // Owner can transfer out any accidentally sent ERC20 tokens
213     // ------------------------------------------------------------------------
214     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
215         return ERC20Interface(tokenAddress).transfer(owner, tokens);
216     }
217 }