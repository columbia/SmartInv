1 pragma solidity ^0.4.19;
2 //   Ubecoin. All Rights Reserved
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract owned {
30     address public owner;
31     address public newOwner;
32 
33     function owned() payable {
34         owner = msg.sender;
35     }
36     
37     modifier onlyOwner {
38         require(owner == msg.sender);
39         _;
40     }
41 
42     function changeOwner(address _owner) onlyOwner public {
43         require(_owner != 0);
44         newOwner = _owner;
45     }
46     
47     function confirmOwner() public {
48         require(newOwner == msg.sender);
49         owner = newOwner;
50         delete newOwner;
51     }
52 }
53 
54 contract StandardToken {
55     using SafeMath for uint256;
56 
57     mapping (address => mapping (address => uint256)) allowed;
58     mapping(address => uint256) balances;
59     uint256 public totalSupply;  
60     
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63     /**
64     * @dev transfer token for a specified address
65     * @param _to The address to transfer to.
66     * @param _value The amount to be transferred.
67     */
68     function transfer(address _to, uint256 _value) public returns (bool) {
69       require(_to != address(0));
70 
71       // SafeMath.sub will throw if there is not enough balance.
72       balances[msg.sender] = balances[msg.sender].sub(_value);
73       balances[_to] = balances[_to].add(_value);
74       Transfer(msg.sender, _to, _value);
75       return true;
76     }
77 
78     /**
79     * @dev Gets the balance of the specified address.
80     * @param _owner The address to query the the balance of. 
81     * @return An uint256 representing the amount owned by the passed address.
82     */
83     function balanceOf(address _owner) public constant returns (uint256 balance) {
84       return balances[_owner];
85     }
86 
87 
88     /**
89     * @dev Transfer tokens from one address to another
90     * @param _from address The address which you want to send tokens from
91     * @param _to address The address which you want to transfer to
92     * @param _value uint256 the amount of tokens to be transferred
93     */
94     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
95       require(_to != address(0));
96 
97       var _allowance = allowed[_from][msg.sender];
98 
99       // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
100       // require (_value <= _allowance);
101 
102       balances[_from] = balances[_from].sub(_value);
103       balances[_to] = balances[_to].add(_value);
104       allowed[_from][msg.sender] = _allowance.sub(_value);
105       Transfer(_from, _to, _value);
106       return true;
107     }
108 
109     /**
110     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
111     * @param _spender The address which will spend the funds.
112     * @param _value The amount of tokens to be spent.
113     */
114     function approve(address _spender, uint256 _value) public returns (bool) {
115 
116       // To change the approve amount you first have to reduce the addresses`
117       //  allowance to zero by calling `approve(_spender, 0)` if it is not
118       //  already 0 to mitigate the race condition described here:
119       //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
120       require((_value == 0) || (allowed[msg.sender][_spender] == 0));
121 
122       allowed[msg.sender][_spender] = _value;
123       Approval(msg.sender, _spender, _value);
124       return true;
125     }
126 
127     /**
128     * @dev Function to check the amount of tokens that an owner allowed to a spender.
129     * @param _owner address The address which owns the funds.
130     * @param _spender address The address which will spend the funds.
131     * @return A uint256 specifying the amount of tokens still available for the spender.
132     */
133     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
134       return allowed[_owner][_spender];
135     }
136     
137     /**
138     * approve should be called when allowed[_spender] == 0. To increment
139     * allowed value is better to use this function to avoid 2 calls (and wait until 
140     * the first transaction is mined)
141     * From MonolithDAO Token.sol
142     */
143     function increaseApproval (address _spender, uint _addedValue) public
144       returns (bool success) {
145       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
146       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147       return true;
148     }
149 
150     function decreaseApproval (address _spender, uint _subtractedValue) public
151       returns (bool success) {
152       uint oldValue = allowed[msg.sender][_spender];
153       if (_subtractedValue > oldValue) {
154         allowed[msg.sender][_spender] = 0;
155       } else {
156         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
157       }
158       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159       return true;
160     }
161 }
162 
163 
164 contract UbecoinICO is owned {
165     using SafeMath for uint256;
166     string public version = "1.0";
167     address private WITHDRAW_WALLET;
168     uint256 public totalSold = 0;
169     uint256 public soldOnStage = 0;
170     uint8 public currentStage = 0;
171     Ubecoin public rewardToken;
172 
173 
174     uint256[] tokensRate = [4200];
175     uint256[] tokensCap = [80000000];
176     mapping(address=>uint256) investments;
177     uint256 limit_on_beneficiary = 1000 * 1000 ether;
178 
179     function investmentsOf(address beneficiary) public constant returns(uint256) {
180       return investments[beneficiary];
181     }
182   
183     function availableOnStage() public constant returns(uint256) {
184         return tokensCap[currentStage].mul(1 ether).sub(soldOnStage);
185     }
186 
187     function createTokenContract() internal returns (Ubecoin) {
188       return new Ubecoin();
189     }
190 
191     function currentStageTokensCap() public constant returns(uint256) {
192       return tokensCap[currentStage];
193     }
194     function currentStageTokensRate() public constant returns(uint256) {
195       return tokensRate[currentStage];
196     }
197 
198     function UbecoinICO() payable owned() {
199         owner = msg.sender;
200         WITHDRAW_WALLET = msg.sender; 
201         rewardToken = createTokenContract();
202     }
203 
204     function () payable {
205         buyTokens(msg.sender);
206     }
207 
208     function buyTokens(address beneficiary) payable {
209       bool canBuy = investmentsOf(beneficiary) < limit_on_beneficiary;
210       bool validPurchase = beneficiary != 0x0 && msg.value != 0;
211       uint256 currentTokensAmount = availableTokens();
212       require(canBuy && validPurchase && currentTokensAmount > 0);
213       uint256 boughtTokens;
214       uint256 refundAmount = 0;
215       
216       uint256[2] memory tokensAndRefund = calcMultiStage();
217       boughtTokens = tokensAndRefund[0];
218       refundAmount = tokensAndRefund[1];
219 
220       require(boughtTokens < currentTokensAmount);
221 
222       totalSold = totalSold.add(boughtTokens);
223       investments[beneficiary] = investments[beneficiary].add(boughtTokens);
224       if( soldOnStage >= tokensCap[currentStage].mul(1 ether)) {
225         toNextStage();
226       } 
227       
228       rewardToken.transfer(beneficiary,boughtTokens);
229       if (refundAmount > 0) 
230           refundMoney(refundAmount);
231 
232       withdrawFunds(this.balance);
233     }
234 
235     function forceWithdraw() onlyOwner {
236       withdrawFunds(this.balance);
237     }
238 
239     function calcMultiStage() internal returns(uint256[2]) {
240       uint256 stageBoughtTokens;
241       uint256 undistributedAmount = msg.value; 
242       uint256 _boughtTokens = 0; 
243       uint256 undistributedTokens = availableTokens(); 
244 
245       while(undistributedAmount > 0 && undistributedTokens > 0) {
246         bool needNextStage = false; 
247         
248         stageBoughtTokens = getTokensAmount(undistributedAmount);
249         
250 
251         if(totalInvestments(_boughtTokens.add(stageBoughtTokens)) > limit_on_beneficiary){
252           stageBoughtTokens = limit_on_beneficiary.sub(_boughtTokens);
253           undistributedTokens = stageBoughtTokens; 
254         }
255 
256         
257         if (stageBoughtTokens > availableOnStage()) {
258           stageBoughtTokens = availableOnStage();
259           needNextStage = true; 
260         }
261         
262         _boughtTokens = _boughtTokens.add(stageBoughtTokens);
263         undistributedTokens = undistributedTokens.sub(stageBoughtTokens); 
264         undistributedAmount = undistributedAmount.sub(getTokensCost(stageBoughtTokens)); 
265         soldOnStage = soldOnStage.add(stageBoughtTokens);
266         if (needNextStage) 
267           toNextStage();
268       }
269       return [_boughtTokens,undistributedAmount];
270     }
271 
272 
273     function setWithdrawWallet(address addressToWithdraw) public onlyOwner {
274         require(addressToWithdraw != 0x0);
275         WITHDRAW_WALLET = addressToWithdraw;
276     }
277     function totalInvestments(uint additionalAmount) internal returns (uint256) {
278       return investmentsOf(msg.sender).add(additionalAmount);
279     }
280 
281     function refundMoney(uint256 refundAmount) internal {
282       msg.sender.transfer(refundAmount);
283     }
284 
285     function burnTokens(uint256 amount) public onlyOwner {
286       rewardToken.burn(amount);
287     }
288 
289     function getTokensCost(uint256 _tokensAmount) internal constant returns(uint256) {
290       return _tokensAmount.div(tokensRate[currentStage]);
291     } 
292 
293     function getTokensAmount(uint256 _amountInWei) internal constant returns(uint256) {
294       return _amountInWei.mul(tokensRate[currentStage]);
295     }
296 
297     function toNextStage() internal {
298         
299         if(currentStage < tokensRate.length && currentStage < tokensCap.length){
300           currentStage++;
301           soldOnStage = 0;
302         }
303     }
304 
305     function availableTokens() public constant returns(uint256) {
306         return rewardToken.balanceOf(address(this));
307     }
308 
309     function withdrawFunds(uint256 amount) internal {
310         WITHDRAW_WALLET.transfer(amount);
311     }
312 }
313 
314 
315 contract Ubecoin is StandardToken {
316       event Burn(address indexed burner, uint256 value);
317 
318       string public constant name = "Ubecoin";
319       string public constant symbol = "UBE";
320       uint8 public constant decimals = 18;
321       string public version = "1.0";
322       uint256 public totalSupply  = 3000000000 * 1 ether;
323       mapping(address=>uint256) premineOf;
324       address[] private premineWallets = [
325           0xc1b1dCA667619888EF005fA515472FC8058856D9, 
326           0x2aB549AF98722F013432698D1D74027c5897843B
327       ];
328 
329       function Ubecoin() public {
330         balances[msg.sender] = totalSupply;
331         premineOf[premineWallets[0]] = 300000000 * 1 ether; 
332         premineOf[premineWallets[1]] = 2620000000 * 1 ether;
333                 
334         for(uint i = 0; i<premineWallets.length;i++) {
335           transfer(premineWallets[i],premineOf[premineWallets[i]]);
336         }
337       }
338 
339     /**
340      * @dev Burns a specific amount of tokens.
341      * @param _value The amount of token to be burned.
342      */
343     function burn(uint256 _value) public {
344         require(_value > 0);
345 
346         address burner = msg.sender;
347         balances[burner] = balances[burner].sub(_value);
348         totalSupply = totalSupply.sub(_value);
349         Burn(burner, _value);
350     }
351   }