1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  * source: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         if (a == 0) {
15             return 0;
16         }
17         c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         // uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return a / b;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44         c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 /* "Interfaces" */
51 
52 //  this is expected from another contracts
53 //  if it wants to spend tokens of behalf of the token owner in our contract
54 //  this can be used in many situations, for example to convert pre-ICO tokens to ICO tokens
55 //  see 'approveAndCall' function
56 contract allowanceRecipient {
57     function receiveApproval(address _from, uint256 _value, address _inContract, bytes _extraData) public returns (bool);
58 }
59 
60 
61 // see:
62 // https://github.com/ethereum/EIPs/issues/677
63 contract tokenRecipient {
64     function tokenFallback(address _from, uint256 _value, bytes _extraData) public returns (bool);
65 }
66 
67 /**
68  * The ACCP contract
69  * ver. 2.0
70  */
71 contract ACCP {
72 
73     // see: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
74     using SafeMath for uint256;
75 
76     address public owner;
77 
78     /* --- ERC-20 variables */
79 
80     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#name
81     // function name() constant returns (string name)
82     string public name = "ACCP";
83 
84     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#symbol
85     // function symbol() constant returns (string symbol)
86     string public symbol = "ACCP";
87 
88     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#decimals
89     // function decimals() constant returns (uint8 decimals)
90     uint8 public decimals = 0;
91 
92     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#totalsupply
93     // function totalSupply() constant returns (uint256 totalSupply)
94     // we start with zero and will create tokens as SC receives ETH
95     uint256 public totalSupply = 10 * 1000000000; // 10B
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
118     /* --- Other variables */
119     bool public transfersBlocked = false;
120     mapping(address => bool) public whiteListed;
121 
122     /* ---------- Constructor */
123     // do not forget about:
124     // https://medium.com/@codetractio/a-look-into-paritys-multisig-wallet-bug-affecting-100-million-in-ether-and-tokens-356f5ba6e90a
125     constructor() public {
126         // owner = msg.sender;
127         owner = 0xff809E4ebB5F94171881b3CA9a0EBf4405C6370a;
128         // (!!!) all tokens initially belong to smart contract itself
129         balanceOf[this] = totalSupply;
130     }
131 
132     event TransfersBlocked(address indexed by);//
133     function blockTransfers() public {// only owner!
134         //
135         require(msg.sender == owner);
136         //
137         require(!transfersBlocked);
138         transfersBlocked = true;
139         emit TransfersBlocked(msg.sender);
140     }
141 
142     event TransfersAllowed(address indexed by);//
143     function allowTransfers() public {// only owner!
144         //
145         require(msg.sender == owner);
146         //
147         require(transfersBlocked);
148         transfersBlocked = false;
149         emit TransfersAllowed(msg.sender);
150     }
151 
152     event AddedToWhiteList(address indexed by, address indexed added);//
153     function addToWhiteList(address acc) public {// only owner!
154         //
155         require(msg.sender == owner);
156         // require(!whiteListed[acc]);
157         whiteListed[acc] = true;
158         emit AddedToWhiteList(msg.sender, acc);
159     }
160 
161     event RemovedFromWhiteList(address indexed by, address indexed removed);//
162     function removeFromWhiteList(address acc) public {// only owner!
163         //
164         require(msg.sender == owner);
165         //
166         require(acc != owner);
167         // require(!whiteListed[acc]);
168         whiteListed[acc] = false;
169         emit RemovedFromWhiteList(msg.sender, acc);
170     }
171 
172     event tokensBurnt(address indexed by, uint256 value); //
173     function burnTokens() public {// only owner!
174         //
175         require(msg.sender == owner);
176         //
177         require(balanceOf[this] > 0);
178         emit tokensBurnt(msg.sender, balanceOf[this]);
179         balanceOf[this] = 0;
180     }
181 
182     /* --- ERC-20 Functions */
183     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#methods
184 
185     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer
186     function transfer(address _to, uint256 _value) public returns (bool){
187         return transferFrom(msg.sender, _to, _value);
188     }
189 
190     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transferfrom
191     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
192 
193         // Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event (ERC-20)
194         require(_value >= 0);
195 
196         // The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism
197         require(msg.sender == _from || _value <= allowance[_from][msg.sender] || (_from == address(this) && msg.sender == owner));
198 
199         // TODO:
200         require(!transfersBlocked || (whiteListed[_from] && whiteListed[msg.sender]));
201 
202         // check if _from account have required amount
203         require(_value <= balanceOf[_from]);
204 
205         // Subtract from the sender
206         // balanceOf[_from] = balanceOf[_from] - _value;
207         balanceOf[_from] = balanceOf[_from].sub(_value);
208         //
209         // Add the same to the recipient
210         // balanceOf[_to] = balanceOf[_to] + _value;
211         balanceOf[_to] = balanceOf[_to].add(_value);
212 
213         // If allowance used, change allowances correspondingly
214         if (_from != msg.sender && (!(_from == address(this) && msg.sender == owner))) {
215             // allowance[_from][msg.sender] = allowance[_from][msg.sender] - _value;
216             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
217         }
218 
219         // event
220         emit Transfer(_from, _to, _value);
221 
222         return true;
223     } // end of transferFrom
224 
225     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approve
226     // there is and attack, see:
227     // https://github.com/CORIONplatform/solidity/issues/6,
228     // https://drive.google.com/file/d/0ByMtMw2hul0EN3NCaVFHSFdxRzA/view
229     // but this function is required by ERC-20
230     function approve(address _spender, uint256 _value) public returns (bool){
231         require(_value >= 0);
232         allowance[msg.sender][_spender] = _value;
233         // event
234         emit Approval(msg.sender, _spender, _value);
235         return true;
236     }
237 
238     /*  ---------- Interaction with other contracts  */
239 
240     /* User can allow another smart contract to spend some shares in his behalf
241     *  (this function should be called by user itself)
242     *  @param _spender another contract's address
243     *  @param _value number of tokens
244     *  @param _extraData Data that can be sent from user to another contract to be processed
245     *  bytes - dynamically-sized byte array,
246     *  see http://solidity.readthedocs.io/en/v0.4.15/types.html#dynamically-sized-byte-array
247     *  see possible attack information in comments to function 'approve'
248     *  > this may be used to convert pre-ICO tokens to ICO tokens
249     */
250     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool) {
251 
252         approve(_spender, _value);
253 
254         // 'spender' is another contract that implements code as prescribed in 'allowanceRecipient' above
255         allowanceRecipient spender = allowanceRecipient(_spender);
256 
257         // our contract calls 'receiveApproval' function of another contract ('allowanceRecipient') to send information about
258         // allowance and data sent by user
259         // 'this' is this (our) contract address
260         if (spender.receiveApproval(msg.sender, _value, this, _extraData)) {
261             emit DataSentToAnotherContract(msg.sender, _spender, _extraData);
262             return true;
263         }
264         return false;
265     } // end of approveAndCall
266 
267     // for convenience:
268     function approveAllAndCall(address _spender, bytes _extraData) public returns (bool success) {
269         return approveAndCall(_spender, balanceOf[msg.sender], _extraData);
270     }
271 
272     /* https://github.com/ethereum/EIPs/issues/677
273     * transfer tokens with additional info to another smart contract, and calls its correspondent function
274     * @param address _to - another smart contract address
275     * @param uint256 _value - number of tokens
276     * @param bytes _extraData - data to send to another contract
277     * > this may be used to convert pre-ICO tokens to ICO tokens
278     */
279     function transferAndCall(address _to, uint256 _value, bytes _extraData) public returns (bool success){
280 
281         transferFrom(msg.sender, _to, _value);
282 
283         tokenRecipient receiver = tokenRecipient(_to);
284 
285         if (receiver.tokenFallback(msg.sender, _value, _extraData)) {
286             emit DataSentToAnotherContract(msg.sender, _to, _extraData);
287             return true;
288         }
289         return false;
290     } // end of transferAndCall
291 
292     // for example for converting ALL tokens of user account to another tokens
293     function transferAllAndCall(address _to, bytes _extraData) public returns (bool success){
294         return transferAndCall(_to, balanceOf[msg.sender], _extraData);
295     }
296 
297 }