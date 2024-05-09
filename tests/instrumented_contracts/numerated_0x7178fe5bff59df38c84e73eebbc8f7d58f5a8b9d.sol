1 pragma solidity ^0.4.25;
2 
3 // donate: 0x95CC9E2FE2E2de48A02CF6C09439889d72D5ea78
4 
5 contract GorgonaKiller {
6     // адрес горгоны
7     address public GorgonaAddr; 
8     
9     // минимальный депозит
10     uint constant public MIN_DEP = 0.01 ether; 
11     
12     // максимальное число транзакций при выплате дивидендов
13     uint constant public TRANSACTION_LIMIT = 100;
14     
15     // баланс дивидендов
16     uint public dividends;
17     
18     // id последнего инвестора, которому прошла оплата
19     uint public last_payed_id;
20     
21     // общая сумма депозитов от инвесторов
22     uint public deposits; 
23     
24     // адреса инвесторов
25     address[] addresses;
26 
27     // мапинг адрес инвестора - структура инвестора
28     mapping(address => Investor) public members;
29     
30     // id адреса в investors, deposit - сумма депозитов
31     struct Investor {
32         uint id;
33         uint deposit;
34     }
35     
36     constructor() public {
37         GorgonaAddr = 0x020e13faF0955eFeF0aC9cD4d2C64C513ffCBdec; 
38     }
39 
40     // обработка поступлений
41     function () external payable {
42 
43         // если пришло с горгоны выходим
44         if (msg.sender == GorgonaAddr) {
45             return;
46         }
47         
48         // если баланс без текущего поступления > 0 пишем в дивиденды
49         if ( address(this).balance - msg.value > 0 ) {
50             dividends = address(this).balance - msg.value;
51         }
52         
53         // выплачиваем дивиденды
54         if ( dividends > 0 ) {
55             payDividends();
56         }
57         
58         // инвестируем текущее поступление
59         if (msg.value >= MIN_DEP) {
60             Investor storage investor = members[msg.sender];
61 
62             // добавляем инвестора, если еще нет
63             if (investor.id == 0) {
64                 investor.id = addresses.push(msg.sender);
65             }
66 
67             // пополняем депозит инвестора и общий депозит
68             investor.deposit += msg.value;
69             deposits += msg.value;
70     
71             // отправляем в горгону
72             payToGorgona();
73 
74         }
75         
76     }
77 
78     // отправляем текущее поступление в горгону
79     function payToGorgona() private {
80         if ( GorgonaAddr.call.value( msg.value )() ) return; 
81     }
82 
83     // выплата дивидендов
84     function payDividends() private {
85         address[] memory _addresses = addresses;
86         
87         uint _dividends = dividends;
88 
89         if ( _dividends > 0) {
90             uint num_payed = 0;
91             
92             for (uint i = last_payed_id; i < _addresses.length; i++) {
93                 
94                 // считаем для каждого инвестора долю дивидендов
95                 uint amount = _dividends * members[ _addresses[i] ].deposit / deposits;
96                 
97                 // отправляем дивиденды
98                 if ( _addresses[i].send( amount ) ) {
99                     last_payed_id = i+1;
100                     num_payed += 1;
101                 }
102                 
103                 // если достигли лимита выплат выходим из цикла
104                 if ( num_payed == TRANSACTION_LIMIT ) break;
105                 
106             }
107             
108             // обнуляем id последней выплаты, если выплатили всем
109             if ( last_payed_id >= _addresses.length) {
110                 last_payed_id = 0;
111             }
112             
113             dividends = 0;
114             
115         }
116         
117     }
118     
119     // смотрим баланс на контракте
120     function getBalance() public view returns(uint) {
121         return address(this).balance / 10 ** 18;
122     }
123 
124     // смотрим число инвесторов
125     function getInvestorsCount() public view returns(uint) {
126         return addresses.length;
127     }
128 
129 }