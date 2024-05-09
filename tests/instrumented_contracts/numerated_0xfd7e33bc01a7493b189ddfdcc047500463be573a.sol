1 pragma solidity ^0.4.19;
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
25     function totalSupply() public constant returns (uint);
26     function balanceOf(address tokenOwner) public constant returns (uint balance);
27     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
28     function transfer(address to, uint tokens) public returns (bool success);
29     function approve(address spender, uint tokens) public returns (bool success);
30     function transferFrom(address from, address to, uint tokens) public returns (bool success);
31 
32     event Transfer(address indexed from, address indexed to, uint tokens);
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34 }
35 
36 
37 contract ApproveAndCallFallBack {
38     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
39 }
40 
41 
42 
43 contract Owned {
44     address public owner;
45     address public newOwner;
46 
47     event OwnershipTransferred(address indexed _from, address indexed _to);
48 
49     function Owned() public {
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
63         OwnershipTransferred(owner, newOwner);
64         owner = newOwner;
65         newOwner = address(0);
66     }
67 }
68 
69 contract FixedSupplyToken is ERC20Interface, Owned {
70     using SafeMath for uint;
71 
72     string public symbol;
73     string public  name;
74     uint8 public decimals;
75     uint public _totalSupply;
76 
77     mapping(address => uint) balances;
78     mapping(address => mapping(address => uint)) allowed;
79 
80 
81     function FixedSupplyToken() public {
82         symbol = "SPH";
83         name = "Sapphire Coin";
84         decimals = 18;
85         _totalSupply = 1000000000 * 10**uint(decimals);
86         balances[owner] = _totalSupply;
87         Transfer(address(0), owner, _totalSupply);
88     }
89 
90 
91     function totalSupply() public constant returns (uint) {
92         return _totalSupply  - balances[address(0)];
93     }
94 
95 
96 
97     function balanceOf(address tokenOwner) public constant returns (uint balance) {
98         return balances[tokenOwner];
99     }
100 
101 
102     function transfer(address to, uint tokens) public returns (bool success) {
103         balances[msg.sender] = balances[msg.sender].sub(tokens);
104         balances[to] = balances[to].add(tokens);
105         Transfer(msg.sender, to, tokens);
106         return true;
107     }
108 
109 
110     function approve(address spender, uint tokens) public returns (bool success) {
111         allowed[msg.sender][spender] = tokens;
112         Approval(msg.sender, spender, tokens);
113         return true;
114     }
115 
116 
117     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
118         balances[from] = balances[from].sub(tokens);
119         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
120         balances[to] = balances[to].add(tokens);
121         Transfer(from, to, tokens);
122         return true;
123     }
124 
125 
126     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
127         return allowed[tokenOwner][spender];
128     }
129 
130 
131 
132     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
133         allowed[msg.sender][spender] = tokens;
134         Approval(msg.sender, spender, tokens);
135         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
136         return true;
137     }
138 
139 
140     function () public payable {
141         revert();
142     }
143 
144     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
145         return ERC20Interface(tokenAddress).transfer(owner, tokens);
146     }
147 }