1 pragma solidity ^0.4.16;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal constant returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal constant returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 
29 }
30 
31 contract ERC20Basic {
32   uint256 public totalSupply;
33   function balanceOf(address who) constant returns (uint256);
34   function transfer(address to, uint256 value) returns (bool);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 contract BasicToken is ERC20Basic {
39   using SafeMath for uint256;
40 
41   mapping(address => uint256) balances;
42 
43   /* @dev transfer token for a specified address
44   * @param _to The address to transfer to.
45   * @param _value The amount to be transferred.
46   */
47   function transfer(address _to, uint256 _value) returns (bool) {
48     balances[msg.sender] = balances[msg.sender].sub(_value);
49     balances[_to] = balances[_to].add(_value);
50     Transfer(msg.sender, _to, _value);
51     return true;
52   }
53 
54   /* @dev Gets the balance of the specified address.
55   * @param _owner The address to query the the balance of. 
56   * @return An uint256 representing the amount owned by the passed address.
57   */
58   function balanceOf(address _owner) constant returns (uint256 balance) {
59     return balances[_owner];
60   }
61 
62 }
63 
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) constant returns (uint256);
66   function transferFrom(address from, address to, uint256 value) returns (bool);
67   function approve(address spender, uint256 value) returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) allowed;
74 
75   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
76     var _allowance = allowed[_from][msg.sender];
77 
78     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
79     // require (_value <= _allowance);
80 
81     balances[_to] = balances[_to].add(_value);
82     balances[_from] = balances[_from].sub(_value);
83     allowed[_from][msg.sender] = _allowance.sub(_value);
84     Transfer(_from, _to, _value);
85     return true;
86   }
87 
88   /* @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
89    * @param _spender The address which will spend the funds.
90    * @param _value The amount of tokens to be spent.
91    */
92   function approve(address _spender, uint256 _value) returns (bool) {
93 
94     // To change the approve amount you first have to reduce the addresses`
95     //  allowance to zero by calling `approve(_spender, 0)` if it is not
96     //  already 0 to mitigate the race condition described here:
97     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
99 
100     allowed[msg.sender][_spender] = _value;
101     Approval(msg.sender, _spender, _value);
102     return true;
103   }
104 
105   /* @dev Function to check the amount of tokens that an owner allowed to a spender.
106    * @param _owner address The address which owns the funds.
107    * @param _spender address The address which will spend the funds.
108    * @return A uint256 specifing the amount of tokens still avaible for the spender.
109    */
110   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
111     return allowed[_owner][_spender];
112   }
113 
114 }
115 
116 contract Ownable {
117   address public owner;
118 /* @dev The Ownable constructor sets the original `owner` of the contract to the sender
119    * account.
120    */
121   function Ownable() {
122     owner = msg.sender;
123   }
124 
125   /* @dev Throws if called by any account other than the owner.
126    */
127   modifier onlyOwner() {
128     require(msg.sender == owner);
129     _;
130   }
131 
132   // Функция для смены владельца
133   function transferOwnership(address newOwner) onlyOwner {
134     if (newOwner != address(0)) {
135       owner = newOwner;
136     }
137   }
138 
139 }
140 
141 // Создаем контракт BCharityToken
142 contract BCharityCoin is StandardToken, Ownable {
143 
144   string public name = "BCharity Coin";
145   string public symbol = "CHAR";
146   // Кол-во нулей после запятой от одного токена
147   // Number of digits after point
148   uint8 public decimals = 18;
149   
150   // 100 000 000 coins are issuing
151   // Выпускаем 100 000 000 монет
152   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
153   
154   function BCharityCoin() {
155     // Записываем в totalSupply кол-во выпущенных токенов
156     // Write into totalSupply count of issuing tokens
157     totalSupply = INITIAL_SUPPLY;
158     // Отправляем на баланс владельца все токены
159     // send all tokens to owner of the contract
160     balances[msg.sender] = INITIAL_SUPPLY;
161   }
162 
163 }