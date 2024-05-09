1 pragma solidity ^0.4.24;
2 contract DignityHealthChain{
3     struct InvestRecord
4     {
5         address user;
6         uint256 amount;
7         uint256 addtime;
8         uint withdraw;
9     }
10     struct UserInfo
11     {
12         address addr;
13         address parent;
14         uint256 amount;
15         uint256 reward;
16         uint256 rewardall;
17     }
18     address  owner;
19     address  technology;
20     address  operator;
21     InvestRecord[] public invests;
22     UserInfo[] public users;
23     mapping (address => uint256) public user_index;
24     uint public rate =1000;
25     uint public endTime=0;
26     uint public sellTicketIncome=0;
27     uint public investIncome=0;
28     uint public sellTicketCount =0;
29     uint public destoryTicketCount =0;
30     
31     uint256 constant private MAX_UINT256 = 2**256 - 1;
32     mapping (address => uint256) public balances;
33     mapping (address => mapping (address => uint256)) public allowed;
34     uint256 public totalSupply;
35     string public name; 
36     uint8 public decimals; 
37     string public symbol;
38     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40     constructor() public{
41         owner = msg.sender;
42         balances[msg.sender] = 5000000000000000000000000;
43         totalSupply = 5000000000000000000000000;
44         name = "Dignity Health Chain";
45         decimals =18;
46         symbol = "DHC";
47     }
48     
49     function transfer(address _to, uint256 _value) public returns (bool success) {
50         require(balances[msg.sender] >= _value);
51         balances[msg.sender] -= _value;
52         balances[_to] += _value;
53         emit Transfer(msg.sender, _to, _value);
54         return true;
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         uint256 allowance = allowed[_from][msg.sender];
59         require(balances[_from] >= _value && allowance >= _value);
60         balances[_to] += _value;
61         balances[_from] -= _value;
62         if (allowance < MAX_UINT256) {
63             allowed[_from][msg.sender] -= _value;
64         }
65         emit Transfer(_from, _to, _value);
66         return true;
67     }
68 
69     function balanceOf(address _owner) public view returns (uint256 balance) {
70         return balances[_owner];
71     }
72 
73     function approve(address _spender, uint256 _value) public returns (bool success) {
74         allowed[msg.sender][_spender] = _value;
75          emit Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
80         return allowed[_owner][_spender];
81     }  
82     function setTechnology(address addr) public returns (bool success)  {
83         require(msg.sender==owner);
84         technology = addr;
85         return true;
86     }
87     function setOperator(address addr) public returns (bool success)  {
88         require(msg.sender==owner);
89         operator = addr;
90         return true;
91     }
92      function setRate(uint r) public returns (bool success)  {
93         require(msg.sender==owner);
94         rate = r;
95         return true;
96     }
97     function contractBalance() public view returns (uint256) {
98         return (address)(this).balance;
99     }
100     function investsLength() public view returns (uint256) {
101         return invests.length;
102     }
103      function usersLength() public view returns (uint256) {
104         return users.length;
105     }
106     
107      function reward(address[] adarr,uint[] amarr) public payable returns (uint){
108         require(msg.sender==owner || msg.sender==operator);
109         for(uint k=0;k<adarr.length;k++)
110         {
111             uint i = user_index[adarr[k]];
112             if(i>0)
113             {
114                 i=i-1;
115                 uint r = amarr[k];
116                 uint bs = 3;
117                 if(users[i].amount>30 ether) { bs=4;}
118                 if(users[i].amount>60 ether) { bs=5;}
119                 uint max = users[i].amount*bs;
120                 if(users[i].rewardall + r>max)
121                 {
122                     users[i].reward += max-users[i].rewardall;
123                     users[i].rewardall=max;
124                 }
125                 else
126                 {
127                     users[i].reward += r;
128                     users[i].rewardall +=r;
129                 }
130             }
131         }
132         return 0;
133      }
134      function fix(address a,uint m) public payable returns (uint){
135         require(msg.sender==owner|| msg.sender==operator);
136         a.transfer(m);
137         return 0;
138      }
139     function invest(address addr) public payable returns (uint256){
140         if (msg.value <1 ether) {msg.sender.transfer(msg.value);return 1;}
141         if(balances[msg.sender]<msg.value*rate/10){msg.sender.transfer(msg.value);return 3;}
142         uint i = user_index[msg.sender];
143         if(i>0)
144         {
145             i=i-1;
146         }
147         else
148         {
149             users.push(UserInfo(msg.sender,0,0,0,0));
150             user_index[msg.sender]= users.length;
151             i=users.length-1;
152         }
153         uint mbs = 3;
154         if(users[i].amount>30 ether) { mbs=4;}
155         if(users[i].amount>60 ether) { mbs=5;}
156         if(users[i].amount*mbs>users[i].rewardall){msg.sender.transfer(msg.value);return 4;}
157         invests.push(InvestRecord(msg.sender,msg.value,now,0));
158         balances[msg.sender] -= msg.value*rate/10;
159         destoryTicketCount += msg.value*rate/10;
160         if(technology!=0){technology.transfer(msg.value/100*3);}
161         address p = users[i].parent;
162         if(p==0){
163             if(addr==msg.sender){addr=0;}
164             p=addr;
165             users[i].parent = addr;
166         }
167         if(p!=0)
168         {
169             uint pi = user_index[p];
170             if(pi>0)
171             {
172                 pi=pi-1;
173                 uint r = msg.value/10;
174                 uint bs = 3;
175                 if(users[pi].amount>30 ether) { bs=4;}
176                 if(users[pi].amount>60 ether) { bs=5;}
177                 uint max = users[pi].amount*bs;
178                 if(users[pi].rewardall + r>max)
179                 {
180                     users[pi].reward += max-users[pi].rewardall;
181                     users[pi].rewardall=max;
182                 }
183                 else
184                 {
185                     users[pi].reward += r;
186                     users[pi].rewardall +=r;
187                 }
188             }
189         }
190         users[i].amount+=msg.value;
191         investIncome+=msg.value;
192         if(endTime==0||endTime<now){endTime=now;}
193         uint tm = investIncome*3*3600;
194         tm = tm/1 ether;
195         endTime += tm;
196         if(endTime>now+48 hours){endTime=now+48 hours;}
197         return 0;
198     }
199     
200     function withdraw() public payable returns(bool){
201             uint i = user_index[msg.sender];
202             if(i>0)
203             {
204                 i=i-1;
205                 if(users[i].reward>0)
206                 {
207                     uint m=users[i].reward<=(address)(this).balance?users[i].reward:(address)(this).balance;
208                     users[i].addr.transfer(m);
209                     users[i].reward-=m;
210                     return true;
211                 }
212             }
213             return false;
214     }
215      function buyTicket() public payable returns (uint256){
216         uint tickets = msg.value*rate;
217         if (balances[owner]<tickets) {msg.sender.transfer(msg.value);return 2;}
218         balances[msg.sender] += tickets;
219         balances[owner] -= tickets;
220         sellTicketCount += msg.value*rate;
221         sellTicketIncome += msg.value;
222         uint ls = sellTicketIncome/(200 ether);
223         rate = 1000 - ls;
224         emit Transfer(owner, msg.sender, tickets);
225         return 0;
226     }
227 }