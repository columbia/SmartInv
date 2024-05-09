1 pragma solidity ^0.4.25;
2 
3 /**
4 
5 
6     ╔═══╗╔═══╗╔════╗───╔╗─╔╗─╔╗
7     ║╔══╝║╔══╝╚═╗╔═╝──╔╝║╔╝║╔╝║
8     ║║╔═╗║╚══╗──║║────╚╗║╚╗║╚╗║
9     ║║╚╗║║╔══╝──║║─────║║─║║─║║
10     ║╚═╝║║╚══╗──║║─────║║─║║─║║
11     ╚═══╝╚═══╝──╚╝─────╚╝─╚╝─╚╝
12 
13    Automatic returns 111% of each investment!
14    M A X  D E P O S I T E  I S  2 ETH  
15    NO HUMAN Factor - fully automatic!
16    http://get111.today/ 
17    Join Telegram Group https://t.me/joinchat/Ky1lEBJD3jLvXXMqcpGEOQ
18    Admin https://t.me/Get111Admin
19   1. Send ETH to smart contract address
20      - from 0.01 to 2 ETH
21      - min 250000 gas limit 
22   2. Wait a bit time..
23   3. Promote us if you want...
24   4. Get your 111%
25 
26   Admin fee is 5% ( 3% for tech support. 2% for transaction gas fees )
27 
28      
29  
30   Автоматические выплаты 111% от вашего депозита!
31   М А К С И М А Л Ь Н Ы Й  Д Е П О З И Т  2 ETH 
32   Без ЧЕЛОВЕЧЕСКОГО фактора - Полная автоматика!
33   http://get111.today/
34   Телеграм Группа  https://t.me/joinchat/Ky1lEBJD3jLvXXMqcpGEOQ
35   Админ https://t.me/Get111Admin
36   1. Отправьте ETH на адрес контракта
37      - от 0.01 до 2 ETH
38      - gas limit минимум 250000
39   2. Можете ждать, а можете,.
40   3. Рассказать друзьям.
41   4. Получите ваши 111% прибыли.
42 
43   Комиссия администратора составляет 5% ( 3% тех поддержка. 2% издержки на оплату газа )
44 
45 */
46 
47 contract GET111 {
48     address constant private ADMIN = 0x411647BA6480bF5FDec2145f858FD37AeCBfC03B;
49     uint constant public ADMIN_FEE = 5;
50     uint constant public PROFIT = 111;
51 
52     struct Deposit {
53         address depositor; //depositor address
54         uint128 deposit;   //deposit amount
55         uint128 expect;    //payout 111% (100% + 11%)
56     }
57 
58     Deposit[] private queue;
59     uint public currentReceiverIndex = 0;
60 
61     //That function receive deposits, saves and after make instant payments
62     function () public payable {
63         if(msg.value > 0){
64             require(gasleft() >= 220000, "We require more gas!"); //gas need to process transaction
65             require(msg.value <= 2 ether); //We not allow big sums, it is for contract long life
66 
67             //Adding investor into queue. Now he expects to receive 111% of his deposit
68             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*PROFIT/100)));
69 
70             //Send fees 5% (3%+2%)
71             uint admin = msg.value*ADMIN_FEE/100;
72             ADMIN.send(admin);
73 
74             //First in line get paid instantly
75             pay();
76         }
77     }
78 
79     //This function paying for the first users in line  
80     function pay() private {
81         uint128 money = uint128(address(this).balance);
82 
83         for(uint i=0; i<queue.length; i++){
84 
85             uint idx = currentReceiverIndex + i;
86 
87             Deposit storage dep = queue[idx];
88 
89             if(money >= dep.expect){
90                 dep.depositor.send(dep.expect);
91                 money -= dep.expect;
92 
93                 //User total paid
94                 delete queue[idx];
95             }else{
96                 
97                 dep.depositor.send(money);
98                 dep.expect -= money;
99                 break;
100             }
101 
102             if(gasleft() <= 50000)
103                 break;
104         }
105 
106         currentReceiverIndex += i;
107     }
108 
109     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
110         Deposit storage dep = queue[idx];
111         return (dep.depositor, dep.deposit, dep.expect);
112     }
113 
114     function getDepositsCount(address depositor) public view returns (uint) {
115         uint c = 0;
116         for(uint i=currentReceiverIndex; i<queue.length; ++i){
117             if(queue[i].depositor == depositor)
118                 c++;
119         }
120         return c;
121     }
122 
123     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
124         uint c = getDepositsCount(depositor);
125 
126         idxs = new uint[](c);
127         deposits = new uint128[](c);
128         expects = new uint128[](c);
129 
130         if(c > 0) {
131             uint j = 0;
132             for(uint i=currentReceiverIndex; i<queue.length; ++i){
133                 Deposit storage dep = queue[i];
134                 if(dep.depositor == depositor){
135                     idxs[j] = i;
136                     deposits[j] = dep.deposit;
137                     expects[j] = dep.expect;
138                     j++;
139                 }
140             }
141         }
142     }
143 
144     function getQueueLength() public view returns (uint) {
145         return queue.length - currentReceiverIndex;
146     }
147 
148 }