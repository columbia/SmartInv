1 contract EthDig
2 {
3     uint constant LifeTime = 30;
4     
5     address Owner = msg.sender;
6     address OutputAddress = msg.sender;
7     
8     uint64 Coef1=723;
9     uint64 Coef2=41665;
10     uint64 Coef3=600000;
11     
12     uint public ContributedAmount;
13     uint ContributedLimit = 10 ether;
14     
15     uint public CashForHardwareReturn;
16     uint public FreezedCash;
17     
18     uint16 UsersLength = 0;
19     mapping (uint16 => User) Users;
20     struct User{
21         address Address;
22         uint16 ContributionsLength;
23         mapping (uint16 => Contribution) Contributions;
24     }
25     struct Contribution{
26         uint CashInHarware;
27         uint CashFreezed;
28         
29         uint16 ProfitPercent;
30         uint NeedPayByDay;
31         
32         bool ReuseCashInHarware;
33         
34         uint DateCreated;
35         uint DateLastCheck;
36         uint AlreadyPaid;
37         
38         bool ReturnedHardwareCash;
39         bool Finished;
40     }
41     
42     function  ContributeInternal(uint16 userId,uint cashInHarware,uint cashFreezed,bool reuseCashInHarware) private{
43         Contribution contribution = Users[userId].Contributions[Users[userId].ContributionsLength];
44 
45         contribution.CashInHarware = cashInHarware;
46         contribution.CashFreezed = cashFreezed;
47         
48         uint8 noFreezCoef = uint8 ((cashInHarware * 100) / (cashFreezed+cashInHarware));
49         contribution.ProfitPercent = uint16 (((Coef1 * noFreezCoef * noFreezCoef) + (Coef2 * noFreezCoef) + Coef3)/10000);//10000
50         
51         contribution.NeedPayByDay = (((cashInHarware + cashFreezed) /10000) * contribution.ProfitPercent)/LifeTime;
52         contribution.ReuseCashInHarware = reuseCashInHarware;
53         contribution.DateCreated = now;
54         contribution.DateLastCheck = now;
55         
56         Users[userId].ContributionsLength++;
57     }
58     function ContributeWithSender (bool reuseCashInHarware,uint8 freezeCoeff,address sender) {
59         if (msg.value == 0 || freezeCoeff>100 ||ContributedAmount + msg.value > ContributedLimit)
60         {
61             sender.send(msg.value);
62             return;
63         }
64         
65         uint16 userId = GetUserIdByAddress(sender);
66         if (userId == 65535)
67         {
68             userId = UsersLength;
69             Users[userId].Address = sender;
70             UsersLength ++;
71         }
72         
73         uint cashFreezed = ((msg.value/100)*freezeCoeff);
74         ContributeInternal(
75             userId,
76             msg.value - cashFreezed,
77             cashFreezed,
78             reuseCashInHarware
79             );
80         FreezedCash += cashFreezed;
81         ContributedAmount += msg.value;
82         
83         OutputAddress.send(msg.value - cashFreezed);
84     }
85     function Contribute (bool reuseCashInHarware,uint8 freezeCoeff) {
86         ContributeWithSender(reuseCashInHarware,freezeCoeff,msg.sender);
87     }
88     function ChangeReuseCashInHarware(bool newValue,uint16 userId,uint16 contributionId){
89         if (msg.sender != Users[userId].Address) return;
90         Users[userId].Contributions[contributionId].ReuseCashInHarware = newValue;
91     }
92     
93     function Triger(){
94         if (Owner != msg.sender) return;
95         
96         uint MinedTillLastPayment = this.balance - CashForHardwareReturn - FreezedCash;
97         bool NotEnoughCash = false;
98         
99         for(uint16 i=0;i<UsersLength;i++)
100         {
101             for(uint16 j=0;j<Users[i].ContributionsLength;j++)
102             {
103                 Contribution contribution = Users[i].Contributions[j];
104                 if (contribution.Finished || now - contribution.DateLastCheck < 1 days) continue;
105                 
106                 if (contribution.AlreadyPaid != contribution.NeedPayByDay * LifeTime)
107                 {
108                     uint8 daysToPay = uint8((now - contribution.DateCreated)/1 days);
109                     if (daysToPay>LifeTime) daysToPay = uint8(LifeTime);
110                     uint needToPay = (daysToPay * contribution.NeedPayByDay) - contribution.AlreadyPaid;
111                     
112                     if (MinedTillLastPayment < needToPay)
113                     {
114                         NotEnoughCash = true;
115                     }
116                     else
117                     {
118                         if (needToPay > 100 finney || daysToPay == LifeTime)
119                         {
120                             MinedTillLastPayment -= needToPay;
121                             Users[i].Address.send(needToPay);
122                             contribution.AlreadyPaid += needToPay;
123                         }
124                     }
125                     contribution.DateLastCheck = now;
126                 }
127 
128                 if (now > contribution.DateCreated + (LifeTime * 1 days) && !contribution.ReturnedHardwareCash)
129                 {
130                     if (contribution.ReuseCashInHarware)
131                     {
132                         ContributeInternal(
133                             i,
134                             contribution.CashInHarware,
135                             contribution.CashFreezed,
136                             true
137                         );
138                         contribution.ReturnedHardwareCash = true;
139                     }
140                     else
141                     {
142                         if (CashForHardwareReturn >= contribution.CashInHarware)
143                         {
144                             CashForHardwareReturn -= contribution.CashInHarware;
145                             FreezedCash -= contribution.CashFreezed;
146                             ContributedAmount -= contribution.CashFreezed + contribution.CashInHarware;
147                             Users[i].Address.send(contribution.CashInHarware + contribution.CashFreezed);
148                             contribution.ReturnedHardwareCash = true;
149                         }
150                     }
151                 }
152                 
153                 if (contribution.ReturnedHardwareCash && contribution.AlreadyPaid == contribution.NeedPayByDay * LifeTime)
154                 {
155                     contribution.Finished = true;
156                 }
157             }  
158         }
159         
160         if (!NotEnoughCash)
161         {
162             OutputAddress.send(MinedTillLastPayment);
163         }
164     }
165     
166     function ConfigureFunction(address outputAddress,uint contributedLimit,uint16 coef1,uint16 coef2,uint16 coef3)
167     {
168         if (Owner != msg.sender) return;
169         OutputAddress = outputAddress;
170         ContributedLimit = contributedLimit;
171         Coef1 = coef1;
172         Coef2 = coef2;
173         Coef3 = coef3;
174     }
175     
176     function SendCashForHardwareReturn(){
177         CashForHardwareReturn += msg.value;
178     }
179     function WithdrawCashForHardwareReturn(uint amount){
180         if (Owner != msg.sender || CashForHardwareReturn < amount) return;
181         Owner.send(amount);
182     }
183     
184     function GetUserIdByAddress (address userAddress) returns (uint16){
185         for(uint16 i=0; i<UsersLength;i++)
186         {
187             if (Users[i].Address == userAddress)
188                 return i;
189         }
190         return 65535;
191     }
192     
193     function GetContributionInfo (uint16 userId,uint16 contributionId) 
194     returns (uint a1,uint a2, uint16 a3,uint a4, bool a5,uint a6,uint a7,uint a8,bool a9,bool a10,address a11) 
195     {
196         Contribution contribution = Users[userId].Contributions[contributionId];
197         a1 = contribution.CashInHarware;
198         a2 = contribution.CashFreezed;
199         a3 = contribution.ProfitPercent;
200         a4 = contribution.NeedPayByDay;
201         a5 = contribution.ReuseCashInHarware;
202         a6 = contribution.DateCreated;
203         a7 = contribution.DateLastCheck;
204         a8 = contribution.AlreadyPaid;
205         a9 = contribution.ReturnedHardwareCash;
206         a10 = contribution.Finished;
207         a11 = Users[userId].Address;
208     }
209     
210 }
211 
212 contract EthDigProxy
213 {
214     address Owner = msg.sender;
215     EthDig public ActiveDigger; 
216     
217     function ChangeActiveDigger(address activeDiggerAddress){
218         if (msg.sender != Owner) return;
219         ActiveDigger =EthDig(activeDiggerAddress);
220     }
221     function GetMoney(){
222         if (msg.sender != Owner) return;
223         Owner.send(this.balance);
224     }
225     
226     function Contribute (bool reuseCashInHarware,uint8 freezeCoeff) {
227         ActiveDigger.ContributeWithSender.value(msg.value)(reuseCashInHarware,freezeCoeff,msg.sender);
228     }
229     function (){
230         ActiveDigger.ContributeWithSender.value(msg.value)(false,0,msg.sender);
231     }
232 }