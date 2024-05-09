1 pragma solidity ^0.4.13
2 ;
3 
4 contract Ownable {
5   address public owner;
6 
7   function Ownable() {
8     owner = msg.sender;
9   }
10 
11   modifier onlyOwner() {
12     if (msg.sender != owner) {
13       throw;
14     }
15     _;
16   }
17 
18   function transferOwnership(address newOwner) onlyOwner {
19     if (newOwner != address(0)) {
20       owner = newOwner;
21     }
22   }
23 }
24 contract SafeMath {
25   function safeMul(uint a, uint b) internal returns (uint) {
26     uint c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function safeDiv(uint a, uint b) internal returns (uint) {
32     assert(b > 0);
33     uint c = a / b;
34     assert(a == b * c + a % b);
35     return c;
36   }
37 
38   function safeSub(uint a, uint b) internal returns (uint) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function safeAdd(uint a, uint b) internal returns (uint) {
44     uint c = a + b;
45     assert(c>=a && c>=b);
46     return c;
47   }
48 
49   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
50     return a >= b ? a : b;
51   }
52 
53   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
54     return a < b ? a : b;
55   }
56 
57   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
58     return a >= b ? a : b;
59   }
60 
61   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
62     return a < b ? a : b;
63   }
64 
65   function assert(bool assertion) internal {
66     if (!assertion) {
67       throw;
68     }
69   }
70 }
71 contract ERC20 {
72   uint public totalSupply;
73   function balanceOf(address who) constant returns (uint);
74   function allowance(address owner, address spender) constant returns (uint);
75   function transfer(address to, uint value) returns (bool ok);
76   function transferFrom(address from, address to, uint value) returns (bool ok);
77   function approve(address spender, uint value) returns (bool ok);
78   event Transfer(address indexed from, address indexed to, uint value);
79   event Approval(address indexed owner, address indexed spender, uint value);
80 }
81 contract StandardToken is ERC20, SafeMath {
82   mapping(address => uint) balances;
83   mapping (address => mapping (address => uint)) allowed;
84   function transfer(address _to, uint _value) returns (bool success) {
85     balances[msg.sender] = safeSub(balances[msg.sender], _value);
86     balances[_to] = safeAdd(balances[_to], _value);
87     Transfer(msg.sender, _to, _value);
88     return true;
89   }
90   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
91     var _allowance = allowed[_from][msg.sender];
92     balances[_to] = safeAdd(balances[_to], _value);
93     balances[_from] = safeSub(balances[_from], _value);
94     allowed[_from][msg.sender] = safeSub(_allowance, _value);
95     Transfer(_from, _to, _value);
96     return true;
97   }
98   function balanceOf(address _owner) constant returns (uint balance) {
99     return balances[_owner];
100   }
101   function approve(address _spender, uint _value) returns (bool success) {
102     allowed[msg.sender][_spender] = _value;
103     Approval(msg.sender, _spender, _value);
104     return true;
105   }
106   function allowance(address _owner, address _spender) constant returns (uint remaining) {
107     return allowed[_owner][_spender];
108   }
109 }
110 contract Schengencoin is Ownable, StandardToken {
111 
112     string public name = "Schengencoin";          
113     string public symbol = "SGNC";              
114     uint public decimals = 18;                 
115     uint public totalSupply = 1000000000 ether;  
116 
117     function Schengencoin() {
118         balances[msg.sender] = totalSupply;
119     }
120 
121     function transferOwnership(address _newOwner) onlyOwner {
122         balances[_newOwner] = balances[owner];
123         balances[owner] = 0;
124         Ownable.transferOwnership(_newOwner);
125     }
126 }