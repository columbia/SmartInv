1 pragma solidity ^0.4.11;
2 
3 library safeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function div(uint a, uint b) internal returns (uint) {
10     assert(b > 0);
11     uint c = a / b;
12     assert(a == b * c + a % b);
13     return c;
14   }
15   function sub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19   function add(uint a, uint b) internal returns (uint) {
20     uint c = a + b;
21     assert(c >= a);
22     return c;
23   }
24   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
25     return a >= b ? a : b;
26   }
27   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
28     return a < b ? a : b;
29   }
30   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
31     return a >= b ? a : b;
32   }
33   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
34     return a < b ? a : b;
35   }
36   function assert(bool assertion) internal {
37     if (!assertion) {
38       throw;
39     }
40   }
41 }
42 
43 contract ERC20 {
44     function totalSupply() constant returns (uint supply);
45     function balanceOf(address who) constant returns (uint value);
46     function allowance(address owner, address spender) constant returns (uint _allowance);
47 
48     function transfer(address to, uint value) returns (bool ok);
49     function transferFrom(address from, address to, uint value) returns (bool ok);
50     function approve(address spender, uint value) returns (bool ok);
51 
52     event Transfer(address indexed from, address indexed to, uint value);
53     event Approval(address indexed owner, address indexed spender, uint value);
54 }
55 
56 contract HealthCoin is ERC20{
57 	uint initialSupply = 500000;
58 	string public constant name = "HealthCoin";
59 	string public constant symbol = "HLC";
60 	uint USDExchangeRate = 300;
61 	uint price = 30;
62 	address HealthCoinAddress;
63 
64 	mapping (address => uint256) balances;
65 	mapping (address => mapping (address => uint256)) allowed;
66 	
67 	modifier onlyOwner{
68     if (msg.sender == HealthCoinAddress) {
69 		  _;
70 		}
71 	}
72 
73 	function totalSupply() constant returns (uint256) {
74 		return initialSupply;
75     }
76 
77 	function balanceOf(address _owner) constant returns (uint256 balance) {
78 		return balances[_owner];
79     }
80 
81   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
82     return allowed[_owner][_spender];
83   }
84 
85   function transfer(address _to, uint256 _value) returns (bool success) {
86     if (balances[msg.sender] >= _value && _value > 0) {
87       balances[msg.sender] -= _value;
88       balances[_to] += _value;
89       Transfer(msg.sender, _to, _value);
90       return true;
91     } else {
92       return false;
93     }
94   }
95 
96   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
97     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
98       balances[_to] += _value;
99       balances[_from] -= _value;
100       allowed[_from][msg.sender] -= _value;
101       Transfer(_from, _to, _value);
102       return true;
103     } else {
104       return false;
105     }
106   }
107 
108   function approve(address _spender, uint256 _value) returns (bool success) {
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111     return true;
112   }
113 
114 	function HealthCoin() {
115         HealthCoinAddress = msg.sender;
116         balances[HealthCoinAddress] = initialSupply;
117     }
118 
119 	function setUSDExchangeRate (uint rate) onlyOwner{
120 		USDExchangeRate = rate;
121 	}
122 
123 	function () payable{
124 	    uint amountInUSDollars = safeMath.div(safeMath.mul(msg.value, USDExchangeRate),10**18);
125 	    uint valueToPass = safeMath.div(amountInUSDollars, price);
126     	if (balances[HealthCoinAddress] >= valueToPass && valueToPass > 0) {
127           balances[msg.sender] = safeMath.add(balances[msg.sender],valueToPass);
128           balances[HealthCoinAddress] = safeMath.sub(balances[HealthCoinAddress],valueToPass);
129           Transfer(HealthCoinAddress, msg.sender, valueToPass);
130         } 
131 	}
132 
133 	function withdraw(uint amount) onlyOwner{
134         HealthCoinAddress.transfer(amount);
135 	}
136 }