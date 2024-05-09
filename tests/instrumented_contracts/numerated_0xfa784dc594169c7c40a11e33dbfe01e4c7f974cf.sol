1 pragma solidity ^0.4.24;
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
24 
25 contract ERC20Interface {
26     function totalSupply() public constant returns (uint);
27     function balanceOf(address tokenOwner) public constant returns (uint balance);
28     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
29     function transfer(address to, uint tokens) public returns (bool success);
30     function approve(address spender, uint tokens) public returns (bool success);
31     function transferFrom(address from, address to, uint tokens) public returns (bool success);
32 
33     event Transfer(address indexed from, address indexed to, uint tokens);
34     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
35 }
36 
37 
38 
39 contract ApproveAndCallFallBack {
40     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
41 }
42 
43 
44 
45 contract Owned {
46     address public owner;
47     address public newOwner;
48 
49     event OwnershipTransferred(address indexed _from, address indexed _to);
50 
51     constructor() public {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function transferOwnership(address _newOwner) public onlyOwner {
61         newOwner = _newOwner;
62     }
63     function acceptOwnership() public {
64         require(msg.sender == newOwner);
65         emit OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67         newOwner = address(0);
68     }
69 }
70 
71 
72 
73 contract LJWToken is ERC20Interface, Owned {
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
84 
85     // ------------------------------------------------------------------------
86     // Constructor
87     // ------------------------------------------------------------------------
88     constructor() public {
89         symbol = "LJW";
90         name = "LJW Token";
91         decimals = 18;
92         _totalSupply = 1000000000 * 10**uint(decimals);
93         balances[owner] = _totalSupply;
94         emit Transfer(address(0), owner, _totalSupply);
95     }
96 
97 
98    
99     function totalSupply() public view returns (uint) {
100         return _totalSupply.sub(balances[address(0)]);
101     }
102 
103 
104    
105     function balanceOf(address tokenOwner) public view returns (uint balance) {
106         return balances[tokenOwner];
107     }
108 
109 
110    
111     function transfer(address to, uint tokens) public returns (bool success) {
112         balances[msg.sender] = balances[msg.sender].sub(tokens);
113         balances[to] = balances[to].add(tokens);
114         emit Transfer(msg.sender, to, tokens);
115         return true;
116     }
117 
118 
119    
120     function approve(address spender, uint tokens) public returns (bool success) {
121         allowed[msg.sender][spender] = tokens;
122         emit Approval(msg.sender, spender, tokens);
123         return true;
124     }
125 
126 
127    
128     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
129         balances[from] = balances[from].sub(tokens);
130         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
131         balances[to] = balances[to].add(tokens);
132         emit Transfer(from, to, tokens);
133         return true;
134     }
135 
136 
137    
138     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
139         return allowed[tokenOwner][spender];
140     }
141 
142 
143    
144     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
145         allowed[msg.sender][spender] = tokens;
146         emit Approval(msg.sender, spender, tokens);
147         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
148         return true;
149     }
150 
151 
152     
153     function () public payable {
154         revert();
155     }
156 
157 
158    
159     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
160         return ERC20Interface(tokenAddress).transfer(owner, tokens);
161     }
162 }