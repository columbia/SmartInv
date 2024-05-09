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
21         bool place;
22         uint date_buy;
23         bool cow_live;
24         uint milk;
25         uint date_milk;
26     } 
27     
28     //Маппинг количество коров у пользователя
29     mapping (address => uint) users_cows;
30     //Маппинг коровы у пользователя
31     mapping (bytes32 => cows) user;
32     //Маппинг телеги
33     mapping (address => bool) telega;
34     //Адрес кошелька rico
35     address rico;
36     
37     //сколько корова дает молока за одну дойку
38     uint volume_milk;
39     //сколько нужно времени между доениями
40     uint time_to_milk;
41     //времмя жизни коровы
42     uint time_to_live;   
43         
44     //сколько стоит молоко в веях в розницу
45     uint milkcost;
46     
47     //инициируем переменные движка
48     function Game() public {
49         
50         //устанавливаем кошелек движка для управления
51     	rico = 0xb5F60D78F15b73DC2D2083571d0EEa70d35b9D28;
52     	
53     	//Устанавливаем счетчик коров
54     	cow_code = 0;
55     	
56         //сколько литров дает корова на 5 минут
57         volume_milk = 20;
58         //через сколько секунд можно доить корову
59         time_to_milk = 60;
60         //сколько секунд живет корова - 30 мин
61         time_to_live = 1800;  
62         
63         //Сколько стоит продать молоко в розницу
64         milkcost = 0.001083333333333 ether;
65     }
66     
67     function pay() public payable {
68         payCow();
69     }        
70     
71     //покупаем коров только от движка
72     function payCow() private {
73        
74         uint time= now;
75         uint cows_count = users_cows[msg.sender];
76         
77         uint index = msg.value/0.1 ether;
78         
79         for (uint i = 1; i <= index; i++) {
80             
81             cow_code++;
82             cows_count++;
83             user[keccak256(msg.sender) & keccak256(i)]=cows(cow_code,true,time,true,0,time);
84         }
85         users_cows[msg.sender] = cows_count;
86         rico.transfer(0.01 ether);
87     }    
88     
89     //доим корову
90     function MilkCow(address gamer) private {
91        
92         uint time= now;
93         uint time_milk;
94         
95         for (uint i=1; i<=users_cows[gamer]; i++) {
96             
97             //если корова пока жива тогда доим
98             if (user[keccak256(gamer) & keccak256(i)].cow_live==true && user[keccak256(gamer) & keccak256(i)].place) {
99                 
100                 //получаем время смерти коровы
101                 uint datedeadcow=user[keccak256(gamer) & keccak256(i)].date_buy+time_to_live;
102                
103                 //если время смерти коровы уже наступило
104                 if (time>=datedeadcow) {
105                     
106                     //получаем сколько доек мы пропустили
107                     time_milk=(time-user[keccak256(gamer) & keccak256(i)].date_milk)/time_to_milk;
108                     
109                     if (time_milk>=1) {
110                         //кидаем на склад молоко которое мы надоили за пропущенные дойки
111                         user[keccak256(gamer) & keccak256(i)].milk+=(volume_milk*time_milk);
112                         //убиваем корову
113                         user[keccak256(gamer) & keccak256(i)].cow_live=false;
114                         //устанавливаем последнее время доения
115                         user[keccak256(gamer) & keccak256(i)].date_milk+=(time_milk*time_to_milk);
116                     }
117                     
118                 } else {
119                     
120                     time_milk=(time-user[keccak256(gamer) & keccak256(i)].date_milk)/time_to_milk;
121                     
122                     if (time_milk>=1) {
123                         user[keccak256(gamer) & keccak256(i)].milk+=(volume_milk*time_milk);
124                         user[keccak256(gamer) & keccak256(i)].date_milk+=(time_milk*time_to_milk);
125                     }
126                 }
127             }
128         }
129     }    
130   
131     //продаем молоко, если указано 0 тогда все молоко, иначе сколько сколько указано
132     function saleMilk() public {
133         
134         //сколько будем продовать молока
135         uint milk_to_sale;
136         
137         //отгрузка молока возможно только при наличии телеги у фермера
138         if (telega[msg.sender]==true) {
139             
140             MilkCow(msg.sender);
141             
142             //Получаем количество коров у пользователя
143             uint cows_count = users_cows[msg.sender];            
144         
145             //обнуляем все молоко на продажу
146             milk_to_sale=0;
147 
148             for (uint i=1; i<=cows_count; i++) {
149 
150                 milk_to_sale += user[keccak256(msg.sender) & keccak256(i)].milk;
151                 //удаляем из анкеты все молоко
152                 user[keccak256(msg.sender) & keccak256(i)].milk = 0;
153             }
154             //отсылаем эфир за купленное молоко
155             msg.sender.transfer(milkcost*milk_to_sale);
156         }            
157     }
158             
159     //продаем корову от фермера фермеру, историю передачи всегда можно узнать из чтения бд
160     function TransferCow(address gamer, uint num_cow) public {
161         
162         //продавать разрешается только живую корову
163         if (user[keccak256(msg.sender) & keccak256(num_cow)].cow_live == true && user[keccak256(msg.sender) & keccak256(num_cow)].place==true) {
164             
165             //получаем количество коров у покупателя
166             uint cows_count = users_cows[gamer];
167             
168             //создаем и заполняем анкету коровы для нового фермера, при этом молоко не передается
169             user[keccak256(gamer) & keccak256(cows_count)]=cows(user[keccak256(msg.sender) & keccak256(num_cow)].cow,
170             true,user[keccak256(msg.sender) & keccak256(num_cow)].date_buy,
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
214     function StatusCow(address gamer, uint num_cow) public view returns (uint,bool,uint,bool,uint,uint) {
215         return (user[keccak256(gamer) & keccak256(num_cow)].cow,
216         user[keccak256(gamer) & keccak256(num_cow)].place,
217         user[keccak256(gamer) & keccak256(num_cow)].date_buy,
218         user[keccak256(gamer) & keccak256(num_cow)].cow_live,
219         user[keccak256(gamer) & keccak256(num_cow)].milk,
220         user[keccak256(gamer) & keccak256(num_cow)].date_milk);   
221     }
222     
223     //Вывести наличие телеги у фермера
224     function Statustelega(address gamer) public view returns (bool) {
225         return telega[gamer];   
226     }    
227     
228 }