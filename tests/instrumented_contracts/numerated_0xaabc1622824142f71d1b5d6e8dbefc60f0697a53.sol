1 pragma solidity 0.4.20;
2 
3 /*
4 Lucky Strike smart contracts version: 1.0
5 */
6 
7 /*
8 Legal Disclaimer
9 This smart contract is intended for entertainment purposes only. Crypto currency gambling is illegal in many jurisdictions and users should consult legal counsel regarding the legal status of cryptocurrency gambling in their jurisdictions.
10 Since developers of this smart contract are unable to determine which jurisdiction you reside in, you must check current laws including your local and state laws to find out if cryptocurrency gambling is legal in your area.
11 If you reside in a location where gambling or crypto currency transactions over the internet or otherwise is illegal, please do not use this smart contract. You must be 21 years of age to use this smart contract even if it is legal to do so in your location.
12 Users in the U.S. should be aware that the U.S. government has taken the position that it is illegal for online casinos and sportsbooks to accept wagers from persons in the U.S.
13 If you reside in the U.S. or intend to promote this smart contract to U.S. residents please do not interact with this smart contract in any way and leave this smart contract  immediately.
14 */
15 
16 library SafeMath {
17 
18     /**
19     * @dev Multiplies two numbers, throws on overflow.
20     */
21     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
22         if (a == 0) {
23             return 0;
24         }
25         c = a * b;
26         assert(c / a == b);
27         return c;
28     }
29 
30     /**
31     * @dev Integer division of two numbers, truncating the quotient.
32     */
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         // assert(b > 0); // Solidity automatically throws when dividing by 0
35         // uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37         return a / b;
38     }
39 
40     /**
41     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42     */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         assert(b <= a);
45         return a - b;
46     }
47 
48     /**
49     * @dev Adds two numbers, throws on overflow.
50     */
51     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
52         c = a + b;
53         assert(c >= a);
54         return c;
55     }
56 }
57 
58 /* "Interfaces" */
59 
60 //  this is expected from another contracts
61 //  if it wants to spend tokens of behalf of the token owner in our contract
62 //  this can be used in many situations, for example to convert pre-ICO tokens to ICO tokens
63 //  see 'approveAndCall' function
64 contract allowanceRecipient {
65     function receiveApproval(address _from, uint256 _value, address _inContract, bytes _extraData) public returns (bool);
66 }
67 
68 // see:
69 // https://github.com/ethereum/EIPs/issues/677
70 contract tokenRecipient {
71     function tokenFallback(address _from, uint256 _value, bytes _extraData) public returns (bool);
72 }
73 
74 contract LuckyStrikeTokens {
75 
76     // see: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
77     using SafeMath for uint256;
78 
79     /* --- ERC-20 variables */
80 
81     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#name
82     // function name() constant returns (string name)
83     string public name = "LuckyStrikeTokens";
84 
85     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#symbol
86     // function symbol() constant returns (string symbol)
87     string public symbol = "LST";
88 
89     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#decimals
90     // function decimals() constant returns (uint8 decimals)
91     uint8 public decimals = 0;
92 
93     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#totalsupply
94     // function totalSupply() constant returns (uint256 totalSupply)
95     uint256 public totalSupply;
96 
97     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#balanceof
98     // function balanceOf(address _owner) constant returns (uint256 balance)
99     mapping(address => uint256) public balanceOf;
100 
101     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#allowance
102     // function allowance(address _owner, address _spender) constant returns (uint256 remaining)
103     mapping(address => mapping(address => uint256)) public allowance;
104 
105     /* --- ERC-20 events */
106 
107     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#events
108 
109     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer-1
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 
112     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approval
113     event Approval(address indexed _owner, address indexed spender, uint256 value);
114 
115     /* --- Interaction with other contracts events  */
116     event DataSentToAnotherContract(address indexed _from, address indexed _toContract, bytes _extraData);
117 
118     address public owner; // main smart contract (with the game)
119     address public team; // team address, to collect tokens minted for the team
120 
121     uint256 public invested; // here we count received investments in wei
122     uint256 public hardCap; // in ETH
123 
124     uint256 public tokenSaleStarted; // unix time
125     uint256 public salePeriod; // in seconds
126     bool public tokenSaleIsRunning = true;
127 
128     /* ---------- Constructor */
129     // do not forget about:
130     // https://medium.com/@codetractio/a-look-into-paritys-multisig-wallet-bug-affecting-100-million-in-ether-and-tokens-356f5ba6e90a
131     address admin; //
132     function LuckyStrikeTokens() public {
133         admin = msg.sender;
134     }
135 
136     function init(address luckyStrikeContractAddress) public {
137 
138         require(msg.sender == admin);
139         require(tokenSaleStarted == 0);
140 
141         // TODO: set in production <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
142         // in production:
143         hardCap = 30000 ether;
144         // 30K ETH
145         salePeriod = 180 days;
146         // 6 month
147 
148         // test:
149         // hardCap = 1 ether;
150         // salePeriod = 60 minutes;
151         // salePeriod = 10 minutes;
152 
153         team = 0xF732628F2757A880A5D73B19fB98bc61c1950d81;
154 
155         owner = luckyStrikeContractAddress;
156         tokenSaleStarted = block.timestamp;
157     }
158 
159     /* --- Dividends */
160     event DividendsPaid(address indexed to, uint256 tokensBurned, uint256 sumInWeiPaid);
161 
162     // valueInTokens : tokens to burn to get dividends
163     function takeDividends(uint256 valueInTokens) public returns (bool) {
164 
165         require(!tokenSaleIsRunning);
166         require(this.balance > 0);
167 
168         uint256 sumToPay = (this.balance / totalSupply).mul(valueInTokens);
169 
170         msg.sender.transfer(sumToPay);
171 
172         totalSupply = totalSupply.sub(valueInTokens);
173         balanceOf[msg.sender] = balanceOf[msg.sender].sub(valueInTokens);
174 
175         DividendsPaid(msg.sender, valueInTokens, sumToPay);
176 
177         return true;
178     }
179 
180     // only if all tokens are burned
181     event WithdrawalByOwner(uint256 value, address indexed to, address indexed triggeredBy);
182 
183     function withdrawAllByOwner() public {
184         require(msg.sender == team);
185         require(totalSupply == 0 && !tokenSaleIsRunning);
186         uint256 sumToWithdraw = this.balance;
187         team.transfer(sumToWithdraw);
188         WithdrawalByOwner(sumToWithdraw, team, msg.sender);
189     }
190 
191     /* --- ERC-20 Functions */
192     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#methods
193 
194     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer
195     function transfer(address _to, uint256 _value) public returns (bool){
196         if (_to == address(this)) {
197             return takeDividends(_value);
198         } else {
199             return transferFrom(msg.sender, _to, _value);
200         }
201     }
202 
203     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transferfrom
204     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
205 
206         require(!tokenSaleIsRunning);
207 
208         // Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event (ERC-20)
209         require(_value >= 0);
210 
211         // The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism
212         require(msg.sender == _from || _value <= allowance[_from][msg.sender]);
213 
214         // check if _from account have required amount
215         require(_value <= balanceOf[_from]);
216 
217         // Subtract from the sender
218         // balanceOf[_from] = balanceOf[_from] - _value;
219         balanceOf[_from] = balanceOf[_from].sub(_value);
220         //
221         // Add the same to the recipient
222         // balanceOf[_to] = balanceOf[_to] + _value;
223         balanceOf[_to] = balanceOf[_to].add(_value);
224 
225         // If allowance used, change allowances correspondingly
226         if (_from != msg.sender) {
227             // allowance[_from][msg.sender] = allowance[_from][msg.sender] - _value;
228             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
229         }
230 
231         // event
232         Transfer(_from, _to, _value);
233 
234         return true;
235     } // end of transferFrom
236 
237     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approve
238     // there is and attack, see:
239     // https://github.com/CORIONplatform/solidity/issues/6,
240     // https://drive.google.com/file/d/0ByMtMw2hul0EN3NCaVFHSFdxRzA/view
241     // but this function is required by ERC-20
242     function approve(address _spender, uint256 _value) public returns (bool){
243         require(_value >= 0);
244         allowance[msg.sender][_spender] = _value;
245         // event
246         Approval(msg.sender, _spender, _value);
247         return true;
248     }
249 
250     /*  ---------- Interaction with other contracts  */
251 
252     /* User can allow another smart contract to spend some shares in his behalf
253     *  (this function should be called by user itself)
254     *  @param _spender another contract's address
255     *  @param _value number of tokens
256     *  @param _extraData Data that can be sent from user to another contract to be processed
257     *  bytes - dynamically-sized byte array,
258     *  see http://solidity.readthedocs.io/en/v0.4.15/types.html#dynamically-sized-byte-array
259     *  see possible attack information in comments to function 'approve'
260     *  > this may be used to convert pre-ICO tokens to ICO tokens
261     */
262     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool) {
263 
264         approve(_spender, _value);
265 
266         // 'spender' is another contract that implements code as prescribed in 'allowanceRecipient' above
267         allowanceRecipient spender = allowanceRecipient(_spender);
268 
269         // our contract calls 'receiveApproval' function of another contract ('allowanceRecipient') to send information about
270         // allowance and data sent by user
271         // 'this' is this (our) contract address
272         if (spender.receiveApproval(msg.sender, _value, this, _extraData)) {
273             DataSentToAnotherContract(msg.sender, _spender, _extraData);
274             return true;
275         }
276         return false;
277     } // end of approveAndCall
278 
279     // for convenience:
280     function approveAllAndCall(address _spender, bytes _extraData) public returns (bool success) {
281         return approveAndCall(_spender, balanceOf[msg.sender], _extraData);
282     }
283 
284     /* https://github.com/ethereum/EIPs/issues/677
285     * transfer tokens with additional info to another smart contract, and calls its correspondent function
286     * @param address _to - another smart contract address
287     * @param uint256 _value - number of tokens
288     * @param bytes _extraData - data to send to another contract
289     * > this may be used to convert pre-ICO tokens to ICO tokens
290     */
291     function transferAndCall(address _to, uint256 _value, bytes _extraData) public returns (bool success){
292 
293         transferFrom(msg.sender, _to, _value);
294 
295         tokenRecipient receiver = tokenRecipient(_to);
296 
297         if (receiver.tokenFallback(msg.sender, _value, _extraData)) {
298             DataSentToAnotherContract(msg.sender, _to, _extraData);
299             return true;
300         }
301         return false;
302     } // end of transferAndCall
303 
304     // for example for converting ALL tokens of user account to another tokens
305     function transferAllAndCall(address _to, bytes _extraData) public returns (bool success){
306         return transferAndCall(_to, balanceOf[msg.sender], _extraData);
307     }
308 
309     /* ========= MINT TOKENS: */
310 
311     event NewTokensMinted(
312         address indexed to, //..............1
313         uint256 invested, //................2
314         uint256 tokensForInvestor, //.......3
315         address indexed by, //..............4
316         uint256 tokensForTeam, //...........5
317         bool indexed tokenSaleFinished, //..6
318         uint256 totalInvested           //..7
319     );
320 
321     // value - number of tokens to mint
322     function mint(address to, uint256 value, uint256 _invested) public returns (bool) {
323 
324         require(tokenSaleIsRunning);
325 
326         require(msg.sender == owner);
327 
328         // tokens for investor
329         balanceOf[to] = balanceOf[to].add(value);
330         totalSupply = totalSupply.add(value);
331 
332         // tokens for team
333         uint256 tokensForTeam = value / 4;
334         // 5 - constant
335         if (tokensForTeam == 0) {
336             tokensForTeam = 1;
337         }
338         balanceOf[team] = balanceOf[team].add(tokensForTeam);
339         totalSupply = totalSupply.add(tokensForTeam);
340 
341         invested = invested.add(_invested);
342 
343         if (invested >= hardCap || now.sub(tokenSaleStarted) > salePeriod) {
344             tokenSaleIsRunning = false;
345         }
346 
347         NewTokensMinted(
348             to, //...................1
349             _invested, //............2
350             value, //................3
351             msg.sender, //...........4
352             tokensForTeam, //........5
353             !tokenSaleIsRunning, //..6
354             invested //..............7
355         );
356         return true;
357     }
358 
359     function() public payable {
360         // require(msg.sender == owner); // no check means we can use standard transfer in main contract
361     }
362 
363 }