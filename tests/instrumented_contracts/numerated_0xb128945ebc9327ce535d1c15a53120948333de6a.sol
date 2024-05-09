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
54 /**
55  * @title ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/20
57  */
58 contract ERC20 {
59     function allowance(address owner, address spender) public view returns (uint256);
60     function transferFrom(address from, address to, uint256 value) public returns (bool);
61     function totalSupply() public view returns (uint256);
62     function balanceOf(address who) public view returns (uint256);
63     function transfer(address to, uint256 value) public returns (bool);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66     function approve(address spender, uint256 value) public returns (bool);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 
71 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
72 /**
73  * @title Standard ERC20 token
74  *
75  * @dev Implementation of the basic standard token.
76  * https://github.com/ethereum/EIPs/issues/20
77  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
78  */
79 contract StandardToken is ERC20{
80     using SafeMath for uint256;
81 
82     mapping (address => mapping (address => uint256)) internal allowed;
83     mapping(address => uint256) balances;
84 
85     uint256 _totalSupply;
86 
87 
88     /**
89     * @dev Total number of tokens in existence
90     */
91     function totalSupply() public view returns (uint256) {
92         return _totalSupply;
93     }
94 
95     /**
96     * @dev Transfer token for a specified address
97     * @param _to The address to transfer to.
98     * @param _value The amount to be transferred.
99     */
100     function transfer(address _to, uint256 _value)  public returns (bool) {
101         require(_to != address(0));
102         require(_value <= balances[msg.sender]);
103 
104         balances[msg.sender] = balances[msg.sender].sub(_value);
105         balances[_to] = balances[_to].add(_value);
106         emit Transfer(msg.sender, _to, _value);
107         return true;
108     }
109 
110     /**
111     * @dev Gets the balance of the specified address.
112     * @param _owner The address to query the the balance of.
113     * @return An uint256 representing the amount owned by the passed address.
114     */
115     function balanceOf(address _owner) public view returns (uint256) {
116         return balances[_owner];
117     }
118 
119 
120     /**
121      * @dev Transfer tokens from one address to another
122      * @param _from address The address which you want to send tokens from
123      * @param _to address The address which you want to transfer to
124      * @param _value uint256 the amount of tokens to be transferred
125      */
126     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
127         require(_to != address(0));
128         require(_value <= balances[_from]);
129         require(_value <= allowed[_from][msg.sender]);
130 
131         balances[_from] = balances[_from].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134         emit Transfer(_from, _to, _value);
135         return true;
136     }
137 
138     /**
139      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
140      * Beware that changing an allowance with this method brings the risk that someone may use both the old
141      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144      * @param _spender The address which will spend the funds.
145      * @param _value The amount of tokens to be spent.
146      */
147     function approve(address _spender, uint256 _value) public returns (bool) {
148         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
149         allowed[msg.sender][_spender] = _value;
150         emit Approval(msg.sender, _spender, _value);
151         return true;
152     }
153 
154     /**
155      * Set allowance for other address and notify
156      *
157      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
158      *
159      * @param _spender The address authorized to spend
160      * @param _value the max amount they can spend
161      * @param _extraData some extra information to send to the approved contract
162      */
163     function approveAndCall(address _spender, uint256 _value, bytes _extraData)  public returns (bool success) {
164         tokenRecipient spender = tokenRecipient(_spender);
165         if (approve(_spender, _value)) {
166             spender.receiveApproval(msg.sender, _value, this, _extraData);
167             return true;
168         }
169     }
170 
171     /**
172      * @dev Function to check the amount of tokens that an owner allowed to a spender.
173      * @param _owner address The address which owns the funds.
174      * @param _spender address The address which will spend the funds.
175      * @return A uint256 specifying the amount of tokens still available for the spender.
176      */
177     function allowance(address _owner, address _spender) public view returns (uint256) {
178         return allowed[_owner][_spender];
179     }
180 
181     /**
182      * @dev Increase the amount of tokens that an owner allowed to a spender.
183      * approve should be called when allowed[_spender] == 0. To increment
184      * allowed value is better to use this function to avoid 2 calls (and wait until
185      * the first transaction is mined)
186      * From MonolithDAO Token.sol
187      * @param _spender The address which will spend the funds.
188      * @param _addedValue The amount of tokens to increase the allowance by.
189      */
190     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
191         allowed[msg.sender][_spender] = (
192         allowed[msg.sender][_spender].add(_addedValue));
193         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194         return true;
195     }
196 
197     /**
198      * @dev Decrease the amount of tokens that an owner allowed to a spender.
199      * approve should be called when allowed[_spender] == 0. To decrement
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      * @param _spender The address which will spend the funds.
204      * @param _subtractedValue The amount of tokens to decrease the allowance by.
205      */
206     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
207         uint256 oldValue = allowed[msg.sender][_spender];
208         if (_subtractedValue > oldValue) {
209             allowed[msg.sender][_spender] = 0;
210         } else {
211             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
212         }
213         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214         return true;
215     }
216 
217 }
218 
219 
220 /**
221  * @title SimpleToken
222  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
223  * Note they can later distribute these tokens as they wish using `transfer` and other
224  * `StandardToken` functions.
225  */
226 contract ShatoCoin is StandardToken {
227     string public constant name = "ShatoCoin"; // solium-disable-line uppercase
228     string public constant symbol = "STC"; // solium-disable-line uppercase
229     uint8 public constant decimals = 18; // solium-disable-line uppercase
230 
231     uint256 public constant INITIAL_SUPPLY = 500000000 * (10 ** uint256(decimals));
232 
233 
234     constructor() public {
235         _totalSupply = INITIAL_SUPPLY;
236         balances[msg.sender] = INITIAL_SUPPLY;
237         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
238     }
239 
240 }