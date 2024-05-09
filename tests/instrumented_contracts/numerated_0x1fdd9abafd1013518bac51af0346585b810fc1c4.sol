1 pragma solidity ^0.4.8;
2 /*
3 AvatarNetwork Copyright
4 
5 https://avatarnetwork.io
6 https://avatar.blue
7 https://www.avatar-network.com
8 https://www.avatar-bank.com
9 */
10 
11 /* Родительский контракт */
12 contract Owned {
13 
14     /* Адрес владельца контракта*/
15     address owner;
16 
17     /* Конструктор контракта, вызывается при первом запуске */
18     function Owned() {
19         owner = msg.sender;
20     }
21 
22         /* Изменить владельца контракта, newOwner - адрес нового владельца */
23     function changeOwner(address newOwner) onlyowner {
24         owner = newOwner;
25     }
26 
27 
28     /* Модификатор для ограничения доступа к функциям только для владельца */
29     modifier onlyowner() {
30         if (msg.sender==owner) _;
31     }
32 
33     
34 }
35 
36 // Абстрактный контракт для токена стандарта ERC 20
37 // https://github.com/ethereum/EIPs/issues/20
38 contract Token is Owned {
39 
40     /// Общее кол-во токенов
41     uint256 public totalSupply;
42 
43     /// @param _owner адрес, с которого будет получен баланс
44     /// @return Баланс
45     function balanceOf(address _owner) constant returns (uint256 balance);
46 
47     /// @notice Отправить кол-во `_value` токенов на адрес `_to` с адреса `msg.sender`
48     /// @param _to Адрес получателя
49     /// @param _value Кол-во токенов для отправки
50     /// @return Была ли отправка успешной или нет
51     function transfer(address _to, uint256 _value) returns (bool success);
52 
53     /// @notice Отправить кол-во `_value` токенов на адрес `_to` с адреса `_from` при условии что это подтверждено отправителем `_from`
54     /// @param _from Адрес отправителя
55     /// @param _to The address of the recipient
56     /// @param _value The amount of token to be transferred
57     /// @return Whether the transfer was successful or not
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
59 
60     /// @notice Вызывающий функции `msg.sender` подтверждает что с адреса `_spender` спишется `_value` токенов
61     /// @param _spender Адрес аккаунта, с которого возможно списать токены
62     /// @param _value Кол-во токенов к подтверждению для отправки
63     /// @return Было ли подтверждение успешным или нет
64     function approve(address _spender, uint256 _value) returns (bool success);
65 
66     /// @param _owner Адрес аккаунта владеющего токенами
67     /// @param _spender Адрес аккаунта, с которого возможно списать токены
68     /// @return Кол-во оставшихся токенов разрешённых для отправки
69     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
70 
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73 }
74 
75 /*
76 Контракт реализует ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
77 */
78 contract ERC20Token is Token
79 {
80 
81     function transfer(address _to, uint256 _value) returns (bool success)
82     {
83         //По-умолчанию предполагается, что totalSupply не может быть больше (2^256 - 1).
84         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
85             balances[msg.sender] -= _value;
86             balances[_to] += _value;
87             Transfer(msg.sender, _to, _value);
88             return true;
89         } else { return false; }
90     }
91 
92     function transferFrom(address _from, address _to, uint256 _value) returns (bool success)
93     {
94         //По-умолчанию предполагается, что totalSupply не может быть больше (2^256 - 1).
95         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
96             balances[_to] += _value;
97             balances[_from] -= _value;
98             allowed[_from][msg.sender] -= _value;
99             Transfer(_from, _to, _value);
100             return true;
101         } else { return false; }
102     }
103 
104     function balanceOf(address _owner) constant returns (uint256 balance)
105     {
106         return balances[_owner];
107     }
108 
109     function approve(address _spender, uint256 _value) returns (bool success)
110     {
111         allowed[msg.sender][_spender] = _value;
112         Approval(msg.sender, _spender, _value);
113         return true;
114     }
115 
116     function allowance(address _owner, address _spender) constant returns (uint256 remaining)
117     {
118       return allowed[_owner][_spender];
119     }
120 
121     mapping (address => uint256) balances;
122     mapping (address => mapping (address => uint256)) allowed;
123 }
124 
125 /* Основной контракт токена, наследует ERC20Token */
126 contract Meridian is ERC20Token
127 {
128 
129     function ()
130     {
131         // Если кто то пытается отправить эфир на адрес контракта, то будет вызвана ошибка.
132         throw;
133     }
134 
135     /* Публичные переменные токена */
136     string public name;                 // Название
137     uint8 public decimals;              // Сколько десятичных знаков
138     string public symbol;               // Идентификатор (трехбуквенный обычно)
139     string public version = '1.0';      // Версия
140 
141     function Meridian(
142             uint256 _initialAmount,
143             string _tokenName,
144             uint8 _decimalUnits,
145             string _tokenSymbol)
146     {
147         balances[msg.sender] = _initialAmount;  // Передача создателю всех выпущенных монет
148         totalSupply = _initialAmount;
149         name = _tokenName;
150         decimals = _decimalUnits;
151         symbol = _tokenSymbol;
152     }
153 
154     
155 
156     
157 }