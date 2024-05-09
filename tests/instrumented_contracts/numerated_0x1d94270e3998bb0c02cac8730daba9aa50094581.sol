1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     uint256 c = a / b;
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ERC20Interface {
33     function totalSupply() public constant returns (uint);
34     function balanceOf(address tokenOwner) public constant returns (uint balance);
35     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
36     function transfer(address to, uint tokens) public returns (bool success);
37     function approve(address spender, uint tokens) public returns (bool success);
38     function transferFrom(address from, address to, uint tokens) public returns (bool success);
39 
40     event Transfer(address indexed from, address indexed to, uint tokens);
41     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
42 }
43 
44 
45 contract ApproveAndCallFallBack {
46     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
47 }
48 
49 contract Owned {
50     address public owner;
51     address public newOwner;
52 
53     event OwnershipTransferred(address indexed _from, address indexed _to);
54 
55     function Owned() public {
56         owner = msg.sender;
57     }
58 
59     modifier onlyOwner {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     function transferOwnership(address _newOwner) public onlyOwner {
65         newOwner = _newOwner;
66     }
67     function acceptOwnership() public {
68         require(msg.sender == newOwner);
69         OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71         newOwner = address(0);
72     }
73 }
74 
75 contract INTLToken is ERC20Interface, Owned {
76     using SafeMath for uint256;
77     string public symbol;
78     string public  name;
79     uint8 public decimals;
80     uint public _totalSupply;
81 
82     mapping(address => uint) balances;
83     mapping(address => mapping(address => uint)) allowed;
84 
85 
86     function INTLToken() public {
87         symbol = "INTL";
88         name = "INTLToken";
89         decimals = 18;
90         _totalSupply = 55000000000000000000000000;
91         balances[msg.sender] = _totalSupply;
92         Transfer(address(0), msg.sender, _totalSupply);
93     }
94 
95 
96     function totalSupply() public constant returns (uint) {
97         return _totalSupply  - balances[address(0)];
98     }
99 
100     function balanceOf(address tokenOwner) public constant returns (uint balance) {
101         return balances[tokenOwner];
102     }
103 
104     function transfer(address to, uint tokens) public returns (bool success) {
105         balances[msg.sender] = balances[msg.sender].sub(tokens);
106         balances[to] = balances[to].add(tokens);
107         Transfer(msg.sender, to, tokens);
108         return true;
109     }
110 
111     function approve(address spender, uint tokens) public returns (bool success) {
112         allowed[msg.sender][spender] = tokens;
113         Approval(msg.sender, spender, tokens);
114         return true;
115     }
116 
117     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
118         balances[from] = balances[from].sub(tokens);
119         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
120         balances[to] = balances[to].add(tokens);
121         Transfer(from, to, tokens);
122         return true;
123     }
124 
125     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
126         return allowed[tokenOwner][spender];
127     }
128 
129     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
130         allowed[msg.sender][spender] = tokens;
131         Approval(msg.sender, spender, tokens);
132         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
133         return true;
134     }
135 
136     function () public payable {
137         revert();
138     }
139 
140     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
141         return ERC20Interface(tokenAddress).transfer(owner, tokens);
142     }
143 }