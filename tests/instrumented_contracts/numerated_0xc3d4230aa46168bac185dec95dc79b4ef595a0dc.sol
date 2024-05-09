1 pragma solidity ^0.4.18;
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
35 
36 contract ApproveAndCallFallBack {
37     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
38 }
39 
40 
41 contract Owned {
42     address public owner;
43     address public newOwner;
44 
45     event OwnershipTransferred(address indexed _from, address indexed _to);
46 
47     function Owned() public {
48         owner = msg.sender;
49     }
50 
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     function transferOwnership(address _newOwner) public onlyOwner {
57         newOwner = _newOwner;
58     }
59     function acceptOwnership() public {
60         require(msg.sender == newOwner);
61         OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63         newOwner = address(0);
64     }
65 }
66 
67 
68 contract Tangent is ERC20Interface, Owned {
69     using SafeMath for uint;
70 
71     string public symbol;
72     string public  name;
73     uint8 public decimals;
74     uint public _totalSupply;
75 
76     mapping(address => uint) balances;
77     mapping(address => mapping(address => uint)) allowed;
78 
79     function Tangent() public {
80         symbol = "TAN";
81         name = "Tangent";
82         decimals = 18;
83         _totalSupply = 1000000 * 10**uint(decimals);
84         balances[owner] = _totalSupply;
85         Transfer(address(0), owner, _totalSupply);
86     }
87 
88     function totalSupply() public constant returns (uint) {
89         return _totalSupply  - balances[address(0)];
90     }
91 
92     function balanceOf(address tokenOwner) public constant returns (uint balance) {
93         return balances[tokenOwner];
94     }
95 
96     function transfer(address to, uint tokens) public returns (bool success) {
97         balances[msg.sender] = balances[msg.sender].sub(tokens);
98         balances[to] = balances[to].add(tokens);
99         Transfer(msg.sender, to, tokens);
100         return true;
101     }
102 
103     function approve(address spender, uint tokens) public returns (bool success) {
104         allowed[msg.sender][spender] = tokens;
105         Approval(msg.sender, spender, tokens);
106         return true;
107     }
108 
109     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
110         balances[from] = balances[from].sub(tokens);
111         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
112         balances[to] = balances[to].add(tokens);
113         Transfer(from, to, tokens);
114         return true;
115     }
116 
117     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
118         return allowed[tokenOwner][spender];
119     }
120 
121     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
122         allowed[msg.sender][spender] = tokens;
123         Approval(msg.sender, spender, tokens);
124         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
125         return true;
126     }
127 
128     function () public payable {
129         revert();
130     }
131 
132     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
133         return ERC20Interface(tokenAddress).transfer(owner, tokens);
134     }
135 }