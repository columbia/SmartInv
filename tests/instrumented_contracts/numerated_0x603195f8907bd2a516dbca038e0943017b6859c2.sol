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
122 contract ArmmoneyTokenLive is ERC20Token
123 {
124 
125     bool public isTokenSale = true;
126     uint256 public price;
127     uint256 public limit;
128 
129     address walletOut = 0xd1d02b31bb863e73058af34d3b9fb8b96f34bae2;
130 
131     function getWalletOut() constant returns (address _to) {
132         return walletOut;
133     }
134 
135     function () external payable  {
136         if (isTokenSale == false) {
137             throw;
138         }
139 
140         uint256 tokenAmount = (msg.value  * 1000000000000000000) / price;
141 
142         if (balances[owner] >= tokenAmount && balances[msg.sender] + tokenAmount > balances[msg.sender]) {
143             if (balances[owner] - tokenAmount < limit) {
144                 throw;
145             }
146             balances[owner] -= tokenAmount;
147             balances[msg.sender] += tokenAmount;
148             Transfer(owner, msg.sender, tokenAmount);
149         } else {
150             throw;
151         }
152     }
153 
154     function stopSale() onlyowner {
155         isTokenSale = false;
156     }
157 
158     function startSale() onlyowner {
159         isTokenSale = true;
160     }
161 
162     function setPrice(uint256 newPrice) onlyowner {
163         price = newPrice;
164     }
165 
166     function setLimit(uint256 newLimit) onlyowner {
167         limit = newLimit;
168     }
169 
170     function setWallet(address _to) onlyowner {
171         walletOut = _to;
172     }
173 
174     function sendFund() onlyowner {
175         walletOut.send(this.balance);
176     }
177 
178     /* Публичные переменные токена */
179     string public name;                 // Название
180     uint8 public decimals;              // Сколько десятичных знаков
181     string public symbol;               // Идентификатор (трехбуквенный обычно)
182     string public version = '1.0';      // Версия
183 
184     function ArmmoneyTokenLive()
185     {
186         totalSupply = 1000000000000000000000000000;
187         balances[msg.sender] = 1000000000000000000000000000;  // Передача создателю всех выпущенных монет
188         name = 'ArmmoneyTokenLive';
189         decimals = 18;
190         symbol = 'AMTL';
191         price = 148957298907646;
192         limit = 0;
193     }
194 
195     
196 
197     
198     /* Уничтожает токены на счете владельца контракта */
199     function burn(uint256 _value) onlyowner returns (bool success)
200     {
201         if (balances[msg.sender] < _value) {
202             return false;
203         }
204         totalSupply -= _value;
205         balances[msg.sender] -= _value;
206         return true;
207     }
208 
209 
210 }