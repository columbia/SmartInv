1 pragma solidity ^0.4.16;
2  
3 /* 
4    Эквивалент белорусского рубля BYN,
5   cвободно конвертируемый в любые платежи по Беларуси через ЕРИП
6    и в балансы операторов сотовой связи Беларуси.
7    1 BYN (Belorussian Rubble) = 1 BYN в системе ЕРИП.
8    Комиссии при транзакциях (переводах) данного эквивалента уплачиваются сторонним майнерам Ethereum в валюте ETH, так как основаны на самом надежном блокчейне Ethereum
9    
10    Система не направлена на получении какой-либо прибыли, действует на некоммерческой основе. 
11    Нет комиссий или иных способов получения прибыли пользователями или создателями системы.
12    Токен  1 BYN (Belorussian Rubble) не является ни денежным суррогатом, ни ценной бумагой.
13   BYN (Belorussian Rubble) - это учетная единица имеющихся у участников системы свободных средств в системе ЕРИП.
14   Покупка или продажа токенов системы  BYN (Belorussian Rubble) является покупкой или продажей белорусских рублей в системе ЕРИП. 
15   Контракт системы хранится на серверах блокчейна Ethereum и не подлежит изменению, редактированию  ввиду невозможности редактирования истории изменений состояния блокчейна.
16   Переводы внутри системы невозможно отменить, вернуть или невозможно закрыть каким-либо участникам права на использование системы.
17   У системы нет ни модератора, ни хозяина, создана для благотворительных целей без целей извлечения какой-либо прибыли. Участники системы действуют на добровольной основе, самостоятельно и без необходимости согласия создателями системы. 
18   BYN (Belorussian Rubble) является смартконтрактм (скрпитом) и не подлежит регулированию. 
19   
20  */
21 contract ERC20Basic {
22   uint256 public totalSupply;
23   function balanceOf(address who) constant returns (uint256);
24   function transfer(address to, uint256 value) returns (bool);
25   event Transfer(address indexed from, address indexed to, uint256 value);
26 }
27  
28 /*
29    ERC20 interface
30   see https://github.com/ethereum/EIPs/issues/20
31  */
32 contract ERC20 is ERC20Basic {
33   function allowance(address owner, address spender) constant returns (uint256);
34   function transferFrom(address from, address to, uint256 value) returns (bool);
35   function approve(address spender, uint256 value) returns (bool);
36   event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38  
39 /*  SafeMath - the lowest gas library
40   Math operations with safety checks that throw on error
41  */
42 library SafeMath {
43     
44   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
45     uint256 c = a * b;
46     assert(a == 0 || c / a == b);
47     return c;
48   }
49  
50   function div(uint256 a, uint256 b) internal constant returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return c;
55   }
56  
57   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61  
62   function add(uint256 a, uint256 b) internal constant returns (uint256) {
63     uint256 c = a + b;
64     assert(c >= a);
65     return c;
66   }
67   
68 }
69  
70 /*
71 Basic token
72  Basic version of StandardToken, with no allowances. 
73  */
74 contract BasicToken is ERC20Basic {
75     
76   using SafeMath for uint256;
77  
78   mapping(address => uint256) balances;
79  
80  function transfer(address _to, uint256 _value) returns (bool) {
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     Transfer(msg.sender, _to, _value);
84     return true;
85   }
86  
87   /*
88   Gets the balance of the specified address.
89    param _owner The address to query the the balance of. 
90    return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) constant returns (uint256 balance) {
93     return balances[_owner];
94   }
95  
96 }
97  
98 /* Implementation of the basic standard token.
99   https://github.com/ethereum/EIPs/issues/20
100  */
101 contract StandardToken is ERC20, BasicToken {
102  
103   mapping (address => mapping (address => uint256)) allowed;
104  
105   /*
106     Transfer tokens from one address to another
107     param _from address The address which you want to send tokens from
108     param _to address The address which you want to transfer to
109     param _value uint256 the amout of tokens to be transfered
110    */
111   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
112     var _allowance = allowed[_from][msg.sender];
113  
114     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
115     // require (_value <= _allowance);
116  
117     balances[_to] = balances[_to].add(_value);
118     balances[_from] = balances[_from].sub(_value);
119     allowed[_from][msg.sender] = _allowance.sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123  
124   /*
125   Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    param _spender The address which will spend the funds.
127    param _value The amount of Roman Lanskoj's tokens to be spent.
128    */
129   function approve(address _spender, uint256 _value) returns (bool) {
130  
131     // To change the approve amount you first have to reduce the addresses`
132     //  allowance to zero by calling `approve(_spender, 0)` if it is not
133     //  already 0 to mitigate the race condition described here:
134     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
136  
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141  
142   /*
143   Function to check the amount of tokens that an owner allowed to a spender.
144   param _owner address The address which owns the funds.
145   param _spender address The address which will spend the funds.
146   return A uint256 specifing the amount of tokens still available for the spender.
147    */
148   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
149     return allowed[_owner][_spender];
150 }
151 }
152  
153 /*
154 The Ownable contract has an owner address, and provides basic authorization control
155  functions, this simplifies the implementation of "user permissions".
156  */
157 contract Ownable {
158     
159   address public owner;
160  
161  
162   function Ownable() {
163     owner = msg.sender;
164   }
165  
166   /*
167   Throws if called by any account other than the owner.
168    */
169   modifier onlyOwner() {
170     require(msg.sender == owner);
171     _;
172   }
173  
174   /*
175   Allows the current owner to transfer control of the contract to a newOwner.
176   param newOwner The address to transfer ownership to.
177    */
178   function transferOwnership(address newOwner) onlyOwner {
179     require(newOwner != address(0));      
180     owner = newOwner;
181   }
182  
183 }
184  
185 contract TheLiquidToken is StandardToken, Ownable {
186     // mint can be finished and token become fixed for forever
187   event Mint(address indexed to, uint256 amount);
188   event MintFinished();
189   bool mintingFinished = false;
190   modifier canMint() {
191     require(!mintingFinished);
192     _;
193   }
194  
195  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
196     totalSupply = totalSupply.add(_amount);
197     balances[_to] = balances[_to].add(_amount);
198     Mint(_to, _amount);
199     return true;
200   }
201  
202   /*
203   Function to stop minting new tokens.
204   return True if the operation was successful.
205    */
206   function finishMinting() onlyOwner returns (bool) {}
207   
208   function burn(uint _value)
209         public
210     {
211         require(_value > 0);
212 
213         address burner = msg.sender;
214         balances[burner] = balances[burner].sub(_value);
215         totalSupply = totalSupply.sub(_value);
216         Burn(burner, _value);
217     }
218 
219     event Burn(address indexed burner, uint indexed value);
220   
221 }
222     
223 contract BYN is TheLiquidToken {
224   string public constant name = "Belorussian Rubble";
225   string public constant symbol = "BYN";
226   uint public constant decimals = 2;
227   uint256 public initialSupply;
228     
229   function Fricacoin () { 
230      totalSupply = 1200 * 10 ** decimals;
231       balances[msg.sender] = totalSupply;
232       initialSupply = totalSupply; 
233         Transfer(0, this, totalSupply);
234         Transfer(this, msg.sender, totalSupply);
235   }
236 }