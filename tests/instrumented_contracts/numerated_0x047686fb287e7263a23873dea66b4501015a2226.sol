1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 contract ERC20Interface {
5 
6     // ERC Token Standard #223 Interface
7     // https://github.com/ethereum/EIPs/issues/223
8 
9     string public symbol;
10     string public  name;
11     uint8 public decimals;
12 
13     function transfer(address _to, uint _value, bytes _data) external returns (bool success);
14 
15     // approveAndCall
16     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
17 
18     // ERC Token Standard #20 Interface
19     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
20 
21 
22     function totalSupply() public constant returns (uint);
23     function balanceOf(address tokenOwner) public constant returns (uint balance);
24     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
25     function transfer(address to, uint tokens) public returns (bool success);
26     function approve(address spender, uint tokens) public returns (bool success);
27     function transferFrom(address from, address to, uint tokens) public returns (bool success);
28     event Transfer(address indexed from, address indexed to, uint tokens);
29     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
30 
31     // bulk operations
32     function transferBulk(address[] to, uint[] tokens) public;
33     function approveBulk(address[] spender, uint[] tokens) public;
34 }
35 
36 pragma solidity ^0.4.24;
37 
38 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
39 contract PluginInterface
40 {
41     /// @dev simply a boolean to indicate this is the contract we expect to be
42     function isPluginInterface() public pure returns (bool);
43 
44     function onRemove() public;
45 
46     /// @dev Begins new feature.
47     /// @param _cutieId - ID of token to auction, sender must be owner.
48     /// @param _parameter - arbitrary parameter
49     /// @param _seller - Old owner, if not the message sender
50     function run(
51         uint40 _cutieId,
52         uint256 _parameter,
53         address _seller
54     ) 
55     public
56     payable;
57 
58     /// @dev Begins new feature, approved and signed by COO.
59     /// @param _cutieId - ID of token to auction, sender must be owner.
60     /// @param _parameter - arbitrary parameter
61     function runSigned(
62         uint40 _cutieId,
63         uint256 _parameter,
64         address _owner
65     )
66     external
67     payable;
68 
69     function withdraw() public;
70 }
71 
72 
73 contract CuteCoinInterface is ERC20Interface
74 {
75     function mint(address target, uint256 mintedAmount) public;
76     function mintBulk(address[] target, uint256[] mintedAmount) external;
77     function burn(uint256 amount) external;
78 }
79 
80 pragma solidity ^0.4.24;
81 
82 
83 /**
84  * @title Ownable
85  * @dev The Ownable contract has an owner address, and provides basic authorization control
86  * functions, this simplifies the implementation of "user permissions".
87  */
88 contract Ownable {
89   address public owner;
90 
91 
92   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
93 
94 
95   /**
96    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
97    * account.
98    */
99   constructor() public {
100     owner = msg.sender;
101   }
102 
103   /**
104    * @dev Throws if called by any account other than the owner.
105    */
106   modifier onlyOwner() {
107     require(msg.sender == owner);
108     _;
109   }
110 
111   /**
112    * @dev Allows the current owner to transfer control of the contract to a newOwner.
113    * @param newOwner The address to transfer ownership to.
114    */
115   function transferOwnership(address newOwner) public onlyOwner {
116     require(newOwner != address(0));
117     emit OwnershipTransferred(owner, newOwner);
118     owner = newOwner;
119   }
120 
121 }
122 
123 pragma solidity ^0.4.24;
124 
125 // ----------------------------------------------------------------------------
126 // Safe maths
127 // ----------------------------------------------------------------------------
128 library SafeMath {
129     function add(uint a, uint b) internal pure returns (uint c) {
130         c = a + b;
131         require(c >= a);
132     }
133     function sub(uint a, uint b) internal pure returns (uint c) {
134         require(b <= a);
135         c = a - b;
136     }
137     function mul(uint a, uint b) internal pure returns (uint c) {
138         c = a * b;
139         require(a == 0 || c / a == b);
140     }
141     function div(uint a, uint b) internal pure returns (uint c) {
142         require(b > 0);
143         c = a / b;
144     }
145 }
146 
147 pragma solidity ^0.4.24;
148 
149 // ----------------------------------------------------------------------------
150 // Contract function to receive approval and execute function in one call
151 //
152 // Borrowed from MiniMeToken
153 
154 interface TokenRecipientInterface
155 {
156     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
157 }
158 
159 pragma solidity ^0.4.24;
160 
161 // https://github.com/ethereum/EIPs/issues/223
162 interface TokenFallback
163 {
164     function tokenFallback(address _from, uint _value, bytes _data) external;
165 }
166 
167 
168 contract CuteCoin is CuteCoinInterface, Ownable
169 {
170     using SafeMath for uint;
171 
172     constructor() public
173     {
174         symbol = "CUTE";
175         name = "Cute Coin";
176         decimals = 18;
177     }
178 
179     uint _totalSupply;
180     mapping (address => uint) balances;
181     mapping(address => mapping(address => uint)) allowed;
182 
183     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
184 
185     // ---------------------------- Operator ----------------------------
186     mapping (address => bool) operatorAddress;
187 
188     function addOperator(address _operator) public onlyOwner
189     {
190         operatorAddress[_operator] = true;
191     }
192 
193     function removeOperator(address _operator) public onlyOwner
194     {
195         delete(operatorAddress[_operator]);
196     }
197 
198     modifier onlyOperator() {
199         require(operatorAddress[msg.sender] || msg.sender == owner);
200         _;
201     }
202 
203     function withdrawEthFromBalance() external onlyOwner
204     {
205         owner.transfer(address(this).balance);
206     }
207 
208     // ------------------------------------------------------------------------
209     // Owner can transfer out any accidentally sent ERC20 tokens
210     // ------------------------------------------------------------------------
211     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
212         return ERC20Interface(tokenAddress).transfer(owner, tokens);
213     }
214 
215     // ---------------------------- Do not accept money ----------------------------
216     function () payable public
217     {
218         revert();
219     }
220 
221     // ---------------------------- Minting ----------------------------
222 
223     function mint(address target, uint256 mintedAmount) public onlyOperator
224     {
225         balances[target] = balances[target].add(mintedAmount);
226         _totalSupply = _totalSupply.add(mintedAmount);
227         emit Transfer(0, target, mintedAmount);
228     }
229 
230     function mintBulk(address[] target, uint256[] mintedAmount) external onlyOperator
231     {
232         require(target.length == mintedAmount.length);
233         for (uint i = 0; i < target.length; i++)
234         {
235             mint(target[i], mintedAmount[i]);
236         }
237     }
238 
239     function burn(uint256 amount) external
240     {
241         balances[msg.sender] = balances[msg.sender].sub(amount);
242         _totalSupply = _totalSupply.sub(amount);
243         emit Transfer(msg.sender, 0, amount);
244     }
245 
246 
247     // ---------------------------- ERC20 ----------------------------
248 
249     function totalSupply() public constant returns (uint)
250     {
251         return _totalSupply;
252     }
253 
254     // ------------------------------------------------------------------------
255     // Get the token balance for account `tokenOwner`
256     // ------------------------------------------------------------------------
257     function balanceOf(address tokenOwner) public constant returns (uint balance)
258     {
259         return balances[tokenOwner];
260     }
261 
262     // ------------------------------------------------------------------------
263     // Returns the amount of tokens approved by the owner that can be
264     // transferred to the spender's account
265     // ------------------------------------------------------------------------
266     function allowance(address tokenOwner, address spender) public constant returns (uint remaining)
267     {
268         return allowed[tokenOwner][spender];
269     }
270 
271     // ------------------------------------------------------------------------
272     // Transfer the balance from token owner's account to `to` account
273     // - Owner's account must have sufficient balance to transfer
274     // - 0 value transfers are allowed
275     // ------------------------------------------------------------------------
276     function transfer(address to, uint tokens) public returns (bool success) {
277         balances[msg.sender] = balances[msg.sender].sub(tokens);
278         balances[to] = balances[to].add(tokens);
279         emit Transfer(msg.sender, to, tokens);
280         return true;
281     }
282 
283     // ------------------------------------------------------------------------
284     // Token owner can approve for `spender` to transferFrom(...) `tokens`
285     // from the token owner's account
286     //
287     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
288     // recommends that there are no checks for the approval double-spend attack
289     // as this should be implemented in user interfaces
290     // ------------------------------------------------------------------------
291     function approve(address spender, uint tokens) public returns (bool success) {
292         allowed[msg.sender][spender] = tokens;
293         emit Approval(msg.sender, spender, tokens);
294         return true;
295     }
296 
297     // ------------------------------------------------------------------------
298     // Transfer `tokens` from the `from` account to the `to` account
299     //
300     // The calling account must already have sufficient tokens approve(...)-d
301     // for spending from the `from` account and
302     // - From account must have sufficient balance to transfer
303     // - Spender must have sufficient allowance to transfer
304     // - 0 value transfers are allowed
305     // ------------------------------------------------------------------------
306     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
307         balances[from] = balances[from].sub(tokens);
308         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
309         balances[to] = balances[to].add(tokens);
310         emit Transfer(from, to, tokens);
311         return true;
312     }
313 
314     // ------------------------------------------------------------------------
315     // Token owner can approve for `spender` to transferFrom(...) `tokens`
316     // from the token owner's account. The `spender` contract function
317     // `receiveApproval(...)` is then executed
318     // ------------------------------------------------------------------------
319     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success) {
320         allowed[msg.sender][spender] = tokens;
321         emit Approval(msg.sender, spender, tokens);
322         TokenRecipientInterface(spender).receiveApproval(msg.sender, tokens, this, data);
323         return true;
324     }
325 
326     function transferBulk(address[] to, uint[] tokens) public
327     {
328         require(to.length == tokens.length);
329         for (uint i = 0; i < to.length; i++)
330         {
331             transfer(to[i], tokens[i]);
332         }
333     }
334 
335     function approveBulk(address[] spender, uint[] tokens) public
336     {
337         require(spender.length == tokens.length);
338         for (uint i = 0; i < spender.length; i++)
339         {
340             approve(spender[i], tokens[i]);
341         }
342     }
343 
344 // ---------------------------- ERC223 ----------------------------
345 
346     // Function that is called when a user or another contract wants to transfer funds .
347     function transfer(address _to, uint _value, bytes _data) external returns (bool success) {
348         if(isContract(_to)) {
349             return transferToContract(_to, _value, _data);
350         }
351         else {
352             return transferToAddress(_to, _value, _data);
353         }
354     }
355 
356     //function that is called when transaction target is a contract
357     function transferToContract(address _to, uint _value, bytes _data) public returns (bool success) {
358         balances[msg.sender] = balances[msg.sender].sub(_value);
359         balances[_to] = balances[_to].add(_value);
360         TokenFallback receiver = TokenFallback(_to);
361         receiver.tokenFallback(msg.sender, _value, _data);
362         emit Transfer(msg.sender, _to, _value, _data);
363         return true;
364     }
365 
366 
367     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
368     function isContract(address _addr) private view returns (bool is_contract) {
369         uint length;
370         assembly {
371         //retrieve the size of the code on target address, this needs assembly
372             length := extcodesize(_addr)
373         }
374         return (length>0);
375     }
376 
377     //function that is called when transaction target is an address
378     function transferToAddress(address _to, uint tokens, bytes _data) public returns (bool success) {
379         balances[msg.sender] = balances[msg.sender].sub(tokens);
380         balances[_to] = balances[_to].add(tokens);
381         emit Transfer(msg.sender, _to, tokens, _data);
382         return true;
383     }
384 
385     // @dev Transfers to _withdrawToAddress all tokens controlled by
386     // contract _tokenContract.
387     function withdrawTokenFromBalance(ERC20Interface _tokenContract, address _withdrawToAddress)
388         external
389         onlyOperator
390     {
391         uint256 balance = _tokenContract.balanceOf(address(this));
392         _tokenContract.transfer(_withdrawToAddress, balance);
393     }
394 }