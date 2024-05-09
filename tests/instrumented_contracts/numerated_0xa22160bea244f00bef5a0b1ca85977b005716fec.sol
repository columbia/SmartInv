1 pragma solidity ^0.4.21;
2 
3 // File: deploy/contracts/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error.
8  * Note, the div and mul methods were removed as they are not currently needed
9  */
10 library SafeMath {
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         assert(b <= a);
13         return a - b;
14     }
15 
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         assert(c >= a);
19         return c;
20     }
21 }
22 
23 // File: deploy/contracts/ERC20.sol
24 
25 /**
26  * @title ERC20 interface
27  * @dev see https://github.com/ethereum/EIPs/issues/20
28  */
29 contract ERC20 {
30     uint256 public totalSupply;
31     string public name;
32     string public symbol;
33     uint8 public decimals;
34 
35     function balanceOf(address who) public view returns (uint256);
36     function transfer(address to, uint256 value) public returns (bool);
37     function allowance(address owner, address spender) public view returns (uint256);
38     function transferFrom(address from, address to, uint256 value) public returns (bool);
39     function approve(address spender, uint256 value) public returns (bool);
40 
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 // File: deploy/contracts/Stampable.sol
46 
47 contract Stampable is ERC20 {
48     using SafeMath for uint256;
49 
50     // A struct that represents a particular token balance
51     struct TokenBalance {
52         uint256 amount;
53         uint index;
54     }
55 
56     // A struct that represents a particular address balance
57     struct AddressBalance {
58         mapping (uint256 => TokenBalance) tokens;
59         uint256[] tokenIndex;
60     }
61 
62     // A mapping of address to balances
63     mapping (address => AddressBalance) balances;
64 
65     // The total number of tokens owned per address
66     mapping (address => uint256) ownershipCount;
67 
68     // Whitelist for addresses allowed to stamp tokens
69     mapping (address => bool) public stampingWhitelist;
70 
71     /**
72     * Modifier for only whitelisted addresses
73     */
74     modifier onlyStampingWhitelisted() {
75         require(stampingWhitelist[msg.sender]);
76         _;
77     }
78 
79     // Event for token stamping
80     event TokenStamp (address indexed from, uint256 tokenStamped, uint256 stamp, uint256 amt);
81 
82     /**
83     * @dev Function to stamp a token in the msg.sender's wallet
84     * @param _tokenToStamp uint256 The tokenId of theirs to stamp (0 for unstamped tokens)
85     * @param _stamp uint256 The new stamp to apply
86     * @param _amt uint256 The quantity of tokens to stamp
87     */
88     function stampToken (uint256 _tokenToStamp, uint256 _stamp, uint256 _amt)
89         onlyStampingWhitelisted
90         public returns (bool) {
91         require(_amt <= balances[msg.sender].tokens[_tokenToStamp].amount);
92 
93         // Subtract balance of 0th token ID _amt value.
94         removeToken(msg.sender, _tokenToStamp, _amt);
95 
96         // "Stamp" the token
97         addToken(msg.sender, _stamp, _amt);
98 
99         // Emit the stamping event
100         emit TokenStamp(msg.sender, _tokenToStamp, _stamp, _amt);
101 
102         return true;
103     }
104 
105     function addToken(address _owner, uint256 _token, uint256 _amount) internal {
106         // If they don't yet have any, assign this token an index
107         if (balances[_owner].tokens[_token].amount == 0) {
108             balances[_owner].tokens[_token].index = balances[_owner].tokenIndex.push(_token) - 1;
109         }
110 
111         // Increase their balance of said token
112         balances[_owner].tokens[_token].amount = balances[_owner].tokens[_token].amount.add(_amount);
113 
114         // Increase their ownership count
115         ownershipCount[_owner] = ownershipCount[_owner].add(_amount);
116     }
117 
118     function removeToken(address _owner, uint256 _token, uint256 _amount) internal {
119         // Decrease their ownership count
120         ownershipCount[_owner] = ownershipCount[_owner].sub(_amount);
121 
122         // Decrease their balance of the token
123         balances[_owner].tokens[_token].amount = balances[_owner].tokens[_token].amount.sub(_amount);
124 
125         // If they don't have any left, remove it
126         if (balances[_owner].tokens[_token].amount == 0) {
127             uint index = balances[_owner].tokens[_token].index;
128             uint256 lastCoin = balances[_owner].tokenIndex[balances[_owner].tokenIndex.length - 1];
129             balances[_owner].tokenIndex[index] = lastCoin;
130             balances[_owner].tokens[lastCoin].index = index;
131             balances[_owner].tokenIndex.length--;
132             // Make sure the user's token is removed
133             delete balances[_owner].tokens[_token];
134         }
135     }
136 }
137 
138 // File: deploy/contracts/FanCoin.sol
139 
140 contract FanCoin is Stampable {
141     using SafeMath for uint256;
142 
143     // The owner of this token
144     address public owner;
145 
146     // Keeps track of allowances for particular address. - ERC20 Method
147     mapping (address => mapping (address => uint256)) public allowed;
148 
149     event TokenTransfer (address indexed from, address indexed to, uint256 tokenId, uint256 value);
150     event MintTransfer  (address indexed from, address indexed to, uint256 originalTokenId, uint256 tokenId, uint256 value);
151 
152     modifier onlyOwner {
153         require(msg.sender == owner);
154         _;
155     }
156 
157     /**
158     * The constructor for the FanCoin token
159     */
160     function FanCoin() public {
161         owner = 0x7DDf115B8eEf3058944A3373025FB507efFAD012;
162         name = "FanChain";
163         symbol = "FANZ";
164         decimals = 4;
165 
166         // Total supply is one billion tokens
167         totalSupply = 6e8 * uint256(10) ** decimals;
168 
169         // Add the owner to the stamping whitelist
170         stampingWhitelist[owner] = true;
171 
172         // Initially give all of the tokens to the owner
173         addToken(owner, 0, totalSupply);
174     }
175 
176     /** ERC 20
177     * @dev Retrieves the balance of a specified address
178     * @param _owner address The address to query the balance of.
179     * @return A uint256 representing the amount owned by the _owner
180     */
181     function balanceOf(address _owner) public view returns (uint256 balance) {
182         return ownershipCount[_owner];
183     }
184 
185     /**
186     * @dev Retrieves the balance of a specified address for a specific token
187     * @param _owner address The address to query the balance of
188     * @param _tokenId uint256 The token being queried
189     * @return A uint256 representing the amount owned by the _owner
190     */
191     function balanceOfToken(address _owner, uint256 _tokenId) public view returns (uint256 balance) {
192         return balances[_owner].tokens[_tokenId].amount;
193     }
194 
195     /**
196     * @dev Returns all of the tokens owned by a particular address
197     * @param _owner address The address to query
198     * @return A uint256 array representing the tokens owned
199     */
200     function tokensOwned(address _owner) public view returns (uint256[] tokens) {
201         return balances[_owner].tokenIndex;
202     }
203 
204     /** ERC 20
205     * @dev Transfers tokens to a specific address
206     * @param _to address The address to transfer tokens to
207     * @param _value unit256 The amount to be transferred
208     */
209     function transfer(address _to, uint256 _value) public returns (bool) {
210         require(_to != address(0));
211         require(_value <= totalSupply);
212         require(_value <= ownershipCount[msg.sender]);
213 
214         // Cast the value as the ERC20 standard uses uint256
215         uint256 _tokensToTransfer = uint256(_value);
216 
217         // Do the transfer
218         require(transferAny(msg.sender, _to, _tokensToTransfer));
219 
220         // Notify that a transfer has occurred
221         emit Transfer(msg.sender, _to, _value);
222 
223         return true;
224     }
225 
226     /**
227     * @dev Transfer a specific kind of token to another address
228     * @param _to address The address to transfer to
229     * @param _tokenId address The type of token to transfer
230     * @param _value uint256 The number of tokens to transfer
231     */
232     function transferToken(address _to, uint256 _tokenId, uint256 _value) public returns (bool) {
233         require(_to != address(0));
234         require(_value <= balances[msg.sender].tokens[_tokenId].amount);
235 
236         // Do the transfer
237         internalTransfer(msg.sender, _to, _tokenId, _value);
238 
239         // Notify that a transfer happened
240         emit TokenTransfer(msg.sender, _to, _tokenId, _value);
241         emit Transfer(msg.sender, _to, _value);
242 
243         return true;
244     }
245 
246     /**
247     * @dev Transfer a list of token kinds and values to another address
248     * @param _to address The address to transfer to
249     * @param _tokenIds uint256[] The list of tokens to transfer
250     * @param _values uint256[] The list of amounts to transfer
251     */
252     function transferTokens(address _to, uint256[] _tokenIds, uint256[] _values) public returns (bool) {
253         require(_to != address(0));
254         require(_tokenIds.length == _values.length);
255         require(_tokenIds.length < 100); // Arbitrary limit
256 
257         // Do verification first
258         for (uint i = 0; i < _tokenIds.length; i++) {
259             require(_values[i] > 0);
260             require(_values[i] <= balances[msg.sender].tokens[_tokenIds[i]].amount);
261         }
262 
263         // Transfer every type of token specified
264         for (i = 0; i < _tokenIds.length; i++) {
265             require(internalTransfer(msg.sender, _to, _tokenIds[i], _values[i]));
266             emit TokenTransfer(msg.sender, _to, _tokenIds[i], _values[i]);
267             emit Transfer(msg.sender, _to, _values[i]);
268         }
269 
270         return true;
271     }
272 
273     /**
274     * @dev Transfers the given number of tokens regardless of how they are stamped
275     * @param _from address The address to transfer from
276     * @param _to address The address to transfer to
277     * @param _value uint256 The number of tokens to send
278     */
279     function transferAny(address _from, address _to, uint256 _value) private returns (bool) {
280         // Iterate through all of the tokens owned, and transfer either the
281         // current balance of that token, or the remaining total amount to be
282         // transferred (`_value`), whichever is smaller. Because tokens are completely removed
283         // as their balances reach 0, we just run the loop until we have transferred all
284         // of the tokens we need to
285         uint256 _tokensToTransfer = _value;
286         while (_tokensToTransfer > 0) {
287             uint256 tokenId = balances[_from].tokenIndex[0];
288             uint256 tokenBalance = balances[_from].tokens[tokenId].amount;
289 
290             if (tokenBalance >= _tokensToTransfer) {
291                 require(internalTransfer(_from, _to, tokenId, _tokensToTransfer));
292                 _tokensToTransfer = 0;
293             } else {
294                 _tokensToTransfer = _tokensToTransfer - tokenBalance;
295                 require(internalTransfer(_from, _to, tokenId, tokenBalance));
296             }
297         }
298 
299         return true;
300     }
301 
302     /**
303     * Internal function for transferring a specific type of token
304     */
305     function internalTransfer(address _from, address _to, uint256 _tokenId, uint256 _value) private returns (bool) {
306         // Decrease the amount being sent first
307         removeToken(_from, _tokenId, _value);
308 
309         // Increase receivers token balances
310         addToken(_to, _tokenId, _value);
311 
312         return true;
313     }
314 
315     /** ERC 20
316     * @dev Transfer on behalf of another address
317     * @param _from address The address to send tokens from
318     * @param _to address The address to send tokens to
319     * @param _value uint256 The amount of tokens to be transferred
320     */
321     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
322         require(_to != address(0));
323         require(_value <= ownershipCount[_from]);
324         require(_value <= allowed[_from][msg.sender]);
325 
326         // Get the uint256 version of value
327         uint256 _castValue = uint256(_value);
328 
329         // Decrease the spending limit
330         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
331 
332         // Actually perform the transfer
333         require(transferAny(_from, _to, _castValue));
334 
335         // Notify that a transfer has occurred
336         emit Transfer(_from, _to, _value);
337 
338         return true;
339     }
340 
341     /**
342     * @dev Transfer and stamp tokens from a mint in one step
343     * @param _to address To send the tokens to
344     * @param _tokenToStamp uint256 The token to stamp (0 is unstamped tokens)
345     * @param _stamp uint256 The new stamp to apply
346     * @param _amount uint256 The number of tokens to stamp and transfer
347     */
348     function mintTransfer(address _to, uint256 _tokenToStamp, uint256 _stamp, uint256 _amount) public
349         onlyStampingWhitelisted returns (bool) {
350         require(_to != address(0));
351         require(_amount <= balances[msg.sender].tokens[_tokenToStamp].amount);
352 
353         // Decrease the amount being sent first
354         removeToken(msg.sender, _tokenToStamp, _amount);
355 
356         // Increase receivers token balances
357         addToken(_to, _stamp, _amount);
358 
359         emit MintTransfer(msg.sender, _to, _tokenToStamp, _stamp, _amount);
360         emit Transfer(msg.sender, _to, _amount);
361 
362         return true;
363     }
364 
365     /**
366      * @dev Add an address to the whitelist
367      * @param _addr address The address to add
368      */
369     function addToWhitelist(address _addr) public
370         onlyOwner {
371         stampingWhitelist[_addr] = true;
372     }
373 
374     /**
375      * @dev Remove an address from the whitelist
376      * @param _addr address The address to remove
377      */
378     function removeFromWhitelist(address _addr) public
379         onlyOwner {
380         stampingWhitelist[_addr] = false;
381     }
382 
383     /** ERC 20
384     * @dev Approve sent address to spend the specified amount of tokens on
385     * behalf of msg.sender
386     *
387     * See https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
388     * for any potential security concerns
389     *
390     * @param _spender address The address that will spend funds
391     * @param _value uint256 The number of tokens they are allowed to spend
392     */
393     function approve(address _spender, uint256 _value) public returns (bool) {
394         require(allowed[msg.sender][_spender] == 0);
395 
396         allowed[msg.sender][_spender] = _value;
397         emit Approval(msg.sender, _spender, _value);
398         return true;
399     }
400 
401     /** ERC 20
402     * @dev Returns the amount a spender is allowed to spend for a particular
403     * address
404     * @param _owner address The address which owns the funds
405     * @param _spender address The address which will spend the funds.
406     * @return uint256 The number of tokens still available for the spender
407     */
408     function allowance(address _owner, address _spender) public view returns (uint256) {
409         return allowed[_owner][_spender];
410     }
411 
412     /** ERC 20
413     * @dev Increases the number of tokens a spender is allowed to spend for
414     * `msg.sender`
415     * @param _spender address The address of the spender
416     * @param _addedValue uint256 The amount to increase the spenders approval by
417     */
418     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
419         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
420         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
421         return true;
422     }
423 
424     /** ERC 20
425     * @dev Decreases the number of tokens a spender is allowed to spend for
426     * `msg.sender`
427     * @param _spender address The address of the spender
428     * @param _subtractedValue uint256 The amount to decrease the spenders approval by
429     */
430     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
431         uint _value = allowed[msg.sender][_spender];
432         if (_subtractedValue > _value) {
433             allowed[msg.sender][_spender] = 0;
434         } else {
435             allowed[msg.sender][_spender] = _value.sub(_subtractedValue);
436         }
437 
438         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
439         return true;
440     }
441 }