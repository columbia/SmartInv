1 pragma solidity ^0.5.0;
2 library SafeMath {
3     function add(uint a, uint b) internal pure returns (uint c) {
4         c = a + b;
5         require(c >= a);
6     }
7     function sub(uint a, uint b) internal pure returns (uint c) {
8         require(b <= a);
9         c = a - b;
10     }
11     function mul(uint a, uint b) internal pure returns (uint c) {
12         c = a * b;
13         require(a == 0 || c / a == b);
14     }
15     function div(uint a, uint b) internal pure returns (uint c) {
16         require(b > 0);
17         c = a / b;
18     }
19 }
20 
21 
22 contract ERC20Interface {
23     function totalSupply() public view returns (uint);
24     function balanceOf(address tokenOwner) public view returns (uint balance);
25     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 
35 
36 contract ApproveAndCallFallBack {
37     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
38 }
39 
40 
41 contract Owned {
42     address public owner;
43     address public newOwner;
44 
45     event OwnershipTransferred(address indexed _from, address indexed _to);
46 
47     constructor() public {
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
61         emit OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63         newOwner = address(0);
64     }
65 }
66 
67 
68 contract Ocbtoken is ERC20Interface, Owned {
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
79 
80     constructor() public {
81         symbol = "OCB";
82         name = "Ocbtoken - Blockmax";
83         decimals = 18;
84         _totalSupply = 60000000 * 10**uint(decimals);
85         balances[owner] = _totalSupply;
86         emit Transfer(address(0), owner, _totalSupply);
87     }
88 
89     function totalSupply() public view returns (uint) {
90         return _totalSupply.sub(balances[address(0)]);
91     }
92 
93     function balanceOf(address tokenOwner) public view returns (uint balance) {
94         return balances[tokenOwner];
95     }
96 
97 
98     function transfer(address to, uint tokens) public returns (bool success) {
99         balances[msg.sender] = balances[msg.sender].sub(tokens);
100         balances[to] = balances[to].add(tokens);
101         emit Transfer(msg.sender, to, tokens);
102         return true;
103     }
104 
105 
106     function approve(address spender, uint tokens) public returns (bool success) {
107         allowed[msg.sender][spender] = tokens;
108         emit Approval(msg.sender, spender, tokens);
109         return true;
110     }
111 
112 
113     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
114         balances[from] = balances[from].sub(tokens);
115         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
116         balances[to] = balances[to].add(tokens);
117         emit Transfer(from, to, tokens);
118         return true;
119     }
120 
121 
122     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
123         return allowed[tokenOwner][spender];
124     }
125 
126 
127 
128     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
129         allowed[msg.sender][spender] = tokens;
130         emit Approval(msg.sender, spender, tokens);
131         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
132         return true;
133     }
134 
135 
136 
137     function () external payable {
138         revert();
139     }
140 
141 
142 
143     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
144         return ERC20Interface(tokenAddress).transfer(owner, tokens);
145     }
146 }