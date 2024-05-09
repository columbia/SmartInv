1 pragma solidity >=0.4.24 <0.6.0;
2 
3 /**
4  * Cryptonomica EthID Tokens smart contract
5  * developed by Cryptonomica Ltd., 2018
6  * https://cryptonomica.net
7  * github: https://github.com/Cryptonomica/
8  * deployed using compiler version: 0.4.24+commit.e67f0147.Emscripten.clang
9  */
10 
11 
12 /* ---- Libraries */
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that revert on error
16  * see: https://openzeppelin.org/api/docs/math_SafeMath.html
17  * source: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v2.0.0/contracts/math/SafeMath.sol
18  * (e7aa8de on Oct 21 2018)
19  */
20 library SafeMath {
21 
22     /**
23     * @dev Multiplies two numbers, reverts on overflow.
24     */
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
27         // benefit is lost if 'b' is also tested.
28         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b);
35 
36         return c;
37     }
38 
39     /**
40     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
41     */
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b > 0);
44         // Solidity only automatically asserts when dividing by 0
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47 
48         return c;
49     }
50 
51     /**
52     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
53     */
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         require(b <= a);
56         uint256 c = a - b;
57 
58         return c;
59     }
60 
61     /**
62     * @dev Adds two numbers, reverts on overflow.
63     */
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         require(c >= a);
67 
68         return c;
69     }
70 
71     /**
72     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
73     * reverts when dividing by zero.
74     */
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b != 0);
77         return a % b;
78     }
79 }
80 
81 // << end of SafeMath
82 
83 /* --- "Interfaces" */
84 
85 //  this is expected from another contracts
86 //  if it wants to spend tokens of behalf of the token owner in our contract
87 contract allowanceRecipient {
88     function receiveApproval(address _from, uint256 _value, address _inContract, bytes _extraData) public returns (bool);
89 }
90 
91 // see: https://github.com/ethereum/EIPs/issues/677
92 contract tokenRecipient {
93     function tokenFallback(address _from, uint256 _value, bytes _extraData) public returns (bool);
94 }
95 
96 /* -------- ///////// Main Contract /////// ----------- */
97 
98 contract EthIdTokens {
99 
100     using SafeMath for uint256;
101 
102     /* --- ERC-20 variables */
103 
104     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#name
105     // function name() constant returns (string name)
106     string public name = "EthID Tokens";
107 
108     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#symbol
109     // function symbol() constant returns (string symbol)
110     string public symbol = "EthID";
111 
112     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#decimals
113     // function decimals() constant returns (uint8 decimals)
114     uint8 public decimals = 0;
115 
116     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#totalsupply
117     // function totalSupply() constant returns (uint256 totalSupply)
118     uint256 public totalSupply;
119 
120     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#balanceof
121     // function balanceOf(address _owner) constant returns (uint256 balance)
122     mapping(address => uint256) public balanceOf;
123 
124     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#allowance
125     // function allowance(address _owner, address _spender) constant returns (uint256 remaining)
126     mapping(address => mapping(address => uint256)) public allowance;
127 
128     /* --- ERC-20 events */
129 
130     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#events
131 
132     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer-1
133     event Transfer(address indexed from, address indexed to, uint256 value);
134 
135     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approval
136     event Approval(address indexed _owner, address indexed spender, uint256 value);
137 
138     /* --- Events for interaction with other smart contracts */
139     event DataSentToAnotherContract(address indexed _from, address indexed _toContract, bytes _extraData);
140 
141 
142     /* --- administrative variable and functions */
143 
144     address public owner; // smart contract owner (super admin)
145 
146     // to avoid mistakes: owner (super admin) should be changed in two steps
147     // change is valid when accepted from new owner address
148     address private newOwner;
149 
150     function changeOwnerStart(address _newOwner) public {
151         // only owner
152         require(msg.sender == owner);
153 
154         newOwner = _newOwner;
155         emit ChangeOwnerStarted(msg.sender, _newOwner);
156     } //
157     event ChangeOwnerStarted (address indexed startedBy, address indexed newOwner);
158 
159     function changeOwnerAccept() public {
160         // only by new owner
161         require(msg.sender == newOwner);
162         // event here:
163         emit OwnerChanged(owner, newOwner);
164         owner = newOwner;
165     } //
166     event OwnerChanged(address indexed from, address indexed to);
167 
168     /* --- Constructor */
169 
170     constructor() public {
171         // can be hardcoded in production:
172         owner = msg.sender;
173         // 100M :
174         totalSupply = 100 * 1000000;
175         balanceOf[owner] = totalSupply;
176     }
177 
178 
179     /* --- Dividends */
180     event DividendsPaid(address indexed to, uint256 tokensBurned, uint256 sumInWeiPaid);
181 
182     // valueInTokens : tokens to burn to get dividends
183     function takeDividends(uint256 valueInTokens) public returns (bool) {
184 
185         require(address(this).balance > 0);
186         require(totalSupply > 0);
187 
188         uint256 sumToPay = (address(this).balance / totalSupply).mul(valueInTokens);
189 
190         totalSupply = totalSupply.sub(valueInTokens);
191         balanceOf[msg.sender] = balanceOf[msg.sender].sub(valueInTokens);
192 
193         msg.sender.transfer(sumToPay);
194 
195         emit DividendsPaid(msg.sender, valueInTokens, sumToPay);
196 
197         return true;
198     }
199 
200     // only if all tokens are burned:
201     event WithdrawalByOwner(uint256 value, address indexed to); //
202     function withdrawAllByOwner() public {
203         // only owner:
204         require(msg.sender == owner);
205         // only if all tokens burned:
206         require(totalSupply == 0);
207 
208         uint256 sumToWithdraw = address(this).balance;
209         owner.transfer(sumToWithdraw);
210         emit WithdrawalByOwner(sumToWithdraw, owner);
211     }
212 
213     /* --- ERC-20 Functions */
214     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#methods
215 
216     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer
217     function transfer(address _to, uint256 _value) public returns (bool){
218         if (_to == address(this)) {
219             return takeDividends(_value);
220         } else {
221             return transferFrom(msg.sender, _to, _value);
222         }
223     }
224 
225     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transferfrom
226     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
227 
228         // Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event (ERC-20)
229         require(_value >= 0);
230 
231         // The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism
232         require(msg.sender == _from || _value <= allowance[_from][msg.sender]);
233 
234         // check if _from account have required amount
235         require(_value <= balanceOf[_from]);
236 
237         // Subtract from the sender
238         // balanceOf[_from] = balanceOf[_from] - _value;
239         balanceOf[_from] = balanceOf[_from].sub(_value);
240         // Add the same to the recipient
241         // balanceOf[_to] = balanceOf[_to] + _value;
242         balanceOf[_to] = balanceOf[_to].add(_value);
243 
244         // If allowance used, change allowances correspondingly
245         if (_from != msg.sender) {
246             // allowance[_from][msg.sender] = allowance[_from][msg.sender] - _value;
247             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
248         }
249 
250         // event
251         emit Transfer(_from, _to, _value);
252 
253         return true;
254     } // end of transferFrom
255 
256     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approve
257     // there is and attack, see:
258     // https://github.com/CORIONplatform/solidity/issues/6,
259     // https://drive.google.com/file/d/0ByMtMw2hul0EN3NCaVFHSFdxRzA/view
260     // but this function is required by ERC-20
261     function approve(address _spender, uint256 _value) public returns (bool){
262         require(_value >= 0);
263         allowance[msg.sender][_spender] = _value;
264         // event
265         emit Approval(msg.sender, _spender, _value);
266         return true;
267     }
268 
269     /*  ---------- Interaction with other contracts  */
270 
271     /* User can allow another smart contract to spend some tokens in his behalf
272     *  (this function should be called by user itself)
273     *  @param _spender another contract's address
274     *  @param _value number of tokens
275     *  @param _extraData Data that can be sent from user to another contract to be processed
276     *  bytes - dynamically-sized byte array,
277     *  see http://solidity.readthedocs.io/en/v0.4.15/types.html#dynamically-sized-byte-array
278     *  see possible attack information in comments to function 'approve'
279     *  > this may be used, for example, to convert pre-ICO tokens to ICO tokens, or
280     *    to convert some tokens to other tokens
281     */
282     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool) {
283 
284         approve(_spender, _value);
285 
286         // 'spender' is another contract that implements code as prescribed in 'allowanceRecipient' above
287         allowanceRecipient spender = allowanceRecipient(_spender);
288 
289         // our contract calls 'receiveApproval' function of another contract ('allowanceRecipient') to send information about
290         // allowance and data sent by user
291         // 'this' is this (our) contract address
292         if (spender.receiveApproval(msg.sender, _value, this, _extraData)) {
293             emit DataSentToAnotherContract(msg.sender, _spender, _extraData);
294             return true;
295         }
296         return false;
297     } // end of approveAndCall
298 
299     // for convenience:
300     function approveAllAndCall(address _spender, bytes _extraData) public returns (bool success) {
301         return approveAndCall(_spender, balanceOf[msg.sender], _extraData);
302     }
303 
304     /* https://github.com/ethereum/EIPs/issues/677
305     * transfer tokens with additional info to another smart contract, and calls its correspondent function
306     * @param address _to - another smart contract address
307     * @param uint256 _value - number of tokens
308     * @param bytes _extraData - data to send to another contract
309     *  > this may be used, for example, to convert pre-ICO tokens to ICO tokens, or
310     *    to convert some tokens to other tokens
311     */
312     function transferAndCall(address _to, uint256 _value, bytes _extraData) public returns (bool success){
313 
314         transferFrom(msg.sender, _to, _value);
315 
316         tokenRecipient receiver = tokenRecipient(_to);
317 
318         if (receiver.tokenFallback(msg.sender, _value, _extraData)) {
319             emit DataSentToAnotherContract(msg.sender, _to, _extraData);
320             return true;
321         }
322         return false;
323     } // end of transferAndCall
324 
325     // for example for converting ALL tokens on user account to another tokens
326     function transferAllAndCall(address _to, bytes _extraData) public returns (bool success){
327         return transferAndCall(_to, balanceOf[msg.sender], _extraData);
328     }
329 
330     /* ---- (!) Receive payments */
331     function() public payable {
332         // no code here, so we can use standard transfer function
333     }
334 
335 }