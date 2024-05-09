1 pragma solidity ^0.4.8;
2 /*
3 
4 AvatarNetwork Copyright
5 
6 https://avatarnetwork.io
7 
8 Support: //producetoken.blockchain.social
9 
10 */
11 
12 /* Родительский контракт */
13 contract Owned {
14 
15     /* Адрес владельца контракта*/
16     address owner;
17 
18     /* Конструктор контракта, вызывается при первом запуске */
19     function Owned() {
20         owner = msg.sender;
21     }
22 
23         /* Изменить владельца контракта, newOwner - адрес нового владельца */
24     function changeOwner(address newOwner) onlyowner {
25         owner = newOwner;
26     }
27 
28 
29     /* Модификатор для ограничения доступа к функциям только для владельца */
30     modifier onlyowner() {
31         if (msg.sender==owner) _;
32     }
33 }
34 
35 // Абстрактный контракт для токена стандарта ERC 20
36 // https://github.com/ethereum/EIPs/issues/20
37 contract Token is Owned {
38 
39     /// Общее кол-во токенов
40     uint256 public totalSupply;
41 
42     /// @param _owner адрес, с которого будет получен баланс
43     /// @return Баланс
44     function balanceOf(address _owner) constant returns (uint256 balance);
45 
46     /// @notice Отправить кол-во `_value` токенов на адрес `_to` с адреса `msg.sender`
47     /// @param _to Адрес получателя
48     /// @param _value Кол-во токенов для отправки
49     /// @return Была ли отправка успешной или нет
50     function transfer(address _to, uint256 _value) returns (bool success);
51 
52     /// @notice Отправить кол-во `_value` токенов на адрес `_to` с адреса `_from` при условии что это подтверждено отправителем `_from`
53     /// @param _from Адрес отправителя
54     /// @param _to The address of the recipient
55     /// @param _value The amount of token to be transferred
56     /// @return Whether the transfer was successful or not
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
58 
59     /// @notice Вызывающий функции `msg.sender` подтверждает что с адреса `_spender` спишется `_value` токенов
60     /// @param _spender Адрес аккаунта, с которого возможно списать токены
61     /// @param _value Кол-во токенов к подтверждению для отправки
62     /// @return Было ли подтверждение успешным или нет
63     function approve(address _spender, uint256 _value) returns (bool success);
64 
65     /// @param _owner Адрес аккаунта владеющего токенами
66     /// @param _spender Адрес аккаунта, с которого возможно списать токены
67     /// @return Кол-во оставшихся токенов разрешённых для отправки
68     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
69 
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72 }
73 
74 /*
75 Контракт реализует ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
76 */
77 contract ERC20Token is Token
78 {
79 
80     function transfer(address _to, uint256 _value) returns (bool success)
81     {
82         //По-умолчанию предполагается, что totalSupply не может быть больше (2^256 - 1).
83         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
84             balances[msg.sender] -= _value;
85             balances[_to] += _value;
86             Transfer(msg.sender, _to, _value);
87             return true;
88         } else { return false; }
89     }
90 
91     function transferFrom(address _from, address _to, uint256 _value) returns (bool success)
92     {
93         //По-умолчанию предполагается, что totalSupply не может быть больше (2^256 - 1).
94         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
95             balances[_to] += _value;
96             balances[_from] -= _value;
97             allowed[_from][msg.sender] -= _value;
98             Transfer(_from, _to, _value);
99             return true;
100         } else { return false; }
101     }
102 
103     function balanceOf(address _owner) constant returns (uint256 balance)
104     {
105         return balances[_owner];
106     }
107 
108     function approve(address _spender, uint256 _value) returns (bool success)
109     {
110         allowed[msg.sender][_spender] = _value;
111         Approval(msg.sender, _spender, _value);
112         return true;
113     }
114 
115     function allowance(address _owner, address _spender) constant returns (uint256 remaining)
116     {
117       return allowed[_owner][_spender];
118     }
119 
120     mapping (address => uint256) balances;
121     mapping (address => mapping (address => uint256)) allowed;
122 }
123 
124 /* Основной контракт токена, наследует ERC20Token */
125 contract ElixirUSD is ERC20Token
126 {
127     bool public isTokenSale = true;
128     uint256 public price;
129     uint256 public limit;
130 
131     address walletOut = 0x420d6edab112cf3dcbdd808333e597623094218a;
132 
133     function getWalletOut() constant returns (address _to) {
134         return walletOut;
135     }
136 
137     function () external payable  {
138         if (isTokenSale == false) {
139             throw;
140         }
141 
142         uint256 tokenAmount = (msg.value  * 1000000000000000000) / price;
143 
144         if (balances[owner] >= tokenAmount && balances[msg.sender] + tokenAmount > balances[msg.sender]) {
145             if (balances[owner] - tokenAmount < limit) {
146                 throw;
147             }
148             balances[owner] -= tokenAmount;
149             balances[msg.sender] += tokenAmount;
150             Transfer(owner, msg.sender, tokenAmount);
151         } else {
152             throw;
153         }
154     }
155 
156     function stopSale() onlyowner {
157         isTokenSale = false;
158     }
159 
160     function startSale() onlyowner {
161         isTokenSale = true;
162     }
163 
164     function setPrice(uint256 newPrice) onlyowner {
165         price = newPrice;
166     }
167 
168     function setLimit(uint256 newLimit) onlyowner {
169         limit = newLimit;
170     }
171 
172     function setWallet(address _to) onlyowner {
173         walletOut = _to;
174     }
175 
176     function sendFund() onlyowner {
177         walletOut.send(this.balance);
178     }
179 
180     /* Публичные переменные токена */
181     string public name;                 // Название
182     uint8 public decimals;              // Сколько десятичных знаков
183     string public symbol;               // Идентификатор (трехбуквенный обычно)
184     string public version = '1.0';      // Версия
185 
186     function ElixirUSD()
187     {
188         totalSupply = 777000000000000000000000000000000;
189         balances[msg.sender] = 777000000000000000000000000000000;  // Передача создателю всех выпущенных монет
190         name = 'ElixirUSD';
191         decimals = 18;
192         symbol = 'ELCU';
193         price = 1694915254237290;
194         limit = 0;
195     }
196 
197     
198     /* Добавляет на счет токенов */
199     function add(uint256 _value) onlyowner returns (bool success)
200     {
201         if (balances[msg.sender] + _value <= balances[msg.sender]) {
202             return false;
203         }
204         totalSupply += _value;
205         balances[msg.sender] += _value;
206         return true;
207     }
208 
209 
210     
211     /* Уничтожает токены на счете владельца контракта */
212     function burn(uint256 _value) onlyowner returns (bool success)
213     {
214         if (balances[msg.sender] < _value) {
215             return false;
216         }
217         totalSupply -= _value;
218         balances[msg.sender] -= _value;
219         return true;
220     }
221 
222 
223 }