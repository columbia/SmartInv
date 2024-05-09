1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
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
39 contract Owned {
40     address public owner;
41     address public newOwner;
42 
43     event OwnershipTransferred(address indexed _from, address indexed _to);
44 
45     constructor() public {
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
59         emit OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61         newOwner = address(0);
62     }
63 }
64 
65 contract HBCToken is ERC20Interface, Owned {
66     using SafeMath for uint;
67 
68     string public symbol;
69     string public  name;
70     uint8 public decimals;
71     uint _totalSupply;
72 
73     mapping(address => uint) balances;
74     mapping(address => mapping(address => uint)) allowed;
75 
76 
77     constructor() public {
78         symbol = "HBCT";
79         name = "Health BlockChain Token";
80         decimals = 8;
81         _totalSupply = 1000000000 * 10**uint(decimals);
82         balances[owner] = _totalSupply;
83         emit Transfer(address(0), owner, _totalSupply);
84     }
85 
86 
87     function totalSupply() public view returns (uint) {
88         return _totalSupply.sub(balances[address(0)]);
89     }
90 
91 
92     function balanceOf(address tokenOwner) public view returns (uint balance) {
93         return balances[tokenOwner];
94     }
95 
96     function transfer(address to, uint tokens) public returns (bool success) {
97         balances[msg.sender] = balances[msg.sender].sub(tokens);
98         balances[to] = balances[to].add(tokens);
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
110 
111     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
112         balances[from] = balances[from].sub(tokens);
113         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
114         balances[to] = balances[to].add(tokens);
115         emit Transfer(from, to, tokens);
116         return true;
117     }
118 
119 
120     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
121         return allowed[tokenOwner][spender];
122     }
123 
124 
125     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
126         allowed[msg.sender][spender] = tokens;
127         emit Approval(msg.sender, spender, tokens);
128         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
129         return true;
130     }
131 
132 
133     function () public payable {
134         revert();
135     }
136 
137 
138     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
139         return ERC20Interface(tokenAddress).transfer(owner, tokens);
140     }
141 
142 }