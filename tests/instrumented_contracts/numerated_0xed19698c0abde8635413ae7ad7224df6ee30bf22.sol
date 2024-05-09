1 pragma solidity ^0.4.11;
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
12 /**
13  * @title SafeMath (from https://github.com/OpenZeppelin/zeppelin-solidity/blob/4d91118dd964618863395dcca25a50ff137bf5b6/contracts/math/SafeMath.sol)
14  * @dev Math operations with safety checks that throw on error
15  */
16 contract SafeMath {
17     
18     function safeMul(uint256 a, uint256 b) internal constant returns (uint256) {
19         uint256 c = a * b;
20         assert(a == 0 || c / a == b);
21         return c;
22     }
23 
24     function safeSub(uint256 a, uint256 b) internal constant returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function safeAdd(uint256 a, uint256 b) internal constant returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 contract TokenERC20 {
37 
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41     function transfer(address _to, uint256 _value) returns (bool success);
42     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
43     function approve(address _spender, uint256 _value) returns (bool success);
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
45     function balanceOf(address _owner) constant returns (uint256 balance);
46 }
47 
48 contract TokenNotifier {
49 
50     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
51 }
52 
53 contract ImmortalToken is Owned, SafeMath, TokenERC20 {
54 
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57     
58     uint8 public constant decimals = 0;
59     uint8 public constant totalSupply = 100;
60     string public constant name = 'Immortal';
61     string public constant symbol = 'IMT';
62     string public constant version = '1.0.0';
63 
64     function transfer(address _to, uint256 _value) returns (bool success) {
65         if (balances[msg.sender] < _value) return false;
66         balances[msg.sender] = safeSub(balances[msg.sender], _value);
67         assert(balances[msg.sender] >= 0);
68         balances[_to] = safeAdd(balances[_to], _value);
69         assert(balances[_to] <= totalSupply);
70         Transfer(msg.sender, _to, _value);
71         return true;
72     }
73 
74     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
75         if(balances[msg.sender] < _value || allowed[_from][msg.sender] < _value) return false;
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
92         if(!approve(_spender, _value)) return false;
93         TokenNotifier(_spender).receiveApproval(msg.sender, _value, this, _extraData);
94         return true;
95     }
96 
97     function balanceOf(address _owner) constant returns (uint256 balance) {
98         return balances[_owner];
99     }
100 
101     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
102         return allowed[_owner][_spender];
103     }
104 }
105 
106 contract Immortals is ImmortalToken {
107 
108     uint256 public tokenAssigned = 0;
109 
110     event Assigned(address _contributor, uint256 _immortals);
111 
112     function () payable {
113 		//Assign immortals based on ethers sent
114         require(tokenAssigned < totalSupply && msg.value >= 0.5 ether);
115 		uint256 immortals = msg.value / 0.5 ether;
116 		uint256 remainder = 0;
117 		//Find the remainder
118 		if( safeAdd(tokenAssigned, immortals) > totalSupply ) {
119 			immortals = totalSupply - tokenAssigned;
120 			remainder = msg.value - (immortals * 0.5 ether);
121 		} else {
122 			remainder = (msg.value % 0.5 ether);
123 		}	
124 		require(safeAdd(tokenAssigned, immortals) <= totalSupply);
125 		balances[msg.sender] = safeAdd(balances[msg.sender], immortals);
126 		tokenAssigned = safeAdd(tokenAssigned, immortals);
127 		assert(balances[msg.sender] <= totalSupply);
128 		//Send remainder to sender
129 		msg.sender.transfer(remainder);
130 		//Send ethers to owner
131 		owner.transfer(this.balance);
132 		assert(this.balance == 0);
133 		Assigned(msg.sender, immortals);
134     }
135 }