1 pragma solidity ^0.4.21;
2 
3 
4 library SafeMath {
5     function add(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function sub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function mul(uint a, uint b) internal pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function div(uint a, uint b) internal pure returns (uint c) {
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
69 contract VLOGS is ERC20Interface, Owned {
70     using SafeMath for uint;
71 
72     string public symbol;
73     string public  name;
74     uint8 public decimals;
75     uint public _totalSupply;
76 
77     mapping(address => uint) balances;
78     mapping(address => mapping(address => uint)) allowed;
79 
80 
81     function VLOGS() public {
82         symbol = "VLOGS";
83         name = "VLOGS";
84         decimals = 18;
85         _totalSupply = 320000000 * 10**uint(decimals);
86         balances[owner] = _totalSupply;
87         Transfer(address(0), owner, _totalSupply);
88     }
89 
90 
91     function totalSupply() public constant returns (uint) {
92         return _totalSupply  - balances[address(0)];
93     }
94 
95 
96     function balanceOf(address tokenOwner) public constant returns (uint balance) {
97         return balances[tokenOwner];
98     }
99 
100 
101     function transfer(address to, uint tokens) public returns (bool success) {
102         balances[msg.sender] = balances[msg.sender].sub(tokens);
103         balances[to] = balances[to].add(tokens);
104         Transfer(msg.sender, to, tokens);
105         return true;
106     }
107 
108 
109     function approve(address spender, uint tokens) public returns (bool success) {
110         allowed[msg.sender][spender] = tokens;
111         Approval(msg.sender, spender, tokens);
112         return true;
113     }
114 
115 
116     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
117         balances[from] = balances[from].sub(tokens);
118         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
119         balances[to] = balances[to].add(tokens);
120         Transfer(from, to, tokens);
121         return true;
122     }
123 
124 
125     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
126         return allowed[tokenOwner][spender];
127     }
128 
129 
130     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
131         allowed[msg.sender][spender] = tokens;
132         Approval(msg.sender, spender, tokens);
133         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
134         return true;
135     }
136 
137 
138     function () public payable {
139         revert();
140     }
141 
142 
143     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
144         return ERC20Interface(tokenAddress).transfer(owner, tokens);
145     }
146 }