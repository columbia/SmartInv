1 pragma solidity ^0.4.25;
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
26 contract ERC20Interface {
27     function totalSupply() public constant returns (uint);
28     function balanceOf(address tokenOwner) public constant returns (uint balance);
29     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
30     function transfer(address to, uint tokens) public returns (bool success);
31     function approve(address spender, uint tokens) public returns (bool success);
32     function transferFrom(address from, address to, uint tokens) public returns (bool success);
33 
34     event Transfer(address indexed from, address indexed to, uint tokens);
35     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36 }
37 
38 
39 // ----------------------------------------------------------------------------
40 // Contract function to receive approval and execute function in one call
41 //
42 // Borrowed from MiniMeToken
43 // ----------------------------------------------------------------------------
44 contract ApproveAndCallFallBack {
45     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
46 }
47 
48 
49 // ----------------------------------------------------------------------------
50 // Owned contract
51 // ----------------------------------------------------------------------------
52 contract Owned {
53     address public owner;
54     address public newOwner;
55 
56     event OwnershipTransferred(address indexed _from, address indexed _to);
57 
58     constructor() public {
59         owner = msg.sender;
60     }
61 
62     modifier onlyOwner {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     function transferOwnership(address _newOwner) public onlyOwner {
68         newOwner = _newOwner;
69     }
70     function acceptOwnership() public {
71         require(msg.sender == newOwner);
72         emit OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74         newOwner = address(0);
75     }
76 }
77 
78 
79 // ----------------------------------------------------------------------------
80 // ERC20 Token, with the addition of symbol, name and decimals and assisted
81 // token transfers
82 // ----------------------------------------------------------------------------
83 contract FEToken is ERC20Interface, Owned, SafeMath {
84     string public symbol;
85     string public  name;
86     uint8 public decimals;
87     uint public _totalSupply;
88 
89     mapping(address => uint) balances;
90     mapping(address => mapping(address => uint)) allowed;
91 
92 
93     // ------------------------------------------------------------------------
94     // Constructor
95     // ------------------------------------------------------------------------
96     constructor() public {
97         symbol = "FE";
98         name = "FE Token";
99         decimals = 18;
100         _totalSupply = 840000000 * (10 ** uint256(decimals));
101         balances[0xbcCf40Ec749908CAE5c23887aB0513b99EfC6a27] = _totalSupply;
102         emit Transfer(address(0), 0xbcCf40Ec749908CAE5c23887aB0513b99EfC6a27, _totalSupply);
103     }
104 
105 
106     // ------------------------------------------------------------------------
107     // Total supply
108     // ------------------------------------------------------------------------
109     function totalSupply() public constant returns (uint) {
110         return _totalSupply  - balances[address(0)];
111     }
112 
113 
114     // ------------------------------------------------------------------------
115     // Get the token balance for account tokenOwner
116     // ------------------------------------------------------------------------
117     function balanceOf(address tokenOwner) public constant returns (uint balance) {
118         return balances[tokenOwner];
119     }
120 
121     // ------------------------------------------------------------------------
122     function transfer(address to, uint tokens) public returns (bool success) {
123         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
124         balances[to] = safeAdd(balances[to], tokens);
125         emit Transfer(msg.sender, to, tokens);
126         return true;
127     }
128     
129     // ------------------------------------------------------------------------
130     function approve(address spender, uint tokens) public returns (bool success) {
131         allowed[msg.sender][spender] = tokens;
132         emit Approval(msg.sender, spender, tokens);
133         return true;
134     }
135     
136     // ------------------------------------------------------------------------
137     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
138         balances[from] = safeSub(balances[from], tokens);
139         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
140         balances[to] = safeAdd(balances[to], tokens);
141         emit Transfer(from, to, tokens);
142         return true;
143     }
144   
145     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
146         return allowed[tokenOwner][spender];
147     }
148 
149     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
150         allowed[msg.sender][spender] = tokens;
151         emit Approval(msg.sender, spender, tokens);
152         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
153         return true;
154     }
155 
156    function multiTransfer(address[] recipients, uint256[] amounts) public {
157         require(recipients.length == amounts.length);
158         for (uint i = 0; i < recipients.length; i++) {
159             transfer(recipients[i], amounts[i]);
160         }
161     }
162 
163     // ------------------------------------------------------------------------
164     // Owner can transfer out any accidentally sent ERC20 tokens
165     // ------------------------------------------------------------------------
166     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
167         return ERC20Interface(tokenAddress).transfer(owner, tokens);
168     }
169 }