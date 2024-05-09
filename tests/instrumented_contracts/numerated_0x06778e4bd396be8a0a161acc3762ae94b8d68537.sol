1 pragma solidity 0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16     if (a == 0) {
17       return 0;
18     }
19     c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 // File: contracts/BasicToken.sol
53 
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances.
57  */
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62 
63   uint256 totalSupply_;
64 
65   /**
66   * @dev total number of tokens in existence
67   */
68   function totalSupply() public view returns (uint256) {
69     return totalSupply_;
70   }
71 
72   /**
73   * @dev transfer token for a specified address
74   * @param _to The address to transfer to.
75   * @param _value The amount to be transferred.
76   */
77   function transfer(address _to, uint256 _value) public returns (bool) {
78     require(_to != address(0));
79     require(_value <= balances[msg.sender]);
80 
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     emit Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of.
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) public view returns (uint256) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 // File: contracts/lottodaotoken.sol
99 
100 contract LottodaoTemplate {
101     function fund(uint256 withdrawn) public payable;
102     function redeem(address account, uint256 amount) public;
103 }
104 
105 contract LottodaoToken is BasicToken {
106     string public name = "Lottodao Token";
107     string public symbol = "LDAO";
108     uint8 public decimals = 0;
109     uint256 public cap = 5000000;
110 
111     uint256 public raised;
112     
113     address public owner;
114     uint256 public initialTokenPrice;
115 
116     uint256 public ethBalance;
117     address private _lottodaoAddress;
118     uint256 private _withdrawLimit = 80 ether;
119     uint256 private _withdrawn;
120 
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123     event Mint(address indexed to, uint256 amount);
124     event TokenPurchase(address indexed to, uint256 units);
125     event Redeem(address indexed to, uint256 units);
126 
127     constructor (address _owner, uint256 _initialTokenPrice) public {
128         initialTokenPrice = _initialTokenPrice;
129         owner = _owner;
130     }
131 
132     modifier onlyOwner() {
133         require(msg.sender == owner);
134         _;
135     }
136 
137     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
138         require(totalSupply_ + _amount <= cap);
139 
140         totalSupply_ = totalSupply_.add(_amount);
141         balances[_to] = balances[_to].add(_amount);
142         emit Mint(_to, _amount);
143         emit Transfer(address(0), _to, _amount);
144         
145         return true;
146     }
147 
148     function _mint(address _to, uint256 _amount) private returns (bool) {
149         require(_amount>0 && totalSupply_ + _amount <= cap);
150 
151         totalSupply_ = totalSupply_.add(_amount);
152         balances[_to] = balances[_to].add(_amount);
153         emit Mint(_to, _amount);
154         emit Transfer(address(0), _to, _amount);
155         
156         return true;
157     }
158 
159     function transferOwnership(address newOwner) public onlyOwner {
160         require(newOwner != address(0));
161         emit OwnershipTransferred(owner, newOwner);
162         owner = newOwner;
163     }
164 
165     function setLottodaoAddress(address lottodaoAddress) public onlyOwner {
166         _lottodaoAddress = lottodaoAddress;
167     }
168 
169     /*
170         transfer funds to Lottodo smart contract
171     */
172     function transferFundsToContract() public onlyOwner {
173         require(_lottodaoAddress!=0x0000000000000000000000000000000000000000 && ethBalance>0);
174         LottodaoTemplate t = LottodaoTemplate(_lottodaoAddress);
175         uint256 bal = ethBalance;
176         ethBalance = 0;
177         t.fund.value(bal)(_withdrawn);
178     }
179 
180     function getWithdrawalLimit() public view returns (uint256){
181         uint8 tranch = getTranch(totalSupply_);
182         uint256 max = _withdrawLimit.mul(tranch);
183         uint256 bal = max-_withdrawn;
184         if(bal>ethBalance){
185             bal = ethBalance;
186         }
187         return bal;
188     }
189 
190     function withdrawFunds(address to, uint256 amount) public onlyOwner {
191         uint256 available = getWithdrawalLimit();
192         require(amount<=available);
193         _withdrawn = _withdrawn.add(amount);
194         ethBalance = ethBalance.sub(amount);
195         to.transfer(amount);
196     }
197 
198 
199     function redeem(address account) public{
200         require(_lottodaoAddress!=0x0000000000000000000000000000000000000000 && (msg.sender==owner || msg.sender==account) && balances[account]>0);
201         uint256 bal = balances[account];
202         balances[account] = 0;
203         balances[_lottodaoAddress].add(bal);
204         LottodaoTemplate t = LottodaoTemplate(_lottodaoAddress);
205         t.redeem(account, bal);
206         emit Redeem(account, bal);
207     }
208 
209  
210     function getTranchEnd(uint8 tranch) public view returns (uint256){
211         if(tranch==1){
212             return cap.div(2).add(cap.div(8));
213         }
214         else if(tranch==2){
215             return cap.div(8).add(getTranchEnd(1));
216         }
217         else if(tranch==3){
218             return cap.div(8).add(getTranchEnd(2));
219         }
220         else{
221             return cap;
222         }
223     }
224 
225     function getTranch(uint256 units) public view returns (uint8){
226         if(units<getTranchEnd(1)){
227             return 1;
228         }
229         else if(units<getTranchEnd(2)){
230             return 2;
231         }
232         else if(units<getTranchEnd(3)){
233             return 3;
234         }
235         else{
236             return 4;
237         }
238     }
239 
240     function getTokenPriceForTranch(uint8 tranch) public view returns (uint256){
241         
242         if(tranch==1){
243             return initialTokenPrice;
244         }
245         else if(tranch==2){
246             return initialTokenPrice.mul(5).div(10).add(getTokenPriceForTranch(1));
247         }
248         else if(tranch==3){
249              return initialTokenPrice.mul(5).div(10).add(getTokenPriceForTranch(2));
250         }
251         else{
252              return initialTokenPrice.mul(5).div(10).add(getTokenPriceForTranch(3));
253         }
254     }
255 
256     function getNumTokensForEth(uint256 eth) public view returns (uint256 units, uint256 balance){
257        uint8 tranch = getTranch(totalSupply_);
258        uint256 start = totalSupply_;
259        uint256 _units = 0;
260        uint256 bal = eth;
261        while(tranch<=4 && bal>0){
262             uint256 tranchEnd = getTranchEnd(tranch);
263             uint256 unitLimit = tranchEnd.sub(start);
264             uint256 price = getTokenPriceForTranch(tranch);
265             uint256 tranchUnits = bal.div(price);
266             if(tranchUnits>unitLimit){
267                 tranchUnits = unitLimit;
268             }
269             _units = _units.add(tranchUnits);
270             bal = bal.sub(tranchUnits.mul(price));
271             start = tranchEnd;
272             tranch += 1;
273        }
274        units = _units;
275        balance = bal;
276        
277        if(_units.add(totalSupply_)<=cap){
278             units = _units;
279             balance = bal;
280        }
281        else{
282            uint256 dif = _units.add(totalSupply_).sub(cap);
283            units = _units.sub(dif);
284            balance = bal.add(dif);
285        }
286        
287 
288     }
289 
290     function purchase() public payable{
291         (uint256 units, uint256 remainder) = getNumTokensForEth(msg.value);
292         if(units>0){
293             _mint(msg.sender,units);
294             if(remainder>0){
295                 uint256 amnt = msg.value.sub(remainder);
296                 ethBalance = ethBalance.add(amnt);
297                 raised = raised.add(amnt);
298                 msg.sender.transfer(remainder);
299             }
300             else{
301                 ethBalance = ethBalance.add(msg.value);
302                 raised = raised.add(msg.value);
303             }
304         }
305         else{
306             if(remainder>0){
307                 msg.sender.transfer(remainder);
308             }
309         }
310         
311     }
312 
313     function() public payable {
314         ethBalance.add(msg.value);
315     }
316 }