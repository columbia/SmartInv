1 pragma solidity ^0.4.18;
2 
3 contract ownerOnly {
4     
5     function ownerOnly() public { owner = msg.sender; }
6     address owner;
7 
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12 }
13 
14 contract Game is ownerOnly {
15     
16     //Уникальный код коровы
17     uint cow_code;
18     
19     struct cows {
20         uint cow;
21         uint date_buy;
22         bool cow_live;
23         uint milk;
24         uint date_milk;
25     } 
26     
27     //Маппинг количество коров у пользователя
28     mapping (address => uint) users_cows;
29     //Маппинг коровы у пользователя
30     mapping (bytes32 => cows) user;
31     //Маппинг телеги
32     mapping (address => bool) telega;
33     //Адрес кошелька rico
34     address rico;
35     
36     //сколько корова дает молока за одну дойку
37     uint volume_milk;
38     //сколько нужно времени между доениями
39     uint time_to_milk;
40     //времмя жизни коровы
41     uint time_to_live;   
42         
43     //сколько стоит молоко в веях в розницу
44     uint milkcost;
45     
46     //инициируем переменные движка
47     function Game() public {
48         
49         //устанавливаем кошелек движка для управления
50     	rico = 0xb5F60D78F15b73DC2D2083571d0EEa70d35b9D28;
51     	
52     	//Устанавливаем счетчик коров
53     	cow_code = 0;
54     	
55         //сколько литров дает корова на 5 минут
56         volume_milk = 1;
57         //через сколько секунд можно доить корову
58         time_to_milk = 60;
59         //сколько секунд живет корова - 30 мин
60         time_to_live = 600;  
61         
62         //Сколько стоит продать молоко в розницу
63         milkcost = 0.0013 ether;
64     }
65     
66     function pay() public payable {
67         payCow();
68     }        
69     
70     //покупаем коров только от движка
71     function payCow() private {
72        
73         uint time= now;
74         uint cows_count = users_cows[msg.sender];
75         
76         uint index = msg.value/0.01 ether;
77         
78         for (uint i = 1; i <= index; i++) {
79             
80             cow_code++;
81             cows_count++;
82             user[keccak256(msg.sender) & keccak256(i)]=cows(cow_code,time,true,0,time);
83         }
84         users_cows[msg.sender] = cows_count;
85         rico.transfer(0.001 ether);
86     }    
87     
88     //доим корову
89     function MilkCow(address gamer) private {
90        
91         uint time= now;
92         uint time_milk;
93         
94         for (uint i=1; i<=users_cows[gamer]; i++) {
95             
96             //если корова пока жива тогда доим
97             if (user[keccak256(gamer) & keccak256(i)].cow_live==true) {
98                 
99                 //получаем время смерти коровы
100                 uint datedeadcow=user[keccak256(gamer) & keccak256(i)].date_buy+time_to_live;
101                
102                 //если время смерти коровы уже наступило
103                 if (time>=datedeadcow) {
104                     
105                     //получаем сколько доек мы пропустили
106                     time_milk=(time-user[keccak256(gamer) & keccak256(i)].date_milk)/time_to_milk;
107                     
108                     if (time_milk>=1) {
109                         //кидаем на склад молоко которое мы надоили за пропущенные дойки
110                         user[keccak256(gamer) & keccak256(i)].milk+=(volume_milk*time_milk);
111                         //убиваем корову
112                         user[keccak256(gamer) & keccak256(i)].cow_live=false;
113                         //устанавливаем последнее время доения
114                         user[keccak256(gamer) & keccak256(i)].date_milk+=(time_milk*time_to_milk);
115                     }
116                     
117                 } else {
118                     
119                     time_milk=(time-user[keccak256(gamer) & keccak256(i)].date_milk)/time_to_milk;
120                     
121                     if (time_milk>=1) {
122                         user[keccak256(gamer) & keccak256(i)].milk+=(volume_milk*time_milk);
123                         user[keccak256(gamer) & keccak256(i)].date_milk+=(time_milk*time_to_milk);
124                     }
125                 }
126             }
127         }
128     }    
129   
130     //продаем молоко, если указано 0 тогда все молоко, иначе сколько сколько указано
131     function saleMilk() public {
132         
133         //сколько будем продовать молока
134         uint milk_to_sale;
135         
136         //отгрузка молока возможно только при наличии телеги у фермера
137         if (telega[msg.sender]==true) {
138             
139             MilkCow(msg.sender);
140             
141             //Получаем количество коров у пользователя
142             uint cows_count = users_cows[msg.sender];            
143         
144             //обнуляем все молоко на продажу
145             milk_to_sale=0;
146 
147             for (uint i=1; i<=cows_count; i++) {
148 
149                 milk_to_sale += user[keccak256(msg.sender) & keccak256(i)].milk;
150                 //удаляем из анкеты все молоко
151                 user[keccak256(msg.sender) & keccak256(i)].milk = 0;
152             }
153             //отсылаем эфир за купленное молоко
154             uint a=milkcost*milk_to_sale;
155             msg.sender.transfer(milkcost*milk_to_sale);
156         }            
157     }
158             
159     //продаем корову от фермера фермеру, историю передачи всегда можно узнать из чтения бд
160     function TransferCow(address gamer, uint num_cow) public {
161         
162         //продавать разрешается только живую корову
163         if (user[keccak256(msg.sender) & keccak256(num_cow)].cow_live == true) {
164             
165             //получаем количество коров у покупателя
166             uint cows_count = users_cows[gamer];
167             
168             //создаем и заполняем анкету коровы для нового фермера, при этом молоко не передается
169             user[keccak256(gamer) & keccak256(cows_count)]=cows(user[keccak256(msg.sender) & keccak256(num_cow)].cow,
170             user[keccak256(msg.sender) & keccak256(num_cow)].date_buy,
171             user[keccak256(msg.sender) & keccak256(num_cow)].cow_live,0,now);
172             
173             //убиваем корову и прошлого фермера
174             user[keccak256(msg.sender) & keccak256(num_cow)].cow_live= false;
175             
176             users_cows[gamer] ++;
177         }
178     }
179     
180     //убиваем корову принудительно из движка
181     function DeadCow(address gamer, uint num_cow) public onlyOwner {
182        
183         //обновляем анкету коровы
184         user[keccak256(gamer) & keccak256(num_cow)].cow_live = false;
185     }  
186     
187     //Послать телегу фермеру
188     function TelegaSend(address gamer) public onlyOwner {
189        
190         //Послать телегу
191         telega[gamer] = true;
192        
193     }  
194     
195     //Вернуть деньги
196     function SendOwner() public onlyOwner {
197         msg.sender.transfer(this.balance);
198     }      
199     
200     //Послать телегу фермеру
201     function TelegaOut(address gamer) public onlyOwner {
202        
203         //Послать телегу
204         telega[gamer] = false;
205        
206     }  
207     
208     //Вывести сколько коров у фермера
209     function CountCow(address gamer) public view returns (uint) {
210         return users_cows[gamer];   
211     }
212 
213     //Вывести сколько коров у фермера
214     function StatusCow(address gamer, uint num_cow) public view returns (uint,uint,bool,uint,uint) {
215         return (user[keccak256(gamer) & keccak256(num_cow)].cow,
216         user[keccak256(gamer) & keccak256(num_cow)].date_buy,
217         user[keccak256(gamer) & keccak256(num_cow)].cow_live,
218         user[keccak256(gamer) & keccak256(num_cow)].milk,
219         user[keccak256(gamer) & keccak256(num_cow)].date_milk);   
220     }
221     
222     //Вывести наличие телеги у фермера
223     function Statustelega(address gamer) public view returns (bool) {
224         return telega[gamer];   
225     }    
226     
227 }