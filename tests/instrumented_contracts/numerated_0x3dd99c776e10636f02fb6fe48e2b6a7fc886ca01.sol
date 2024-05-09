1 pragma solidity ^0.5.0;
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
25     function totalSupply() public view returns (uint);
26     function balanceOf(address tokenOwner) public view returns (uint balance);
27     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
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
39     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
40 }
41 
42 
43 contract Owned {
44     address public owner;
45     address public newOwner;
46 
47     event OwnershipTransferred(address indexed _from, address indexed _to);
48 
49     constructor() public {
50         owner = msg.sender;
51     }
52 
53     modifier onlyOwner {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     function transferOwnership(address _newOwner) public onlyOwner {
59         newOwner = _newOwner;
60     }
61     function acceptOwnership() public {
62         require(msg.sender == newOwner);
63         emit OwnershipTransferred(owner, newOwner);
64         owner = newOwner;
65         newOwner = address(0);
66     }
67 }
68 
69 
70 
71 contract FixedSupplyToken is ERC20Interface, Owned {
72     using SafeMath for uint;
73 
74     string public symbol;
75     string public  name;
76     uint8 public decimals;
77     uint _totalSupply;
78 
79     mapping(address => uint) balances;
80     mapping(address => mapping(address => uint)) allowed;
81 
82 
83     constructor() public {
84         symbol = "ZYC";
85         name = "Zhongying Coin";
86         decimals = 18;
87         _totalSupply = 1000000000 * 10**uint(decimals);
88         balances[owner] = _totalSupply;
89         emit Transfer(address(0), owner, _totalSupply);
90     }
91 
92 
93     function totalSupply() public view returns (uint) {
94         return _totalSupply.sub(balances[address(0)]);
95     }
96 
97 
98     function balanceOf(address tokenOwner) public view returns (uint balance) {
99         return balances[tokenOwner];
100     }
101 
102 
103     function transfer(address to, uint tokens) public returns (bool success) {
104         balances[msg.sender] = balances[msg.sender].sub(tokens);
105         balances[to] = balances[to].add(tokens);
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
119         balances[from] = balances[from].sub(tokens);
120         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
121         balances[to] = balances[to].add(tokens);
122         emit Transfer(from, to, tokens);
123         return true;
124     }
125 
126 
127     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
128         return allowed[tokenOwner][spender];
129     }
130 
131 
132     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
133         allowed[msg.sender][spender] = tokens;
134         emit Approval(msg.sender, spender, tokens);
135         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
136         return true;
137     }
138 
139 
140     function () external payable {
141         revert();
142     }
143 
144 
145     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
146         return ERC20Interface(tokenAddress).transfer(owner, tokens);
147     }
148 }