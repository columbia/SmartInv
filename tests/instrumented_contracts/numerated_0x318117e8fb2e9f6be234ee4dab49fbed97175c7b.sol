1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
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
33     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57     address public owner;
58 
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63     /**
64     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65     * account.
66     */
67     function Ownable() public {
68         owner = msg.sender;
69     }
70 
71     /**
72     * @dev Throws if called by any account other than the owner.
73     */
74     modifier onlyOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     /**
80     * @dev Allows the current owner to transfer control of the contract to a newOwner.
81     * @param newOwner The address to transfer ownership to.
82     */
83     function transferOwnership(address newOwner) public onlyOwner {
84         require(newOwner != address(0));
85         OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87     }
88 
89 }
90 
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/179
96  */
97 contract ERC20Basic {
98     function totalSupply() public view returns (uint256);
99     function balanceOf(address who) public view returns (uint256);
100     function transfer(address to, uint256 value) public returns (bool);
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
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
116 
117 /**
118  * @title Basic token
119  * @dev Basic version of StandardToken, with no allowances.
120  */
121 contract BasicToken is ERC20Basic {
122     using SafeMath for uint256;
123 
124     mapping(address => uint256) balances;
125 
126     uint256 totalSupply_;
127 
128     /**
129     * @dev total number of tokens in existence
130     */
131     function totalSupply() public view returns (uint256) {
132         return totalSupply_;
133     }
134 
135     /**
136     * @dev transfer token for a specified address
137     * @param _to The address to transfer to.
138     * @param _value The amount to be transferred.
139     */
140     function transfer(address _to, uint256 _value) public returns (bool) {
141         require(_to != address(0));
142         require(_value <= balances[msg.sender]);
143 
144         // SafeMath.sub will throw if there is not enough balance.
145         balances[msg.sender] = balances[msg.sender].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         Transfer(msg.sender, _to, _value);
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
159 
160 }
161 
162 
163 /**
164  * @title Standard ERC20 token
165  *
166  * @dev Implementation of the basic standard token.
167  * @dev https://github.com/ethereum/EIPs/issues/20
168  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
169  */
170 contract StandardToken is ERC20, BasicToken {
171 
172     mapping (address => mapping (address => uint256)) internal allowed;
173 
174     /**
175     * @dev Transfer tokens from one address to another
176     * @param _from address The address which you want to send tokens from
177     * @param _to address The address which you want to transfer to
178     * @param _value uint256 the amount of tokens to be transferred
179     */
180     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
181         require(_to != address(0));
182         require(_value <= balances[_from]);
183         require(_value <= allowed[_from][msg.sender]);
184 
185         balances[_from] = balances[_from].sub(_value);
186         balances[_to] = balances[_to].add(_value);
187         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
188         Transfer(_from, _to, _value);
189         return true;
190     }
191 
192     /**
193     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194     *
195     * Beware that changing an allowance with this method brings the risk that someone may use both the old
196     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199     * @param _spender The address which will spend the funds.
200     * @param _value The amount of tokens to be spent.
201     */
202     function approve(address _spender, uint256 _value) public returns (bool) {
203         allowed[msg.sender][_spender] = _value;
204         Approval(msg.sender, _spender, _value);
205         return true;
206     }
207 
208     /**
209     * @dev Function to check the amount of tokens that an owner allowed to a spender.
210     * @param _owner address The address which owns the funds.
211     * @param _spender address The address which will spend the funds.
212     * @return A uint256 specifying the amount of tokens still available for the spender.
213     */
214     function allowance(address _owner, address _spender) public view returns (uint256) {
215         return allowed[_owner][_spender];
216     }
217 
218     /**
219     * @dev Increase the amount of tokens that an owner allowed to a spender.
220     *
221     * approve should be called when allowed[_spender] == 0. To increment
222     * allowed value is better to use this function to avoid 2 calls (and wait until
223     * the first transaction is mined)
224     * From MonolithDAO Token.sol
225     * @param _spender The address which will spend the funds.
226     * @param _addedValue The amount of tokens to increase the allowance by.
227     */
228     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
229         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
230         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231         return true;
232     }
233 
234     /**
235     * @dev Decrease the amount of tokens that an owner allowed to a spender.
236     *
237     * approve should be called when allowed[_spender] == 0. To decrement
238     * allowed value is better to use this function to avoid 2 calls (and wait until
239     * the first transaction is mined)
240     * From MonolithDAO Token.sol
241     * @param _spender The address which will spend the funds.
242     * @param _subtractedValue The amount of tokens to decrease the allowance by.
243     */
244     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
245         uint oldValue = allowed[msg.sender][_spender];
246         if (_subtractedValue > oldValue) {
247             allowed[msg.sender][_spender] = 0;
248         } else {
249             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250         }
251         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252         return true;
253     }
254 
255 }
256 
257 /**
258  * @title Mintable token
259  * @dev Simple ERC20 Token example, with mintable token creation
260  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
261  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
262  */
263 contract MintableToken is StandardToken, Ownable {
264     event Mint(address indexed to, uint256 amount);
265 
266     /**
267     * @dev Function to mint tokens
268     * @param _to The address that will receive the minted tokens.
269     * @param _amount The amount of tokens to mint.
270     * @return A boolean that indicates if the operation was successful.
271     */
272     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
273         totalSupply_ = totalSupply_.add(_amount);
274         balances[_to] = balances[_to].add(_amount);
275         Mint(_to, _amount);
276         Transfer(address(0), _to, _amount);
277         return true;
278     }
279 }
280 
281 
282 /**
283  * @title SimpleToken
284  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
285  * Note they can later distribute these tokens as they wish using `transfer` and other
286  * `StandardToken` functions.
287  */
288 contract SimpleToken is MintableToken {
289 
290     string public constant name = "UNKOin"; // solium-disable-line uppercase
291     string public constant symbol = "UNK"; // solium-disable-line uppercase
292     uint8 public constant decimals = 0; // solium-disable-line uppercase
293 
294     uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));
295 
296     /**
297     * @dev Constructor that gives msg.sender all of existing tokens.
298     */
299     function SimpleToken() public {
300         totalSupply_ = INITIAL_SUPPLY;
301         balances[msg.sender] = INITIAL_SUPPLY;
302         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
303     }
304 
305 }