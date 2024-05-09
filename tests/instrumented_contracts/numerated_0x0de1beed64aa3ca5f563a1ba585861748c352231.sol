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
23 contract ERC20Interface {
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
65 
66 contract BioCoin is ERC20Interface, Owned, SafeMath {
67     string public symbol;
68     string public  name;
69     uint8 public decimals;
70     uint public _totalSupply;
71 
72     mapping(address => uint) balances;
73     mapping(address => mapping(address => uint)) allowed;
74 
75     function BioCoin() public {
76         symbol = "CoP";
77         name = "BioCoin";
78         decimals = 0;
79         _totalSupply = 10000000;
80         balances[0x66125E7980a3A79413485e61Cd8161Fa6C467227] = _totalSupply;
81         Transfer(address(0), 0x66125E7980a3A79413485e61Cd8161Fa6C467227, _totalSupply);
82     }
83 
84     function totalSupply() public constant returns (uint) {
85         return _totalSupply  - balances[address(0)];
86     }
87 
88 
89     function balanceOf(address tokenOwner) public constant returns (uint balance) {
90         return balances[tokenOwner];
91     }
92 
93     function transfer(address to, uint tokens) public returns (bool success) {
94         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
95         balances[to] = safeAdd(balances[to], tokens);
96         Transfer(msg.sender, to, tokens);
97         return true;
98     }
99 
100     function approve(address spender, uint tokens) public returns (bool success) {
101         allowed[msg.sender][spender] = tokens;
102         Approval(msg.sender, spender, tokens);
103         return true;
104     }
105 
106     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
107         balances[from] = safeSub(balances[from], tokens);
108         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
109         balances[to] = safeAdd(balances[to], tokens);
110         Transfer(from, to, tokens);
111         return true;
112     }
113 
114 
115     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
116         return allowed[tokenOwner][spender];
117     }
118 
119     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
120         allowed[msg.sender][spender] = tokens;
121         Approval(msg.sender, spender, tokens);
122         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
123         return true;
124     }
125 
126 
127     function () public payable {
128         revert();
129     }
130 
131     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
132         return ERC20Interface(tokenAddress).transfer(owner, tokens);
133     }
134 }