1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5       c = a + b;
6       require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9       require(b <= a);
10       c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13       c = a * b;
14       require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17       require(b > 0);
18       c = a / b;
19     }
20 }
21 
22 // ----------------------------------------------------------------------------
23 // ERC Token Standard #20 Interface
24 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
25 // ----------------------------------------------------------------------------
26 contract ERC20Interface {
27     function totalSupply() public constant returns (uint);
28     function balanceOf(address tokenOwner) public constant returns (uint balance);
29     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
30     function transfer(address to, uint tokens) public returns (bool success);
31     function approve(address spender, uint tokens) public returns (bool success);
32     function transferFrom(address from, address to, uint tokens) public returns (bool success);
33 
34     event Transfer(address indexed from, address indexed to, uint tokens);
35     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36 }
37 
38 // ----------------------------------------------------------------------------
39 // Contract function to receive approval and execute function in one call,
40 // borrowed from MiniMeToken
41 // ----------------------------------------------------------------------------
42 contract ApproveAndCallFallBack {
43     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
44 }
45 
46 // ----------------------------------------------------------------------------
47 // Owned contract
48 // ----------------------------------------------------------------------------
49 contract Owned {
50     address public owner;
51     address public newOwner;
52 
53     event OwnershipTransferred(address indexed _from, address indexed _to);
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function Owned() public {
61         owner = msg.sender;
62     }
63     function transferOwnership(address _newOwner) public onlyOwner {
64         newOwner = _newOwner;
65     }
66     function acceptOwnership() public {
67         require(msg.sender == newOwner);
68         emit OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70         newOwner = address(0);
71     }
72 }
73 
74 contract TPortToken is ERC20Interface, Owned {
75     using SafeMath for uint;
76 
77     string public name = "Today Portfoliotest Token";
78     string public symbol = "TPT";
79     uint8 public decimals = 18;
80     uint256 public _totalSupply = 88000000 * 10**18;
81     bool public locked = false;
82 
83     mapping(address => uint) balances;
84     mapping(address => mapping(address => uint)) allowed;
85 
86     event Locked();
87 
88     function TPortToken() public {
89         
90         balances[owner] = _totalSupply;
91         emit Transfer(address(0), owner, _totalSupply);
92     }
93 
94     function lock() public onlyOwner {
95         require(!locked);
96         emit Locked();
97         locked = true;
98     }
99 
100     function totalSupply() public constant returns (uint) {
101         return _totalSupply  - balances[address(0)];
102     }
103 
104     function balanceOf(address tokenOwner) public constant returns (uint balance) {
105         return balances[tokenOwner];
106     }
107 
108     function transfer(address to, uint tokens) public returns (bool success) {
109         balances[msg.sender] = balances[msg.sender].sub(tokens);
110         balances[to] = balances[to].add(tokens);
111         emit Transfer(msg.sender, to, tokens);
112         return true;
113     }
114 
115     function approve(address spender, uint tokens) public returns (bool success) {
116         allowed[msg.sender][spender] = tokens;
117         emit Approval(msg.sender, spender, tokens);
118         return true;
119     }
120 
121     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
122         balances[from] = balances[from].sub(tokens);
123         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
124         balances[to] = balances[to].add(tokens);
125         emit Transfer(from, to, tokens);
126         return true;
127     }
128 
129     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
130         return allowed[tokenOwner][spender];
131     }
132 
133     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
134         allowed[msg.sender][spender] = tokens;
135         emit Approval(msg.sender, spender, tokens);
136         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
137         return true;
138     }
139 
140     function () public payable {
141         revert();
142     }
143     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
144         return ERC20Interface(tokenAddress).transfer(owner, tokens);
145     }
146 }