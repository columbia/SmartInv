1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43     uint256 public totalSupply;
44     function balanceOf(address who) public view returns (uint256);
45     function transfer(address to, uint256 value) public returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 
50 /**
51  * @title Basic token
52  * @dev Basic version of StandardToken, with no allowances.
53  */
54 contract BasicToken is ERC20Basic {
55     using SafeMath for uint256;
56 
57     mapping(address => uint256) balances;
58 
59     /**
60     * @dev transfer token for a specified address
61     * @param _to The address to transfer to.
62     * @param _value The amount to be transferred.
63     */
64     function transfer(address _to, uint256 _value) public returns (bool) {
65         require(_to != address(0));
66         require(_value <= balances[msg.sender]);
67 
68         // SafeMath.sub will throw if there is not enough balance.
69         balances[msg.sender] = balances[msg.sender].sub(_value);
70         balances[_to] = balances[_to].add(_value);
71         emit Transfer(msg.sender, _to, _value);
72         return true;
73     }
74 
75     /**
76     * @dev Gets the balance of the specified address.
77     * @param _owner The address to query the the balance of.
78     * @return An uint256 representing the amount owned by the passed address.
79     */
80     function balanceOf(address _owner) public view returns (uint256) {
81         return balances[_owner];
82     }
83 
84 }
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 contract ERC20 is ERC20Basic {
91     function allowance(address owner, address spender) public view returns (uint256);
92     function transferFrom(address from, address to, uint256 value) public returns (bool);
93     function approve(address spender, uint256 value) public returns (bool);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 
98 /**
99  * @title Standard ERC20 token
100  *
101  * @dev Implementation of the basic standard token.
102  * @dev https://github.com/ethereum/EIPs/issues/20
103  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
104  */
105 contract StandardToken is ERC20, BasicToken {
106 
107     mapping (address => mapping (address => uint256)) internal allowed;
108 
109 
110     /**
111     * @dev Transfer tokens from one address to another
112     * @param _from address The address which you want to send tokens from
113     * @param _to address The address which you want to transfer to
114     * @param _value uint256 the amount of tokens to be transferred
115     */
116     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
117         require(_value <= balances[_from]);
118         require(_value <= allowed[_from][msg.sender]);
119 
120         balances[_from] = balances[_from].sub(_value);
121         balances[_to] = balances[_to].add(_value);
122         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123         emit Transfer(_from, _to, _value);
124         return true;
125     }
126 
127     /**
128     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
129     *
130     * Beware that changing an allowance with this method brings the risk that someone may use both the old
131     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
132     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
133     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134     * @param _spender The address which will spend the funds.
135     * @param _value The amount of tokens to be spent.
136     */
137     function approve(address _spender, uint256 _value) public returns (bool) {
138         allowed[msg.sender][_spender] = _value;
139         emit Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143     /**
144     * @dev Function to check the amount of tokens that an owner allowed to a spender.
145     * @param _owner address The address which owns the funds.
146     * @param _spender address The address which will spend the funds.
147     * @return A uint256 specifying the amount of tokens still available for the spender.
148     */
149     function allowance(address _owner, address _spender) public view returns (uint256) {
150         return allowed[_owner][_spender];
151     }
152 
153     /**
154     * @dev Increase the amount of tokens that an owner allowed to a spender.
155     *
156     * approve should be called when allowed[_spender] == 0. To increment
157     * allowed value is better to use this function to avoid 2 calls (and wait until
158     * the first transaction is mined)
159     * From MonolithDAO Token.sol
160     * @param _spender The address which will spend the funds.
161     * @param _addedValue The amount of tokens to increase the allowance by.
162     */
163     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
164         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
165         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166         return true;
167     }
168 
169     /**
170     * @dev Decrease the amount of tokens that an owner allowed to a spender.
171     *
172     * approve should be called when allowed[_spender] == 0. To decrement
173     * allowed value is better to use this function to avoid 2 calls (and wait until
174     * the first transaction is mined)
175     * From MonolithDAO Token.sol
176     * @param _spender The address which will spend the funds.
177     * @param _subtractedValue The amount of tokens to decrease the allowance by.
178     */
179     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
180         uint oldValue = allowed[msg.sender][_spender];
181         if (_subtractedValue > oldValue) {
182             allowed[msg.sender][_spender] = 0;
183         } else {
184             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
185         }
186         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187         return true;
188     }
189 
190 }
191 
192 contract BurnableToken is StandardToken {
193 
194     event Burn(address indexed burner, uint256 value);
195 
196     /**
197     * @dev Burns a specific amount of tokens.
198     * @param _value The amount of token to be burned.
199     */
200     function burn(uint256 _value) public {
201         _burn(msg.sender, _value);
202     }
203 
204     function _burn(address _who, uint256 _value) internal {
205         require(_value <= balances[_who]);
206         // no need to require value <= totalSupply, since that would imply the
207         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
208 
209         balances[_who] = balances[_who].sub(_value);
210         totalSupply = totalSupply.sub(_value);
211         emit Burn(_who, _value);
212         emit Transfer(_who, address(0), _value);
213     }
214 }
215 
216 
217 
218 /**
219  * @title Ownable
220  * @dev The Ownable contract has an owner address, and provides basic authorization control
221  * functions, this simplifies the implementation of "user permissions".
222  */
223 contract Ownable {
224     address public owner;
225 
226 
227     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
228 
229 
230     /**
231     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
232     * account.
233     */
234     function Ownable() public {
235         owner = msg.sender;
236     }
237 
238 
239     /**
240     * @dev Throws if called by any account other than the owner.
241     */
242     modifier onlyOwner() {
243         require(msg.sender == owner);
244         _;
245     }
246 
247 
248     /**
249     * @dev Allows the current owner to transfer control of the contract to a newOwner.
250     * @param newOwner The address to transfer ownership to.
251     */
252     function transferOwnership(address newOwner) public onlyOwner {
253         require(newOwner != address(0));
254         emit OwnershipTransferred(owner, newOwner);
255         owner = newOwner;
256     }
257 
258 }
259 
260 
261 /**
262  * @title Mintable token
263  * @dev Simple ERC20 Token example, with mintable token creation
264  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
265  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
266  */
267 
268 contract MintableToken is BurnableToken, Ownable  {
269     event Mint(address indexed to, uint256 amount);
270     event MintFinished();
271     bool public mintingFinished = false;
272     
273 
274 
275     modifier canMint() {
276         require(!mintingFinished);
277         _;
278     }
279 
280     /**
281     * @dev Function to mint tokens
282     * @param _to The address that will receive the minted tokens.
283     * @param _amount The amount of tokens to mint.
284     * @return A boolean that indicates if the operation was successful.
285     */
286     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
287         totalSupply = totalSupply.add(_amount);
288         balances[_to] = balances[_to].add(_amount);
289         emit Mint(_to, _amount);
290         emit Transfer(address(0), _to, _amount);
291         return true;
292     }
293 
294     /**
295     * @dev Function to stop minting new tokens.
296     * @return True if the operation was successful.
297     */
298     function finishMinting() onlyOwner canMint public returns (bool) {
299         mintingFinished = true;
300         emit MintFinished();
301         return true;
302     }
303 
304     
305 }
306 
307 contract ElepigToken is MintableToken {
308     string public name = "Elepig";
309     string public symbol = "EPG";
310     uint8 public decimals = 18;    
311 
312    // unlock times for Team Wallets
313     uint constant unlockY1Time = 1546300800; //  Tuesday, January 1, 2019 12:00:00 AM
314     uint constant unlockY2Time = 1577836800; //  Wednesday, January 1, 2020 12:00:00 AM
315     uint constant unlockY3Time = 1609459200; //  Friday, January 1, 2021 12:00:00 AM
316     uint constant unlockY4Time = 1640995200; //  Saturday, January 1, 2022 12:00:00 AM
317          
318     mapping (address => uint256) public freezeOf;
319     
320     address affiliate;
321     address contingency;
322     address advisor;  
323 
324     // team vesting plan wallets
325     address team; 
326     address teamY1; 
327     address teamY2; 
328     address teamY3; 
329     address teamY4; 
330     bool public mintedWallets = false;
331     
332     // tokens to be minted straight away
333     //=============================    
334     // 50% of tokens will be minted during presale & ico, 50% now
335 
336     uint256 constant affiliateTokens = 7500000000000000000000000;      // 2.5% 
337     uint256 constant contingencyTokens = 52500000000000000000000000;   // 17.5%
338     uint256 constant advisorTokens = 30000000000000000000000000;       // 10%   
339     uint256 constant teamTokensPerWallet = 12000000000000000000000000;  // 20% of 60MM EPG team fund - vesting program 
340 
341     
342    
343     event Unfreeze(address indexed from, uint256 value);
344     event Freeze(address indexed from, uint256 value);
345     event WalletsMinted();
346 
347 
348     // constructor - null 
349     function ElepigToken() public {
350         
351     }
352     
353     // mints ElePig wallets
354     function mintWallets(                
355         address _affiliateAddress, 
356         address _contingencyAddress, 
357         address _advisorAddress,         
358         address _teamAddress, 
359         address _teamY1Address, 
360         address _teamY2Address, 
361         address _teamY3Address, 
362         address _teamY4Address
363         ) public  onlyOwner {  
364         require(_affiliateAddress != address(0));
365         require(_contingencyAddress != address(0));
366         require(_advisorAddress != address(0));
367         require(_teamAddress != address(0));
368         require(_teamY1Address != address(0));
369         require(_teamY2Address != address(0));
370         require(_teamY3Address != address(0));
371         require(_teamY4Address != address(0)); 
372         require(mintedWallets == false); // can only call function once
373         
374             
375         affiliate = _affiliateAddress;
376         contingency = _contingencyAddress;
377         advisor = _advisorAddress;
378 
379         // team vesting plan wallets each year 20%
380         team = _teamAddress;
381         teamY1 = _teamY1Address;
382         teamY2 = _teamY2Address;
383         teamY3 = _teamY3Address;
384         teamY4 = _teamY4Address;
385         
386         // mint coins immediately that aren't for crowdsale
387         mint(affiliate, affiliateTokens);
388         mint(contingency, contingencyTokens);
389         mint(advisor, advisorTokens);
390         mint(team, teamTokensPerWallet);
391         mint(teamY1, teamTokensPerWallet); // These will be locked for transfer until 01/01/2019 00:00:00
392         mint(teamY2, teamTokensPerWallet); // These will be locked for transfer until 01/01/2020 00:00:00
393         mint(teamY3, teamTokensPerWallet); // These will be locked for transfer until 01/01/2021 00:00:00
394         mint(teamY4, teamTokensPerWallet); // These will be locked for transfer until 01/01/2022 00:00:00
395 
396         mintedWallets = true;
397         emit WalletsMinted();
398     }
399 
400     function checkPermissions(address _from) internal view returns (bool) {        
401         // team vesting, a wallet gets unlocked each year.
402         if (_from == teamY1 && now < unlockY1Time) {
403             return false;
404         } else if (_from == teamY2 && now < unlockY2Time) {
405             return false;
406         } else if (_from == teamY3 && now < unlockY3Time) {
407             return false;
408         } else if (_from == teamY4 && now < unlockY4Time) {
409             return false;
410         } else {
411         //all other addresses are not locked
412             return true;
413         } 
414     }
415 
416     // check Permissions before transfer
417     function transfer(address _to, uint256 _value) public returns (bool) {
418 
419         require(checkPermissions(msg.sender));
420         super.transfer(_to, _value);
421     }
422 
423     // check Permissions before transfer
424     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
425 
426         require(checkPermissions(_from));
427         super.transferFrom(_from, _to, _value);
428     }
429 
430     function () public payable {
431         revert();
432     }
433 }