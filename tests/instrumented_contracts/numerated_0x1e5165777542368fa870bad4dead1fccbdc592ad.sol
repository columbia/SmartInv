1 pragma solidity ^0.4.19;
2 
3 
4 /** test
5 */
6  
7 contract SafeMath {
8   function mul(uint256 a, uint256 b) internal returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal returns (uint256) {
15     assert(b > 0);
16     uint256 c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal returns (uint256) {
27     uint256 c = a + b;
28     assert(c>=a && c>=b);
29     return c;
30   }
31 
32   function assert(bool assertion) internal {
33     if (!assertion) {
34       throw;
35     }
36   }
37 }
38 
39 contract Token {
40 
41     function totalSupply() constant returns (uint256 supply) {}
42     function balanceOf(address _owner) constant returns (uint256 balance) {}
43     function transfer(address _to, uint256 _value) returns (bool success) {}
44     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
45     function approve(address _spender, uint256 _value) returns (bool success) {}
46     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
47 
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 
52 contract RegularToken is Token, SafeMath {
53 
54     function transfer(address _to, uint256 _value) returns (bool) {
55         require(balances[msg.sender] >= _value);
56         require(balances[_to] + _value >= balances[_to]);
57         balances[msg.sender] = sub(balances[msg.sender], _value);
58         balances[_to] = add(balances[_to], _value);
59         emit Transfer(msg.sender, _to, _value);
60         return true;
61     }
62 
63     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
64         require(balances[_from] >= _value);
65         require(balances[_to] + _value >= balances[_to]);
66         require(allowed[_from][msg.sender] >= _value);
67         balances[_from] = sub(balances[_from], _value);
68         balances[_to] = add(balances[_to], _value);
69         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
70         emit Transfer(_from, _to, _value);
71         return true;
72     }
73 
74     function balanceOf(address _owner) constant returns (uint256) {
75         return balances[_owner];
76     }
77 
78     function approve(address _spender, uint256 _value) returns (bool) {
79         allowed[msg.sender][_spender] = _value;
80         emit Approval(msg.sender, _spender, _value);
81         return true;
82     }
83 
84     function allowance(address _owner, address _spender) constant returns (uint256) {
85         return allowed[_owner][_spender];
86     }
87 
88     mapping (address => uint256) balances;
89     mapping (address => mapping (address => uint256)) allowed;
90     uint256 public totalSupply;
91 }
92 
93 
94 contract MyTestToken is RegularToken {
95 
96     uint256 public totalSupply = 100*10**(18+8);
97     uint8 constant public decimals = 18;
98     string constant public name = "Mytest";
99     string constant public symbol = "MT";
100 
101     function MyTestToken() {
102         balances[msg.sender] = totalSupply;
103         emit Transfer(address(0), msg.sender, totalSupply);
104     }
105 }