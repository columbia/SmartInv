1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) public pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8 
9     function safeSub(uint a, uint b) public pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13 
14     function safeMul(uint a, uint b) public pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18 
19     function safeDiv(uint a, uint b) public pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 contract ERC20Interface {
26     function totalSupply() public constant returns (uint);
27 
28     function balanceOf(address tokenOwner) public constant returns (uint balance);
29 
30     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
31 
32     function transfer(address to, uint tokens) public returns (bool success);
33 
34     function approve(address spender, uint tokens) public returns (bool success);
35 
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 contract ApproveAndCallFallBack {
43     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
44 }
45 
46 contract Owned {
47     address public owner;
48     address public newOwner;
49 
50     event OwnershipTransferred(address indexed _from, address indexed _to);
51     constructor() public {
52         owner = msg.sender;
53     }
54     modifier onlyOwner {
55         require(msg.sender == owner);
56         _;
57     }
58     function transferOwnership(address _newOwner) public onlyOwner {
59         newOwner = _newOwner;
60     }
61 
62     function acceptOwnership() public {
63         require(msg.sender == newOwner);
64         emit OwnershipTransferred(owner, newOwner);
65         owner = newOwner;
66         newOwner = address(0);
67     }
68 }
69 
70 contract LuxToken is ERC20Interface, Owned, SafeMath {
71     string public symbol;
72     string public  name;
73     uint256 public constant decimals = 18;
74     uint public _totalSupply;
75     mapping(address => uint) balances;
76     mapping(address => mapping(address => uint)) allowed;
77 
78     uint public constant supplyNumber = 80000000;
79     uint public constant powNumber = 10;
80     uint public constant TOKEN_SUPPLY_TOTAL = supplyNumber * powNumber ** decimals;
81 
82     constructor() public {
83         symbol = "LXT";
84         name = "LUX Token";
85         _totalSupply = TOKEN_SUPPLY_TOTAL;
86         balances[msg.sender] = _totalSupply;
87         emit Transfer(address(0), msg.sender, _totalSupply);
88     }
89     function totalSupply() public constant returns (uint) {
90         return _totalSupply - balances[address(0)];
91     }
92 
93     function balanceOf(address tokenOwner) public constant returns (uint balance) {
94         return balances[tokenOwner];
95     }
96 
97     function transfer(address to, uint tokens) public returns (bool success) {
98         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
99         balances[to] = safeAdd(balances[to], tokens);
100         emit Transfer(msg.sender, to, tokens);
101         return true;
102     }
103 
104     function batchTransfer(address[] _receivers, uint256[] _amounts) public returns (bool) {
105         uint256 cnt = _receivers.length;
106         require(cnt > 0 && cnt <= 100);
107         require(cnt == _amounts.length);
108         cnt = (uint8)(cnt);
109         uint256 totalAmount = 0;
110         for (uint8 i = 0; i < cnt; i++) {
111             totalAmount = safeAdd(totalAmount, _amounts[i]);
112         }
113         require(totalAmount <= balances[msg.sender]);
114         balances[msg.sender] = safeSub(balances[msg.sender], totalAmount);
115         for (i = 0; i < cnt; i++) {
116             balances[_receivers[i]] = safeAdd(balances[_receivers[i]], _amounts[i]);
117             emit Transfer(msg.sender, _receivers[i], _amounts[i]);
118         }
119         return true;
120     }
121 
122     function approve(address spender, uint tokens) public returns (bool success) {
123         allowed[msg.sender][spender] = tokens;
124         emit Approval(msg.sender, spender, tokens);
125         return true;
126     }
127 
128     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
129         balances[from] = safeSub(balances[from], tokens);
130         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
131         balances[to] = safeAdd(balances[to], tokens);
132         emit Transfer(from, to, tokens);
133         return true;
134     }
135 
136     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
137         return allowed[tokenOwner][spender];
138     }
139 
140     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
141         allowed[msg.sender][spender] = tokens;
142         emit Approval(msg.sender, spender, tokens);
143         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
144         return true;
145     }
146 
147     function() public payable {
148         revert();
149     }
150 
151     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
152         return ERC20Interface(tokenAddress).transfer(owner, tokens);
153     }
154 
155     function burn(uint256 _value) public {
156         require(balances[msg.sender] >= _value);
157         balances[msg.sender] -= _value;
158         balances[0x0] += _value;
159         emit Transfer(msg.sender, 0x0, _value);
160     }
161 }