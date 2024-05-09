1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4 
5   function mul(uint a, uint b) internal constant returns (uint) {
6     if (a == 0) {
7       return 0;
8     }
9     uint c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal constant returns(uint) {
15     assert(b > 0);
16     uint c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal constant returns(uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal constant returns(uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ERC20 {
34     uint public totalSupply = 0;
35 
36     mapping(address => uint256) balances;
37     mapping(address => mapping (address => uint256)) allowed;
38 
39     function balanceOf(address _owner) constant returns (uint);
40     function transfer(address _to, uint _value) returns (bool);
41     function transferFrom(address _from, address _to, uint _value) returns (bool);
42     function approve(address _spender, uint _value) returns (bool);
43     function allowance(address _owner, address _spender) constant returns (uint);
44 
45     event Transfer(address indexed _from, address indexed _to, uint _value);
46     event Approval(address indexed _owner, address indexed _spender, uint _value);
47 
48 } // Functions of ERC20 standard
49 
50 
51 
52 contract DatariusICO {
53     using SafeMath for uint;
54 
55     uint public constant Tokens_For_Sale = 146000000*1e18; // Tokens for Sale without bonuses(HardCap)
56     uint public constant Total_Amount = 200000000*1e18; // Fixed total supply
57     uint public Sold = 0;
58 
59     uint CONST_DEL = 1000;
60 
61     uint public Tokens_Per_Dollar = 2179;
62     uint public Rate_Eth = 446; // Rate USD per ETH
63     uint public Token_Price = Tokens_Per_Dollar * Rate_Eth / CONST_DEL; // DAT per ETH
64 
65     event LogStartPreICO();
66     event LogStartICO();
67     event LogPause();
68     event LogFinishPreICO();
69     event LogFinishICO(address ReserveFund);
70     event LogBuyForInvestor(address investor, uint datValue, string txHash);
71 
72     DAT public dat = new DAT(this);
73 
74     address public Company;
75     address public BountyFund;
76     address public SupportFund;
77     address public ReserveFund;
78     address public TeamFund;
79 
80     address public Manager; // Manager controls contract
81     address public Controller_Address1; // First address that is used to buy tokens for other cryptos
82     address public Controller_Address2; // Second address that is used to buy tokens for other cryptos
83     address public Controller_Address3; // Third address that is used to buy tokens for other cryptos
84     modifier managerOnly { require(msg.sender == Manager); _; }
85     modifier controllersOnly {
86       require((msg.sender == Controller_Address1) || (msg.sender == Controller_Address2) || (msg.sender == Controller_Address3));
87       _;
88     }
89 
90     uint startTime = 0;
91     uint bountyAmount = 4000000*1e18;
92     uint supportAmount = 10000000*1e18;
93     uint reserveAmount = 24000000*1e18;
94     uint teamAmount = 16000000*1e18;
95 
96     enum Status {
97                   Created,
98                   PreIcoStarted,
99                   PreIcoFinished,
100                   PreIcoPaused,
101                   IcoPaused,
102                   IcoStarted,
103                   IcoFinished
104                   }
105     Status status = Status.Created;
106 
107     function DatariusICO(
108                           address _Company,
109                           address _BountyFund,
110                           address _SupportFund,
111                           address _ReserveFund,
112                           address _TeamFund,
113                           address _Manager,
114                           address _Controller_Address1,
115                           address _Controller_Address2,
116                           address _Controller_Address3
117                           ) public {
118        Company = _Company;
119        BountyFund = _BountyFund;
120        SupportFund = _SupportFund;
121        ReserveFund = _ReserveFund;
122        TeamFund = _TeamFund;
123        Manager = _Manager;
124        Controller_Address1 = _Controller_Address1;
125        Controller_Address2 = _Controller_Address2;
126        Controller_Address3 = _Controller_Address3;
127     }
128 
129 // function for changing rate of ETH and price of token
130 
131 
132     function setRate(uint _RateEth) external managerOnly {
133        Rate_Eth = _RateEth;
134        Token_Price = Tokens_Per_Dollar*Rate_Eth/CONST_DEL;
135     }
136 
137 
138 //ICO status functions
139 
140     function startPreIco() external managerOnly {
141        require(status == Status.Created || status == Status.PreIcoPaused);
142        if(status == Status.Created) {
143            dat.mint(BountyFund, bountyAmount);
144            dat.mint(SupportFund, supportAmount);
145            dat.mint(ReserveFund, reserveAmount);
146            dat.mint(TeamFund, teamAmount);
147        }
148        status = Status.PreIcoStarted;
149        LogStartPreICO();
150     }
151 
152     function finishPreIco() external managerOnly { // Funds for minting of tokens
153        require(status == Status.PreIcoStarted || status == Status.PreIcoPaused);
154 
155        status = Status.PreIcoFinished;
156        LogFinishPreICO();
157     }
158 
159 
160     function startIco() external managerOnly {
161        require(status == Status.PreIcoFinished || status == Status.IcoPaused);
162        if(status == Status.PreIcoFinished) {
163          startTime = now;
164        }
165        status = Status.IcoStarted;
166        LogStartICO();
167     }
168 
169     function finishIco() external managerOnly { // Funds for minting of tokens
170 
171        require(status == Status.IcoStarted || status == Status.IcoPaused);
172 
173        uint alreadyMinted = dat.totalSupply(); //=PublicICO+PrivateOffer
174 
175        dat.mint(ReserveFund, Total_Amount.sub(alreadyMinted)); //
176 
177        dat.defrost();
178 
179        status = Status.IcoFinished;
180        LogFinishICO(ReserveFund);
181     }
182 
183     function pauseIco() external managerOnly {
184        require(status == Status.IcoStarted);
185        status = Status.IcoPaused;
186        LogPause();
187     }
188     function pausePreIco() external managerOnly {
189        require(status == Status.PreIcoStarted);
190        status = Status.PreIcoPaused;
191        LogPause();
192     }
193 
194 // function that buys tokens when investor sends ETH to address of ICO
195     function() external payable {
196 
197        buy(msg.sender, msg.value * Token_Price);
198     }
199 
200 // function for buying tokens to investors who paid in other cryptos
201 
202     function buyForInvestor(address _investor, uint _datValue, string _txHash) external controllersOnly {
203        buy(_investor, _datValue);
204        LogBuyForInvestor(_investor, _datValue, _txHash);
205     }
206 
207 // internal function for buying tokens
208 
209     function buy(address _investor, uint _datValue) internal {
210        require((status == Status.PreIcoStarted) || (status == Status.IcoStarted));
211        require(_datValue > 0);
212 
213        uint bonus = getBonus(_datValue);
214 
215        uint total = _datValue.add(bonus);
216 
217        require(Sold + total <= Tokens_For_Sale);
218        dat.mint(_investor, total);
219        Sold = Sold.add(_datValue);
220     }
221 
222 // function that calculates bonus
223     function getBonus(uint _value) public constant returns (uint) {
224        uint bonus = 0;
225        uint time = now;
226        if(status == Status.PreIcoStarted) {
227             bonus = _value.mul(35).div(100);
228             return bonus;
229        } else {
230             if(time <= startTime + 6 hours)
231             {
232 
233                   bonus = _value.mul(30).div(100);
234                   return bonus;
235             }
236 
237             if(time <= startTime + 12 hours)
238             {
239                   bonus = _value.mul(25).div(100);
240                   return bonus;
241             }
242 
243             if(time <= startTime + 24 hours)
244             {
245 
246                   bonus = _value.mul(20).div(100);
247                   return bonus;
248             }
249 
250             if(time <= startTime + 48 hours)
251             {
252 
253                   bonus = _value.mul(10).div(100);
254                   return bonus;
255             }
256        }
257        return bonus;
258     }
259 
260 //function to withdraw ETH from smart contract
261 
262     function withdrawEther(uint256 _value) external managerOnly {
263        require((status == Status.PreIcoFinished) || (status == Status.IcoFinished));
264        Company.transfer(_value);
265     }
266 
267 }
268 
269 contract DAT  is ERC20 {
270     using SafeMath for uint;
271 
272     string public name = "Datarius Token";
273     string public symbol = "DAT";
274     uint public decimals = 18;
275 
276     address public ico;
277 
278     event Burn(address indexed from, uint256 value);
279 
280     bool public tokensAreFrozen = true;
281 
282     modifier icoOnly { require(msg.sender == ico); _; }
283 
284     function DAT(address _ico) public {
285        ico = _ico;
286     }
287 
288 
289     function mint(address _holder, uint _value) external icoOnly {
290        require(_value > 0);
291        balances[_holder] = balances[_holder].add(_value);
292        totalSupply = totalSupply.add(_value);
293        Transfer(0x0, _holder, _value);
294     }
295 
296 
297     function defrost() external icoOnly {
298        tokensAreFrozen = false;
299     }
300 
301     function burn(uint256 _value) {
302        require(!tokensAreFrozen);
303        balances[msg.sender] = balances[msg.sender].sub(_value);
304        totalSupply = totalSupply.sub(_value);
305        Burn(msg.sender, _value);
306     }
307 
308 
309     function balanceOf(address _owner) constant returns (uint256) {
310          return balances[_owner];
311     }
312 
313 
314     function transfer(address _to, uint256 _amount) public returns (bool) {
315         require(!tokensAreFrozen);
316         balances[msg.sender] = balances[msg.sender].sub(_amount);
317         balances[_to] = balances[_to].add(_amount);
318         Transfer(msg.sender, _to, _amount);
319         return true;
320     }
321 
322 
323     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
324         require(!tokensAreFrozen);
325         balances[_from] = balances[_from].sub(_amount);
326         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
327         balances[_to] = balances[_to].add(_amount);
328         Transfer(_from, _to, _amount);
329         return true;
330      }
331 
332 
333     function approve(address _spender, uint256 _amount) public returns (bool) {
334         // To change the approve amount you first have to reduce the addresses`
335         //  allowance to zero by calling `approve(_spender, 0)` if it is not
336         //  already 0 to mitigate the race condition described here:
337         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
338         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
339 
340         allowed[msg.sender][_spender] = _amount;
341         Approval(msg.sender, _spender, _amount);
342         return true;
343     }
344 
345 
346     function allowance(address _owner, address _spender) constant returns (uint256) {
347         return allowed[_owner][_spender];
348     }
349 }