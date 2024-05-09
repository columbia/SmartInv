1 pragma solidity ^0.4.24;
2 contract SafeMath {
3     function safeAdd(uint a, uint b) public pure returns (uint c) {
4         c = a + b;
5         require(c >= a);
6     }
7     function safeSub(uint a, uint b) public pure returns (uint c) {
8         require(b <= a);
9         c = a - b;
10     }
11     function safeMul(uint a, uint b) public pure returns (uint c) {
12         c = a * b;
13         require(a == 0 || c / a == b);
14     }
15     function safeDiv(uint a, uint b) public pure returns (uint c) {
16         require(b > 0);
17         c = a / b;
18     }
19 }
20 
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
34 
35 contract ApproveAndCallFallBack {
36     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
37 }
38 
39 
40 contract Owned {
41     address public owner;
42     address public newOwner;
43 
44     event OwnershipTransferred(address indexed _from, address indexed _to);
45 
46     constructor() public {
47         owner = msg.sender;
48     }
49 
50     modifier onlyOwner {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     function transferOwnership(address _newOwner) public onlyOwner {
56         newOwner = _newOwner;
57     }
58     function acceptOwnership() public {
59         require(msg.sender == newOwner);
60         emit OwnershipTransferred(owner, newOwner);
61         owner = newOwner;
62         newOwner = address(0);
63     }
64 }
65 
66 
67 contract MNF is ERC20Interface, Owned, SafeMath {
68     string public symbol;
69     string public  name;
70     uint8 public decimals;
71     uint public _totalSupply;
72 
73     mapping(address => uint) balances;
74     mapping(address => mapping(address => uint)) allowed;
75 
76 
77     constructor() public {
78         symbol = "MNF";
79         name = "MasterNode Fund";
80         decimals = 18;
81         _totalSupply = 11000000000000000000000000;
82         balances[0x1a9d93cde9244AC616e8Dcfd70c6eB9d66689d55] = _totalSupply;
83         emit Transfer(address(0), 0x1a9d93cde9244AC616e8Dcfd70c6eB9d66689d55, _totalSupply);
84     }
85 
86 
87     function totalSupply() public constant returns (uint) {
88         return _totalSupply  - balances[address(0)];
89     }
90 
91     function balanceOf(address tokenOwner) public constant returns (uint balance) {
92         return balances[tokenOwner];
93     }
94 
95 
96     function transfer(address to, uint tokens) public returns (bool success) {
97         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
98         balances[to] = safeAdd(balances[to], tokens);
99         emit Transfer(msg.sender, to, tokens);
100         return true;
101     }
102 
103 
104     function approve(address spender, uint tokens) public returns (bool success) {
105         allowed[msg.sender][spender] = tokens;
106         emit Approval(msg.sender, spender, tokens);
107         return true;
108     }
109 
110     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
111         balances[from] = safeSub(balances[from], tokens);
112         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
113         balances[to] = safeAdd(balances[to], tokens);
114         emit Transfer(from, to, tokens);
115         return true;
116     }
117 
118 
119     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
120         return allowed[tokenOwner][spender];
121     }
122 
123 
124     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
125         allowed[msg.sender][spender] = tokens;
126         emit Approval(msg.sender, spender, tokens);
127         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
128         return true;
129     }
130 
131 
132     function () public payable {
133         revert();
134     }
135 
136     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
137         return ERC20Interface(tokenAddress).transfer(owner, tokens);
138     }
139 }