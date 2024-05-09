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
54 contract StandardToken is Token,Owned {
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
65     mapping (address => bool) public frozenAccount;
66     event FrozenFunds(address target, bool frozen);
67     
68     function freezeAccount(address target, bool freeze) onlyOwner {
69         frozenAccount[target] = freeze;
70         FrozenFunds(target, freeze);
71     }
72 
73     function transfer(address _to, uint256 _value) returns (bool success) {
74 
75         require(!locked);
76         require(!frozenAccount[msg.sender]);
77         
78         require(balances[msg.sender] >= _value);
79         
80         require(balances[_to] + _value >= balances[_to]);
81        
82         balances[msg.sender] -= _value;
83         balances[_to] += _value;
84 
85 
86         Transfer(msg.sender, _to, _value);
87         return true;
88     }
89 
90 
91     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
92 
93         require(!locked);
94         
95         require(balances[_from] >= _value);
96              
97         require(balances[_to] + _value >= balances[_to]);    
98        
99         require(_value <= allowed[_from][msg.sender]);    
100 
101         balances[_to] += _value;
102         balances[_from] -= _value;
103 
104         allowed[_from][msg.sender] -= _value;
105 
106         Transfer(_from, _to, _value);
107         return true;
108     }
109 
110 
111     function approve(address _spender, uint256 _value) returns (bool success) {
112   
113         require(!locked);
114 
115         allowed[msg.sender][_spender] = _value;
116 
117         Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121 
122     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
123       return allowed[_owner][_spender];
124     }
125 }
126 
127 
128 
129 contract FccToken is Owned, StandardToken {
130 
131     string public standard = "Token 0.2";
132 
133     string public name = "First Capital Coin";        
134     
135     string public symbol = "FCC";
136 
137     uint8 public decimals = 8;
138    
139     function FccToken() {  
140         balances[msg.sender] = 500000000* 10**8;
141         totalSupply = 500000000* 10**8;
142         locked = false;
143     }
144    
145     function unlock() onlyOwner returns (bool success)  {
146         locked = false;
147         return true;
148     }
149     
150     function lock() onlyOwner returns (bool success)  {
151         locked = true;
152         return true;
153     }
154     
155     
156 
157     function issue(address _recipient, uint256 _value) onlyICO returns (bool success) {
158 
159         require(_value >= 0);
160 
161         balances[_recipient] += _value;
162         totalSupply += _value;
163 
164         Transfer(0, owner, _value);
165         Transfer(owner, _recipient, _value);
166 
167         return true;
168     }
169    
170     function () {
171         throw;
172     }
173 }