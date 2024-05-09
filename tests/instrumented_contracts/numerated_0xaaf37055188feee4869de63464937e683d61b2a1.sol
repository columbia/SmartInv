1 pragma solidity ^0.4.23;
2 
3 /***************************************************
4 Externally copied contracts and interfaces.
5 Source: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
6 ***************************************************/
7 
8 
9 /**** ERC20Basic.sol ****/
10 /**
11  * @title ERC20Basic
12  * @dev Simpler version of ERC20 interface
13  * @dev see https://github.com/ethereum/EIPs/issues/179
14  */
15 contract ERC20Basic {
16     function totalSupply() public view returns (uint256);
17     function balanceOf(address who) public view returns (uint256);
18     function transfer(address to, uint256 value) public returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 }
21 /**** ERC20Basic.sol ****/
22 
23 /**** ERC20.sol ****/
24 /**
25  * @title ERC20 interface
26  * @dev see https://github.com/ethereum/EIPs/issues/20
27  */
28 contract ERC20 is ERC20Basic {
29     function allowance(address owner, address spender)
30     public view returns (uint256);
31 
32     function transferFrom(address from, address to, uint256 value)
33     public returns (bool);
34 
35     function approve(address spender, uint256 value) public returns (bool);
36     event Approval(
37         address indexed owner,
38         address indexed spender,
39         uint256 value
40     );
41 }
42 /**** ERC20.sol ****/
43 
44 /**** SafeMath.sol ****/
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51     /**
52     * @dev Multiplies two numbers, throws on overflow.
53     */
54     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
55         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
56         // benefit is lost if 'b' is also tested.
57         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
58         if (a == 0) {
59             return 0;
60         }
61 
62         c = a * b;
63         assert(c / a == b);
64         return c;
65     }
66 
67     /**
68     * @dev Integer division of two numbers, truncating the quotient.
69     */
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         // assert(b > 0); // Solidity automatically throws when dividing by 0
72         // uint256 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74         return a / b;
75     }
76 
77     /**
78     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
79     */
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         assert(b <= a);
82         return a - b;
83     }
84 
85     /**
86     * @dev Adds two numbers, throws on overflow.
87     */
88     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
89         c = a + b;
90         assert(c >= a);
91         return c;
92     }
93 }
94 /**** SafeMath.sol ****/
95 
96 /**** Ownable.sol ****/
97 /**
98  * @title Ownable
99  * @dev The Ownable contract has an owner address, and provides basic authorization control
100  * functions, this simplifies the implementation of "user permissions".
101  */
102 contract Ownable {
103     address public owner;
104 
105 
106     event OwnershipRenounced(address indexed previousOwner);
107     event OwnershipTransferred(
108         address indexed previousOwner,
109         address indexed newOwner
110     );
111 
112 
113     /**
114      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
115      * account.
116      */
117     constructor() public {
118         owner = msg.sender;
119     }
120 
121     /**
122      * @dev Throws if called by any account other than the owner.
123      */
124     modifier onlyOwner() {
125         require(msg.sender == owner);
126         _;
127     }
128 
129     /**
130      * @dev Allows the current owner to relinquish control of the contract.
131      * @notice Renouncing to ownership will leave the contract without an owner.
132      * It will not be possible to call the functions with the `onlyOwner`
133      * modifier anymore.
134      */
135     function renounceOwnership() public onlyOwner {
136         emit OwnershipRenounced(owner);
137         owner = address(0);
138     }
139 
140     /**
141      * @dev Allows the current owner to transfer control of the contract to a newOwner.
142      * @param _newOwner The address to transfer ownership to.
143      */
144     function transferOwnership(address _newOwner) public onlyOwner {
145         require(_newOwner != address(0));
146         emit OwnershipTransferred(owner, _newOwner);
147         owner = _newOwner;
148     }
149 
150 
151 }
152 /**** Ownable.sol ****/
153 
154 
155 
156 
157 /***************************************************
158  * Individually implemented code
159  ***************************************************/
160 
161 /**
162  * @title UChain ERC20 Token
163  */
164 contract UChainToken is ERC20 {
165     using SafeMath for uint256;
166 
167     /* Constant variables of the token */
168     string constant public name = 'UChain Token';
169     string constant public symbol = 'UCN';
170     uint8 constant public decimals = 18;
171     uint256 constant public decimalFactor = 10 ** uint(decimals);
172 
173     uint256 public totalSupply;
174 
175     /* minting related state */
176     bool public isMintingFinished = false;
177     mapping(address => bool) public admins;
178 
179     /* vesting related state */
180     struct Vesting {
181         uint256 vestedUntil;
182         uint256 vestedAmount;
183     }
184 
185     mapping(address => Vesting) public vestingEntries;
186 
187     /* ERC20 related state */
188     bool public isTransferEnabled = false;
189     mapping(address => uint256) public balances;
190     mapping(address => mapping(address => uint256)) public allowances;
191 
192 
193     /* custom events */
194     event MintFinished();
195     event Mint(address indexed _beneficiary, uint256 _value);
196     event MintVested(address indexed _beneficiary, uint256 _value);
197     event AdminRemoved(address indexed _adminAddress);
198     event AdminAdded(address indexed _adminAddress);
199 
200     /**
201      * @dev contstructor.
202      */
203     constructor() public {
204         admins[msg.sender] = true;
205     }
206 
207     /***************************************************
208      * View only methods
209      ***************************************************/
210 
211     /**
212       * @dev specified in the ERC20 interface, returns the total token supply. Burned tokens are not counted.
213       */
214     function totalSupply() public view returns (uint256) {
215         return totalSupply - balances[address(0)];
216     }
217 
218     /**
219       * @dev Get the token balance for token owner
220       * @param _tokenOwner The address of you want to query the balance for
221       */
222     function balanceOf(address _tokenOwner) public view returns (uint256) {
223         return balances[_tokenOwner];
224     }
225 
226     /**
227      * @dev Function to check the amount of tokens that an owner allowed to a spender.
228      * @param _tokenOwner address The address which owns the funds.
229      * @param _spender address The address which will spend the funds.
230      * @return A uint256 specifying the amount of tokens still available for the spender.
231      */
232     function allowance(address _tokenOwner, address _spender) public view returns (uint256) {
233         return allowances[_tokenOwner][_spender];
234     }
235 
236     /***************************************************
237      * Admin permission related methods
238      ***************************************************/
239 
240     /**
241      * @dev Throws if called by any account other than the owner.
242      */
243     modifier onlyAdmin() {
244         require(admins[msg.sender]);
245         _;
246     }
247 
248     /**
249      * @dev remove admin rights
250      * @param _adminAddress address to remove from admin list
251      */
252     function removeAdmin(address _adminAddress) public onlyAdmin {
253         delete admins[_adminAddress];
254         emit AdminRemoved(_adminAddress);
255     }
256 
257     /**
258      * @dev give admin rights to address
259      * @param _adminAddress address to add to admin list
260      */
261     function addAdmin(address _adminAddress) public onlyAdmin {
262         admins[_adminAddress] = true;
263         emit AdminAdded(_adminAddress);
264     }
265 
266     /**
267      * @dev tells you whether a particular address has admin privileges or not
268      * @param _adminAddress address to check whether it has admin privileges
269      */
270     function isAdmin(address _adminAddress) public view returns (bool) {
271         return admins[_adminAddress];
272     }
273 
274     /***************************************************
275      * Minting related methods
276      ***************************************************/
277 
278     function mint(address _beneficiary, uint256 _value) public onlyAdmin returns (bool)  {
279         require(!isMintingFinished);
280         totalSupply = totalSupply.add(_value);
281         balances[_beneficiary] = balances[_beneficiary].add(_value);
282         emit Mint(_beneficiary, _value);
283         emit Transfer(address(0), _beneficiary, _value);
284         return true;
285     }
286 
287     function bulkMint(address[] _beneficiaries, uint256[] _values) public onlyAdmin returns (bool)  {
288         require(_beneficiaries.length == _values.length);
289         for (uint256 i = 0; i < _beneficiaries.length; i = i.add(1)) {
290             require(mint(_beneficiaries[i], _values[i]));
291         }
292         return true;
293     }
294 
295     function mintVested(uint256 _vestedUntil, address _beneficiary, uint256 _value) public onlyAdmin returns (bool) {
296         require(mint(_beneficiary, _value));
297         vestingEntries[_beneficiary] = Vesting(_vestedUntil, _value);
298         emit MintVested(_beneficiary, _value);
299         return true;
300     }
301 
302     function bulkMintVested(uint256 _vestedUntil, address[] _beneficiaries, uint256[] _values) public onlyAdmin returns (bool)  {
303         require(_beneficiaries.length == _values.length);
304         for (uint256 i = 0; i < _beneficiaries.length; i = i.add(1)) {
305             require(mintVested(_vestedUntil, _beneficiaries[i], _values[i]));
306         }
307         return true;
308     }
309 
310     /**
311      * @dev finishes the minting. After this call no more tokens can be minted.
312      */
313     function finishMinting() public onlyAdmin {
314         isMintingFinished = true;
315     }
316 
317     /***************************************************
318      * Vesting related methods
319      ***************************************************/
320     function getNonVestedBalanceOf(address _tokenOwner) public view returns (uint256) {
321         if (block.timestamp < vestingEntries[_tokenOwner].vestedUntil) {
322             return balances[_tokenOwner].sub(vestingEntries[_tokenOwner].vestedAmount);
323         } else {
324             return balances[_tokenOwner];
325         }
326     }
327 
328     /***************************************************
329      * Basic Token operations
330      * Source: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
331      ***************************************************/
332 
333     /**
334      * @dev Transfer token for a specified address
335      * @param _to The address to transfer to.
336      * @param _value The amount to be transferred.
337      */
338     function transfer(address _to, uint256 _value) public returns (bool) {
339         require(isTransferEnabled);
340         require(_to != address(0));
341         require(_value <= getNonVestedBalanceOf(msg.sender));
342 
343         balances[msg.sender] = balances[msg.sender].sub(_value);
344         balances[_to] = balances[_to].add(_value);
345 
346         emit Transfer(msg.sender, _to, _value);
347         return true;
348     }
349 
350 
351     /***************************************************
352      * Standard Token operations
353      * Source: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol
354      ***************************************************/
355 
356     /**
357      * @dev Transfer tokens from one address to another
358      * @param _from address The address which you want to send tokens from
359      * @param _to address The address which you want to transfer to
360      * @param _value uint256 the amount of tokens to be transferred
361      */
362     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
363         require(isTransferEnabled);
364         require(_to != address(0));
365         require(_value <= getNonVestedBalanceOf(_from));
366         require(_value <= allowances[_from][msg.sender]);
367 
368         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
369         balances[_from] = balances[_from].sub(_value);
370         balances[_to] = balances[_to].add(_value);
371 
372         emit Transfer(_from, _to, _value);
373         return true;
374     }
375 
376     /**
377      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
378      *
379      * Beware that changing an allowance with this method brings the risk that someone may use both the old
380      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
381      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
382      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
383      * @param _spender The address which will spend the funds.
384      * @param _value The amount of tokens to be spent.
385      */
386     function approve(address _spender, uint256 _value) public returns (bool) {
387         allowances[msg.sender][_spender] = _value;
388         emit Approval(msg.sender, _spender, _value);
389         return true;
390     }
391 
392     /**
393      * @dev sets the right to transfer tokens or not.
394      * @param _isTransferEnabled the new state to set
395      */
396     function setIsTransferEnabled(bool _isTransferEnabled) public onlyAdmin {
397         isTransferEnabled = _isTransferEnabled;
398     }
399 }