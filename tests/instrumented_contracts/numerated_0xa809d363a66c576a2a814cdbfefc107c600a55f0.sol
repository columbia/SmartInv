1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers, truncating the quotient.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         // uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return a / b;
34     }
35 
36     /**
37     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38     */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     /**
45     * @dev Adds two numbers, throws on overflow.
46     */
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60     address public owner;
61     address public pendingOwner;
62     address public manager;
63 
64     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66     /**
67     * @dev Throws if called by any account other than the owner.
68     */
69     modifier onlyOwner() {
70         require(msg.sender == owner);
71         _;
72     }
73 
74     /**
75      * @dev Modifier throws if called by any account other than the pendingOwner.
76      */
77     modifier onlyPendingOwner() {
78         require(msg.sender == pendingOwner);
79         _;
80     }
81 
82     constructor() public {
83         owner = msg.sender;
84     }
85 
86     /**
87      * @dev Allows the current owner to set the pendingOwner address.
88      * @param newOwner The address to transfer ownership to.
89      */
90     function transferOwnership(address newOwner) public onlyOwner {
91         pendingOwner = newOwner;
92     }
93 
94     /**
95      * @dev Allows the pendingOwner address to finalize the transfer.
96      */
97     function claimOwnership() public onlyPendingOwner {
98         emit OwnershipTransferred(owner, pendingOwner);
99         owner = pendingOwner;
100         pendingOwner = address(0);
101     }
102 
103     /**
104      * @dev Sets the manager address.
105      * @param _manager The manager address.
106      */
107     function setManager(address _manager) public onlyOwner {
108         require(_manager != address(0));
109         manager = _manager;
110     }
111 
112 }
113 
114 
115 contract ERC20 {
116     function totalSupply() public view returns (uint256);
117     function balanceOf(address who) public view returns (uint256);
118     function transfer(address to, uint256 value) public returns (bool);
119     function transferFrom(address from, address to, uint256 value) public returns (bool);
120     function approve(address spender, uint256 value) public returns (bool);
121     function allowance(address who, address spender) public view returns (uint256);
122     event Transfer(address indexed from, address indexed to, uint256 value);
123     event Approval(address indexed who, address indexed spender, uint256 value);
124 }
125 
126 
127 contract HyperLootToken is ERC20, Ownable {
128     using SafeMath for uint256;
129 
130     uint256 internal totalSupply_;
131     uint8 public decimals = 18;
132     uint256 public MAX_TOTAL_SUPPLY = uint256(1000000000) * uint256(10) ** decimals;
133     mapping(address => uint256) internal balances;
134     mapping(address => mapping (address => uint256)) internal allowed;
135     string public name = "HyperLoot";
136     string public symbol = "HLT";
137 
138     event Mint(address indexed _to, uint _amount);
139 
140     modifier canMint() {
141         require(msg.sender == manager);
142         require(totalSupply() <= MAX_TOTAL_SUPPLY);
143         _;
144     }
145 
146     /**
147      * @dev Reclaim all ERC20Basic compatible tokens
148      * @param token ERC20B The address of the token contract
149      */
150     function reclaimToken(ERC20 token) external onlyOwner {
151         uint256 balance = token.balanceOf(this);
152         token.transfer(owner, balance);
153     }
154 
155     /**
156     * @dev total number of tokens in existence
157     */
158     function totalSupply() public view returns (uint256) {
159         return totalSupply_;
160     }
161 
162     /**
163     * @dev max total number of tokens
164     */
165     function getMaxTotalSupply() public view returns (uint256) {
166         return MAX_TOTAL_SUPPLY;
167     }
168 
169     /**
170     * @dev Gets the balance of the specified address.
171     * @param _who The address to query the the balance of.
172     * @return An uint256 representing the amount owned by the passed address.
173     */
174     function balanceOf(address _who) public view returns (uint256 balance) {
175         return balances[_who];
176     }
177 
178     /**
179     * @dev transfer token for a specified address
180     * @param _to The address to transfer to.
181     * @param _value The amount to be transferred.
182     */
183     function transfer(address _to, uint256 _value) public returns (bool) {
184         require(_to != address(0));
185         require(_value <= balances[msg.sender]);
186 
187         // SafeMath.sub will throw if there is not enough balance.
188         balances[msg.sender] = balances[msg.sender].sub(_value);
189         balances[_to] = balances[_to].add(_value);
190         emit Transfer(msg.sender, _to, _value);
191         return true;
192     }
193 
194     /**
195      * @dev Transfer tokens from one address to another
196      * @param _from address The address which you want to send tokens from
197      * @param _to address The address which you want to transfer to
198      * @param _value uint256 the amount of tokens to be transferred
199      */
200     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
201         require(_to != address(0));
202         require(_value <= balances[_from]);
203         require(_value <= allowed[_from][msg.sender]);
204 
205         balances[_from] = balances[_from].sub(_value);
206         balances[_to] = balances[_to].add(_value);
207         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
208         emit Transfer(_from, _to, _value);
209         return true;
210     }
211 
212     /**
213      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
214      *
215      * Beware that changing an allowance with this method brings the risk that someone may use both the old
216      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
217      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
218      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
219      * @param _spender The address which will spend the funds.
220      * @param _value The amount of tokens to be spent.
221      */
222     function approve(address _spender, uint256 _value) public returns (bool) {
223         allowed[msg.sender][_spender] = _value;
224         emit Approval(msg.sender, _spender, _value);
225         return true;
226     }
227 
228     /**
229      * @dev Function to check the amount of tokens that an owner allowed to a spender.
230      * @param _who address The address which owns the funds.
231      * @param _spender address The address which will spend the funds.
232      * @return A uint256 specifying the amount of tokens still available for the spender.
233      */
234     function allowance(address _who, address _spender) public view returns (uint256) {
235         return allowed[_who][_spender];
236     }
237 
238     /**
239      * @dev Increase the amount of tokens that an owner allowed to a spender.
240      *
241      * approve should be called when allowed[_spender] == 0. To increment
242      * allowed value is better to use this function to avoid 2 calls (and wait until
243      * the first transaction is mined)
244      * From MonolithDAO Token.sol
245      * @param _spender The address which will spend the funds.
246      * @param _addedValue The amount of tokens to increase the allowance by.
247      */
248     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
249         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
250         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251         return true;
252     }
253 
254     /**
255      * @dev Decrease the amount of tokens that an owner allowed to a spender.
256      *
257      * approve should be called when allowed[_spender] == 0. To decrement
258      * allowed value is better to use this function to avoid 2 calls (and wait until
259      * the first transaction is mined)
260      * From MonolithDAO Token.sol
261      * @param _spender The address which will spend the funds.
262      * @param _subtractedValue The amount of tokens to decrease the allowance by.
263      */
264     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
265         uint oldValue = allowed[msg.sender][_spender];
266         if (_subtractedValue > oldValue) {
267             allowed[msg.sender][_spender] = 0;
268         } else {
269             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270         }
271         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272         return true;
273     }
274 
275     /**
276      * @dev Function to mint tokens
277      * @param _to The address that will receive the minted tokens.
278      * @param _amount The amount of tokens to mint.
279      * @return A boolean that indicates if the operation was successful.
280      */
281     function mint(address _to, uint256 _amount) public canMint returns (bool) {
282         require(_amount > 0);
283         require(_to != address(0));
284         totalSupply_ = totalSupply_.add(_amount);
285         require(totalSupply_ <= MAX_TOTAL_SUPPLY);
286         balances[_to] = balances[_to].add(_amount);
287         emit Mint(_to, _amount);
288         emit Transfer(address(0), _to, _amount);
289         return true;
290     }
291 }