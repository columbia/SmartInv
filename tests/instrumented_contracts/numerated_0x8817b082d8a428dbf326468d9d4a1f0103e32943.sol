1 pragma solidity 0.4.24;
2 
3 contract Ownable {
4     address public owner;
5 
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10     /**
11      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12      * account.
13      */
14     function Ownable() {
15         owner = msg.sender;
16     }
17 
18 
19     /**
20      * @dev Throws if called by any account other than the owner.
21      */
22     modifier onlyOwner() {
23         require(msg.sender == owner);
24         _;
25     }
26 
27 
28     /**
29      * @dev Allows the current owner to transfer control of the contract to a newOwner.
30      * @param newOwner The address to transfer ownership to.
31      */
32     function transferOwnership(address newOwner) onlyOwner public {
33         require(newOwner != address(0));
34         OwnershipTransferred(owner, newOwner);
35         owner = newOwner;
36     }
37 }
38 
39 contract ERC20Basic {
40     uint256 public totalSupply;
41     function balanceOf(address who) public constant returns (uint256);
42     function transfer(address to, uint256 value) public returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 contract BasicToken is ERC20Basic {
47     using SafeMath for uint256;
48 
49     mapping(address => uint256) balances;
50 
51     /**
52     * @dev transfer token for a specified address
53     * @param _to The address to transfer to.
54     * @param _value The amount to be transferred.
55     */
56     function transfer(address _to, uint256 _value) public returns (bool) {
57         require(_to != address(0));
58 
59         // SafeMath.sub will throw if there is not enough balance.
60         balances[msg.sender] = balances[msg.sender].sub(_value);
61         balances[_to] = balances[_to].add(_value);
62         Transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     /**
67     * @dev Gets the balance of the specified address.
68     * @param _owner The address to query the the balance of.
69     * @return An uint256 representing the amount owned by the passed address.
70     */
71     function balanceOf(address _owner) public constant returns (uint256 balance) {
72         return balances[_owner];
73     }
74 
75 }
76 
77 contract ERC20 is ERC20Basic {
78     function allowance(address owner, address spender) public constant returns (uint256);
79     function transferFrom(address from, address to, uint256 value) public returns (bool);
80     function approve(address spender, uint256 value) public returns (bool);
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 contract StandardToken is ERC20, BasicToken {
85 
86     mapping (address => mapping (address => uint256)) allowed;
87 
88 
89     /**
90      * @dev Transfer tokens from one address to another
91      * @param _from address The address which you want to send tokens from
92      * @param _to address The address which you want to transfer to
93      * @param _value uint256 the amount of tokens to be transferred
94      */
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
96         require(_to != address(0));
97 
98         uint256 _allowance = allowed[_from][msg.sender];
99 
100         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
101         // require (_value <= _allowance);
102 
103         balances[_from] = balances[_from].sub(_value);
104         balances[_to] = balances[_to].add(_value);
105         allowed[_from][msg.sender] = _allowance.sub(_value);
106         Transfer(_from, _to, _value);
107         return true;
108     }
109 
110     /**
111      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
112      *
113      * Beware that changing an allowance with this method brings the risk that someone may use both the old
114      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
115      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
116      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
117      * @param _spender The address which will spend the funds.
118      * @param _value The amount of tokens to be spent.
119      */
120     function approve(address _spender, uint256 _value) public returns (bool) {
121         allowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123         return true;
124     }
125 
126     /**
127      * @dev Function to check the amount of tokens that an owner allowed to a spender.
128      * @param _owner address The address which owns the funds.
129      * @param _spender address The address which will spend the funds.
130      * @return A uint256 specifying the amount of tokens still available for the spender.
131      */
132     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
133         return allowed[_owner][_spender];
134     }
135 
136     /**
137      * approve should be called when allowed[_spender] == 0. To increment
138      * allowed value is better to use this function to avoid 2 calls (and wait until
139      * the first transaction is mined)
140      * From MonolithDAO Token.sol
141      */
142     function increaseApproval (address _spender, uint _addedValue)
143     returns (bool success) {
144         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
145         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146         return true;
147     }
148 
149     function decreaseApproval (address _spender, uint _subtractedValue)
150     returns (bool success) {
151         uint oldValue = allowed[msg.sender][_spender];
152         if (_subtractedValue > oldValue) {
153             allowed[msg.sender][_spender] = 0;
154         } else {
155             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
156         }
157         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158         return true;
159     }
160 
161 }
162 
163 library SafeMath {
164     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
165         uint256 c = a * b;
166         assert(a == 0 || c / a == b);
167         return c;
168     }
169 
170     function div(uint256 a, uint256 b) internal constant returns (uint256) {
171         // assert(b > 0); // Solidity automatically throws when dividing by 0
172         uint256 c = a / b;
173         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
174         return c;
175     }
176 
177     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
178         assert(b <= a);
179         return a - b;
180     }
181 
182     function add(uint256 a, uint256 b) internal constant returns (uint256) {
183         uint256 c = a + b;
184         assert(c >= a);
185         return c;
186     }
187 }
188 
189 contract MintableToken is StandardToken, Ownable {
190     event Mint(address indexed to, uint256 amount);
191     event MintFinished();
192 
193     bool public mintingFinished = false;
194 
195 
196     modifier canMint() {
197         require(!mintingFinished);
198         _;
199     }
200 
201     /**
202      * @dev Function to mint tokens
203      * @param _to The address that will receive the minted tokens.
204      * @param _amount The amount of tokens to mint.
205      * @return A boolean that indicates if the operation was successful.
206      */
207     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
208         totalSupply = totalSupply.add(_amount);
209         balances[_to] = balances[_to].add(_amount);
210         Mint(_to, _amount);
211         Transfer(0x0, _to, _amount);
212         return true;
213     }
214 
215     /**
216      * @dev Function to stop minting new tokens.
217      * @return True if the operation was successful.
218      */
219     function finishMinting() onlyOwner public returns (bool) {
220         mintingFinished = true;
221         MintFinished();
222         return true;
223     }
224 }
225 
226 contract DXC is MintableToken {
227     address[] public additionalOwnersList; // List of addresses which are able to call `mint` function
228     mapping(address => bool) public additionalOwners;  // Mapping of addresses which are able to call `mint` function
229     uint public maximumSupply = 300000000 * 10**18; // Maximum supply of DXC tokens equals 300 millions
230 
231     event TokenCreation(address _address);
232     event SetAdditionalOwners(address[] oldOwners, address[] newOwners);
233 
234     string public constant name = "Daox Coin";
235     string public constant symbol = "DXC";
236     uint public constant decimals = 18;
237 
238     /**
239      * @dev Transfer specified amount of tokens to the specified address and call
240      * standard `handleDXCPayment` method of Crowdsale DAO
241      * @param _to The address of Crowdsale DAO
242      * @param _amount The amount of tokens to send
243     */
244     function contributeTo(address _to, uint256 _amount) public {
245         super.transfer(_to, _amount);
246         require(_to.call(bytes4(keccak256("handleDXCPayment(address,uint256)")), msg.sender, _amount));
247     }
248 
249     /**
250      * @dev Overrides function to mint tokens from `MintableToken` contract with new modifier
251      * @param _to The address that will receive the minted tokens.
252      * @param _amount The amount of tokens to mint.
253      * @return A boolean that indicates if the operation was successful.
254     */
255     function mint(address _to, uint256 _amount) isOwnerOrAdditionalOwner canMint maximumSupplyWasNotReached(_amount) public returns (bool) {
256         totalSupply = totalSupply.add(_amount);
257         balances[_to] = balances[_to].add(_amount);
258         Mint(_to, _amount);
259         Transfer(0x0, _to, _amount);
260         return true;
261     }
262 
263     /**
264      * @dev Transfer specified amount of tokens to the specified list of addresses
265      * @param _to The array of addresses that will receive tokens
266      * @param _amount The array of uint values indicates how much tokens will receive corresponding address
267      * @return True if all transfers were completed successfully
268     */
269     function transferTokens(address[] _to, uint256[] _amount) isOwnerOrAdditionalOwner public returns (bool) {
270         require(_to.length == _amount.length);
271         for (uint i = 0; i < _to.length; i++) {
272             transfer(_to[i], _amount[i]);
273         }
274 
275         return true;
276     }
277 
278     /**
279      * @dev Define array and mapping of addresses that will be additional owners
280      * @param _owners The addresses that will be defined as additional owners
281     */
282     function setAdditionalOwners(address[] _owners) onlyOwner {
283         SetAdditionalOwners(additionalOwnersList, _owners);
284 
285         for (uint i = 0; i < additionalOwnersList.length; i++) {
286             additionalOwners[additionalOwnersList[i]] = false;
287         }
288 
289         for (i = 0; i < _owners.length; i++) {
290             additionalOwners[_owners[i]] = true;
291         }
292 
293         additionalOwnersList = _owners;
294     }
295 
296     /**
297      * @dev Throws an exception if called not by owner or additional owner
298      */
299     modifier isOwnerOrAdditionalOwner() {
300         require(msg.sender == owner || additionalOwners[msg.sender]);
301         _;
302     }
303 
304     /**
305      * @dev Throws an exception if maximumSupply will be exceeded after minting
306      * @param _amount The amount of tokens to mint
307      */
308     modifier maximumSupplyWasNotReached(uint256 _amount) {
309         require(totalSupply.add(_amount) <= maximumSupply);
310         _;
311     }
312 }