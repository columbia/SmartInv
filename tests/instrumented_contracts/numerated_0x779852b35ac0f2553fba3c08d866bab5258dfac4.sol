1 pragma solidity ^0.4.24;
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
23 
24 contract ERC20Interface {
25     function totalSupply() public constant returns (uint);
26     function balanceOf(address tokenOwner) public constant returns (uint balance);
27     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
28     function transfer(address to, uint tokens) public returns (bool success);
29     function approve(address spender, uint tokens) public returns (bool success);
30     function transferFrom(address from, address to, uint tokens) public returns (bool success);
31 
32     event Transfer(address indexed from, address indexed to, uint tokens);
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34 }
35 
36 
37 
38 contract ApproveAndCallFallBack {
39     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
40 }
41 
42 
43 contract Owned {
44     address public owner;
45     address public newOwner;
46 
47     event OwnershipTransferred(address indexed _from, address indexed _to);
48 
49     constructor() public {
50         owner = msg.sender;
51     }
52 
53     modifier onlyOwner {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     function transferOwnership(address _newOwner) public onlyOwner {
59         newOwner = _newOwner;
60     }
61     function acceptOwnership() public {
62         require(msg.sender == newOwner);
63         emit OwnershipTransferred(owner, newOwner);
64         owner = newOwner;
65         newOwner = address(0);
66     }
67 }
68 
69 
70 
71 contract BITD is ERC20Interface, Owned, SafeMath {
72     string public symbol;
73     string public  name;
74     uint8 public decimals;
75     uint public _totalSupply;
76 
77     mapping(address => uint) balances;
78     mapping(address => mapping(address => uint)) allowed;
79 
80 
81   
82     constructor() public {
83         symbol = "BITD";
84         name = "BITD";
85         decimals = 8;
86         _totalSupply = 21000000000000000;
87         balances[0xe4eD75a0A590848eE440a473bCBe4aE6a20D424A] = _totalSupply;
88         emit Transfer(address(0), 0xe4eD75a0A590848eE440a473bCBe4aE6a20D424A, _totalSupply);
89     }
90 
91 
92 
93     function totalSupply() public constant returns (uint) {
94         return _totalSupply  - balances[address(0)];
95     }
96 
97 
98     // ------------------------------------------------------------------------
99     // Get the token balance for account tokenOwner
100     // ------------------------------------------------------------------------
101     function balanceOf(address tokenOwner) public constant returns (uint balance) {
102         return balances[tokenOwner];
103     }
104 
105 
106     // ------------------------------------------------------------------------
107     // Transfer the balance from token owner's account to to account
108     // - Owner's account must have sufficient balance to transfer
109     // - 0 value transfers are allowed
110     // ------------------------------------------------------------------------
111     function transfer(address to, uint tokens) public returns (bool success) {
112         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
113         balances[to] = safeAdd(balances[to], tokens);
114         emit Transfer(msg.sender, to, tokens);
115         return true;
116     }
117 
118 
119     // ------------------------------------------------------------------------
120     // Token owner can approve for spender to transferFrom(...) tokens
121     // from the token owner's account
122     //
123     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
124     // recommends that there are no checks for the approval double-spend attack
125     // as this should be implemented in user interfaces 
126     // ------------------------------------------------------------------------
127     function approve(address spender, uint tokens) public returns (bool success) {
128         allowed[msg.sender][spender] = tokens;
129         emit Approval(msg.sender, spender, tokens);
130         return true;
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Transfer tokens from the from account to the to account
136     // 
137     // The calling account must already have sufficient tokens approve(...)-d
138     // for spending from the from account and
139     // - From account must have sufficient balance to transfer
140     // - Spender must have sufficient allowance to transfer
141     // - 0 value transfers are allowed
142     // ------------------------------------------------------------------------
143     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
144         balances[from] = safeSub(balances[from], tokens);
145         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
146         balances[to] = safeAdd(balances[to], tokens);
147         emit Transfer(from, to, tokens);
148         return true;
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Returns the amount of tokens approved by the owner that can be
154     // transferred to the spender's account
155     // ------------------------------------------------------------------------
156     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
157         return allowed[tokenOwner][spender];
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Token owner can approve for spender to transferFrom(...) tokens
163     // from the token owner's account. The spender contract function
164     // receiveApproval(...) is then executed
165     // ------------------------------------------------------------------------
166     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
167         allowed[msg.sender][spender] = tokens;
168         emit Approval(msg.sender, spender, tokens);
169         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
170         return true;
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Don't accept ETH
176     // ------------------------------------------------------------------------
177     function () public payable {
178         revert();
179     }
180 
181 
182     // ------------------------------------------------------------------------
183     // Owner can transfer out any accidentally sent ERC20 tokens
184     // ------------------------------------------------------------------------
185     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
186         return ERC20Interface(tokenAddress).transfer(owner, tokens);
187     }
188 }