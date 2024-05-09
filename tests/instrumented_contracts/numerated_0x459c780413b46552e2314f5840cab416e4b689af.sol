1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // Made by Blocknix.com
5 // ----------------------------------------------------------------------------
6 
7 library SafeMath {
8     function add(uint a, uint b) internal pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function sub(uint a, uint b) internal pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function mul(uint a, uint b) internal pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function div(uint a, uint b) internal pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 contract ERC20Interface {
27     function totalSupply() public view returns (uint);
28     function balanceOf(address tokenOwner) public view returns (uint balance);
29     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
30     function transfer(address to, uint tokens) public returns (bool success);
31     function approve(address spender, uint tokens) public returns (bool success);
32     function transferFrom(address from, address to, uint tokens) public returns (bool success);
33 
34     event Transfer(address indexed from, address indexed to, uint tokens);
35     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36 }
37 
38 contract ApproveAndCallFallBack {
39     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
40 }
41 
42 contract Owned {
43     address public owner;
44     address public newOwner;
45 
46     event OwnershipTransferred(address indexed _from, address indexed _to);
47 
48     constructor() public {
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
62         emit OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64         newOwner = address(0);
65     }
66 }
67 
68 contract CalegariToken is ERC20Interface, Owned {
69     using SafeMath for uint;
70 
71     string public symbol;
72     string public  name;
73     uint8 public decimals;
74     uint _totalSupply;
75 
76     mapping(address => uint) balances;
77     mapping(address => mapping(address => uint)) allowed;
78 
79     constructor() public {
80         symbol = "CLG";
81         name = "Calegari Token";
82         decimals = 0;
83         _totalSupply = 150000000 * 10**uint(decimals);
84         balances[owner] = _totalSupply;
85         emit Transfer(address(0), owner, _totalSupply);
86     }
87 
88     function totalSupply() public view returns (uint) {
89         return _totalSupply.sub(balances[address(0)]);
90     }
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
103     function approve(address spender, uint tokens) public returns (bool success) {
104         allowed[msg.sender][spender] = tokens;
105         emit Approval(msg.sender, spender, tokens);
106         return true;
107     }
108 
109     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
110         balances[from] = balances[from].sub(tokens);
111         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
112         balances[to] = balances[to].add(tokens);
113         emit Transfer(from, to, tokens);
114         return true;
115     }
116 
117     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
118         return allowed[tokenOwner][spender];
119     }
120 
121     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
122         allowed[msg.sender][spender] = tokens;
123         emit Approval(msg.sender, spender, tokens);
124         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
125         return true;
126     }
127 
128     function () external payable {
129         revert();
130     }
131 
132     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
133         return ERC20Interface(tokenAddress).transfer(owner, tokens);
134     }
135 }