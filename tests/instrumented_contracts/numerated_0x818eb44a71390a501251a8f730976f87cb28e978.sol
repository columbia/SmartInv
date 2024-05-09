1 pragma solidity ^0.4.11;
2 
3 
4 contract ERC20 {
5   uint public totalSupply;
6   function balanceOf(address who) constant returns (uint);
7   function allowance(address owner, address spender) constant returns (uint);
8 
9   function transfer(address to, uint value) returns (bool ok);
10   function transferFrom(address from, address to, uint value) returns (bool ok);
11   function approve(address spender, uint value) returns (bool ok);
12   event Transfer(address indexed from, address indexed to, uint value);
13   event Approval(address indexed owner, address indexed spender, uint value);
14 }
15 
16 
17 contract SafeMath {
18   function safeMul(uint a, uint b) internal returns (uint) {
19     uint c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function safeDiv(uint a, uint b) internal returns (uint) {
25     assert(b > 0);
26     uint c = a / b;
27     assert(a == b * c + a % b);
28     return c;
29   }
30 
31   function safeSub(uint a, uint b) internal returns (uint) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function safeAdd(uint a, uint b) internal returns (uint) {
37     uint c = a + b;
38     assert(c>=a && c>=b);
39     return c;
40   }
41 
42   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
43     return a >= b ? a : b;
44   }
45 
46   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
47     return a < b ? a : b;
48   }
49 
50   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
51     return a >= b ? a : b;
52   }
53 
54   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
55     return a < b ? a : b;
56   }
57 
58 }
59 
60 
61 
62 
63 /**
64  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
65  */
66 
67 contract StandardToken is ERC20, SafeMath {
68 
69   mapping(address => uint) balances;
70 
71   mapping (address => mapping (address => uint)) allowed;
72 
73   /**
74    * Fix for the ERC20 short address attack
75    */
76   modifier onlyPayloadSize(uint size) {
77      if(msg.data.length != size + 4) {
78        revert();
79      }
80      _;
81   }
82 
83   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
84     balances[msg.sender] = safeSub(balances[msg.sender], _value);
85     balances[_to] = safeAdd(balances[_to], _value);
86     Transfer(msg.sender, _to, _value);
87     return true;
88   }
89 
90   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
91     uint _allowance = allowed[_from][msg.sender];
92 
93     balances[_to] = safeAdd(balances[_to], _value);
94     balances[_from] = safeSub(balances[_from], _value);
95     allowed[_from][msg.sender] = safeSub(_allowance, _value);
96     Transfer(_from, _to, _value);
97     return true;
98   }
99 
100   function balanceOf(address _owner) constant returns (uint balance) {
101     return balances[_owner];
102   }
103 
104   function approve(address _spender, uint _value) returns (bool success) {
105 
106     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
107 
108     allowed[msg.sender][_spender] = _value;
109     Approval(msg.sender, _spender, _value);
110     return true;
111   }
112 
113   function allowance(address _owner, address _spender) constant returns (uint remaining) {
114     return allowed[_owner][_spender];
115   }
116   }
117 
118 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
119 
120 
121 contract PermiCoin is StandardToken {
122   string public constant name = "PermiCoin";
123   string public constant symbol = "PMC";
124   uint public constant decimals = 6;               
125   uint public totalSupply = 10000000000000;       
126  /* = 10 000 000 PermiCoins * 1 000 000 (6 decimals) */
127   string public version = "1.0";
128 
129   // Constructor
130 
131   function PermiCoin() {
132       balances[msg.sender] = totalSupply; 
133   }
134 
135 
136     /* Approve and then communicate the approved contract in a single tx */
137     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
138         returns (bool success) {
139         tokenRecipient spender = tokenRecipient(_spender);
140         if (approve(_spender, _value)) {
141             spender.receiveApproval(msg.sender, _value, this, _extraData);
142             return true;
143         }
144     }   
145 
146   }