1 pragma solidity ^0.4.20;
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
24     function totalSupply() public view returns (uint);
25     function balanceOf(address tokenOwner) public view returns (uint balance);
26     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
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
41 
42 contract Owned {
43     address public owner;
44     address public newOwner;
45 
46     event OwnershipTransferred(address indexed _from, address indexed _to);
47 
48     constructor() public {
49         owner = 0xda5525d212878d73bA9Fb8b9abcD6Cc88103B3be;
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
68 
69 contract Token is ERC20Interface, Owned {
70     using SafeMath for uint;
71 
72     string public name = "Blood To The Majority";   
73     string public symbol = "BTTM";   
74     uint8 public decimals = 18;    
75     uint public _totalSupply;   
76 
77 
78     mapping(address => uint) balances;  
79     mapping(address => mapping(address => uint)) allowed;   
80 
81 
82     constructor() public {   
83         name = "Blood To The Majority";
84         symbol = "BTTM";
85         decimals = 18;
86         _totalSupply = 21000000 * 10**uint(decimals);
87         balances[owner] = _totalSupply;
88         emit Transfer(address(0), owner, _totalSupply);
89     }
90 
91     function totalSupply() public view returns (uint) { 
92         return _totalSupply - balances[address(0)];
93     }
94 
95     // Extra function
96     function totalSupplyWithZeroAddress() public view returns (uint) { 
97         return _totalSupply;
98     }
99 
100 
101     function balanceOf(address tokenOwner) public view returns (uint balance) { 
102         return balances[tokenOwner];
103     }
104 
105     // Extra function
106     function myBalance() public view returns (uint balance) {
107         return balances[msg.sender];
108     }
109 
110 
111     function transfer(address to, uint tokens) public returns (bool success) {  
112         balances[msg.sender] = balances[msg.sender].sub(tokens);
113         balances[to] = balances[to].add(tokens);
114         emit Transfer(msg.sender, to, tokens);
115         return true;
116     }
117 
118     function approve(address spender, uint tokens) public returns (bool success) {  
119         allowed[msg.sender][spender] = tokens;
120         emit Approval(msg.sender, spender, tokens);
121         return true;
122     }
123 
124     function transferFrom(address from, address to, uint tokens) public returns (bool success) {    
125         balances[from] = balances[from].sub(tokens);
126         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
127         balances[to] = balances[to].add(tokens);
128         emit Transfer(from, to, tokens);
129         return true;
130     }
131 
132     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {  
133         return allowed[tokenOwner][spender];
134     }
135 
136     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
137         allowed[msg.sender][spender] = tokens;
138         emit Approval(msg.sender, spender, tokens);
139         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
140         return true;
141     }
142 
143     function () public payable {  
144         revert();
145     }
146 
147     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) { 
148         return ERC20Interface(tokenAddress).transfer(owner, tokens);        
149     }
150 }
151 
152 contract Admin is Token {
153     // change symbol and name
154     function reconfig(string newName, string newSymbol) external onlyOwner {
155         symbol = newSymbol;
156         name = newName;
157     }
158 
159     // increase supply and send newly added tokens to owner
160     function increaseSupply(uint256 increase) external onlyOwner {
161         _totalSupply = _totalSupply.add(increase);
162         balances[owner] = balances[owner].add(increase);
163         emit Transfer(address(0), owner, increase);
164     }
165     
166     // deactivate the contract
167     function deactivate() external onlyOwner {
168         selfdestruct(owner);
169     }
170 }