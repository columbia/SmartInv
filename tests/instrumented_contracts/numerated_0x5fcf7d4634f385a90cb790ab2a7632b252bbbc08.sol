1 pragma solidity ^0.4.18;
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
19   function Ownable() public {
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
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51     if (a == 0) {
52       return 0;
53     }
54     uint256 c = a * b;
55     assert(c / a == b);
56     return c;
57   }
58 
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return c;
64   }
65 
66   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67     assert(b <= a);
68     return a - b;
69   }
70 
71   function add(uint256 a, uint256 b) internal pure returns (uint256) {
72     uint256 c = a + b;
73     assert(c >= a);
74     return c;
75   }
76 }
77 
78 contract EtherRacing is Ownable {
79     using SafeMath for uint256;
80 
81     struct Customer {
82         bytes32 name;
83         uint256 earned;
84         uint16 c_num;
85         mapping (uint256 => uint16) garage;
86         uint256[] garage_idx;
87     }
88 
89     struct Car {
90       uint256 id;
91       bytes32 name;
92       uint256 s_price;
93       uint256 c_price;
94       uint256 earning;
95       uint256 o_earning;
96       uint16 s_count;
97       uint16 brand;
98       uint8 ctype;
99       uint8 spd;
100       uint8 acc;
101       uint8 dur;
102       uint8 hndl;
103       mapping (address => uint16) c_owners;
104     }
105 
106     string public constant name = 'CarToken';
107     string public constant symbol = 'CAR';
108     uint8 public constant decimals = 18;
109     uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));
110 
111     uint256 private store_balance;
112 
113     mapping (address => Customer) private customers;
114     //mapping (address => uint256) pendingWithdrawals;
115     mapping (uint256 => Car) public cars;
116     mapping (uint256 => address[]) public yesBuyer;
117     mapping (address => uint256) balances;
118     uint256[] public carAccts;
119 
120     /* Store Events */
121 
122     event CarRegistered(uint256 carId);
123     event CarUpdated(uint256 carId);
124     event CarDeregistered(uint256 carId);
125     event CarRegistrationFailed(uint256 carId);
126     event CarDeregistrationFaled(uint256 carId);
127 
128     event BuyCarCompleted(address customer, uint256 paymentSum);
129     event BuyCarFailed(address customer, uint256 customerBalance, uint256 paymentSum);
130     event EventCashOut (address indexed player,uint256 amount);
131 
132     function EtherRacing() public payable {
133         store_balance = 0;
134         balances[tx.origin] = INITIAL_SUPPLY;
135     }
136 
137     function() public payable {
138 
139     }
140 
141     function setInsertCar(bytes32 _name,
142                           uint256 _s_price,
143                           uint256 _earning,
144                           uint256 _o_earning,
145                           uint16 _brand,
146                           uint8 _ctype,
147                           uint8 _spd,
148                           uint8 _acc,
149                           uint8 _dur,
150                           uint8 _hndl)
151                           onlyOwner public {
152         var _id = carAccts.length + 1;
153         var car = Car(_id, _name, _s_price, _s_price, _earning, _o_earning,
154                       0, _brand, _ctype, _spd, _acc, _dur, _hndl);
155         cars[_id] = car;
156         carAccts.push(_id);
157         CarRegistered(_id);
158     }
159 
160     function updateCar(uint256 _id,
161                         bytes32 _name,
162                         uint256 _s_price,
163                         uint256 _earning,
164                         uint256 _o_earning,
165                         uint16 _brand,
166                         uint8 _ctype,
167                         uint8 _spd,
168                         uint8 _acc,
169                         uint8 _dur,
170                         uint8 _hndl)
171                         onlyOwner public {
172         Car storage car = cars[_id];
173         car.name = _name;
174         car.s_price = _s_price;
175         car.earning = _earning;
176         car.o_earning = _o_earning;
177         car.brand = _brand;
178         car.ctype = _ctype;
179         car.spd = _spd;
180         car.acc = _acc;
181         car.dur = _dur;
182         car.hndl = _hndl;
183         CarUpdated(_id);
184     }
185 
186     function getCar(uint256 _id) view public returns (uint256,
187                                                       bytes32,
188                                                       uint256,
189                                                       uint256,
190                                                       uint256,
191                                                       uint256,
192                                                       uint16) {
193         Car storage car = cars[_id];
194         return (car.id, car.name, car.s_price, car.c_price, car.earning, car.o_earning, car.s_count);
195     }
196 
197     function getCars() view public returns(uint256[]) {
198         return carAccts;
199     }
200 
201     function getCarName(uint256 _id) view public returns (bytes32){
202       return cars[_id].name;
203     }
204 
205     function countCars() view public returns (uint256) {
206         return carAccts.length;
207     }
208 
209     function deleteCar(uint256 _id) onlyOwner public returns (bool success) {
210       Car storage car = cars[_id];
211       if (car.id == _id) {
212         delete cars[_id];
213         CarDeregistered(_id);
214         return true;
215       }
216       CarDeregistrationFaled(_id);
217       return false;
218     }
219 
220     function buyCar(uint256 _id) public payable returns (bool success) {
221         require(_id > 0);
222         require(cars[_id].c_price > 0 && (msg.value + balances[msg.sender]) > 0);
223         require((msg.value + balances[msg.sender]) >= cars[_id].c_price);
224         Customer storage customer = customers[msg.sender];
225         customer.garage[_id] += 1;
226         customer.garage_idx.push(_id);
227         customer.c_num += 1;
228         cars[_id].s_count += 1;
229 
230         if ((msg.value + balances[msg.sender]) > cars[_id].c_price)
231             balances[msg.sender] += msg.value - cars[_id].c_price;
232 
233         uint256 f_price = cars[_id].earning * cars[_id].s_count + cars[_id].o_earning;
234         if(f_price > cars[_id].s_price){
235           cars[_id].c_price = f_price;
236         }
237         for (uint i = 0; i < yesBuyer[_id].length; ++i){
238             address buyer = yesBuyer[_id][i];
239             uint16 buy_count = cars[_id].c_owners[buyer];
240             uint256 earned = cars[_id].earning * buy_count;
241             balances[buyer] += earned;
242             customers[buyer].earned += earned;
243 
244         }
245         balances[owner] += cars[_id].c_price - cars[_id].earning * cars[_id].s_count;
246         cars[_id].c_owners[msg.sender] +=1;
247         if(cars[_id].c_owners[msg.sender] == 1){
248           yesBuyer[_id].push(msg.sender);
249         }
250         BuyCarCompleted(msg.sender, cars[_id].c_price);
251         return true;
252     }
253 
254     function getMyCarsIdx() public view returns (uint256[]){
255         Customer storage customer = customers[msg.sender];
256         return customer.garage_idx;
257     }
258 
259     function getMyCarsIdxCount(uint256 _id) public view returns (uint16){
260         Customer storage customer = customers[msg.sender];
261         return customer.garage[_id];
262     }
263 
264     function getCustomer() public view returns (bytes32 _name,
265                                                 uint256 _balance,
266                                                 uint256 _earned,
267                                                 uint16 _c_num) {
268         if (msg.sender != address(0)) {
269             _name = customers[msg.sender].name;
270             _balance = balances[msg.sender];
271             _earned = customers[msg.sender].earned;
272             _c_num = customers[msg.sender].c_num;
273         }
274         return (_name, _balance, _earned, _c_num);
275     }
276 
277     function earnedOf(address _address) public view returns (uint256) {
278         return customers[_address].earned;
279     }
280 
281     function carnumOf(address _address) public view returns (uint16) {
282         return customers[_address].c_num;
283     }
284 
285     function getBalanceInEth(address addr) public view returns (uint256) {
286   		return convert(getBalance(addr),2);
287   	}
288 
289   	function getBalance(address addr) public view returns(uint256) {
290   		return balances[addr];
291   	}
292 
293     function getStoreBalance() onlyOwner public constant returns (uint256) {
294         return this.balance;
295     }
296 
297     function withdraw(uint256 _amount) public returns (bool) {
298 
299         require(_amount >= 0);
300         require(_amount == uint256(uint128(_amount)));
301         require(this.balance >= _amount);
302         require(balances[msg.sender] >= _amount);
303 
304         if (_amount == 0)
305             _amount = balances[msg.sender];
306 
307         balances[msg.sender] -= _amount;
308 
309         if (!msg.sender.send(_amount))
310             balances[msg.sender] += _amount;
311             return false;
312         return true;
313 
314         EventCashOut(msg.sender, _amount);
315     }
316 
317     function convert(uint256 amount,uint256 conversionRate) public pure returns (uint256 convertedAmount)
318     {
319       return amount * conversionRate;
320     }
321 
322 
323 }