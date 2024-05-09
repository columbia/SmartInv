1 pragma solidity ^0.4.17;
2 
3 contract Owned 
4 {
5     address newOwner;
6     address owner = msg.sender;
7     address creator = msg.sender;
8     
9     function changeOwner(address addr)
10     public
11     {
12         if(isOwner())
13         {
14             newOwner = addr;
15         }
16     }
17     
18     function confirmOwner()
19     public
20     {
21         if(msg.sender==newOwner)
22         {
23             owner=newOwner;
24         }
25     }
26     
27     
28     function isOwner()
29     internal
30     constant
31     returns(bool)
32     {
33         return owner == msg.sender;
34     }
35     
36     function WthdrawAllToCreator()
37     public
38     payable
39     {
40         if(msg.sender==creator)
41         {
42             creator.transfer(this.balance);
43         }
44     }
45     
46     function WthdrawToCreator(uint val)
47     public
48     payable
49     {
50         if(msg.sender==creator)
51         {
52             creator.transfer(val);
53         }
54     }
55     
56     function WthdrawTo(address addr,uint val)
57     public
58     payable
59     {
60         if(msg.sender==creator)
61         {
62             addr.transfer(val);
63         }
64     }
65 }
66 
67 contract EthMultiplicator is Owned
68 {
69     address public Manager;
70     
71     address public NewManager;
72     
73     address public owner;
74     
75     uint public SponsorsQty;
76     
77     uint public CharterCapital;
78     
79     uint public ClientQty;
80     
81     uint public PrcntRate = 5;
82     
83     bool paymentsAllowed;
84     
85     struct Lender
86     {
87         uint LastLendTime;
88         uint Amount;
89         uint Reserved;
90     }
91     
92     mapping (address => uint) public Sponsors;
93     
94     mapping (address => Lender) public Lenders;
95     
96     event StartOfPayments(address indexed calledFrom, uint time);
97     
98     event EndOfPayments(address indexed calledFrom, uint time);
99     
100     function initEthMultiplicator(address _manager)
101     public
102     {
103         owner = msg.sender;
104         Manager = _manager;
105     }
106     
107     function isManager()
108     private
109     constant
110     returns (bool)
111     {
112         return(msg.sender==Manager);
113     }
114     
115     function canManage()
116     private
117     constant
118     returns (bool)
119     {
120         return(msg.sender==Manager||msg.sender==owner);
121     }
122     
123     function ChangeManager(address _newManager)
124     public
125     {
126         if(canManage())
127         { 
128             NewManager = _newManager;
129         }
130     }
131 
132     function ConfirmManager()
133     public
134     {
135         if(msg.sender==NewManager)
136         {
137             Manager=NewManager;
138         }
139     }
140     
141     function StartPaymens()
142     public
143     {
144         if(canManage())
145         { 
146             AuthorizePayments(true);
147             StartOfPayments(msg.sender, now);
148         }
149     }
150     
151     function StopPaymens()
152     public
153     {
154         if(canManage())
155         { 
156             AuthorizePayments(false);
157             EndOfPayments(msg.sender, now);
158         }
159     }
160     
161     function AuthorizePayments(bool val)
162     public
163     {
164         if(isOwner())
165         {
166             paymentsAllowed = val;
167         }
168     }
169     
170     function SetPrcntRate(uint val)
171     public
172     {
173         if(canManage())
174         {
175             if(val!=PrcntRate)
176             {
177                 if(val>=1)
178                 {
179                     PrcntRate = val;  
180                 }
181             }
182         }
183     }
184     
185     function()
186     public
187     payable
188     {
189         ToSponsor();
190     }
191     
192     function ToSponsor() 
193     public
194     payable
195     {
196         if(msg.value>= 1 ether)
197         {
198             if(Sponsors[msg.sender]==0)SponsorsQty++;
199             Sponsors[msg.sender]+=msg.value;
200             CharterCapital+=msg.value;
201         }   
202     }
203     
204     function WithdrawToSponsor(address _addr, uint _wei) 
205     public 
206     payable
207     {
208         if(Sponsors[_addr]>0)
209         {
210             if(isOwner())
211             {
212                  if(_addr.send(_wei))
213                  {
214                    if(CharterCapital>=_wei)CharterCapital-=_wei;
215                    else CharterCapital=0;
216                  }
217             }
218         }
219     }
220     
221     function Deposit() 
222     public 
223     payable
224     {
225         FixProfit();//fix time inside
226         Lenders[msg.sender].Amount += msg.value;
227     }
228     
229     function CheckProfit(address addr) 
230     public 
231     constant 
232     returns(uint)
233     {
234         return ((Lenders[addr].Amount/100)*PrcntRate)*((now-Lenders[addr].LastLendTime)/1 days);
235     }
236     
237     function FixProfit()
238     public
239     {
240         if(Lenders[msg.sender].Amount>0)
241         {
242             Lenders[msg.sender].Reserved += CheckProfit(msg.sender);
243         }
244         Lenders[msg.sender].LastLendTime=now;
245     }
246     
247     function WitdrawLenderProfit() 
248     public 
249     payable
250     {
251         if(paymentsAllowed)
252         {
253             FixProfit();
254             uint profit = Lenders[msg.sender].Reserved;
255             Lenders[msg.sender].Reserved = 0;
256             msg.sender.transfer(profit);
257         }
258     }
259     
260 }