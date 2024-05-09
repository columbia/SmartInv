1 pragma solidity ^0.4.11;
2 
3 
4 
5 contract Token 
6 {
7 
8     
9     function totalSupply() constant returns (uint256 ) {
10       return;
11     }
12 
13     
14     
15     function balanceOf(address ) constant returns (uint256 ) {
16       return;
17     }
18 
19     
20     
21     
22     
23     function transfer(address , uint256 ) returns (bool ) {
24       return;
25     }
26 
27     
28     
29     
30     
31     
32     function transferFrom(address , address , uint256 ) returns (bool ) {
33       return;
34     }
35 
36     
37     
38     
39     
40     function approve(address , uint256 ) returns (bool ) {
41       return;
42     }
43 
44     
45     
46     
47     function allowance(address , address ) constant returns (uint256 ) {
48       return;
49     }
50 
51 
52     event Transfer(address indexed , address indexed , uint256 );
53     event Approval(address indexed , address indexed , uint256 );
54 }
55 
56 contract StdToken is Token 
57 {
58 
59      mapping(address => uint256) balances;
60      mapping (address => mapping (address => uint256)) allowed;
61 
62      uint256 public allSupply = 0;
63 
64 
65      function transfer(address _to, uint256 _value) returns (bool success) 
66      {
67           if((balances[msg.sender] >= _value) && (balances[_to] + _value > balances[_to])) 
68           {
69                balances[msg.sender] -= _value;
70                balances[_to] += _value;
71 
72                Transfer(msg.sender, _to, _value);
73                return true;
74           } 
75           else 
76           { 
77                return false; 
78           }
79      }
80 
81      function transferFrom(address _from, address _to, uint256 _value) returns (bool success) 
82      {
83           if((balances[_from] >= _value) && (allowed[_from][msg.sender] >= _value) && (balances[_to] + _value > balances[_to])) 
84           {
85                balances[_to] += _value;
86                balances[_from] -= _value;
87                allowed[_from][msg.sender] -= _value;
88 
89                Transfer(_from, _to, _value);
90                return true;
91           } 
92           else 
93           { 
94                return false; 
95           }
96      }
97 
98      function balanceOf(address _owner) constant returns (uint256 balance) 
99      {
100           return balances[_owner];
101      }
102 
103      function approve(address _spender, uint256 _value) returns (bool success) 
104      {
105           allowed[msg.sender][_spender] = _value;
106           Approval(msg.sender, _spender, _value);
107 
108           return true;
109      }
110 
111      function allowance(address _owner, address _spender) constant returns (uint256 remaining) 
112      {
113           return allowed[_owner][_spender];
114      }
115 
116      function totalSupply() constant returns (uint256 supplyOut) 
117      {
118           supplyOut = allSupply;
119           return;
120      }
121 }
122 
123 contract ReputationToken is StdToken {
124      string public name = "EthlendReputationToken";
125      uint public decimals = 18;
126      string public symbol = "CRE";
127 
128      address public creator = 0x0;
129 
130      function ReputationToken(){
131           creator = msg.sender;
132      }
133 
134      function changeCreator(address newCreator){
135           if(msg.sender!=creator)throw;
136 
137           creator = newCreator;
138      }
139 
140      function issueTokens(address forAddress, uint tokenCount) returns (bool success){
141           if(msg.sender!=creator)throw;
142           
143           if(tokenCount==0) {
144                success = false;
145                return ;
146           }
147 
148           balances[forAddress]+=tokenCount;
149           allSupply+=tokenCount;
150 
151           success = true;
152           return;
153      }
154 }