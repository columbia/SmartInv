1 pragma solidity ^0.4.19;
2 
3 contract SafeMath {
4 
5 function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
6 uint256 z = x + y;
7       assert((z >= x) && (z >= y));
8       return z;
9     }
10 
11     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
12       assert(x >= y);
13       uint256 z = x - y;
14       return z;
15     }
16 
17     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
18       uint256 z = x * y;
19       assert((x == 0)||(z/x == y));
20       return z;
21     }
22 
23 }
24 
25 contract ERC20 {
26     uint256 public totalSupply;
27     function balanceOf(address _owner) constant returns (uint256 balance);
28     function transfer(address _to, uint256 _value) returns (bool success);
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
30     function approve(address _spender, uint256 _value) returns (bool success);
31     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35 
36 
37 /*  ERC 20 token */
38 contract StandardToken is ERC20 {
39 
40     function transfer(address _to, uint256 _value) returns (bool success) {
41       if (balances[msg.sender] >= _value && _value > 0) {
42         balances[msg.sender] -= _value;
43         balances[_to] += _value;
44         Transfer(msg.sender, _to, _value);
45         return true;
46       } else {
47         return false;
48       }
49     }
50 
51     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
52       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
53         balances[_to] += _value;
54         balances[_from] -= _value;
55         allowed[_from][msg.sender] -= _value;
56         Transfer(_from, _to, _value);
57         return true;
58       } else {
59         return false;
60       }
61     }
62 
63     function balanceOf(address _owner) constant returns (uint256 balance) {
64         return balances[_owner];
65     }
66 
67     function approve(address _spender, uint256 _value) returns (bool success) {
68         allowed[msg.sender][_spender] = _value;
69         Approval(msg.sender, _spender, _value);
70         return true;
71     }
72 
73     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
74       return allowed[_owner][_spender];
75     }
76 
77     mapping (address => uint256) balances;
78     mapping (address => mapping (address => uint256)) allowed;
79 }
80 
81 contract UnicornCoin is StandardToken, SafeMath {
82 
83     // metadata
84     uint256 public totalSupply;
85     string public constant name = "Unicorn Coin";
86     string public constant symbol = "UCC";
87     uint256 public constant decimals = 18;
88     string public version = "1.0";
89     
90     /* 1ETH = 500 UCC */
91     uint256 public constant rate= 500;
92     address public owner;
93     uint256 public totalEth;
94     
95     function UnicornCoin(){
96         balances[msg.sender] = 30000000000000000000000000;
97         totalSupply = 30000000000000000000000000;
98         owner = msg.sender;
99     }
100     
101     function () payable {
102         sendTokens();
103     }
104     
105     function sendTokens() payable {
106         require(msg.value > 0);
107         totalEth = safeAdd(totalEth, msg.value);
108         uint256 tokens = safeMult(msg.value, rate);
109         
110         if (balances[owner] < tokens) {
111             return;
112         }
113 
114         balances[owner] = safeSubtract(balances[owner], tokens);
115         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
116 
117         Transfer(owner, msg.sender, tokens); 
118 
119         owner.transfer(msg.value);    
120         
121     }
122 }