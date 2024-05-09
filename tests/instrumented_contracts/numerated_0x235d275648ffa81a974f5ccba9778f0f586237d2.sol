1 pragma solidity ^0.4.11;
2 
3 
4 contract owned {
5 
6     address public owner;
7 	
8     function owned() payable { owner = msg.sender; }
9     
10     modifier onlyOwner { require(owner == msg.sender); _; }
11 
12  }
13 
14 
15 	
16 contract ARCEON is owned {
17 
18     using SafeMath for uint256;
19     string public name;
20     string public symbol;
21     uint8 public decimals;
22     uint256 public totalSupply;
23 	address public owner;
24 	
25 
26     /* Мэппинги */
27     mapping (address => uint256) public balanceOf; //балансы пользователей
28 	mapping (address => uint256) public freezeOf; // мэппинг замороженных токенов
29     mapping (address => mapping (address => uint256)) public allowance; // мэппинг делегированных токенов
30 
31     /* Событие при успешном выполнении функции transfer */
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     /* Событие при выполнении функции сжигания токенов Овнера */
35     event Burn(address indexed from, uint256 value);
36 	
37 	
38 	/* Событие при выполнении функции заморозки токенов */
39     event Freeze(address indexed from, uint256 value);
40 	
41 	/* Событие при выполнении функции разморозки токенов */
42     event Unfreeze(address indexed from, uint256 value);
43 	
44 
45     /* Конструктор */
46 	
47     function ArCoin (
48     
49         uint256 initialSupply,
50         string tokenName,
51         uint8 decimalUnits,
52         string tokenSymbol
53         
54         
55         ) onlyOwner {
56 		
57 		
58 
59 		
60 		owner = msg.sender; // Владелец == отправитель
61 		name = tokenName; // Устанавливается имя токена
62         symbol = tokenSymbol; // Устанавливается символ токена
63         decimals = decimalUnits; // Кол-во нулей
64 		
65         balanceOf[owner] = initialSupply.safeDiv(2); // Эти токены принадлежат создателю
66 		balanceOf[this]  = initialSupply.safeDiv(2); // Эти токены принадлежат контракту
67         totalSupply = initialSupply; // Устанавливается общая эмиссия токенов
68 		Transfer(this, owner, balanceOf[owner]); //Посылаем контракту половину
69 		
70 		
71         
72 		
73     }  
74 	
75 
76     /* Функция для отправки токенов */
77     function transfer(address _to, uint256 _value) {
78 	    
79         require (_to != 0x0); // Запрет на передачу на адрес 0x0. Проверка что соответствует ETH-адресу
80 		require (_value > 0); 
81         require (balanceOf[msg.sender] > _value); // Проверка что у отправителя <= кол-ву токенов
82         require (balanceOf[_to] + _value > balanceOf[_to]); // Проверка на переполнение
83         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);// Вычитает токены у отправителя
84         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);//Прибавляет токены получателю
85         Transfer(msg.sender, _to, _value);// Запускается событие Transfer
86     }
87 
88     /* Функция для одобрения делегирования токенов */
89     function approve(address _spender, uint256 _value)
90         returns (bool success) {
91 		
92 		require (_value > 0); 
93         allowance[msg.sender][_spender] = _value;
94         return true;
95     }   
96 
97     /* Функция для отправки делегированных токенов */
98     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
99 	    
100         require(_to != 0x0);
101 		require (_value > 0); 
102         require (balanceOf[_from] > _value);
103         require (balanceOf[_to] + _value > balanceOf[_to]);
104         require (_value < allowance[_from][msg.sender]);
105         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
106         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
107         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
108         Transfer(_from, _to, _value);
109         return true;
110     }
111 
112 	/* Функция для сжигания токенов */
113     function burn(uint256 _value) onlyOwner returns (bool success) {
114 	    
115         require (balanceOf[msg.sender] > _value); //проверка что на балансе есть нужное кол-во токенов
116 		require (_value > 0); 
117         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);// вычитание
118         totalSupply = SafeMath.safeSub(totalSupply,_value);// Новое значение totalSupply
119         Burn(msg.sender, _value);// Запуск события Burn
120         return true;
121     
122     }
123 	
124 	 /* Функция заморозки токенов */
125 	function freeze(uint256 _value) onlyOwner returns (bool success)   {
126 	    
127         require (balanceOf[msg.sender] > _value); //проверка что на балансе есть нужное кол-во токенов
128 		require (_value > 0); 
129         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Уменьшаем в мэппинге balanceOf
130         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value); // Прибавляем в мэппинг freezeOf
131         Freeze(msg.sender, _value);
132         return true;
133     }
134 	
135 	/* Функция разморозки токенов */
136 	function unfreeze(uint256 _value) onlyOwner returns (bool success) {
137 	   
138         require(freezeOf[msg.sender] > _value);
139 		require (_value > 0);
140         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);
141 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
142         Unfreeze(msg.sender, _value);
143         return true;
144     }
145 	
146 	
147 	            function  BalanceContract() public constant returns (uint256 BalanceContract) {
148         BalanceContract = balanceOf[this];
149                 return BalanceContract;
150 	            }
151 				
152 				function  BalanceOwner() public constant returns (uint256 BalanceOwner) {
153         BalanceOwner = balanceOf[msg.sender];
154                 return BalanceOwner;
155 				}
156 		
157 		
158 	
159 	//Позволяет создателю выводить хранящиеся на адрес контракта Эфиры и токены
160 	
161 	
162 	function withdrawEther () public onlyOwner {
163 	    
164         owner.transfer(this.balance);
165     }
166 	
167 	function () payable {
168         require(balanceOf[this] > 0);
169        uint256 tokensPerOneEther = 20000;
170         uint256 tokens = tokensPerOneEther * msg.value / 1000000000000000000;
171         if (tokens > balanceOf[this]) {
172             tokens = balanceOf[this];
173             uint valueWei = tokens * 1000000000000000000 / tokensPerOneEther;
174             msg.sender.transfer(msg.value - valueWei);
175         }
176         require(tokens > 0);
177         balanceOf[msg.sender] += tokens;
178         balanceOf[this] -= tokens;
179         Transfer(this, msg.sender, tokens);
180     }
181 }
182 
183 /**
184  * Безопасные математические операции
185  */
186  
187 	
188 library  SafeMath {
189 	// умножение
190   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
191     uint256 c = a * b;
192     assert(a == 0 || c / a == b);
193     return c;
194   }
195 	//деление
196   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
197     assert(b > 0);
198     uint256 c = a / b;
199     assert(a == b * c + a % b);
200     return c;
201   }
202 	//вычитание
203   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
204     assert(b <= a);
205     return a - b;
206   }
207 	//сложение
208   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
209     uint256 c = a + b;
210     assert(c>=a && c>=b);
211     return c;
212   }
213 
214   function assert(bool assertion) internal {
215     if (!assertion) {
216       throw;
217     }
218   }
219 }