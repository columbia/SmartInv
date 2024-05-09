1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner(), "Ownable: caller is not the owner");
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * It will not be possible to call the functions with the `onlyOwner`
47      * modifier anymore.
48      * @notice Renouncing ownership will leave the contract without an owner,
49      * thereby removing any functionality that is only available to the owner.
50      */
51     function renounceOwnership() public onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) public onlyOwner {
61         _transferOwnership(newOwner);
62     }
63 
64     /**
65      * @dev Transfers control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function _transferOwnership(address newOwner) internal {
69         require(newOwner != address(0), "Ownable: new owner is the zero address");
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 }
74 
75 library SafeMath {
76 
77     /**
78     * @dev Bulkplies two numbers, throws on overflow.
79     */
80     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81         if (a == 0) {
82             return 0;
83         }
84         uint256 c = a * b;
85         require(c / a == b);
86 
87         return c;
88     }
89 
90     /**
91     * @dev Integer division of two numbers, truncating the quotient.
92     */
93     function div(uint256 a, uint256 b) internal pure returns (uint256) {
94         // assert(b > 0); // Solidity automatically throws when dividing by 0
95         require(b > 0);
96         uint256 c = a / b;
97         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98         return c;
99     }
100 
101     /**
102     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103     */
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         require(b <= a);
106         return a - b;
107     }
108 
109     /**
110     * @dev Adds two numbers, throws on overflow.
111     */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a);
115         return c;
116     }
117 
118     /**
119      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
120      * reverts when dividing by zero.
121      */
122     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
123         require(b != 0);
124         return a % b;
125     }
126 }
127 
128 
129 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
130 
131 contract FIICToken is Ownable {
132     using SafeMath for uint256;
133     // Public variables of the token
134     string public name;
135     string public symbol;
136     uint8 public decimals = 0;
137     // 18 decimals is the strongly suggested default, avoid changing it
138     uint256 public totalSupply;
139 
140     // This creates an array with all balances
141     mapping (address => uint256) public balanceOf;
142     mapping (address => mapping (address => uint256)) public allowance;
143 
144     // accounts' lockFund property
145     struct LockFund {
146         uint256 amount;
147         uint256 startTime;
148         uint256 lockUnit;
149         uint256 times;
150         bool recyclable;
151     }
152     mapping (address => LockFund) public lockFunds;
153 
154     // This generates a public event on the blockchain that will notify clients
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 
157     // This generates a public event on the blockchain that will notify clients
158     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
159 
160     // This notifies clients about the amount burnt
161     event Burn(address indexed from, uint256 value);
162 
163     // lockFund event
164     event LockTransfer(address indexed acc, uint256 amount, uint256 startTime, uint256 lockUnit, uint256 times);
165     
166     //  recycle token 
167     event recycleToke(address indexed acc, uint256 amount, uint256 startTime);
168 
169     /**
170      * Constrctor function
171      *
172      * Initializes contract with initial supply tokens to the creator of the contract
173      */
174     constructor(
175         uint256 initialSupply,
176         string memory tokenName,
177         string memory tokenSymbol
178     ) public {
179         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
180         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
181         name = tokenName;                                       // Set the name for display purposes
182         symbol = tokenSymbol;                                   // Set the symbol for display purposes
183     }
184 
185     /**
186      * Internal transfer, only can be called by this contract
187      */
188     function _transfer(address _from, address _to, uint _value) internal {
189         // Prevent transfer to 0x0 address. Use burn() instead
190         require(_to != address(0x0),"目的地址不能为空");
191         
192         require(_from != _to,"自己不能给自己转账");
193         
194         // if lock
195         require(balanceOf[_from] - getLockedAmount(_from) >= _value,"转账的数量不能超过可用的数量");
196         // Check for overflows
197         require(balanceOf[_to] + _value > balanceOf[_to],"转账的数量有问题");
198         // Save this for an assertion in the future
199         uint previousBalances = balanceOf[_from] + balanceOf[_to];
200         // Subtract from the sender
201         balanceOf[_from] -= _value;
202         // Add the same to the recipient
203         balanceOf[_to] += _value;
204         emit Transfer(_from, _to, _value);
205         // Asserts are used to use static analysis to find bugs in your code. They should never fail
206         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);//"转账前后，两个地址总和不同"
207         
208         
209     }
210 
211     function getLockedAmount(address _from) public view returns (uint256 lockAmount) {
212         LockFund memory lockFund = lockFunds[_from];
213         if(lockFund.amount > 0) {
214             if(block.timestamp <= lockFund.startTime) {
215                 return lockFund.amount;
216             }
217             uint256 ap = lockFund.amount.div(lockFund.times);
218             // uint256 ap = lockFund.amount / lockFund.times;
219             // uint256 t = (block.timestamp - lockFund.startTime ) / lockFund.lockUnit;
220             uint256 t = (block.timestamp.sub(lockFund.startTime)).div(lockFund.lockUnit);
221 //            uint256 t = (block.timestamp - lockFund.startTime) / (60 * 60 * 24) / lockFund.lockUnit;
222             if(t < lockFund.times) {
223                 return lockFund.amount.sub(ap.mul(t));
224             }
225         }
226         return 0;
227     }
228     
229     function getReleaseAmount(address _from) public view returns (uint256 releaseAmount) {
230        LockFund memory lockFund = lockFunds[_from];
231         if(lockFund.amount > 0) {
232             if(block.timestamp <= lockFund.startTime) {
233                 return 0;
234             }
235             uint256 ap = lockFund.amount / lockFund.times;
236             uint256 t = (block.timestamp - lockFund.startTime) / lockFund.lockUnit;
237             if(t>= lockFund.times){
238                 return lockFund.amount;
239             }
240             return ap * t;
241         }
242         return balanceOf[_from];
243         
244     }
245 
246     /**
247      * Transfer tokens
248      *
249      * Send `_value` tokens to `_to` from your account
250      *
251      * @param _to The address of the recipient
252      * @param _value the amount to send
253      */
254     function transfer(address _to, uint256 _value) public returns (bool success) {
255         _transfer(msg.sender, _to, _value);
256         return true;
257     }
258 
259     /**
260      * Transfer tokens from other address
261      *
262      * Send `_value` tokens to `_to` in behalf of `_from`
263      *
264      * @param _from The address of the sender
265      * @param _to The address of the recipient
266      * @param _value the amount to send
267      */
268     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
269         require(_value <= allowance[_from][msg.sender]);     // Check allowance
270         allowance[_from][msg.sender] -= _value;
271         _transfer(_from, _to, _value);
272         return true;
273     }
274 
275     /**
276      * Set allowance for other address
277      *
278      * Allows `_spender` to spend no more than `_value` tokens in your behalf
279      *
280      * @param _spender The address authorized to spend
281      * @param _value the max amount they can spend
282      */
283     function approve(address _spender, uint256 _value) public
284         returns (bool success) {
285         allowance[msg.sender][_spender] = _value;
286         emit Approval(msg.sender, _spender, _value);
287         return true;
288     }
289 
290     /**
291      * Set allowance for other address and notify
292      *
293      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
294      *
295      * @param _spender The address authorized to spend
296      * @param _value the max amount they can spend
297      * @param _extraData some extra information to send to the approved contract
298      */
299     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
300         public
301         returns (bool success) {
302         tokenRecipient spender = tokenRecipient(_spender);
303         if (approve(_spender, _value)) {
304             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
305             return true;
306         }
307     }
308 
309     /**
310      * Destroy tokens
311      *
312      * Remove `_value` tokens from the system irreversibly
313      *
314      * @param _value the amount of money to burn
315      */
316     function burn(uint256 _value) public returns (bool success) {
317         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
318         balanceOf[msg.sender] -= _value;            // Subtract from the sender
319         totalSupply -= _value;                      // Updates totalSupply
320         emit Burn(msg.sender, _value);
321         return true;
322     }
323 
324     /**
325      * Destroy tokens from other account
326      *
327      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
328      *
329      * @param _from the address of the sender
330      * @param _value the amount of money to burn
331      */
332     function burnFrom(address _from, uint256 _value) public returns (bool success) {
333         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
334         require(_value <= allowance[_from][msg.sender]);    // Check allowance
335         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
336         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
337         totalSupply -= _value;                              // Update totalSupply
338         emit Burn(_from, _value);
339         return true;
340     }
341 
342     /**
343      * 锁仓的转账
344      *
345      * 从账户里给其他账户转锁仓的token，token按照一定的时间多次自动释放
346      *
347      * @param _lockAddress          接受锁仓token地址
348      * @param _lockAmount           转账的总量
349      * @param _startReleaseTime     释放起始的时间
350      * @param _releaseInterval      释放的间隔时间
351      * @param _releaseTimes         总共释放的次数
352      * @param _recyclable           是否可回收，true为可以
353      */
354     function lockTransfer(address _lockAddress, uint256 _lockAmount, uint256 _startReleaseTime, uint256 _releaseInterval, uint256 _releaseTimes,bool _recyclable) onlyOwner public {
355         // transfer token to _lockAddress
356         _transfer(msg.sender, _lockAddress, _lockAmount);
357         // add lockFund
358         LockFund storage lockFund = lockFunds[_lockAddress];
359         lockFund.amount = _lockAmount;
360         lockFund.startTime = _startReleaseTime;
361         lockFund.lockUnit = _releaseInterval;
362         lockFund.times = _releaseTimes;
363         lockFund.recyclable = _recyclable;
364 
365         emit LockTransfer(_lockAddress, _lockAmount, _startReleaseTime, _releaseInterval, _releaseTimes);
366     }
367     
368     /**
369      *
370      * 将_lockAddress里的token回收
371      *
372      * @param _lockAddress          回收token的地址
373      */
374     function recycleRemainingToken(address _lockAddress) onlyOwner public{
375         // 将计算还剩下的token数量
376         LockFund storage lockFund = lockFunds[_lockAddress];
377         require(lockFund.recyclable == true,"该地址不支持撤销操作");
378         
379         uint256 remaingCount = getLockedAmount(_lockAddress);
380         
381         // Check for overflows
382         require(balanceOf[owner()] + remaingCount > balanceOf[owner()],"转账的数量有问题");
383         // Save this for an assertion in the future
384         uint previousBalances = balanceOf[owner()] + balanceOf[_lockAddress];
385         // Subtract from the sender
386         balanceOf[_lockAddress] -= remaingCount;
387         // Add the same to the recipient
388         balanceOf[owner()] += remaingCount;
389             
390         lockFund.amount = 0;
391         
392         emit recycleToke(_lockAddress,remaingCount,block.timestamp);
393         emit Transfer(_lockAddress, owner(), remaingCount);
394         // Asserts are used to use static analysis to find bugs in your code. They should never fail
395         assert(balanceOf[owner()] + balanceOf[_lockAddress] == previousBalances);//"转账前后，两个地址总和不同"
396         
397     }
398 }