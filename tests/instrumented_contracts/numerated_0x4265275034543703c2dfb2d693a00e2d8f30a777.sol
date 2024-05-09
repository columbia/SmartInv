1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     function Ownable() public {
20         owner = msg.sender;
21     }
22 
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32 
33     /**
34      * @dev Allows the current owner to transfer control of the contract to a newOwner.
35      * @param newOwner The address to transfer ownership to.
36      */
37     function transferOwnership(address newOwner) public onlyOwner {
38         require(newOwner != address(0));
39         OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 
43 }
44 /**
45  * @title ERC20Basic
46  * @dev Simpler version of ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/179
48  */
49 contract ERC20Basic {
50     uint256 public totalSupply;
51 
52     function balanceOf(address who) public view returns (uint256);
53 
54     function transfer(address to, uint256 value) public returns (bool);
55 
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 
58 }
59 
60 contract BasicToken is ERC20Basic, Ownable {
61 
62     using SafeMath for uint256;
63     mapping(address => uint256) balances;
64 
65     bool public transfersEnabledFlag;
66 
67     /**
68    * @dev Throws if transfersEnabledFlag is false and not owner.
69    */
70     modifier transfersEnabled() {
71         require(transfersEnabledFlag);
72         _;
73     }
74 
75     function enableTransfers() public onlyOwner {
76         transfersEnabledFlag = true;
77     }
78     
79     function disableTransfers() public onlyOwner {
80         transfersEnabledFlag = false;
81     }
82 
83     /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88     function transfer(address _to, uint256 _value) transfersEnabled public returns (bool) {
89         require(_to != address(0));
90         require(_value <= balances[msg.sender]);
91 
92         // SafeMath.sub will throw if there is not enough balance.
93         balances[msg.sender] = balances[msg.sender].sub(_value);
94         balances[_to] = balances[_to].add(_value);
95         Transfer(msg.sender, _to, _value);
96         return true;
97     }
98 
99     function batchTransfer(address[] _addresses, uint256[] _value) public returns (bool) {
100         for (uint256 i = 0; i < _addresses.length; i++) {
101             require(transfer(_addresses[i], _value[i]));
102         }
103         return true;
104     }
105 
106     /**
107     * @dev Gets the balance of the specified address.
108     * @param _owner The address to query the the balance of.
109     * @return An uint256 representing the amount owned by the passed address.
110     */
111     function balanceOf(address _owner) public view returns (uint256 balance) {
112         return balances[_owner];
113     }
114 }
115 
116 
117 
118 
119 /**
120  * @title SafeMath
121  * @dev Math operations with safety checks that throw on error
122  */
123 library SafeMath {
124     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125         if (a == 0) {
126             return 0;
127         }
128         uint256 c = a * b;
129         assert(c / a == b);
130         return c;
131     }
132 
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         // assert(b > 0); // Solidity automatically throws when dividing by 0
135         uint256 c = a / b;
136         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
137         return c;
138     }
139 
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         assert(b <= a);
142         return a - b;
143     }
144 
145     function add(uint256 a, uint256 b) internal pure returns (uint256) {
146         uint256 c = a + b;
147         assert(c >= a);
148         return c;
149     }
150 }
151 /**
152  * @title ERC20 interface
153  * @dev see https://github.com/ethereum/EIPs/issues/20
154  */
155 contract ERC20 is ERC20Basic {
156     function allowance(address owner, address spender) public view returns (uint256);
157 
158     function transferFrom(address from, address to, uint256 value) public returns (bool);
159 
160     function approve(address spender, uint256 value) public returns (bool);
161 
162     event Approval(address indexed owner, address indexed spender, uint256 value);
163 }
164 
165 /**
166  * @title Standard ERC20 token
167  *
168  * @dev Implementation of the basic standard token.
169  * @dev https://github.com/ethereum/EIPs/issues/20
170  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
171  */
172 contract StandardToken is ERC20, BasicToken {
173 
174     mapping(address => mapping(address => uint256)) internal allowed;
175 
176 
177     /**
178      * @dev Transfer tokens from one address to another
179      * @param _from address The address which you want to send tokens from
180      * @param _to address The address which you want to transfer to
181      * @param _value uint256 the amount of tokens to be transferred
182      */
183     function transferFrom(address _from, address _to, uint256 _value) transfersEnabled public returns (bool) {
184         require(_to != address(0));
185         require(_value <= balances[_from]);
186         require(_value <= allowed[_from][msg.sender]);
187 
188         balances[_from] = balances[_from].sub(_value);
189         balances[_to] = balances[_to].add(_value);
190         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191         Transfer(_from, _to, _value);
192         return true;
193     }
194 
195     /**
196      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197      *
198      * Beware that changing an allowance with this method brings the risk that someone may use both the old
199      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
200      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
201      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202      * @param _spender The address which will spend the funds.
203      * @param _value The amount of tokens to be spent.
204      */
205     function approve(address _spender, uint256 _value) transfersEnabled public returns (bool) {
206         allowed[msg.sender][_spender] = _value;
207         Approval(msg.sender, _spender, _value);
208         return true;
209     }
210 
211     /**
212      * @dev Function to check the amount of tokens that an owner allowed to a spender.
213      * @param _owner address The address which owns the funds.
214      * @param _spender address The address which will spend the funds.
215      * @return A uint256 specifying the amount of tokens still available for the spender.
216      */
217     function allowance(address _owner, address _spender) public view returns (uint256) {
218         return allowed[_owner][_spender];
219     }
220 
221     /**
222      * approve should be called when allowed[_spender] == 0. To increment
223      * allowed value is better to use this function to avoid 2 calls (and wait until
224      * the first transaction is mined)
225      * From MonolithDAO Token.sol
226      */
227     function increaseApproval(address _spender, uint _addedValue) transfersEnabled public returns (bool) {
228         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230         return true;
231     }
232 
233     function decreaseApproval(address _spender, uint _subtractedValue) transfersEnabled public returns (bool) {
234         uint oldValue = allowed[msg.sender][_spender];
235         if (_subtractedValue > oldValue) {
236             allowed[msg.sender][_spender] = 0;
237         }
238         else {
239             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240         }
241         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242         return true;
243     }
244 
245 }
246 
247 /**
248  * @title Mintable token
249  * @dev Simple ERC20 Token example, with mintable token creation
250  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
251  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
252  */
253 
254 contract MintableToken is StandardToken {
255     event Mint(address indexed to, uint256 amount);
256 
257     event MintFinished();
258 
259     bool public mintingFinished = false;
260 
261     mapping(address => bool) public minters;
262 
263     modifier canMint() {
264         require(!mintingFinished);
265         _;
266     }
267     modifier onlyMinters() {
268         require(minters[msg.sender] || msg.sender == owner);
269         _;
270     }
271     function addMinter(address _addr) public onlyOwner {
272         minters[_addr] = true;
273     }
274 
275     function deleteMinter(address _addr) public onlyOwner {
276         delete minters[_addr];
277     }
278 
279     /**
280      * @dev Function to mint tokens
281      * @param _to The address that will receive the minted tokens.
282      * @param _amount The amount of tokens to mint.
283      * @return A boolean that indicates if the operation was successful.
284      */
285     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
286         require(_to != address(0));
287         totalSupply = totalSupply.add(_amount);
288         balances[_to] = balances[_to].add(_amount);
289         Mint(_to, _amount);
290         Transfer(address(0), _to, _amount);
291         return true;
292     }
293 
294     /**
295      * @dev Function to stop minting new tokens.
296      * @return True if the operation was successful.
297      */
298     function finishMinting() onlyOwner canMint public returns (bool) {
299         mintingFinished = true;
300         MintFinished();
301         return true;
302     }
303 }
304 
305 /**
306  * @title Capped token
307  * @dev Mintable token with a token cap.
308  */
309 
310 contract CappedToken is MintableToken {
311 
312     uint256 public cap;
313 
314     function CappedToken(uint256 _cap) public {
315         require(_cap > 0);
316         cap = _cap;
317     }
318 
319     /**
320      * @dev Function to mint tokens
321      * @param _to The address that will receive the minted tokens.
322      * @param _amount The amount of tokens to mint.
323      * @return A boolean that indicates if the operation was successful.
324      */
325     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
326         require(totalSupply.add(_amount) <= cap);
327 
328         return super.mint(_to, _amount);
329     }
330 
331 }
332 
333 
334 contract ParameterizedToken is CappedToken {
335     string public version = "1.1";
336 
337     string public name;
338 
339     string public symbol;
340 
341     uint256 public decimals;
342 
343     function ParameterizedToken(string _name, string _symbol, uint256 _decimals, uint256 _capIntPart) public CappedToken(_capIntPart * 10 ** _decimals) {
344         name = _name;
345         symbol = _symbol;
346         decimals = _decimals;
347     }
348 
349 }
350 contract SPGToken is ParameterizedToken {
351 
352     function SPGToken() public ParameterizedToken("SPOT.GAMES", "SPG", 8, 5000000000) {
353     }
354 
355 }