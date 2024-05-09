1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner {
38     require(newOwner != address(0));      
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /*
46  * Базовый контракт, который поддерживает остановку продаж
47  */
48 
49 contract Haltable is Ownable {
50     bool public halted;
51 
52     modifier stopInEmergency {
53         require(!halted);
54         _;
55     }
56 
57     /* Модификатор, который вызывается в потомках */
58     modifier onlyInEmergency {
59         require(halted);
60         _;
61     }
62 
63     /* Вызов функции прервет продажи, вызывать может только владелец */
64     function halt() external onlyOwner {
65         halted = true;
66     }
67 
68     /* Вызов возвращает режим продаж */
69     function unhalt() external onlyOwner onlyInEmergency {
70         halted = false;
71     }
72 
73 }
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81 uint256 public totalSupply;
82 function balanceOf(address who) constant returns (uint256);
83 function transfer(address to, uint256 value) returns (bool);
84 event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 /**
88  * Интерфейс контракта токена
89  */
90 
91 contract ImpToken is ERC20Basic {
92     function decimals() public returns (uint) {}
93 }
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  */
99 library SafeMath {
100   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
101     uint256 c = a * b;
102     assert(a == 0 || c / a == b);
103     return c;
104   }
105 
106   function div(uint256 a, uint256 b) internal constant returns (uint256) {
107     // assert(b > 0); // Solidity automatically throws when dividing by 0
108     uint256 c = a / b;
109     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110     return c;
111   }
112 
113   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
114     assert(b <= a);
115     return a - b;
116   }
117 
118   function add(uint256 a, uint256 b) internal constant returns (uint256) {
119     uint256 c = a + b;
120     assert(c >= a);
121     return c;
122   }
123 }
124 
125 /* Контракт продаж */
126 
127 contract Sale is Haltable {
128     using SafeMath for uint;
129 
130     /* Токен, который продаем */
131     ImpToken public impToken;
132 
133     /* Собранные средства будут переводиться сюда */
134     address public destinationWallet;
135 
136     /*  Сколько сейчас стоит 1 IMP в wei */
137     uint public oneImpInWei;
138 
139     /*  Минимальное кол-во токенов, которое можно продать */
140     uint public minBuyTokenAmount;
141 
142     /*  Максимальное кол-во токенов, которое можно купить за 1 раз */
143     uint public maxBuyTokenAmount;
144 
145     /* Событие покупки токена */
146     event Invested(address receiver, uint weiAmount, uint tokenAmount);
147 
148     /* Конструктор */
149     function Sale(address _impTokenAddress, address _destinationWallet) {
150         require(_impTokenAddress != 0);
151         require(_destinationWallet != 0);
152 
153         impToken = ImpToken(_impTokenAddress);
154 
155         destinationWallet = _destinationWallet;
156     }
157 
158     /**
159      * Fallback функция вызывающаяся при переводе эфира
160      */
161     function() payable stopInEmergency {
162         uint weiAmount = msg.value;
163         address receiver = msg.sender;
164 
165         uint tokenMultiplier = 10 ** impToken.decimals();
166         uint tokenAmount = weiAmount.mul(tokenMultiplier).div(oneImpInWei);
167 
168         require(tokenAmount > 0);
169 
170         require(tokenAmount >= minBuyTokenAmount && tokenAmount <= maxBuyTokenAmount);
171 
172         // Сколько осталось токенов на контракте продаж
173         uint tokensLeft = getTokensLeft();
174 
175         require(tokensLeft > 0);
176 
177         require(tokenAmount <= tokensLeft);
178 
179         // Переводим токены инвестору
180         assignTokens(receiver, tokenAmount);
181 
182         // Шлем на кошелёк эфир
183         destinationWallet.transfer(weiAmount);
184 
185         // Вызываем событие
186         Invested(receiver, weiAmount, tokenAmount);
187     }
188 
189     /**
190      * Адрес кошелька для сбора средств
191      */
192     function setDestinationWallet(address destinationAddress) external onlyOwner {
193         destinationWallet = destinationAddress;
194     }
195 
196     /**
197      *  Минимальное кол-во токенов, которое можно продать
198      */
199     function setMinBuyTokenAmount(uint value) external onlyOwner {
200         minBuyTokenAmount = value;
201     }
202 
203     /**
204      *  Максимальное кол-во токенов, которое можно продать
205      */
206     function setMaxBuyTokenAmount(uint value) external onlyOwner {
207         maxBuyTokenAmount = value;
208     }
209 
210     /**
211      * Функция, которая задает текущий курс ETH в центах
212      */
213     function setOneImpInWei(uint value) external onlyOwner {
214         require(value > 0);
215 
216         oneImpInWei = value;
217     }
218 
219     /**
220      * Перевод токенов покупателю
221      */
222     function assignTokens(address receiver, uint tokenAmount) private {
223         impToken.transfer(receiver, tokenAmount);
224     }
225 
226     /**
227      * Возвращает кол-во нераспроданных токенов
228      */
229     function getTokensLeft() public constant returns (uint) {
230         return impToken.balanceOf(address(this));
231     }
232 }