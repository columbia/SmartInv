1 pragma solidity ^0.4.16;
2 
3 contract Owned {
4 
5     
6     address public owner;
7     address public ico;
8 
9     function Owned() {
10         owner = msg.sender;
11         ico = msg.sender;
12     }
13 
14     modifier onlyOwner() {
15         
16         require(msg.sender == owner);
17         _;
18     }
19     
20     modifier onlyICO() {
21         
22         require(msg.sender == ico);
23         _;
24     }
25 
26     function transferOwnership(address _newOwner) onlyOwner {
27         owner = _newOwner;
28     }
29     function transferIcoship(address _newIco) onlyOwner {
30         ico = _newIco;
31     }
32 }
33 
34 
35 contract Token {
36     
37     uint256 public totalSupply;
38 
39     function balanceOf(address _owner) constant returns (uint256 balance);
40 
41     function transfer(address _to, uint256 _value) returns (bool success);
42 
43     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
44 
45     function approve(address _spender, uint256 _value) returns (bool success);
46 
47     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
48 
49     event Transfer(address indexed _from, address indexed _to, uint256 _value);
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 }
52 
53 
54 contract StandardToken is Token {
55 
56     bool public locked;
57 
58     mapping (address => uint256) balances;
59 
60     mapping (address => mapping (address => uint256)) allowed;
61     
62     function balanceOf(address _owner) constant returns (uint256 balance) {
63         return balances[_owner];
64     }
65 
66     function transfer(address _to, uint256 _value) returns (bool success) {
67 
68         require(!locked);
69         
70         require(balances[msg.sender] >= _value);
71         
72         require(balances[_to] + _value >= balances[_to]);
73        
74         balances[msg.sender] -= _value;
75         balances[_to] += _value;
76 
77 
78         Transfer(msg.sender, _to, _value);
79         return true;
80     }
81 
82 
83     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
84 
85         require(!locked);
86         
87         require(balances[_from] >= _value);
88              
89         require(balances[_to] + _value >= balances[_to]);    
90        
91         require(_value <= allowed[_from][msg.sender]);    
92 
93         balances[_to] += _value;
94         balances[_from] -= _value;
95 
96         allowed[_from][msg.sender] -= _value;
97 
98         Transfer(_from, _to, _value);
99         return true;
100     }
101 
102 
103     function approve(address _spender, uint256 _value) returns (bool success) {
104   
105         require(!locked);
106 
107         allowed[msg.sender][_spender] = _value;
108 
109         Approval(msg.sender, _spender, _value);
110         return true;
111     }
112 
113 
114     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
115       return allowed[_owner][_spender];
116     }
117 }
118 
119 
120 
121 contract FccToken is Owned, StandardToken {
122 
123     string public standard = "Token 0.1";
124 
125     string public name = "First Cash Coin";        
126     
127     string public symbol = "FCC";
128 
129     uint8 public decimals = 8;
130    
131     function FccToken() {  
132         balances[msg.sender] = 200000000* 10**8;
133         totalSupply = 200000000* 10**8;
134         locked = false;
135     }
136    
137     function unlock() onlyOwner returns (bool success)  {
138         locked = false;
139         return true;
140     }
141     
142     function lock() onlyOwner returns (bool success)  {
143         locked = true;
144         return true;
145     }
146     
147     
148 
149     function issue(address _recipient, uint256 _value) onlyICO returns (bool success) {
150 
151         require(_value >= 0);
152 
153         balances[_recipient] += _value;
154         totalSupply += _value;
155 
156         Transfer(0, owner, _value);
157         Transfer(owner, _recipient, _value);
158 
159         return true;
160     }
161    
162     function () {
163         throw;
164     }
165 }