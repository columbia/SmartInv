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
53 
54 contract Ownable {
55     mapping(address => bool) owners;
56 
57     event OwnerAdded(address indexed newOwner);
58     event OwnerDeleted(address indexed owner);
59 
60     /**
61      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62      * account.
63      */
64     constructor() public {
65         owners[msg.sender] = true;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(isOwner(msg.sender));
73         _;
74     }
75 
76     function addOwner(address _newOwner) external onlyOwner {
77         require(_newOwner != address(0));
78         owners[_newOwner] = true;
79         emit OwnerAdded(_newOwner);
80     }
81 
82     function delOwner(address _owner) external onlyOwner {
83         require(owners[_owner]);
84         owners[_owner] = false;
85         emit OwnerDeleted(_owner);
86     }
87 
88     function isOwner(address _owner) public view returns (bool) {
89         return owners[_owner];
90     }
91 }
92 
93 
94 /**
95  * @title ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/20
97  */
98 contract ERC20 {
99     function allowance(address owner, address spender) public view returns (uint256);
100     function transferFrom(address from, address to, uint256 value) public returns (bool);
101     function totalSupply() public view returns (uint256);
102     function balanceOf(address who) public view returns (uint256);
103     function transfer(address to, uint256 value) public returns (bool);
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     function approve(address spender, uint256 value) public returns (bool);
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 
111 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
112 /**
113  * @title Standard ERC20 token
114  *
115  * @dev Implementation of the basic standard token.
116  * https://github.com/ethereum/EIPs/issues/20
117  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
118  */
119 contract StandardToken is ERC20, Ownable{
120     using SafeMath for uint256;
121 
122     mapping (address => mapping (address => uint256)) internal allowed;
123     mapping(address => uint256) balances;
124 
125     uint256 _totalSupply;
126 
127 
128     /**
129     * @dev Total number of tokens in existence
130     */
131     function totalSupply() public view returns (uint256) {
132         return _totalSupply;
133     }
134 
135     /**
136     * @dev Transfer token for a specified address
137     * @param _to The address to transfer to.
138     * @param _value The amount to be transferred.
139     */
140     function transfer(address _to, uint256 _value)  public returns (bool) {
141         require(_to != address(0));
142         require(_value <= balances[msg.sender]);
143 
144         balances[msg.sender] = balances[msg.sender].sub(_value);
145         balances[_to] = balances[_to].add(_value);
146         emit Transfer(msg.sender, _to, _value);
147         return true;
148     }
149 
150     /**
151     * @dev Gets the balance of the specified address.
152     * @param _owner The address to query the the balance of.
153     * @return An uint256 representing the amount owned by the passed address.
154     */
155     function balanceOf(address _owner) public view returns (uint256) {
156         return balances[_owner];
157     }
158 
159 
160     /**
161      * @dev Transfer tokens from one address to another
162      * @param _from address The address which you want to send tokens from
163      * @param _to address The address which you want to transfer to
164      * @param _value uint256 the amount of tokens to be transferred
165      */
166     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
167         require(_to != address(0));
168         require(_value <= balances[_from]);
169         require(_value <= allowed[_from][msg.sender]);
170 
171         balances[_from] = balances[_from].sub(_value);
172         balances[_to] = balances[_to].add(_value);
173         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174         emit Transfer(_from, _to, _value);
175         return true;
176     }
177 
178     /**
179      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180      * Beware that changing an allowance with this method brings the risk that someone may use both the old
181      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
182      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
183      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184      * @param _spender The address which will spend the funds.
185      * @param _value The amount of tokens to be spent.
186      */
187     function approve(address _spender, uint256 _value) public returns (bool) {
188         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
189         allowed[msg.sender][_spender] = _value;
190         emit Approval(msg.sender, _spender, _value);
191         return true;
192     }
193 
194     /**
195      * Set allowance for other address and notify
196      *
197      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
198      *
199      * @param _spender The address authorized to spend
200      * @param _value the max amount they can spend
201      * @param _extraData some extra information to send to the approved contract
202      */
203     function approveAndCall(address _spender, uint256 _value, bytes _extraData)  public returns (bool success) {
204         tokenRecipient spender = tokenRecipient(_spender);
205         if (approve(_spender, _value)) {
206             spender.receiveApproval(msg.sender, _value, this, _extraData);
207             return true;
208         }
209     }
210 
211     /**
212      * @dev Function to check the amount of tokens that an owner allowed to a spender.
213      * @param _owner address The address which owns the funds.
214      * @param _spender address The address which will spend the funds.
215      * @return A uint256 specifying the amount of tokens still available for the spender.
216      */
217     function allowance(address _owner, address _spender) public view returns (uint256) {
218         return allowed[_owner][_spender];
219     }
220 
221     /**
222      * @dev Increase the amount of tokens that an owner allowed to a spender.
223      * approve should be called when allowed[_spender] == 0. To increment
224      * allowed value is better to use this function to avoid 2 calls (and wait until
225      * the first transaction is mined)
226      * From MonolithDAO Token.sol
227      * @param _spender The address which will spend the funds.
228      * @param _addedValue The amount of tokens to increase the allowance by.
229      */
230     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
231         allowed[msg.sender][_spender] = (
232         allowed[msg.sender][_spender].add(_addedValue));
233         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234         return true;
235     }
236 
237     /**
238      * @dev Decrease the amount of tokens that an owner allowed to a spender.
239      * approve should be called when allowed[_spender] == 0. To decrement
240      * allowed value is better to use this function to avoid 2 calls (and wait until
241      * the first transaction is mined)
242      * From MonolithDAO Token.sol
243      * @param _spender The address which will spend the funds.
244      * @param _subtractedValue The amount of tokens to decrease the allowance by.
245      */
246     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
247         uint256 oldValue = allowed[msg.sender][_spender];
248         if (_subtractedValue > oldValue) {
249             allowed[msg.sender][_spender] = 0;
250         } else {
251             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252         }
253         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254         return true;
255     }
256 
257 
258     function burn(uint256 value) onlyOwner external {
259         _totalSupply = _totalSupply.sub(value);
260         balances[msg.sender] = balances[msg.sender].sub(value);
261         emit Transfer(msg.sender, address(0), value);
262     }
263 
264 }
265 
266 
267 /**
268  * @title SimpleToken
269  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
270  * Note they can later distribute these tokens as they wish using `transfer` and other
271  * `StandardToken` functions.
272  */
273 contract ErbNToken is StandardToken {
274     string public constant name = "Erbauer Netz"; // solium-disable-line uppercase
275     string public constant symbol = "ErbN"; // solium-disable-line uppercase
276     uint8 public constant decimals = 18; // solium-disable-line uppercase
277 
278     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
279 
280 
281     constructor() public {
282         _totalSupply = INITIAL_SUPPLY;
283         balances[msg.sender] = INITIAL_SUPPLY;
284         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
285     }
286 
287 }