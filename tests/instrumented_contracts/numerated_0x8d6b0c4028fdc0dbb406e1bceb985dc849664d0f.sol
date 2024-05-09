1 pragma solidity ^0.4.8;
2 /*
3 AvatarNetwork Copyright
4 
5 https://avatarnetwork.io
6 
7 */
8 
9 /* Родительский контракт */
10 contract Owned {
11 
12     /* Адрес владельца контракта*/
13     address owner;
14 
15     /* Конструктор контракта, вызывается при первом запуске */
16     function Owned() {
17         owner = msg.sender;
18     }
19 
20         /* Изменить владельца контракта, newOwner - адрес нового владельца */
21     function changeOwner(address newOwner) onlyowner {
22         owner = newOwner;
23     }
24 
25 
26     /* Модификатор для ограничения доступа к функциям только для владельца */
27     modifier onlyowner() {
28         if (msg.sender==owner) _;
29     }
30 }
31 
32 // Абстрактный контракт для токена стандарта ERC 20
33 // https://github.com/ethereum/EIPs/issues/20
34 contract Token is Owned {
35 
36     /// Общее кол-во токенов
37     uint256 public totalSupply;
38 
39     /// @param _owner адрес, с которого будет получен баланс
40     /// @return Баланс
41     function balanceOf(address _owner) constant returns (uint256 balance);
42 
43     /// @notice Отправить кол-во `_value` токенов на адрес `_to` с адреса `msg.sender`
44     /// @param _to Адрес получателя
45     /// @param _value Кол-во токенов для отправки
46     /// @return Была ли отправка успешной или нет
47     function transfer(address _to, uint256 _value) returns (bool success);
48 
49     /// @notice Отправить кол-во `_value` токенов на адрес `_to` с адреса `_from` при условии что это подтверждено отправителем `_from`
50     /// @param _from Адрес отправителя
51     /// @param _to The address of the recipient
52     /// @param _value The amount of token to be transferred
53     /// @return Whether the transfer was successful or not
54     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
55 
56     /// @notice Вызывающий функции `msg.sender` подтверждает что с адреса `_spender` спишется `_value` токенов
57     /// @param _spender Адрес аккаунта, с которого возможно списать токены
58     /// @param _value Кол-во токенов к подтверждению для отправки
59     /// @return Было ли подтверждение успешным или нет
60     function approve(address _spender, uint256 _value) returns (bool success);
61 
62     /// @param _owner Адрес аккаунта владеющего токенами
63     /// @param _spender Адрес аккаунта, с которого возможно списать токены
64     /// @return Кол-во оставшихся токенов разрешённых для отправки
65     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
66 
67     event Transfer(address indexed _from, address indexed _to, uint256 _value);
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69 }
70 
71 /*
72 Контракт реализует ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
73 */
74 contract ERC20Token is Token
75 {
76 
77     function transfer(address _to, uint256 _value) returns (bool success)
78     {
79         //По-умолчанию предполагается, что totalSupply не может быть больше (2^256 - 1).
80         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
81             balances[msg.sender] -= _value;
82             balances[_to] += _value;
83             Transfer(msg.sender, _to, _value);
84             return true;
85         } else { return false; }
86     }
87 
88     function transferFrom(address _from, address _to, uint256 _value) returns (bool success)
89     {
90         //По-умолчанию предполагается, что totalSupply не может быть больше (2^256 - 1).
91         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
92             balances[_to] += _value;
93             balances[_from] -= _value;
94             allowed[_from][msg.sender] -= _value;
95             Transfer(_from, _to, _value);
96             return true;
97         } else { return false; }
98     }
99 
100     function balanceOf(address _owner) constant returns (uint256 balance)
101     {
102         return balances[_owner];
103     }
104 
105     function approve(address _spender, uint256 _value) returns (bool success)
106     {
107         allowed[msg.sender][_spender] = _value;
108         Approval(msg.sender, _spender, _value);
109         return true;
110     }
111 
112     function allowance(address _owner, address _spender) constant returns (uint256 remaining)
113     {
114       return allowed[_owner][_spender];
115     }
116 
117     mapping (address => uint256) balances;
118     mapping (address => mapping (address => uint256)) allowed;
119 }
120 
121 /* Основной контракт токена, наследует ERC20Token */
122 contract ArmMoneyliFe is ERC20Token
123 {
124     bool public isTokenSale = true;
125     uint256 public price;
126     uint256 public limit;
127 
128     address walletOut = 0xde8c00ae50b203ac1091266d5b207fbc59be5bc4;
129 
130     function getWalletOut() constant returns (address _to) {
131         return walletOut;
132     }
133 
134     function () external payable  {
135         if (isTokenSale == false) {
136             throw;
137         }
138 
139         uint256 tokenAmount = (msg.value  * 1000000000000000000) / price;
140 
141         if (balances[owner] >= tokenAmount && balances[msg.sender] + tokenAmount > balances[msg.sender]) {
142             if (balances[owner] - tokenAmount < limit) {
143                 throw;
144             }
145             balances[owner] -= tokenAmount;
146             balances[msg.sender] += tokenAmount;
147             Transfer(owner, msg.sender, tokenAmount);
148         } else {
149             throw;
150         }
151     }
152 
153     function stopSale() onlyowner {
154         isTokenSale = false;
155     }
156 
157     function startSale() onlyowner {
158         isTokenSale = true;
159     }
160 
161     function setPrice(uint256 newPrice) onlyowner {
162         price = newPrice;
163     }
164 
165     function setLimit(uint256 newLimit) onlyowner {
166         limit = newLimit;
167     }
168 
169     function setWallet(address _to) onlyowner {
170         walletOut = _to;
171     }
172 
173     function sendFund() onlyowner {
174         walletOut.send(this.balance);
175     }
176 
177     /* Публичные переменные токена */
178     string public name;                 // Название
179     uint8 public decimals;              // Сколько десятичных знаков
180     string public symbol;               // Идентификатор (трехбуквенный обычно)
181     string public version = '1.0';      // Версия
182 
183     function ArmMoneyliFe()
184     {
185         totalSupply = 1000000000000000000000000000;
186         balances[msg.sender] = 1000000000000000000000000000;  // Передача создателю всех выпущенных монет
187         name = 'ArmMoneyliFe';
188         decimals = 18;
189         symbol = 'AMF';
190         price = 2188183807439824;
191         limit = 0;
192     }
193 
194     
195     /* Добавляет на счет токенов */
196     function add(uint256 _value) onlyowner returns (bool success)
197     {
198         if (balances[msg.sender] + _value <= balances[msg.sender]) {
199             return false;
200         }
201         totalSupply += _value;
202         balances[msg.sender] += _value;
203         return true;
204     }
205 
206 
207     
208 }