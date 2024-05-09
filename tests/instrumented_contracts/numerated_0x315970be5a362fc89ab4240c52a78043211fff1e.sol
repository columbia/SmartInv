1 pragma solidity ^0.4.13;
2 
3 contract SafeMath{
4   function safeMul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint a, uint b) internal returns (uint) {
11     assert(b > 0);
12     uint c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 	
17 	function safeSub(uint a, uint b) internal returns (uint) {
18     	assert(b <= a);
19     	return a - b;
20   }
21 
22 	function safeAdd(uint a, uint b) internal returns (uint) {
23     	uint c = a + b;
24     	assert(c >= a);
25     	return c;
26   }
27 	function assert(bool assertion) internal {
28 	    if (!assertion) {
29 	      revert();
30 	    }
31 	}
32 }
33 
34 contract Token {
35 
36     function totalSupply() constant returns (uint256 supply) {}
37 
38     function balanceOf(address _owner) constant returns (uint256 balance) {}
39 
40     function transfer(address _to, uint256 _value) returns (bool success) {}
41 
42     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
43 
44     function approve(address _spender, uint256 _value) returns (bool success) {}
45 
46     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
47 
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 
52 contract StandardToken is Token , SafeMath{
53 
54     function transfer(address _to, uint256 _value) returns (bool success) {
55         if (balances[msg.sender] >= _value && _value > 0) {
56             balances[msg.sender] = safeSub(balances[msg.sender], _value);
57             balances[_to] = safeAdd(balances[_to],_value);
58             Transfer(msg.sender, _to, _value);
59             return true;
60         } else { return false; }
61     }
62 
63     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
64          if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
65             balances[_to] = safeAdd(balances[_to],_value);
66             balances[_from] = safeSub(balances[_from],_value);
67             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
68             Transfer(_from, _to, _value);
69             return true;
70         } else { return false; }
71     }
72 
73     function balanceOf(address _owner) constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77     function approve(address _spender, uint256 _value) returns (bool success) {
78         allowed[msg.sender][_spender] = _value;
79         Approval(msg.sender, _spender, _value);
80         return true;
81     }
82 
83     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
84       return allowed[_owner][_spender];
85     }
86 
87     mapping (address => uint256) balances;
88     mapping (address => mapping (address => uint256)) allowed;
89     uint256 public totalSupply;
90 }
91 
92 contract DID is StandardToken {
93 
94     function () {
95         //if ether is sent to this address, send it back.
96         throw;
97     }
98 
99     
100     string public name = "DID";                   
101     uint8 public decimals = 18;
102     string public symbol = "DID";
103     uint256 public INITIAL_SUPPLY = 20000000000000000000000000000;
104 
105     function DID() {
106         balances[msg.sender] = INITIAL_SUPPLY;
107         totalSupply = INITIAL_SUPPLY;
108     }
109 
110      function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
111         allowed[msg.sender][_spender] = _value;
112         Approval(msg.sender, _spender, _value);
113 
114         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
115         return true;
116     }
117 }