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
54 contract StandardToken is Token, Owned {
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
66     mapping (address => bool) public frozenAccount;
67     event FrozenFunds(address target, bool frozen);
68     
69     function freezeAccount(address target, bool freeze) onlyOwner {
70         frozenAccount[target] = freeze;
71         FrozenFunds(target, freeze);
72     }
73 
74     function transfer(address _to, uint256 _value) returns (bool success) {
75 
76         require(!locked);
77       
78         require(!frozenAccount[msg.sender]);
79         
80         require(balances[msg.sender] >= _value);
81         
82         require(balances[_to] + _value >= balances[_to]);
83        
84         balances[msg.sender] -= _value;
85         balances[_to] += _value;
86 
87 
88         Transfer(msg.sender, _to, _value);
89         return true;
90     }
91 
92 
93     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
94 
95         require(!locked);
96         
97         require(balances[_from] >= _value);
98         require(!frozenAccount[msg.sender]);
99         require(!frozenAccount[_from]);
100         
101              
102         require(balances[_to] + _value >= balances[_to]);    
103        
104         require(_value <= allowed[_from][msg.sender]);    
105 
106         balances[_to] += _value;
107         balances[_from] -= _value;
108 
109         allowed[_from][msg.sender] -= _value;
110 
111         Transfer(_from, _to, _value);
112         return true;
113     }
114 
115 
116     function approve(address _spender, uint256 _value) returns (bool success) {
117   
118         require(!locked);
119 
120         allowed[msg.sender][_spender] = _value;
121         require(!frozenAccount[msg.sender]);
122         require(!frozenAccount[_spender]);
123 
124         Approval(msg.sender, _spender, _value);
125         return true;
126     }
127 
128 
129     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
130       require(!frozenAccount[_spender]);
131       require(!frozenAccount[_owner]);
132       require(!frozenAccount[msg.sender]);
133       return allowed[_owner][_spender];
134     }
135 }
136 
137 
138 
139 contract StarToken is Owned, StandardToken {
140 
141     string public standard = "Token 0.1";
142 
143     string public name = "StarLight";        
144     
145     string public symbol = "STAR";
146 
147     uint8 public decimals = 8;
148    
149     function StarToken() {  
150         balances[msg.sender] = 0;
151         totalSupply = 0;
152         locked = false;
153     }
154    
155     function unlock() onlyOwner returns (bool success)  {
156         locked = false;
157         return true;
158     }
159     
160     function lock() onlyOwner returns (bool success)  {
161         locked = true;
162         return true;
163     }
164     
165     
166 
167     function issue(address _recipient, uint256 _value) onlyICO returns (bool success) {
168 
169         require(_value >= 0);
170 
171         balances[_recipient] += _value;
172         totalSupply += _value;
173 
174         Transfer(0, owner, _value);
175         Transfer(owner, _recipient, _value);
176 
177         return true;
178     }
179    
180     function () {
181         throw;
182     }
183 }