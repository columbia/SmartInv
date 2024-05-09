1 pragma solidity ^0.4.8;
2 
3 contract SafeMath {
4 
5     function assert(bool assertion) internal {
6         if (!assertion) {
7             throw;
8         }
9     }
10 
11     function safeAddCheck(uint256 x, uint256 y) internal returns(bool) {
12       uint256 z = x + y;
13       if ((z >= x) && (z >= y)) {
14           return true;
15       }
16     }
17 
18     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
19         uint256 z = x * y;
20         assert((x == 0)||(z/x == y));
21         return z;
22     }
23 
24 }
25 
26 contract Token {
27     uint256 public totalSupply;
28     function balanceOf(address _owner) constant returns (uint256 balance);
29     function transfer(address _to, uint256 _value) returns (bool success);
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
31     function approve(address _spender, uint256 _value) returns (bool success);
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 }
36 
37 
38 /*  ERC 20 token */
39 contract LeeroyPoints is Token, SafeMath {
40     address public owner;
41     mapping (address => bool) public controllers;
42 
43     string public constant name = "Leeroy Points";
44     string public constant symbol = "LRP";
45     uint256 public constant decimals = 18;
46     string public version = "1.0";
47     uint256 public constant baseUnit = 1 * 10**decimals;
48 
49     event CreateLRP(address indexed _to, uint256 _value);
50 
51     function LeeroyPoints() {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner { if (msg.sender != owner) throw; _; }
56 
57     modifier onlyController { if (controllers[msg.sender] == false) throw; _; }
58 
59     function enableController(address controller) onlyOwner {
60         controllers[controller] = true;
61     }
62 
63     function disableController(address controller) onlyOwner {
64         controllers[controller] = false;
65     }
66 
67     function create(uint num, address targetAddress) onlyController {
68         uint points = safeMult(num, baseUnit);
69         // use bool instead of assert, controller can run indefinitely
70         // regardless of totalSupply
71         bool checked = safeAddCheck(totalSupply, points);
72         if (checked) {
73             totalSupply = totalSupply + points;
74             balances[targetAddress] += points;
75             CreateLRP(targetAddress, points);
76         }
77    }
78 
79     function transfer(address _to, uint256 _value) returns (bool success) {
80       if (balances[msg.sender] >= _value && _value > 0) {
81         balances[msg.sender] -= _value;
82         balances[_to] += _value;
83         Transfer(msg.sender, _to, _value);
84         return true;
85       } else {
86         return false;
87       }
88     }
89 
90     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
91       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
92         balances[_to] += _value;
93         balances[_from] -= _value;
94         allowed[_from][msg.sender] -= _value;
95         Transfer(_from, _to, _value);
96         return true;
97       } else {
98         return false;
99       }
100     }
101 
102     function balanceOf(address _owner) constant returns (uint256 balance) {
103         return balances[_owner];
104     }
105 
106     function approve(address _spender, uint256 _value) returns (bool success) {
107         allowed[msg.sender][_spender] = _value;
108         Approval(msg.sender, _spender, _value);
109         return true;
110     }
111 
112     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
113       return allowed[_owner][_spender];
114     }
115 
116     mapping (address => uint256) balances;
117     mapping (address => mapping (address => uint256)) allowed;
118 }