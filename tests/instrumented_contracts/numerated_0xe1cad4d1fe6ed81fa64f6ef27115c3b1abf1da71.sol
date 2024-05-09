1 pragma solidity ^0.4.18;
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
37 contract ApproveAndCallFallBack {
38     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
39 }
40 
41 
42 contract Owned {
43     address public owner;
44     address public newOwner;
45 
46     event OwnershipTransferred(address indexed _from, address indexed _to);
47 
48     function Owned() public {
49         owner = msg.sender;
50     }
51 
52     modifier onlyOwner {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     function transferOwnership(address _newOwner) public onlyOwner {
58         newOwner = _newOwner;
59     }
60     function acceptOwnership() public {
61         require(msg.sender == newOwner);
62         OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64         newOwner = address(0);
65     }
66 }
67 
68 
69 contract TotiMed is ERC20Interface, Owned, SafeMath {
70     string public symbol;
71     string public  name;
72     uint8 public decimals;
73     uint public _totalSupply;
74 
75     mapping(address => uint) balances;
76     mapping(address => mapping(address => uint)) allowed;
77 
78 
79     function TotiMed() public {
80         symbol = "TTMD";
81         name = "TotiMed";
82         decimals = 18;
83         _totalSupply = 2000000000000000000000000000;
84         balances[0x176cc10Ec6c216Bfa6aC4f6A173203E34011DcA8] = _totalSupply;
85         Transfer(address(0), 0x176cc10Ec6c216Bfa6aC4f6A173203E34011DcA8, _totalSupply);
86     }
87 
88 
89     function totalSupply() public constant returns (uint) {
90         return _totalSupply  - balances[address(0)];
91     }
92 
93 
94     function balanceOf(address tokenOwner) public constant returns (uint balance) {
95         return balances[tokenOwner];
96     }
97 
98 
99     function transfer(address to, uint tokens) public returns (bool success) {
100         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
101         balances[to] = safeAdd(balances[to], tokens);
102         Transfer(msg.sender, to, tokens);
103         return true;
104     }
105 
106 
107     function approve(address spender, uint tokens) public returns (bool success) {
108         allowed[msg.sender][spender] = tokens;
109         Approval(msg.sender, spender, tokens);
110         return true;
111     }
112 
113 
114     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
115         balances[from] = safeSub(balances[from], tokens);
116         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
117         balances[to] = safeAdd(balances[to], tokens);
118         Transfer(from, to, tokens);
119         return true;
120     }
121 
122 
123     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
124         return allowed[tokenOwner][spender];
125     }
126 
127 
128     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
129         allowed[msg.sender][spender] = tokens;
130         Approval(msg.sender, spender, tokens);
131         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
132         return true;
133     }
134 
135 
136     function () public payable {
137         revert();
138     }
139 
140 
141     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
142         return ERC20Interface(tokenAddress).transfer(owner, tokens);
143     }
144 }