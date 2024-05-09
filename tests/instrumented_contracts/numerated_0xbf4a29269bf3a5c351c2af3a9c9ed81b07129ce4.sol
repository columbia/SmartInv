1 pragma solidity ^0.4.15;
2 
3 /*
4     ERC20 Standard Token interface
5 */
6 contract IERC20Token {
7     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
8     function name() public constant returns (string) { name; }
9     function symbol() public constant returns (string) { symbol; }
10     function decimals() public constant returns (uint8) { decimals; }
11     function totalSupply() public constant returns (uint256) { totalSupply; }
12     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
13     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
14 
15     function transfer(address _to, uint256 _value) public returns (bool success);
16     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
17     function approve(address _spender, uint256 _value) public returns (bool success);
18 }
19 
20 /*
21     Utilities & Common Modifiers
22 */
23 contract Utils {
24     /**
25         constructor
26     */
27     function Utils() {
28     }
29 
30     // validates an address - currently only checks that it isn't null
31     modifier validAddress(address _address) {
32         require(_address != 0x0);
33         _;
34     }
35 
36     // verifies that the address is different than this contract address
37     modifier notThis(address _address) {
38         require(_address != address(this));
39         _;
40     }
41 
42     // Overflow protected math functions
43 
44     /**
45         @dev returns the sum of _x and _y, asserts if the calculation overflows
46 
47         @param _x   value 1
48         @param _y   value 2
49 
50         @return sum
51     */
52     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
53         uint256 z = _x + _y;
54         assert(z >= _x);
55         return z;
56     }
57 
58     /**
59         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
60 
61         @param _x   minuend
62         @param _y   subtrahend
63 
64         @return difference
65     */
66     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
67         assert(_x >= _y);
68         return _x - _y;
69     }
70 
71     /**
72         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
73 
74         @param _x   factor 1
75         @param _y   factor 2
76 
77         @return product
78     */
79     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
80         uint256 z = _x * _y;
81         assert(_x == 0 || z / _x == _y);
82         return z;
83     }
84 }
85 
86 /*
87     Owned contract interface
88 */
89 contract IOwned {
90     // this function isn't abstract since the compiler emits automatically generated getter functions as external
91     function owner() public constant returns (address) { owner; }
92 
93     function transferOwnership(address _newOwner) public;
94     function acceptOwnership() public;
95 }
96 
97 /*
98     Provides support and utilities for contract ownership
99 */
100 contract Owned is IOwned {
101     address public owner;
102     address public newOwner;
103 
104     event OwnerUpdate(address _prevOwner, address _newOwner);
105 
106     /**
107         @dev constructor
108     */
109     function Owned() {
110         owner = msg.sender;
111     }
112 
113     // allows execution by the owner only
114     modifier ownerOnly {
115         assert(msg.sender == owner);
116         _;
117     }
118 
119     /**
120         @dev allows transferring the contract ownership
121         the new owner still needs to accept the transfer
122         can only be called by the contract owner
123 
124         @param _newOwner    new contract owner
125     */
126     function transferOwnership(address _newOwner) public ownerOnly {
127         require(_newOwner != owner);
128         newOwner = _newOwner;
129     }
130 
131     /**
132         @dev used by a new owner to accept an ownership transfer
133     */
134     function acceptOwnership() public {
135         require(msg.sender == newOwner);
136         OwnerUpdate(owner, newOwner);
137         owner = newOwner;
138         newOwner = 0x0;
139     }
140 }
141 
142 /*
143     Token Holder interface
144 */
145 contract ITokenHolder is IOwned {
146     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
147 }
148 
149 /*
150     We consider every contract to be a 'token holder' since it's currently not possible
151     for a contract to deny receiving tokens.
152 
153     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
154     the owner to send tokens that were sent to the contract by mistake back to their sender.
155 */
156 contract TokenHolder is ITokenHolder, Owned, Utils {
157     /**
158         @dev constructor
159     */
160     function TokenHolder() {
161     }
162 
163     /**
164         @dev withdraws tokens held by the contract and sends them to an account
165         can only be called by the owner
166 
167         @param _token   ERC20 token contract address
168         @param _to      account to receive the new amount
169         @param _amount  amount to withdraw
170     */
171     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
172         public
173         ownerOnly
174         validAddress(_token)
175         validAddress(_to)
176         notThis(_to)
177     {
178         assert(_token.transfer(_to, _amount));
179     }
180 }
181 
182 /**
183     ERC20 Standard Token implementation
184 */
185 contract ERC20Token is IERC20Token, Utils {
186     string public standard = "Token 0.1";
187     string public name = "";
188     string public symbol = "";
189     uint8 public decimals = 0;
190     uint256 public totalSupply = 0;
191     mapping (address => uint256) public balanceOf;
192     mapping (address => mapping (address => uint256)) public allowance;
193 
194     event Transfer(address indexed _from, address indexed _to, uint256 _value);
195     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
196 
197     /**
198         @dev constructor
199 
200         @param _name        token name
201         @param _symbol      token symbol
202         @param _decimals    decimal points, for display purposes
203     */
204     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
205         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
206 
207         name = _name;
208         symbol = _symbol;
209         decimals = _decimals;
210     }
211 
212     /**
213         @dev send coins
214         throws on any error rather then return a false flag to minimize user errors
215 
216         @param _to      target address
217         @param _value   transfer amount
218 
219         @return true if the transfer was successful, false if it wasn't
220     */
221     function transfer(address _to, uint256 _value)
222         public
223         validAddress(_to)
224         returns (bool success)
225     {
226         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
227         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
228         Transfer(msg.sender, _to, _value);
229         return true;
230     }
231 
232     /**
233         @dev an account/contract attempts to get the coins
234         throws on any error rather then return a false flag to minimize user errors
235 
236         @param _from    source address
237         @param _to      target address
238         @param _value   transfer amount
239 
240         @return true if the transfer was successful, false if it wasn't
241     */
242     function transferFrom(address _from, address _to, uint256 _value)
243         public
244         validAddress(_from)
245         validAddress(_to)
246         returns (bool success)
247     {
248         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
249         balanceOf[_from] = safeSub(balanceOf[_from], _value);
250         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
251         Transfer(_from, _to, _value);
252         return true;
253     }
254 
255     /**
256         @dev allow another account/contract to spend some tokens on your behalf
257         throws on any error rather then return a false flag to minimize user errors
258 
259         also, to minimize the risk of the approve/transferFrom attack vector
260         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
261         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
262 
263         @param _spender approved address
264         @param _value   allowance amount
265 
266         @return true if the approval was successful, false if it wasn't
267     */
268     function approve(address _spender, uint256 _value)
269         public
270         validAddress(_spender)
271         returns (bool success)
272     {
273         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
274         require(_value == 0 || allowance[msg.sender][_spender] == 0);
275 
276         allowance[msg.sender][_spender] = _value;
277         Approval(msg.sender, _spender, _value);
278         return true;
279     }
280 }
281 
282 contract Token is ERC20Token, TokenHolder {
283 
284     function Token(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply, address _tokenHolder) ERC20Token(_name, _symbol, _decimals)
285     {
286         totalSupply = _totalSupply * 1 ether;
287         
288         if (_tokenHolder == 0x0) {
289             _tokenHolder = msg.sender;
290         }
291         owner = _tokenHolder;
292         balanceOf[_tokenHolder] = _totalSupply * 1 ether;
293     }
294 
295     function deliverPresaleTokens(address[] _batchOfAddresses, uint256[] _amountOfTokens) public ownerOnly returns (bool success) {
296         for (uint256 i = 0; i < _batchOfAddresses.length; i++) {
297             transfer(_batchOfAddresses[i], _amountOfTokens[i]);            
298         }
299         return true;
300     }
301 }