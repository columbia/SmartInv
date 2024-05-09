1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Centhereum token contract
5 //
6 // Deployed to : 0x0c9F9dcd5DA56471eE3761D90b92759710297D23
7 // Symbol      : CTRM
8 // Name        : Centhereum
9 // Total supply: 180000000
10 // Decimals    : 18
11 //
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
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
36 
37 
38 // ----------------------------------------------------------------------------
39 // ERC20 Token Standard Interface
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint);
43     function balanceOf(address tokenOwner) public constant returns (uint balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Contract function to receive approval and execute function in one call
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
71     function Owned() public {
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
93 // Centhereum details
94 // ----------------------------------------------------------------------------
95 contract Centhereum is ERC20Interface, Owned, SafeMath {
96     string public symbol;
97     string public  name;
98     uint8 public decimals;
99     uint public _totalSupply;
100 
101     mapping(address => uint) balances;
102     mapping(address => mapping(address => uint)) allowed;
103 
104 
105     // ------------------------------------------------------------------------
106     // Constructor
107     // ------------------------------------------------------------------------
108     function Centhereum() public {
109         symbol = "CTRM";
110         name = "Centhereum";
111         decimals = 18;
112         _totalSupply = 180000000000000000000000000;
113         balances[0x0c9F9dcd5DA56471eE3761D90b92759710297D23] = _totalSupply;
114         emit Transfer(address(0), 0x0c9F9dcd5DA56471eE3761D90b92759710297D23, _totalSupply);
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Total supply
120     // ------------------------------------------------------------------------
121     function totalSupply() public constant returns (uint) {
122         return _totalSupply  - balances[address(0)];
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Get the token balance for account tokenOwner
128     // ------------------------------------------------------------------------
129     function balanceOf(address tokenOwner) public constant returns (uint balance) {
130         return balances[tokenOwner];
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Transfer the balance from token owner's account to to account
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
148     // Token owner can approve for spender to transferFrom(...) tokens
149     // from the token owner's account
150     // ------------------------------------------------------------------------
151     function approve(address spender, uint tokens) public returns (bool success) {
152         allowed[msg.sender][spender] = tokens;
153         emit Approval(msg.sender, spender, tokens);
154         return true;
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Transfer tokens from the from account to the to account
160     // 
161     // The calling account must already have sufficient tokens approve(...)-d
162     // for spending from the from account and
163     // - From account must have sufficient balance to transfer
164     // - Spender must have sufficient allowance to transfer
165     // - 0 value transfers are allowed
166     // ------------------------------------------------------------------------
167     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
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
186     // Token owner can approve for spender to transferFrom(...) tokens
187     // from the token owner's account. The spender contract function
188     // receiveApproval(...) is then executed
189     // ------------------------------------------------------------------------
190     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
191         allowed[msg.sender][spender] = tokens;
192         emit Approval(msg.sender, spender, tokens);
193         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
194         return true;
195     }
196 
197 
198     // ------------------------------------------------------------------------
199     // Don't accept ETH
200     // ------------------------------------------------------------------------
201     function () public payable {
202         revert();
203     }
204 
205 
206     // ------------------------------------------------------------------------
207     // Owner can transfer out any accidentally sent ERC20 tokens
208     // ------------------------------------------------------------------------
209     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
210         return ERC20Interface(tokenAddress).transfer(owner, tokens);
211     }
212   
213 }