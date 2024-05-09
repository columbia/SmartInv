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
21 
22 contract ERC20Interface {
23     function totalSupply() public constant returns (uint);
24     function balanceOf(address tokenOwner) public constant returns (uint balance);
25     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 contract ApproveAndCallFallBack {
35     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
36 }
37 contract Owned {
38     address public owner;
39     address public newOwner;
40 
41     event OwnershipTransferred(address indexed _from, address indexed _to);
42 
43     function Owned() public {
44         owner = msg.sender;
45     }
46 
47     modifier onlyOwner {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     function transferOwnership(address _newOwner) public onlyOwner {
53         newOwner = _newOwner;
54     }
55     function acceptOwnership() public {
56         require(msg.sender == newOwner);
57         OwnershipTransferred(owner, newOwner);
58         owner = newOwner;
59         newOwner = address(0);
60     }
61 }
62 
63 contract myfichain is ERC20Interface, Owned, SafeMath {
64     string public symbol;
65     string public  name;
66     uint8 public decimals;
67     uint public _totalSupply;
68 
69     mapping(address => uint) balances;
70     mapping(address => mapping(address => uint)) allowed;
71 
72 function myfichain() public {
73         symbol = "MYFI";
74         name = "MyFiChain";
75         decimals = 18;
76         _totalSupply = 10000000000000000000000000000;
77         balances[0xAbB082211930DA475879BF315AFaDDD55913C6a8] = _totalSupply;
78         Transfer(address(0), 0xAbB082211930DA475879BF315AFaDDD55913C6a8, _totalSupply);
79     }
80 
81 
82     // ------------------------------------------------------------------------
83     // Total supply
84     // ------------------------------------------------------------------------
85     function totalSupply() public constant returns (uint) {
86         return _totalSupply  - balances[address(0)];
87     }
88 
89 
90     // ------------------------------------------------------------------------
91     // Get the token balance for account tokenOwner
92     // ------------------------------------------------------------------------
93     function balanceOf(address tokenOwner) public constant returns (uint balance) {
94         return balances[tokenOwner];
95     }
96 
97 
98     // ------------------------------------------------------------------------
99     // Transfer the balance from token owner's account to to account
100     // - Owner's account must have sufficient balance to transfer
101     // - 0 value transfers are allowed
102     // ------------------------------------------------------------------------
103     function transfer(address to, uint tokens) public returns (bool success) {
104         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
105         balances[to] = safeAdd(balances[to], tokens);
106         Transfer(msg.sender, to, tokens);
107         return true;
108     }
109 
110 
111     // ------------------------------------------------------------------------
112     // Token owner can approve for spender to transferFrom(...) tokens
113     // from the token owner's account
114     //
115     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
116     // recommends that there are no checks for the approval double-spend attack
117     // as this should be implemented in user interfaces 
118     // ------------------------------------------------------------------------
119     function approve(address spender, uint tokens) public returns (bool success) {
120         allowed[msg.sender][spender] = tokens;
121         Approval(msg.sender, spender, tokens);
122         return true;
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Transfer tokens from the from account to the to account
128     // 
129     // The calling account must already have sufficient tokens approve(...)-d
130     // for spending from the from account and
131     // - From account must have sufficient balance to transfer
132     // - Spender must have sufficient allowance to transfer
133     // - 0 value transfers are allowed
134     // ------------------------------------------------------------------------
135     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
136         balances[from] = safeSub(balances[from], tokens);
137         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
138         balances[to] = safeAdd(balances[to], tokens);
139         Transfer(from, to, tokens);
140         return true;
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Returns the amount of tokens approved by the owner that can be
146     // transferred to the spender's account
147     // ------------------------------------------------------------------------
148     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
149         return allowed[tokenOwner][spender];
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Token owner can approve for spender to transferFrom(...) tokens
155     // from the token owner's account. The spender contract function
156     // receiveApproval(...) is then executed
157     // ------------------------------------------------------------------------
158     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
159         allowed[msg.sender][spender] = tokens;
160         Approval(msg.sender, spender, tokens);
161         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
162         return true;
163     }
164 
165 
166     // ------------------------------------------------------------------------
167     // Don't accept ETH
168     // ------------------------------------------------------------------------
169     function () public payable {
170         revert();
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Owner can transfer out any accidentally sent ERC20 tokens
176     // ------------------------------------------------------------------------
177     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
178         return ERC20Interface(tokenAddress).transfer(owner, tokens);
179     }
180 }