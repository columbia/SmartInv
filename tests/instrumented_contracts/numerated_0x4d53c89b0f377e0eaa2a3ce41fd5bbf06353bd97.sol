1 pragma solidity 0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55     function totalSupply() public view returns (uint256);
56     function balanceOf(address who) public view returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66     using SafeMath for uint256;
67 
68     mapping(address => uint256) balances;
69 
70     uint256 totalSupply_;
71 
72     /**
73     * @dev total number of tokens in existence
74     */
75     function totalSupply() public view returns (uint256) {
76         return totalSupply_;
77     }
78 
79     /**
80     * @dev transfer token for a specified address
81     * @param _to The address to transfer to.
82     * @param _value The amount to be transferred.
83     */
84     function transfer(address _to, uint256 _value) public returns (bool) {
85         require(_to != address(0));
86         require(_value <= balances[msg.sender]);
87 
88         // SafeMath.sub will throw if there is not enough balance.
89         balances[msg.sender] = balances[msg.sender].sub(_value);
90         balances[_to] = balances[_to].add(_value);
91         emit Transfer(msg.sender, _to, _value);
92         return true;
93     }
94 
95     /**
96     * @dev Gets the balance of the specified address.
97     * @param _owner The address to query the the balance of.
98     * @return An uint256 representing the amount owned by the passed address.
99     */
100     function balanceOf(address _owner) public view returns (uint256 balance) {
101         return balances[_owner];
102     }
103 }
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110     function allowance(address owner, address spender) public view returns (uint256);
111     function transferFrom(address from, address to, uint256 value) public returns (bool);
112     function approve(address spender, uint256 value) public returns (bool);
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20, BasicToken {
124 
125     mapping (address => mapping (address => uint256)) internal allowed;
126 
127     /**
128      * @dev Transfer tokens from one address to another
129      * @param _from address The address which you want to send tokens from
130      * @param _to address The address which you want to transfer to
131      * @param _value uint256 the amount of tokens to be transferred
132      */
133     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
134         require(_to != address(0));
135         require(_value <= balances[_from]);
136         require(_value <= allowed[_from][msg.sender]);
137 
138         balances[_from] = balances[_from].sub(_value);
139         balances[_to] = balances[_to].add(_value);
140         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141         emit Transfer(_from, _to, _value);
142         return true;
143     }
144 
145     /**
146      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147      *
148      * Beware that changing an allowance with this method brings the risk that someone may use both the old
149      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152      * @param _spender The address which will spend the funds.
153      * @param _value The amount of tokens to be spent.
154      */
155     function approve(address _spender, uint256 _value) public returns (bool) {
156         allowed[msg.sender][_spender] = _value;
157         emit Approval(msg.sender, _spender, _value);
158         return true;
159     }
160 
161     /**
162      * @dev Function to check the amount of tokens that an owner allowed to a spender.
163      * @param _owner address The address which owns the funds.
164      * @param _spender address The address which will spend the funds.
165      * @return A uint256 specifying the amount of tokens still available for the spender.
166      */
167     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
168         return allowed[_owner][_spender];
169     }
170 
171     /**
172      * approve should be called when allowed[_spender] == 0. To increment
173      * allowed value is better to use this function to avoid 2 calls (and wait until
174      * the first transaction is mined)
175      * From MonolithDAO Token.sol
176      */
177     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
178         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
179         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180         return true;
181     }
182 
183     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
184         uint oldValue = allowed[msg.sender][_spender];
185         if (_subtractedValue > oldValue) {
186             allowed[msg.sender][_spender] = 0;
187         } else {
188             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
189         }
190         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191         return true;
192     }
193 }
194 
195 contract Owned {
196     address public owner;
197 
198     constructor() public {
199         owner = msg.sender;
200     }
201 
202     modifier onlyOwner {
203         require(msg.sender == owner);
204         _;
205     }
206 }
207 
208 /**
209  * @title Mintable token
210  * @dev Simple ERC20 Token example, with mintable token creation
211  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
212  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
213  */
214 contract MintableToken is StandardToken, Owned {
215     event Mint(address indexed to, uint256 amount);
216     event MintFinished();
217 
218     bool public mintingFinished = false;
219 
220     modifier canMint() {
221         require(!mintingFinished);
222         _;
223     }
224 
225     /**
226     * @dev Function to mint tokens
227     * @param _to The address that will receive the minted tokens.
228     * @param _amount The amount of tokens to mint.
229     * @return A boolean that indicates if the operation was successful.
230     */
231     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
232         totalSupply_ = totalSupply_.add(_amount);
233         balances[_to] = balances[_to].add(_amount);
234         emit Mint(_to, _amount);
235         emit Transfer(address(0), _to, _amount);
236         return true;
237     }
238 
239     /**
240     * @dev Function to stop minting new tokens.
241     * @return True if the operation was successful.
242     */
243     function finishMinting() onlyOwner canMint public returns (bool) {
244         mintingFinished = true;
245         emit MintFinished();
246         return true;
247     }
248 }
249 
250 contract BidoohToken is MintableToken {
251     string public constant name = "Bidooh Token2";
252     string public constant symbol = "DOOH2";
253     uint8 public constant decimals = 18;
254 
255     /// This address is be assigned the Bidooh Team tokens
256     address public teamTokensAddress;
257 
258     /// This address is be assigned the Reserve tokens
259     address public reserveTokensAddress;
260 
261     /// This address is be assigned the Sale tokens
262     address public saleTokensAddress;
263 
264     /// This address will have the sole ability to mint more tokens
265     address public bidoohAdminAddress;
266 
267     /// a safeguard flag to prevent multiple calls of close()
268     bool public saleClosed = false;
269 
270     /// Only allowed to execute before the token sale is closed
271     modifier beforeSaleClosed {
272         require(!saleClosed);
273         _;
274     }
275 
276     constructor(address _teamTokensAddress, address _reserveTokensAddress,
277                 address _saleTokensAddress, address _bidoohAdminAddress) public {
278         require(_teamTokensAddress != address(0));
279         require(_reserveTokensAddress != address(0));
280         require(_saleTokensAddress != address(0));
281         require(_bidoohAdminAddress != address(0));
282 
283         teamTokensAddress = _teamTokensAddress;
284         reserveTokensAddress = _reserveTokensAddress;
285         saleTokensAddress = _saleTokensAddress;
286         bidoohAdminAddress = _bidoohAdminAddress;
287 
288         /// Maximum tokens to be allocated on the sale
289         /// 88.2 billion DOOH
290         uint256 saleTokens = 88200000000 * 10**uint256(decimals);
291         totalSupply_ = saleTokens;
292         balances[saleTokensAddress] = saleTokens;
293 
294         /// Reserve tokens - 18.9 billion DOOH
295         uint256 reserveTokens = 18900000000 * 10**uint256(decimals);
296         totalSupply_ = totalSupply_.add(reserveTokens);
297         balances[reserveTokensAddress] = reserveTokens;
298 
299         /// Team tokens - 18.9 billion DOOH
300         uint256 teamTokens = 18900000000 * 10**uint256(decimals);
301         totalSupply_ = totalSupply_.add(teamTokens);
302         balances[teamTokensAddress] = teamTokens;
303     }
304 
305     /// @dev Close the token sale and transfer ownership
306     function close() public onlyOwner beforeSaleClosed {
307         uint256 unsoldTokens = balances[saleTokensAddress];
308         balances[reserveTokensAddress] = balances[reserveTokensAddress].add(unsoldTokens);
309         balances[saleTokensAddress] = 0;
310         emit Transfer(saleTokensAddress, reserveTokensAddress, unsoldTokens);
311 
312         owner = bidoohAdminAddress;
313         saleClosed = true;
314     }
315 }