1 pragma solidity ^0.4.0;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     uint256 public totalSupply;
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Burn(address indexed from, uint256 value);
14 }
15 
16 library SafeMath {
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         if (a == 0) {
19             return 0;
20         }
21         uint256 c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract Ownable {
46     address public owner;
47 
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52     /**
53     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54     * account.
55     */
56     constructor() public {
57         owner = msg.sender;
58     }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63     modifier onlyOwner() {
64         require(msg.sender == owner);
65         _;
66     }
67 
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73     function transferOwnership(address newOwner) public onlyOwner {
74         require(newOwner != address(0));
75         emit OwnershipTransferred(owner, newOwner);
76         owner = newOwner;
77     }
78 
79 }
80 
81 contract BasicToken is ERC20Basic, Ownable {
82 
83     using SafeMath for uint256;
84     mapping (address => uint256) balances;
85 
86     bool public transfersEnabledFlag;
87 
88     /**
89    * @dev Throws if transfersEnabledFlag is false and not owner.
90    */
91     modifier transfersEnabled() {
92         require(transfersEnabledFlag);
93         _;
94     }
95 
96     function enableTransfers() public onlyOwner {
97         transfersEnabledFlag = true;
98     }
99 
100     /**
101   * @dev transfer token for a specified address
102   * @param _to The address to transfer to.
103   * @param _value The amount to be transferred.
104   */
105     function transfer(address _to, uint256 _value)  public returns (bool) {
106         require(_to != address(0));
107         require(_value <= balances[msg.sender]);
108 
109         // SafeMath.sub will throw if there is not enough balance.
110         balances[msg.sender] = balances[msg.sender].sub(_value);
111         balances[_to] = balances[_to].add(_value);
112         emit Transfer(msg.sender, _to, _value);
113         return true;
114     }
115 
116     /**
117     * @dev Gets the balance of the specified address.
118     * @param _owner The address to query the the balance of.
119     * @return An uint256 representing the amount owned by the passed address.
120     */
121     function balanceOf(address _owner) public view returns (uint256 balance) {
122         return balances[_owner];
123     }
124 }
125 contract ERC20 is ERC20Basic {
126     function allowance(address owner, address spender) public view returns (uint256);
127     function transferFrom(address from, address to, uint256 value) public returns (bool);
128     function approve(address spender, uint256 value) public returns (bool);
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 
133 /**
134  * @title Standard ERC20 token
135  *
136  * @dev Implementation of the basic standard token.
137  * @dev https://github.com/ethereum/EIPs/issues/20
138  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  */
140 contract StandardToken is ERC20, BasicToken {
141 
142     mapping (address => mapping (address => uint256)) internal allowed;
143 
144 
145     /**
146      * @dev Transfer tokens from one address to another
147      * @param _from address The address which you want to send tokens from
148      * @param _to address The address which you want to transfer to
149      * @param _value uint256 the amount of tokens to be transferred
150      */
151     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
152         require(_to != address(0));
153         require(_value <= balances[_from]);
154         require(_value <= allowed[_from][msg.sender]);
155 
156         balances[_from] = balances[_from].sub(_value);
157         balances[_to] = balances[_to].add(_value);
158         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159         emit Transfer(_from, _to, _value);
160         return true;
161     }
162 
163     /**
164      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165      *
166      * Beware that changing an allowance with this method brings the risk that someone may use both the old
167      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170      * @param _spender The address which will spend the funds.
171      * @param _value The amount of tokens to be spent.
172      */
173     function approve(address _spender, uint256 _value) public returns (bool) {
174         allowed[msg.sender][_spender] = _value;
175         emit Approval(msg.sender, _spender, _value);
176         return true;
177     }
178 
179     /**
180      * @dev Function to check the amount of tokens that an owner allowed to a spender.
181      * @param _owner address The address which owns the funds.
182      * @param _spender address The address which will spend the funds.
183      * @return A uint256 specifying the amount of tokens still available for the spender.
184      */
185     function allowance(address _owner, address _spender) public view returns (uint256) {
186         return allowed[_owner][_spender];
187     }
188 
189     /**
190      * approve should be called when allowed[_spender] == 0. To increment
191      * allowed value is better to use this function to avoid 2 calls (and wait until
192      * the first transaction is mined)
193      * From MonolithDAO Token.sol
194      */
195     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
196         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
197         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198         return true;
199     }
200 
201     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
202         uint oldValue = allowed[msg.sender][_spender];
203         if (_subtractedValue > oldValue) {
204             allowed[msg.sender][_spender] = 0;
205         }
206         else {
207             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
208         }
209         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210         return true;
211     }
212 
213 }
214 /**
215  * @title Mintable token
216  * @dev Simple ERC20 Token example, with mintable token creation
217  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
218  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
219  */
220 
221 contract MintableToken is StandardToken {
222     event Mint(address indexed to, uint256 amount);
223 
224     event MintFinished();
225 
226     bool public mintingFinished = false;
227 
228     mapping(address => bool) public minters;
229 
230     modifier canMint() {
231         require(!mintingFinished);
232         _;
233     }
234     modifier onlyMinters() {
235         require(minters[msg.sender] || msg.sender == owner);
236         _;
237     }
238     function addMinter(address _addr) public onlyOwner  {
239         minters[_addr] = true;
240     }
241 
242     function deleteMinter(address _addr) public onlyOwner {
243         delete minters[_addr];
244     }
245 
246     /**
247      * @dev Function to mint tokens
248      * @param _to The address that will receive the minted tokens.
249      * @param _amount The amount of tokens to mint.
250      * @return A boolean that indicates if the operation was successful.
251      */
252     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
253         totalSupply = totalSupply.add(_amount);
254         balances[_to] = balances[_to].add(_amount);
255         emit Mint(_to, _amount);
256         emit Transfer(address(0), _to, _amount);
257         return true;
258     }
259 
260     /**
261      * @dev Function to stop minting new tokens.
262      * @return True if the operation was successful.
263      */
264     function finishMinting() onlyOwner canMint public returns (bool) {
265         mintingFinished = true;
266         emit MintFinished();
267         return true;
268     }
269 }
270 
271 /**
272  * @title Capped token
273  * @dev Mintable token with a token cap.
274  */
275 
276 contract CappedToken is MintableToken {
277 
278     uint256 public cap;
279 
280     constructor(uint256 _cap) public {
281         require(_cap > 0);
282         cap = _cap;
283     }
284 
285 
286     /**
287      * @dev Function to mint tokens
288      * @param _to The address that will receive the minted tokens.
289      * @param _amount The amount of tokens to mint.
290      * @return A boolean that indicates if the operation was successful.
291      */
292     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
293         require(totalSupply.add(_amount) <= cap);
294 
295         return super.mint(_to, _amount);
296     }
297 
298 }
299 
300 contract TokenParam {
301 	/**
302 	 * 小数点位数
303 	 */
304     uint256 public constant decimals = 18;
305 
306 	/**
307 	 * 总量
308 	 */
309     uint256 public  totalSupply = 500 * 10 ** decimals;
310 
311 }
312 
313 contract AIAISIToken is CappedToken,TokenParam {
314     string public constant name = "AIDOC-AISI";
315 
316     string public constant symbol = "AIDOC-AISI";
317 
318     constructor() public CappedToken(totalSupply) {
319         balances[msg.sender] = totalSupply;
320     }
321     function burn(uint256 _value)  onlyOwner public returns (bool success) {
322         require(balances[msg.sender] >= _value);   // Check if the sender has enough
323         balances[msg.sender] = balances[msg.sender].sub(_value);       // Subtract from the sender
324         totalSupply = totalSupply.sub(_value);                        // Updates totalSupply
325         emit Burn(msg.sender, _value);
326         return true;
327     }
328     function burnFrom(address _from, uint256 _value)  onlyOwner public returns (bool success) {
329         require(_from!=address(0));
330         require(balances[_from] >= _value);                // Check if the targeted balance is enough
331         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
332         totalSupply = totalSupply.sub(_value);                                // Update totalSupply
333         emit Burn(_from, _value);
334         return true;
335     }
336     function mintToken(address _target, uint256 _value) onlyOwner public returns (bool success)  {
337         require(_target!=address(0));
338         balances[_target] = balances[_target].add(_value);
339         totalSupply = totalSupply.add(_value);
340         emit Transfer(address(0), owner, _value);
341         emit Transfer(owner, _target, _value);
342         return true;
343     }
344 }