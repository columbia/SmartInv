1 pragma solidity ^0.4.18;
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
51     function Owned() public {
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
65         OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67         newOwner = address(0);
68     }
69 }
70 
71 
72 
73 contract SMILEHEART is ERC20Interface, Owned {
74     using SafeMath for uint;
75 
76     string public symbol;
77     string public  name;
78     uint8 public decimals;
79     uint public _totalSupply;
80 
81     mapping(address => uint) balances;
82     mapping(address => mapping(address => uint)) allowed;
83 
84 
85     function SMILEHEART() public {
86         symbol = "SMHT";
87         name = "SMILEHEART";
88         decimals = 8;
89         _totalSupply = 143000000 * 10**uint(decimals);
90         balances[owner] = _totalSupply;
91         Transfer(address(0), owner, _totalSupply);
92     }
93 
94 
95 
96     function totalSupply() public constant returns (uint) {
97         return _totalSupply  - balances[address(0)];
98     }
99 
100 
101 
102     function balanceOf(address tokenOwner) public constant returns (uint balance) {
103         return balances[tokenOwner];
104     }
105 
106 
107 
108     function transfer(address to, uint tokens) public returns (bool success) {
109         balances[msg.sender] = balances[msg.sender].sub(tokens);
110         balances[to] = balances[to].add(tokens);
111         Transfer(msg.sender, to, tokens);
112         return true;
113     }
114 
115 
116 
117     function approve(address spender, uint tokens) public returns (bool success) {
118         allowed[msg.sender][spender] = tokens;
119         Approval(msg.sender, spender, tokens);
120         return true;
121     }
122 
123 
124 
125     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
126         balances[from] = balances[from].sub(tokens);
127         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
128         balances[to] = balances[to].add(tokens);
129         Transfer(from, to, tokens);
130         return true;
131     }
132 
133 
134 
135     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
136         return allowed[tokenOwner][spender];
137     }
138 
139 
140     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
141         allowed[msg.sender][spender] = tokens;
142         Approval(msg.sender, spender, tokens);
143         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
144         return true;
145     }
146 
147 
148 
149     function () public payable {
150         revert();
151     }
152 
153 
154     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
155         return ERC20Interface(tokenAddress).transfer(owner, tokens);
156     }
157 }