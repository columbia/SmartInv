1 pragma solidity ^0.4.8;
2 
3 contract Ownable {
4   address public owner;
5 
6   function Ownable() {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     if (msg.sender != owner) {
12       throw;
13     }
14     _;
15   }
16 
17   function transferOwnership(address newOwner) onlyOwner {
18     if (newOwner != address(0)) {
19       owner = newOwner;
20     }
21   }
22 }
23 
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
71 
72 contract ERC20 {
73   uint public totalSupply;
74   function balanceOf(address who) constant returns (uint);
75   function allowance(address owner, address spender) constant returns (uint);
76 
77   function transfer(address to, uint value) returns (bool ok);
78   function transferFrom(address from, address to, uint value) returns (bool ok);
79   function approve(address spender, uint value) returns (bool ok);
80   event Transfer(address indexed from, address indexed to, uint value);
81   event Approval(address indexed owner, address indexed spender, uint value);
82 }
83 
84 contract StandardToken is ERC20, SafeMath {
85   mapping(address => uint) balances;
86   mapping (address => mapping (address => uint)) allowed;
87 
88   function transfer(address _to, uint _value) returns (bool success) {
89     balances[msg.sender] = safeSub(balances[msg.sender], _value);
90     balances[_to] = safeAdd(balances[_to], _value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
96     var _allowance = allowed[_from][msg.sender];
97     balances[_to] = safeAdd(balances[_to], _value);
98     balances[_from] = safeSub(balances[_from], _value);
99     allowed[_from][msg.sender] = safeSub(_allowance, _value);
100     Transfer(_from, _to, _value);
101     return true;
102   }
103 
104   function balanceOf(address _owner) constant returns (uint balance) {
105     return balances[_owner];
106   }
107 
108   function approve(address _spender, uint _value) returns (bool success) {
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111     return true;
112   }
113 
114   function allowance(address _owner, address _spender) constant returns (uint remaining) {
115     return allowed[_owner][_spender];
116   }
117 }
118 
119 contract TicketToken is Ownable, StandardToken {
120 
121     string public name = "7icket";
122     string public symbol = "7ICKET";
123     uint public decimals = 18;
124 
125     uint public totalSupply = 10000000 ether;
126 
127     function TicketToken() {
128         balances[msg.sender] = totalSupply;
129     }
130   
131     function transferOwnership(address _newOwner) onlyOwner {
132         balances[_newOwner] = balances[owner];
133         balances[owner] = 0;
134         Ownable.transferOwnership(_newOwner);
135     }
136 }