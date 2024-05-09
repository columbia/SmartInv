1 pragma solidity ^0.4.10;
2 
3 contract Token {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 
15 /*  ERC 20 token */
16 contract StandardToken is Token {
17 
18     function transfer(address _to, uint256 _value) returns (bool success) {
19       if (balances[msg.sender] >= _value && _value > 0) {		
20         balances[msg.sender] -= _value;
21         balances[_to] += _value;
22         Transfer(msg.sender, _to, _value);
23         return true;
24       } else {
25         return false;
26       }
27     }
28 
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
30       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
31         balances[_to] += _value;
32         balances[_from] -= _value;
33         allowed[_from][msg.sender] -= _value;
34         Transfer(_from, _to, _value);
35         return true;
36       } else {
37         return false;
38       }
39     }
40 
41     function balanceOf(address _owner) constant returns (uint256 balance) {
42         return balances[_owner];
43     }
44 
45     function approve(address _spender, uint256 _value) returns (bool success) {
46         allowed[msg.sender][_spender] = _value;
47         Approval(msg.sender, _spender, _value);
48         return true;
49     }
50 
51     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
52       return allowed[_owner][_spender];
53     }
54 
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57 }
58 
59 contract UGame is StandardToken {
60 	
61     // metadata
62 	string public constant name = "UGame";
63     string public constant symbol = "UGame";
64     uint256 public constant decimals = 18;
65     string public version = "1.0";
66 	
67     address public creator;                    
68     address account1 = '0xBF1BE11D53BC31E05B471296B14eE66F4C0Fe4dc';  //6000W	
69 	address account2 = '0x0eA6d81D796F113B2Fc420261DE115eE44B2a888';  //1500W 	
70 	address account3 = '0xc3c4C1F265dcA870389BE76D1846F2b1c47A5983';  //300W
71 	address account4 = '0xAa3608ca11fb3168EbaD0c9Aa602008655DbBbeb';  //1000W
72 	address account5 = '0x008B1850BdAAC42Bc050702eDeAA700BFC56f017';  //1200W
73 	
74     uint256 public amount1 = 6000 * 10000 * 10**decimals;
75     uint256 public amount2 = 1500 * 10000 * 10**decimals;
76 	uint256 public amount3 = 300  * 10000 * 10**decimals;
77 	uint256 public amount4 = 1000 * 10000 * 10**decimals;
78 	uint256 public amount5 = 1200 * 10000 * 10**decimals;
79 	
80 
81     // constructor
82     function UGame() {
83 	    creator = msg.sender;
84 		balances[account1] = amount1;                          
85 		balances[account2] = amount2;                         
86 		balances[account3] = amount3;                         
87 		balances[account4] = amount4;
88 		balances[account5] = amount5;
89     }
90 	
91 	function transfer(address _to, uint256 _value) returns (bool success) {
92       if (balances[msg.sender] >= _value && _value > 0) {	
93 			balances[msg.sender] -= _value;
94 			balances[_to] += _value;
95 			Transfer(msg.sender, _to, _value);
96 			return true;
97       } else {
98         return false;
99       }
100     }
101 
102 }