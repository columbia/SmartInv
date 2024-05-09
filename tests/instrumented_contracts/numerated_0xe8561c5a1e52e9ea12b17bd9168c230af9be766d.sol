1 pragma solidity ^0.4.21;
2 
3 contract Owned {
4     
5     /// 'owner' is the only address that can call a function with 
6     /// this modifier
7     address public owner;
8     address internal newOwner;
9     
10     ///@notice The constructor assigns the message sender to be 'owner'
11     function Owned() public {
12         owner = msg.sender;
13     }
14     
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19     
20     event updateOwner(address _oldOwner, address _newOwner);
21     
22     ///change the owner
23     function changeOwner(address _newOwner) public onlyOwner returns(bool) {
24         require(owner != _newOwner);
25         newOwner = _newOwner;
26         return true;
27     }
28     
29     /// accept the ownership
30     function acceptNewOwner() public returns(bool) {
31         require(msg.sender == newOwner);
32         emit updateOwner(owner, newOwner);
33         owner = newOwner;
34         return true;
35     }
36 }
37 
38 contract SafeMath {
39     function safeMul(uint a, uint b) pure internal returns (uint) {
40         uint c = a * b;
41         assert(a == 0 || c / a == b);
42         return c;
43     }
44     
45     function safeSub(uint a, uint b) pure internal returns (uint) {
46         assert(b <= a);
47         return a - b;
48     }
49     
50     function safeAdd(uint a, uint b) pure internal returns (uint) {
51         uint c = a + b;
52         assert(c>=a && c>=b);
53         return c;
54     }
55 
56 }
57 
58 contract ERC20Token {
59     /* This is a slight change to the ERC20 base standard.
60     function totalSupply() constant returns (uint256 supply);
61     is replaced with:
62     uint256 public totalSupply;
63     This automatically creates a getter function for the totalSupply.
64     This is moved to the base contract since public getter functions are not
65     currently recognised as an implementation of the matching abstract
66     function by the compiler.
67     */
68     /// total amount of tokens
69     uint256 public totalSupply;
70     
71     /// user tokens
72     mapping (address => uint256) public balances;
73     
74     /// @param _owner The address from which the balance will be retrieved
75     /// @return The balance
76     function balanceOf(address _owner) constant public returns (uint256 balance);
77 
78     /// @notice send `_value` token to `_to` from `msg.sender`
79     /// @param _to The address of the recipient
80     /// @param _value The amount of token to be transferred
81     /// @return Whether the transfer was successful or not
82     function transfer(address _to, uint256 _value) public returns (bool success);
83     
84     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
85     /// @param _from The address of the sender
86     /// @param _to The address of the recipient
87     /// @param _value The amount of token to be transferred
88     /// @return Whether the transfer was successful or not
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
90 
91     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
92     /// @param _spender The address of the account able to transfer the tokens
93     /// @param _value The amount of tokens to be approved for transfer
94     /// @return Whether the approval was successful or not
95     function approve(address _spender, uint256 _value) public returns (bool success);
96 
97     /// @param _owner The address of the account owning tokens
98     /// @param _spender The address of the account able to transfer the tokens
99     /// @return Amount of remaining tokens allowed to spent
100     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
101 
102     event Transfer(address indexed _from, address indexed _to, uint256 _value);
103     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
104 }
105 
106 contract PUST is ERC20Token {
107     
108     string public name = "UST Put Option";
109     string public symbol = "PUST";
110     uint public decimals = 0;
111     
112     uint256 public totalSupply = 0;
113     uint256 public topTotalSupply = 2000;
114     
115     function transfer(address _to, uint256 _value) public returns (bool success) {
116     //Default assumes totalSupply can't be over max (2^256 - 1).
117     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
118     //Replace the if with this one instead.
119         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
120             balances[msg.sender] -= _value;
121             balances[_to] += _value;
122             emit Transfer(msg.sender, _to, _value);
123             return true;
124         } else { return false; }
125     }
126     
127     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
128     //same as above. Replace this line with the following if you want to protect against wrapping uints.
129         if (balances[_from] >= _value && allowances[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
130           balances[_to] += _value;
131           balances[_from] -= _value;
132           allowances[_from][msg.sender] -= _value;
133           emit Transfer(_from, _to, _value);
134           return true;
135         } else { return false; }
136     }
137     
138     function balanceOf(address _owner) constant public returns (uint256 balance) {
139         return balances[_owner];
140     }
141     
142     function approve(address _spender, uint256 _value) public returns (bool success) {
143         allowances[msg.sender][_spender] = _value;
144         emit Approval(msg.sender, _spender, _value);
145         return true;
146     }
147     
148     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
149         return allowances[_owner][_spender];
150     }
151     
152     mapping(address => uint256) public balances;
153     
154     mapping (address => mapping (address => uint256)) allowances;
155 }
156 
157 
158 contract ExchangeUST is SafeMath, Owned, PUST {
159     
160     // Exercise End Time 1/1/2019 0:0:0
161     uint public ExerciseEndTime = 1546272000;
162     uint public exchangeRate = 100000; //percentage times (1 ether)
163     //mapping (address => uint) ustValue; //mapping of token addresses to mapping of account balances (token=0 means Ether)
164     
165     // UST address
166     address public ustAddress = address(0xFa55951f84Bfbe2E6F95aA74B58cc7047f9F0644);
167     
168     // offical Address
169     address public officialAddress = address(0x472fc5B96afDbD1ebC5Ae22Ea10bafe45225Bdc6);
170     
171     event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
172     event Deposit(address token, address user, uint amount, uint balance);
173     event Withdraw(address token, address user, uint amount, uint balance);
174     event exchange(address contractAddr, address reciverAddr, uint _pustBalance);
175     event changeFeeAt(uint _exchangeRate);
176 
177     function chgExchangeRate(uint _exchangeRate) public onlyOwner {
178         require (_exchangeRate != exchangeRate);
179         require (_exchangeRate != 0);
180         exchangeRate = _exchangeRate;
181     }
182 
183     function exerciseOption(uint _pustBalance) public returns (bool) {
184         require (now < ExerciseEndTime);
185         require (_pustBalance <= balances[msg.sender]);
186         
187         // convert units from ether to wei
188         uint _ether = safeMul(_pustBalance, 10 ** 18);
189         require (address(this).balance >= _ether); 
190         
191         // UST amount
192         uint _amount = safeMul(_pustBalance, exchangeRate * 10**18);
193         require (PUST(ustAddress).transferFrom(msg.sender, officialAddress, _amount) == true);
194         
195         balances[msg.sender] = safeSub(balances[msg.sender], _pustBalance);
196         balances[officialAddress] = safeAdd(balances[officialAddress], _pustBalance);
197         //totalSupply = safeSub(totalSupply, _pustBalance);
198         msg.sender.transfer(_ether);    
199         emit exchange(address(this), msg.sender, _pustBalance);
200     }
201 }
202 
203 contract USTputOption is ExchangeUST {
204     
205     // constant 
206     uint public initBlockEpoch = 40;
207     uint public eachUserWeight = 10;
208     uint public initEachPUST = 5 * 10**17 wei;
209     uint public lastEpochBlock = block.number + initBlockEpoch;
210     uint public price1=4*9995 * 10**17/10000;
211     uint public price2=99993 * 10**17/100000;
212     uint public eachPUSTprice = initEachPUST;
213     uint public lastEpochTX = 0;
214     uint public epochLast = 0;
215     address public lastCallAddress;
216     uint public lastCallPUST;
217 
218     event buyPUST (address caller, uint PUST);
219     event Reward (address indexed _from, address indexed _to, uint256 _value);
220     
221     function () payable public {
222         require (now < ExerciseEndTime);
223         require (topTotalSupply > totalSupply);
224         bool firstCallReward = false;
225         uint epochNow = whichEpoch(block.number);
226         
227         if(epochNow != epochLast) {
228             
229             lastEpochBlock = safeAdd(lastEpochBlock, ((block.number - lastEpochBlock)/initBlockEpoch + 1)* initBlockEpoch);
230             doReward();
231             eachPUSTprice = calcpustprice(epochNow, epochLast);
232             epochLast = epochNow;
233             //reward _first
234             firstCallReward = true;
235             lastEpochTX = 0;
236         }
237 
238         uint _value = msg.value;
239         uint _PUST = _value / eachPUSTprice;
240         require(_PUST > 0);
241         if (safeAdd(totalSupply, _PUST) > topTotalSupply) {
242             _PUST = safeSub(topTotalSupply, totalSupply);
243         }
244         
245         uint _refound = _value - safeMul(_PUST, eachPUSTprice);
246         
247         if(_refound > 0) {
248             msg.sender.transfer(_refound);
249         }
250         
251         officialAddress.transfer(safeMul(_PUST, eachPUSTprice));
252         
253         balances[msg.sender] = safeAdd(balances[msg.sender], _PUST);
254         totalSupply = safeAdd(totalSupply, _PUST);
255         emit Transfer(address(this), msg.sender, _PUST);
256         
257         // alloc first reward in a new or init epoch
258         if(lastCallAddress == address(0) && epochLast == 0) {
259              firstCallReward = true;
260         }
261         
262         if (firstCallReward) {
263             uint _firstReward = 0;
264             _firstReward = (_PUST - 1) * 2 / 10 + 1;
265             if (safeAdd(totalSupply, _firstReward) > topTotalSupply) {
266                 _firstReward = safeSub(topTotalSupply, totalSupply);
267             }
268             balances[msg.sender] = safeAdd(balances[msg.sender], _firstReward);
269             totalSupply = safeAdd(totalSupply, _firstReward);
270             emit Reward(address(this), msg.sender, _firstReward);
271         }
272         
273         lastEpochTX += 1;
274         
275         // last call address info
276         lastCallAddress = msg.sender;
277         lastCallPUST = _PUST;
278         
279         // calc last epoch
280         lastEpochBlock = safeAdd(lastEpochBlock, eachUserWeight);
281     }
282     
283     // 
284     function whichEpoch(uint _blocknumber) internal view returns (uint _epochNow) {
285         if (lastEpochBlock >= _blocknumber ) {
286             _epochNow = epochLast;
287         } else {
288             //lastEpochBlock = safeAdd(lastEpochBlock, thisEpochBlockCount);
289             //thisEpochBlockCount = initBlockEpoch;
290             _epochNow = epochLast + (_blocknumber - lastEpochBlock) / initBlockEpoch + 1;
291         }
292     }
293     
294     function calcpustprice(uint _epochNow, uint _epochLast) public returns (uint _eachPUSTprice) {
295         require (_epochNow - _epochLast > 0);    
296         uint dif = _epochNow - _epochLast;
297         uint dif100 = dif/100;
298         dif = dif - dif100*100;        
299         for(uint i=0;i<dif100;i++)
300             {
301                 price1 = price1-price1*5/100;
302                 price2 = price2-price2*7/1000;
303             }
304         price1 = price1 - price1*5*dif/10000;
305         price2 = price2 - price2*7*dif/100000;
306         
307         _eachPUSTprice = price1+price2;    
308     }
309     
310     function doReward() internal returns (bool) {
311         if (lastEpochTX == 1) return false;
312         uint _lastReward = 0;
313         
314         if(lastCallPUST > 0) {
315             _lastReward = (lastCallPUST-1) * 2 / 10 + 1;
316         }
317         
318         if (safeAdd(totalSupply, _lastReward) > topTotalSupply) {
319             _lastReward = safeSub(topTotalSupply,totalSupply);
320         }
321         balances[lastCallAddress] = safeAdd(balances[lastCallAddress], _lastReward);
322         totalSupply = safeAdd(totalSupply, _lastReward);
323         emit Reward(address(this), lastCallAddress, _lastReward);
324     }
325 
326     // only owner can deposit ether into put option contract
327     function DepositETH(uint _PUST) payable public {
328         // deposit ether
329         require (msg.sender == officialAddress);
330         topTotalSupply += _PUST;
331     }
332     
333     // only end time, onwer can transfer contract's ether out.
334     function WithdrawETH() payable public onlyOwner {
335         officialAddress.transfer(address(this).balance);
336     } 
337     
338     // if this epoch is the last, then the reward called by the owner
339     function allocLastTxRewardByHand() public onlyOwner returns (bool success) {
340         lastEpochBlock = safeAdd(block.number, initBlockEpoch);
341         doReward();
342         success = true;
343     }
344 }