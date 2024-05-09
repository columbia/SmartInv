1 pragma solidity ^0.5.3;
2 
3 /**
4 * @author ESPAY PTY LTD.
5 */
6 
7 /**
8 * @title ERC223ReceivingContract
9 * @dev ContractReceiver abstract class that define by erc223, the method tokenFallback must by receiver contract if it want 
10 *      to accept erc223 tokens.
11 *      ERC223 Receiving Contract interface
12 */
13 contract ERC223ReceivingContract {
14     function tokenFallback(address from, uint value, bytes memory _data) public;
15 }
16 
17 /**
18 * @title ERC223Interface
19 * @dev ERC223 Contract Interface
20 */
21 contract ERC223Interface {
22     function balanceOf(address who)public view returns (uint);
23     function transfer(address to, uint value)public returns (bool success);
24     function transfer(address to, uint value, bytes memory data)public returns (bool success);
25     event Transfer(address indexed from, address indexed to, uint value);
26 }
27 
28 /**
29 * @title UpgradedStandardToken
30 * @dev Contract Upgraded Interface
31 */
32 contract UpgradedStandardToken{
33     function transferByHolder(address to, uint tokens) external;
34 }
35 
36 /**
37 * @title Authenticity
38 * @dev Address Authenticity Interface
39 */
40 contract Authenticity{
41     function getAddress(address contratAddress) public view returns (bool);
42 }
43 
44 /**
45 * @title SafeMath
46 * @dev Math operations with safety checks that throw on error
47 */
48 library safeMath {
49     
50     /**
51     * @dev Adds two numbers, reverts on overflow.
52     */
53     function add(uint a, uint b) internal pure returns (uint c) {
54         c = a + b;
55         require(c >= a);
56     }
57     
58     /**
59     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
60     */
61     function sub(uint a, uint b) internal pure returns (uint c) {
62         require(b <= a);
63         c = a - b;
64     }
65     
66     /**
67     * @dev Multiplies two numbers, reverts on overflow.
68     */
69     function mul(uint a, uint b) internal pure returns (uint c) {
70         c = a * b;
71         require(a == 0 || c / a == b);
72     }
73     
74     /**
75     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
76     */
77     function div(uint256 a, uint256 b) internal pure returns (uint c) {
78         require(b > 0);
79         c = a / b;
80     }
81 }
82 
83 /**
84 * @title Ownable
85 * @dev The Ownable contract has an owner address, and provides basic authorization control
86 *      functions, this simplifies the implementation of "user permissions".
87 */
88 contract Ownable {
89     address public owner;
90     
91     constructor() internal{
92         owner = msg.sender;
93     }
94 
95     /**
96     * @dev Throws if called by any account other than the owner.
97     */
98     modifier onlyOwner() {
99         require(msg.sender == owner);
100         _;
101     }
102 }
103 
104 /**
105 * @title BlackList
106 * @dev The BlackList contract has an BlackList address, and provides basic authorization control
107 *      functions, this simplifies the implementation of "user address authorization".
108 */
109 contract BlackList is Ownable{
110     
111     mapping (address => bool) internal isBlackListed;
112     
113     event AddedBlackList(address _user);
114     event RemovedBlackList(address _user);
115     
116     function getBlackListStatus(address _maker) external view returns (bool) {
117         return isBlackListed[_maker];
118     }
119     
120     /**
121     * @param _evilUser address of user the owner want to add in BlackList 
122     */
123     function addBlackList (address _evilUser) public onlyOwner {
124         require(!isBlackListed[_evilUser]);
125         isBlackListed[_evilUser] = true;
126         emit AddedBlackList(_evilUser);
127     }
128 
129     /**
130     * @param _clearedUser address of user the owner want to remove BlackList 
131     */
132     function removeBlackList (address _clearedUser) public onlyOwner {
133         require(isBlackListed[_clearedUser]);
134         isBlackListed[_clearedUser] = false;
135         emit RemovedBlackList(_clearedUser);
136     }
137 }
138 
139 /**
140 * @title BasicERC223
141 * @dev standard ERC223 contract
142 */
143 contract BasicERC223 is BlackList,ERC223Interface {
144     
145     using safeMath for uint;
146     uint8 public basisPointsRate;
147     uint public minimumFee;
148     uint public maximumFee;
149     address[] holders;
150     
151     mapping(address => uint) internal balances;
152     
153     event Transfer(address from, address to, uint256 value, bytes data, uint256 fee);
154     
155     /**
156     * @dev Function that is called when a user or another contract wants to transfer funds.
157     * @param _address address of contract.
158     * @return true is _address was contract address.
159     */
160     function isContract(address _address) internal view returns (bool is_contract) {
161         uint length;
162         require(_address != address(0));
163         assembly {
164             length := extcodesize(_address)
165         }
166         return (length > 0);
167     }
168     
169     /**
170     * @dev function that is called by transfer method to calculate Fee.
171     * @param _amount Amount of tokens.
172     * @return fee calculate from _amount.
173     */
174     function calculateFee(uint _amount) internal view returns(uint fee){
175         fee = (_amount.mul(basisPointsRate)).div(1000);
176         if (fee > maximumFee) fee = maximumFee;
177         if (fee < minimumFee) fee = minimumFee;
178     }
179     
180     /**
181     * @dev function that is called when transaction target is a contract.
182     * @return true if transferToContract execute successfully.
183     */
184     function transferToContract(address _to, uint _value, bytes memory _data) internal returns (bool success) {
185         require(_value > 0 && balances[msg.sender]>=_value);
186         require(_to != msg.sender && _to != address(0));
187         uint fee = calculateFee(_value);
188         balances[msg.sender] = balances[msg.sender].sub(_value);
189         balances[_to] = balances[_to].add(_value.sub(fee));
190         if (fee > 0) {
191             balances[owner] = balances[owner].add(fee);
192         }
193         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
194         receiver.tokenFallback(msg.sender, _value, _data);
195         emit Transfer(msg.sender, _to, _value);
196         emit Transfer(msg.sender, _to, _value,  _data, fee);
197         holderIsExist(_to);
198         return true;
199     }
200     
201     /**
202     * @dev function that is called when transaction target is a external Address.
203     * @return true if transferToAddress execute successfully.
204     */
205     function transferToAddress(address _to, uint _value, bytes memory _data) internal returns (bool success) {
206         require(_value > 0 && balances[msg.sender]>=_value);
207         require(_to != msg.sender && _to != address(0));
208         uint fee = calculateFee(_value);
209         balances[msg.sender] = balances[msg.sender].sub(_value);
210         balances[_to] = balances[_to].add(_value.sub(fee));
211         if (fee > 0) {
212             balances[owner] = balances[owner].add(fee);
213         }
214         emit Transfer(msg.sender, _to, _value);
215         emit Transfer(msg.sender, _to, _value,  _data, fee);
216         holderIsExist(_to);
217         return true;
218     }
219     
220     /**
221     * @dev Check for existing holder address if not then add it .
222     * @param _holder The address to check it already exist or not.
223     * @return true if holderIsExist execute successfully.
224     */
225     function holderIsExist(address _holder) internal returns (bool success){
226         for(uint i=0;i<holders.length;i++)
227             if(_holder==holders[i])
228                 success=true;
229         if(!success) holders.push(_holder);
230     }
231     
232     /**
233     * @dev Get all holders of Contract.
234     * @return array of holder address.
235     */
236     function holder() public onlyOwner view returns(address[] memory){
237         return holders;
238     }
239 }
240 
241 /**
242 * @title CoolDex.
243 * @dev CoolDex that implements BasicERC223.
244 */
245 contract CoolDex is BasicERC223{
246     string public  name;
247     string public symbol;
248     uint8 public decimals;
249     uint256 internal _totalSupply;
250     bool public Auth;
251     bool public deprecated;
252     bytes empty;
253    
254     /** @dev fee Events */
255     event Params(uint8 feeBasisPoints,uint maximumFee,uint minimumFee);
256     
257     /** @dev IsAutheticate is modifier use to check contract is verifyed or not. */
258     modifier IsAuthenticate(){
259         require(Auth);
260         _;
261     }
262     
263     constructor(string memory _name, string memory _symbol, uint256 totalSupply) public {
264         name = _name;                                       // Name of token
265         symbol = _symbol;                                   // Symbol of token
266         decimals = 18;                                      // Decimal unit of token
267         _totalSupply = totalSupply * 10**uint(decimals);    // Initial supply of token
268         balances[msg.sender] = _totalSupply;                // Token owner will credited defined token supply
269         holders.push(msg.sender);
270         emit Transfer(address(this), msg.sender, _totalSupply);
271     }
272     
273     /**
274     * @dev Get totalSupply of tokens.
275     */
276     function totalSupply() IsAuthenticate public view returns (uint256) {
277         return _totalSupply;
278     }
279     
280     /**
281     * @dev Gets the balance of the specified address.
282     * @param _owner The address to query the the balance of.
283     * @return An uint representing the amount owned by the passed address.
284     */
285     function balanceOf(address _owner) IsAuthenticate public view returns (uint balance) {
286         return balances[_owner];
287     }
288     
289     /**
290     * @dev Transfer the specified amount of tokens to the specified address.
291     *      This function works the same with the previous one
292     *      but doesn't contain `_data` param.
293     *      Added due to backwards compatibility reasons.
294     * @param to    Receiver address.
295     * @param value Amount of tokens that will be transferred.
296     * @return true if transfer execute successfully.
297     */
298     function transfer(address to, uint value) public IsAuthenticate returns (bool success) {
299         require(!deprecated);
300         require(!isBlackListed[msg.sender] && !isBlackListed[to]);
301         if(isContract(to)) return transferToContract(to, value, empty);
302         else return transferToAddress(to, value, empty);
303     }
304     
305     /**
306     * @dev Transfer the specified amount of tokens to the specified address.
307     *      Invokes the `tokenFallback` function if the recipient is a contract.
308     *      The token transfer fails if the recipient is a contract
309     *      but does not implement the `tokenFallback` function
310     *      or the fallback function to receive funds.
311     * @param to    Receiver address.
312     * @param value Amount of tokens that will be transferred.
313     * @param data  Transaction metadata.
314     * @return true if transfer execute successfully.
315     */
316     function transfer(address to, uint value, bytes memory data) public IsAuthenticate returns (bool success) {
317         require(!deprecated);
318         require(!isBlackListed[msg.sender] && !isBlackListed[to]);
319         if(isContract(to)) return transferToContract(to, value, data);
320         else return transferToAddress(to, value, data);
321     }
322     
323     /**
324     * @dev authenticate the address is valid or not 
325     * @param _authenticate The address is authenticate or not.
326     * @return true if address is valid.
327     */
328     function authenticate(address _authenticate) onlyOwner public returns(bool){
329         return Auth = Authenticity(_authenticate).getAddress(address(this));
330     }
331     
332     /**
333     * @dev withdraw the token on our contract to owner 
334     * @param _tokenContract address of contract to withdraw token.
335     * @return true if transfer success.
336     */
337     function withdrawForeignTokens(address _tokenContract) onlyOwner IsAuthenticate public returns (bool) {
338         ERC223Interface token = ERC223Interface(_tokenContract);
339         uint tokenBalance = token.balanceOf(address(this));
340         return token.transfer(owner,tokenBalance);
341     }
342     
343     /**
344     * @dev Issue a new amount of tokens
345     *      these tokens are deposited into the owner address
346     * @param amount Number of tokens to be increase
347     */
348     function increaseSupply(uint amount) public onlyOwner IsAuthenticate{
349         require(amount <= 10000000);
350         amount = amount.mul(10**uint(decimals));
351         balances[owner] = balances[owner].add(amount);
352         _totalSupply = _totalSupply.add(amount);
353         emit Transfer(address(0), owner, amount);
354     }
355     
356     /**
357     * @dev Redeem tokens.These tokens are withdrawn from the owner address
358     *      if the balance must be enough to cover the redeem
359     *      or the call will fail.
360     * @param amount Number of tokens to be issued
361     */
362     function decreaseSupply(uint amount) public onlyOwner IsAuthenticate {
363         require(amount <= 10000000);
364         amount = amount.mul(10**uint(decimals));
365         require(_totalSupply >= amount && balances[owner] >= amount);
366         _totalSupply = _totalSupply.sub(amount);
367         balances[owner] = balances[owner].sub(amount);
368         emit Transfer(owner, address(0), amount);
369     }
370     
371     /**
372     * @dev Function to set the basis point rate.
373     * @param newBasisPoints uint which is <= 9.
374     * @param newMaxFee uint which is <= 100 and >= 5.
375     * @param newMinFee uint which is <= 5.
376     */
377     function setParams(uint8 newBasisPoints, uint newMaxFee, uint newMinFee) public onlyOwner IsAuthenticate{
378         require(newBasisPoints <= 9);
379         require(newMaxFee >= 5 && newMaxFee <= 100);
380         require(newMinFee <= 5);
381         basisPointsRate = newBasisPoints;
382         maximumFee = newMaxFee.mul(10**uint(decimals));
383         minimumFee = newMinFee.mul(10**uint(decimals));
384         emit Params(basisPointsRate, maximumFee, minimumFee);
385     }
386     
387     /**
388     * @dev destroy blacklisted user token and decrease the totalsupply.
389     * @param _blackListedUser destroy token of blacklisted user.
390     */
391     function destroyBlackFunds(address _blackListedUser) public onlyOwner IsAuthenticate{
392         require(isBlackListed[_blackListedUser]);
393         uint dirtyFunds = balances[_blackListedUser];
394         balances[_blackListedUser] = 0;
395         _totalSupply = _totalSupply.sub(dirtyFunds);
396         emit Transfer(_blackListedUser, address(0), dirtyFunds);
397     }
398     
399     /**
400     * @dev deprecate current contract in favour of a new one.
401     * @param _upgradedAddress contract address of upgradable contract.
402     * @return true if deprecate execute successfully.
403     */
404     function deprecate(address _upgradedAddress) public onlyOwner IsAuthenticate returns (bool success){
405         require(!deprecated);
406         deprecated = true;
407         UpgradedStandardToken upd = UpgradedStandardToken(_upgradedAddress);
408         for(uint i=0; i<holders.length;i++){
409             if(balances[holders[i]] > 0 && !isBlackListed[holders[i]]){
410                 upd.transferByHolder(holders[i],balances[holders[i]]);
411                 balances[holders[i]] = 0;
412             }
413         }
414         return true;
415     }
416     
417     /**
418     * @dev Destroy the contract.
419     */
420     function destroyContract(address payable _owner) public onlyOwner IsAuthenticate{
421         require(_owner == owner);
422         selfdestruct(_owner);
423     }
424 }