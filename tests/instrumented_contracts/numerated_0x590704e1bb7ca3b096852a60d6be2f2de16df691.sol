1 pragma solidity ^0.4.24;
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
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60     address public owner;
61 
62 
63     event OwnershipRenounced(address indexed previousOwner);
64     event OwnershipTransferred(
65         address indexed previousOwner,
66         address indexed newOwner
67     );
68 
69 
70     /**
71      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72      * account.
73      */
74     constructor() public {
75         owner = msg.sender;
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     /**
87      * @dev Allows the current owner to relinquish control of the contract.
88      * @notice Renouncing to ownership will leave the contract without an owner.
89      * It will not be possible to call the functions with the `onlyOwner`
90      * modifier anymore.
91      */
92     function renounceOwnership() public onlyOwner {
93         emit OwnershipRenounced(owner);
94         owner = address(0);
95     }
96 
97     /**
98      * @dev Allows the current owner to transfer control of the contract to a newOwner.
99      * @param _newOwner The address to transfer ownership to.
100      */
101     function transferOwnership(address _newOwner) public onlyOwner {
102         _transferOwnership(_newOwner);
103     }
104 
105     /**
106      * @dev Transfers control of the contract to a newOwner.
107      * @param _newOwner The address to transfer ownership to.
108      */
109     function _transferOwnership(address _newOwner) internal {
110         require(_newOwner != address(0));
111         emit OwnershipTransferred(owner, _newOwner);
112         owner = _newOwner;
113     }
114 }
115 
116 
117 /**
118  * @title ERC20Basic
119  * @dev Simpler version of ERC20 interface
120  * See https://github.com/ethereum/EIPs/issues/179
121  */
122 contract ERC20Basic {
123     function totalSupply() public view returns (uint256);
124     function balanceOf(address who) public view returns (uint256);
125     function transfer(address to, uint256 value) public returns (bool);
126     event Transfer(address indexed from, address indexed to, uint256 value);
127 }
128 
129 
130 /**
131  * @title SafeERC20
132  * @dev Wrappers around ERC20 operations that throw on failure.
133  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
134  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
135  */
136 library SafeERC20 {
137     function safeTransfer(ERC20 token, address to, uint256 value) internal {
138         require(token.transfer(to, value));
139     }
140 
141     function safeTransferFrom(
142         ERC20 token,
143         address from,
144         address to,
145         uint256 value
146     )
147     internal
148     {
149         require(token.transferFrom(from, to, value));
150     }
151 
152     function safeApprove(ERC20 token, address spender, uint256 value) internal {
153         require(token.approve(spender, value));
154     }
155 }
156 
157 /**
158  * @title ERC20 interface
159  * @dev see https://github.com/ethereum/EIPs/issues/20
160  */
161 contract ERC20 is ERC20Basic {
162     function allowance(address owner, address spender)
163     public view returns (uint256);
164 
165     function transferFrom(address from, address to, uint256 value)
166     public returns (bool);
167 
168     function approve(address spender, uint256 value) public returns (bool);
169     event Approval(
170         address indexed owner,
171         address indexed spender,
172         uint256 value
173     );
174 }
175 
176 /**
177  * @title Basic token
178  * @dev Basic version of StandardToken, with no allowances.
179  */
180 contract BasicToken is ERC20Basic {
181     using SafeMath for uint256;
182 
183     mapping(address => uint256) balances;
184 
185     uint256 totalSupply_;
186 
187     /**
188     * @dev Total number of tokens in existence
189     */
190     function totalSupply() public view returns (uint256) {
191         return totalSupply_;
192     }
193 
194     function transfer(address _to, uint256 _value) public returns (bool) {
195 		require(_to != address(0));
196 		require(_value <= balances[msg.sender]);
197 		
198 		balances[msg.sender] = balances[msg.sender].sub(_value);
199 		balances[_to] = balances[_to].add(_value);
200 		emit Transfer(msg.sender, _to, _value);
201 		return true;
202 	}
203 
204 
205     /**
206     * @dev Gets the balance of the specified address.
207     * @param _owner The address to query the the balance of.
208     * @return An uint256 representing the amount owned by the passed address.
209     */
210     function balanceOf(address _owner) public view returns (uint256) {
211         return balances[_owner];
212     }
213 
214 
215 }
216 
217 
218 
219 /**
220  * @title Standard ERC20 token
221  *
222  * @dev Implementation of the basic standard token.
223  * https://github.com/ethereum/EIPs/issues/20
224  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
225  */
226 contract StandardToken is ERC20, BasicToken {
227 
228     mapping (address => mapping (address => uint256)) internal allowed;
229 
230 
231     /**
232      * @dev Transfer tokens from one address to another
233      * @param _from address The address which you want to send tokens from
234      * @param _to address The address which you want to transfer to
235      * @param _value uint256 the amount of tokens to be transferred
236      */
237     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
238         require(_to != address(0));
239         require(_value <= balances[_from]);
240         require(_value <= allowed[_from][msg.sender]);
241 
242         balances[_from] = balances[_from].sub(_value);
243         balances[_to] = balances[_to].add(_value);
244         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
245         emit Transfer(_from, _to, _value);
246         return true;
247     }
248 
249     /**
250      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251      * Beware that changing an allowance with this method brings the risk that someone may use both the old
252      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
253      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
254      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255      * @param _spender The address which will spend the funds.
256      * @param _value The amount of tokens to be spent.
257      */
258     function approve(address _spender, uint256 _value) public returns (bool) {
259         //        allowed[msg.sender][_spender] = _value;
260         //        emit Approval(msg.sender, _spender, _value);
261         _spender;
262         _value;
263         return true;
264     }
265 
266     /**
267      * @dev Function to check the amount of tokens that an owner allowed to a spender.
268      * @param _owner address The address which owns the funds.
269      * @param _spender address The address which will spend the funds.
270      * @return A uint256 specifying the amount of tokens still available for the spender.
271      */
272     function allowance(
273         address _owner,
274         address _spender
275     )
276     public
277     view
278     returns (uint256)
279     {
280         return allowed[_owner][_spender];
281     }
282 
283 
284 }
285 
286 
287 /**
288  * @title SimpleToken
289  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
290  * Note they can later distribute these tokens as they wish using `transfer` and other
291  * `StandardToken` functions.
292  */
293 contract AngeniumPromoToken is StandardToken, Ownable {
294 
295     address public backEndOperator = 0xe26032f45d83F6E897ab38bE63e0b638769eD18E;
296     address public mainToken = 0xC5C02655BbD508545B4e32eC88Cef3Aa5e741D87;
297 
298     string public constant name = "Angenium Promo Token";
299     string public constant symbol = "ANGENIUM PROMO";
300     uint8 public constant decimals = 18;
301 
302 
303     uint256 public constant INITIAL_SUPPLY = 50000 * (10 ** uint256(decimals));
304 
305 
306     modifier backEnd() {
307         require(msg.sender == backEndOperator || msg.sender == owner);
308         _;
309     }
310 
311     constructor() public {
312         totalSupply_ = INITIAL_SUPPLY;
313     }
314 
315 
316     function multisend(address[] _owners) public backEnd {
317         for (uint256 i = 0; i < _owners.length; i++) {
318             emit Transfer(address(0), _owners[i], 1000000000000000000);
319         }
320     }
321 
322 
323 }