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
20     
21 
22     /* Модификатор для ограничения доступа к функциям только для владельца */
23     modifier onlyowner() {
24         if (msg.sender==owner) _;
25     }
26 }
27 
28 // Абстрактный контракт для токена стандарта ERC 20
29 // https://github.com/ethereum/EIPs/issues/20
30 contract Token is Owned {
31 
32     /// Общее кол-во токенов
33     uint256 public totalSupply;
34 
35     /// @param _owner адрес, с которого будет получен баланс
36     /// @return Баланс
37     function balanceOf(address _owner) constant returns (uint256 balance);
38 
39     /// @notice Отправить кол-во `_value` токенов на адрес `_to` с адреса `msg.sender`
40     /// @param _to Адрес получателя
41     /// @param _value Кол-во токенов для отправки
42     /// @return Была ли отправка успешной или нет
43     function transfer(address _to, uint256 _value) returns (bool success);
44 
45     /// @notice Отправить кол-во `_value` токенов на адрес `_to` с адреса `_from` при условии что это подтверждено отправителем `_from`
46     /// @param _from Адрес отправителя
47     /// @param _to The address of the recipient
48     /// @param _value The amount of token to be transferred
49     /// @return Whether the transfer was successful or not
50     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
51 
52     /// @notice Вызывающий функции `msg.sender` подтверждает что с адреса `_spender` спишется `_value` токенов
53     /// @param _spender Адрес аккаунта, с которого возможно списать токены
54     /// @param _value Кол-во токенов к подтверждению для отправки
55     /// @return Было ли подтверждение успешным или нет
56     function approve(address _spender, uint256 _value) returns (bool success);
57 
58     /// @param _owner Адрес аккаунта владеющего токенами
59     /// @param _spender Адрес аккаунта, с которого возможно списать токены
60     /// @return Кол-во оставшихся токенов разрешённых для отправки
61     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
62 
63     event Transfer(address indexed _from, address indexed _to, uint256 _value);
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65 }
66 
67 /*
68 Контракт реализует ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
69 */
70 contract ERC20Token is Token
71 {
72 
73     function transfer(address _to, uint256 _value) returns (bool success)
74     {
75         //По-умолчанию предполагается, что totalSupply не может быть больше (2^256 - 1).
76         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
77             balances[msg.sender] -= _value;
78             balances[_to] += _value;
79             Transfer(msg.sender, _to, _value);
80             return true;
81         } else { return false; }
82     }
83 
84     function transferFrom(address _from, address _to, uint256 _value) returns (bool success)
85     {
86         //По-умолчанию предполагается, что totalSupply не может быть больше (2^256 - 1).
87         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
88             balances[_to] += _value;
89             balances[_from] -= _value;
90             allowed[_from][msg.sender] -= _value;
91             Transfer(_from, _to, _value);
92             return true;
93         } else { return false; }
94     }
95 
96     function balanceOf(address _owner) constant returns (uint256 balance)
97     {
98         return balances[_owner];
99     }
100 
101     function approve(address _spender, uint256 _value) returns (bool success)
102     {
103         allowed[msg.sender][_spender] = _value;
104         Approval(msg.sender, _spender, _value);
105         return true;
106     }
107 
108     function allowance(address _owner, address _spender) constant returns (uint256 remaining)
109     {
110       return allowed[_owner][_spender];
111     }
112 
113     mapping (address => uint256) balances;
114     mapping (address => mapping (address => uint256)) allowed;
115 }
116 
117 /* Основной контракт токена, наследует ERC20Token */
118 contract MegaWattContract is ERC20Token
119 {
120     bool public isTokenSale = true;
121     uint256 public price;
122     uint256 public limit;
123 
124     address walletOut = 0x562d88c226c850549842f42fcb4ff048f1072340;
125 
126     function getWalletOut() constant returns (address _to) {
127         return walletOut;
128     }
129 
130     function () external payable  {
131         if (isTokenSale == false) {
132             throw;
133         }
134 
135         uint256 tokenAmount = (msg.value  * 1000000000) / price;
136 
137         if (balances[owner] >= tokenAmount && balances[msg.sender] + tokenAmount > balances[msg.sender]) {
138             if (balances[owner] - tokenAmount < limit) {
139                 throw;
140             }
141             balances[owner] -= tokenAmount;
142             balances[msg.sender] += tokenAmount;
143             Transfer(owner, msg.sender, tokenAmount);
144         } else {
145             throw;
146         }
147     }
148 
149     function stopSale() onlyowner {
150         isTokenSale = false;
151     }
152 
153     function startSale() onlyowner {
154         isTokenSale = true;
155     }
156 
157     function setPrice(uint256 newPrice) onlyowner {
158         price = newPrice;
159     }
160 
161     function setLimit(uint256 newLimit) onlyowner {
162         limit = newLimit;
163     }
164 
165     function setWallet(address _to) onlyowner {
166         walletOut = _to;
167     }
168 
169     function sendFund() onlyowner {
170         walletOut.send(this.balance);
171     }
172 
173     /* Публичные переменные токена */
174     string public name;                 // Название
175     uint8 public decimals;              // Сколько десятичных знаков
176     string public symbol;               // Идентификатор (трехбуквенный обычно)
177     string public version = '1.0';      // Версия
178 
179     function MegaWattContract()
180     {
181         totalSupply = 380000000000000;
182         balances[msg.sender] = 380000000000000;  // Передача создателю всех выпущенных монет
183         name = 'MegaWattContract';
184         decimals = 6;
185         symbol = 'MWC';
186         price = 119047619047619;
187         limit = 0;
188     }
189 
190     
191     /* Добавляет на счет токенов */
192     function add(uint256 _value) onlyowner returns (bool success)
193     {
194         if (balances[msg.sender] + _value <= balances[msg.sender]) {
195             return false;
196         }
197         totalSupply += _value;
198         balances[msg.sender] += _value;
199         return true;
200     }
201 
202 
203     
204 }