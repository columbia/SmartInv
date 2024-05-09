1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 /**
45  * @title ERC20Basic
46  * @dev Simpler version of ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/179
48  */
49 contract ERC20Basic {
50   uint256 public totalSupply;
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54   
55 }
56 
57 contract BasicToken is ERC20Basic, Ownable {
58 
59     using SafeMath for uint256;
60     mapping(address => uint256) balances;
61 
62     bool public transfersEnabledFlag;
63 
64     /**
65    * @dev Throws if transfersEnabledFlag is false and not owner.
66    */
67     modifier transfersEnabled() {
68         require(transfersEnabledFlag);
69         _;
70     }
71 
72     function enableTransfers() public onlyOwner {
73         transfersEnabledFlag = true;
74     }
75 
76     /**
77   * @dev transfer token for a specified address
78   * @param _to The address to transfer to.
79   * @param _value The amount to be transferred.
80   */
81     function transfer(address _to, uint256 _value) transfersEnabled public returns (bool) {
82         require(_to != address(0));
83         require(_value <= balances[msg.sender]);
84 
85         // SafeMath.sub will throw if there is not enough balance.
86         balances[msg.sender] = balances[msg.sender].sub(_value);
87         balances[_to] = balances[_to].add(_value);
88         Transfer(msg.sender, _to, _value);
89         return true;
90     }
91 
92     /**
93     * @dev Gets the balance of the specified address.
94     * @param _owner The address to query the the balance of.
95     * @return An uint256 representing the amount owned by the passed address.
96     */
97     function balanceOf(address _owner) public view returns (uint256 balance) {
98         return balances[_owner];
99     }
100 }
101 
102 
103 
104 
105 /**
106  * @title SafeMath
107  * @dev Math operations with safety checks that throw on error
108  */
109 library SafeMath {
110   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111     if (a == 0) {
112       return 0;
113     }
114     uint256 c = a * b;
115     assert(c / a == b);
116     return c;
117   }
118 
119   function div(uint256 a, uint256 b) internal pure returns (uint256) {
120     // assert(b > 0); // Solidity automatically throws when dividing by 0
121     uint256 c = a / b;
122     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123     return c;
124   }
125 
126   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127     assert(b <= a);
128     return a - b;
129   }
130 
131   function add(uint256 a, uint256 b) internal pure returns (uint256) {
132     uint256 c = a + b;
133     assert(c >= a);
134     return c;
135   }
136 }
137 /**
138  * @title ERC20 interface
139  * @dev see https://github.com/ethereum/EIPs/issues/20
140  */
141 contract ERC20 is ERC20Basic {
142   function allowance(address owner, address spender) public view returns (uint256);
143   function transferFrom(address from, address to, uint256 value) public returns (bool);
144   function approve(address spender, uint256 value) public returns (bool);
145   event Approval(address indexed owner, address indexed spender, uint256 value);
146 }
147 
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * @dev https://github.com/ethereum/EIPs/issues/20
153  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  */
155 contract StandardToken is ERC20, BasicToken {
156 
157     mapping (address => mapping (address => uint256)) internal allowed;
158 
159 
160     /**
161      * @dev Transfer tokens from one address to another
162      * @param _from address The address which you want to send tokens from
163      * @param _to address The address which you want to transfer to
164      * @param _value uint256 the amount of tokens to be transferred
165      */
166     function transferFrom(address _from, address _to, uint256 _value) transfersEnabled public returns (bool) {
167         require(_to != address(0));
168         require(_value <= balances[_from]);
169         require(_value <= allowed[_from][msg.sender]);
170 
171         balances[_from] = balances[_from].sub(_value);
172         balances[_to] = balances[_to].add(_value);
173         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174         Transfer(_from, _to, _value);
175         return true;
176     }
177 
178     /**
179      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180      *
181      * Beware that changing an allowance with this method brings the risk that someone may use both the old
182      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185      * @param _spender The address which will spend the funds.
186      * @param _value The amount of tokens to be spent.
187      */
188     function approve(address _spender, uint256 _value) transfersEnabled public returns (bool) {
189         allowed[msg.sender][_spender] = _value;
190         Approval(msg.sender, _spender, _value);
191         return true;
192     }
193 
194     /**
195      * @dev Function to check the amount of tokens that an owner allowed to a spender.
196      * @param _owner address The address which owns the funds.
197      * @param _spender address The address which will spend the funds.
198      * @return A uint256 specifying the amount of tokens still available for the spender.
199      */
200     function allowance(address _owner, address _spender) public view returns (uint256) {
201         return allowed[_owner][_spender];
202     }
203 
204     /**
205      * approve should be called when allowed[_spender] == 0. To increment
206      * allowed value is better to use this function to avoid 2 calls (and wait until
207      * the first transaction is mined)
208      * From MonolithDAO Token.sol
209      */
210     function increaseApproval(address _spender, uint _addedValue) transfersEnabled public returns (bool) {
211         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
212         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213         return true;
214     }
215 
216     function decreaseApproval(address _spender, uint _subtractedValue) transfersEnabled public returns (bool) {
217         uint oldValue = allowed[msg.sender][_spender];
218         if (_subtractedValue > oldValue) {
219             allowed[msg.sender][_spender] = 0;
220         }
221         else {
222             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
223         }
224         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225         return true;
226     }
227 
228 }
229 
230 /**
231  * @title Mintable token
232  * @dev Simple ERC20 Token example, with mintable token creation
233  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
234  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
235  */
236 
237 contract MintableToken is StandardToken {
238     event Mint(address indexed to, uint256 amount);
239 
240     event MintFinished();
241 
242     bool public mintingFinished = false;
243 
244     mapping(address => bool) public minters;
245 
246     modifier canMint() {
247         require(!mintingFinished);
248         _;
249     }
250     modifier onlyMinters() {
251         require(minters[msg.sender] || msg.sender == owner);
252         _;
253     }
254     function addMinter(address _addr) public onlyOwner {
255         minters[_addr] = true;
256     }
257 
258     function deleteMinter(address _addr) public onlyOwner {
259         delete minters[_addr];
260     }
261 
262     /**
263      * @dev Function to mint tokens
264      * @param _to The address that will receive the minted tokens.
265      * @param _amount The amount of tokens to mint.
266      * @return A boolean that indicates if the operation was successful.
267      */
268     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
269         require(_to != address(0));
270         totalSupply = totalSupply.add(_amount);
271         balances[_to] = balances[_to].add(_amount);
272         Mint(_to, _amount);
273         Transfer(address(0), _to, _amount);
274         return true;
275     }
276 
277     /**
278      * @dev Function to stop minting new tokens.
279      * @return True if the operation was successful.
280      */
281     function finishMinting() onlyOwner canMint public returns (bool) {
282         mintingFinished = true;
283         MintFinished();
284         return true;
285     }
286 }
287 
288 /**
289  * @title Capped token
290  * @dev Mintable token with a token cap.
291  */
292 
293 contract CappedToken is MintableToken {
294 
295     uint256 public cap;
296 
297     function CappedToken(uint256 _cap) public {
298         require(_cap > 0);
299         cap = _cap;
300     }
301 
302     /**
303      * @dev Function to mint tokens
304      * @param _to The address that will receive the minted tokens.
305      * @param _amount The amount of tokens to mint.
306      * @return A boolean that indicates if the operation was successful.
307      */
308     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
309         require(totalSupply.add(_amount) <= cap);
310 
311         return super.mint(_to, _amount);
312     }
313 
314 }
315 
316 
317 contract ParameterizedToken is CappedToken {
318     string public version = "1.1";
319 
320     string public name;
321 
322     string public symbol;
323 
324     uint256 public decimals;
325 
326     function ParameterizedToken(string _name, string _symbol, uint256 _decimals, uint256 _capIntPart) public CappedToken(_capIntPart * 10 ** _decimals) {
327         name = _name;
328         symbol = _symbol;
329         decimals = _decimals;
330     }
331 
332 }
333 
334 
335 contract FOCToken is ParameterizedToken {
336 
337     function FOCToken() public ParameterizedToken("Fruit Origin Chain", "FOC", 18, 21000000000) {
338     }
339 
340 }