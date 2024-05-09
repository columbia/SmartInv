1 pragma solidity ^0.4.19;
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
23 contract ERC20Basic {
24     function totalSupply() public constant returns (uint);
25     function balanceOf(address tokenOwner) public constant returns (uint balance);
26     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
27     function transfer(address to, uint tokens) public returns (bool success);
28     function approve(address spender, uint tokens) public returns (bool success);
29     function transferFrom(address from, address to, uint tokens) public returns (bool success);
30 
31     event Transfer(address indexed from, address indexed to, uint tokens);
32     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
33 }
34 
35 contract ApproveAndCallFallBack {
36     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
37 }
38 
39 contract Owned {
40     address public owner;
41     address public newOwner;
42 
43     event OwnershipTransferred(address indexed _from, address indexed _to);
44 
45     function Owned() public {
46         owner = msg.sender;
47     }
48 
49     modifier onlyOwner {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function transferOwnership(address _newOwner) public onlyOwner {
55         newOwner = _newOwner;
56     }
57     function acceptOwnership() public {
58         require(msg.sender == newOwner);
59         OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61         newOwner = address(0);
62     }
63 }
64 
65 contract Mystemcell is ERC20Basic, Owned, SafeMath {
66     string public symbol;
67     string public  name;
68     uint8 public decimals;
69     uint public _totalSupply;
70 
71     mapping(address => uint) balances;
72     mapping(address => mapping(address => uint)) allowed;
73 
74 
75     // ------------------------------------------------------------------------
76     // Constructor
77     // ------------------------------------------------------------------------
78     function Mystemcell() public {
79         symbol = "MySC";
80         name = "MyStemCell Token";
81         decimals = 18;
82         _totalSupply = 100000000000000000000000000;
83         balances[0x02679b7b0cF758dA1987091bAb809A6e2ecAC0cF] = _totalSupply;
84         Transfer(address(0), 0x02679b7b0cF758dA1987091bAb809A6e2ecAC0cF, _totalSupply);
85     }
86 
87 
88     // ------------------------------------------------------------------------
89     // Total supply
90     // ------------------------------------------------------------------------
91     function totalSupply() public constant returns (uint) {
92         return _totalSupply  - balances[address(0)];
93     }
94 
95 
96     // ------------------------------------------------------------------------
97     // Get the token balance for account tokenOwner
98     // ------------------------------------------------------------------------
99     function balanceOf(address tokenOwner) public constant returns (uint balance) {
100         return balances[tokenOwner];
101     }
102 
103 
104     // ------------------------------------------------------------------------
105     // Transfer the balance from token owner's account to to account
106     // - Owner's account must have sufficient balance to transfer
107     // - 0 value transfers are allowed
108     // ------------------------------------------------------------------------
109     function transfer(address to, uint tokens) public returns (bool success) {
110         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
111         balances[to] = safeAdd(balances[to], tokens);
112         Transfer(msg.sender, to, tokens);
113         return true;
114     }
115 
116 
117     // ------------------------------------------------------------------------
118     // Token owner can approve for spender to transferFrom(...) tokens
119     // from the token owner's account
120     //
121     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
122     // recommends that there are no checks for the approval double-spend attack
123     // as this should be implemented in user interfaces 
124     // ------------------------------------------------------------------------
125     function approve(address spender, uint tokens) public returns (bool success) {
126         allowed[msg.sender][spender] = tokens;
127         Approval(msg.sender, spender, tokens);
128         return true;
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Transfer tokens from the from account to the to account
134     // 
135     // The calling account must already have sufficient tokens approve(...)-d
136     // for spending from the from account and
137     // - From account must have sufficient balance to transfer
138     // - Spender must have sufficient allowance to transfer
139     // - 0 value transfers are allowed
140     // ------------------------------------------------------------------------
141     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
142         balances[from] = safeSub(balances[from], tokens);
143         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
144         balances[to] = safeAdd(balances[to], tokens);
145         Transfer(from, to, tokens);
146         return true;
147     }
148 
149 
150     // ------------------------------------------------------------------------
151     // Returns the amount of tokens approved by the owner that can be
152     // transferred to the spender's account
153     // ------------------------------------------------------------------------
154     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
155         return allowed[tokenOwner][spender];
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Token owner can approve for spender to transferFrom(...) tokens
161     // from the token owner's account. The spender contract function
162     // receiveApproval(...) is then executed
163     // ------------------------------------------------------------------------
164     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
165         allowed[msg.sender][spender] = tokens;
166         Approval(msg.sender, spender, tokens);
167         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
168         return true;
169     }
170 
171 
172     // ------------------------------------------------------------------------
173     // Don't accept ETH
174     // ------------------------------------------------------------------------
175     function () public payable {
176         revert();
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Owner can transfer out any accidentally sent ERC20 tokens
182     // ------------------------------------------------------------------------
183     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
184         return ERC20Basic(tokenAddress).transfer(owner, tokens);
185     }
186 }