1 pragma solidity ^0.4.16;
2 
3 contract Ownable {
4     
5 	address public owner;// Адрес владельца
6     
7 	function Ownable() public { // Конструктор, создаль является владельцем
8     	owner = msg.sender;
9 	}
10  
11 	modifier onlyOwner() { // Модификатор "Только владелец"
12     	require(msg.sender == owner);
13     	_;
14 	}
15  
16 	function transferOwnership(address _owner) public onlyOwner { // Передача права собственности на контракт токена
17     	owner = _owner;
18 	}
19     
20 }
21 
22 contract KVCoin is Ownable{
23 
24   string public name; // Название
25   string public symbol; // Символ
26   uint8 public decimals; // Знаков после запятой
27 	 
28   uint256 public tokenTotalSupply;// Общее количество токенов
29 
30   function totalSupply() constant returns (uint256 _totalSupply){ // Функция, которая возвращает общее количество токенов
31   	return tokenTotalSupply;
32 	}
33    
34   mapping (address => uint256) public balances; // Хранение токенов (у кого сколько)
35   mapping (address => mapping (address => uint256)) public allowed; // Разрешение на перевод эфиров обратно
36 
37   function balanceOf(address _owner) public constant returns (uint balance) { // Функция, возвращающая количество токенов на запрашиваемом счёте
38   	return balances[_owner];
39   }
40 
41   event Transfer(address indexed _from, address indexed _to, uint256 _value); // Событие, сигнализирующее о переводе
42   event Approval(address indexed _owner, address indexed _spender, uint256 _value); // Событие, сигнализируещее об одобрении перевода эфиров обратно
43   event Mint(address indexed _to, uint256 _amount); // Выпустить токены
44   event Burn(address indexed _from, uint256 _value); // Событие, сигнализируещее о сжигании
45 
46   function KVCoin () {
47 	name = "KVCoin"; // Имя токена
48 	symbol = "KVC"; // Символ токена
49 	decimals = 0; // Число знаков после запятой
50    	 
51 	tokenTotalSupply = 0; // Пока не создано ни одного токена
52 	}
53 
54   function _transfer(address _from, address _to, uint256 _value) internal returns (bool){ // Вспомогательная функция перевода токенов
55 	require (_to != 0x0); // Адрес назначения не нулевой
56 	require(balances[_from] >= _value); // У переводящего достаточно токенов
57 	require(balances[_to] + _value >= balances[_to]); // У принимающего не случится переполнения
58 
59 	balances[_from] -= _value; // Списание токенов у отправителя
60 	balances[_to] += _value; // Зачисление токенов получателю
61 
62 	Transfer(_from, _to, _value);
63 	if (_to == address(this)){ // Если монетки переведены на счёт контракта токена, они сжигаются
64   	return burn();
65 	}
66 	return true;
67   }
68 
69   function serviceTransfer(address _from, address _to, uint256 _value) { // Функция перевода токенов, для владельца, чтобы исправлять косяки, например
70 	require((msg.sender == owner)||(msg.sender == saleAgent)); // Если вызывающий владелец контракта, или контракт-продавец
71 	_transfer(_from, _to, _value);        	 
72   }
73 
74     
75   function transfer(address _to, uint256 _value) returns (bool success) { // Функция для перевода своих токенов
76 	return _transfer(msg.sender, _to, _value);
77   }
78 
79   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) { // Функция для перевода токенов с чужого счёта  
80 	require(_value <= allowed[_from][_to]);// Проверка, что токены были выделены аккаунтом _from для аккаунта _to
81 	allowed[_from][_to] -= _value; // Снятие разрешения перевода
82 	return _transfer(_from, _to, _value);//Отправка токенов
83   }
84  
85   function approve(address _spender, uint256 _value) returns (bool success){ // Функция разрешения перевода токенов со своего счёта
86 	allowed[msg.sender][_spender] += _value;
87 	Approval(msg.sender, _spender, _value);
88 	return true;
89   }
90 
91   address public saleAgent; // Адрес контракта продавца, который уполномочен выпускать токены
92  
93 	function setSaleAgent(address newSaleAgnet) public { // Установка адреса контракта продавца
94   	require(msg.sender == saleAgent || msg.sender == owner);
95   	saleAgent = newSaleAgnet;
96 	}
97     
98     
99   function mint(address _to, uint256 _amount) public returns (bool) { // Выпуск токенов
100 	require(msg.sender == saleAgent);
101 	tokenTotalSupply += _amount;
102 	balances[_to] += _amount;
103 	Mint(_to, _amount);
104 	if (_to == address(this)){ // Если монетки созданы на счёте контракта токена, они сжигаются
105   	return burn();
106 	}
107 	return true;
108   }
109  
110   function() external payable {
111 	owner.transfer(msg.value);
112   }
113 
114   function burn() internal returns (bool success) { // Функция для уничтожения токенов, которые появились на счёте контракта токена
115 	uint256 burningTokensAmmount = balances[address(this)]; // Запоминаем количество сжигаемых токенов
116 	tokenTotalSupply -= burningTokensAmmount; // Общее количество выпущенных токенов сокращается на количество сжигаемых токенов
117 	balances[address(this)] = 0;                  	// Количество монет на счёте контракта токена обнуляется
118     
119 	Burn(msg.sender, burningTokensAmmount);
120 	return true;
121   }
122 
123   function allowance(address _owner, address _spender) constant returns (uint256 remaining){ // Функция, возвращающая значение токенов, которым _owner разрешил управлять _spender`у
124 	return allowed[_owner][_spender];
125   }
126     
127 }