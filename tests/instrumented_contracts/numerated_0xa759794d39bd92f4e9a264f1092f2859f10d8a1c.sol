1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4     function mul(uint a, uint b) internal returns (uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9     function div(uint a, uint b) internal returns (uint) {
10         assert(b > 0);
11         uint c = a / b;
12         assert(a == b * c + a % b);
13         return c;
14     }
15     function sub(uint a, uint b) internal returns (uint) {
16         assert(b <= a);
17         return a - b;
18      }
19     function add(uint a, uint b) internal returns (uint) {
20          uint c = a + b;
21          assert(c >= a);
22          return c;
23      }
24     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
25         return a >= b ? a : b;
26      }
27 
28     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
29         return a < b ? a : b;
30     }
31 
32     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
33         return a >= b ? a : b;
34     }
35 
36     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
37         return a < b ? a : b;
38     }
39 }
40 
41 contract ERC20 {
42     uint public totalSupply = 0;
43 
44     mapping(address => uint256) balances;
45     mapping(address => mapping (address => uint256)) allowed;
46 
47     function balanceOf(address _owner) constant returns (uint);
48     function transfer(address _to, uint _value) returns (bool);
49     function transferFrom(address _from, address _to, uint _value) returns (bool);
50     function approve(address _spender, uint _value) returns (bool);
51     function allowance(address _owner, address _spender) constant returns (uint);
52 
53     event Transfer(address indexed _from, address indexed _to, uint _value);
54     event Approval(address indexed _owner, address indexed _spender, uint _value);
55 
56 } // Functions of ERC20 standard
57 
58 contract TKT  is ERC20 {
59     using SafeMath for uint;
60 
61     string public name = "CryptoTickets COIN";
62     string public symbol = "TKT";
63     uint public decimals = 18;
64 
65     address public ico;
66 
67     event Burn(address indexed from, uint256 value);
68 
69     bool public tokensAreFrozen = true;
70 
71     modifier icoOnly { require(msg.sender == ico); _; }
72 
73     function TKT(address _ico) {
74        ico = _ico;
75     }
76 
77 
78     function mint(address _holder, uint _value) external icoOnly {
79        require(_value != 0);
80        balances[_holder] = balances[_holder].add(_value);
81        totalSupply = totalSupply.add(_value);
82        Transfer(0x0, _holder, _value);
83     }
84 
85 
86     function defrost() external icoOnly {
87        tokensAreFrozen = false;
88     }
89 
90     function burn(uint256 _value) {
91        require(!tokensAreFrozen);
92        balances[msg.sender] = balances[msg.sender].sub(_value);
93        totalSupply = totalSupply.sub(_value);
94        Burn(msg.sender, _value);
95     }
96 
97 
98     function balanceOf(address _owner) constant returns (uint256) {
99          return balances[_owner];
100     }
101 
102 
103     function transfer(address _to, uint256 _amount) returns (bool) {
104         require(!tokensAreFrozen);
105         balances[msg.sender] = balances[msg.sender].sub(_amount);
106         balances[_to] = balances[_to].add(_amount);
107         Transfer(msg.sender, _to, _amount);
108         return true;
109     }
110 
111 
112     function transferFrom(address _from, address _to, uint256 _amount) returns (bool) {
113         require(!tokensAreFrozen);
114         balances[_from] = balances[_from].sub(_amount);
115         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
116         balances[_to] = balances[_to].add(_amount);
117         Transfer(_from, _to, _amount);
118         return true;
119      }
120 
121 
122     function approve(address _spender, uint256 _amount) returns (bool) {
123         // To change the approve amount you first have to reduce the addresses`
124         //  allowance to zero by calling `approve(_spender, 0)` if it is not
125         //  already 0 to mitigate the race condition described here:
126         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
128 
129         allowed[msg.sender][_spender] = _amount;
130         Approval(msg.sender, _spender, _amount);
131         return true;
132     }
133 
134 
135     function allowance(address _owner, address _spender) constant returns (uint256) {
136         return allowed[_owner][_spender];
137     }
138 }
139 
140 contract CryptoTicketsICO {
141     using SafeMath for uint;
142 
143     uint public constant Tokens_For_Sale = 525000000*1e18; // Tokens for Sale without bonuses(HardCap)
144 
145     // Style: Caps should not be used for vars, only for consts!
146     uint public Rate_Eth = 298; // Rate USD per ETH
147     uint public Token_Price = 25 * Rate_Eth; // tkt per ETH
148     uint public SoldNoBonuses = 0; //Sold tokens without bonuses
149 
150     mapping(address => bool) swapped;
151 
152     event LogStartICO();
153     event LogPauseICO();
154     event LogFinishICO(address bountyFund, address advisorsFund, address itdFund, address storageFund);
155     event LogBuyForInvestor(address investor, uint tokenValue, string txHash);
156     event LogSwapToken(address investor, uint tokenValue);
157 
158     TKT public token = new TKT(this);
159     TKT public tkt;
160 
161     address public Company;
162     address public BountyFund;
163     address public AdvisorsFund;
164     address public ItdFund;
165     address public StorageFund;
166 
167     address public Manager; // Manager controls contract
168     address public SwapManager;
169     address public Controller_Address1; // First address that is used to buy tokens for other cryptos
170     address public Controller_Address2; // Second address that is used to buy tokens for other cryptos
171     address public Controller_Address3; // Third address that is used to buy tokens for other cryptos
172     modifier managerOnly { require(msg.sender == Manager); _; }
173     modifier controllersOnly { require((msg.sender == Controller_Address1) || (msg.sender == Controller_Address2) || (msg.sender == Controller_Address3)); _; }
174     modifier swapManagerOnly { require(msg.sender == SwapManager); _; }
175 
176     uint bountyPart = 2; // 2% of TotalSupply for BountyFund
177     uint advisorsPart = 35; //3,5% of TotalSupply for AdvisorsFund
178     uint itdPart = 15; //15% of TotalSupply for ItdFund
179     uint storagePart = 3; //3% of TotalSupply for StorageFund
180     uint icoAndPOfPart = 765; // 76,5% of TotalSupply for PublicICO and PrivateOffer
181     enum StatusICO { Created, Started, Paused, Finished }
182     StatusICO statusICO = StatusICO.Created;
183 
184 
185     function CryptoTicketsICO(address _tkt, address _Company, address _BountyFund, address _AdvisorsFund, address _ItdFund, address _StorageFund, address _Manager, address _Controller_Address1, address _Controller_Address2, address _Controller_Address3, address _SwapManager){
186        tkt = TKT(_tkt);
187        Company = _Company;
188        BountyFund = _BountyFund;
189        AdvisorsFund = _AdvisorsFund;
190        ItdFund = _ItdFund;
191        StorageFund = _StorageFund;
192        Manager = _Manager;
193        Controller_Address1 = _Controller_Address1;
194        Controller_Address2 = _Controller_Address2;
195        Controller_Address3 = _Controller_Address3;
196        SwapManager = _SwapManager;
197     }
198 
199 // function for changing rate of ETH and price of token
200 
201 
202     function setRate(uint _RateEth) external managerOnly {
203        Rate_Eth = _RateEth;
204        Token_Price = 25*Rate_Eth;
205     }
206 
207 
208 //ICO status functions
209 
210     function startIco() external managerOnly {
211        require(statusICO == StatusICO.Created || statusICO == StatusICO.Paused);
212        LogStartICO();
213        statusICO = StatusICO.Started;
214     }
215 
216     function pauseIco() external managerOnly {
217        require(statusICO == StatusICO.Started);
218        statusICO = StatusICO.Paused;
219        LogPauseICO();
220     }
221 
222 
223     function finishIco() external managerOnly { // Funds for minting of tokens
224 
225        require(statusICO == StatusICO.Started);
226 
227        uint alreadyMinted = token.totalSupply(); //=PublicICO+PrivateOffer
228        uint totalAmount = alreadyMinted * 1000 / icoAndPOfPart;
229 
230 
231        token.mint(BountyFund, bountyPart * totalAmount / 100); // 2% for Bounty
232        token.mint(AdvisorsFund, advisorsPart * totalAmount / 1000); // 3.5% for Advisors
233        token.mint(ItdFund, itdPart * totalAmount / 100); // 15% for Ticketscloud ltd
234        token.mint(StorageFund, storagePart * totalAmount / 100); // 3% for Storage
235 
236        token.defrost();
237 
238        statusICO = StatusICO.Finished;
239        LogFinishICO(BountyFund, AdvisorsFund, ItdFund, StorageFund);
240     }
241 
242 // function that buys tokens when investor sends ETH to address of ICO
243     function() external payable {
244 
245        buy(msg.sender, msg.value * Token_Price);
246     }
247 
248 // function for buying tokens to investors who paid in other cryptos
249 
250     function buyForInvestor(address _investor, uint _tokenValue, string _txHash) external controllersOnly {
251        buy(_investor, _tokenValue);
252        LogBuyForInvestor(_investor, _tokenValue, _txHash);
253     }
254 
255 //function for buying tokens for investors
256 
257     function swapToken(address _investor) swapManagerOnly{
258          require(statusICO != StatusICO.Finished);
259          require(swapped[_investor] == false);
260          uint tktTokens = tkt.balanceOf(_investor);
261          require(tktTokens > 0);
262          swapped[_investor] = true;
263          token.mint(_investor, tktTokens);
264 
265          LogSwapToken(_investor, tktTokens);
266     }
267 // internal function for buying tokens
268 
269     function buy(address _investor, uint _tokenValue) internal {
270        require(statusICO == StatusICO.Started);
271        require(_tokenValue > 0);
272        require(SoldNoBonuses + _tokenValue <= Tokens_For_Sale);
273        token.mint(_investor, _tokenValue);
274 
275        SoldNoBonuses = SoldNoBonuses.add(_tokenValue);
276     }
277 
278 
279 
280 
281 //function to withdraw ETH from smart contract
282 
283     function withdrawEther(uint256 _value) external managerOnly {
284        require(statusICO == StatusICO.Finished);
285        Company.transfer(_value);
286     }
287 
288 }