1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal constant returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal constant returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43     uint256 public totalSupply;
44     function balanceOf(address who) public constant returns (uint256);
45     function transfer(address to, uint256 value) public returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20 is ERC20Basic {
54     function allowance(address owner, address spender) public constant returns (uint256);
55     function transferFrom(address from, address to, uint256 value) public returns (bool);
56     function approve(address spender, uint256 value) public returns (bool);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, with no allowances.
63  */
64 contract BasicToken is ERC20Basic {
65     using SafeMath for uint256;
66     
67     mapping(address => uint256) balances;
68 
69     /**
70     * @dev transfer token for a specified address
71     * @param _to The address to transfer to.
72     * @param _value The amount to be transferred.
73     */
74     function transfer(address _to, uint256 _value) public returns (bool) {
75         require(_to != address(0));
76         require(_value <= balances[msg.sender]);
77 
78         // SafeMath.sub will throw if there is not enough balance.
79         balances[msg.sender] = balances[msg.sender].sub(_value);
80         balances[_to] = balances[_to].add(_value);
81         Transfer(msg.sender, _to, _value);
82         return true;
83     }
84 
85     /**
86     * @dev Gets the balance of the specified address.
87     * @param _owner The address to query the the balance of.
88     * @return An uint256 representing the amount owned by the passed address.
89     */
90     function balanceOf(address _owner) public constant returns (uint256 balance) {
91         return balances[_owner];
92     }
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103     mapping (address => mapping (address => uint256)) internal allowed;
104 
105 
106     /**
107     * @dev Transfer tokens from one address to another
108     * @param _from address The address which you want to send tokens from
109     * @param _to address The address which you want to transfer to
110     * @param _value uint256 the amount of tokens to be transferred
111     */
112     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113         require(_to != address(0));
114         require(_value <= balances[_from]);
115         require(_value <= allowed[_from][msg.sender]);
116 
117         balances[_from] = balances[_from].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120         Transfer(_from, _to, _value);
121         return true;
122     }
123 
124     /**
125     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126     *
127     * Beware that changing an allowance with this method brings the risk that someone may use both the old
128     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
129     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
130     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131     * @param _spender The address which will spend the funds.
132     * @param _value The amount of tokens to be spent.
133     */
134     function approve(address _spender, uint256 _value) public returns (bool) {
135         allowed[msg.sender][_spender] = _value;
136         Approval(msg.sender, _spender, _value);
137         return true;
138     }
139 
140     /**
141     * @dev Function to check the amount of tokens that an owner allowed to a spender.
142     * @param _owner address The address which owns the funds.
143     * @param _spender address The address which will spend the funds.
144     * @return A uint256 specifying the amount of tokens still available for the spender.
145     */
146     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
147         return allowed[_owner][_spender];
148     }
149 
150     /**
151     * approve should be called when allowed[_spender] == 0. To increment
152     * allowed value is better to use this function to avoid 2 calls (and wait until
153     * the first transaction is mined)
154     * From MonolithDAO Token.sol
155     */
156     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
157         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
158         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159         return true;
160     }
161 
162     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
163         uint oldValue = allowed[msg.sender][_spender];
164         if (_subtractedValue > oldValue) {
165             allowed[msg.sender][_spender] = 0;
166         } else {
167             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
168         }
169         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170         return true;
171     }
172 }
173 
174 /**
175  * @title Ownable
176  * @dev The Ownable contract has an owner address, and provides basic authorization control
177  * functions, this simplifies the implementation of "user permissions".
178  */
179 contract Ownable {
180     address public owner;
181 
182     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183 
184 
185     /**
186      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
187      * account.
188      */
189     function Ownable() public {
190         owner = msg.sender;
191     }
192 
193 
194     /**
195      * @dev Throws if called by any account other than the owner.
196      */
197     modifier onlyOwner() {
198         require(msg.sender == owner);
199         _;
200     }
201 
202 
203     /**
204      * @dev Allows the current owner to transfer control of the contract to a newOwner.
205      * @param newOwner The address to transfer ownership to.
206      */
207     function transferOwnership(address newOwner) public onlyOwner {
208         require(newOwner != address(0));
209         OwnershipTransferred(owner, newOwner);
210         owner = newOwner;
211     }
212 }
213 
214 /**
215  * @title Burnable Token
216  * @dev Token that can be irreversibly burned (destroyed).
217  */
218 contract BurnableToken is StandardToken {
219     event Burn(address indexed burner, uint256 value);
220 
221     /**
222      * @dev Burns a specific amount of tokens.
223      * @param _value The amount of token to be burned.
224      */
225     function burn(uint256 _value) public {
226         require(_value > 0);
227         require(_value <= balances[msg.sender]);
228         // no need to require value <= totalSupply, since that would imply the
229         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
230 
231         address burner = msg.sender;
232         balances[burner] = balances[burner].sub(_value);
233         totalSupply = totalSupply.sub(_value);
234         Burn(burner, _value);
235     }
236 }
237 
238 /**
239  * @title Cedex
240  * @dev Burnable Token, which can be irreversibly destroyed, ERC20 Token, where all tokens are pre-assigned to the creator.
241  * Note they can later distribute these tokens as they wish using `transfer` and other
242  * `StandardToken` functions.
243  */
244 contract Cedex is BurnableToken, Ownable {
245     string public constant name = "CEDEX";
246     string public constant symbol = "CEDEX";
247     uint8 public constant decimals = 18;
248     uint256 public constant INITIAL_SUPPLY = 100000000 * 10**18;
249     mapping(address => uint) public transferAllowedDates;
250 
251     /**
252      * @dev Constructor that gives msg.sender all of existing tokens.
253      */
254     function Cedex() {
255       	totalSupply = INITIAL_SUPPLY;
256         balances[msg.sender] = INITIAL_SUPPLY;
257         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
258     }
259 
260     modifier onlyAfterAllowedDate(address _account) {
261         require(now > transferAllowedDates[_account]);
262             _;
263     }
264 
265     function transfer(address _to, uint _value) onlyAfterAllowedDate(msg.sender) returns (bool) {
266         return super.transfer(_to, _value);
267     }
268 
269     function transferFrom(address _from, address _to, uint256 _value) onlyAfterAllowedDate(_from) returns (bool) {
270         return super.transferFrom(_from, _to, _value);
271     }
272 
273     function distributeToken(address _to, uint _value, uint _transferAllowedDate) onlyOwner {
274         transferAllowedDates[_to] = _transferAllowedDate;
275         super.transfer(_to, _value);
276     }
277 }