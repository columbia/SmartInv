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
73 contract DGCASH is ERC20Interface, Owned {
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
85     function DGCASH() public {
86         symbol = "DGCASH";
87         name = "DGCASH";
88         decimals = 8;
89         _totalSupply = 333000000 * 10**uint(decimals);
90         balances[owner] = _totalSupply;
91         Transfer(address(0), owner, _totalSupply);
92     }
93 
94 
95     // ------------------------------------------------------------------------
96     // Total supply
97     // ------------------------------------------------------------------------
98     function totalSupply() public constant returns (uint) {
99         return _totalSupply  - balances[address(0)];
100     }
101 
102 
103 
104     function balanceOf(address tokenOwner) public constant returns (uint balance) {
105         return balances[tokenOwner];
106     }
107 
108 
109 
110     function transfer(address to, uint tokens) public returns (bool success) {
111         balances[msg.sender] = balances[msg.sender].sub(tokens);
112         balances[to] = balances[to].add(tokens);
113         Transfer(msg.sender, to, tokens);
114         return true;
115     }
116 
117 
118 
119     function approve(address spender, uint tokens) public returns (bool success) {
120         allowed[msg.sender][spender] = tokens;
121         Approval(msg.sender, spender, tokens);
122         return true;
123     }
124 
125 
126 
127     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
128         balances[from] = balances[from].sub(tokens);
129         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
130         balances[to] = balances[to].add(tokens);
131         Transfer(from, to, tokens);
132         return true;
133     }
134 
135 
136 
137     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
138         return allowed[tokenOwner][spender];
139     }
140 
141 
142     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
143         allowed[msg.sender][spender] = tokens;
144         Approval(msg.sender, spender, tokens);
145         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
146         return true;
147     }
148 
149 
150 
151     function () public payable {
152         revert();
153     }
154 
155 
156     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
157         return ERC20Interface(tokenAddress).transfer(owner, tokens);
158     }
159 }