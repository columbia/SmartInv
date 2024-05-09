1 pragma solidity ^0.4.18;
2 
3 /*
4     Utilities & Common Modifiers
5 */
6 contract Utils {
7     /**
8         constructor
9     */
10     function Utils() public{
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
41     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
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
55     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
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
68     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
69         uint256 z = _x * _y;
70         assert(_x == 0 || z / _x == _y);
71         return z;
72     }
73 }
74 
75 /*
76     ERC20 Standard Token interface
77 */
78 contract IERC20Token {
79     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
80     function name() public pure returns (string) {}
81     function symbol() public pure returns (string) {}
82     function decimals() public pure returns (uint8) {}
83     function totalSupply() public pure returns (uint256) {}
84     function balanceOf(address _owner) public pure returns (uint256) { _owner; }
85     function allowance(address _owner, address _spender) public pure returns (uint256) { _owner; _spender; }
86 
87     function transfer(address _to, uint256 _value) public returns (bool success);
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
89     function approve(address _spender, uint256 _value) public returns (bool success);
90 }
91 
92 /*
93     Owned contract interface
94 */
95 contract IOwned {
96     // this function isn't abstract since the compiler emits automatically generated getter functions as external
97     function owner() public pure returns (address) {}
98 
99     function transferOwnership(address _newOwner) public;
100     function acceptOwnership() public;
101 }
102 
103 /*
104     Provides support and utilities for contract ownership
105 */
106 contract Owned is IOwned {
107     address public owner;
108     address public newOwner;
109 
110     event OwnerUpdate(address _prevOwner, address _newOwner);
111 
112     /**
113         @dev constructor
114     */
115     function Owned() public{
116         owner = msg.sender;
117     }
118 
119     // allows execution by the owner only
120     modifier ownerOnly {
121         assert(msg.sender == owner);
122         _;
123     }
124 
125     /**
126         @dev allows transferring the contract ownership
127         the new owner still needs to accept the transfer
128         can only be called by the contract owner
129 
130         @param _newOwner    new contract owner
131     */
132     function transferOwnership(address _newOwner) public ownerOnly {
133         require(_newOwner != owner);
134         newOwner = _newOwner;
135     }
136 
137     /**
138         @dev used by a new owner to accept an ownership transfer
139     */
140     function acceptOwnership() public {
141         require(msg.sender == newOwner);
142         emit OwnerUpdate(owner, newOwner);
143         owner = newOwner;
144         newOwner = 0x0;
145     }
146 }
147 
148 /*
149     Token Holder interface
150 */
151 contract ITokenHolder is IOwned {
152     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
153 }
154 
155 /*
156     We consider every contract to be a 'token holder' since it's currently not possible
157     for a contract to deny receiving tokens.
158 
159     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
160     the owner to send tokens that were sent to the contract by mistake back to their sender.
161 */
162 contract TokenHolder is ITokenHolder, Owned, Utils {
163     /**
164         @dev constructor
165     */
166     function TokenHolder() public{
167     }
168 
169     /**
170         @dev withdraws tokens held by the contract and sends them to an account
171         can only be called by the owner
172 
173         @param _token   ERC20 token contract address
174         @param _to      account to receive the new amount
175         @param _amount  amount to withdraw
176     */
177     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
178         public
179         ownerOnly
180         validAddress(_token)
181         validAddress(_to)
182         notThis(_to)
183     {
184         assert(_token.transfer(_to, _amount));
185     }
186 }
187 
188 
189 
190 /**
191     Ether tokenization contract
192 
193     'Owned' is specified here for readability reasons
194 */
195 contract GLBToken is IERC20Token, Utils, TokenHolder {
196 
197     string public standard = 'Token 0.1';
198     string public name = 'Columbus Fund';
199     string public symbol = 'GLB';
200     uint8 public decimals = 8;
201     uint256 public totalSupply = 1000000000000000;
202     mapping (address => uint256) public balanceOf;
203     mapping (address => mapping (address => uint256)) public allowance;
204 
205     event Transfer(address indexed _from, address indexed _to, uint256 _value);
206     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
207 
208 
209     /**
210         @dev send coins
211         throws on any error rather then return a false flag to minimize user errors
212 
213         @param _to      target address
214         @param _value   transfer amount
215 
216         @return true if the transfer was successful, false if it wasn't
217     */
218     function transfer(address _to, uint256 _value)
219         public
220         validAddress(_to)
221 		notThis(_to)
222         returns (bool success)
223     {
224         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
225         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
226         emit Transfer(msg.sender, _to, _value);
227         return true;
228     }
229 
230     /**
231         @dev an account/contract attempts to get the coins
232         throws on any error rather then return a false flag to minimize user errors
233 
234         @param _from    source address
235         @param _to      target address
236         @param _value   transfer amount
237 
238         @return true if the transfer was successful, false if it wasn't
239     */
240     function transferFrom(address _from, address _to, uint256 _value)
241         public
242         validAddress(_from)
243         validAddress(_to)
244 		notThis(_to)
245         returns (bool success)
246     {
247         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
248         balanceOf[_from] = safeSub(balanceOf[_from], _value);
249         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
250         emit Transfer(_from, _to, _value);
251         return true;
252     }
253 
254     /**
255         @dev allow another account/contract to spend some tokens on your behalf
256         throws on any error rather then return a false flag to minimize user errors
257 
258         also, to minimize the risk of the approve/transferFrom attack vector
259         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
260         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
261 
262         @param _spender approved address
263         @param _value   allowance amount
264 
265         @return true if the approval was successful, false if it wasn't
266     */
267     function approve(address _spender, uint256 _value)
268         public
269         validAddress(_spender)
270         returns (bool success)
271     {
272         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
273         require(_value == 0 || allowance[msg.sender][_spender] == 0);
274 
275         allowance[msg.sender][_spender] = _value;
276         emit Approval(msg.sender, _spender, _value);
277         return true;
278     }
279 
280 
281 }