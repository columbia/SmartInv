1 pragma solidity ^0.4.18;
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
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56     address public owner;
57 
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62     /**
63      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64      * account.
65      */
66     function Ownable() public {
67         owner = msg.sender;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     /**
79      * @dev Allows the current owner to transfer control of the contract to a newOwner.
80      * @param newOwner The address to transfer ownership to.
81      */
82     function transferOwnership(address newOwner) public onlyOwner {
83         require(newOwner != address(0));
84         emit OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86     }
87 
88 }
89 
90 /**
91  * @title ERC20Basic
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/179
94  */
95 contract ERC20Basic {
96     function totalSupply() public view returns (uint256);
97 
98     function balanceOf(address who) public view returns (uint256);
99 
100     function transfer(address to, uint256 value) public returns (bool);
101 
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110     function allowance(address owner, address spender) public view returns (uint256);
111 
112     function transferFrom(address from, address to, uint256 value) public returns (bool);
113 
114     function approve(address spender, uint256 value) public returns (bool);
115 
116     event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 /**
120  * @title Basic token
121  * @dev Basic version of StandardToken, with no allowances.
122  */
123 contract BasicToken is ERC20Basic {
124     using SafeMath for uint256;
125 
126     mapping(address => uint256) balances;
127 
128     uint256 totalSupply_;
129 
130     /**
131     * @dev total number of tokens in existence
132     */
133     function totalSupply() public view returns (uint256) {
134         return totalSupply_;
135     }
136 
137     /**
138     * @dev transfer token for a specified address
139     * @param _to The address to transfer to.
140     * @param _value The amount to be transferred.
141     */
142     function transfer(address _to, uint256 _value) public returns (bool) {
143         require(_to != address(0));
144         require(_value <= balances[msg.sender]);
145 
146         // SafeMath.sub will throw if there is not enough balance.
147         balances[msg.sender] = balances[msg.sender].sub(_value);
148         balances[_to] = balances[_to].add(_value);
149         emit Transfer(msg.sender, _to, _value);
150         return true;
151     }
152 
153     /**
154     * @dev Gets the balance of the specified address.
155     * @param _owner The address to query the the balance of.
156     * @return An uint256 representing the amount owned by the passed address.
157     */
158     function balanceOf(address _owner) public view returns (uint256 balance) {
159         return balances[_owner];
160     }
161 
162 }
163 
164 /**
165  * @title Standard ERC20 token
166  *
167  * @dev Implementation of the basic standard token.
168  * @dev https://github.com/ethereum/EIPs/issues/20
169  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
170  */
171 contract StandardToken is ERC20, BasicToken {
172 
173     mapping(address => mapping(address => uint256)) internal allowed;
174 
175 
176     /**
177      * @dev Transfer tokens from one address to another
178      * @param _from address The address which you want to send tokens from
179      * @param _to address The address which you want to transfer to
180      * @param _value uint256 the amount of tokens to be transferred
181      */
182     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
183         require(_to != address(0));
184         require(_value <= balances[_from]);
185         require(_value <= allowed[_from][msg.sender]);
186 
187         balances[_from] = balances[_from].sub(_value);
188         balances[_to] = balances[_to].add(_value);
189         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190         emit Transfer(_from, _to, _value);
191         return true;
192     }
193 
194     /**
195      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196      *
197      * Beware that changing an allowance with this method brings the risk that someone may use both the old
198      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201      * @param _spender The address which will spend the funds.
202      * @param _value The amount of tokens to be spent.
203      */
204     function approve(address _spender, uint256 _value) public returns (bool) {
205         allowed[msg.sender][_spender] = _value;
206         emit Approval(msg.sender, _spender, _value);
207         return true;
208     }
209 
210     /**
211      * @dev Function to check the amount of tokens that an owner allowed to a spender.
212      * @param _owner address The address which owns the funds.
213      * @param _spender address The address which will spend the funds.
214      * @return A uint256 specifying the amount of tokens still available for the spender.
215      */
216     function allowance(address _owner, address _spender) public view returns (uint256) {
217         return allowed[_owner][_spender];
218     }
219 
220     /**
221      * @dev Increase the amount of tokens that an owner allowed to a spender.
222      *
223      * approve should be called when allowed[_spender] == 0. To increment
224      * allowed value is better to use this function to avoid 2 calls (and wait until
225      * the first transaction is mined)
226      * From MonolithDAO Token.sol
227      * @param _spender The address which will spend the funds.
228      * @param _addedValue The amount of tokens to increase the allowance by.
229      */
230     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
231         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
232         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233         return true;
234     }
235 
236     /**
237      * @dev Decrease the amount of tokens that an owner allowed to a spender.
238      *
239      * approve should be called when allowed[_spender] == 0. To decrement
240      * allowed value is better to use this function to avoid 2 calls (and wait until
241      * the first transaction is mined)
242      * From MonolithDAO Token.sol
243      * @param _spender The address which will spend the funds.
244      * @param _subtractedValue The amount of tokens to decrease the allowance by.
245      */
246     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
247         uint oldValue = allowed[msg.sender][_spender];
248         if (_subtractedValue > oldValue) {
249             allowed[msg.sender][_spender] = 0;
250         } else {
251             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252         }
253         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254         return true;
255     }
256 
257 }
258 
259 /**
260  * @title TREON token
261  * @dev Token for tokensale.
262  */
263 contract TXOtoken is StandardToken {
264 
265     string public constant name = "TREON";
266     string public constant symbol = "TXO";
267     uint8 public constant decimals = 18;
268 
269     // Total Supply	1 Billion
270     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
271 
272     /**
273      * @dev Constructor that gives the wallet all of existing tokens.
274      */
275     function TXOtoken(address wallet) public {
276         totalSupply_ = INITIAL_SUPPLY;
277         balances[wallet] = INITIAL_SUPPLY;
278         emit Transfer(0x0, wallet, INITIAL_SUPPLY);
279     }
280 }
281 
282 /**
283  * @title TREON token sale
284  * @dev This contract receives money. Redirects money to the wallet. Verifies the correctness of transactions.
285  * @dev Does not produce tokens. All tokens are sent manually, after approval.
286  */
287 contract TXOsale is Ownable {
288 
289     event ReceiveEther(address indexed from, uint256 value);
290 
291     TXOtoken public token;
292 
293     bool public goalAchieved = false;
294 
295     address public constant wallet = 0x8dA7477d56c90CF2C5b78f36F9E39395ADb2Ae63;
296     //  Monday, May 21, 2018 12:00:00 AM
297     uint public  constant saleStart = 1526860800;
298     // Tuesday, July 17, 2018 11:59:59 PM
299     uint public constant saleEnd = 1531871999;
300 
301     function TXOsale() public {
302         token = new TXOtoken(wallet);
303     }
304 
305     /**
306     * @dev fallback function
307     */
308     function() public payable {
309         require(now >= saleStart && now <= saleEnd);
310         require(!goalAchieved);
311         require(msg.value >= 0.1 ether);
312         wallet.transfer(msg.value);
313         emit ReceiveEther(msg.sender, msg.value);
314     }
315 
316     /**
317      * @dev The owner can suspend the sale if the HardCap has been achieved.
318      */
319     function setGoalAchieved(bool _goalAchieved) public onlyOwner {
320         goalAchieved = _goalAchieved;
321     }
322 }