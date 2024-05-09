1 pragma solidity ^0.4.25;
2 
3 //BITCENTECH LIMITED
4 //Company number: 11987716
5 //Office address: 1 Payne Road, Bow, London, United Kingdom, E3 2SP
6 //Nature of business (SIC): 66300 - Fund management activities
7 
8 contract SafeMath {
9     function safeAdd(uint a, uint b) public pure returns (uint c) {
10         c = a + b;
11         require(c >= a, "Error");
12     }
13     function safeSub(uint a, uint b) public pure returns (uint c) {
14         require(b <= a, "Error");
15         c = a - b;
16     }
17     function safeMul(uint a, uint b) public pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b, "Error");
20     }
21     function safeDiv(uint a, uint b) public pure returns (uint c) {
22         require(b > 0, "Error");
23         c = a / b;
24     }
25 }
26 
27 contract ERC20Interface {
28     function totalSupply() public view returns (uint);
29     function balanceOf(address tokenOwner) public view returns (uint balance);
30     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
31     function transfer(address to, uint tokens) public returns (bool success);
32     function approve(address spender, uint tokens) public returns (bool success);
33     function transferFrom(address from, address to, uint tokens) public returns (bool success);
34 
35     event Transfer(address indexed from, address indexed to, uint tokens);
36     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
37 }
38 
39 
40 contract ApproveAndCallFallBack {
41     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
42 }
43 
44 contract Owned {
45     address public owner;
46     address public newOwner;
47 
48     event OwnershipTransferred(address indexed from, address indexed to);
49 
50     constructor() public {
51         owner = msg.sender;
52     }
53 
54     modifier onlyOwner {
55         require(msg.sender == owner, "Sender should be the owner");
56         _;
57     }
58 
59     function transferOwnership(address _newOwner) public onlyOwner {
60         owner = _newOwner;
61         emit OwnershipTransferred(owner, newOwner);
62     }
63     function acceptOwnership() public {
64         require(msg.sender == newOwner, "Sender should be the owner");
65         emit OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67         newOwner = address(0);
68     }
69 }
70 
71 
72 contract Bitcentech is ERC20Interface, Owned, SafeMath {
73     string public symbol;
74     string public  name;
75     uint8 public decimals;
76     uint public _totalSupply;
77 
78     mapping(address => uint) balances;
79     mapping(address => mapping(address => uint)) allowed;
80 
81     constructor(string _symbol, string _name, uint8 _decimals, uint totalSupply, address _owner) public {
82         symbol = _symbol;
83         name = _name;
84         decimals = _decimals;
85         _totalSupply = totalSupply*10**uint(decimals);
86         balances[_owner] = _totalSupply;
87         emit Transfer(address(0), _owner, _totalSupply);
88         transferOwnership(_owner);
89     }
90 
91 
92     function totalSupply() public view returns (uint) {
93         return _totalSupply - balances[address(0)];
94     }
95 
96 
97     function balanceOf(address tokenOwner) public view returns (uint balance) {
98         return balances[tokenOwner];
99     }
100 
101 
102     function transfer(address to, uint tokens) public returns (bool success) {
103         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
104         balances[to] = safeAdd(balances[to], tokens);
105         emit Transfer(msg.sender, to, tokens);
106         return true;
107     }
108 
109 
110     function approve(address spender, uint tokens) public returns (bool success) {
111         allowed[msg.sender][spender] = tokens;
112         emit Approval(msg.sender, spender, tokens);
113         return true;
114     }
115 
116 
117     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
118         balances[from] = safeSub(balances[from], tokens);
119         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
120         balances[to] = safeAdd(balances[to], tokens);
121         emit Transfer(from, to, tokens);
122         return true;
123     }
124 
125 
126     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
127         return allowed[tokenOwner][spender];
128     }
129 
130 
131     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
132         allowed[msg.sender][spender] = tokens;
133         emit Approval(msg.sender, spender, tokens);
134         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
135         return true;
136     }
137 
138 
139     function () public payable {
140         revert("Ether can't be accepted.");
141     }
142 
143 
144     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
145         return ERC20Interface(tokenAddress).transfer(owner, tokens);
146     }
147 }