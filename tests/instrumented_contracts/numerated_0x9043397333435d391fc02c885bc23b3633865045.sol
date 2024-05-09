1 pragma solidity 0.4.25;
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
53 contract Ownable {
54     address public owner;
55 
56 
57     event OwnershipTransferred(
58         address indexed previousOwner,
59         address indexed newOwner
60     );
61 
62 
63     /**
64      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65      * account.
66      */
67     constructor() public {
68         owner = msg.sender;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78 
79 
80     function transferOwnership(address _newOwner) public onlyOwner {
81         require(_newOwner != address(0));
82         emit OwnershipTransferred(owner, _newOwner);
83         owner = _newOwner;
84     }
85 
86 
87 }
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 {
93     function allowance(address owner, address spender) public view returns (uint256);
94     function transferFrom(address from, address to, uint256 value) public returns (bool);
95     function totalSupply() public view returns (uint256);
96     function balanceOf(address who) public view returns (uint256);
97     function transfer(address to, uint256 value) public returns (bool);
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     function approve(address spender, uint256 value) public returns (bool);
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 
105 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
106 /**
107  * @title Standard ERC20 token
108  *
109  * @dev Implementation of the basic standard token.
110  * https://github.com/ethereum/EIPs/issues/20
111  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
112  */
113 contract StandardToken is ERC20{
114     using SafeMath for uint256;
115 
116     mapping (address => mapping (address => uint256)) internal allowed;
117     mapping(address => uint256) balances;
118 
119     uint256 _totalSupply;
120 
121     /**
122     * @dev Total number of tokens in existence
123     */
124     function totalSupply() public view returns (uint256) {
125         return _totalSupply;
126     }
127 
128     /**
129     * @dev Transfer token for a specified address
130     * @param _to The address to transfer to.
131     * @param _value The amount to be transferred.
132     */
133     function transfer(address _to, uint256 _value)  public returns (bool) {
134         require(_to != address(0));
135         require(_value <= balances[msg.sender]);
136 
137         balances[msg.sender] = balances[msg.sender].sub(_value);
138         balances[_to] = balances[_to].add(_value);
139         emit Transfer(msg.sender, _to, _value);
140         return true;
141     }
142 
143     /**
144     * @dev Gets the balance of the specified address.
145     * @param _owner The address to query the the balance of.
146     * @return An uint256 representing the amount owned by the passed address.
147     */
148     function balanceOf(address _owner) public view returns (uint256) {
149         return balances[_owner];
150     }
151 
152 
153     /**
154      * @dev Transfer tokens from one address to another
155      * @param _from address The address which you want to send tokens from
156      * @param _to address The address which you want to transfer to
157      * @param _value uint256 the amount of tokens to be transferred
158      */
159     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
160         require(_to != address(0));
161         require(_value <= balances[_from]);
162         require(_value <= allowed[_from][msg.sender]);
163 
164         balances[_from] = balances[_from].sub(_value);
165         balances[_to] = balances[_to].add(_value);
166         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
167         emit Transfer(_from, _to, _value);
168         return true;
169     }
170 
171     /**
172      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173      * Beware that changing an allowance with this method brings the risk that someone may use both the old
174      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177      * @param _spender The address which will spend the funds.
178      * @param _value The amount of tokens to be spent.
179      */
180     function approve(address _spender, uint256 _value) public returns (bool) {
181         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
182         allowed[msg.sender][_spender] = _value;
183         emit Approval(msg.sender, _spender, _value);
184         return true;
185     }
186 
187     /**
188      * Set allowance for other address and notify
189      *
190      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
191      *
192      * @param _spender The address authorized to spend
193      * @param _value the max amount they can spend
194      * @param _extraData some extra information to send to the approved contract
195      */
196     function approveAndCall(address _spender, uint256 _value, bytes _extraData)  public returns (bool success) {
197         tokenRecipient spender = tokenRecipient(_spender);
198         if (approve(_spender, _value)) {
199             spender.receiveApproval(msg.sender, _value, this, _extraData);
200             return true;
201         }
202     }
203 
204     /**
205      * @dev Function to check the amount of tokens that an owner allowed to a spender.
206      * @param _owner address The address which owns the funds.
207      * @param _spender address The address which will spend the funds.
208      * @return A uint256 specifying the amount of tokens still available for the spender.
209      */
210     function allowance(address _owner, address _spender) public view returns (uint256) {
211         return allowed[_owner][_spender];
212     }
213 
214     /**
215      * @dev Increase the amount of tokens that an owner allowed to a spender.
216      * approve should be called when allowed[_spender] == 0. To increment
217      * allowed value is better to use this function to avoid 2 calls (and wait until
218      * the first transaction is mined)
219      * From MonolithDAO Token.sol
220      * @param _spender The address which will spend the funds.
221      * @param _addedValue The amount of tokens to increase the allowance by.
222      */
223     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
224         allowed[msg.sender][_spender] = (
225         allowed[msg.sender][_spender].add(_addedValue));
226         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227         return true;
228     }
229 
230     /**
231      * @dev Decrease the amount of tokens that an owner allowed to a spender.
232      * approve should be called when allowed[_spender] == 0. To decrement
233      * allowed value is better to use this function to avoid 2 calls (and wait until
234      * the first transaction is mined)
235      * From MonolithDAO Token.sol
236      * @param _spender The address which will spend the funds.
237      * @param _subtractedValue The amount of tokens to decrease the allowance by.
238      */
239     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
240         uint256 oldValue = allowed[msg.sender][_spender];
241         if (_subtractedValue > oldValue) {
242             allowed[msg.sender][_spender] = 0;
243         } else {
244             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245         }
246         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247         return true;
248     }
249 
250 
251 }
252 
253 
254 /**
255  * @title SimpleToken
256  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
257  * Note they can later distribute these tokens as they wish using `transfer` and other
258  * `StandardToken` functions.
259  */
260 contract SapphireCoin is StandardToken, Ownable {
261     string public constant name = "Sapphire Coin"; // solium-disable-line uppercase
262     string public constant symbol = "SPH"; // solium-disable-line uppercase
263     uint8 public constant decimals = 18; // solium-disable-line uppercase
264 
265     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
266 
267 
268     constructor() public {
269         _totalSupply = INITIAL_SUPPLY;
270         balances[msg.sender] = INITIAL_SUPPLY;
271         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
272     }
273 
274 
275     /// @notice This method can be used by the owner to extract mistakenly
276     ///  sent tokens to this contract.
277     /// @param _token The address of the token contract that you want to recover
278     ///  set to 0 in case you want to extract ether.
279     function claimTokens(address _token, address _to) external onlyOwner {
280         require(_to != address(0));
281         if (_token == 0x0) {
282             _to.transfer(address(this).balance);
283             return;
284         }
285 
286         ERC20 token = ERC20(_token);
287         uint balance = token.balanceOf(this);
288         token.transfer(_to, balance);
289     }
290 
291 }