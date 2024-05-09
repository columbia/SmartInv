1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56 
57   address public owner;
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 
92 /**
93  * An ideal or perfect society
94  */
95 contract GreatHarmon is Ownable {
96 
97     using SafeMath for uint256;
98 
99     /* Initializes contract */
100     function GreatHarmon() public {
101         
102     }
103 
104     //领取Basic income的冷却时间, 暂且设定为1天。
105     uint public cooldownTime = 1 days;
106 
107     //basicIncome发放限制
108     uint public basicIncomeLimit = 10000;
109 
110     //日常发放
111     uint public dailySupply = 50;
112 
113     /**
114      * @dev 分发基本收入
115      */
116     function getBasicIncome() public {
117         Resident storage _resident = residents[idOf[msg.sender]-1];
118         require(_isReady(_resident));
119         require(_isUnderLimit());
120         require(!frozenAccount[msg.sender]);  
121 
122         balanceOf[msg.sender] += dailySupply;
123 
124         totalSupply = totalSupply.add(dailySupply);
125 
126         _triggerCooldown(_resident);
127         GetBasicIncome(idOf[msg.sender]-1, _resident.name, dailySupply, uint32(now));
128         Transfer(address(this), msg.sender, dailySupply);
129     }
130 
131     function _triggerCooldown(Resident storage _resident) internal {
132         _resident.readyTime = uint32(now + cooldownTime);
133     }
134 
135     /**
136     * @dev BasicIncome 设定为每日领取一次。 领取之后，进入一天的冷却时间。
137     * 这里检测是否在冷却周期内。
138     */
139     function _isReady(Resident storage _resident) internal view returns (bool) {
140         return (_resident.readyTime <= now);
141     }
142 
143     /**
144     * @dev 分发基本收入之前，需检测是否符合发放规则。
145     * 大同世界崇尚“按需索取”,贪婪获取是不应该的。
146     * 此函数检测居民的当前ghCoin，如果大于系统设定的basicIncomeLimit，
147     * 则不能再获取basicIncome。
148     */
149     function _isUnderLimit() internal view returns (bool) {
150         return (balanceOf[msg.sender] <= basicIncomeLimit);
151     }
152 
153     //居民加入事件
154     event JoinGreatHarmon(uint id, string name, string identity, uint32 date);
155     event GetBasicIncome(uint id, string name, uint supply, uint32 date);
156 
157     // 居民
158     struct Resident {
159         string name;      //姓名
160         string identity;  //记录生日、性别等个人信息。类似身份证。
161         uint32 prestige;  //声望值，大同世界中，鼓励人们“达则兼济天下”。做更多的好事。将提高声望值。
162         uint32 joinDate;  //何时加入。
163         uint32 readyTime; //"Basic income system" 的冷却时间。
164     }
165 
166     Resident[] public residents;
167 
168     //存储居民id索引
169     mapping (address => uint) public idOf;
170 
171     function getResidentNumber() external view returns(uint) {
172         return residents.length;
173     }
174 
175     /**
176     * @dev 加入“大同世界”的唯一入口。
177     * 加入“大同世界”的操作,除要消耗支付给以太坊矿工的gas,不需要再任何费用。
178     * 但我知道有很多好心人,乐于奉献, 于是这里作为一个payable函数, 你可以再加入“大同世界”的时候,
179     * 向这个理想丰满而美好的组织捐赠任意大小的ether,助它更好的成长。
180     * @param _name 居民的显示名字
181     * @param _identity 各种实名认证之后产生的身份唯一标识.
182     * (目前只需传身份证号码，并且非常相信愿意加入“大同世界”的人的行为，没有做太多的认证,
183     * 假设这项目有人看好,再做更复杂的认证)
184     */
185     function joinGreatHarmon(string _name, string _identity) public payable returns(uint) {
186         //检测是否重复加入。
187         require(idOf[msg.sender] == 0);
188         if (msg.value > 0) {
189             donateMap[msg.sender] += msg.value;
190             Donate(msg.sender, _name, msg.value, "");
191         }
192         return _createResident(_name, _identity);
193     }
194 
195     function _createResident(string _name, string _identity) internal returns(uint) {
196         uint id = residents.push(Resident(_name, _identity, 0, uint32(now), uint32(now)));
197         idOf[msg.sender] = id;
198         JoinGreatHarmon(id, _name, _identity, uint32(now));
199         getBasicIncome();
200         return id;
201     }
202 
203     function withdraw() external onlyOwner {
204         owner.transfer(this.balance);
205     }
206 
207     function setCooldownTime(uint _cooldownTime) external onlyOwner {
208         cooldownTime = _cooldownTime;
209     }
210 
211     function setBasicIncomeLimit(uint _basicIncomeLimit) external onlyOwner {
212         basicIncomeLimit = _basicIncomeLimit;
213     }
214 
215     function setDailySupply(uint _dailySupply) external onlyOwner {
216         dailySupply = _dailySupply;
217     }
218 
219     mapping (address => bool) public frozenAccount;
220     
221     /* This generates a public event on the blockchain that will notify clients */
222     event FrozenAccount(address target, bool frozen);
223 
224     /// @notice `freeze? Prevent | Allow` `target` from get Basic Income
225     /// @param target Address to be frozen
226     /// @param freeze either to freeze it or not
227     function freezeAccount(address target, bool freeze) external onlyOwner {
228         frozenAccount[target] = freeze;
229         FrozenAccount(target, freeze);
230     }
231 
232     mapping (address => uint) public donateMap;
233 
234     event Donate(address sender, string name, uint amount, string text);
235 
236     // accept ether donate
237     function donate(string _text) payable public {
238         if (msg.value > 0) {
239             donateMap[msg.sender] += msg.value;
240             Resident memory _resident = residents[idOf[msg.sender]-1];
241             Donate(msg.sender, _resident.name, msg.value, _text);
242         }
243     }
244 
245     // token erc20
246     // Public variables of the token
247     string public name = "Great Harmon Coin";
248     string public symbol = "GHC";
249     uint8 public decimals = 18;
250     // 18 decimals is the strongly suggested default, avoid changing it
251     uint256 public totalSupply = 0;
252 
253     // This creates an array with all balances
254     mapping (address => uint256) public balanceOf;
255     mapping (address => mapping (address => uint256)) public allowance;
256 
257     // This generates a public event on the blockchain that will notify clients
258     event Transfer(address indexed from, address indexed to, uint256 value);
259 
260     // This notifies clients about the amount burnt
261     event Burn(address indexed from, uint256 value);
262 
263     /**
264      * Internal transfer, only can be called by this contract
265      */
266     function _transfer(address _from, address _to, uint _value) internal {
267         // Prevent transfer to 0x0 address. Use burn() instead
268         require(_to != 0x0);
269         // Check if the sender has enough
270         require(balanceOf[_from] >= _value);
271         // Check for overflows
272         require(balanceOf[_to] + _value > balanceOf[_to]);
273         // Save this for an assertion in the future
274         uint previousBalances = balanceOf[_from] + balanceOf[_to];
275         // Subtract from the sender
276         balanceOf[_from] -= _value;
277         // Add the same to the recipient
278         balanceOf[_to] += _value;
279         Transfer(_from, _to, _value);
280         // Asserts are used to use static analysis to find bugs in your code. They should never fail
281         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
282     }
283 
284     /**
285      * Transfer tokens
286      *
287      * Send `_value` tokens to `_to` from your account
288      *
289      * @param _to The address of the recipient
290      * @param _value the amount to send
291      */
292     function transfer(address _to, uint256 _value) public {
293         _transfer(msg.sender, _to, _value);
294     }
295 
296     /**
297      * Transfer tokens from other address
298      *
299      * Send `_value` tokens to `_to` in behalf of `_from`
300      *
301      * @param _from The address of the sender
302      * @param _to The address of the recipient
303      * @param _value the amount to send
304      */
305     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
306         require(_value <= allowance[_from][msg.sender]);     // Check allowance
307         allowance[_from][msg.sender] -= _value;
308         _transfer(_from, _to, _value);
309         return true;
310     }
311 
312     /**
313      * Set allowance for other address
314      *
315      * Allows `_spender` to spend no more than `_value` tokens in your behalf
316      *
317      * @param _spender The address authorized to spend
318      * @param _value the max amount they can spend
319      */
320     function approve(address _spender, uint256 _value) public returns (bool success) { 
321         allowance[msg.sender][_spender] = _value;
322         return true;
323     }
324 
325     /**
326      * Destroy tokens
327      *
328      * Remove `_value` tokens from the system irreversibly
329      *
330      * @param _value the amount of money to burn
331      */
332     function burn(uint256 _value) public returns (bool success) {
333         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
334         balanceOf[msg.sender] -= _value;            // Subtract from the sender
335         totalSupply -= _value;                      // Updates totalSupply
336         Burn(msg.sender, _value);
337         return true;
338     }
339 
340     /**
341      * Destroy tokens from other account
342      *
343      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
344      *
345      * @param _from the address of the sender
346      * @param _value the amount of money to burn
347      */
348     function burnFrom(address _from, uint256 _value) public returns (bool success) {
349         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
350         require(_value <= allowance[_from][msg.sender]);    // Check allowance
351         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
352         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
353         totalSupply -= _value;                              // Update totalSupply
354         Burn(_from, _value);
355         return true;
356     }
357     
358 }