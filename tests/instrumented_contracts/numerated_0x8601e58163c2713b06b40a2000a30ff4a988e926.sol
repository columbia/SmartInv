1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     uint256 public totalSupply;
10 
11     function balanceOf(address who) public view returns (uint256);
12 
13     function transfer(address to, uint256 value) public returns (bool);
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 
17 }
18 
19 /**
20  * @title ERC20Standard interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20Standard is ERC20Basic {
24     function allowance(address owner, address spender) public view returns (uint256);
25 
26     function transferFrom(address from, address to, uint256 value) public returns (bool);
27 
28     function approve(address spender, uint256 value) public returns (bool);
29 
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 library SafeMath {
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42         uint256 c = a * b;
43         assert(c / a == b);
44         return c;
45     }
46 
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         // assert(b > 0); // Solidity automatically throws when dividing by 0
49         uint256 c = a / b;
50         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51         return c;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         assert(b <= a);
56         return a - b;
57     }
58 
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         assert(c >= a);
62         return c;
63     }
64 }
65 
66 /**
67  * @title Ownable
68  * @dev The Ownable contract has an owner address, and provides basic authorization control
69  * functions, this simplifies the implementation of "user permissions".
70  */
71 contract Ownable {
72 
73     address public owner;
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77 
78     /**
79      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80      * account.
81      */
82     function Ownable() public {
83         owner = msg.sender;
84     }
85 
86 
87     /**
88      * @dev Throws if called by any account other than the owner.
89      */
90     modifier onlyOwner() {
91         require(msg.sender == owner);
92         _;
93     }
94 
95 
96     /**
97      * @dev Allows the current owner to transfer control of the contract to a newOwner.
98      * @param newOwner The address to transfer ownership to.
99      */
100     function transferOwnership(address newOwner) public onlyOwner {
101         require(newOwner != address(0));
102         OwnershipTransferred(owner, newOwner);
103         owner = newOwner;
104     }
105 
106 }
107 
108 
109 contract BasicToken is ERC20Basic, Ownable {
110 
111     using SafeMath for uint256;
112     mapping(address => uint256) balances;
113 
114     bool public transfersEnabledFlag;
115 
116     /**
117    * @dev Throws if transfersEnabledFlag is false and not owner.
118    */
119     modifier transfersEnabled() {
120         require(transfersEnabledFlag);
121         _;
122     }
123 
124     function enableTransfers() public onlyOwner {
125         transfersEnabledFlag = true;
126     }
127 
128     /**
129   * @dev transfer token for a specified address
130   * @param _to The address to transfer to.
131   * @param _value The amount to be transferred.
132   */
133     function transfer(address _to, uint256 _value) transfersEnabled public returns (bool) {
134         require(_to != address(0));
135         require(_value <= balances[msg.sender]);
136 
137         // SafeMath.sub will throw if there is not enough balance.
138         balances[msg.sender] = balances[msg.sender].sub(_value);
139         balances[_to] = balances[_to].add(_value);
140         Transfer(msg.sender, _to, _value);
141         return true;
142     }
143 
144     function batchTransfer(address[] _addresses, uint256[] _value) public returns (bool) {
145         for (uint256 i = 0; i < _addresses.length; i++) {
146             require(transfer(_addresses[i], _value[i]));
147         }
148         return true;
149     }
150 
151     /**
152     * @dev Gets the balance of the specified address.
153     * @param _owner The address to query the the balance of.
154     * @return An uint256 representing the amount owned by the passed address.
155     */
156     function balanceOf(address _owner) public view returns (uint256 balance) {
157         return balances[_owner];
158     }
159 }
160 
161 
162 
163 
164 /**
165  * @title Standard ERC20 token
166  *
167  * @dev Implementation of the basic standard token.
168  * @dev https://github.com/ethereum/EIPs/issues/20
169  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
170  */
171 contract StandardToken is ERC20Standard, BasicToken {
172 
173     //set more spenders mapping
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
272         require(_addr != address(0));
273         minters[_addr] = true;
274     }
275 
276     function deleteMinter(address _addr) public onlyOwner {
277         require(_addr != address(0));
278         delete minters[_addr];
279     }
280 
281     /**
282      * @dev Function to mint tokens
283      * @param _to The address that will receive the minted tokens.
284      * @param _amount The amount of tokens to mint.
285      * @return A boolean that indicates if the operation was successful.
286      */
287     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
288         require(_to != address(0));
289         totalSupply = totalSupply.add(_amount);
290         balances[_to] = balances[_to].add(_amount);
291         Mint(_to, _amount);
292         Transfer(address(0), _to, _amount);
293         return true;
294     }
295 
296     /**
297      * @dev Function to stop minting new tokens.
298      * @return True if the operation was successful.
299      */
300     function finishMinting() onlyOwner canMint public returns (bool) {
301         mintingFinished = true;
302         MintFinished();
303         return true;
304     }
305 }
306 
307 /**
308  * @title Capped token
309  * @dev Mintable token with a token cap.
310  */
311 
312 contract CappedToken is MintableToken {
313 
314     uint256 public cap;
315 
316     function CappedToken(uint256 _cap) public {
317         require(_cap > 0);
318         cap = _cap;
319     }
320 
321     /**
322      * @dev Function to mint tokens
323      * @param _to The address that will receive the minted tokens.
324      * @param _amount The amount of tokens to mint.
325      * @return A boolean that indicates if the operation was successful.
326      */
327     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
328         require(totalSupply.add(_amount) <= cap);
329 
330         return super.mint(_to, _amount);
331     }
332 
333 }
334 
335 
336 contract CustomToken is CappedToken {
337     //1.3 update add minter/delete minter address validation
338     string public version = "1.3";
339 
340     string public name;
341 
342     string public symbol;
343 
344     uint256 public decimals;
345 
346     function CustomToken(uint256 _capIntPart, string _name, string _symbol, uint256 _decimals) public CappedToken(_capIntPart * 10 ** _decimals) {
347         name = _name;
348         symbol = _symbol;
349         decimals = _decimals;
350     }
351 
352 }