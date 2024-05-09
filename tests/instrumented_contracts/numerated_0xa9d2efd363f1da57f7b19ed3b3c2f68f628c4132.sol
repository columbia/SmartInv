1 pragma solidity ^0.4.24;
2 
3 /**
4  * title ERC20 interface
5  * see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20Token{
8   uint256 public totalSupply;
9   mapping (address => uint256) public balanceOf;
10   mapping (address => mapping (address => uint256)) public allowance;
11   function transfer(address to, uint256 value) public returns (bool);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 
19 /**
20  * title Standard ERC20 token
21  *
22  * Implementation of the basic standard token.
23  * https://github.com/ethereum/EIPs/issues/20
24  */
25 contract StandardToken is ERC20Token{
26   string public version = "1.0";
27   string public name = "Preserve One’s Health";
28   string public symbol = "POH";
29   uint8 public  decimals = 18;
30 
31   bool public transfersEnabled = true;
32 
33   /**
34    * to stop this contract
35    */
36   modifier transable(){
37       require(transfersEnabled);
38       _;
39   }
40 
41   function transfer(address _to, uint256 _value) transable public returns (bool) {
42     require(_to != address(0));
43     require(balanceOf[msg.sender]>_value);
44     balanceOf[msg.sender] -= _value;
45     balanceOf[_to] += _value;
46     emit Transfer(msg.sender, _to, _value);
47     return true;
48   }
49 
50   /**
51    * Transfer tokens from one address to another
52    * param _from address The address which you want to send tokens from
53    * param _to address The address which you want to transfer to
54    * param _value uint256 the amount of tokens to be transferred
55    */
56   function transferFrom(address _from, address _to, uint256 _value) transable public returns (bool) {
57     require(_to != address(0));
58 
59     uint256 _allowance = allowance[_from][msg.sender];
60 
61     require (_value <= _allowance);
62     require(balanceOf[_from]>_value);
63 
64     balanceOf[_from] -= _value;
65     balanceOf[_to] += _value;
66     allowance[_from][msg.sender] -= _value;
67     emit Transfer(_from, _to, _value);
68     return true;
69   }
70 
71   /**
72    * Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
73    * 
74    * param _spender The address which will spend the funds.
75    * param _value The amount of tokens to be spent.
76    */
77   function approve(address _spender, uint256 _value) public returns (bool) {
78     require(allowance[msg.sender][_spender]==0);
79     allowance[msg.sender][_spender] = _value;
80     emit Approval(msg.sender, _spender, _value);
81     return true;
82   }
83 
84 
85   /**
86    * approve should be called only first. To increment
87    * allowed value is better to use this function
88    */
89   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
90     allowance[msg.sender][_spender] += _addedValue;
91     emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
92     return true;
93   }
94 
95   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
96     uint oldValue = allowance[msg.sender][_spender];
97     if (_subtractedValue > oldValue) {
98       allowance[msg.sender][_spender] = 0;
99     } else {
100       allowance[msg.sender][_spender] -= _subtractedValue;
101     }
102     emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
103     return true;
104   }
105 
106 }
107 
108 
109 
110 // This is just a contract of a BOP Token.
111 // It is a ERC20 token
112 contract POHToken is StandardToken{
113 
114     //解锁信息
115     uint  currUnlockStep; //当前解锁step
116     uint256 currUnlockSeq; //当前解锁step 内的游标
117 
118     //Key1: step(募资阶段); Key2: user sequence(用户序列)
119     mapping (uint => uint256[]) public freezeOf; //所有数额，地址与数额合并为uint256，位运算拆分。
120     mapping (uint => bool) public stepUnlockInfo; //所有锁仓，key 使用序号向上增加，value,是否已解锁。
121     mapping (address => uint256) public freezeOfUser; //用户所有锁仓，方便用户查询自己锁仓余额
122     
123    
124     uint256 internal constant INITIAL_SUPPLY = 10 * (10**8) * (10 **18);
125 
126 
127     event Burn(address indexed burner, uint256 value);
128     event Freeze(address indexed locker, uint256 value);
129     event Unfreeze(address indexed unlocker, uint256 value);
130     event TransferMulti(uint256 count, uint256 total);
131 
132     constructor() {
133         owner = msg.sender;
134         balanceOf[msg.sender] = INITIAL_SUPPLY;
135         totalSupply = INITIAL_SUPPLY;
136     }
137 
138     // transfer to and lock it
139     function transferAndLock(address _to, uint256 _value, uint256 _lockValue, uint _step) transable public returns (bool success) {
140         require(_to != 0x0);
141         require(_value <= balanceOf[msg.sender]);
142         require(_value > 0);
143 
144         balanceOf[msg.sender] -= _value;
145         balanceOf[_to] += _value;
146 
147         emit Transfer(msg.sender, _to, _value);
148         freeze(_to, _lockValue, _step);
149         return true;
150     }
151 
152     // transfer to and lock it
153     function transferFromAndLock(address _from, address _to, uint256 _value, uint256 _lockValue, uint _step) transable public returns (bool success) {
154         uint256 _allowance = allowance[_from][msg.sender];
155 
156         require (_value <= _allowance);
157         require(_to != 0x0);
158         require(_value <= balanceOf[_from]);
159         require(_value > 0);
160 
161         allowance[_from][msg.sender] -= _value;
162         balanceOf[_from] -= _value;
163         balanceOf[_to] += _value;
164 
165         emit Transfer(_from, _to, _value);
166         freeze(_to, _lockValue, _step);
167         return true;
168     }
169 
170 
171     function transferMulti(address[] _to, uint256[] _value) transable public returns (uint256 amount){
172         require(_to.length == _value.length && _to.length <= 1024);
173         uint256 balanceOfSender = balanceOf[msg.sender];
174         uint256 len = _to.length;
175         for(uint256 j; j<len; j++){
176             require(_value[j] <= balanceOfSender); //limit transfer value
177             require(amount <= balanceOfSender);
178             amount += _value[j];
179         }
180         require(balanceOfSender >= amount); //check enough and not overflow
181         balanceOf[msg.sender] -= amount;
182         for(uint256 i; i<len; i++){
183             address _toI = _to[i];
184             uint256 _valueI = _value[i];
185             balanceOf[_toI] += _valueI;
186             emit Transfer(msg.sender, _toI, _valueI);
187         }
188         emit TransferMulti(len, amount);
189     }
190     
191 
192     function transferMultiSameVaule(address[] _to, uint256 _value) transable public returns (bool success){
193         uint256 len = _to.length;
194         uint256 amount = _value*len;
195         require(amount <= balanceOf[msg.sender]);
196         balanceOf[msg.sender] -= amount; //this will check enough automatically
197         for(uint256 i; i<len; i++){
198             address _toI = _to[i];
199             balanceOf[_toI] += _value;
200             emit Transfer(msg.sender, _toI, _value);
201         }
202         emit TransferMulti(len, amount);
203         return true;
204     }
205 
206 
207     //冻结账户
208     function freeze(address _user, uint256 _value, uint _step) internal returns (bool success) {
209         require(balanceOf[_user] >= _value);
210         balanceOf[_user] -= _value;
211         freezeOfUser[_user] += _value;
212         freezeOf[_step].push(uint256(_user)<<92|_value);
213         emit Freeze(_user, _value);
214         return true;
215     }
216 
217 
218     //event ShowStart(uint256 start);
219 
220     //为用户解锁账户资金
221     function unFreeze(uint _step) onlyOwner public returns (bool unlockOver) {
222         require(currUnlockStep==_step || currUnlockSeq==uint256(0));
223         require(stepUnlockInfo[_step]==false);
224         uint256[] memory currArr = freezeOf[_step];
225         currUnlockStep = _step;
226         if(currUnlockSeq==uint256(0)){
227             currUnlockSeq = currArr.length;
228         }
229 
230         uint256 userLockInfo;
231         uint256 _amount;
232         address userAddress;
233 
234         for(uint i = 0; i<99&&currUnlockSeq>0; i++){
235             userLockInfo = freezeOf[_step][currUnlockSeq-1];
236             _amount = userLockInfo&0xFFFFFFFFFFFFFFFFFFFFFFF;
237             userAddress = address(userLockInfo>>92);
238             balanceOf[userAddress] += _amount;
239             freezeOfUser[userAddress] -= _amount;
240             emit Unfreeze(userAddress, _amount);
241             currUnlockSeq--;
242         }
243         if(currUnlockSeq==0){
244             stepUnlockInfo[_step] = true;
245         }
246         return true;
247     }
248 
249 
250     /**
251      * Burns a specific amount of tokens.
252      * param _value The amount of token to be burned.
253      */
254     function burn(uint256 _value) transable public returns (bool success) {
255         require(_value > 0);
256         require(_value <= balanceOf[msg.sender]);
257    
258         balanceOf[msg.sender] -= _value;
259         totalSupply -= _value;
260         emit Burn(msg.sender, _value);
261         return true;
262     }
263 
264 
265 
266     /**
267      * dev Function to mint tokens
268      * param _to The address that will receive the minted tokens.
269      * param _amount The amount of tokens to mint.
270      * return A boolean that indicates if the operation was successful.
271      */
272     function enableTransfers(bool _transfersEnabled) onlyOwner public {
273       transfersEnabled = _transfersEnabled;
274     }
275 
276 
277     address public owner;
278 
279     event ChangeOwner(address indexed previousOwner, address indexed newOwner);
280 
281 
282     /**
283      * revert if called by any account except owner.
284      */
285     modifier onlyOwner() {
286       require(msg.sender == owner);
287       _;
288     }
289 
290     /**
291      * revert if called by any account except owner.
292      */
293     function claim() onlyOwner public {
294       owner.transfer(this.balance);
295     }
296 
297 
298 
299     /**
300      * Allows the current owner to transfer control of the contract to a newOwner.
301      * param newOwner The address to transfer ownership to.
302      */
303     function changeOwner(address newOwner) onlyOwner public {
304       require(newOwner != address(0));
305       owner = newOwner;
306       emit ChangeOwner(owner, newOwner);
307     }
308 }