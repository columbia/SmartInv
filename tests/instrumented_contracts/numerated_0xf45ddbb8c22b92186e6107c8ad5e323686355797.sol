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
37 
38 contract Owned {
39     address public owner;
40     address public newOwner;
41 
42     event OwnershipTransferred(address indexed _from, address indexed _to);
43 
44     function Owned() public {
45         owner = msg.sender;
46     }
47 
48     modifier onlyOwner {
49         require(msg.sender == owner);
50         _;
51     }
52 
53     function transferOwnership(address _newOwner) public onlyOwner {
54         newOwner = _newOwner;
55     }
56     function acceptOwnership() public {
57         require(msg.sender == newOwner);
58         OwnershipTransferred(owner, newOwner);
59         owner = newOwner;
60         newOwner = address(0);
61     }
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // ERC20 Token, with the addition of symbol, name and decimals and assisted
67 // token transfers
68 // ----------------------------------------------------------------------------
69 contract PieceofEightToken is ERC20Interface, Owned, SafeMath {
70     string public symbol;
71     string public  name;
72     uint8 public decimals;
73     uint public _totalSupply;
74 
75     mapping(address => uint) balances;
76     mapping(address => mapping(address => uint)) allowed;
77 
78 
79     // ------------------------------------------------------------------------
80     // Token parameters
81     // ------------------------------------------------------------------------
82     function PieceofEightToken() public {
83         symbol = "PO8";
84         name = "Piece of Eight Token";
85         decimals = 18;
86         _totalSupply = 888000000000000000000;
87         balances[0x0d6516F663C6332Fcabe28c07BD494a05719FC2B] = _totalSupply;
88         Transfer(address(0), 0x0d6516F663C6332Fcabe28c07BD494a05719FC2B, _totalSupply);
89     }
90 
91 
92     // ------------------------------------------------------------------------
93     // Total supply
94     // ------------------------------------------------------------------------
95     function totalSupply() public constant returns (uint) {
96         return _totalSupply  - balances[address(0)];
97     }
98 
99 
100     // ------------------------------------------------------------------------
101     // Get the token balance for account tokenOwner
102     // ------------------------------------------------------------------------
103     function balanceOf(address tokenOwner) public constant returns (uint balance) {
104         return balances[tokenOwner];
105     }
106 
107 
108     // ------------------------------------------------------------------------
109     // Transfer the balance from token owner's account to to account
110     // - Owner's account must have sufficient balance to transfer
111     // ------------------------------------------------------------------------
112     function transfer(address to, uint tokens) public returns (bool success) {
113         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
114         balances[to] = safeAdd(balances[to], tokens);
115         Transfer(msg.sender, to, tokens);
116         return true;
117     }
118 
119     function approve(address spender, uint tokens) public returns (bool success) {
120         allowed[msg.sender][spender] = tokens;
121         Approval(msg.sender, spender, tokens);
122         return true;
123     }
124 
125     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
126         balances[from] = safeSub(balances[from], tokens);
127         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
128         balances[to] = safeAdd(balances[to], tokens);
129         Transfer(from, to, tokens);
130         return true;
131     }
132 
133     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
134         return allowed[tokenOwner][spender];
135     }
136 
137     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
138         allowed[msg.sender][spender] = tokens;
139         Approval(msg.sender, spender, tokens);
140         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
141         return true;
142     }
143 
144     function () public payable {
145         revert();
146     }
147 
148     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
149         return ERC20Interface(tokenAddress).transfer(owner, tokens);
150     }
151 }