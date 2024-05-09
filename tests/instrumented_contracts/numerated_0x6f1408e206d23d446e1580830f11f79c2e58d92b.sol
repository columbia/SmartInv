1 pragma solidity ^0.4.11;
2  
3 contract NRMc {
4     string public symbol = "NRMc";
5     string public name = "NRMc Closed ICO";
6     uint8 public constant decimals = 18;
7     uint256 _totalSupply = 20000000000000000000000000;
8     uint256 perReserve   =  2000000000000000000000000;
9     bool startDone = false;
10     bool finishDone = false;
11     bool onefiveDone = false;
12     address owner = 0;
13     address reserve1 = 0x0d4dAA952a8840715d901f97EDb98973Ce8010F7;
14     address reserve2 = 0xCd4846fF42C1DCe3E421cb4fE8d01523B962D641;
15     address reserve3 = 0x2241C99B6f44Cc630a073703EdFDf3c9964CbE22;
16     address reserve4 = 0x5c5bfC25A0B99ac5F974927F1f6D39f19Af9D14C;
17     address reserve5 = 0xa8356f49640093cec3dCd6dcE1ff4Dfe3785c17c;
18     bool prereserved1Done = false;
19     bool prereserved2Done = false;
20     bool prereserved3Done = false;
21     bool prereserved4Done = false;
22     bool prereserved5Done = false;
23     address out1 = 0xF9D23f5d833dB355bfc870c8aCD9f4fc7EF05883;
24     address out2 = 0x5c07f5DD4d3eE06A977Dee53072e10de9414E3f0;
25     address out3 = 0xF425821a2545cF1414B6E342ff5D95f3c572a7CD;
26     address out4 = 0xa873134afa83410787Ae29dBfB39e5C38ca05fF2;
27     address out5 = 0x5E663D73de8205b3f339fAA5a4218AcA95963260;
28     bool public out1Done = false;
29     bool public out2Done = false;
30     bool public out3Done = false;
31     bool public out4Done = false;
32     bool public out5Done = false;
33     uint public amountRaised;
34     uint public deadline;
35     uint public overRaisedUnsend = 0;
36     uint public backers = 0;
37     uint public rate = 45000;
38     uint public onefive = 0;
39     uint _durationInMinutes = 0;
40     mapping(address => uint256) public balanceOf;
41     
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 
45     mapping(address => uint256) balances;
46  
47     mapping(address => mapping (address => uint256)) allowed;
48  
49     function NRMc(address adr) {
50         if (startDone == false) {
51         owner = adr;        
52         }
53     }
54     
55     function StartICO(uint256 durationInMinutes) {
56         if (msg.sender == owner 
57         && startDone == false)
58         {
59             balances[owner] = _totalSupply;
60             _durationInMinutes = durationInMinutes;
61             deadline = now + durationInMinutes * 1 minutes;
62             startDone = true;
63         }
64     }
65     
66     function SendPreReserved1() {
67             if (msg.sender == owner 
68             && prereserved1Done == false
69             && balances[owner] >= perReserve
70             && balances[reserve1] + perReserve > balances[reserve1]
71             && now <= deadline
72             && !finishDone 
73             && startDone) 
74             {
75                 balances[owner] -= perReserve;
76                 balances[reserve1] += perReserve;
77                 Transfer(owner, reserve1, perReserve);
78                 prereserved1Done = true;
79                 backers += 1; 
80             }
81     }       
82     
83     function SendPreReserved2() {
84             if (msg.sender == owner 
85             && prereserved2Done == false
86             && balances[owner] >= perReserve
87             && balances[reserve2] + perReserve > balances[reserve2]
88             && now <= deadline
89             && !finishDone 
90             && startDone) 
91             {
92                 balances[owner] -= perReserve;
93                 balances[reserve2] += perReserve;
94                 Transfer(owner, reserve2, perReserve);
95                 prereserved2Done = true;
96                 backers += 1; 
97             }
98     }       
99 
100     function SendPreReserved3() {
101             if (msg.sender == owner 
102             && prereserved3Done == false
103             && balances[owner] >= perReserve
104             && balances[reserve3] + perReserve > balances[reserve3]
105             && now <= deadline
106             && !finishDone 
107             && startDone) 
108             {
109                 balances[owner] -= perReserve;
110                 balances[reserve3] += perReserve;
111                 Transfer(owner, reserve3, perReserve);
112                 prereserved3Done = true;
113                 backers += 1; 
114             }
115     }       
116     
117     function SendPreReserved4() {
118             if (msg.sender == owner 
119             && prereserved4Done == false
120             && balances[owner] >= perReserve
121             && balances[reserve4] + perReserve > balances[reserve4]
122             && now <= deadline
123             && !finishDone 
124             && startDone) 
125             {
126                 balances[owner] -= perReserve;
127                 balances[reserve4] += perReserve;
128                 Transfer(owner, reserve4, perReserve);
129                 prereserved4Done = true;
130                 backers += 1; 
131             }
132     }       
133     
134     function SendPreReserved5() {
135             if (msg.sender == owner 
136             && prereserved5Done == false
137             && balances[owner] >= perReserve
138             && balances[reserve5] + perReserve > balances[reserve5]
139             && now <= deadline
140             && !finishDone 
141             && startDone) 
142             {
143                 balances[owner] -= perReserve;
144                 balances[reserve5] += perReserve;
145                 Transfer(owner, reserve5, perReserve);
146                 prereserved5Done = true;
147                 backers += 1; 
148             }
149     }       
150  
151     function totalSupply() constant returns (uint256 totalSupply) {        
152         return _totalSupply;
153     }
154  
155     function balanceOf(address _owner) constant returns (uint256 balance) {
156         return balances[_owner];
157     }
158  
159     function transfer(address _to, uint256 _amount) returns (bool success) {
160         if (balances[msg.sender] >= _amount 
161             && _amount > 0
162             && balances[_to] + _amount > balances[_to]) {
163             balances[msg.sender] -= _amount;
164             balances[_to] += _amount;
165             Transfer(msg.sender, _to, _amount);
166             return true;
167         } else {
168             return false;
169         }
170     }
171  
172     function transferFrom(
173         address _from,
174         address _to,
175         uint256 _amount
176     ) returns (bool success) {
177         if (balances[_from] >= _amount
178             && allowed[_from][msg.sender] >= _amount
179             && _amount > 0
180             && balances[_to] + _amount > balances[_to]) {
181             balances[_from] -= _amount;
182             allowed[_from][msg.sender] -= _amount;
183             balances[_to] += _amount;
184             Transfer(_from, _to, _amount);
185             return true;
186         } else {
187             return false;
188         }
189     }
190     
191     function () payable {
192         uint _amount = msg.value * rate;
193         uint amount = msg.value;
194         if (balances[owner] >= _amount
195             && _amount > 0
196             && balances[msg.sender] + _amount > balances[msg.sender]
197             && now <= deadline
198             && !finishDone 
199             && startDone) {
200         backers += 1;
201         balances[msg.sender] += _amount;
202         balances[owner] -= _amount;
203         amountRaised += amount;
204         Transfer(owner, msg.sender, _amount);
205         } else {
206             if (!msg.sender.send(amount)) {
207                 overRaisedUnsend += amount; 
208             }
209         }
210     }
211  
212     function approve(address _spender, uint256 _amount) returns (bool success) {
213         allowed[msg.sender][_spender] = _amount;
214         Approval(msg.sender, _spender, _amount);
215         return true;
216     }
217  
218     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
219         return allowed[_owner][_spender];
220     }
221     
222     modifier afterDeadline() { if (now > deadline || balances[owner] == 0) _; }
223 
224     function safeWithdrawal() afterDeadline {
225         
226     if (onefiveDone == false) {
227         onefive = this.balance / 5;
228         onefiveDone = true;
229     }
230 
231     if (out1 == msg.sender && !out1Done) {
232         if (out1.send(onefive)) {
233            out1Done = true;
234         } 
235     }
236         
237     if (out2 == msg.sender && !out2Done) {
238         if (out2.send(onefive)) {
239            out2Done = true;
240         } 
241     }  
242         
243     if (out3 == msg.sender && !out3Done) {
244         if (out3.send(onefive)) {
245            out3Done = true;
246         } 
247     }
248     
249     if (out4 == msg.sender && !out4Done) {
250         if (out4.send(onefive)) {
251            out4Done = true;
252         } 
253     }
254     
255     if (out5 == msg.sender && !out5Done) {
256         if (out5.send(onefive)) {
257            out5Done = true;
258         } 
259     }
260     }
261 }