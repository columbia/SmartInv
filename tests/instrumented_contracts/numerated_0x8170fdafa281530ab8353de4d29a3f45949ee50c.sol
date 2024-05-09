1 pragma solidity ^0.4.19;
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint);
5     function balanceOf(address tokenOwner) public constant returns (uint balance);
6     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 
16 contract ApproveAndCallFallBack {
17     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
18 }
19 
20 contract Owned {
21     address public owner;
22     address public newOwner;
23 
24     event OwnershipTransferred(address indexed _from, address indexed _to);
25 
26     function Own() public {
27         owner = msg.sender;
28     }
29 
30     modifier onlyOwner {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     function transferOwnership(address _newOwner) public onlyOwner {
36         newOwner = _newOwner;
37     }
38     
39     function acceptOwnership() public {
40         require(msg.sender == newOwner);
41      emit   OwnershipTransferred(owner, newOwner);
42         owner = newOwner;
43         newOwner = address(0);
44     }
45 }
46 
47 contract Flame is ERC20Interface, Owned {
48     string public symbol;
49     string public  name;
50     uint8 public decimals;
51     uint public _totalSupply;
52     uint public _maxSupply;
53     uint public _ratio;
54     bool disabled;
55 
56     mapping(address => uint) balances;
57     mapping(address => mapping(address => uint)) allowed;
58     
59 
60 
61     function Flames() public {
62             disabled = false;
63         symbol = "FLAME";
64 
65         name = "Flame";
66         decimals = 18;
67         _totalSupply = 25000 * 10**uint(decimals);      
68 
69         _ratio = 1000;
70 
71         _maxSupply = 125000 * 10**uint(decimals);    
72         balances[owner] = _totalSupply;
73  
74       emit  Transfer(address(0), owner, _totalSupply);
75     }
76 
77     function totalSupply() public constant returns (uint) {
78         return _totalSupply;
79     }
80 
81 
82     function balanceOf(address tokenOwner) public constant returns (uint balance) {
83         return balances[tokenOwner];
84     }
85 
86  
87     function transfer(address to, uint tokens) public returns (bool success) {
88         require(balances[msg.sender] >= tokens);
89         balances[msg.sender] -= tokens;
90         balances[to] += tokens;
91       emit  Transfer(msg.sender, to, tokens);
92         return true;
93     }
94 
95 
96     function approve(address spender, uint tokens) public returns (bool success) {
97         allowed[msg.sender][spender] = tokens;
98      emit Approval(msg.sender, spender, tokens);
99         return true;
100     }
101 
102  function transferFrom(address from, address to, uint tokens) public returns (bool success) {
103         require (allowed[from][msg.sender] >= tokens);
104         require (balances[from] >= tokens);
105         
106         balances[from] -= tokens;
107         allowed[from][msg.sender] -= tokens;
108         balances[to] += tokens;
109       emit  Transfer(from, to, tokens);
110         return true;
111     }
112 
113     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
114         return allowed[tokenOwner][spender];
115     }
116 
117     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
118         allowed[msg.sender][spender] = tokens;
119       emit  Approval(msg.sender, spender, tokens);
120         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
121         return true;
122     }
123 
124 
125     function disablePresale(bool _disabled) public onlyOwner returns (bool success) {
126         disabled = _disabled;
127         return true;
128     }
129 
130     function () public payable {
131         require(msg.value >= 100000000000);
132         require(_totalSupply+(msg.value*_ratio)<=_maxSupply);
133         
134         uint tokens;
135         tokens = msg.value*_ratio;
136 
137         balances[msg.sender] += tokens;
138         _totalSupply += tokens;
139      emit   Transfer(address(0), msg.sender, tokens);
140     }
141 
142 
143 
144     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
145         return ERC20Interface(tokenAddress).transfer(owner, tokens);
146     }
147 
148 
149 
150     function checkBalance() public constant returns (uint checkBal) {
151         return address(this).balance;
152     }
153 
154 
155 
156     function transferFunds(address _address, uint amount) public onlyOwner {
157        require(amount <= address(this).balance);
158         _address.transfer(amount);
159     }
160 }