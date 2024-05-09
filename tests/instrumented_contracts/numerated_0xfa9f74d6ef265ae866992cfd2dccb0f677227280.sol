1 pragma solidity ^0.4.24;
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
43 
44 contract Owned {
45     address public owner;
46     address public newOwner;
47 
48     event OwnershipTransferred(address indexed _from, address indexed _to);
49 
50     constructor() public {
51         owner = msg.sender;
52     }
53 
54     modifier onlyOwner {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     function transferOwnership(address _newOwner) public onlyOwner {
60         newOwner = _newOwner;
61     }
62     function acceptOwnership() public {
63         require(msg.sender == newOwner);
64         emit OwnershipTransferred(owner, newOwner);
65         owner = newOwner;
66         newOwner = address(0);
67     }
68 }
69 
70 
71 contract DindicashToken is ERC20Interface, Owned, SafeMath {
72     string public symbol;
73     string public  name;
74     uint8 public decimals;
75     uint public _totalSupply;
76 
77     mapping(address => uint) balances;
78     mapping(address => mapping(address => uint)) allowed;
79 
80 
81     constructor() public {
82         symbol = "DDCH";
83         name = "DINDICASH";
84         decimals = 18;
85         _totalSupply = 777000000000 * 10**uint(decimals);
86         balances[0x214Ab828e020E909C95eb92E60555D6eb845a5d5] = _totalSupply;
87         emit Transfer(address(0), 0x214Ab828e020E909C95eb92E60555D6eb845a5d5, _totalSupply);
88     }
89 
90 
91 
92     function totalSupply() public constant returns (uint) {
93         return _totalSupply  - balances[address(0)];
94     }
95 
96 
97 
98     function balanceOf(address tokenOwner) public constant returns (uint balance) {
99         return balances[tokenOwner];
100     }
101 
102 
103     function transfer(address to, uint tokens) public returns (bool success) {
104         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
105         balances[to] = safeAdd(balances[to], tokens);
106         emit Transfer(msg.sender, to, tokens);
107         return true;
108     }
109 
110 
111     function approve(address spender, uint tokens) public returns (bool success) {
112         allowed[msg.sender][spender] = tokens;
113         emit Approval(msg.sender, spender, tokens);
114         return true;
115     }
116 
117 
118     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
119         balances[from] = safeSub(balances[from], tokens);
120         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
121         balances[to] = safeAdd(balances[to], tokens);
122         emit Transfer(from, to, tokens);
123         return true;
124     }
125 
126 
127     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
128         return allowed[tokenOwner][spender];
129     }
130 
131     // ------------------------------------------------------------------------
132     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
133         allowed[msg.sender][spender] = tokens;
134         emit Approval(msg.sender, spender, tokens);
135         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
136         return true;
137     }
138 
139 
140  
141     function () public payable {
142         revert();
143     }
144 
145 
146     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
147         return ERC20Interface(tokenAddress).transfer(owner, tokens);
148     }
149 }