1 pragma solidity 0.4.20;
2 
3 /*
4 Lucky Strike smart contracts version: 2.1
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
150         balanceOf[0x0d7e2582738de99FFFD9F10710bBF4EAbB3a1b98] = 2100000;
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
168         // uint256 sumToPay = (this.balance / totalSupply).mul(valueInTokens);
169         uint256 sumToPay = (this.balance).mul(valueInTokens) / totalSupply;
170 
171         totalSupply = totalSupply.sub(valueInTokens);
172         balanceOf[msg.sender] = balanceOf[msg.sender].sub(valueInTokens);
173 
174         msg.sender.transfer(sumToPay);
175         //
176 
177         DividendsPaid(msg.sender, valueInTokens, sumToPay);
178 
179         return true;
180     }
181 
182     // only if all tokens are burned
183     event WithdrawalByOwner(uint256 value, address indexed to, address indexed triggeredBy);
184 
185     function withdrawAllByOwner() public {
186         require(msg.sender == team);
187         require(totalSupply == 0 && !tokenSaleIsRunning);
188         uint256 sumToWithdraw = this.balance;
189         team.transfer(sumToWithdraw);
190         WithdrawalByOwner(sumToWithdraw, team, msg.sender);
191     }
192 
193     /* --- ERC-20 Functions */
194     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#methods
195 
196     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer
197     function transfer(address _to, uint256 _value) public returns (bool){
198         if (_to == address(this)) {
199             return takeDividends(_value);
200         } else {
201             return transferFrom(msg.sender, _to, _value);
202         }
203     }
204 
205     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transferfrom
206     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
207 
208         require(!tokenSaleIsRunning);
209 
210         // Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event (ERC-20)
211         require(_value >= 0);
212 
213         // The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism
214         require(msg.sender == _from || _value <= allowance[_from][msg.sender]);
215 
216         // check if _from account have required amount
217         require(_value <= balanceOf[_from]);
218 
219         // Subtract from the sender
220         // balanceOf[_from] = balanceOf[_from] - _value;
221         balanceOf[_from] = balanceOf[_from].sub(_value);
222         //
223         // Add the same to the recipient
224         // balanceOf[_to] = balanceOf[_to] + _value;
225         balanceOf[_to] = balanceOf[_to].add(_value);
226 
227         // If allowance used, change allowances correspondingly
228         if (_from != msg.sender) {
229             // allowance[_from][msg.sender] = allowance[_from][msg.sender] - _value;
230             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
231         }
232 
233         // event
234         Transfer(_from, _to, _value);
235 
236         return true;
237     } // end of transferFrom
238 
239     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approve
240     // there is and attack, see:
241     // https://github.com/CORIONplatform/solidity/issues/6,
242     // https://drive.google.com/file/d/0ByMtMw2hul0EN3NCaVFHSFdxRzA/view
243     // but this function is required by ERC-20
244     function approve(address _spender, uint256 _value) public returns (bool){
245         require(_value >= 0);
246         allowance[msg.sender][_spender] = _value;
247         // event
248         Approval(msg.sender, _spender, _value);
249         return true;
250     }
251 
252     /*  ---------- Interaction with other contracts  */
253 
254     /* User can allow another smart contract to spend some shares in his behalf
255     *  (this function should be called by user itself)
256     *  @param _spender another contract's address
257     *  @param _value number of tokens
258     *  @param _extraData Data that can be sent from user to another contract to be processed
259     *  bytes - dynamically-sized byte array,
260     *  see http://solidity.readthedocs.io/en/v0.4.15/types.html#dynamically-sized-byte-array
261     *  see possible attack information in comments to function 'approve'
262     *  > this may be used to convert pre-ICO tokens to ICO tokens
263     */
264     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool) {
265 
266         approve(_spender, _value);
267 
268         // 'spender' is another contract that implements code as prescribed in 'allowanceRecipient' above
269         allowanceRecipient spender = allowanceRecipient(_spender);
270 
271         // our contract calls 'receiveApproval' function of another contract ('allowanceRecipient') to send information about
272         // allowance and data sent by user
273         // 'this' is this (our) contract address
274         if (spender.receiveApproval(msg.sender, _value, this, _extraData)) {
275             DataSentToAnotherContract(msg.sender, _spender, _extraData);
276             return true;
277         }
278         return false;
279     } // end of approveAndCall
280 
281     // for convenience:
282     function approveAllAndCall(address _spender, bytes _extraData) public returns (bool success) {
283         return approveAndCall(_spender, balanceOf[msg.sender], _extraData);
284     }
285 
286     /* https://github.com/ethereum/EIPs/issues/677
287     * transfer tokens with additional info to another smart contract, and calls its correspondent function
288     * @param address _to - another smart contract address
289     * @param uint256 _value - number of tokens
290     * @param bytes _extraData - data to send to another contract
291     * > this may be used to convert pre-ICO tokens to ICO tokens
292     */
293     function transferAndCall(address _to, uint256 _value, bytes _extraData) public returns (bool success){
294 
295         transferFrom(msg.sender, _to, _value);
296 
297         tokenRecipient receiver = tokenRecipient(_to);
298 
299         if (receiver.tokenFallback(msg.sender, _value, _extraData)) {
300             DataSentToAnotherContract(msg.sender, _to, _extraData);
301             return true;
302         }
303         return false;
304     } // end of transferAndCall
305 
306     // for example for converting ALL tokens of user account to another tokens
307     function transferAllAndCall(address _to, bytes _extraData) public returns (bool success){
308         return transferAndCall(_to, balanceOf[msg.sender], _extraData);
309     }
310 
311     /* ========= MINT TOKENS: */
312 
313     event NewTokensMinted(
314         address indexed to, //..............1
315         uint256 invested, //................2
316         uint256 tokensForInvestor, //.......3
317         address indexed by, //..............4
318         bool indexed tokenSaleFinished, //..5
319         uint256 totalInvested //............6
320     );
321 
322     // value - number of tokens to mint
323     function mint(address to, uint256 value, uint256 _invested) public returns (bool) {
324 
325         require(tokenSaleIsRunning);
326 
327         require(msg.sender == owner);
328 
329         // tokens for investor
330         balanceOf[to] = balanceOf[to].add(value);
331         totalSupply = totalSupply.add(value);
332 
333         invested = invested.add(_invested);
334 
335         if (invested >= hardCap || now.sub(tokenSaleStarted) > salePeriod) {
336             tokenSaleIsRunning = false;
337         }
338 
339         NewTokensMinted(
340             to, //...................1
341             _invested, //............2
342             value, //................3
343             msg.sender, //...........4
344             !tokenSaleIsRunning, //..5
345             invested //..............6
346         );
347         return true;
348     }
349 
350     //    function() public payable {
351     //        // require(msg.sender == owner); // no check means we can use standard transfer in main contract
352     //    }
353 
354     function transferDividends() public payable {
355     }
356 
357 }