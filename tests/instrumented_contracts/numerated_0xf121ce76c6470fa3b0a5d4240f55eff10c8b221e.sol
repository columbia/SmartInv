1 pragma solidity ^0.4.15;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner) throw;
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 
21 contract tokenSPERT {
22     /* Public variables of the token */
23     string public name;
24     string public symbol;
25     uint8 public decimals;
26     uint256 public totalSupply = 0;
27 
28 
29     function tokenSPERT (string _name, string _symbol, uint8 _decimals){
30         name = _name;
31         symbol = _symbol;
32         decimals = _decimals;
33         
34     }
35     /* This creates an array with all balances */
36     mapping (address => uint256) public balanceOf;
37 
38 
39     /* This unnamed function is called whenever someone tries to send ether to it */
40     function () {
41         throw;     // Prevents accidental sending of ether
42     }
43 }
44 
45 contract Presale is owned, tokenSPERT {
46 
47         string name = 'Pre-sale Eristica Token';
48         string symbol = 'SPERT';
49         uint8 decimals = 18;
50         
51         
52 function Presale ()
53         tokenSPERT (name, symbol, decimals){}
54     
55     event Transfer(address _from, address _to, uint256 amount); 
56     event Burned(address _from, uint256 amount);
57         
58     function mintToken(address investor, uint256 mintedAmount) public onlyOwner {
59         balanceOf[investor] += mintedAmount;
60         totalSupply += mintedAmount;
61         Transfer(this, investor, mintedAmount);
62         
63     }
64 
65  function burnTokens(address _owner) public
66         onlyOwner
67     {   
68         uint  tokens = balanceOf[_owner];
69         if(balanceOf[_owner] == 0) throw;
70         balanceOf[_owner] = 0;
71         totalSupply -= tokens;
72         Burned(_owner, tokens);
73     }
74 }
75 
76 library SafeMath {
77     function div(uint a, uint b) internal returns (uint) {
78         assert(b > 0);
79         uint c = a / b;
80         assert(a == b * c + a % b);
81         return c;
82     }
83     function sub(uint a, uint b) internal returns (uint) {
84         assert(b <= a);
85         return a - b;
86      }
87     function add(uint a, uint b) internal returns (uint) {
88          uint c = a + b;
89          assert(c >= a);
90          return c;
91      }
92 }
93 
94 
95 contract ERC20 {
96     uint public totalSupply = 0;
97 
98     mapping(address => uint256) balances;
99     mapping(address => mapping (address => uint256)) allowed;
100 
101     function balanceOf(address _owner) constant returns (uint);
102     function transfer(address _to, uint _value) returns (bool);
103     function transferFrom(address _from, address _to, uint _value) returns (bool);
104     function approve(address _spender, uint _value) returns (bool);
105     function allowance(address _owner, address _spender) constant returns (uint);
106 
107     event Transfer(address indexed _from, address indexed _to, uint _value);
108     event Approval(address indexed _owner, address indexed _spender, uint _value);
109 
110 } // Functions of ERC20 standard
111 
112 
113 
114 contract EristicaICO {
115     using SafeMath for uint;
116 
117     uint public constant Tokens_For_Sale = 482500000*1e18; // Tokens for Sale (HardCap)
118 
119     uint public Rate_Eth = 458; // Rate USD per ETH
120     uint public Token_Price = 50 * Rate_Eth; // ERT per ETH
121     uint public Sold = 0; //Sold tokens
122 
123 
124     event LogStartICO();
125     event LogPauseICO();
126     event LogFinishICO(address bountyFund, address advisorsFund, address teamFund, address challengeFund);
127     event LogBuyForInvestor(address investor, uint ertValue, string txHash);
128     event LogReplaceToken(address investor, uint ertValue);
129 
130     ERT public ert = new ERT(this);
131     Presale public presale;
132 
133     address public Company;
134     address public BountyFund;
135     address public AdvisorsFund;
136     address public TeamFund;
137     address public ChallengeFund;
138 
139     address public Manager; // Manager controls contract
140     address public Controller_Address1; // First address that is used to buy tokens for other cryptos
141     address public Controller_Address2; // Second address that is used to buy tokens for other cryptos
142     address public Controller_Address3; // Third address that is used to buy tokens for other cryptos
143     modifier managerOnly { require(msg.sender == Manager); _; }
144     modifier controllersOnly { require((msg.sender == Controller_Address1) || (msg.sender == Controller_Address2) || (msg.sender == Controller_Address3)); _; }
145 
146     uint bountyPart = 150; // 1.5% of TotalSupply for BountyFund
147     uint advisorsPart = 389; //3,89% of TotalSupply for AdvisorsFund
148     uint teamPart = 1000; //10% of TotalSupply for TeamFund
149     uint challengePart = 1000; //10% of TotalSupply for ChallengeFund
150     uint icoAndPOfPart = 7461; // 74,61% of TotalSupply for PublicICO and PrivateOffer
151     enum StatusICO { Created, Started, Paused, Finished }
152     StatusICO statusICO = StatusICO.Created;
153 
154 
155     function EristicaICO(address _presale, address _Company, address _BountyFund, address _AdvisorsFund, address _TeamFund, address _ChallengeFund, address _Manager, address _Controller_Address1, address _Controller_Address2, address _Controller_Address3){
156        presale = Presale(_presale);
157        Company = _Company;
158        BountyFund = _BountyFund;
159        AdvisorsFund = _AdvisorsFund;
160        TeamFund = _TeamFund;
161        ChallengeFund = _ChallengeFund;
162        Manager = _Manager;
163        Controller_Address1 = _Controller_Address1;
164        Controller_Address2 = _Controller_Address2;
165        Controller_Address3 = _Controller_Address3;
166     }
167 
168 // function for changing rate of ETH and price of token
169 
170 
171     function setRate(uint _RateEth) external managerOnly {
172        Rate_Eth = _RateEth;
173        Token_Price = 50*Rate_Eth;
174     }
175 
176 
177 //ICO status functions
178 
179     function startIco() external managerOnly {
180        require(statusICO == StatusICO.Created || statusICO == StatusICO.Paused);
181        LogStartICO();
182        statusICO = StatusICO.Started;
183     }
184 
185     function pauseIco() external managerOnly {
186        require(statusICO == StatusICO.Started);
187        statusICO = StatusICO.Paused;
188        LogPauseICO();
189     }
190 
191 
192     function finishIco() external managerOnly { // Funds for minting of tokens
193 
194        require(statusICO == StatusICO.Started);
195 
196        uint alreadyMinted = ert.totalSupply(); //=PublicICO+PrivateOffer
197        uint totalAmount = alreadyMinted * 10000 / icoAndPOfPart;
198 
199 
200        ert.mint(BountyFund, bountyPart * totalAmount / 10000); // 1.5% for Bounty
201        ert.mint(AdvisorsFund, advisorsPart * totalAmount / 10000); // 3.89% for Advisors
202        ert.mint(TeamFund, teamPart * totalAmount / 10000); // 10% for Eristica team
203        ert.mint(ChallengeFund, challengePart * totalAmount / 10000); // 10% for Challenge Fund
204 
205        ert.defrost();
206 
207        statusICO = StatusICO.Finished;
208        LogFinishICO(BountyFund, AdvisorsFund, TeamFund, ChallengeFund);
209     }
210 
211 // function that buys tokens when investor sends ETH to address of ICO
212     function() external payable {
213 
214        buy(msg.sender, msg.value * Token_Price);
215     }
216 
217 // function for buying tokens to investors who paid in other cryptos
218 
219     function buyForInvestor(address _investor, uint _ertValue, string _txHash) external controllersOnly {
220        buy(_investor, _ertValue);
221        LogBuyForInvestor(_investor, _ertValue, _txHash);
222     }
223 
224 //function for buying tokens for presale investors
225 
226     function replaceToken(address _investor) managerOnly{
227          require(statusICO != StatusICO.Finished);
228          uint spertTokens = presale.balanceOf(_investor);
229          require(spertTokens > 0);
230          presale.burnTokens(_investor);
231          ert.mint(_investor, spertTokens);
232 
233          LogReplaceToken(_investor, spertTokens);
234     }
235 // internal function for buying tokens
236 
237     function buy(address _investor, uint _ertValue) internal {
238        require(statusICO == StatusICO.Started);
239        require(_ertValue > 0);
240        require(Sold + _ertValue <= Tokens_For_Sale);
241        ert.mint(_investor, _ertValue);
242        Sold = Sold.add(_ertValue);
243     }
244 
245 
246 
247 //function to withdraw ETH from smart contract
248 
249     function withdrawEther(uint256 _value) external managerOnly {
250        require(statusICO == StatusICO.Finished);
251        Company.transfer(_value);
252     }
253 
254 }
255 
256 contract ERT  is ERC20 {
257     using SafeMath for uint;
258 
259     string public name = "Eristica TOKEN";
260     string public symbol = "ERT";
261     uint public decimals = 18;
262 
263     address public ico;
264 
265     event Burn(address indexed from, uint256 value);
266 
267     bool public tokensAreFrozen = true;
268 
269     modifier icoOnly { require(msg.sender == ico); _; }
270 
271     function ERT(address _ico) {
272        ico = _ico;
273     }
274 
275 
276     function mint(address _holder, uint _value) external icoOnly {
277        require(_value != 0);
278        balances[_holder] = balances[_holder].add(_value);
279        totalSupply = totalSupply.add(_value);
280        Transfer(0x0, _holder, _value);
281     }
282 
283 
284     function defrost() external icoOnly {
285        tokensAreFrozen = false;
286     }
287 
288     function burn(uint256 _value) {
289        require(!tokensAreFrozen);
290        balances[msg.sender] = balances[msg.sender].sub(_value);
291        totalSupply = totalSupply.sub(_value);
292        Burn(msg.sender, _value);
293     }
294 
295 
296     function balanceOf(address _owner) constant returns (uint256) {
297          return balances[_owner];
298     }
299 
300 
301     function transfer(address _to, uint256 _amount) returns (bool) {
302         require(!tokensAreFrozen);
303         balances[msg.sender] = balances[msg.sender].sub(_amount);
304         balances[_to] = balances[_to].add(_amount);
305         Transfer(msg.sender, _to, _amount);
306         return true;
307     }
308 
309 
310     function transferFrom(address _from, address _to, uint256 _amount) returns (bool) {
311         require(!tokensAreFrozen);
312         balances[_from] = balances[_from].sub(_amount);
313         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
314         balances[_to] = balances[_to].add(_amount);
315         Transfer(_from, _to, _amount);
316         return true;
317      }
318 
319 
320     function approve(address _spender, uint256 _amount) returns (bool) {
321         // To change the approve amount you first have to reduce the addresses`
322         //  allowance to zero by calling `approve(_spender, 0)` if it is not
323         //  already 0 to mitigate the race condition described here:
324         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
325         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
326 
327         allowed[msg.sender][_spender] = _amount;
328         Approval(msg.sender, _spender, _amount);
329         return true;
330     }
331 
332 
333     function allowance(address _owner, address _spender) constant returns (uint256) {
334         return allowed[_owner][_spender];
335     }
336 }