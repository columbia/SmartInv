1 pragma solidity ^0.4.25;
2 
3 library Percent {
4   // Solidity automatically throws when dividing by 0
5   struct percent {
6     uint num;
7     uint den;
8   }
9   
10   // storage
11   function mul(percent storage p, uint a) internal view returns (uint) {
12     if (a == 0) {
13       return 0;
14     }
15     return a*p.num/p.den;
16   }
17 
18     function toMemory(percent storage p) internal view returns (Percent.percent memory) {
19     return Percent.percent(p.num, p.den);
20   }
21 }
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that revert on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, reverts on overflow.
31   */
32   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
33     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (_a == 0) {
37       return 0;
38     }
39 
40     uint256 c = _a * _b;
41     require(c / _a == _b);
42 
43     return c;
44   }
45 
46   /**
47   * @dev Adds two numbers, reverts on overflow.
48   */
49   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
50     uint256 c = _a + _b;
51     require(c >= _a);
52 
53     return c;
54   }
55   
56   /**
57     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
58     */
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b <= a);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66 }
67 
68 contract Ownable {
69   address public owner;
70 
71   event OwnershipTransferred(
72     address indexed previousOwner,
73     address indexed newOwner
74   );
75 
76   /**
77    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78    * account.
79    */
80   constructor() internal {
81     owner = msg.sender;
82     emit OwnershipTransferred(address(0), owner);
83   }
84 
85   /**
86    * @return the address of the owner.
87    */
88   function owner() public view returns(address) {
89     return owner;
90   }
91 
92   /**
93    * @dev Throws if called by any account other than the owner.
94    */
95   modifier onlyOwner() {
96     require(isOwner());
97     _;
98   }
99 
100   /**
101    * @return true if `msg.sender` is the owner of the contract.
102    */
103   function isOwner() public view returns(bool) {
104     return msg.sender == owner;
105   }
106 
107   /**
108    * @dev Allows the current owner to relinquish control of the contract.
109    * @notice Renouncing to ownership will leave the contract without an owner.
110    * It will not be possible to call the functions with the `onlyOwner`
111    * modifier anymore.
112    */
113   function renounceOwnership() public onlyOwner {
114     emit OwnershipTransferred(owner, address(0));
115     owner = address(0);
116   }
117 }
118 
119 contract FastLap is Ownable {
120     using Percent for Percent.percent;
121     using SafeMath for uint;
122     
123     //Address for advertising and admins expences
124     address constant public advertisingAddress = address(0xf86117De6539c6f48764b638412C99F3ADB19892); //рекламный
125     address constant public adminsAddress = address(0x33a6c786Cf6D69CC62c475B5d69947af08bB6210); //тех поддержка и автоматизация выплат
126     
127     //Percent for promo expences
128     Percent.percent private m_adminsPercent = Percent.percent(3, 100);       //   3/100  *100% = 3%
129     Percent.percent private m_advertisingPercent = Percent.percent(5, 100);// 5/100  *100% = 5%
130     //How many percent for your deposit to be multiplied
131     Percent.percent public MULTIPLIER = Percent.percent(120, 100); // 120/100 * 100% = 120%
132     
133     uint public amountRaised = 0;
134     //The deposit structure holds all the info about the deposit made
135     struct Deposit {
136         address depositor; //The depositor address
137         uint deposit;   //The deposit amount
138         uint expects;    //How much we should pay out (initially it is 120% of deposit)
139         uint paymentTime; //when payment
140     }
141 
142     Deposit[] private Queue;  //The queue for new investments
143     // list of deposites for 1 user
144     mapping(address => uint[]) private depositors;
145     
146     uint public depositorsCount = 0;
147     
148     uint private currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
149     
150     uint public minBalanceForDistribution = 3 ether; //минимально необходимый баланс
151 
152     //создаем депозит инвестора в основной очереди
153     function () public payable {
154         if(msg.value > 0){ //регистрация депозита
155             require(msg.value >= 0.1 ether, "investment must be between 0.1 and 0.5 ether"); //ограничение минимального депозита
156             require(msg.value <= 0.5 ether, "investment must be between 0.1 and 0.5 ether"); //ограничение максимального депозита
157 
158             //к выплате 120% от депозита
159             uint expect = MULTIPLIER.mul(msg.value);
160             Queue.push(Deposit({depositor:msg.sender, deposit:msg.value, expects:expect, paymentTime:0}));
161             amountRaised += msg.value;
162             if (depositors[msg.sender].length == 0) depositorsCount += 1;
163             depositors[msg.sender].push(Queue.length - 1);
164             
165             advertisingAddress.send(m_advertisingPercent.mul(msg.value));
166             adminsAddress.send(m_adminsPercent.mul(msg.value));
167         } else { //выплаты инвесторам
168             uint money = address(this).balance;
169             require(money >= minBalanceForDistribution, "Not enough funds to pay");//на балансе недостаточно денег для выплат
170             uint QueueLen = Queue.length;
171             uint toSend = Queue[currentReceiverIndex].expects;
172             uint maxIterations = 25;//максимум 25 итераций
173             uint num = 0;
174             uint i = 0;
175             
176             while ((currentReceiverIndex < QueueLen) && (i < maxIterations) && (money >= toSend)) {
177                 money = money.sub(toSend);
178                 Queue[currentReceiverIndex].paymentTime = now;
179                 num = currentReceiverIndex;
180                 currentReceiverIndex += 1;
181                 i +=1;
182                 Queue[num].depositor.send(toSend);
183                 toSend = Queue[currentReceiverIndex].expects;
184             }
185         }
186     }
187 
188     //баланс контракта
189     function getNeedBalance() public view returns (uint) {
190         uint money = address(this).balance;
191         if (money >= minBalanceForDistribution){
192           return 0;  
193         } else {
194             return minBalanceForDistribution - money;
195         }
196     }
197     
198     //данные о депозите по порядковому номеру 
199     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect, uint paymentTime){
200         Deposit storage dep = Queue[idx];
201         return (dep.depositor, dep.deposit, dep.expects, dep.paymentTime);
202     }
203 
204     //общее количество депозитов у кошелька depositor
205     function getUserDepositsCount(address depositor) public view returns (uint) {
206         return depositors[depositor].length;
207     }
208 
209     //Все депозиты основной очереди кошелька depositor в виде массива
210     function getUserInfo(address depositor) public view returns (uint depCount, uint allDeps, uint payDepCount, uint allPay, uint lastPaymentTime) {
211         depCount = depositors[depositor].length;
212         allPay = 0;
213         allDeps = 0;
214         lastPaymentTime = 0;
215         payDepCount = 0;
216         uint num = 0;
217         
218         for(uint i=0; i<depCount; ++i){
219             num = depositors[depositor][i];
220             allDeps += Queue[num].deposit;
221             if (Queue[num].paymentTime > 0){
222                 allPay += Queue[num].expects;
223                 payDepCount += 1;
224                 lastPaymentTime = Queue[num].paymentTime;
225             }
226         }
227         return (depCount, allDeps, payDepCount, allPay, lastPaymentTime);
228     }
229 }