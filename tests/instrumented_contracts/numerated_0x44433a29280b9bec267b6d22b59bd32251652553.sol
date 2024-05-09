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
40     uint c = a * b;
41     assert(a == 0 || c / a == b);
42     return c;
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
113     uint256 public topTotalSupply = 0;
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
167     // our hardWallet address
168     //address public ustHolderAddress = address(0xe88a5b4b01c683FcE5D6cb4494c8E5705c993145);
169     // offical Address
170     address public officialAddress = address(0x472fc5B96afDbD1ebC5Ae22Ea10bafe45225Bdc6);
171     
172     event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
173     event Deposit(address token, address user, uint amount, uint balance);
174     event Withdraw(address token, address user, uint amount, uint balance);
175     event exchange(address contractAddr, address reciverAddr, uint _pustBalance);
176     event changeFeeAt(uint _exchangeRate);
177 
178     function chgExchangeRate(uint _exchangeRate) public onlyOwner {
179         require (_exchangeRate != exchangeRate);
180         require (_exchangeRate != 0);
181         exchangeRate = _exchangeRate;
182     }
183 
184     function exerciseOption(uint _pustBalance) public returns (bool) {
185         require (now < ExerciseEndTime);
186         require (_pustBalance <= balances[msg.sender]);
187         
188         uint _ether = _pustBalance * 10 ** 18;
189         require (address(this).balance >= _ether); 
190         
191         uint _amount = _pustBalance * exchangeRate * 10**18;
192         require (PUST(ustAddress).transferFrom(msg.sender, officialAddress, _amount) == true);
193         
194         balances[msg.sender] = safeSub(balances[msg.sender], _pustBalance);
195         totalSupply = safeSub(totalSupply, _pustBalance);
196         msg.sender.transfer(_ether);   // convert units from ether to wei 
197         emit exchange(address(this), msg.sender, _pustBalance);
198     }
199 }
200 
201 contract USTputOption is ExchangeUST {
202     
203     // constant 
204     uint public initBlockEpoch = 40;
205     uint public eachUserWeight = 10;
206     uint public initEachPUST = 5*10**17 wei;
207     uint public lastEpochBlock = block.number + initBlockEpoch;
208     uint public price1=4*9995*10**17/10000;
209     uint public price2=99993 * 10**17/100000;
210     uint public eachPUSTprice = initEachPUST;
211     uint public lastEpochTX = 0;
212     uint public epochLast = 0;
213     address public lastCallAddress;
214     uint public lastCallPUST;
215 
216     event buyPUST (address caller, uint PUST);
217     
218     function () payable public {
219         require (now < ExerciseEndTime);
220         require (topTotalSupply > totalSupply);
221         bool firstCallReward = false;
222         uint epochNow = whichEpoch(block.number);
223         
224         if(epochNow != epochLast) {
225             
226             lastEpochBlock = safeAdd(lastEpochBlock, ((block.number - lastEpochBlock)/initBlockEpoch + 1)* initBlockEpoch);
227             doReward();
228             eachPUSTprice = calcpustprice(epochNow, epochLast);
229             epochLast = epochNow;
230             //reward _first
231             firstCallReward = true;
232             lastEpochTX = 0;
233         }
234 
235         uint _value = msg.value;
236         uint _PUST = _value / eachPUSTprice;
237         require(_PUST > 0);
238         if (safeAdd(totalSupply, _PUST) > topTotalSupply) {
239             _PUST = safeSub(topTotalSupply, totalSupply);
240         }
241         uint _refound = _value - _PUST * eachPUSTprice;
242         if(_refound > 0) {
243             msg.sender.transfer(_refound);
244         }
245         
246         balances[msg.sender] = safeAdd(balances[msg.sender], _PUST);
247         totalSupply = safeAdd(totalSupply, _PUST);
248         emit buyPUST(msg.sender, _PUST);
249         
250         // alloc first reward in a new or init epoch
251         if(lastCallAddress == address(0) && epochLast == 0) {
252              firstCallReward = true;
253         }
254         
255         if (firstCallReward) {
256             uint _firstReward = 0;
257             _firstReward = (_PUST - 1) * 2 / 10 + 1;
258             if (safeAdd(totalSupply, _firstReward) > topTotalSupply) {
259                 _firstReward = safeSub(topTotalSupply,totalSupply);
260             }
261             balances[msg.sender] = safeAdd(balances[msg.sender], _firstReward);
262             totalSupply = safeAdd(totalSupply, _firstReward);
263             
264         }
265         
266         
267         lastEpochTX += 1;
268         
269         // last call address info
270         lastCallAddress = msg.sender;
271         lastCallPUST = _PUST;
272         
273         // calc last epoch
274         lastEpochBlock = safeAdd(lastEpochBlock, eachUserWeight);
275     }
276     
277     // 
278     function whichEpoch(uint _blocknumber) internal view returns (uint _epochNow) {
279         if (lastEpochBlock >= _blocknumber ) {
280             _epochNow = epochLast;
281         }
282         else {
283             //lastEpochBlock = safeAdd(lastEpochBlock, thisEpochBlockCount);
284             //thisEpochBlockCount = initBlockEpoch;
285             _epochNow = epochLast + (_blocknumber - lastEpochBlock) / initBlockEpoch + 1;
286         }
287     }
288     
289     function calcpustprice(uint _epochNow, uint _epochLast) public returns (uint _eachPUSTprice) {
290         require (_epochNow - _epochLast > 0);    
291         uint dif = _epochNow - _epochLast;
292         uint dif100 = dif/100;
293         dif = dif - dif100*100;        
294         for(uint i=0;i<dif100;i++)
295             {
296                 price1 = price1-price1*5/100;
297                 price2 = price2-price2*7/1000;
298             }
299         price1 = price1 - price1*5*dif/10000;
300         price2 = price2 - price2*7*dif/100000;
301         
302         _eachPUSTprice = price1+price2;    
303     }
304     
305     function doReward() internal returns (bool) {
306         if (lastEpochTX == 1) return false;
307         uint _lastReward = 0;
308         
309         if(lastCallPUST != 0) {
310             _lastReward = (lastCallPUST-1) * 2 / 10 + 1;
311         }
312         
313         if (safeAdd(totalSupply, _lastReward) > topTotalSupply) {
314             _lastReward = safeSub(topTotalSupply,totalSupply);
315         }
316         balances[lastCallAddress] = safeAdd(balances[lastCallAddress], _lastReward);
317         totalSupply = safeAdd(totalSupply, _lastReward);
318     }
319 
320     // only owner can deposit ether into put option contract
321     function DepositETH() payable public {
322         // deposit ether
323         require (msg.sender == officialAddress);
324         topTotalSupply += msg.value / 10**18;
325     }
326     
327     // only end time, onwer can transfer contract's ether out.
328     function WithdrawETH() payable public onlyOwner {
329         require (now >= ExerciseEndTime);
330         officialAddress.transfer(address(this).balance);
331     } 
332     
333     // if this epoch is the last, then the reward called by the owner
334     function allocLastTxRewardByHand() public onlyOwner returns (bool success) {
335         lastEpochBlock = safeAdd(block.number, initBlockEpoch);
336         doReward();
337         success = true;
338     }
339 }