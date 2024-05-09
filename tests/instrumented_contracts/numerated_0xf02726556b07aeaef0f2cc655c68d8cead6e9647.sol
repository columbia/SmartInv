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
29     event Transfer(address indexed from, address indexed to, uint tokens);
30     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
31 }
32 
33 contract ApproveAndCallFallBack {
34     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
35 }
36 
37 contract Owned {
38     address public owner;
39     address public newOwner;
40 
41     event OwnershipTransferred(address indexed _from, address indexed _to);
42 
43     constructor() public {
44         owner = msg.sender;
45     }
46 
47     modifier onlyOwner {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     function transferOwnership(address _newOwner) public onlyOwner {
53         newOwner = _newOwner;
54     }
55     
56     function acceptOwnership() public {
57         require(msg.sender == newOwner);
58         emit OwnershipTransferred(owner, newOwner);
59         owner = newOwner;
60         newOwner = address(0);
61     }
62 }
63 
64 contract HedgeBankToken is ERC20Interface, Owned {
65     using SafeMath for uint;
66 
67     string public symbol;
68     string public  name;
69     uint8 public decimals;
70     uint _totalSupply;
71     bool public stopped;
72 
73     mapping(address => uint) balances;
74     mapping(address => mapping(address => uint)) allowed;
75 
76     constructor() public {
77         symbol = "HEB";
78         name = "HedgeBank Token";
79         decimals = 18;
80         _totalSupply = 1000000000 * 10**uint(decimals);
81         stopped = false;
82         balances[owner] = _totalSupply;
83         emit Transfer(address(0), owner, _totalSupply);
84     }
85     
86     modifier notStopped {
87         require(!stopped);
88         _;
89     }
90     
91     function stop() public onlyOwner {
92         stopped = true;
93     }
94     
95     function start() public onlyOwner {
96         stopped = false;
97     }
98 
99     function totalSupply() public view returns (uint) {
100         return _totalSupply.sub(balances[address(0)]);
101     }
102 
103     function balanceOf(address tokenOwner) public view returns (uint balance) {
104         return balances[tokenOwner];
105     }
106 
107     function transfer(address to, uint tokens) public notStopped returns (bool success) {
108         require(to != address(0));
109         balances[msg.sender] = balances[msg.sender].sub(tokens);
110         balances[to] = balances[to].add(tokens);
111         emit Transfer(msg.sender, to, tokens);
112         return true;
113     }
114 
115     function approve(address spender, uint tokens) public notStopped returns (bool success) {
116         allowed[msg.sender][spender] = tokens;
117         emit Approval(msg.sender, spender, tokens);
118         return true;
119     }
120 
121     function transferFrom(address from, address to, uint tokens) public notStopped returns (bool success) {
122         require(to != address(0));
123         balances[from] = balances[from].sub(tokens);
124         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
125         balances[to] = balances[to].add(tokens);
126         emit Transfer(from, to, tokens);
127         return true;
128     }
129 
130     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
131         return allowed[tokenOwner][spender];
132     }
133 
134     function approveAndCall(address spender, uint tokens, bytes data) public notStopped returns (bool success) {
135         allowed[msg.sender][spender] = tokens;
136         emit Approval(msg.sender, spender, tokens);
137         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
138         return true;
139     }
140 
141     function () public payable {
142         revert();
143     }
144 
145     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
146         return ERC20Interface(tokenAddress).transfer(owner, tokens);
147     }
148 }