1 pragma solidity ^0.4.18;
2 
3 // ***********************************************************
4 // Symbol       : CSQ
5 // Name         : Cryptosquirrel
6 // Total supply : 100,000,000
7 // Decimals     : 18
8 // Author:      : John Hussey
9 // ***********************************************************
10 
11 // -----------------------------------------------------------
12 // Safe maths: standard practise function
13 // -----------------------------------------------------------
14 contract SafeMath {
15     function safeAdd(uint a, uint b) public pure returns (uint c) {
16         c = a + b;
17         require(c >= a);
18     }
19     function safeSub(uint a, uint b) public pure returns (uint c) {
20         require(b <= a);
21         c = a - b;
22     }
23     function safeMul(uint a, uint b) public pure returns (uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b);
26     }
27     function safeDiv(uint a, uint b) public pure returns (uint c) {
28         require(b > 0);
29         c = a / b;
30     }
31 }
32 
33 // -----------------------------------------------------------
34 // ERC Token Standard #20 Interface
35 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
36 // -----------------------------------------------------------
37 contract ERC20Interface {
38     function totalSupply() public constant returns (uint);
39     function balanceOf(address tokenOwner) public constant returns (uint balance);
40     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
41     function transfer(address to, uint tokens) public returns (bool success);
42     function approve(address spender, uint tokens) public returns (bool success);
43     function transferFrom(address from, address to, uint tokens) public returns (bool success);
44 
45     event Transfer(address indexed from, address indexed to, uint tokens);
46     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
47 }
48 
49 
50 // ----------------------------------------------------------------------------
51 // Contract function to receive approval and execute function in one call
52 //
53 // Borrowed from MiniMeToken
54 // ----------------------------------------------------------------------------
55 contract ApproveAndCallFallBack {
56     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
57 }
58 
59 
60 // -----------------------------------------------------------
61 // Owned contract
62 // -----------------------------------------------------------
63 contract Owned {
64     address public owner;
65     address public newOwner;
66 
67     event OwnershipTransferred(address indexed _from, address indexed _to);
68 
69     function Owned() public {
70         owner = msg.sender;
71     }
72 
73     modifier onlyOwner {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     function transferOwnership(address _newOwner) public onlyOwner {
79         newOwner = _newOwner;
80     }
81     function acceptOwnership() public {
82         require(msg.sender == newOwner);
83         OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85         newOwner = address(0);
86     }
87 }
88 
89 
90 // ***********************************************************
91 // ERC20 Token: inherits ERC20Interface, Owned, SafeMath
92 // ***********************************************************
93 
94 contract Cryptosquirrel is ERC20Interface, Owned, SafeMath {
95     string public symbol;
96     string public  name;
97     uint8 public decimals;
98     uint public _totalSupply;
99 
100     mapping(address => uint) balances;
101     mapping(address => mapping(address => uint)) allowed;
102 
103 
104     // -----------------------------------------------------------
105     // Constructor
106     // -----------------------------------------------------------
107     function Cryptosquirrel() public {
108         symbol = "CSQ";
109         name = "Cryptosquirrel";
110         decimals = 18;
111         _totalSupply = 100000000000000000000000000; //100,000,000 tokens
112         balances[owner] = _totalSupply;
113         Transfer(address(0), owner, _totalSupply);
114     }
115 
116 
117     // -----------------------------------------------------------
118     // Total supply
119     // -----------------------------------------------------------
120     function totalSupply() public constant returns (uint) {
121         return _totalSupply  - balances[address(0)];
122     }
123 
124 
125     // -----------------------------------------------------------
126     // Get the token balance for account tokenOwner
127     // -----------------------------------------------------------
128     function balanceOf(address tokenOwner) public constant returns (uint balance) {
129         return balances[tokenOwner];
130     }
131 
132 
133     // -----------------------------------------------------------
134     // Transfer the balance from token owner's account to "to" account
135     // - Owner's account must have sufficient balance to transfer
136     // - 0 value transfers are allowed
137     // -----------------------------------------------------------
138     function transfer(address to, uint tokens) public returns (bool success) {
139         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
140         balances[to] = safeAdd(balances[to], tokens);
141         Transfer(msg.sender, to, tokens);
142         return true;
143     }
144 
145     // -----------------------------------------------------------
146     // Token owner can approve for spender to transferFrom(...) tokens
147     // from the token owner's account
148     //
149     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
150     // recommends that there are no checks for the approval double-spend attack
151     // as this should be implemented in user interfaces 
152     // -----------------------------------------------------------
153     function approve(address spender, uint tokens) public returns (bool success) {
154         allowed[msg.sender][spender] = tokens;
155         Approval(msg.sender, spender, tokens);
156         return true;
157     }
158 
159     // -----------------------------------------------------------
160     // Transfer tokens from the from account to the to account
161     // 
162     // The calling account must already have sufficient tokens approve(...)-d
163     // for spending from the from account and
164     // - From account must have sufficient balance to transfer
165     // - Spender must have sufficient allowance to transfer
166     // - 0 value transfers are allowed
167     // -----------------------------------------------------------
168     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
169         balances[from] = safeSub(balances[from], tokens);
170         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
171         balances[to] = safeAdd(balances[to], tokens);
172         Transfer(from, to, tokens);
173         return true;
174     }
175 
176     // -----------------------------------------------------------
177     // Returns the amount of tokens approved by the owner that can be
178     // transferred to the spender's account
179     // -----------------------------------------------------------
180     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
181         return allowed[tokenOwner][spender];
182     }
183 
184     // -----------------------------------------------------------
185     // Token owner can approve for spender to transferFrom(...) tokens
186     // from the token owner's account. The spender contract function
187     // receiveApproval(...) is then executed
188     // -----------------------------------------------------------
189     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
190         allowed[msg.sender][spender] = tokens;
191         Approval(msg.sender, spender, tokens);
192         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
193         return true;
194     }
195 
196     // -----------------------------------------------------------
197     // Don't accept ETH
198     // -----------------------------------------------------------
199     function () public payable {
200         revert();
201     }
202 
203     // -----------------------------------------------------------
204     // Owner can transfer out any accidentally sent ERC20 tokens
205     // -----------------------------------------------------------
206     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
207         return ERC20Interface(tokenAddress).transfer(owner, tokens);
208     }
209 }