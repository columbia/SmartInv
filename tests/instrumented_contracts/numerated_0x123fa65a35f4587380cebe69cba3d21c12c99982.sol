1 pragma solidity ^0.5.7;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint a, uint b) internal pure returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal pure returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal pure returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal pure returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
44     return a < b ? a : b;
45   }
46 }
47 
48 
49 contract EIP20Interface {
50     /* This is a slight change to the ERC20 base standard.
51     function totalSupply() constant returns (uint256 supply);
52     is replaced with:
53     uint256 public totalSupply;
54     This automatically creates a getter function for the totalSupply.
55     This is moved to the base contract since public getter functions are not
56     currently recognised as an implementation of the matching abstract
57     function by the compiler.
58     */
59     /// total amount of tokens
60     uint256 public totalSupply;
61 
62     /// @param _owner The address from which the balance will be retrieved
63     /// @return The balance
64     function balanceOf(address _owner) public view returns (uint256 balance);
65 
66     /// @notice send `_value` token to `_to` from `msg.sender`
67     /// @param _to The address of the recipient
68     /// @param _value The amount of token to be transferred
69     /// @return Whether the transfer was successful or not
70     function transfer(address _to, uint256 _value) public returns (bool success);
71 
72     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
73     /// @param _from The address of the sender
74     /// @param _to The address of the recipient
75     /// @param _value The amount of token to be transferred
76     /// @return Whether the transfer was successful or not
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
78 
79     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
80     /// @param _spender The address of the account able to transfer the tokens
81     /// @param _value The amount of tokens to be approved for transfer
82     /// @return Whether the approval was successful or not
83     function approve(address _spender, uint256 _value) public returns (bool success);
84 
85     /// @param _owner The address of the account owning tokens
86     /// @param _spender The address of the account able to transfer the tokens
87     /// @return Amount of remaining tokens allowed to spent
88     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
89 
90     // solhint-disable-next-line no-simple-event-func-name
91     event Transfer(address indexed _from, address indexed _to, uint256 _value);
92     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93 }
94 
95 
96 contract EIP20 is EIP20Interface {
97 
98     uint256 constant private MAX_UINT256 = 2**256 - 1;
99     mapping (address => uint256) public balances;
100     mapping (address => mapping (address => uint256)) public allowed;
101     /*
102     NOTE:
103     The following variables are OPTIONAL vanities. One does not have to include them.
104     They allow one to customise the token contract & in no way influences the core functionality.
105     Some wallets/interfaces might not even bother to look at this information.
106     */
107     string public name;                   //fancy name: eg Simon Bucks
108     uint8 public decimals;                //How many decimals to show.
109     string public symbol;                 //An identifier: eg SBX
110 
111     constructor(
112         uint256 _initialAmount,
113         string memory _tokenName,
114         uint8 _decimalUnits,
115         string memory _tokenSymbol
116     ) public {
117         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
118         totalSupply = _initialAmount;                        // Update total supply
119         name = _tokenName;                                   // Set the name for display purposes
120         decimals = _decimalUnits;                            // Amount of decimals for display purposes
121         symbol = _tokenSymbol;                               // Set the symbol for display purposes
122     }
123 
124     function transfer(address _to, uint256 _value) public returns (bool success) {
125         require(balances[msg.sender] >= _value);
126         balances[msg.sender] -= _value;
127         balances[_to] += _value;
128         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
129         return true;
130     }
131 
132     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
133         uint256 allowance = allowed[_from][msg.sender];
134         require(balances[_from] >= _value && allowance >= _value);
135         balances[_to] += _value;
136         balances[_from] -= _value;
137         if (allowance < MAX_UINT256) {
138             allowed[_from][msg.sender] -= _value;
139         }
140         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
141         return true;
142     }
143 
144     function balanceOf(address _owner) public view returns (uint256 balance) {
145         return balances[_owner];
146     }
147 
148     function approve(address _spender, uint256 _value) public returns (bool success) {
149         allowed[msg.sender][_spender] = _value;
150         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
151         return true;
152     }
153 
154     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
155         return allowed[_owner][_spender];
156     }
157 }
158 
159 
160 contract BitbattleExchange{
161     using SafeMath for uint256;
162 
163     constructor(address _escrow, address _namiMultiSigWallet) public {
164         require(_namiMultiSigWallet != address(0));
165         escrow = _escrow;
166         namiMultiSigWallet = _namiMultiSigWallet;
167         
168         // init token
169         // BinanceCoin
170         TokenAddress[0] = 0xB8c77482e45F1F44dE1745F52C74426C631bDD52;
171         // Maker
172         TokenAddress[1] = 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2;
173         // BasicAttentionToken
174         TokenAddress[2] = 0x0D8775F648430679A709E98d2b0Cb6250d2887EF;
175         // OmiseGo
176         TokenAddress[3] = 0xd26114cd6EE289AccF82350c8d8487fedB8A0C07;
177         // Chainlink
178         TokenAddress[4] = 0x514910771AF9Ca656af840dff83E8264EcF986CA;
179         // Holo
180         TokenAddress[5] = 0x6c6EE5e31d828De241282B9606C8e98Ea48526E2;
181         // Zilliqa
182         TokenAddress[6] = 0x05f4a42e251f2d52b8ed15E9FEdAacFcEF1FAD27;
183         // Augur
184         TokenAddress[7] = 0x1985365e9f78359a9B6AD760e32412f4a445E862;
185         // 0x
186         TokenAddress[8] = 0xE41d2489571d322189246DaFA5ebDe1F4699F498;
187         // THETA
188         TokenAddress[9] = 0x3883f5e181fccaF8410FA61e12b59BAd963fb645;
189         // PundiX
190         TokenAddress[10] = 0xA15C7Ebe1f07CaF6bFF097D8a589fb8AC49Ae5B3;
191         // IOST
192         TokenAddress[11] = 0xFA1a856Cfa3409CFa145Fa4e20Eb270dF3EB21ab;
193         // EnjinCoin
194         TokenAddress[12] = 0xF629cBd94d3791C9250152BD8dfBDF380E2a3B9c;
195         // HuobiToken
196         TokenAddress[13] = 0x6f259637dcD74C767781E37Bc6133cd6A68aa161;
197         // Status
198         TokenAddress[14] = 0x744d70FDBE2Ba4CF95131626614a1763DF805B9E;
199         
200         // Nami
201         TokenAddress[15] = 0x8d80de8A78198396329dfA769aD54d24bF90E7aa;
202         // Dai
203         TokenAddress[16] = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
204         // KyberNetwork
205         TokenAddress[17] = 0xdd974D5C2e2928deA5F71b9825b8b646686BD200;
206         // Golem
207         TokenAddress[18] = 0xa74476443119A942dE498590Fe1f2454d7D4aC0d;
208         // Populous
209         TokenAddress[19] = 0xd4fa1460F537bb9085d22C7bcCB5DD450Ef28e3a;
210         // CryptoCom
211         TokenAddress[20] = 0xB63B606Ac810a52cCa15e44bB630fd42D8d1d83d;
212         // Waltonchain
213         TokenAddress[21] = 0xb7cB1C96dB6B22b0D3d9536E0108d062BD488F74;
214         // Decentraland
215         TokenAddress[22] = 0x0F5D2fB29fb7d3CFeE444a200298f468908cC942;
216         // LoomNetwork
217         TokenAddress[23] = 0xA4e8C3Ec456107eA67d3075bF9e3DF3A75823DB0;
218         // Loopring
219         TokenAddress[24] = 0xEF68e7C694F40c8202821eDF525dE3782458639f;
220         // Aelf
221         TokenAddress[25] = 0xbf2179859fc6D5BEE9Bf9158632Dc51678a4100e;
222         // PowerLedger
223         TokenAddress[26] = 0x595832F8FC6BF59c85C527fEC3740A1b7a361269;
224         // USDCoin
225         TokenAddress[27] = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
226     }
227 
228     // escrow has exclusive priveleges to call administrative
229     // functions on this contract.
230     address public escrow;
231     uint public minWithdraw = 1 * 10**18;
232     uint public maxWithdraw = 1000000 * 10**18;
233 
234     // Gathered funds can be withdraw only to namimultisigwallet's address.
235     address public namiMultiSigWallet;
236     
237     // Token Address
238     mapping(uint256 => address) public TokenAddress;
239 
240 
241     /**
242     * list setting function
243     */
244     mapping(address => bool) public isController;
245 
246     /**
247      * List event
248      */
249     event Withdraw(address indexed user, uint amount, uint timeWithdraw, uint tokenIndex);
250 
251     modifier onlyEscrow() {
252         require(msg.sender == escrow);
253         _;
254     }
255 
256     modifier onlyNamiMultisig {
257         require(msg.sender == namiMultiSigWallet);
258         _;
259     }
260 
261     modifier onlyController {
262         require(isController[msg.sender] == true);
263         _;
264     }
265 
266     
267     /**
268      * Admin function
269      */
270     function() external payable {}
271     function changeEscrow(address _escrow) public
272     onlyNamiMultisig
273     {
274         require(_escrow != address(0));
275         escrow = _escrow;
276     }
277 
278     function changeMinWithdraw(uint _minWithdraw) public
279     onlyEscrow
280     {
281         require(_minWithdraw != 0);
282         minWithdraw = _minWithdraw;
283     }
284 
285     function changeMaxWithdraw(uint _maxNac) public
286     onlyEscrow
287     {
288         require(_maxNac != 0);
289         maxWithdraw = _maxNac;
290     }
291 
292     /// @dev withdraw ether, only escrow can call
293     /// @param _amount value ether in wei to withdraw
294     function withdrawEther(uint _amount, address payable _to) public
295     onlyEscrow
296     {
297         require(_to != address(0x0));
298         // Available at any phase.
299         if (address(this).balance > 0) {
300             _to.transfer(_amount);
301         }
302     }
303 
304     /**
305      * make new controller
306      * require input address is not a controller
307      * execute any time in sc state
308      */
309     function setController(address _controller)
310     public
311     onlyEscrow
312     {
313         require(!isController[_controller]);
314         isController[_controller] = true;
315     }
316 
317     /**
318      * remove controller
319      * require input address is a controller
320      * execute any time in sc state
321      */
322     function removeController(address _controller)
323     public
324     onlyEscrow
325     {
326         require(isController[_controller]);
327         isController[_controller] = false;
328     }
329     
330     /**
331      * update token address
332      */
333     function updateTokenAddress(address payable _tokenAddress, uint _tokenIndex) public
334     onlyEscrow
335     {
336         require(_tokenAddress != address(0));
337         TokenAddress[_tokenIndex] = _tokenAddress;
338     }
339 
340 
341     function withdrawToken(address _account, uint _amount, uint _tokenIndex) public
342     onlyController
343     {
344         require(_account != address(0x0) && _amount != 0);
345         require(_amount >= minWithdraw && _amount <= maxWithdraw);
346         
347         // check valid token index
348         require(TokenAddress[_tokenIndex] != address(0));
349         EIP20 ERC20Token = EIP20(TokenAddress[_tokenIndex]);
350         if (ERC20Token.balanceOf(address(this)) >= _amount) {
351             ERC20Token.transfer(_account, _amount);
352         } else {
353             revert();
354         }
355         // emit event
356         emit Withdraw(_account, _amount, now, _tokenIndex);
357     }
358 }