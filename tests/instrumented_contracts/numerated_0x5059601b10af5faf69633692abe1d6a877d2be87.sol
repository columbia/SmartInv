1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'Victus' token contract
5 //
6 // Symbol      : CYAT
7 // Name        : Cryptoyat 
8 // Total supply: 20000000000
9 // Decimals    : 18
10 //
11 // ----------------------------------------------------------------------------
12 // Safe maths
13 // ----------------------------------------------------------------------------
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
33 
34 contract ERC20Interface {
35     function totalSupply() public constant returns (uint);
36     function balanceOf(address tokenOwner) public constant returns (uint balance);
37     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
38     function transfer(address to, uint tokens) public returns (bool success);
39     function approve(address spender, uint tokens) public returns (bool success);
40     function transferFrom(address from, address to, uint tokens) public returns (bool success);
41 
42     event Transfer(address indexed from, address indexed to, uint tokens);
43     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
44 }
45 
46 
47 contract ApproveAndCallFallBack {
48     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
49 }
50 
51 
52 // ----------------------------------------------------------------------------
53 // Owned contract
54 // ----------------------------------------------------------------------------
55 contract Owned {
56     address public owner;
57     address public newOwner;
58 
59     event OwnershipTransferred(address indexed _from, address indexed _to);
60 
61     constructor() public {
62         owner = msg.sender;
63     }
64 
65     modifier onlyOwner {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     function transferOwnership(address _newOwner) public onlyOwner {
71         newOwner = _newOwner;
72     }
73     function acceptOwnership() public {
74         require(msg.sender == newOwner);
75         emit OwnershipTransferred(owner, newOwner);
76         owner = newOwner;
77         newOwner = address(0);
78     }
79 }
80 
81 
82 // ----------------------------------------------------------------------------
83 // ERC20 Token, with the addition of symbol, name and decimals and assisted
84 // token transfers
85 // ----------------------------------------------------------------------------
86 contract CryptoyatToken is ERC20Interface, Owned, SafeMath {
87     string public symbol;
88     string public  name;
89     uint8 public decimals;
90     uint public _totalSupply;
91 
92     mapping(address => uint) balances;
93     mapping(address => mapping(address => uint)) allowed;
94 
95 
96     // ------------------------------------------------------------------------
97     // Constructor
98     // ------------------------------------------------------------------------
99     constructor() public {
100         symbol = "CYAT";
101         name = "Cryptoyat";
102         decimals = 18;
103         _totalSupply = 20000000000000000000000000000;
104         balances[msg.sender] = _totalSupply;
105         emit Transfer(address(0), msg.sender, _totalSupply);
106     }
107 
108 
109     function totalSupply() public constant returns (uint) {
110         return _totalSupply  - balances[address(0)];
111     }
112 
113 
114     function balanceOf(address tokenOwner) public constant returns (uint balance) {
115         return balances[tokenOwner];
116     }
117 
118     function transfer(address to, uint tokens) public returns (bool success) {
119         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
120         balances[to] = safeAdd(balances[to], tokens);
121         emit Transfer(msg.sender, to, tokens);
122         return true;
123     }
124 
125 
126     function approve(address spender, uint tokens) public returns (bool success) {
127         allowed[msg.sender][spender] = tokens;
128         emit Approval(msg.sender, spender, tokens);
129         return true;
130     }
131 
132 
133     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
134         balances[from] = safeSub(balances[from], tokens);
135         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
136         balances[to] = safeAdd(balances[to], tokens);
137         emit Transfer(from, to, tokens);
138         return true;
139     }
140 
141 
142     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
143         return allowed[tokenOwner][spender];
144     }
145 
146 
147     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
148         allowed[msg.sender][spender] = tokens;
149         emit Approval(msg.sender, spender, tokens);
150         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
151         return true;
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Don't accept ETH
157     // ------------------------------------------------------------------------
158     function () public payable {
159         revert();
160     }
161 
162 
163     // ------------------------------------------------------------------------
164     // Owner can transfer out any accidentally sent ERC20 tokens
165     // ------------------------------------------------------------------------
166     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
167         return ERC20Interface(tokenAddress).transfer(owner, tokens);
168     }
169 }