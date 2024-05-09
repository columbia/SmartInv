1 pragma solidity ^0.4.8;
2 /*
3 AvatarNetwork Copyright
4 */
5 
6 /* Родительский контракт */
7 contract Owned {
8 
9     /* Адрес владельца контракта*/
10     address owner;
11 
12     /* Конструктор контракта, вызывается при первом запуске */
13     function Owned() {
14         owner = msg.sender;
15     }
16 
17     /* Изменить владельца контракта, newOwner - адрес нового владельца */
18     function changeOwner(address newOwner) onlyowner {
19         owner = newOwner;
20     }
21 
22     /* Модификатор для ограничения доступа к функциям только для владельца */
23     modifier onlyowner() {
24         if (msg.sender==owner) _;
25     }
26 
27     /* Удалить контракт */
28     function kill() onlyowner {
29         if (msg.sender == owner) suicide(owner);
30     }
31 }
32 
33 // Абстрактный контракт для токена стандарта ERC 20
34 // https://github.com/ethereum/EIPs/issues/20
35 contract Token is Owned {
36 
37     /// Общее кол-во токенов
38     uint256 public totalSupply;
39 
40     /// @param _owner адрес, с которого будет получен баланс
41     /// @return Баланс
42     function balanceOf(address _owner) constant returns (uint256 balance);
43 
44     /// @notice Отправить кол-во `_value` токенов на адрес `_to` с адреса `msg.sender`
45     /// @param _to Адрес получателя
46     /// @param _value Кол-во токенов для отправки
47     /// @return Была ли отправка успешной или нет
48     function transfer(address _to, uint256 _value) returns (bool success);
49 
50     /// @notice Отправить кол-во `_value` токенов на адрес `_to` с адреса `_from` при условии что это подтверждено отправителем `_from`
51     /// @param _from Адрес отправителя
52     /// @param _to The address of the recipient
53     /// @param _value The amount of token to be transferred
54     /// @return Whether the transfer was successful or not
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
56 
57     /// @notice Вызывающий функции `msg.sender` подтверждает что с адреса `_spender` спишется `_value` токенов
58     /// @param _spender Адрес аккаунта, с которого возможно списать токены
59     /// @param _value Кол-во токенов к подтверждению для отправки
60     /// @return Было ли подтверждение успешным или нет
61     function approve(address _spender, uint256 _value) returns (bool success);
62 
63     /// @param _owner Адрес аккаунта владеющего токенами
64     /// @param _spender Адрес аккаунта, с которого возможно списать токены
65     /// @return Кол-во оставшихся токенов разрешённых для отправки
66     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
67 
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70 }
71 
72 /*
73 Контракт реализует ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
74 */
75 contract ERC20Token is Token
76 {
77 
78     function transfer(address _to, uint256 _value) returns (bool success)
79     {
80         //По-умолчанию предполагается, что totalSupply не может быть больше (2^256 - 1).
81         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
82             balances[msg.sender] -= _value;
83             balances[_to] += _value;
84             Transfer(msg.sender, _to, _value);
85             return true;
86         } else { return false; }
87     }
88 
89     function transferFrom(address _from, address _to, uint256 _value) returns (bool success)
90     {
91         //По-умолчанию предполагается, что totalSupply не может быть больше (2^256 - 1).
92         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
93             balances[_to] += _value;
94             balances[_from] -= _value;
95             allowed[_from][msg.sender] -= _value;
96             Transfer(_from, _to, _value);
97             return true;
98         } else { return false; }
99     }
100 
101     function balanceOf(address _owner) constant returns (uint256 balance)
102     {
103         return balances[_owner];
104     }
105 
106     function approve(address _spender, uint256 _value) returns (bool success)
107     {
108         allowed[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110         return true;
111     }
112 
113     function allowance(address _owner, address _spender) constant returns (uint256 remaining)
114     {
115       return allowed[_owner][_spender];
116     }
117 
118     mapping (address => uint256) balances;
119     mapping (address => mapping (address => uint256)) allowed;
120 }
121 
122 /* Основной контракт токена, наследует ERC20Token */
123 contract BlackSnail is ERC20Token
124 {
125 
126     function ()
127     {
128         // Если кто то пытается отправить эфир на адрес контракта, то будет вызвана ошибка.
129         throw;
130     }
131 
132     /* Публичные переменные токена */
133     string public name;                 // Название
134     uint8 public decimals;              // Сколько десятичных знаков
135     string public symbol;               // Идентификатор (трехбуквенный обычно)
136     string public version = '1.0';      // Версия
137 
138     function BlackSnail(
139             uint256 _initialAmount,
140             string _tokenName,
141             uint8 _decimalUnits,
142             string _tokenSymbol)
143     {
144         balances[msg.sender] = _initialAmount;  // Передача создателю всех выпущенных монет
145         totalSupply = _initialAmount;
146         name = _tokenName;
147         decimals = _decimalUnits;
148         symbol = _tokenSymbol;
149     }
150 
151 }