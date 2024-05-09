1 pragma solidity 0.4.19;
2 
3 contract BaseContract {
4     modifier greaterThanZero(uint256 _amount) {
5         require(_amount > 0);
6 
7         _;
8     }
9 
10     modifier isZero(uint256 _amount) {
11         require(_amount == 0);
12 
13         _;
14     }
15 
16     modifier nonZero(uint256 _amount) {
17         require(_amount != 0);
18 
19         _;
20     }
21 
22     modifier notThis(address _address) {
23         require(_address != address(this));
24 
25         _;
26     }
27 
28     modifier onlyIf(bool condition) {
29         require(condition);
30 
31         _;
32     }
33 
34     modifier validIndex(uint256 arrayLength, uint256 index) {
35         requireValidIndex(arrayLength, index);
36 
37         _;
38     }
39 
40     modifier validAddress(address _address) {
41         require(_address != 0x0);
42 
43         _;
44     }
45 
46     modifier validString(string value) {
47         require(bytes(value).length > 0);
48 
49         _;
50     }
51 
52     // mitigate short address attack
53     // http://vessenes.com/the-erc20-short-address-attack-explained/
54     modifier validParamData(uint256 numParams) {
55         uint256 expectedDataLength = (numParams * 32) + 4;
56         assert(msg.data.length >= expectedDataLength);
57 
58         _;
59     }
60 
61     function requireValidIndex(uint256 arrayLength, uint256 index)
62         internal
63         pure
64     {
65         require(index >= 0 && index < arrayLength);
66     }
67 }
68 
69 contract Owned is BaseContract {
70     address public owner;
71     address public newOwner;
72 
73     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
74 
75     function Owned()
76         internal
77     {
78         owner = msg.sender;
79     }
80 
81     modifier onlyOwner {
82         require(msg.sender == owner);
83 
84         _;
85     }
86 
87     /// @dev allows transferring the contract ownership
88     /// the new owner still needs to accept the transfer
89     /// can only be called by the contract owner
90     /// @param _newOwner    new contract owner
91     function transferOwnership(address _newOwner)
92         public
93         validParamData(1)
94         onlyOwner
95         onlyIf(_newOwner != owner)
96     {
97         newOwner = _newOwner;
98     }
99 
100     /// @dev used by a new owner to accept an ownership transfer
101     function acceptOwnership()
102         public
103         onlyIf(msg.sender == newOwner)
104     {
105         OwnerUpdate(owner, newOwner);
106         owner = newOwner;
107         newOwner = 0x0;
108     }
109 }
110 
111 
112 contract IToken { 
113     function totalSupply()
114         public view
115         returns (uint256);
116 
117     function balanceOf(address _owner)
118         public view
119         returns (uint256);
120 
121     function transfer(address _to, uint256 _value)
122         public
123         returns (bool);
124 
125     function transferFrom(address _from, address _to, uint256 _value)
126         public
127         returns (bool);
128 
129     function approve(address _spender, uint256 _value)
130         public
131         returns (bool);
132 
133     function allowance(address _owner, address _spender)
134         public view
135         returns (uint256);
136 }
137 
138 
139 
140 
141 
142 
143 
144 
145 contract TokenRetriever is Owned {
146     function TokenRetriever()
147         internal
148     {
149     }
150 
151     /// @dev Failsafe mechanism - Allows owner to retrieve tokens from the contract
152     /// @param _token The address of ERC20 compatible token
153     function retrieveTokens(IToken _token)
154         public
155         onlyOwner
156     {
157         uint256 tokenBalance = _token.balanceOf(this);
158         if (tokenBalance > 0) {
159             _token.transfer(owner, tokenBalance);
160         }
161     }
162 }
163 
164 
165 
166 
167 
168 
169 /// @title Math operations with safety checks
170 library SafeMath {
171     function mul(uint256 a, uint256 b)
172         internal
173         pure
174         returns (uint256)
175     {
176         uint256 c = a * b;
177         require(a == 0 || c / a == b);
178         return c;
179     }
180 
181     function div(uint256 a, uint256 b)
182         internal
183         pure
184         returns (uint256)
185     {
186         require(b > 0); // Solidity automatically throws when dividing by 0
187         uint256 c = a / b;
188         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
189         return c;
190     }
191 
192     function sub(uint256 a, uint256 b)
193         internal
194         pure
195         returns (uint256)
196     {
197         require(b <= a);
198         return a - b;
199     }
200 
201     function add(uint256 a, uint256 b)
202         internal
203         pure
204         returns (uint256)
205     {
206         uint256 c = a + b;
207         require(c >= a);
208         return c;
209     }
210 
211     function min256(uint256 a, uint256 b)
212         internal
213         pure
214         returns (uint256)
215     {
216         return a < b ? a : b;
217     }
218 }
219 
220 
221 // solhint-disable no-simple-event-func-name
222 
223 // ERC20 Standard Token implementation
224 contract ERC20Token is BaseContract {
225     using SafeMath for uint256;
226 
227     string public name = "";
228     string public symbol = "";
229     uint8 public decimals = 0;
230     uint256 public totalSupply = 0;
231     mapping (address => uint256) public balanceOf;
232     mapping (address => mapping (address => uint256)) public allowance;
233 
234     event Transfer(address indexed _from, address indexed _to, uint256 _value);
235     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
236 
237     /// @dev constructor
238     /// @param _name        token name
239     /// @param _symbol      token symbol
240     /// @param _decimals    decimal points, for display purposes
241     function ERC20Token(string _name, string _symbol, uint8 _decimals)
242         internal
243         validString(_name)
244         validString(_symbol)
245     {
246         name = _name;
247         symbol = _symbol;
248         decimals = _decimals;
249     }
250 
251     /// @dev send coins
252     /// throws on any error rather then return a false flag to minimize user errors
253     /// @param _to      target address
254     /// @param _value   transfer amount
255     /// @return true if the transfer was successful, false if it wasn't
256     function transfer(address _to, uint256 _value)
257         public
258         validParamData(2)
259         validAddress(_to)
260         notThis(_to)
261         returns (bool success)
262     {
263         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
264         balanceOf[_to] = balanceOf[_to].add(_value);
265         Transfer(msg.sender, _to, _value);
266         return true;
267     }
268 
269     /// @dev an account/contract attempts to get the coins
270     /// throws on any error rather then return a false flag to minimize user errors
271     /// @param _from    source address
272     /// @param _to      target address
273     /// @param _value   transfer amount
274     /// @return true if the transfer was successful, false if it wasn't
275     function transferFrom(address _from, address _to, uint256 _value)
276         public
277         validParamData(3)
278         validAddress(_from)
279         validAddress(_to)
280         notThis(_to)
281         returns (bool success)
282     {
283         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
284         balanceOf[_from] = balanceOf[_from].sub(_value);
285         balanceOf[_to] = balanceOf[_to].add(_value);
286         Transfer(_from, _to, _value);
287         return true;
288     }
289 
290     /// @dev allow another account/contract to spend some tokens on your behalf
291     /// throws on any error rather then return a false flag to minimize user errors
292     /// also, to minimize the risk of the approve/transferFrom attack vector
293     /// (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/)
294     /// approve has to be called twice in 2 separate transactions
295     /// once to change the allowance to 0 and secondly to change it to the new allowance value
296     /// @param _spender approved address
297     /// @param _value   allowance amount
298     /// @return true if the approval was successful, false if it wasn't
299     function approve(address _spender, uint256 _value)
300         public
301         validParamData(2)
302         validAddress(_spender)
303         onlyIf(_value == 0 || allowance[msg.sender][_spender] == 0)
304         returns (bool success)
305     {
306         uint256 currentAllowance = allowance[msg.sender][_spender];
307 
308         return changeApprovalCore(_spender, currentAllowance, _value);
309     }
310 
311     /// @dev Allow another account/contract to spend some tokens on your behalf
312     /// Note: This method is protected against the approve/transferFrom attack vector
313     /// (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/)
314     /// because the previous value and new value must both be specified.
315     function changeApproval(address _spender, uint256 _previousValue, uint256 _value)
316         public
317         validParamData(3)
318         validAddress(_spender)
319         returns (bool success)
320     {
321         return changeApprovalCore(_spender, _previousValue, _value);
322     }
323 
324     function changeApprovalCore(address _spender, uint256 _previousValue, uint256 _value)
325         private
326         onlyIf(allowance[msg.sender][_spender] == _previousValue)
327         returns (bool success)
328     {
329         allowance[msg.sender][_spender] = _value;
330         Approval(msg.sender, _spender, _value);
331 
332         return true;
333     }
334 }
335 
336 
337 
338 
339 
340 
341 contract XBPToken is BaseContract, Owned, TokenRetriever, ERC20Token {
342     using SafeMath for uint256;
343 
344     bool public issuanceEnabled = true;
345 
346     event Issuance(uint256 _amount);
347 
348     function XBPToken()
349         public
350         ERC20Token("BlitzPredict", "XBP", 18)
351     {
352     }
353 
354     /// @dev disables/enables token issuance
355     /// can only be called by the contract owner
356     function disableIssuance()
357         public
358         onlyOwner
359         onlyIf(issuanceEnabled)
360     {
361         issuanceEnabled = false;
362     }
363 
364     /// @dev increases the token supply and sends the new tokens to an account
365     /// can only be called by the contract owner
366     /// @param _to         account to receive the new amount
367     /// @param _amount     amount to increase the supply by
368     function issue(address _to, uint256 _amount)
369         public
370         onlyOwner
371         validParamData(2)
372         validAddress(_to)
373         onlyIf(issuanceEnabled)
374         notThis(_to)
375     {
376         totalSupply = totalSupply.add(_amount);
377         balanceOf[_to] = balanceOf[_to].add(_amount);
378 
379         Issuance(_amount);
380         Transfer(this, _to, _amount);
381     }
382 }