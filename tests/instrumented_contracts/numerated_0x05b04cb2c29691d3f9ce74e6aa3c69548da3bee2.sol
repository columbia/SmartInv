1 pragma solidity ^0.4.25;
2 
3 contract EtherStateEquivalentToken {
4     address public owner;
5     mapping (address => uint256) public tokenBalance;
6     mapping (address => uint256) public refBalance;
7     
8     uint256 public tokenPrice = 0.0004 ether; 
9     uint256 public tokenSupply = 0;
10     uint256 constant public softCap =  2500000 ether;
11     uint256 constant public hardCap = 10000000 ether;
12     uint256 public start;
13     uint256 public softCapMoment = 0;
14     uint256 public softCapPeriod = 1483300; //17 * 24 * 60 * 60;
15     uint256 public hardCapPeriod = softCapPeriod;
16     uint256 public investedTotal = 0;
17     
18     bool public softCapReached = false;
19     
20     modifier onlyOwner {
21         require(msg.sender == owner);
22         _;
23     }
24     
25     modifier softCapFailed {
26         require(now > start + softCapPeriod && !softCapReached);
27         _;
28     }
29     
30     constructor() public {
31         owner = msg.sender;
32         start = now;
33     }
34     
35     function() public payable {
36         invest(msg.sender, msg.value, 0x0, 0x0);
37     }
38     
39     function buy(address ref1, address ref2) public payable {
40         /* 
41             Function Enhamster
42         */
43         
44         require(msg.value > 0);
45         
46         invest(msg.sender, msg.value, ref1, ref2);
47     }
48     
49     function invest(address investor, uint256 value, address ref1, address ref2) internal {
50         /* 
51             Внутренняя функция покупки токенов, вызывается из головного метода и метода buy.
52         */
53         
54         uint256 tokens = value / tokenPrice * 1 ether;
55         require (tokens + tokenSupply <= hardCap); /* нельзя чтобы образовался tokenSupply, превосходящий 10 000 000 EST */
56         if (softCapMoment > 0) require(now < softCapMoment + hardCapPeriod); /* после периода Hard Cap токены нельзя покупать */
57         
58         tokenBalance[investor] += tokens;
59         tokenSupply += tokens;
60         
61         if (tokenSupply >= softCap) {
62             softCapReached = true;
63             softCapMoment = now;
64         }
65         
66         uint256 ref1Money = value * 6 / 100;
67         uint256 ref2Money = value * 3 / 100;
68         uint256 ownerMoney = value - ref1Money - ref2Money;
69         
70         if (ref1 != 0x0 && tokenBalance[ref1] >= 125 ether) {
71             refBalance[ref1] += ref1Money;
72         } else {
73             refBalance[owner] += ref1Money;
74         }
75         if (ref2 != 0x0 && tokenBalance[ref2] >= 125 ether) {
76             refBalance[ref2] += ref2Money;
77         } else {
78             refBalance[owner] += ref2Money;
79         }
80         refBalance[owner] += ownerMoney;
81         
82         investedTotal += value;
83          
84         emit OnInvest(investor, value, tokens, ref1, ref2, now);
85     }
86     
87     function withdraw() public {
88         /* 
89             Вывод средств с реферального баланса, возможен только в случае достижения Soft Cap. Этот же метод 
90             используется owner'ом контракта для вывода средств.
91         */
92         
93         require(softCapReached);
94         uint256 value = refBalance[msg.sender];
95         require(value > 0);
96         
97         refBalance[msg.sender] = 0;
98         
99         msg.sender.transfer(value);
100         emit OnWithdraw(msg.sender, value, now);
101     }
102     
103     function withdrawAmount(uint256 amount) public {
104         /* 
105             Вывод средств с реферального баланса, с указанием определённой суммы.
106         */
107         require(amount > 0);
108         require(softCapReached);
109         uint256 value = refBalance[msg.sender];
110         require(value >= amount);
111         
112         refBalance[msg.sender] = value-amount;
113         
114         msg.sender.transfer(amount);
115         emit OnWithdraw(msg.sender, amount, now);
116     }
117     
118     function withdrawAmountTo(uint256 amount, address receiver) public {
119         /* 
120             Вывод средств с реферального баланса определённой суммы в пользу другого адреса.
121         */
122         require(amount > 0);
123         require(softCapReached);
124         uint256 value = refBalance[msg.sender];
125         require(value >= amount);
126         
127         refBalance[msg.sender] = value-amount;
128         
129         receiver.transfer(amount);
130         emit OnWithdrawTo(msg.sender, receiver, amount, now);
131     }
132     
133     function deinvest() public softCapFailed {
134         /* 
135             Вывод средств инвестора в случае провала softCap. Модификатор проверяет время и не позволяет 
136             выводить средства до завершения периода softCapPeriod, а также в случае, если Soft Cap был выполнен.
137         */
138             
139         uint256 tokens = tokenBalance[msg.sender];
140         require(tokens > 0);
141         
142         tokenBalance[msg.sender] = 0;
143         tokenSupply -= tokens;
144         uint256 money = tokens * tokenPrice / 1e18;
145         msg.sender.transfer(money);
146         emit OnDeinvest(msg.sender, tokens, money, now);
147     }
148     
149     function goESM() public { 
150         /*  
151             Обмен на токены Ether State Main. При вызове этого метода, все токены EST будут сожжены,
152             и сформируется соответствующий Event.
153         */
154        
155         require(softCapReached);
156         uint256 tokens = tokenBalance[msg.sender];
157         require(tokens > 0);
158         
159         tokenBalance[msg.sender] = 0;
160         tokenSupply -= tokens;
161         emit OnExchangeForESM(msg.sender, tokens, now);
162     }
163 
164     function transfer(address receiver) public {
165         uint256 tokens = tokenBalance[msg.sender];
166         require(tokens > 0);
167 
168         tokenBalance[msg.sender] = 0;
169         tokenBalance[receiver] += tokens;
170 
171         emit OnTransfer(msg.sender, receiver, tokens, now);
172     }
173     
174     event OnInvest (
175         address investor,
176         uint256 value,
177         uint256 tokensGranted,
178         address ref1,
179         address ref2,
180         uint256 timestamp
181     );
182     
183     event OnWithdraw (
184         address indexed investor,
185         uint256 value,
186         uint256 timestamp
187     );
188 
189     event OnWithdrawTo (
190         address indexed investor,
191         address indexed receiver,
192         uint256 value,
193         uint256 timestamp
194     );
195     
196     event OnDeinvest (
197         address indexed investor,
198         uint256 tokensBurned,
199         uint256 value,
200         uint256 timestamp
201     );
202     
203     event OnExchangeForESM (
204         address indexed investor,
205         uint256 tokensBurned,
206         uint256 timestamp
207     );
208 
209     event OnTransfer (
210         address investorA,
211         address investorB,
212         uint256 tokens,
213         uint256 timestamp
214     );
215 }