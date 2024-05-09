1 pragma solidity ^0.4.24;
2 
3 /*
4   Реализация смарт контракта по типу 6 друзей
5 */
6 
7 contract SixFriends {
8 
9     using SafeMath for uint;
10 
11     address public ownerAddress; //Адресс владельца
12     uint private percentMarketing = 8; //Проценты на маркетинг
13     uint private percentAdministrator = 2; //Проценты администрации
14 
15     uint public c_total_hexagons; //Количество гексагонов всего
16     mapping(address =>  uint256) public Bills; //Баланс для вывода
17 
18     uint256 public BillsTotal; //суммарная проведенная сумма
19 
20     struct Node {
21         uint256 usd;
22         bool cfw;
23         uint256 min; //Стоимость входа
24         uint c_hexagons; //Количество гексагонов
25         mapping(address => bytes32[]) Addresses; //Адресс => уникальные ссылки
26         mapping(address => uint256[6]) Statistics; //Адресс => статистика по рефералам
27         mapping(bytes32 => address[6]) Hexagons; //Уникальная ссылка (keccak256) => 6 кошельков
28     }
29 
30     mapping (uint256 => Node) public Nodes; //все типы
31 
32     //Проверяет что сумма перевода достаточна
33     modifier enoughMoney(uint256 tp) {
34         require (msg.value >= Nodes[0].min, "Insufficient funds");
35         _;
36     }
37 
38     //Проверяет что тот кто перевел владелец кошелька
39     modifier onlyOwner {
40         require (msg.sender == ownerAddress, "Only owner");
41         _;
42     }
43 
44     //Ранее создан
45     modifier allReadyCreate(uint256 tp) {
46         require (Nodes[tp].cfw == false);
47         _;
48     }
49 
50     //Проверяю что человек запросивший являетя владельцем баланса
51     modifier recipientOwner(address recipient) {
52         require (Bills[recipient] > 0);
53         require (msg.sender == recipient);
54         _;
55     }
56 
57     //Функция для оплаты
58     function pay(bytes32 ref, uint256 tp) public payable enoughMoney(tp) {
59 
60         if (Nodes[tp].Hexagons[ref][0] == 0) ref = Nodes[tp].Addresses[ownerAddress][0]; //Если ref не найдена то берется первое значение
61 
62         createHexagons(ref, tp); //Передаю текущую ref, добавляю новые 6 друзей
63 
64         uint256 marketing_pay = ((msg.value / 100) * (percentMarketing + percentAdministrator));
65         uint256 friend_pay = msg.value - marketing_pay;
66 
67         //Перевожу деньги на счета клиентов
68         for(uint256 i = 0; i < 6; i++)
69             Bills[Nodes[tp].Hexagons[ref][i]] += friend_pay.div(6);
70 
71         //Перевожу коммисию на маркетинг
72         Bills[ownerAddress] += marketing_pay;
73 
74         //Суммирую всего выплат
75         BillsTotal += msg.value;
76     }
77 
78     function getHexagons(bytes32 ref, uint256 tp) public view returns (address, address, address, address, address, address)
79     {
80         return (Nodes[tp].Hexagons[ref][0], Nodes[tp].Hexagons[ref][1], Nodes[tp].Hexagons[ref][2], Nodes[tp].Hexagons[ref][3], Nodes[tp].Hexagons[ref][4], Nodes[tp].Hexagons[ref][0]);
81     }
82 
83     //Запросить деньги и обнулить счет
84     function getMoney(address recipient) public recipientOwner(recipient) {
85         recipient.transfer(Bills[recipient]);
86         Bills[recipient] = 0;
87     }
88 
89     //Передаю переданную рефку и добавляю новый гексагон
90     function createHexagons(bytes32 ref, uint256 tp) internal {
91 
92         Nodes[tp].c_hexagons++; //Увеличиваю счетчик гексагонов и транзакций
93         c_total_hexagons++; //Увеличиваю счетчик гексагонов и транзакций
94 
95         bytes32 new_ref = createRef(Nodes[tp].c_hexagons);
96 
97         //Прохожу по переданной рефке и создаю кошельки
98         for(uint8 i = 0; i < 5; i++)
99         {
100             Nodes[tp].Hexagons[new_ref][i] = Nodes[tp].Hexagons[ref][i + 1]; //Добавляю новый гексагон
101             Nodes[tp].Statistics[Nodes[tp].Hexagons[ref][i]][5 - i]++; //Добавляю статистку
102         }
103 
104         Nodes[tp].Statistics[Nodes[tp].Hexagons[ref][i]][0]++; //Добавляю статистку
105 
106         Nodes[tp].Hexagons[new_ref][5] = msg.sender;
107         Nodes[tp].Addresses[msg.sender].push(new_ref); //Добавляю рефку
108     }
109 
110     //Создаю новый гексагон с указанием его стоимости и порядкового номера
111     function createFirstWallets(uint256 usd, uint256 tp) public onlyOwner allReadyCreate(tp) {
112 
113         bytes32 new_ref = createRef(1);
114 
115         Nodes[tp].Hexagons[new_ref] = [ownerAddress, ownerAddress, ownerAddress, ownerAddress, ownerAddress, ownerAddress];
116         Nodes[tp].Addresses[ownerAddress].push(new_ref);
117 
118         Nodes[tp].c_hexagons = 1; //Количество гексагонов
119         Nodes[tp].usd = usd; //Сколько стоит членский взнос в эту ноду в долларах
120         Nodes[tp].cfw = true; //Нода помечается как созданная
121 
122         c_total_hexagons++;
123     }
124 
125     //Создаю реферальную ссылку на основе номера блока и типа контракта
126     function createRef(uint hx) internal pure returns (bytes32) {
127         uint256 _unixTimestamp;
128         uint256 _timeExpired;
129         return keccak256(abi.encodePacked(hx, _unixTimestamp, _timeExpired));
130     }
131 
132     //Получаю количество ссылок для адреса
133     function countAddressRef(address adr, uint256 tp) public view returns (uint count) {
134         count = Nodes[tp].Addresses[adr].length;
135     }
136 
137     //Получаю ссылку
138     function getAddress(address adr, uint256 i, uint256 tp) public view returns(bytes32) {
139         return Nodes[tp].Addresses[adr][i];
140     }
141 
142     //Возвращение статистики
143     function getStatistics(address adr, uint256 tp) public view returns(uint256, uint256, uint256, uint256, uint256, uint256)
144     {
145         return (Nodes[tp].Statistics[adr][0], Nodes[tp].Statistics[adr][1], Nodes[tp].Statistics[adr][2], Nodes[tp].Statistics[adr][3], Nodes[tp].Statistics[adr][4], Nodes[tp].Statistics[adr][5]);
146     }
147 
148     //Устанавливаю стоимость входа
149     function setMin(uint value, uint256 tp) public onlyOwner {
150         Nodes[tp].min = value;
151     }
152 
153     //Получение минимальной стоимости
154     function getMin(uint256 tp) public view returns (uint256) {
155         return Nodes[tp].min;
156     }
157 
158     //Получаю тотал денег
159     function getBillsTotal() public view returns (uint256) {
160         return BillsTotal;
161     }
162 
163     constructor() public {
164         ownerAddress = msg.sender;
165     }
166 }
167 
168 library SafeMath {
169     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
170         if (a == 0) {
171             return 0;
172         }
173         uint256 c = a * b;
174         assert(c / a == b);
175         return c;
176     }
177 
178     function div(uint256 a, uint256 b) internal pure returns (uint256) {
179         uint256 c = a / b;
180         return c;
181     }
182 
183     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
184         assert(b <= a);
185         return a - b;
186     }
187 
188     function add(uint256 a, uint256 b) internal pure returns (uint256) {
189         uint256 c = a + b;
190         assert(c >= a);
191         return c;
192     }
193 }