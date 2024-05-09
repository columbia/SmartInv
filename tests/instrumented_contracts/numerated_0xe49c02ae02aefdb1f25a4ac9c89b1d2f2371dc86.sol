1 pragma solidity ^0.4.17;
2 
3 
4 contract Ownable {
5   address public owner;
6   function Ownable() {
7     owner = msg.sender;
8   }
9   modifier onlyOwner() {
10     if (msg.sender != owner) {
11       throw;
12         
13     }
14     _;
15   }
16   function transferOwnership(address newOwner) onlyOwner 
17   {if(newOwner != address(0)){owner = newOwner;}
18   }
19 }
20 
21 contract SafeMath {
22   function safeMul(uint a, uint b) internal returns (uint) {
23     uint c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function safeDiv(uint a, uint b) internal returns (uint) {
29     assert(b > 0);
30     uint c = a / b;
31     assert(a == b * c + a % b);
32     return c;
33   }
34 
35   function safeSub(uint a, uint b) internal returns (uint) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function safeAdd(uint a, uint b) internal returns (uint) {
41     uint c = a + b;
42     assert(c>=a && c>=b);
43     return c;
44   }
45 
46   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
47     return a >= b ? a : b;
48   }
49 
50   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
51     return a < b ? a : b;
52   }
53 
54   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
55     return a >= b ? a : b;
56   }
57 
58   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
59     return a < b ? a : b;
60   }
61 
62   function assert(bool assertion) internal {
63     if (!assertion) {
64       throw;
65     }
66   }
67 }
68 
69 contract ERC20 {
70   uint public totalSupply;
71   function balanceOf(address who) constant returns (uint);
72   function allowance(address owner, address spender) constant returns (uint);
73 
74   function transfer(address to, uint value) returns (bool ok);
75   function transferFrom(address from, address to, uint value) returns (bool ok);
76   function approve(address spender, uint value) returns (bool ok);
77   event Transfer(address indexed from, address indexed to, uint value);
78   event Approval(address indexed owner, address indexed spender, uint value);
79 }
80 contract StandardToken is ERC20, SafeMath {
81   mapping(address => uint) balances;
82   mapping (address => mapping (address => uint)) allowed;
83   function transfer(address _to, uint _value) returns (bool success) {
84     balances[msg.sender] = safeSub(balances[msg.sender], _value);
85     balances[_to] = safeAdd(balances[_to], _value);
86     Transfer(msg.sender, _to, _value);
87     return true;
88   }
89   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
90     var _allowance = allowed[_from][msg.sender];
91     balances[_to] = safeAdd(balances[_to], _value);
92     balances[_from] = safeSub(balances[_from], _value);
93     allowed[_from][msg.sender] = safeSub(_allowance, _value);
94     Transfer(_from, _to, _value);
95     return true;
96    }
97   function balanceOf(address _owner) constant returns (uint balance) {
98     return balances[_owner];
99    }
100   function approve(address _spender, uint _value) returns (bool success) {
101     allowed[msg.sender][_spender] = _value;
102     Approval(msg.sender, _spender, _value);
103     return true;
104    }
105   function allowance(address _owner, address _spender) constant returns (uint remaining) {
106     return allowed[_owner][_spender];
107    }
108 }
109 contract TheCoinEconomy is Ownable, StandardToken {
110     string public name = "TheCoinEconomy";          
111     string public symbol = "TCE";              
112     uint public decimals = 18;                  
113     uint public totalSupply = 1100000000000000000000000;  
114     function TheCoinEconomy() {
115         balances[msg.sender] = totalSupply;
116     }   
117 }