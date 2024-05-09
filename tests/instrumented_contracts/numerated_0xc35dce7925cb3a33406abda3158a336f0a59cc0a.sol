1 library SafeMath {
2     function mul(uint a, uint b) internal returns (uint) {
3         uint c = a * b;
4         assert(a == 0 || c / a == b);
5         return c;
6     }
7     function div(uint a, uint b) internal returns (uint) {
8         assert(b > 0);
9         uint c = a / b;
10         assert(a == b * c + a % b);
11         return c;
12     }
13     function sub(uint a, uint b) internal returns (uint) {
14         assert(b <= a);
15         return a - b;
16      }
17     function add(uint a, uint b) internal returns (uint) {
18          uint c = a + b;
19          assert(c >= a);
20          return c;
21      }
22     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
23         return a >= b ? a : b;
24      }
25 
26     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
27         return a < b ? a : b;
28     }
29 
30     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
31         return a >= b ? a : b;
32     }
33 
34     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
35         return a < b ? a : b;
36     }
37 }
38 
39 contract tokenPCT {
40     /* Public variables of the token */
41         string public name;
42         string public symbol;
43         uint8 public decimals;
44         uint256 public totalSupply = 0;
45 
46 
47         function tokenPCT (string _name, string _symbol, uint8 _decimals){
48             name = _name;
49             symbol = _symbol;
50             decimals = _decimals;
51 
52         }
53     /* This creates an array with all balances */
54         mapping (address => uint256) public balanceOf;
55 
56 }
57 
58 contract Presale is tokenPCT {
59 
60         using SafeMath for uint;
61         string name = 'Presale CryptoTickets Token';
62         string symbol = 'PCT';
63         uint8 decimals = 18;
64         address manager;
65         address public ico;
66 
67         function Presale (address _manager) tokenPCT (name, symbol, decimals){
68              manager = _manager;
69 
70         }
71 
72         event Transfer(address _from, address _to, uint256 amount);
73         event Burn(address _from, uint256 amount);
74 
75         modifier onlyManager{
76              require(msg.sender == manager);
77             _;
78         }
79 
80         modifier onlyIco{
81              require(msg.sender == ico);
82             _;
83         }
84         function mintTokens(address _investor, uint256 _mintedAmount) public onlyManager {
85              balanceOf[_investor] = balanceOf[_investor].add(_mintedAmount);
86              totalSupply = totalSupply.add(_mintedAmount);
87              Transfer(this, _investor, _mintedAmount);
88 
89         }
90 
91         function burnTokens(address _owner) public onlyIco{
92              uint  tokens = balanceOf[_owner];
93              require(balanceOf[_owner] != 0);
94              balanceOf[_owner] = 0;
95              totalSupply = totalSupply.sub(tokens);
96              Burn(_owner, tokens);
97         }
98 
99         function setIco(address _ico) onlyManager{
100             ico = _ico;
101         }
102 }
103 
104 contract ERC20 {
105     uint public totalSupply = 0;
106 
107     mapping(address => uint256) balances;
108     mapping(address => mapping (address => uint256)) allowed;
109 
110     function balanceOf(address _owner) constant returns (uint);
111     function transfer(address _to, uint _value) returns (bool);
112     function transferFrom(address _from, address _to, uint _value) returns (bool);
113     function approve(address _spender, uint _value) returns (bool);
114     function allowance(address _owner, address _spender) constant returns (uint);
115 
116     event Transfer(address indexed _from, address indexed _to, uint _value);
117     event Approval(address indexed _owner, address indexed _spender, uint _value);
118 
119 } // Functions of ERC20 standard
120 
121 
122 
123 contract CryptoTicketsICO {
124     using SafeMath for uint;
125 
126     uint public constant Tokens_For_Sale = 525000000*1e18; // Tokens for Sale without bonuses(HardCap)
127 
128     // Style: Caps should not be used for vars, only for consts!
129     uint public Rate_Eth = 298; // Rate USD per ETH
130     uint public Token_Price = 25 * Rate_Eth; // TKT per ETH
131     uint public SoldNoBonuses = 0; //Sold tokens without bonuses
132 
133 
134     event LogStartICO();
135     event LogPauseICO();
136     event LogFinishICO(address bountyFund, address advisorsFund, address itdFund, address storageFund);
137     event LogBuyForInvestor(address investor, uint tktValue, string txHash);
138     event LogReplaceToken(address investor, uint tktValue);
139 
140     TKT public tkt = new TKT(this);
141     Presale public presale;
142 
143     address public Company;
144     address public BountyFund;
145     address public AdvisorsFund;
146     address public ItdFund;
147     address public StorageFund;
148 
149     address public Manager; // Manager controls contract
150     address public Controller_Address1; // First address that is used to buy tokens for other cryptos
151     address public Controller_Address2; // Second address that is used to buy tokens for other cryptos
152     address public Controller_Address3; // Third address that is used to buy tokens for other cryptos
153     modifier managerOnly { require(msg.sender == Manager); _; }
154     modifier controllersOnly { require((msg.sender == Controller_Address1) || (msg.sender == Controller_Address2) || (msg.sender == Controller_Address3)); _; }
155 
156     uint startTime = 0;
157     uint bountyPart = 2; // 2% of TotalSupply for BountyFund
158     uint advisorsPart = 35; //3,5% of TotalSupply for AdvisorsFund
159     uint itdPart = 15; //15% of TotalSupply for ItdFund
160     uint storagePart = 3; //3% of TotalSupply for StorageFund
161     uint icoAndPOfPart = 765; // 76,5% of TotalSupply for PublicICO and PrivateOffer
162     enum StatusICO { Created, Started, Paused, Finished }
163     StatusICO statusICO = StatusICO.Created;
164 
165 
166     function CryptoTicketsICO(address _presale, address _Company, address _BountyFund, address _AdvisorsFund, address _ItdFund, address _StorageFund, address _Manager, address _Controller_Address1, address _Controller_Address2, address _Controller_Address3){
167        presale = Presale(_presale);
168        Company = _Company;
169        BountyFund = _BountyFund;
170        AdvisorsFund = _AdvisorsFund;
171        ItdFund = _ItdFund;
172        StorageFund = _StorageFund;
173        Manager = _Manager;
174        Controller_Address1 = _Controller_Address1;
175        Controller_Address2 = _Controller_Address2;
176        Controller_Address3 = _Controller_Address3;
177     }
178 
179 // function for changing rate of ETH and price of token
180 
181 
182     function setRate(uint _RateEth) external managerOnly {
183        Rate_Eth = _RateEth;
184        Token_Price = 25*Rate_Eth;
185     }
186 
187 
188 //ICO status functions
189 
190     function startIco() external managerOnly {
191        require(statusICO == StatusICO.Created || statusICO == StatusICO.Paused);
192        if(statusICO == StatusICO.Created)
193        {
194          startTime = now;
195        }
196        LogStartICO();
197        statusICO = StatusICO.Started;
198     }
199 
200     function pauseIco() external managerOnly {
201        require(statusICO == StatusICO.Started);
202        statusICO = StatusICO.Paused;
203        LogPauseICO();
204     }
205 
206 
207     function finishIco() external managerOnly { // Funds for minting of tokens
208 
209        require(statusICO == StatusICO.Started);
210 
211        uint alreadyMinted = tkt.totalSupply(); //=PublicICO+PrivateOffer
212        uint totalAmount = alreadyMinted * 1000 / icoAndPOfPart;
213 
214 
215        tkt.mint(BountyFund, bountyPart * totalAmount / 100); // 2% for Bounty
216        tkt.mint(AdvisorsFund, advisorsPart * totalAmount / 1000); // 3.5% for Advisors
217        tkt.mint(ItdFund, itdPart * totalAmount / 100); // 15% for Ticketscloud ltd
218        tkt.mint(StorageFund, storagePart * totalAmount / 100); // 3% for Storage
219 
220        tkt.defrost();
221 
222        statusICO = StatusICO.Finished;
223        LogFinishICO(BountyFund, AdvisorsFund, ItdFund, StorageFund);
224     }
225 
226 // function that buys tokens when investor sends ETH to address of ICO
227     function() external payable {
228 
229        buy(msg.sender, msg.value * Token_Price);
230     }
231 
232 // function for buying tokens to investors who paid in other cryptos
233 
234     function buyForInvestor(address _investor, uint _tktValue, string _txHash) external controllersOnly {
235        buy(_investor, _tktValue);
236        LogBuyForInvestor(_investor, _tktValue, _txHash);
237     }
238 
239 //function for buying tokens for presale investors
240 
241     function replaceToken(address _investor) managerOnly{
242          require(statusICO != StatusICO.Finished);
243          uint pctTokens = presale.balanceOf(_investor);
244          require(pctTokens > 0);
245          presale.burnTokens(_investor);
246          tkt.mint(_investor, pctTokens);
247 
248          LogReplaceToken(_investor, pctTokens);
249     }
250 // internal function for buying tokens
251 
252     function buy(address _investor, uint _tktValue) internal {
253        require(statusICO == StatusICO.Started);
254        require(_tktValue > 0);
255 
256 
257        uint bonus = getBonus(_tktValue);
258 
259        uint _total = _tktValue.add(bonus);
260 
261        require(SoldNoBonuses + _tktValue <= Tokens_For_Sale);
262        tkt.mint(_investor, _total);
263 
264        SoldNoBonuses = SoldNoBonuses.add(_tktValue);
265     }
266 
267 // function that calculates bonus
268     function getBonus(uint _value) public constant returns (uint) {
269        uint bonus = 0;
270        uint time = now;
271        if(time >= startTime && time <= startTime + 48 hours)
272        {
273 
274             bonus = _value * 20/100;
275         }
276 
277        if(time > startTime + 48 hours && time <= startTime + 96 hours)
278        {
279             bonus = _value * 10/100;
280        }
281 
282        if(time > startTime + 96 hours && time <= startTime + 168 hours)
283        {
284 
285             bonus = _value * 5/100;
286         }
287 
288        return bonus;
289     }
290 
291 //function to withdraw ETH from smart contract
292 
293     // SUGGESTION:
294     // even if you lose you manager keys -> you still will be able to get ETH
295     function withdrawEther(uint256 _value) external managerOnly {
296        require(statusICO == StatusICO.Finished);
297        Company.transfer(_value);
298     }
299 
300 }
301 
302 contract TKT  is ERC20 {
303     using SafeMath for uint;
304 
305     string public name = "CryptoTickets COIN";
306     string public symbol = "TKT";
307     uint public decimals = 18;
308 
309     address public ico;
310 
311     event Burn(address indexed from, uint256 value);
312 
313     bool public tokensAreFrozen = true;
314 
315     modifier icoOnly { require(msg.sender == ico); _; }
316 
317     function TKT(address _ico) {
318        ico = _ico;
319     }
320 
321 
322     function mint(address _holder, uint _value) external icoOnly {
323        require(_value != 0);
324        balances[_holder] = balances[_holder].add(_value);
325        totalSupply = totalSupply.add(_value);
326        Transfer(0x0, _holder, _value);
327     }
328 
329 
330     function defrost() external icoOnly {
331        tokensAreFrozen = false;
332     }
333 
334     function burn(uint256 _value) {
335        require(!tokensAreFrozen);
336        balances[msg.sender] = balances[msg.sender].sub(_value);
337        totalSupply = totalSupply.sub(_value);
338        Burn(msg.sender, _value);
339     }
340 
341 
342     function balanceOf(address _owner) constant returns (uint256) {
343          return balances[_owner];
344     }
345 
346 
347     function transfer(address _to, uint256 _amount) returns (bool) {
348         require(!tokensAreFrozen);
349         balances[msg.sender] = balances[msg.sender].sub(_amount);
350         balances[_to] = balances[_to].add(_amount);
351         Transfer(msg.sender, _to, _amount);
352         return true;
353     }
354 
355 
356     function transferFrom(address _from, address _to, uint256 _amount) returns (bool) {
357         require(!tokensAreFrozen);
358         balances[_from] = balances[_from].sub(_amount);
359         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
360         balances[_to] = balances[_to].add(_amount);
361         Transfer(_from, _to, _amount);
362         return true;
363      }
364 
365 
366     function approve(address _spender, uint256 _amount) returns (bool) {
367         // To change the approve amount you first have to reduce the addresses`
368         //  allowance to zero by calling `approve(_spender, 0)` if it is not
369         //  already 0 to mitigate the race condition described here:
370         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
371         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
372 
373         allowed[msg.sender][_spender] = _amount;
374         Approval(msg.sender, _spender, _amount);
375         return true;
376     }
377 
378 
379     function allowance(address _owner, address _spender) constant returns (uint256) {
380         return allowed[_owner][_spender];
381     }
382 }