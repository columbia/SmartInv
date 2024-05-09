1 pragma solidity ^0.4.11;
2 
3 /*
4     Utilities & Common Modifiers
5 */
6 contract Utils {
7     /**
8         constructor
9     */
10     function Utils() {
11     }
12 
13     // verifies that an amount is greater than zero
14     modifier greaterThanZero(uint256 _amount) {
15         require(_amount > 0);
16         _;
17     }
18 
19     // validates an address - currently only checks that it isn't null
20     modifier validAddress(address _address) {
21         require(_address != 0x0);
22         _;
23     }
24 
25     // verifies that the address is different than this contract address
26     modifier notThis(address _address) {
27         require(_address != address(this));
28         _;
29     }
30 
31     // Overflow protected math functions
32 
33     /**
34         @dev returns the sum of _x and _y, asserts if the calculation overflows
35 
36         @param _x   value 1
37         @param _y   value 2
38 
39         @return sum
40     */
41     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
42         uint256 z = _x + _y;
43         assert(z >= _x);
44         return z;
45     }
46 
47     /**
48         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
49 
50         @param _x   minuend
51         @param _y   subtrahend
52 
53         @return difference
54     */
55     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
56         assert(_x >= _y);
57         return _x - _y;
58     }
59 
60     /**
61         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
62 
63         @param _x   factor 1
64         @param _y   factor 2
65 
66         @return product
67     */
68     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
69         uint256 z = _x * _y;
70         assert(_x == 0 || z / _x == _y);
71         return z;
72     }
73 }
74 
75 /*
76     Owned contract interface
77 */
78 contract IOwned {
79     // this function isn't abstract since the compiler emits automatically generated getter functions as external
80     function owner() public constant returns (address) {}
81 
82     function transferOwnership(address _newOwner) public;
83     function acceptOwnership() public;
84 }
85 
86 /*
87     Provides support and utilities for contract ownership
88 */
89 contract Owned is IOwned {
90     address public owner;
91     address public newOwner;
92 
93     event OwnerUpdate(address _prevOwner, address _newOwner);
94 
95     /**
96         @dev constructor
97     */
98     function Owned() {
99         owner = msg.sender;
100     }
101 
102     // allows execution by the owner only
103     modifier ownerOnly {
104         assert(msg.sender == owner);
105         _;
106     }
107 
108     /**
109         @dev allows transferring the contract ownership
110         the new owner still needs to accept the transfer
111         can only be called by the contract owner
112 
113         @param _newOwner    new contract owner
114     */
115     function transferOwnership(address _newOwner) public ownerOnly {
116         require(_newOwner != owner);
117         newOwner = _newOwner;
118     }
119 
120     /**
121         @dev used by a new owner to accept an ownership transfer
122     */
123     function acceptOwnership() public {
124         require(msg.sender == newOwner);
125         OwnerUpdate(owner, newOwner);
126         owner = newOwner;
127         newOwner = 0x0;
128     }
129 }
130 
131 /*
132     ERC20 Standard Token interface
133 */
134 contract IERC20Token {
135     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
136     function name() public constant returns (string) {}
137     function symbol() public constant returns (string) {}
138     function decimals() public constant returns (uint8) {}
139     function totalSupply() public constant returns (uint256) {}
140     function balanceOf(address _owner) public constant returns (uint256) { _owner; }
141     function allowance(address _owner, address _spender) public constant returns (uint256) { _owner; _spender; }
142 
143     function transfer(address _to, uint256 _value) public returns (bool success);
144     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
145     function approve(address _spender, uint256 _value) public returns (bool success);
146 }
147 
148 /*
149     Bancor Formula interface
150 */
151 contract IBancorFormula {
152     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public constant returns (uint256);
153     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public constant returns (uint256);
154 }
155 
156 /*
157     Bancor Gas Price Limit interface
158 */
159 contract IBancorGasPriceLimit {
160     function gasPrice() public constant returns (uint256) {}
161 }
162 
163 /*
164     Bancor Quick Converter interface
165 */
166 contract IBancorQuickConverter {
167     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
168     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
169 }
170 
171 /*
172     Token Holder interface
173 */
174 contract ITokenHolder is IOwned {
175     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
176 }
177 
178 /*
179     We consider every contract to be a 'token holder' since it's currently not possible
180     for a contract to deny receiving tokens.
181 
182     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
183     the owner to send tokens that were sent to the contract by mistake back to their sender.
184 */
185 contract TokenHolder is ITokenHolder, Owned, Utils {
186     /**
187         @dev constructor
188     */
189     function TokenHolder() {
190     }
191 
192     /**
193         @dev withdraws tokens held by the contract and sends them to an account
194         can only be called by the owner
195 
196         @param _token   ERC20 token contract address
197         @param _to      account to receive the new amount
198         @param _amount  amount to withdraw
199     */
200     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
201         public
202         ownerOnly
203         validAddress(_token)
204         validAddress(_to)
205         notThis(_to)
206     {
207         assert(_token.transfer(_to, _amount));
208     }
209 }
210 
211 /*
212     Bancor Converter Extensions interface
213 */
214 contract IBancorConverterExtensions {
215     function formula() public constant returns (IBancorFormula) {}
216     function gasPriceLimit() public constant returns (IBancorGasPriceLimit) {}
217     function quickConverter() public constant returns (IBancorQuickConverter) {}
218 }
219 
220 /**
221     @dev the BancorConverterExtensions contract is an owned contract that serves as a single point of access
222     to the BancorFormula, BancorGasPriceLimit and BancorQuickConverter contracts from all BancorConverter contract instances.
223     it allows upgrading these contracts without the need to update each and every
224     BancorConverter contract instance individually.
225 */
226 contract BancorConverterExtensions is IBancorConverterExtensions, TokenHolder {
227     IBancorFormula public formula;  // bancor calculation formula contract
228     IBancorGasPriceLimit public gasPriceLimit; // bancor universal gas price limit contract
229     IBancorQuickConverter public quickConverter; // bancor quick converter contract
230 
231     /**
232         @dev constructor
233 
234         @param _formula         address of a bancor formula contract
235         @param _gasPriceLimit   address of a bancor gas price limit contract
236         @param _quickConverter  address of a bancor quick converter contract
237     */
238     function BancorConverterExtensions(IBancorFormula _formula, IBancorGasPriceLimit _gasPriceLimit, IBancorQuickConverter _quickConverter)
239         validAddress(_formula)
240         validAddress(_gasPriceLimit)
241         validAddress(_quickConverter)
242     {
243         formula = _formula;
244         gasPriceLimit = _gasPriceLimit;
245         quickConverter = _quickConverter;
246     }
247 
248     /*
249         @dev allows the owner to update the formula contract address
250 
251         @param _formula    address of a bancor formula contract
252     */
253     function setFormula(IBancorFormula _formula)
254         public
255         ownerOnly
256         validAddress(_formula)
257         notThis(_formula)
258     {
259         formula = _formula;
260     }
261 
262     /*
263         @dev allows the owner to update the gas price limit contract address
264 
265         @param _gasPriceLimit   address of a bancor gas price limit contract
266     */
267     function setGasPriceLimit(IBancorGasPriceLimit _gasPriceLimit)
268         public
269         ownerOnly
270         validAddress(_gasPriceLimit)
271         notThis(_gasPriceLimit)
272     {
273         gasPriceLimit = _gasPriceLimit;
274     }
275 
276     /*
277         @dev allows the owner to update the quick converter contract address
278 
279         @param _quickConverter  address of a bancor quick converter contract
280     */
281     function setQuickConverter(IBancorQuickConverter _quickConverter)
282         public
283         ownerOnly
284         validAddress(_quickConverter)
285         notThis(_quickConverter)
286     {
287         quickConverter = _quickConverter;
288     }
289 }