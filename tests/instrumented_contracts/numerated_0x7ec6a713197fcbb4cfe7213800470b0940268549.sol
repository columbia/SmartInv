1 pragma solidity ^0.4.11;
2 
3 /*
4     Overflow protected math functions
5 */
6 contract SafeMath {
7     /**
8         constructor
9     */
10     function SafeMath() {
11     }
12 
13     /**
14         @dev returns the sum of _x and _y, asserts if the calculation overflows
15 
16         @param _x   value 1
17         @param _y   value 2
18 
19         @return sum
20     */
21     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
22         uint256 z = _x + _y;
23         assert(z >= _x);
24         return z;
25     }
26 
27     /**
28         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
29 
30         @param _x   minuend
31         @param _y   subtrahend
32 
33         @return difference
34     */
35     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
36         assert(_x >= _y);
37         return _x - _y;
38     }
39 
40     /**
41         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
42 
43         @param _x   factor 1
44         @param _y   factor 2
45 
46         @return product
47     */
48     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
49         uint256 z = _x * _y;
50         assert(_x == 0 || z / _x == _y);
51         return z;
52     }
53 } 
54 
55 /*
56     Owned contract interface
57 */
58 contract IOwned {
59     // this function isn't abstract since the compiler emits automatically generated getter functions as external
60     function owner() public constant returns (address owner) { owner; }
61 
62     function transferOwnership(address _newOwner) public;
63     function acceptOwnership() public;
64 }
65 
66 /*
67     Provides support and utilities for contract ownership
68 */
69 contract Owned is IOwned {
70     address public owner;
71     address public newOwner;
72 
73     event OwnerUpdate(address _prevOwner, address _newOwner);
74 
75     /**
76         @dev constructor
77     */
78     function Owned() {
79         owner = msg.sender;
80     }
81 
82     // allows execution by the owner only
83     modifier ownerOnly {
84         assert(msg.sender == owner);
85         _;
86     }
87 
88     /**
89         @dev allows transferring the contract ownership
90         the new owner still need to accept the transfer
91         can only be called by the contract owner
92 
93         @param _newOwner    new contract owner
94     */
95     function transferOwnership(address _newOwner) public ownerOnly {
96         require(_newOwner != owner);
97         newOwner = _newOwner;
98     }
99 
100     /**
101         @dev used by a new owner to accept an ownership transfer
102     */
103     function acceptOwnership() public {
104         require(msg.sender == newOwner);
105         OwnerUpdate(owner, newOwner);
106         owner = newOwner;
107         newOwner = 0x0;
108     }
109 }
110 
111 /*
112     ERC20 Standard Token interface
113 */
114 contract IERC20Token {
115     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
116     function name() public constant returns (string name) { name; }
117     function symbol() public constant returns (string symbol) { symbol; }
118     function decimals() public constant returns (uint8 decimals) { decimals; }
119     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
120     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
121     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
122 
123     function transfer(address _to, uint256 _value) public returns (bool success);
124     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
125     function approve(address _spender, uint256 _value) public returns (bool success);
126 }
127 
128 /*
129     Token Holder interface
130 */
131 contract ITokenHolder is IOwned {
132     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
133 }
134 
135 /*
136     We consider every contract to be a 'token holder' since it's currently not possible
137     for a contract to deny receiving tokens.
138 
139     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
140     the owner to send tokens that were sent to the contract by mistake back to their sender.
141 */
142 contract TokenHolder is ITokenHolder, Owned {
143     /**
144         @dev constructor
145     */
146     function TokenHolder() {
147     }
148 
149     // validates an address - currently only checks that it isn't null
150     modifier validAddress(address _address) {
151         require(_address != 0x0);
152         _;
153     }
154 
155     // verifies that the address is different than this contract address
156     modifier notThis(address _address) {
157         require(_address != address(this));
158         _;
159     }
160 
161     /**
162         @dev withdraws tokens held by the contract and sends them to an account
163         can only be called by the owner
164 
165         @param _token   ERC20 token contract address
166         @param _to      account to receive the new amount
167         @param _amount  amount to withdraw
168     */
169     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
170         public
171         ownerOnly
172         validAddress(_token)
173         validAddress(_to)
174         notThis(_to)
175     {
176         assert(_token.transfer(_to, _amount));
177     }
178 }
179 
180 /*
181     Smart Token interface
182 */
183 contract ISmartToken is ITokenHolder, IERC20Token {
184     function disableTransfers(bool _disable) public;
185     function issue(address _to, uint256 _amount) public;
186     function destroy(address _from, uint256 _amount) public;
187 }
188 
189 /*
190     BancorPriceFloor v0.1
191 
192     The bancor price floor contract is a simple contract that allows selling smart tokens for a constant ETH price
193 
194     'Owned' is specified here for readability reasons
195 */
196 contract BancorPriceFloor is Owned, TokenHolder, SafeMath {
197     uint256 public constant TOKEN_PRICE_N = 1;      // crowdsale price in wei (numerator)
198     uint256 public constant TOKEN_PRICE_D = 100;    // crowdsale price in wei (denominator)
199 
200     string public version = '0.1';
201     ISmartToken public token; // smart token the contract allows selling
202 
203     /**
204         @dev constructor
205 
206         @param _token   smart token the contract allows selling
207     */
208     function BancorPriceFloor(ISmartToken _token)
209         validAddress(_token)
210     {
211         token = _token;
212     }
213 
214     /**
215         @dev sells the smart token for ETH
216         note that the function will sell the full allowance amount
217 
218         @return ETH sent in return
219     */
220     function sell() public returns (uint256 amount) {
221         uint256 allowance = token.allowance(msg.sender, this); // get the full allowance amount
222         assert(token.transferFrom(msg.sender, this, allowance)); // transfer all tokens from the sender to the contract
223         uint256 etherValue = safeMul(allowance, TOKEN_PRICE_N) / TOKEN_PRICE_D; // calculate ETH value of the tokens
224         msg.sender.transfer(etherValue); // send the ETH amount to the seller
225         return etherValue;
226     }
227 
228     /**
229         @dev withdraws ETH from the contract
230 
231         @param _amount  amount of ETH to withdraw
232     */
233     function withdraw(uint256 _amount) public ownerOnly {
234         assert(msg.sender.send(_amount)); // send the amount
235     }
236 
237     /**
238         @dev deposits ETH in the contract
239     */
240     function() public payable {
241     }
242 }