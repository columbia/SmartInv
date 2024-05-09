1 pragma solidity ^0.4.16;
2 contract Token {
3 
4 
5  /** PUMPANOMICS
6  PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
7   PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
8      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
9      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
10               PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
11      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
12      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
13     
14       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
15      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
16      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
17     
18       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
19      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
20      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
21     
22       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
23      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
24      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
25     
26       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
27      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
28      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
29      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
30  **/
31     function totalSupply() constant returns (uint256 supply) {}
32 
33 
34     function balanceOf(address _owner) constant returns (uint256 balance) {}
35 
36    
37     function transfer(address _to, uint256 _value) returns (bool success) {}
38 
39     
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
41 
42   
43     function approve(address _spender, uint256 _value) returns (bool success) {}
44 
45   
46     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
47 
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50     
51 }
52 
53  /** PUMPANOMICS
54  PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
55   PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
56      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
57      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
58               PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
59      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
60      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
61     
62       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
63      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
64      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
65     
66       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
67      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
68      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
69     
70       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
71      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
72      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
73     
74       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
75      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
76      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
77      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
78  **/
79 
80 contract StandardToken is Token {
81 
82     function transfer(address _to, uint256 _value) returns (bool success) {
83      
84         if (balances[msg.sender] >= _value && _value > 0) {
85             balances[msg.sender] -= _value;
86             balances[_to] += _value;
87             Transfer(msg.sender, _to, _value);
88             return true;
89         } else { return false; }
90     }
91 
92     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
93       
94         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
95             balances[_to] += _value;
96             balances[_from] -= _value;
97             allowed[_from][msg.sender] -= _value;
98             Transfer(_from, _to, _value);
99             return true;
100         } else { return false; }
101     }
102  /** PUMPANOMICS
103  PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
104   PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
105      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
106      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
107               PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
108      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
109      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
110     
111       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
112      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
113      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
114     
115       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
116      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
117      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
118     
119       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
120      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
121      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
122     
123       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
124      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
125      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
126      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
127  **/
128     function balanceOf(address _owner) constant returns (uint256 balance) {
129         return balances[_owner];
130     }
131 
132     function approve(address _spender, uint256 _value) returns (bool success) {
133         allowed[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135         return true;
136     }
137 
138     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
139       return allowed[_owner][_spender];
140     }
141 
142     mapping (address => uint256) balances;
143     mapping (address => mapping (address => uint256)) allowed;
144     uint256 public totalSupply;
145 }
146 
147  /** PUMPANOMICS
148  PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
149   PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
150      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
151      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
152               PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
153      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
154      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
155     
156       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
157      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
158      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
159     
160       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
161      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
162      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
163     
164       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
165      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
166      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
167     
168       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
169      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
170      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
171      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
172  **/
173 
174 contract Pump is StandardToken {
175 
176     function () {
177         throw;
178     }
179 
180  
181     string public name;                   
182     uint8 public decimals;                
183     string public symbol;                 
184     string public version = 'H1.0';       
185 
186  /** PUMPANOMICS
187  PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
188   PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
189      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
190      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
191               PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
192      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
193      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
194     
195       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
196      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
197      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
198     
199       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
200      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
201      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
202     
203       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
204      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
205      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
206     
207       PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
208      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
209      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
210      PUMP PUMP PUMP PUMP PUMP PUMP PUMP PUMP
211  **/
212 
213 
214     function Pump(
215         ) {
216         balances[msg.sender] = 1000000000000000000;              
217         totalSupply = 1000000000000000000;                        
218         name = "PUMPANOMICS";                                   
219         decimals = 18;                            
220         symbol = "PUMP";                               
221     }
222 
223     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
224         allowed[msg.sender][_spender] = _value;
225         Approval(msg.sender, _spender, _value);
226 
227        
228         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
229         return true;
230     }
231 }