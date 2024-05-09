1 pragma solidity 0.4.20;
2 
3 /*
4 Lucky Strike smart contracts version: 2.0
5 */
6 
7 /*
8 This smart contract is intended for entertainment purposes only. Cryptocurrency gambling is illegal in many jurisdictions and users should consult their legal counsel regarding the legal status of cryptocurrency gambling in their jurisdictions.
9 Since developers of this smart contract are unable to determine which jurisdiction you reside in, you must check current laws including your local and state laws to find out if cryptocurrency gambling is legal in your area.
10 If you reside in a location where cryptocurrency gambling is illegal, please do not interact with this smart contract in any way and leave it  immediately.
11 */
12 
13 library SafeMath {
14 
15     /**
16     * @dev Multiplies two numbers, throws on overflow.
17     */
18     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
19         if (a == 0) {
20             return 0;
21         }
22         c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers, truncating the quotient.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // assert(b > 0); // Solidity automatically throws when dividing by 0
32         // uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return a / b;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         assert(b <= a);
42         return a - b;
43     }
44 
45     /**
46     * @dev Adds two numbers, throws on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49         c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 
55 /* "Interfaces" */
56 
57 //  this is expected from another contracts
58 //  if it wants to spend tokens of behalf of the token owner in our contract
59 //  this can be used in many situations, for example to convert pre-ICO tokens to ICO tokens
60 //  see 'approveAndCall' function
61 contract allowanceRecipient {
62     function receiveApproval(address _from, uint256 _value, address _inContract, bytes _extraData) public returns (bool);
63 }
64 
65 // see:
66 // https://github.com/ethereum/EIPs/issues/677
67 contract tokenRecipient {
68     function tokenFallback(address _from, uint256 _value, bytes _extraData) public returns (bool);
69 }
70 
71 contract LuckyStrikeTokens {
72 
73     // see: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
74     using SafeMath for uint256;
75 
76     /* --- ERC-20 variables */
77 
78     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#name
79     // function name() constant returns (string name)
80     string public name = "LuckyStrikeTokens";
81 
82     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#symbol
83     // function symbol() constant returns (string symbol)
84     string public symbol = "LST";
85 
86     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#decimals
87     // function decimals() constant returns (uint8 decimals)
88     uint8 public decimals = 0;
89 
90     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#totalsupply
91     // function totalSupply() constant returns (uint256 totalSupply)
92     uint256 public totalSupply;
93 
94     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#balanceof
95     // function balanceOf(address _owner) constant returns (uint256 balance)
96     mapping(address => uint256) public balanceOf;
97 
98     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#allowance
99     // function allowance(address _owner, address _spender) constant returns (uint256 remaining)
100     mapping(address => mapping(address => uint256)) public allowance;
101 
102     /* --- ERC-20 events */
103 
104     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#events
105 
106     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer-1
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approval
110     event Approval(address indexed _owner, address indexed spender, uint256 value);
111 
112     /* --- Interaction with other contracts events  */
113     event DataSentToAnotherContract(address indexed _from, address indexed _toContract, bytes _extraData);
114 
115     address public owner; // main smart contract (with the game)
116     address public team; // team address, to collect tokens minted for the team
117 
118     uint256 public invested; // here we count received investments in wei
119     uint256 public hardCap; // in ETH
120 
121     uint256 public tokenSaleStarted; // unix time
122     uint256 public salePeriod; // in seconds
123     bool public tokenSaleIsRunning = true;
124 
125     /* ---------- Constructor */
126     // do not forget about:
127     // https://medium.com/@codetractio/a-look-into-paritys-multisig-wallet-bug-affecting-100-million-in-ether-and-tokens-356f5ba6e90a
128     address admin; //
129     function LuckyStrikeTokens() public {
130         admin = msg.sender;
131     }
132 
133     function init(address luckyStrikeContractAddress) public {
134 
135         require(msg.sender == admin);
136         require(tokenSaleStarted == 0);
137 
138         hardCap = 4500 ether;
139         salePeriod = 200 days;
140 
141         // test:
142         // hardCap = 1 ether;
143         // salePeriod = 10 minutes;
144 
145         team = 0x0bBAb60c495413c870F8cABF09436BeE9fe3542F;
146 
147         balanceOf[0x7E6CdeE9104f0d93fdACd550304bF36542A95bfD] = 33040000;
148         balanceOf[0x21F73Fc4557a396233C0786c7b4d0dDAc6237582] = 8260000;
149         balanceOf[0x0bBAb60c495413c870F8cABF09436BeE9fe3542F] = 26600000;
150         balanceOf[admin] = 2100000;
151 
152         totalSupply = 70000000;
153 
154         owner = luckyStrikeContractAddress;
155         tokenSaleStarted = block.timestamp;
156     }
157 
158     /* --- Dividends */
159     event DividendsPaid(address indexed to, uint256 tokensBurned, uint256 sumInWeiPaid);
160 
161     // valueInTokens : tokens to burn to get dividends
162     function takeDividends(uint256 valueInTokens) public returns (bool) {
163 
164         require(!tokenSaleIsRunning);
165         require(this.balance > 0);
166         require(totalSupply > 0);
167 
168         uint256 sumToPay = (this.balance / totalSupply).mul(valueInTokens);
169 
170         totalSupply = totalSupply.sub(valueInTokens);
171         balanceOf[msg.sender] = balanceOf[msg.sender].sub(valueInTokens);
172 
173         msg.sender.transfer(sumToPay);
174         //
175 
176         DividendsPaid(msg.sender, valueInTokens, sumToPay);
177 
178         return true;
179     }
180 
181     // only if all tokens are burned
182     event WithdrawalByOwner(uint256 value, address indexed to, address indexed triggeredBy);
183 
184     function withdrawAllByOwner() public {
185         require(msg.sender == team);
186         require(totalSupply == 0 && !tokenSaleIsRunning);
187         uint256 sumToWithdraw = this.balance;
188         team.transfer(sumToWithdraw);
189         WithdrawalByOwner(sumToWithdraw, team, msg.sender);
190     }
191 
192     /* --- ERC-20 Functions */
193     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#methods
194 
195     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer
196     function transfer(address _to, uint256 _value) public returns (bool){
197         if (_to == address(this)) {
198             return takeDividends(_value);
199         } else {
200             return transferFrom(msg.sender, _to, _value);
201         }
202     }
203 
204     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transferfrom
205     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
206 
207         require(!tokenSaleIsRunning);
208 
209         // Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event (ERC-20)
210         require(_value >= 0);
211 
212         // The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism
213         require(msg.sender == _from || _value <= allowance[_from][msg.sender]);
214 
215         // check if _from account have required amount
216         require(_value <= balanceOf[_from]);
217 
218         // Subtract from the sender
219         // balanceOf[_from] = balanceOf[_from] - _value;
220         balanceOf[_from] = balanceOf[_from].sub(_value);
221         //
222         // Add the same to the recipient
223         // balanceOf[_to] = balanceOf[_to] + _value;
224         balanceOf[_to] = balanceOf[_to].add(_value);
225 
226         // If allowance used, change allowances correspondingly
227         if (_from != msg.sender) {
228             // allowance[_from][msg.sender] = allowance[_from][msg.sender] - _value;
229             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
230         }
231 
232         // event
233         Transfer(_from, _to, _value);
234 
235         return true;
236     } // end of transferFrom
237 
238     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approve
239     // there is and attack, see:
240     // https://github.com/CORIONplatform/solidity/issues/6,
241     // https://drive.google.com/file/d/0ByMtMw2hul0EN3NCaVFHSFdxRzA/view
242     // but this function is required by ERC-20
243     function approve(address _spender, uint256 _value) public returns (bool){
244         require(_value >= 0);
245         allowance[msg.sender][_spender] = _value;
246         // event
247         Approval(msg.sender, _spender, _value);
248         return true;
249     }
250 
251     /*  ---------- Interaction with other contracts  */
252 
253     /* User can allow another smart contract to spend some shares in his behalf
254     *  (this function should be called by user itself)
255     *  @param _spender another contract's address
256     *  @param _value number of tokens
257     *  @param _extraData Data that can be sent from user to another contract to be processed
258     *  bytes - dynamically-sized byte array,
259     *  see http://solidity.readthedocs.io/en/v0.4.15/types.html#dynamically-sized-byte-array
260     *  see possible attack information in comments to function 'approve'
261     *  > this may be used to convert pre-ICO tokens to ICO tokens
262     */
263     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool) {
264 
265         approve(_spender, _value);
266 
267         // 'spender' is another contract that implements code as prescribed in 'allowanceRecipient' above
268         allowanceRecipient spender = allowanceRecipient(_spender);
269 
270         // our contract calls 'receiveApproval' function of another contract ('allowanceRecipient') to send information about
271         // allowance and data sent by user
272         // 'this' is this (our) contract address
273         if (spender.receiveApproval(msg.sender, _value, this, _extraData)) {
274             DataSentToAnotherContract(msg.sender, _spender, _extraData);
275             return true;
276         }
277         return false;
278     } // end of approveAndCall
279 
280     // for convenience:
281     function approveAllAndCall(address _spender, bytes _extraData) public returns (bool success) {
282         return approveAndCall(_spender, balanceOf[msg.sender], _extraData);
283     }
284 
285     /* https://github.com/ethereum/EIPs/issues/677
286     * transfer tokens with additional info to another smart contract, and calls its correspondent function
287     * @param address _to - another smart contract address
288     * @param uint256 _value - number of tokens
289     * @param bytes _extraData - data to send to another contract
290     * > this may be used to convert pre-ICO tokens to ICO tokens
291     */
292     function transferAndCall(address _to, uint256 _value, bytes _extraData) public returns (bool success){
293 
294         transferFrom(msg.sender, _to, _value);
295 
296         tokenRecipient receiver = tokenRecipient(_to);
297 
298         if (receiver.tokenFallback(msg.sender, _value, _extraData)) {
299             DataSentToAnotherContract(msg.sender, _to, _extraData);
300             return true;
301         }
302         return false;
303     } // end of transferAndCall
304 
305     // for example for converting ALL tokens of user account to another tokens
306     function transferAllAndCall(address _to, bytes _extraData) public returns (bool success){
307         return transferAndCall(_to, balanceOf[msg.sender], _extraData);
308     }
309 
310     /* ========= MINT TOKENS: */
311 
312     event NewTokensMinted(
313         address indexed to, //..............1
314         uint256 invested, //................2
315         uint256 tokensForInvestor, //.......3
316         address indexed by, //..............4
317         bool indexed tokenSaleFinished, //..5
318         uint256 totalInvested //............6
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
332         invested = invested.add(_invested);
333 
334         if (invested >= hardCap || now.sub(tokenSaleStarted) > salePeriod) {
335             tokenSaleIsRunning = false;
336         }
337 
338         NewTokensMinted(
339             to, //...................1
340             _invested, //............2
341             value, //................3
342             msg.sender, //...........4
343             !tokenSaleIsRunning, //..5
344             invested //..............6
345         );
346         return true;
347     }
348 
349     function() public payable {
350         // require(msg.sender == owner); // no check means we can use standard transfer in main contract
351     }
352 
353 }