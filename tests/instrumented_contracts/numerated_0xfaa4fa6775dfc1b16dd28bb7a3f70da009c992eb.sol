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
14 
15 contract Game is ownerOnly {
16     
17     //Уникальный код коровы
18     uint cow_code;
19     
20     struct cows {
21         uint cow;
22         bool place;
23         uint date_buy;
24         bool cow_live;
25         uint milk;
26         uint date_milk;
27     } 
28     
29     //Маппинг количество коров у пользователя
30     mapping (address => uint) users_cows;
31     //Маппинг коровы у пользователя
32     mapping (bytes32 => cows) user;
33     //Маппинг телеги
34     mapping (address => bool) telega;
35     //Адрес кошелька движка
36     address multisig;
37     //Адрес кошелька rico
38     address rico;
39     
40     
41     //сколько корова дает молока за одну дойку
42     uint volume_milk;
43     //сколько нужно времени между доениями
44     uint time_to_milk;
45     //времмя жизни коровы
46     uint time_to_live;   
47         
48     //сколько стоит молоко в веях в розницу
49     uint milkcost;
50     
51 
52     //инициируем переменные движка
53     function Game() public {
54         
55         //устанавливаем кошелек движка для управления
56     	multisig = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
57         //устанавливаем кошелек движка для управления
58     	rico = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
59     	
60     	//Устанавливаем счетчик коров
61     	cow_code = 0;
62     	
63         //сколько литров дает корова на 5 минут
64         volume_milk = 20;
65         //через сколько секунд можно доить корову
66         time_to_milk = 60;
67         //сколько секунд живет корова - 30 мин
68         time_to_live = 1800;  
69         
70         //Сколько стоит продать молоко в розницу
71         milkcost = 0.001083333333333 ether;
72     }
73     
74     function pay(uint cor) public payable {
75        
76         if (cor==0) {
77             payCow();    
78         }
79         else {
80             payPlace(cor);
81         }
82     }        
83     
84     //покупаем коров только от движка
85     function payCow() private {
86        
87         uint time= now;
88         uint cows_count = users_cows[msg.sender];
89         
90         uint index = msg.value/0.09 ether;
91         
92         for (uint i = 1; i <= index; i++) {
93             
94             cow_code++;
95             cows_count++;
96             user[keccak256(msg.sender) & keccak256(i)]=cows(cow_code,false,time,true,0,time);
97         }
98         users_cows[msg.sender] = cows_count;
99     }    
100     
101     //покупаем поле
102     function payPlace(uint cor) private {
103 
104         uint index = msg.value/0.01 ether;
105         user[keccak256(msg.sender) & keccak256(cor)].place=true;
106         rico.transfer(msg.value);
107     }        
108     
109     
110     
111     //доим корову
112     function MilkCow(address gamer) private {
113        
114         uint time= now;
115         uint time_milk;
116         
117         //получеем количество коров пользователя
118         uint cows_count = users_cows[gamer];
119         
120         for (uint i=1; i<=cows_count; i++) {
121             
122             //получеем анкету коровы
123             cows tmp = user[keccak256(gamer) & keccak256(i)];
124             
125             //если корова пока жива тогда доим
126             if (tmp.cow_live==true && tmp.place) {
127                 
128                 //получаем время смерти коровы
129                 uint datedeadcow=tmp.date_buy+time_to_live;
130                
131                 //если время смерти коровы уже наступило
132                 if (time>=datedeadcow) {
133                     
134                     //получаем сколько доек мы пропустили
135                     time_milk=(time-tmp.date_milk)/time_to_milk;
136                     
137                     if (time_milk>=1) {
138                         //кидаем на склад молоко которое мы надоили за пропущенные дойки
139                         tmp.milk+=(volume_milk*time_milk);
140                         //убиваем корову
141                         tmp.cow_live=false;
142                         //устанавливаем последнее время доения
143                         tmp.date_milk+=time_milk*time_to_milk;
144                     }
145                     
146                 } else {
147                     
148                     time_milk=(time-tmp.date_milk)/time_to_milk;
149                     
150                     if (time_milk>=1) {
151                         tmp.milk+=volume_milk*time_milk;
152                         tmp.date_milk+=time_milk*time_to_milk;
153                     }
154                 }
155            
156                 //обновляем анкету коровы
157                 user[keccak256(gamer) & keccak256(i)] = tmp;
158             }
159         }
160     }    
161   
162     //продаем молоко, если указано 0 тогда все молоко, иначе сколько сколько указано
163     function saleMilk(uint vol, uint num_cow) public {
164         
165         //сколько будем продовать молока
166         uint milk_to_sale;
167         
168         //отгрузка молока возможно только при наличии телеги у фермера
169         if (telega[msg.sender]==true) {
170             
171             MilkCow(msg.sender);
172             
173             //Получаем количество коров у пользователя
174             uint cows_count = users_cows[msg.sender];            
175         
176             //обнуляем все молоко на продажу
177             milk_to_sale=0;
178             
179             //если мы продаем молоко всех коров
180             if (num_cow==0) {
181                 
182                 for (uint i=1; i<=cows_count; i++) {
183                     
184                     if (user[keccak256(msg.sender) & keccak256(i)].place) {
185                         
186                         milk_to_sale += user[keccak256(msg.sender) & keccak256(i)].milk;
187                         //удаляем из анкеты все молоко
188                         user[keccak256(msg.sender) & keccak256(i)].milk = 0;
189                     }
190                 }
191             }
192             //если указана корова которую мы должны подоить
193             else {
194                 
195                 //получеем анкету коровы
196                 cows tmp = user[keccak256(msg.sender) & keccak256(num_cow)];
197                             
198                 //если будем продовать все молоко
199                 if (vol==0) {
200                 
201                     //запоминаем сколько молока продавать
202                     milk_to_sale = tmp.milk;
203                     //удаляем из анкеты все молоко
204                     tmp.milk = 0;    
205                 } 
206                 //если будем продовать часть молока
207                 else {
208                         
209                     //если молока которого хочет продать фермер меньше чем есть
210                     if (tmp.milk>vol) {
211                     
212                         milk_to_sale = vol;
213                         tmp.milk -= milk_to_sale;
214                     } 
215                     
216                     //если молока который хочет продать фермер недостаточно, то продаем только то что есть
217                     else {
218                         
219                         milk_to_sale = tmp.milk;
220                         tmp.milk = 0;
221                     }                        
222                 } 
223                 
224                 user[keccak256(msg.sender) & keccak256(num_cow)] = tmp;
225             }
226             
227             //отсылаем эфир за купленное молоко
228             msg.sender.transfer(milkcost*milk_to_sale);
229         }            
230     }
231             
232     //продаем корову от фермера фермеру, историю передачи всегда можно узнать из чтения бд
233     function TransferCow(address gamer, uint num_cow) public {
234        
235         //получеем анкету коровы
236         cows cow= user[keccak256(msg.sender) & keccak256(num_cow)];
237         
238         //продавать разрешается только живую корову
239         if (cow.cow_live == true && cow.place==true) {
240             
241             //получаем количество коров у покупателя
242             uint cows_count = users_cows[gamer];
243             
244             //увеличиваем счетчик коров покупателя
245             cows_count++;
246             
247             //создаем и заполняем анкету коровы для нового фермера, при этом молоко не передается
248             user[keccak256(gamer) & keccak256(cows_count)]=cows(cow.cow,true,cow.date_buy,cow.cow_live,0,now);
249             
250             //убиваем корову и прошлого фермера
251             cow.cow_live= false;
252             //обновляем анкету коровы предыдущего фермера
253             user[keccak256(msg.sender) & keccak256(num_cow)] = cow;
254             
255             users_cows[gamer] = cows_count;
256         }
257     }
258     
259     //убиваем корову принудительно из движка
260     function DeadCow(address gamer, uint num_cow) public onlyOwner {
261        
262         //обновляем анкету коровы
263         user[keccak256(gamer) & keccak256(num_cow)].cow_live = false;
264     }  
265     
266     //Послать телегу фермеру
267     function TelegaSend(address gamer) public onlyOwner {
268        
269         //Послать телегу
270         telega[gamer] = true;
271        
272     }  
273     
274     //Вернуть деньги
275     function SendOwner() public onlyOwner {
276         msg.sender.transfer(this.balance);
277     }      
278     
279     //Послать телегу фермеру
280     function TelegaOut(address gamer) public onlyOwner {
281        
282         //Послать телегу
283         telega[gamer] = false;
284        
285     }  
286     
287     //Вывести сколько коров у фермера
288     function CountCow(address gamer) public view returns (uint) {
289         return users_cows[gamer];   
290     }
291 
292     //Вывести сколько коров у фермера
293     function StatusCow(address gamer, uint num_cow) public view returns (uint,bool,uint,bool,uint,uint) {
294         return (user[keccak256(gamer) & keccak256(num_cow)].cow,
295         user[keccak256(gamer) & keccak256(num_cow)].place,
296         user[keccak256(gamer) & keccak256(num_cow)].date_buy,
297         user[keccak256(gamer) & keccak256(num_cow)].cow_live,
298         user[keccak256(gamer) & keccak256(num_cow)].milk,
299         user[keccak256(gamer) & keccak256(num_cow)].date_milk);   
300     }
301     
302     //Вывести наличие телеги у фермера
303     function Statustelega(address gamer) public view returns (bool) {
304         return telega[gamer];   
305     }    
306     
307 }