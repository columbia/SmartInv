1 pragma solidity ^0.4.23;
2 
3  /*
4  * Contract that is working with ERC223 tokens
5  * https://github.com/ethereum/EIPs/issues/223
6  */
7 
8 /// @title ERC223ReceivingContract - Standard contract implementation for compatibility with ERC223 tokens.
9 contract ERC223ReceivingContract {
10 
11     /// @dev Function that is called when a user or another contract wants to transfer funds.
12     /// @param _from Transaction initiator, analogue of msg.sender
13     /// @param _value Number of tokens to transfer.
14     /// @param _data Data containig a function signature and/or parameters
15     function tokenFallback(address _from, uint256 _value, bytes _data) public;
16 }
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that revert on error
21  */
22 library SafeMath {
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27         uint256 c = a * b;
28         assert(c / a == b);
29         return c;
30     }
31 
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b > 0); // Solidity only automatically asserts when dividing by 0
34         uint256 c = a / b;
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         uint256 c = a - b;
41         return c;
42     }
43 
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 
50     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
51         assert(b != 0);
52         return a % b;
53     }
54 }
55 
56 /// @title Base Token contract
57 contract Token {
58     /*
59      * Implements ERC 20 standard.
60      * https://github.com/ethereum/EIPs/blob/f90864a3d2b2b45c4decf95efd26b3f0c276051a/EIPS/eip-20-token-standard.md
61      * https://github.com/ethereum/EIPs/issues/20
62      *
63      *  Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
64      *  https://github.com/ethereum/EIPs/issues/223
65      */
66     uint256 public totalSupply;
67 
68     /*
69      * ERC 20
70      */
71     function balanceOf(address _owner) public view returns (uint256 balance);
72     function transfer(address _to, uint256 _value) public returns (bool success);
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
74     function approve(address _spender, uint256 _value) public returns (bool success);
75     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
76 
77     /*
78      * ERC 223
79      */
80     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
81 
82     /*
83      * Events
84      */
85     event Transfer(address indexed _from, address indexed _to, uint256 _value);
86     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
87 }
88 
89 
90 /// @title Standard token contract - Standard token implementation.
91 contract StandardToken is Token {
92 
93     /*
94      * Data structures
95      */
96     mapping (address => uint256) balances;
97     mapping (address => mapping (address => uint256)) allowed;
98 
99     /// @notice Allows `_spender` to transfer `_value` tokens from `msg.sender` to any address.
100     /// @dev Sets approved amount of tokens for spender. Returns success.
101     /// @param _spender Address of allowed account.
102     /// @param _value Number of approved tokens.
103     /// @return Returns success of function call.
104     function approve(address _spender, uint256 _value) public returns (bool) {
105         require(_spender != 0x0);
106 
107         // To change the approve amount you first have to reduce the addresses`
108         // allowance to zero by calling `approve(_spender, 0)` if it is not
109         // already 0 to mitigate the race condition described here:
110         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111         require(_value == 0 || allowed[msg.sender][_spender] == 0);
112 
113         allowed[msg.sender][_spender] = _value;
114         emit Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     /*
119      * Read functions
120      */
121     /// @dev Returns number of allowed tokens that a spender can transfer on
122     /// behalf of a token owner.
123     /// @param _owner Address of token owner.
124     /// @param _spender Address of token spender.
125     /// @return Returns remaining allowance for spender.
126     function allowance(address _owner, address _spender)
127         public
128         view
129         returns (uint256)
130     {
131         return allowed[_owner][_spender];
132     }
133 
134     /// @dev Returns number of tokens owned by the given address.
135     /// @param _owner Address of token owner.
136     /// @return Returns balance of owner.
137     function balanceOf(address _owner) public view returns (uint256) {
138         return balances[_owner];
139     }
140 }
141 
142 
143 /// @title Vitalik2X Token
144 contract Vitalik2XToken is StandardToken {
145     using SafeMath for uint256;
146 
147     /*
148      *  Token metadata
149      */
150     string constant public symbol = "V2X";
151     string constant public name = "Vitalik2X";
152     uint256 constant public decimals = 18;
153     uint256 constant public multiplier = 10 ** decimals;
154 
155     address public owner;
156 
157     uint256 public creationBlock;
158     uint256 public mainPotTokenBalance;
159     uint256 public mainPotETHBalance;
160 
161     mapping (address => uint256) blockLock;
162 
163     event Mint(address indexed to, uint256 amount);
164     event DonatedTokens(address indexed donator, uint256 amount);
165     event DonatedETH(address indexed donator, uint256 amount);
166     event SoldTokensFromPot(address indexed seller, uint256 amount);
167     event BoughtTokensFromPot(address indexed buyer, uint256 amount);
168     /*
169      *  Public functions
170      */
171     /// @dev Function create the token and distribute to the deploying address
172     constructor() public {
173         owner = msg.sender;
174         totalSupply = 10 ** decimals;
175         balances[msg.sender] = totalSupply;
176         creationBlock = block.number;
177 
178         emit Transfer(0x0, msg.sender, totalSupply);
179     }
180 
181     modifier onlyOwner() {
182         require(msg.sender == owner);
183         _;
184     }
185 
186     /*
187      * External Functions
188      */
189     /// @dev Adds the tokens to the main Pot.
190     function donateTokensToMainPot(uint256 amount) external returns (bool){
191         require(_transfer(this, amount));
192         mainPotTokenBalance = mainPotTokenBalance.add(amount);
193         emit DonatedTokens(msg.sender, amount);
194         return true;
195     }
196 
197     function donateETHToMainPot() external payable returns (bool){
198         require(msg.value > 0);
199         mainPotETHBalance = mainPotETHBalance.add(msg.value);
200         emit DonatedETH(msg.sender, msg.value);
201         return true;
202     }
203 
204     /// @dev Automatically sends a proportional percent of the ETH balance from the pot for proportion of the Tokens deposited.
205     function sellTokensToPot(uint256 amount) external returns (bool) {
206         uint256 amountBeingPaid = ethSliceAmount(amount);
207         require(amountBeingPaid <= ethSliceCap(), "Token amount sent is above the cap.");
208         require(_transfer(this, amount));
209         mainPotTokenBalance = mainPotTokenBalance.add(amount);
210         mainPotETHBalance = mainPotETHBalance.sub(amountBeingPaid);
211         msg.sender.transfer(amountBeingPaid);
212         emit SoldTokensFromPot(msg.sender, amount);
213         return true;
214     }
215 
216     /// @dev Automatically sends a proportional percent of the VTK2X token balance from the pot for proportion of the ETH deposited.
217     function buyTokensFromPot() external payable returns (uint256) {
218         require(msg.value > 0);
219         uint256 amountBuying = tokenSliceAmount(msg.value);
220         require(amountBuying <= tokenSliceCap(), "Msg.value is above the cap.");
221         require(mainPotTokenBalance >= 1 finney, "Pot does not have enough tokens.");
222         mainPotETHBalance = mainPotETHBalance.add(msg.value);
223         mainPotTokenBalance = mainPotTokenBalance.sub(amountBuying);
224         balances[address(this)] = balances[address(this)].sub(amountBuying);
225         balances[msg.sender] = balances[msg.sender].add(amountBuying);
226         emit Transfer(address(this), msg.sender, amountBuying);
227         emit BoughtTokensFromPot(msg.sender, amountBuying);
228         return amountBuying;
229     }
230 
231     /// @dev Returns the block number the given address is locked until.
232     /// @param _owner Address of token owner.
233     /// @return Returns block number the lock is released.
234     function blockLockOf(address _owner) external view returns (uint256) {
235         return blockLock[_owner];
236     }
237 
238     /// @dev external function to retrieve ETH sent to the contract.
239     function withdrawETH() external onlyOwner {
240         owner.transfer(address(this).balance.sub(mainPotETHBalance));
241     }
242 
243     /// @dev external function to retrieve tokens accidentally sent to the contract.
244     function withdrawToken(address token) external onlyOwner {
245         require(token != address(this));
246         Token erc20 = Token(token);
247         erc20.transfer(owner, erc20.balanceOf(this));
248     }
249 
250     /*
251      * Public Functions
252      */
253     /// @dev public function to retrieve the ETH amount.
254     function ethSliceAmount(uint256 amountOfTokens) public view returns (uint256) {
255         uint256 amountBuying = mainPotETHBalance.mul(amountOfTokens).div(mainPotTokenBalance);
256         amountBuying = amountBuying.sub(amountBuying.mul(amountOfTokens).div(mainPotTokenBalance));
257         return amountBuying;
258     }
259 
260     /// @dev public function to retrieve the max ETH slice allotted.
261     function ethSliceCap() public view returns (uint256) {
262         return mainPotETHBalance.mul(30).div(100);
263     }
264 
265     /// @dev public function to retrieve the percentage of ETH user wants from pot.
266     function ethSlicePercentage(uint256 amountOfTokens) public view returns (uint256) {
267         uint256 amountOfTokenRecieved = ethSliceAmount(amountOfTokens);
268         return amountOfTokenRecieved.mul(100).div(mainPotETHBalance);
269     }
270 
271     /// @dev public function to retrieve the current pot reward amount.
272     function tokenSliceAmount(uint256 amountOfETH) public view returns (uint256) {
273         uint256 amountBuying = mainPotTokenBalance.mul(amountOfETH).div(mainPotETHBalance);
274         amountBuying = amountBuying.sub(amountBuying.mul(amountOfETH).div(mainPotETHBalance));
275         return amountBuying;
276     }
277 
278     /// @dev public function to retrieve the max token slice allotted.
279     function tokenSliceCap() public view returns (uint256) {
280         return mainPotTokenBalance.mul(30).div(100);
281     }
282     /// @dev public function to retrieve the percentage of ETH user wants from pot.
283     function tokenSlicePercentage(uint256 amountOfEth) public view returns (uint256) {
284         uint256 amountOfEthRecieved = tokenSliceAmount(amountOfEth);
285         return amountOfEthRecieved.mul(100).div(mainPotTokenBalance);
286     }
287 
288     /// @dev public function to check the status of account's lock.
289     function accountLocked() public view returns (bool) {
290         return (block.number < blockLock[msg.sender]);
291     }
292 
293     function transfer(address _to, uint256 _value) public returns (bool) {
294         require(block.number >= blockLock[msg.sender], "Address is still locked.");
295         if (_to == address(this)) {
296             return _vitalikize(msg.sender, _value);
297         } else {
298             return _transfer(_to, _value);
299         }
300     }
301 
302 
303     /// @notice Send `_value` tokens to `_to` from `msg.sender` and trigger
304     /// tokenFallback if sender is a contract.
305     /// @dev Function that is called when a user or another contract wants to transfer funds.
306     /// @param _to Address of token receiver.
307     /// @param _value Number of tokens to transfer.
308     /// @param _data Data to be sent to tokenFallback
309     /// @return Returns success of function call.
310     function transfer(
311         address _to,
312         uint256 _value,
313         bytes _data)
314         public
315         returns (bool)
316     {
317         require(_to != address(this));
318         // Transfers tokens normally as per ERC20 standards
319         require(transfer(_to, _value));
320 
321         uint codeLength;
322 
323         assembly {
324             // Retrieve the size of the code on target address, this needs assembly.
325             codeLength := extcodesize(_to)
326         }
327 
328         // If codeLength is > 0, it means it is a contract, handle fallback
329         if (codeLength > 0) {
330             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
331             receiver.tokenFallback(msg.sender, _value, _data);
332         }
333 
334         return true;
335     }
336 
337     /// @notice Transfer `_value` tokens from `_from` to `_to` if `msg.sender` is allowed.
338     /// @dev Allows for an approved third party to transfer tokens from one
339     /// address to another. Returns success.
340     /// @param _from Address from where tokens are withdrawn.
341     /// @param _to Address to where tokens are sent.
342     /// @param _value Number of tokens to transfer.
343     /// @return Returns success of function call.
344     function transferFrom(address _from, address _to, uint256 _value)
345         public
346         returns (bool)
347     {
348         require(block.number >= blockLock[_from], "Address is still locked.");
349         require(_from != 0x0);
350         require(_to != 0x0);
351         require(_to != address(this));
352         // Balance of sender is legit
353         balances[_to] = balances[_to].add(_value);
354         balances[_from] = balances[_from].sub(_value);
355         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
356 
357         emit Transfer(_from, _to, _value);
358 
359         return true;
360     }
361 
362     /*
363      * Internal functions
364      */
365     /// @notice Send `_value` tokens to `_to` from `msg.sender`.
366     /// @dev Transfers sender's tokens to a given address. Returns success.
367     /// @param _to Address of token receiver.
368     /// @param _value Number of tokens to transfer.
369     /// @return Returns success of function call.
370     function _transfer(address _to, uint256 _value) internal returns (bool) {
371         balances[msg.sender] = balances[msg.sender].sub(_value);
372         balances[_to] = balances[_to].add(_value);
373         emit Transfer(msg.sender, _to, _value);
374         return true;
375     }
376 
377     /// @dev Mints the amount of token passed and sends it to the sender
378     function _vitalikize(address _sender, uint256 _value) internal returns (bool) {
379         require(balances[_sender] >= _value, "Owner doesnt have enough tokens.");
380         uint256 calcBlockLock = (block.number - creationBlock)/5;
381         blockLock[_sender] = block.number + (calcBlockLock > 2600 ? calcBlockLock : 2600);
382         require(mint(_sender, _value), "Minting failed");
383         emit Transfer(address(0), _sender, _value);
384         return true;
385     }
386 
387     function mint(address _address, uint256 _amount) internal returns (bool) {
388         totalSupply = totalSupply.add(_amount);
389         balances[_address] = balances[_address].add(_amount);
390         return true;
391     }
392 }