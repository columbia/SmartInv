1 pragma solidity ^0.4.24;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 library SafeMath {
8 
9 /**
10 * @dev Multiplies two numbers, throws on overflow.
11 */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49     /**
50     * @title Ownable
51     * @dev The Ownable contract has an owner address, and provides basic authorization control
52     * functions, this simplifies the implementation of "user permissions".
53     */
54 contract Ownable {
55     address public owner;
56 
57 
58     event OwnershipRenounced(address indexed previousOwner);
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62     /**
63     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64     * account.
65     */
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     /**
71     * @dev Throws if called by any account other than the owner.
72     */
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     /**
79     * @dev Allows the current owner to transfer control of the contract to a newOwner.
80     * @param newOwner The address to transfer ownership to.
81     */
82     function transferOwnership(address newOwner) external onlyOwner {
83         require(newOwner != address(0));
84         emit OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86     }
87 }
88 
89 contract Lockable is Ownable {
90     uint256 public creationTime;
91     bool public tokenTransferLocker;
92     mapping(address => bool) lockaddress;
93 
94     event Locked(address lockaddress);
95     event Unlocked(address lockaddress);
96     event TokenTransferLocker(bool _setto);
97 
98     // if Token transfer
99     modifier isTokenTransfer {
100         // only contract holder can send token during locked period
101         if(msg.sender != owner) {
102             // if token transfer is not allow
103             require(!tokenTransferLocker);
104             if(lockaddress[msg.sender]){
105                 revert();
106             }
107         }
108         _;
109     }
110 
111     // This modifier check whether the contract should be in a locked
112     // or unlocked state, then acts and updates accordingly if
113     // necessary
114     modifier checkLock {
115         if (lockaddress[msg.sender]) {
116             revert();
117         }
118         _;
119     }
120 
121     constructor() public {
122         creationTime = now;
123         owner = msg.sender;
124     }
125 
126 
127     function isTokenTransferLocked()
128     external
129     view
130     returns (bool)
131     {
132         return tokenTransferLocker;
133     }
134 
135     function enableTokenTransfer()
136     external
137     onlyOwner
138     {
139         delete tokenTransferLocker;
140         emit TokenTransferLocker(false);
141     }
142 
143     function disableTokenTransfer()
144     external
145     onlyOwner
146     {
147         tokenTransferLocker = true;
148         emit TokenTransferLocker(true);
149     }
150 }
151 
152 
153 contract ERC20 {
154     mapping(address => uint256) balances;
155     mapping (address => mapping (address => uint256)) internal allowed;
156     uint256 public totalSupply;
157     function balanceOf(address who) view external returns (uint256);
158     function transfer(address to, uint256 value) public returns (bool);
159     function allowance(address owner, address spender) external view returns (uint256);
160     function transferFrom(address from, address to, uint256 value) external returns (bool);
161     function approve(address spender, uint256 value) public returns (bool);
162 
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164     event Transfer(address indexed from, address indexed to, uint256 value);
165 }
166 
167 contract CoolPandaToken is ERC20, Lockable  {
168     using SafeMath for uint256;
169 
170     uint256 public decimals = 18;
171     address public fundWallet = 0x071961b88F848D09C3d988E8814F38cbAE755C44;
172     uint256 public tokenPrice;
173 
174     function balanceOf(address _addr) external view returns (uint256) {
175         return balances[_addr];
176     }
177 
178     function allowance(address _from, address _spender) external view returns (uint256) {
179         return allowed[_from][_spender];
180     }
181 
182     function transfer(address _to, uint256 _value)
183     isTokenTransfer
184     public
185     returns (bool success) {
186         require(_to != address(0));
187         require(_value <= balances[msg.sender]);
188 
189         balances[msg.sender] = balances[msg.sender].sub(_value);
190         balances[_to] = balances[_to].add(_value);
191         emit Transfer(msg.sender, _to, _value);
192         return true;
193     }
194 
195     function transferFrom(address _from, address _to, uint _value)
196     isTokenTransfer
197     external
198     returns (bool) {
199         require(_to != address(0));
200         require(_value <= balances[_from]);
201         require(_value <= allowed[_from][msg.sender]);
202 
203         balances[_from] = balances[_from].sub(_value);
204         balances[_to] = balances[_to].add(_value);
205         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
206         emit Transfer(_from, _to, _value);
207         return true;
208     }
209 
210     function approve(address _spender, uint256 _value)
211     isTokenTransfer
212     public
213     returns (bool success) {
214         allowed[msg.sender][_spender] = _value;
215         emit Approval(msg.sender, _spender, _value);
216         return true;
217     }
218 
219     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
220         isTokenTransfer
221         external
222         returns (bool success) {
223         tokenRecipient spender = tokenRecipient(_spender);
224         if (approve(_spender, _value)) {
225             spender.receiveApproval(msg.sender, _value, this, _extraData);
226             return true;
227         }
228     }
229 
230     function setFundWallet(address _newAddr) external onlyOwner {
231         require(_newAddr != address(0));
232         fundWallet = _newAddr;
233     }
234 
235     function transferEth() onlyOwner external {
236         fundWallet.transfer(address(this).balance);
237     }
238 
239     function setTokenPrice(uint256 _newBuyPrice) external onlyOwner {
240         tokenPrice = _newBuyPrice;
241     }
242 }
243 
244 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
245 
246 contract PaoToken is CoolPandaToken {
247     using SafeMath for uint256;
248 
249     string public name = "PAO Token";
250     string public symbol = "PAO";
251     uint fundRatio = 6;
252     uint256 public minBuyETH = 50;
253 
254     JPYC public jpyc;                       //JPYC Address
255     uint256 public jypcBonus = 40000;       
256 
257     event JypcBonus(uint256 paoAmount, uint256 jpycAmount);
258 
259     // constructor
260     constructor() public {
261         totalSupply = 10000000000 * 10 ** uint256(decimals);
262         tokenPrice = 50000;
263         balances[fundWallet] = totalSupply * fundRatio / 10;
264         balances[address(this)] = totalSupply.sub(balances[fundWallet]);
265     }
266 
267     // @notice Buy tokens from contract by sending ether
268     function () payable public {
269         if(fundWallet != msg.sender){
270             require (msg.value >= (minBuyETH * 10 ** uint256(decimals)));   // Check if minimum amount 
271             uint256 amount = msg.value.mul(tokenPrice);                     // calculates the amount
272             _buyToken(msg.sender, amount);                                  // makes the transfers
273             fundWallet.transfer(msg.value);                              // send ether to the fundWallet
274         }
275     }
276 
277     function _buyToken(address _to, uint256 _value) isTokenTransfer internal {
278         address _from = address(this);
279         require (_to != 0x0);                                                   // Prevent transfer to 0x0 address.
280         require (balances[_from] >= _value);                                    // Check if the sender has enough
281         require (balances[_to].add(_value) >= balances[_to]);                   // Check for overflows
282         balances[_from] = balances[_from].sub(_value);
283         balances[_to] = balances[_to].add(_value);
284         emit Transfer(_from, _to, _value);
285 
286         //give bonus consume token
287         uint256 _jpycAmount = _getJYPCBonus();
288         jpyc.giveBonus(_to, _jpycAmount);
289 
290         emit JypcBonus(_value,_jpycAmount);
291     }
292 
293     function _getJYPCBonus() internal view returns (uint256 amount){
294         return msg.value.mul(jypcBonus); 
295     }  
296 
297     function setMinBuyEth(uint256 _amount) external onlyOwner{
298         minBuyETH = _amount;
299     }
300 
301     function setJypcBonus(uint256 _amount) external onlyOwner{
302         jypcBonus = _amount;
303     }
304 
305     function transferToken() onlyOwner external {
306         address _from = address(this);
307         uint256 _total = balances[_from];
308         balances[_from] = balances[_from].sub(_total);
309         balances[fundWallet] = balances[fundWallet].add(_total);
310     }
311 
312     function setJpycContactAddress(address _tokenAddress) external onlyOwner {
313         jpyc = JPYC(_tokenAddress);
314     }
315 }
316 
317 contract JPYC is CoolPandaToken {
318     using SafeMath for uint256;
319 
320     string public name = "Japan Yen Coin";
321     uint256 _initialSupply = 10000000000 * 10 ** uint256(decimals);
322     string public symbol = "JPYC";
323     address public paoContactAddress;
324 
325     event Issue(uint256 amount);
326 
327     // constructor
328     constructor() public {
329         tokenPrice = 47000;           //JPY to ETH (rough number)
330         totalSupply = _initialSupply;
331         balances[fundWallet] = _initialSupply;
332     }
333 
334     function () payable public {
335         uint amount = msg.value.mul(tokenPrice);             // calculates the amount
336         _giveToken(msg.sender, amount);                          // makes the transfers
337         fundWallet.transfer(msg.value);                         // send ether to the public collection wallet
338     }
339 
340     function _giveToken(address _to, uint256 _value) isTokenTransfer internal {
341         require (_to != 0x0);                                       // Prevent transfer to 0x0 address.
342         require(totalSupply.add(_value) >= totalSupply);
343         require (balances[_to].add(_value) >= balances[_to]);       // Check for overflows
344 
345         totalSupply = totalSupply.add(_value);
346         balances[_to] = balances[_to].add(_value);                  // Add the same to the recipient
347         emit Transfer(address(this), _to, _value);
348     }
349 
350     function issue(uint256 amount) external onlyOwner {
351         _giveToken(fundWallet, amount);
352 
353         emit Issue(amount);
354     }
355 
356     function setPaoContactAddress(address _newAddr) external onlyOwner {
357         require(_newAddr != address(0));
358         paoContactAddress = _newAddr;
359     }
360 
361     function giveBonus(address _to, uint256 _value)
362     isTokenTransfer
363     external
364     returns (bool success) {
365         require(_to != address(0));
366         if(msg.sender == paoContactAddress){
367             _giveToken(_to,_value);
368             return true;
369         }
370         return false;
371     }
372 }