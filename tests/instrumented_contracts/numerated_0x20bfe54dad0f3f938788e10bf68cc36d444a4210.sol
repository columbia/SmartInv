1 pragma solidity >=0.5.0 <0.6.0;
2 
3 
4 library Strings {
5   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
6   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
7       bytes memory _ba = bytes(_a);
8       bytes memory _bb = bytes(_b);
9       bytes memory _bc = bytes(_c);
10       bytes memory _bd = bytes(_d);
11       bytes memory _be = bytes(_e);
12       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
13       bytes memory babcde = bytes(abcde);
14       uint k = 0; 
15       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
16       for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
17       for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
18       for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
19       for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
20       return string(babcde);
21     }
22 
23     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
24         return strConcat(_a, _b, _c, _d, "");
25     }
26 
27     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
28         return strConcat(_a, _b, _c, "", "");
29     }
30 
31     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
32         return strConcat(_a, _b, "", "", "");
33     }
34 
35     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
36         if (_i == 0) {
37             return "0";
38         }
39         uint j = _i;
40         uint len;
41         while (j != 0) {
42             len++;
43             j /= 10;
44         }
45         bytes memory bstr = new bytes(len);
46         uint k = len - 1;
47         while (_i != 0) {
48             bstr[k--] = byte(uint8(48 + _i % 10));
49             _i /= 10;
50         }
51         return string(bstr);
52     }
53 }
54 
55 
56 
57 /**
58  * @title SafeMath
59  * @dev Unsigned math operations with safety checks that revert on error
60  */
61 library SafeMath {
62     /**
63     * @dev Multiplies two unsigned integers, reverts on overflow.
64     */
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
67         // benefit is lost if 'b' is also tested.
68         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
69         if (a == 0) {
70             return 0;
71         }
72 
73         uint256 c = a * b;
74         require(c / a == b);
75 
76         return c;
77     }
78 
79     /**
80     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
81     */
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Solidity only automatically asserts when dividing by 0
84         require(b > 0);
85         uint256 c = a / b;
86         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87 
88         return c;
89     }
90 
91     /**
92     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
93     */
94     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95         require(b <= a);
96         uint256 c = a - b;
97 
98         return c;
99     }
100 
101     /**
102     * @dev Adds two unsigned integers, reverts on overflow.
103     */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a);
107 
108         return c;
109     }
110 
111     /**
112     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
113     * reverts when dividing by zero.
114     */
115     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
116         require(b != 0);
117         return a % b;
118     }
119 }
120 
121 
122 
123 /**
124  * Utility library of inline functions on addresses
125  */
126 library Address {
127     /**
128      * Returns whether the target address is a contract
129      * @dev This function will return false if invoked during the constructor of a contract,
130      * as the code is not actually created until after the constructor finishes.
131      * @param account address of the account to check
132      * @return whether the target address is a contract
133      */
134     function isContract(address account) internal view returns (bool) {
135         uint256 size;
136         // XXX Currently there is no better way to check if there is a contract in an address
137         // than to check the size of the code at that address.
138         // See https://ethereum.stackexchange.com/a/14016/36603
139         // for more details about how this works.
140         // TODO Check this again before the Serenity release, because all addresses will be
141         // contracts then.
142         // solhint-disable-next-line no-inline-assembly
143         assembly { size := extcodesize(account) }
144         return size > 0;
145     }
146 
147     function toString(address _addr) internal pure returns(string memory) {
148         bytes32 value = bytes32(uint256(_addr));
149         bytes memory alphabet = "0123456789abcdef";
150 
151         bytes memory str = new bytes(51);
152         str[0] = '0';
153         str[1] = 'x';
154         for (uint i = 0; i < 20; i++) {
155             str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];
156             str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];
157         }
158         return string(str);
159     }
160 }
161 
162 
163 
164 contract AccessERC20x {
165     address private _ceo;
166     address private _coo;
167     address private _proxy;
168 
169     constructor () internal {
170         _ceo = msg.sender;
171         _coo = msg.sender;
172         _proxy = msg.sender;
173     }
174 
175     function ceoAddress() public view returns (address) {
176         return _ceo;
177     }
178 
179     function cooAddress() public view returns (address) {
180         return _coo;
181     }
182 
183     function proxyAddress() public view returns (address) {
184         return _proxy;
185     }
186 
187     modifier onlyCEO() {
188         require(msg.sender == _ceo);
189         _;
190     }
191 
192     modifier onlyCLevel() {
193         require(msg.sender == _ceo || msg.sender == _coo);
194         _;
195     }
196 
197     modifier onlyProxy() {
198         require(msg.sender == _ceo || msg.sender == _coo || msg.sender == _proxy);
199         _;
200     }
201 
202     function setCEO(address _newCEO) external onlyCEO {
203         require(_newCEO != address(0));
204 
205         _ceo = _newCEO;
206     }
207 
208     function setCOO(address _newCOO) external onlyCLevel {
209         require(_newCOO != address(0));
210 
211         _coo = _newCOO;
212     }
213 
214     function setProxy(address _newProxy) external onlyCLevel {
215         require(_newProxy != address(0));
216 
217         _proxy = _newProxy;
218     }
219 }
220 
221 
222 
223 interface IERC20x {
224     function totalSupply() external view returns (uint256);
225 
226     function balanceOf(address owner) external view returns (uint256);
227 
228     function tokenURI(address owner, uint256 index) external view returns (string memory);
229 
230     function approve(uint256 value) external returns (bool);
231 
232     function allowance(address owner) external view returns (uint256);
233 
234     function transferFrom(address from, address to, uint256 value) external returns (bool);
235 
236     function mintToken(address owner, uint256 value) external returns (bool);
237 
238     function burnToken(address owner, uint256 value) external returns (bool);
239 
240     event Transfer(address indexed from, address indexed to, uint256 value);
241 
242     event Approval(address indexed owner, uint256 value);
243 }
244 
245 
246 
247 contract ERC20x is IERC20x, AccessERC20x {
248     using SafeMath for uint256;
249 
250     mapping (address => uint256) private _balances;
251 
252     mapping (address => uint256) private _allowed;
253 
254     uint256 private _totalSupply;
255 	string internal _baseuri;
256 
257     /**
258     * @dev Transfer token for a specified addresses
259     * @param from The address to transfer from.
260     * @param to The address to transfer to.
261     * @param value The amount to be transferred.
262     */
263     function _transfer(address from, address to, uint256 value) internal {
264         require(to != address(0));
265 
266         _balances[from] = _balances[from].sub(value);
267         _balances[to] = _balances[to].add(value);
268         emit Transfer(from, to, value);
269     }
270 
271     /**
272      * @dev Internal function that mints an amount of the token and assigns it to
273      * an account. This encapsulates the modification of balances such that the
274      * proper events are emitted.
275      * @param account The account that will receive the created tokens.
276      * @param value The amount that will be created.
277      */
278     function _mint(address account, uint256 value) internal {
279         require(account != address(0));
280 
281         _totalSupply = _totalSupply.add(value);
282         _balances[account] = _balances[account].add(value);
283         emit Transfer(address(0), account, value);
284     }
285 
286     /**
287      * @dev Internal function that burns an amount of the token of a given
288      * account.
289      * @param account The account whose tokens will be burnt.
290      * @param value The amount that will be burnt.
291      */
292     function _burn(address account, uint256 value) internal {
293         require(account != address(0));
294 		require(_balances[account] >= value);
295 
296         _totalSupply = _totalSupply.sub(value);
297         _balances[account] = _balances[account].sub(value);
298         emit Transfer(account, address(0), value);
299     }
300 
301     /**
302      * @dev Internal function that burns an amount of the token of a given
303      * account, deducting from the sender's allowance for said account. Uses the
304      * internal burn function.
305      * Emits an Approval event (reflecting the reduced allowance).
306      * @param account The account whose tokens will be burnt.
307      * @param value The amount that will be burnt.
308      */
309     function _burnFrom(address account, uint256 value) internal {
310         _allowed[account] = _allowed[account].sub(value);
311         _burn(account, value);
312         emit Approval(account, _allowed[account]);
313     }
314 
315 
316     /**
317     * @dev Total number of tokens in existence
318     */
319     function totalSupply() public view returns (uint256) {
320         return _totalSupply;
321     }
322 
323     /**
324     * @dev Gets the balance of the specified address.
325     * @param owner The address to query the balance of.
326     * @return An uint256 representing the amount owned by the passed address.
327     */
328     function balanceOf(address owner) public view returns (uint256) {
329         return _balances[owner];
330     }
331 
332     function baseTokenURI() public view returns (string memory) {
333         return _baseuri;
334     }
335 
336     function tokenURI(address owner, uint256 index) public view returns (string memory) {
337 	    string memory p1;
338 	    string memory p2;
339 
340 		p1 = Strings.strConcat("?wallet=", Address.toString(owner));
341 		p2 = Strings.strConcat("&index=",  Strings.uint2str(index));
342 
343         return Strings.strConcat(baseTokenURI(), Strings.strConcat(p1, p2));
344     }
345 
346     /**
347      * @dev Approve to spend the specified amount of tokens on behalf of msg.sender.
348      * @param value The amount of tokens to be spent.
349      */
350     function approve(uint256 value) public returns (bool) {
351 		require(value > 0);
352 		require(_balances[msg.sender] >= _allowed[msg.sender] + value);
353 
354         _allowed[msg.sender] = _allowed[msg.sender].add (value);
355         emit Approval(msg.sender, value);
356         return true;
357     }
358 
359     /**
360      * @dev Function to check the amount of tokens that an owner allowed to a proxy.
361      * @param owner address The address which owns the funds.
362      * @return A uint256 specifying the amount of tokens still available for the proxy.
363      */
364     function allowance(address owner) public view returns (uint256) {
365         return _allowed[owner];
366     }
367 
368     /**
369      * @dev Transfer tokens from one address to another.
370      * Note that while this function emits an Approval event, this is not required as per the specification,
371      * and other compliant implementations may not emit the event.
372      * @param from address The address which you want to send tokens from
373      * @param to address The address which you want to transfer to
374      * @param value uint256 the amount of tokens to be transferred
375      */
376     function transferFrom(address from, address to, uint256 value) public onlyProxy returns (bool) {
377 		require(value > 0);
378 
379         _allowed[from] = _allowed[from].sub(value);
380         _transfer(from, to, value);
381         emit Approval(from, _allowed[from]);
382         return true;
383     }
384 
385     function mintToken(address owner, uint256 value) public onlyProxy returns (bool) {
386 		require(value > 0);
387 
388         _mint(owner, value);
389         return true;
390     }
391 
392     function mintApprovedToken(address owner, uint256 value) public onlyProxy returns (bool) {
393 		require(value > 0);
394 
395         _mint(owner, value);
396 
397         _allowed[owner] = _allowed[owner].add (value);
398         emit Approval(owner, value);
399         return true;
400     }
401 
402     function burnToken(address owner, uint256 value) public onlyProxy returns (bool) {
403         _burnFrom(owner, value);
404         return true;
405     }
406 }
407 
408 
409 
410 contract MoonDiaToken is ERC20x {
411     string public name = "MoonDiaToken"; 
412     string public symbol = "DIA";
413     uint public decimals = 0;
414     uint public INITIAL_SUPPLY = 60000000;
415 
416     constructor() public {
417 	    _baseuri = "https://reg.diana.io/api/token";
418 
419         _mint(msg.sender, INITIAL_SUPPLY);
420     }
421 
422     function setBaseTokenURI(string memory _uri) public onlyCLevel {
423         _baseuri = _uri;
424     }
425 }