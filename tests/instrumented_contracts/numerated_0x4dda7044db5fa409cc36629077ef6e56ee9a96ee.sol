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
79     /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84     function transfer(address _to, uint256 _value) transfersEnabled public returns (bool) {
85         require(_to != address(0));
86         require(_value <= balances[msg.sender]);
87 
88         // SafeMath.sub will throw if there is not enough balance.
89         balances[msg.sender] = balances[msg.sender].sub(_value);
90         balances[_to] = balances[_to].add(_value);
91         Transfer(msg.sender, _to, _value);
92         return true;
93     }
94 
95     function batchTransfer(address[] _addresses, uint256[] _value) public returns (bool) {
96         for (uint256 i = 0; i < _addresses.length; i++) {
97             require(transfer(_addresses[i], _value[i]));
98         }
99         return true;
100     }
101 
102     /**
103     * @dev Gets the balance of the specified address.
104     * @param _owner The address to query the the balance of.
105     * @return An uint256 representing the amount owned by the passed address.
106     */
107     function balanceOf(address _owner) public view returns (uint256 balance) {
108         return balances[_owner];
109     }
110 }
111 
112 
113 
114 
115 /**
116  * @title SafeMath
117  * @dev Math operations with safety checks that throw on error
118  */
119 library SafeMath {
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         if (a == 0) {
122             return 0;
123         }
124         uint256 c = a * b;
125         assert(c / a == b);
126         return c;
127     }
128 
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         // assert(b > 0); // Solidity automatically throws when dividing by 0
131         uint256 c = a / b;
132         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133         return c;
134     }
135 
136     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137         assert(b <= a);
138         return a - b;
139     }
140 
141     function add(uint256 a, uint256 b) internal pure returns (uint256) {
142         uint256 c = a + b;
143         assert(c >= a);
144         return c;
145     }
146 }
147 /**
148  * @title ERC20 interface
149  * @dev see https://github.com/ethereum/EIPs/issues/20
150  */
151 contract ERC20 is ERC20Basic {
152     function allowance(address owner, address spender) public view returns (uint256);
153 
154     function transferFrom(address from, address to, uint256 value) public returns (bool);
155 
156     function approve(address spender, uint256 value) public returns (bool);
157 
158     event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 /**
162  * @title Standard ERC20 token
163  *
164  * @dev Implementation of the basic standard token.
165  * @dev https://github.com/ethereum/EIPs/issues/20
166  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  */
168 contract StandardToken is ERC20, BasicToken {
169 
170     mapping(address => mapping(address => uint256)) internal allowed;
171 
172 
173     /**
174      * @dev Transfer tokens from one address to another
175      * @param _from address The address which you want to send tokens from
176      * @param _to address The address which you want to transfer to
177      * @param _value uint256 the amount of tokens to be transferred
178      */
179     function transferFrom(address _from, address _to, uint256 _value) transfersEnabled public returns (bool) {
180         require(_to != address(0));
181         require(_value <= balances[_from]);
182         require(_value <= allowed[_from][msg.sender]);
183 
184         balances[_from] = balances[_from].sub(_value);
185         balances[_to] = balances[_to].add(_value);
186         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187         Transfer(_from, _to, _value);
188         return true;
189     }
190 
191     /**
192      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193      *
194      * Beware that changing an allowance with this method brings the risk that someone may use both the old
195      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198      * @param _spender The address which will spend the funds.
199      * @param _value The amount of tokens to be spent.
200      */
201     function approve(address _spender, uint256 _value) transfersEnabled public returns (bool) {
202         allowed[msg.sender][_spender] = _value;
203         Approval(msg.sender, _spender, _value);
204         return true;
205     }
206 
207     /**
208      * @dev Function to check the amount of tokens that an owner allowed to a spender.
209      * @param _owner address The address which owns the funds.
210      * @param _spender address The address which will spend the funds.
211      * @return A uint256 specifying the amount of tokens still available for the spender.
212      */
213     function allowance(address _owner, address _spender) public view returns (uint256) {
214         return allowed[_owner][_spender];
215     }
216 
217     /**
218      * approve should be called when allowed[_spender] == 0. To increment
219      * allowed value is better to use this function to avoid 2 calls (and wait until
220      * the first transaction is mined)
221      * From MonolithDAO Token.sol
222      */
223     function increaseApproval(address _spender, uint _addedValue) transfersEnabled public returns (bool) {
224         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226         return true;
227     }
228 
229     function decreaseApproval(address _spender, uint _subtractedValue) transfersEnabled public returns (bool) {
230         uint oldValue = allowed[msg.sender][_spender];
231         if (_subtractedValue > oldValue) {
232             allowed[msg.sender][_spender] = 0;
233         }
234         else {
235             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236         }
237         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238         return true;
239     }
240 
241 }
242 
243 /**
244  * @title Mintable token
245  * @dev Simple ERC20 Token example, with mintable token creation
246  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
247  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
248  */
249 
250 contract MintableToken is StandardToken {
251     event Mint(address indexed to, uint256 amount);
252 
253     event MintFinished();
254 
255     bool public mintingFinished = false;
256 
257     mapping(address => bool) public minters;
258 
259     modifier canMint() {
260         require(!mintingFinished);
261         _;
262     }
263     modifier onlyMinters() {
264         require(minters[msg.sender] || msg.sender == owner);
265         _;
266     }
267     function addMinter(address _addr) public onlyOwner {
268         require(_addr != address(0));
269         minters[_addr] = true;
270     }
271 
272     function deleteMinter(address _addr) public onlyOwner {
273         require(_addr != address(0));
274         delete minters[_addr];
275     }
276 
277     /**
278      * @dev Function to mint tokens
279      * @param _to The address that will receive the minted tokens.
280      * @param _amount The amount of tokens to mint.
281      * @return A boolean that indicates if the operation was successful.
282      */
283     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
284         require(_to != address(0));
285         totalSupply = totalSupply.add(_amount);
286         balances[_to] = balances[_to].add(_amount);
287         Mint(_to, _amount);
288         Transfer(address(0), _to, _amount);
289         return true;
290     }
291 
292     /**
293      * @dev Function to stop minting new tokens.
294      * @return True if the operation was successful.
295      */
296     function finishMinting() onlyOwner canMint public returns (bool) {
297         mintingFinished = true;
298         MintFinished();
299         return true;
300     }
301 }
302 
303 /**
304  * @title Capped token
305  * @dev Mintable token with a token cap.
306  */
307 
308 contract CappedToken is MintableToken {
309 
310     uint256 public cap;
311 
312     function CappedToken(uint256 _cap) public {
313         require(_cap > 0);
314         cap = _cap;
315     }
316 
317     /**
318      * @dev Function to mint tokens
319      * @param _to The address that will receive the minted tokens.
320      * @param _amount The amount of tokens to mint.
321      * @return A boolean that indicates if the operation was successful.
322      */
323     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
324         require(totalSupply.add(_amount) <= cap);
325 
326         return super.mint(_to, _amount);
327     }
328 
329 }
330 
331 
332 contract ParameterizedToken is CappedToken {
333     //1.3 update add minter/delete minter address validation
334     string public version = "1.3";
335 
336     string public name;
337 
338     string public symbol;
339 
340     uint256 public decimals;
341 
342     function ParameterizedToken(string _name, string _symbol, uint256 _decimals, uint256 _capIntPart) public CappedToken(_capIntPart * 10 ** _decimals) {
343         name = _name;
344         symbol = _symbol;
345         decimals = _decimals;
346     }
347 
348 }
349 
350 contract LINCToken is ParameterizedToken {
351 
352     function LINCToken() public ParameterizedToken("linkcloud", "LINC", 18, 1000000000) {
353     }
354 
355 }