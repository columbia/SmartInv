1 pragma solidity ^0.4.24;
2 
3 // HHH Token contract (ERC20)
4 // Symbol      : HHH
5 // Name        : HHHToken
6 // Total supply: 300,000,000.000000000000000000
7 // Decimals    : 18
8 //
9 // (c) HHH Lab 2018. The MIT Licence.
10 // ----------------------------------------------------------------------------
11 
12 library SafeMath {
13     function add(uint a, uint b) internal pure returns (uint c) {
14         c = a + b;
15         require(c >= a);
16     }
17     function sub(uint a, uint b) internal pure returns (uint c) {
18         require(b <= a);
19         c = a - b;
20     }
21     function mul(uint a, uint b) internal pure returns (uint c) {
22         c = a * b;
23         require(a == 0 || c / a == b);
24     }
25     function div(uint a, uint b) internal pure returns (uint c) {
26         require(b > 0);
27         c = a / b;
28     }
29 }
30 
31 contract ERC20Interface {
32     function totalSupply() public constant returns (uint);
33     function balanceOf(address tokenOwner) public constant returns (uint balance);
34     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
35     function transfer(address to, uint tokens) public returns (bool success);
36     function approve(address spender, uint tokens) public returns (bool success);
37     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38 
39     event Transfer(address indexed from, address indexed to, uint tokens);
40     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41 }
42 
43 contract ApproveAndCallFallBack {
44     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
45 }
46 
47 contract Owned {
48     address public owner;
49     address public newOwner;
50 
51     event OwnershipTransferred(address indexed _from, address indexed _to);
52 
53     constructor() public {
54         owner = msg.sender;
55     }
56 
57     modifier onlyOwner {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     function transferOwnership(address _newOwner) public onlyOwner {
63         newOwner = _newOwner;
64     }
65     function acceptOwnership() public {
66         require(msg.sender == newOwner);
67         emit OwnershipTransferred(owner, newOwner);
68         owner = newOwner;
69         newOwner = address(0);
70     }
71 }
72 
73 contract HHHToken is ERC20Interface, Owned {
74     using SafeMath for uint;
75 
76     string public symbol;
77     string public  name;
78     uint8 public decimals;
79     uint _totalSupply;
80 
81     mapping(address => uint) balances;
82     mapping(address => mapping(address => uint)) allowed;
83 
84     constructor() public {
85         symbol = "HHH";
86         name = "HHH Token";
87         decimals = 18;
88         _totalSupply = 300000000 * 10**uint(decimals);
89         balances[owner] = _totalSupply;
90         emit Transfer(address(0), owner, _totalSupply);
91     }
92 
93     function totalSupply() public view returns (uint) {
94         return _totalSupply.sub(balances[address(0)]);
95     }
96 
97     function balanceOf(address tokenOwner) public view returns (uint balance) {
98         return balances[tokenOwner];
99     }
100 
101 
102     function transfer(address to, uint tokens) public returns (bool success) {
103         balances[msg.sender] = balances[msg.sender].sub(tokens);
104         balances[to] = balances[to].add(tokens);
105         emit Transfer(msg.sender, to, tokens);
106         return true;
107     }
108 
109     function approve(address spender, uint tokens) public returns (bool success) {
110         allowed[msg.sender][spender] = tokens;
111         emit Approval(msg.sender, spender, tokens);
112         return true;
113     }
114 
115     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
116         balances[from] = balances[from].sub(tokens);
117         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
118         balances[to] = balances[to].add(tokens);
119         emit Transfer(from, to, tokens);
120         return true;
121     }
122 
123     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
124         return allowed[tokenOwner][spender];
125     }
126 
127     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
128         allowed[msg.sender][spender] = tokens;
129         emit Approval(msg.sender, spender, tokens);
130         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
131         return true;
132     }
133 
134     function () public payable {
135         revert();
136     }
137 
138     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
139         return ERC20Interface(tokenAddress).transfer(owner, tokens);
140     }
141 }