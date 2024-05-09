1 pragma solidity ^0.4.13;
2 
3 contract Owned {
4 
5     address owner;
6     
7     function Owned() { owner = msg.sender; }
8 
9     modifier onlyOwner { require(msg.sender == owner); _; }
10 }
11 
12 contract SafeMath {
13     
14     function safeMul(uint256 a, uint256 b) internal constant returns (uint256) {
15         uint256 c = a * b;
16         assert(a == 0 || c / a == b);
17         return c;
18     }
19 
20     function safeSub(uint256 a, uint256 b) internal constant returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function safeAdd(uint256 a, uint256 b) internal constant returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract TokenERC20 {
33 
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 
37     function transfer(address _to, uint256 _value) returns (bool success);
38     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
39     function approve(address _spender, uint256 _value) returns (bool success);
40     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
41     function balanceOf(address _owner) constant returns (uint256 balance);
42 }
43 
44 contract TokenNotifier {
45 
46     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
47 }
48 
49 contract ImmortalToken is Owned, SafeMath, TokenERC20 {
50 
51     mapping (address => uint256) balances;
52     mapping (address => mapping (address => uint256)) allowed;
53     
54     uint8 public constant decimals = 0;
55     uint8 public constant totalSupply = 100;
56     string public constant name = "Immortal";
57     string public constant symbol = "IMT";
58     string public constant version = "1.0.1";
59 
60     function transfer(address _to, uint256 _value) returns (bool success) {
61         if (balances[msg.sender] < _value) {
62             return false;
63         }
64         balances[msg.sender] = safeSub(balances[msg.sender], _value);
65         assert(balances[msg.sender] >= 0);
66         balances[_to] = safeAdd(balances[_to], _value);
67         assert(balances[_to] <= totalSupply);
68         Transfer(msg.sender, _to, _value);
69         return true;
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
73         if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {
74             return false;
75         }
76         balances[_from] = safeSub(balances[_from], _value);
77         assert(balances[_from] >= 0);
78         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
79         balances[_to] = safeAdd(balances[_to], _value);
80         assert(balances[_to] <= totalSupply);
81         Transfer(_from, _to, _value);
82         return true;
83     }
84 
85     function approve(address _spender, uint256 _value) returns (bool success) {
86         allowed[msg.sender][_spender] = _value;
87         Approval(msg.sender, _spender, _value);
88         return true;
89     }
90 
91     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
92         if (!approve(_spender, _value)) {
93             return false;
94         }
95         TokenNotifier(_spender).receiveApproval(msg.sender, _value, this, _extraData);
96         return true;
97     }
98 
99     function balanceOf(address _owner) constant returns (uint256 balance) {
100         return balances[_owner];
101     }
102 
103     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
104         return allowed[_owner][_spender];
105     }
106 }
107 
108 contract Immortals is ImmortalToken {
109 
110     uint256 public tokenAssigned = 0;
111 
112     event Assigned(address _contributor, uint256 _immortals);
113 
114     function () payable {
115 		//Assign immortals based on ethers sent
116         require(tokenAssigned < totalSupply && msg.value >= 0.5 ether);
117 		uint256 immortals = msg.value / 0.5 ether;
118 		uint256 remainder = 0;
119 		//Find the remainder
120 		if (safeAdd(tokenAssigned, immortals) > totalSupply) {
121 			immortals = totalSupply - tokenAssigned;
122 			remainder = msg.value - (immortals * 0.5 ether);
123 		} else {
124 			remainder = (msg.value % 0.5 ether);
125 		}	
126 		require(safeAdd(tokenAssigned, immortals) <= totalSupply);
127 		balances[msg.sender] = safeAdd(balances[msg.sender], immortals);
128 		tokenAssigned = safeAdd(tokenAssigned, immortals);
129 		assert(balances[msg.sender] <= totalSupply);
130 		//Send remainder to sender
131 		msg.sender.transfer(remainder);
132 		Assigned(msg.sender, immortals);
133     }
134 
135 	function redeemEther(uint256 _amount) onlyOwner external {
136         owner.transfer(_amount);
137     }
138 }