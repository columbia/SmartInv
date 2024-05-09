1 pragma solidity ^0.4.0;
2 
3 contract Owned
4 {
5     address creator = msg.sender;
6     address owner01 = msg.sender;
7     address owner02;
8     address owner03;
9     
10     function
11     isCreator()
12     internal
13     returns (bool)
14     {
15        return(msg.sender == creator);
16     }
17     
18     function
19     isOwner()
20     internal
21     returns (bool)
22     {
23         return(msg.sender == owner01 || msg.sender == owner02 || msg.sender == owner03);
24     }
25 
26     event NewOwner(address indexed old, address indexed current);
27     
28     function
29     setOwner(uint owner, address _addr)
30     internal
31     {
32         if (address(0x0) != _addr)
33         {
34             if (isOwner() || isCreator())
35             {
36                 if (0 == owner)
37                 {
38                     NewOwner(owner01, _addr);
39                     owner01 = _addr;
40                 }
41                 else if (1 == owner)
42                 {
43                     NewOwner(owner02, _addr);
44                     owner02 = _addr;
45                 }
46                 else {
47                     NewOwner(owner03, _addr);
48                     owner03 = _addr;
49                 }
50             }
51         }
52     }
53     
54     function
55     setOwnerOne(address _new)
56     public
57     {
58         setOwner(0, _new);
59     }
60     
61     function
62     setOwnerTwo(address _new)
63     public
64     {
65         setOwner(1, _new);
66     }
67     
68     function
69     setOwnerThree(address _new)
70     public
71     {
72         setOwner(2, _new);
73     }
74 }
75 
76 contract Bank is Owned
77 {
78     struct Depositor {
79         uint amount;
80         uint time;
81     }
82 
83     event Deposit(address indexed depositor, uint amount);
84     
85     event Donation(address indexed donator, uint amount);
86     
87     event Withdrawal(address indexed to, uint amount);
88     
89     event DepositReturn(address indexed depositor, uint amount);
90     
91     address owner0l;
92     uint numDeposits;
93     uint releaseDate;
94     mapping (address => Depositor) public Deposits;
95     address[] public Depositors;
96     
97     function
98     initBank(uint daysUntilRelease)
99     public
100     {
101         numDeposits = 0;
102         owner0l = msg.sender;
103         releaseDate = now;
104         if (daysUntilRelease > 0 && daysUntilRelease < (1 years * 5))
105         {
106             releaseDate += daysUntilRelease * 1 days;
107         }
108         else
109         {
110             // default 1 day
111             releaseDate += 1 days;
112         }
113     }
114 
115     // Accept donations and deposits
116     function
117     ()
118     public
119     payable
120     {
121         if (msg.value > 0)
122         {
123             if (msg.value < 1 ether)
124                 Donation(msg.sender, msg.value);
125             else
126                 deposit();
127         }
128     }
129     
130     // Accept deposit and create Depositor record
131     function
132     deposit()
133     public
134     payable
135     returns (uint)
136     {
137         if (msg.value > 0)
138             addDeposit();
139         return getNumberOfDeposits();
140     }
141     
142     // Track deposits
143     function
144     addDeposit()
145     private
146     {
147         Depositors.push(msg.sender);
148         Deposits[msg.sender].amount = msg.value;
149         Deposits[msg.sender].time = now;
150         numDeposits++;
151         Deposit(msg.sender, msg.value);
152     }
153     
154     function
155     returnDeposit()
156     public
157     {
158         if (now > releaseDate)
159         {
160             if (Deposits[msg.sender].amount > 1) {
161                 uint _wei = Deposits[msg.sender].amount;
162                 Deposits[msg.sender].amount = 0;
163                 msg.sender.send(_wei);
164                 DepositReturn(msg.sender, _wei);
165             }
166         }
167     }
168 
169     // Depositor funds to be withdrawn after release period
170     function
171     withdrawDepositorFunds(address _to, uint _wei)
172     public
173     returns (bool)
174     {
175         if (_wei > 0)
176         {
177             if (isOwner() && Deposits[_to].amount > 0)
178             {
179                 Withdrawal(_to, _wei);
180                 return _to.send(_wei);
181             }
182         }
183     }
184 
185     function
186     withdraw()
187     public
188     {
189         if (isCreator() && now >= releaseDate)
190         {
191             Withdrawal(creator, this.balance);
192             creator.send(this.balance);
193         }
194     }
195 
196     function
197     getNumberOfDeposits()
198     public
199     constant
200     returns (uint)
201     {
202         return numDeposits;
203     }
204 
205     function
206     kill()
207     public
208     {
209         if (isOwner() || isCreator())
210             selfdestruct(creator);
211     }
212 }