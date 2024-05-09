1 pragma solidity 0.4.16;
2 
3 contract SafeMath{
4 
5   
6 
7   function safeMul(uint256 a, uint256 b) internal returns (uint256){
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function safeDiv(uint256 a, uint256 b) internal returns (uint256){
17     
18     return a / b;
19   }
20 
21   function safeSub(uint256 a, uint256 b) internal returns (uint256){
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function safeAdd(uint256 a, uint256 b) internal returns (uint256){
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   
33   modifier onlyPayloadSize(uint numWords){
34      assert(msg.data.length >= numWords * 32 + 4);
35      _;
36   }
37 
38 }
39 
40 contract Token{ 
41     
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44     function balanceOf(address _owner) constant returns (uint256 balance);
45     function transfer(address _to, uint256 _value) returns (bool success);
46     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
47     function approve(address _spender, uint256 _value) returns (bool success);
48     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
49 
50 }
51 
52 
53 contract StandardToken is Token, SafeMath{
54 
55 
56 
57     function transfer(address _to, uint256 _value) public returns (bool success){
58         require(_to != address(0));
59         require(balances[msg.sender] >= _value && _value > 0);
60         balances[msg.sender] = safeSub(balances[msg.sender], _value);
61         balances[_to] = safeAdd(balances[_to], _value);
62         Transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) returns (bool success){
67         require(_to != address(0));
68         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
69         balances[_from] = safeSub(balances[_from], _value);
70         balances[_to] = safeAdd(balances[_to], _value);
71         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
72         Transfer(_from, _to, _value);
73         return true;
74     }
75 
76     function balanceOf(address _owner) constant returns (uint256 balance){
77         return balances[_owner];
78     }
79 
80     
81     function approve(address _spender, uint256 _value) onlyPayloadSize(2) returns (bool success){
82         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
83         allowed[msg.sender][_spender] = _value;
84         Approval(msg.sender, _spender, _value);
85         return true;
86     }
87 
88     function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) onlyPayloadSize(3) returns (bool success){
89         require(allowed[msg.sender][_spender] == _oldValue);
90         allowed[msg.sender][_spender] = _newValue;
91         Approval(msg.sender, _spender, _newValue);
92         return true;
93     }
94 
95     function allowance(address _owner, address _spender) constant returns (uint256 remaining){
96         return allowed[_owner][_spender];
97     }
98 
99     
100     mapping (address => uint256) balances;
101     mapping (address => mapping (address => uint256)) allowed;
102 
103 }
104 
105 contract Winsshar is StandardToken {
106 
107     string public name = "Winsshar";
108     string public symbol = "WSR";
109     uint256 public decimals = 6;
110     uint256 public maxSupply = 100000000000;
111     uint256 public totalSupply = 1000000000;
112     uint256 public administrativeSupply = 20000000;
113     address owner;
114     address admin;
115 
116     mapping (uint256 => address) public downloaders;
117     uint256 public numberOfDownloaders;
118 
119     function Winsshar (address administrativeAddress) {
120         numberOfDownloaders=0;
121         owner = msg.sender;
122         balances[owner] = totalSupply;
123         admin = administrativeAddress;
124         balances[administrativeAddress] = administrativeSupply;
125     }
126 
127     modifier checkNumberOfDownloaders {
128         require(numberOfDownloaders <= 1000000);
129         _;
130 
131     }
132 
133     modifier checkOwner {
134       require(owner == msg.sender);
135       _;
136     }
137 
138      modifier checkAdmin {
139       require(admin == msg.sender);
140       _;
141     }
142 
143     function giveReward(address awardee) public checkNumberOfDownloaders checkOwner {
144         require(awardee != address(0));
145         numberOfDownloaders++;
146         downloaders[numberOfDownloaders]=awardee;
147         transfer(awardee,10);
148 
149     }
150 
151     function transferDuringIntialOffer(address to, uint256 tokens) public checkNumberOfDownloaders {
152         require(tokens <= 2000);
153         transfer(to,tokens);
154     }
155 
156     function administrativePayouts(address to, uint tokens) public checkAdmin {
157         require(to != address(0));
158         transfer(to,tokens);
159     }
160 
161     function ownership(address newOwner) public checkOwner {
162         owner = newOwner;
163         balances[owner] = balances[msg.sender];
164         balances[msg.sender] = 0;
165     }
166 
167 
168     function mintTokens(uint256 addSupply) public checkOwner {
169         require(maxSupply-administrativeSupply >= totalSupply+addSupply);
170         totalSupply = safeAdd(totalSupply,addSupply);
171         balances[owner] = safeAdd(balances[owner],addSupply);
172 
173     }
174 
175     function burnTokens(uint256 subSupply) public checkOwner{
176         require(totalSupply-subSupply >= 0);
177         totalSupply = safeSub(totalSupply,subSupply);
178         balances[owner] = safeSub(balances[owner],subSupply);
179 
180     }
181 
182     function() payable {
183         require(tx.origin == msg.sender);
184 
185     }
186 
187 }