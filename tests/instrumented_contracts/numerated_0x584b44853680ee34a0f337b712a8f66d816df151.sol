1 /**
2  * @title ERC20Basic
3  * @dev Simpler version of ERC20 interface
4  * @dev see https://github.com/ethereum/EIPs/issues/179
5  */
6 contract ERC20Basic {
7   uint256 public totalSupply;
8   function balanceOf(address who) public view returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11   
12 }
13 
14 library SafeMath {
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract BasicToken is ERC20Basic, Ownable {
81 
82     using SafeMath for uint256;
83     mapping (address => uint256) balances;
84 
85     bool public transfersEnabledFlag;
86 
87     /**
88    * @dev Throws if transfersEnabledFlag is false and not owner.
89    */
90     modifier transfersEnabled() {
91         require(transfersEnabledFlag);
92         _;
93     }
94 
95     function enableTransfers() public onlyOwner {
96         transfersEnabledFlag = true;
97     }
98 
99     /**
100   * @dev transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104     function transfer(address _to, uint256 _value) transfersEnabled() public returns (bool) {
105         require(_to != address(0));
106         require(_value <= balances[msg.sender]);
107 
108         // SafeMath.sub will throw if there is not enough balance.
109         balances[msg.sender] = balances[msg.sender].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         Transfer(msg.sender, _to, _value);
112         return true;
113     }
114 
115     /**
116     * @dev Gets the balance of the specified address.
117     * @param _owner The address to query the the balance of.
118     * @return An uint256 representing the amount owned by the passed address.
119     */
120     function balanceOf(address _owner) public view returns (uint256 balance) {
121         return balances[_owner];
122     }
123 }
124 contract ERC20 is ERC20Basic {
125   function allowance(address owner, address spender) public view returns (uint256);
126   function transferFrom(address from, address to, uint256 value) public returns (bool);
127   function approve(address spender, uint256 value) public returns (bool);
128   event Approval(address indexed owner, address indexed spender, uint256 value);
129 }
130 
131 
132 /**
133  * @title Standard ERC20 token
134  *
135  * @dev Implementation of the basic standard token.
136  * @dev https://github.com/ethereum/EIPs/issues/20
137  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
138  */
139 contract StandardToken is ERC20, BasicToken {
140 
141     mapping (address => mapping (address => uint256)) internal allowed;
142 
143 
144     /**
145      * @dev Transfer tokens from one address to another
146      * @param _from address The address which you want to send tokens from
147      * @param _to address The address which you want to transfer to
148      * @param _value uint256 the amount of tokens to be transferred
149      */
150     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
151         require(_to != address(0));
152         require(_value <= balances[_from]);
153         require(_value <= allowed[_from][msg.sender]);
154 
155         balances[_from] = balances[_from].sub(_value);
156         balances[_to] = balances[_to].add(_value);
157         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158         Transfer(_from, _to, _value);
159         return true;
160     }
161 
162     /**
163      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164      *
165      * Beware that changing an allowance with this method brings the risk that someone may use both the old
166      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      * @param _spender The address which will spend the funds.
170      * @param _value The amount of tokens to be spent.
171      */
172     function approve(address _spender, uint256 _value) public returns (bool) {
173         allowed[msg.sender][_spender] = _value;
174         Approval(msg.sender, _spender, _value);
175         return true;
176     }
177 
178     /**
179      * @dev Function to check the amount of tokens that an owner allowed to a spender.
180      * @param _owner address The address which owns the funds.
181      * @param _spender address The address which will spend the funds.
182      * @return A uint256 specifying the amount of tokens still available for the spender.
183      */
184     function allowance(address _owner, address _spender) public view returns (uint256) {
185         return allowed[_owner][_spender];
186     }
187 
188     /**
189      * approve should be called when allowed[_spender] == 0. To increment
190      * allowed value is better to use this function to avoid 2 calls (and wait until
191      * the first transaction is mined)
192      * From MonolithDAO Token.sol
193      */
194     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197         return true;
198     }
199 
200     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
201         uint oldValue = allowed[msg.sender][_spender];
202         if (_subtractedValue > oldValue) {
203             allowed[msg.sender][_spender] = 0;
204         }
205         else {
206             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207         }
208         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209         return true;
210     }
211 
212 }
213 /**
214  * @title Mintable token
215  * @dev Simple ERC20 Token example, with mintable token creation
216  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
217  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
218  */
219 
220 contract MintableToken is StandardToken {
221     event Mint(address indexed to, uint256 amount);
222 
223     event MintFinished();
224 
225     bool public mintingFinished = false;
226 
227     mapping(address => bool) public minters;
228 
229     modifier canMint() {
230         require(!mintingFinished);
231         _;
232     }
233     modifier onlyMinters() {
234         require(minters[msg.sender] || msg.sender == owner);
235         _;
236     }
237     function addMinter(address _addr) onlyOwner {
238         minters[_addr] = true;
239     }
240 
241     function deleteMinter(address _addr) onlyOwner {
242         delete minters[_addr];
243     }
244 
245     /**
246      * @dev Function to mint tokens
247      * @param _to The address that will receive the minted tokens.
248      * @param _amount The amount of tokens to mint.
249      * @return A boolean that indicates if the operation was successful.
250      */
251     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
252         totalSupply = totalSupply.add(_amount);
253         balances[_to] = balances[_to].add(_amount);
254         Mint(_to, _amount);
255         Transfer(address(0), _to, _amount);
256         return true;
257     }
258 
259     /**
260      * @dev Function to stop minting new tokens.
261      * @return True if the operation was successful.
262      */
263     function finishMinting() onlyOwner canMint public returns (bool) {
264         mintingFinished = true;
265         MintFinished();
266         return true;
267     }
268 }
269 
270 /**
271  * @title Capped token
272  * @dev Mintable token with a token cap.
273  */
274 
275 contract CappedToken is MintableToken {
276 
277     uint256 public cap;
278 
279     function CappedToken(uint256 _cap) public {
280         require(_cap > 0);
281         cap = _cap;
282     }
283 
284     /**
285      * @dev Function to mint tokens
286      * @param _to The address that will receive the minted tokens.
287      * @param _amount The amount of tokens to mint.
288      * @return A boolean that indicates if the operation was successful.
289      */
290     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
291         require(totalSupply.add(_amount) <= cap);
292 
293         return super.mint(_to, _amount);
294     }
295 
296 }
297 
298 contract TokenParam {
299 	/**
300 	 * 小数点位数
301 	 */
302     uint256 public constant decimals = 18;
303 	
304 	/**
305 	 * 总量
306 	 */
307     uint256 public constant capacity = 777777777 * 10 ** decimals;
308 
309 }
310 
311 contract AidocToken is CappedToken,TokenParam {
312     string public constant name = "AI Doctor";
313 
314     string public constant symbol = "AIDOC";
315 
316     function AidocToken() public CappedToken(capacity) {
317     }
318     
319 }