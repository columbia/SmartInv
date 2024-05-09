1 pragma solidity ^0.4.10;
2 
3 
4 contract SafeMath {
5     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
6         uint256 z = x + y;
7         assert((z >= x) && (z >= y));
8         return z;
9     }
10 
11     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
12         assert(x >= y);
13         uint256 z = x - y;
14         return z;
15     }
16 
17     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
18         uint256 z = x * y;
19         assert((x == 0)||(z/x == y));
20         return z;
21     }
22 
23 }
24 
25 contract Token {
26     uint256 public totalSupply;
27     function balanceOf(address _owner) constant returns  (uint256 balance);
28     function transfer(address _to, uint256 _value) returns (bool success);
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
30     function approve(address _spender, uint256 _value) returns (bool success);
31     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 
35 }
36 
37 
38 contract StandardToken is Token , SafeMath {
39 
40     bool public status = true;
41     modifier on() {
42         require(status == true);
43         _;
44     }
45 
46     function transfer(address _to, uint256 _value) on returns (bool success) {
47         if (balances[msg.sender] >= _value && _value > 0 && _to != 0X0) {
48             balances[msg.sender] -= _value;
49             balances[_to] = safeAdd(balances[_to],_value);
50             Transfer(msg.sender, _to, _value);
51             return true;
52         } else {
53             return false;
54         }
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) on returns (bool success) {
58         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
59             balances[_to] = safeAdd(balances[_to],_value);
60             balances[_from] = safeSubtract(balances[_from],_value);
61             allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender],_value);
62             Transfer(_from, _to, _value);
63             return true;
64         } else {
65             return false;
66         }
67     }
68 
69     function balanceOf(address _owner) on constant returns (uint256 balance) {
70         return balances[_owner];
71     }
72 
73     function approve(address _spender, uint256 _value) on returns (bool success) {
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     function allowance(address _owner, address _spender) on constant returns (uint256 remaining) {
80         return allowed[_owner][_spender];
81     }
82 
83     mapping (address => uint256) balances;
84     mapping (address => mapping (address => uint256)) allowed;
85 }
86 
87 
88 
89 contract TurboPayToken is StandardToken {
90     string public name = "TurboPayToken";
91     uint8 public decimals = 18;
92     string public symbol = "TBP";
93     bool private init =true;
94     function turnon() controller {
95         status = true;
96     }
97     function turnoff() controller {
98         status = false;
99     }
100     function TurboPayToken() {
101         require(init==true);
102         totalSupply = 120000000*10**18;
103         balances[0x2e127CE2293Fb11263F3cf5C5F3E5Da68A77bDEB] = totalSupply;
104         init = false;
105     }
106     address public controllerAdd = 0x2e127CE2293Fb11263F3cf5C5F3E5Da68A77bDEB;
107 
108     modifier controller () {
109         require(msg.sender == controllerAdd);
110         _;
111     }
112 }