1 pragma solidity 0.5.13;
2 contract EtherParadise {
3     struct User{
4         
5         address reddr;
6         
7         uint8 valid;
8         
9         uint bet;
10         
11         uint remcode;
12         
13         uint last_inv;
14     }
15     struct Bet{
16         address addr;
17         address reddr;
18         uint amount;
19         uint remcode;
20         uint time;
21     }
22     
23     mapping(address => User) private Accounts;
24     
25     mapping(uint => Bet) private InvRecord;
26     
27     mapping(uint => uint8) private record;
28     
29     mapping(address => uint8) private Staff;
30     
31     mapping(uint => address) private CodeMapAddr;
32     address private first;
33     
34     uint private IndNum = 100;
35     
36     uint private TeamRate = 5;
37     
38     uint private PoolRate = 5;
39     
40     address Team = 0x574A8008Dc79a058d4B412ceEa5A42030c95e2cb;
41     
42     address Pool = 0x0d33E6a9757ceF0d698b2D0B5b74834977d5147c;
43     
44     address Fund = 0x73A72F8a61875265A84d180e09bd2Bfd637FA9e6;
45     
46     uint8 private IsOnLine = 0;
47     
48     uint private LastT = 0;
49     
50     uint8 private IsRepeat = 0;
51 
52     constructor () public{
53         first = msg.sender;
54     }
55 
56     modifier isfirst{
57         require(msg.sender==first,"not owner");
58         _;
59     }
60 
61     modifier IsStaff{
62         require(msg.sender==first||Staff[msg.sender]==1,"not staff");
63         _;
64     }
65 
66     function() external payable{}
67     function TeamAddr()public view returns(address){return Team;}
68     function PoolAddr()public view returns(address){return Pool;}
69     function FundAddr()public view returns(address){return Fund;}
70     function entry(address reAddr) public payable{
71         require(reAddr!=first&&reAddr!=0x0000000000000000000000000000000000000000,"Invalid address");
72         if(IsRepeat==0){
73             require(Accounts[msg.sender].valid!=1,"Cannot bet repeatedly");
74         }
75         uint  payamount = msg.value;
76         if(Accounts[msg.sender].valid == 0){
77           require(Accounts[reAddr].valid>0&&msg.sender!=reAddr,"Invalid recommended account");
78         }else{
79           require(payamount>=Accounts[msg.sender].last_inv,"The quantity cannot be less than the last quantity");
80         }
81         compute(msg.sender,reAddr,payamount);
82     }
83 
84     function test(address addr,address reAddr,uint payamount) external isfirst {
85         require(IsOnLine==0,"Is on-line");
86         compute(addr,reAddr,payamount);
87     }
88 
89     function compute(address addr,address reAddr,uint payamount) private{
90         require(payamount % 1 ether == 0 && payamount >= 1 ether && payamount <= 13 ether,"Amount error");
91         address nowReAddr = reAddr;
92         LastT = block.timestamp;
93          if(Accounts[addr].valid == 0){
94             Accounts[addr].reddr = reAddr;
95             uint remCode = 666666666*IndNum;
96             CodeMapAddr[remCode] = addr;
97             Accounts[addr].remcode = remCode;
98         }else{
99             nowReAddr = Accounts[addr].reddr;
100         }
101         Accounts[addr].valid = 1;
102         Accounts[addr].last_inv = payamount;
103         Accounts[addr].bet = Accounts[addr].bet + payamount;
104         InvRecord[IndNum] = Bet(addr,nowReAddr,payamount,Accounts[addr].remcode,LastT);
105         IndNum = IndNum + 1;
106         sendTeam(payamount);
107         sendPool(payamount);
108     }
109 
110     function take(uint order,address addr,uint payamount) external IsStaff{
111         require(address(this).balance>0,"Insufficient balance");
112         if(record[order]==0){
113             uint amount = payamount;
114             if(amount>address(this).balance){
115                 amount = address(this).balance;
116                 LastT = block.timestamp;
117             }
118             address payable takeAddr = address(uint160(addr));
119             record[order] = 1;
120             takeAddr.transfer(amount);
121         }
122     }
123 
124     function sendTeam(uint payamount) private{
125         uint teamAmount = payamount*TeamRate/100;
126         if(teamAmount<=address(this).balance){
127             address payable teamAddr = address(uint160(Team));
128             teamAddr.transfer(teamAmount);
129         }
130     }
131     function sendPool(uint payamount) private{
132         uint poolAmount = payamount*PoolRate/100;
133         if(poolAmount<=address(this).balance){
134             address payable poolAddr = address(uint160(Pool));
135             poolAddr.transfer(poolAmount);
136         }
137     }
138     function online(uint8 status) public isfirst{
139         IsOnLine = status;
140     }
141     function repeat(uint8 status) public isfirst{
142         if(status==1){
143             IsRepeat = 1;
144         }else{
145             IsRepeat = 0;
146         }
147     }
148     
149     function over(address addr) public IsStaff{
150         if(Accounts[addr].valid == 1){
151             Accounts[addr].valid = 2;
152         }
153     }
154 
155     function setStaff(address addr,uint8 status) public isfirst{
156         if(status==1){
157             Staff[addr] = 1;
158         }else{
159             Staff[addr] = 0;
160         }
161     }
162 
163     function getAccount(uint remcode) external view returns(uint,uint,uint,uint,uint,uint8,uint8,address,address){
164         User memory act = Accounts[msg.sender];
165         address remAddr = CodeMapAddr[remcode];
166         address payable poolAddr = address(uint160(Pool));
167         address payable fundAddr = address(uint160(Fund));
168         return (poolAddr.balance,fundAddr.balance,act.remcode,act.bet,act.last_inv,act.valid,IsRepeat,act.reddr,remAddr);
169     }
170 
171     function getIndex(uint index,uint order) external view IsStaff returns (address,address,uint,uint,uint,uint,uint,uint,uint8){
172         Bet memory idB = InvRecord[index];
173         uint total = address(this).balance;
174         uint8 odVal = record[order];
175         return (idB.addr,idB.reddr,idB.amount,idB.remcode,IndNum,total,idB.time,LastT,odVal);
176     }
177 }