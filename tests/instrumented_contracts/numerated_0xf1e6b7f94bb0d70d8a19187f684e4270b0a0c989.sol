1 /*
2 This Contract is free software: you can redistribute it and/or
3 modify it under the terms of the GNU lesser General Public License as published
4 by the Free Software Foundation, either version 3 of the License, or
5 (at your option) any later version.
6 This Contract is distributed WITHOUT ANY WARRANTY; without even the implied warranty of
7 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
8 GNU lesser General Public License for more details.
9 You should have received a copy of the GNU lesser General Public License
10 <http://www.gnu.org/licenses/>.
11 */
12 
13 pragma solidity ^0.4.18;
14 
15 contract ERC20TokenCPN
16 {
17 
18 ///PARAMETRS///
19 
20     ///ERC20 PARAMETRS///
21     
22     string public constant name = "STAR COUPON";
23     string public constant symbol = "CPN";
24     uint8 public constant decimals = 0;
25     
26     ///*ERC20 PARAMETRS///
27 
28     address public regulator;
29     uint8 public regulatorStatus; /* 0 - stop; 1 - start; 2 - constant regulator and constant status 'start'; */
30     uint internal amount;
31 
32     struct agent
33     {
34         uint balance;
35         mapping (address => uint) allowed;
36         uint8 permission; /* 0 - user; 1 - changeAgentPermission () / changeRegulator () / changeRegulatoryStatus (); 2 - changeRegulatoryStatus () '2'; 3 - destroy; */
37     }
38     mapping (address => agent) internal agents;
39 
40 ///*PARAMETRS///
41 
42 ///EVENTS///
43     
44     ///ERC20 EVENTS///
45 
46     event Transfer (address indexed _from, address indexed _to, uint _value);
47     event Approval (address indexed _owner, address indexed _spender, uint _value);
48 
49     ///*ERC20 EVENTS///
50 
51     event Management (address indexed _called, uint8 _function, address indexed _dataA, uint8 dataB);
52     event Mint (address indexed _called, address indexed _to, uint _value);
53     event Burn (address indexed called, address indexed _to, uint _value);
54 
55 ///EVENTS///
56 
57 ///FUNCTIONS///
58 
59     function ERC20TokenCPN ()
60     {
61         agents[msg.sender].permission = 1;
62         changeRegulator(msg.sender);
63         changeRegulatorStatus(1);
64         mint (msg.sender, 100000);
65         changeRegulatorStatus(0);
66     }
67 
68     function changeAgentPermission (address _agent, uint8 _permission) public returns (bool success)
69     {
70         if (regulatorStatus != 2)
71         {
72             if ((agents[msg.sender].permission == 1) && (_permission >= 0 && _permission <= 3) && (msg.sender != _agent))
73             {
74                 agents[_agent].permission = _permission;
75                 Management (msg.sender, 1, _agent, _permission);
76                 return true;
77             }
78         }
79         return false;
80     }
81     
82     function changeRegulator (address _regulator) public returns (bool success)
83     {
84         if (regulatorStatus != 2)
85         {
86             if (agents[msg.sender].permission == 1)
87             {
88                 regulator = _regulator;
89                 Management (msg.sender, 2, _regulator, 0);
90                 return true;
91             }
92         }
93         return false;
94     }
95     
96     function changeRegulatorStatus (uint8 _status) public returns (bool success)
97     {
98         if (regulatorStatus != 2)
99         {
100             if (((agents[msg.sender].permission == 1) && (_status == 0 || _status == 1)) || ((agents[msg.sender].permission == 2) && (_status == 2)))
101             {
102                 regulatorStatus = _status;
103                 Management (msg.sender, 3, regulator, _status);
104                 return true;
105             }
106         }
107         return false;
108     }
109     
110     function destroy (address _to) public
111     {
112         if ((agents[msg.sender].permission == 3) && (regulatorStatus != 2))
113         {
114             selfdestruct(_to);
115         }
116     }
117     
118     function agentPermission (address _agent) public constant returns (uint8 permission)
119     {
120         return agents[_agent].permission;
121     }
122 
123     function mint (address _to, uint _value) public returns (bool success)
124     {
125         if ((msg.sender == regulator) && (regulatorStatus == 1 || regulatorStatus == 2) && (amount + _value > amount))
126         {
127             amount += _value;
128             agents[msg.sender].balance += _value;
129             transfer (_to, _value);
130             Mint (msg.sender, _to, _value);
131             return true;
132         }
133         return false;
134     }
135 
136     function burn (address _to, uint _value) public returns (bool success)
137     {
138         if ((msg.sender == regulator) && (regulatorStatus == 1 || regulatorStatus == 2) && (agents[_to].balance >= _value))
139         {
140             Transfer (_to, msg.sender, _value);
141             agents[_to].balance -= _value;
142             amount -= _value;
143             Burn (msg.sender, _to, _value);
144             return true;
145         }
146         return false;
147     }
148 
149     ///ERC20 FUNCTIONS///
150 
151     function totalSupply () public constant returns (uint)
152     {
153         return amount;
154     }
155 
156     function balanceOf (address _owner) public constant returns (uint balance)
157     {
158         return agents[_owner].balance;
159     }
160 
161     function transfer (address _to, uint _value) public returns (bool success)
162     {
163         if (agents[msg.sender].balance >= _value && agents[_to].balance + _value >= agents[_to].balance)
164         {
165             agents[msg.sender].balance -= _value; 
166             agents[_to].balance += _value;
167             Transfer (msg.sender, _to, _value);
168             return true;
169         } 
170         return false;
171     }
172     
173     function transferFrom (address _from, address _to, uint _value) public returns (bool success)
174     {
175         if (agents[_from].allowed[msg.sender] >= _value && agents[_from].balance >= _value && agents[_to].balance + _value >= agents[_to].balance)
176         {
177             agents[_from].allowed[msg.sender] -= _value;
178             agents[_from].balance -= _value; 
179             agents[_to].balance += _value;
180             Transfer (_from, _to, _value);
181             return true;
182         } 
183         return false;
184     }
185 
186     function approve (address _spender, uint _value) public returns (bool success)
187     {
188         if (_value > 0)
189         {
190             agents[msg.sender].allowed[_spender] = _value;
191             Approval (msg.sender, _spender, _value);
192             return true;
193         }
194         return false;
195     }
196 
197     function allowance (address _owner, address _spender) public constant returns (uint remaining)
198     {
199         return agents[_owner].allowed[_spender];
200     }
201 
202     ///*ERC20 FUNCTIONS///
203 
204 ///FUNCTIONS///
205 
206 }