1 pragma solidity ^0.4.18;
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
32     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56     address public owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61     /**
62      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63      * account.
64      */
65     function Ownable() public {
66         owner = msg.sender;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     /**
78      * @dev Allows the current owner to transfer control of the contract to a newOwner.
79      * @param newOwner The address to transfer ownership to.
80      */
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0));
83         OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85     }
86 
87 }
88 
89 
90 /**
91  * @title ERC20Basic
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/179
94  */
95 contract ERC20Basic {
96     function totalSupply() public view returns (uint256);
97     function balanceOf(address who) public view returns (uint256);
98     function transfer(address to, uint256 value) public returns (bool);
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances.
106  */
107 contract BasicToken is ERC20Basic {
108     using SafeMath for uint256;
109 
110     mapping(address => uint256) balances;
111 
112     uint256 totalSupply_;
113 
114     /**
115     * @dev total number of tokens in existence
116     */
117     function totalSupply() public view returns (uint256) {
118         return totalSupply_;
119     }
120 
121     /**
122     * @dev transfer token for a specified address
123     * @param _to The address to transfer to.
124     * @param _value The amount to be transferred.
125     */
126     function transfer(address _to, uint256 _value) public returns (bool) {
127         require(_to != address(0));
128         require(_value <= balances[msg.sender]);
129 
130         // SafeMath.sub will throw if there is not enough balance.
131         balances[msg.sender] = balances[msg.sender].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133         Transfer(msg.sender, _to, _value);
134         return true;
135     }
136 
137     /**
138     * @dev Gets the balance of the specified address.
139     * @param _owner The address to query the the balance of.
140     * @return An uint256 representing the amount owned by the passed address.
141     */
142     function balanceOf(address _owner) public view returns (uint256 balance) {
143         return balances[_owner];
144     }
145 
146 }
147 
148 
149 /**
150  * @title Burnable Token
151  * @dev Token that can be irreversibly burned (destroyed).
152  */
153 contract BurnableToken is BasicToken {
154 
155     event Burn(address indexed burner, uint256 value);
156 
157     /**
158      * @dev Burns a specific amount of tokens.
159      * @param _value The amount of token to be burned.
160      */
161     function burn(uint256 _value) public {
162         require(_value <= balances[msg.sender]);
163         // no need to require value <= totalSupply, since that would imply the
164         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
165 
166         address burner = msg.sender;
167         balances[burner] = balances[burner].sub(_value);
168         totalSupply_ = totalSupply_.sub(_value);
169         Burn(burner, _value);
170     }
171 }
172 
173 
174 /**
175  * @title ERC20 interface
176  * @dev see https://github.com/ethereum/EIPs/issues/20
177  */
178 contract ERC20 is ERC20Basic {
179     function allowance(address owner, address spender) public view returns (uint256);
180     function transferFrom(address from, address to, uint256 value) public returns (bool);
181     function approve(address spender, uint256 value) public returns (bool);
182     event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 
185 
186 /**
187  * @title Standard ERC20 token
188  *
189  * @dev Implementation of the basic standard token.
190  * @dev https://github.com/ethereum/EIPs/issues/20
191  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
192  */
193 contract StandardToken is ERC20, BasicToken {
194 
195     mapping (address => mapping (address => uint256)) internal allowed;
196 
197     /**
198      * @dev Transfer tokens from one address to another
199      * @param _from address The address which you want to send tokens from
200      * @param _to address The address which you want to transfer to
201      * @param _value uint256 the amount of tokens to be transferred
202      */
203     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
204         require(_to != address(0));
205         require(_value <= balances[_from]);
206         require(_value <= allowed[_from][msg.sender]);
207        
208         
209         balances[_from] = balances[_from].sub(_value);
210         balances[_to] = balances[_to].add(_value);
211         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212         Transfer(_from, _to, _value);
213         return true;
214     }
215 
216     /*
217     
218      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
219      *
220      * Beware that changing an allowance with this method brings the risk that someone may use both the old
221      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
222      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
223      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
224      * @param _spender The address which will spend the funds.
225      * @param _value The amount of tokens to be spent.
226      */
227     function approve(address _spender, uint256 _value) public returns (bool) {
228         allowed[msg.sender][_spender] = _value;
229         Approval(msg.sender, _spender, _value);
230         return true;
231     }
232 
233     /**
234      * @dev Function to check the amount of tokens that an owner allowed to a spender.
235      * @param _owner address The address which owns the funds.
236      * @param _spender address The address which will spend the funds.
237      * @return A uint256 specifying the amount of tokens still available for the spender.
238      */
239     function allowance(address _owner, address _spender) public view returns (uint256) {
240         return allowed[_owner][_spender];
241     }
242 
243     /**
244      * @dev Increase the amount of tokens that an owner allowed to a spender.
245      *
246      * approve should be called when allowed[_spender] == 0. To increment
247      * allowed value is better to use this function to avoid 2 calls (and wait until
248      * the first transaction is mined)
249      * From MonolithDAO Token.sol
250      * @param _spender The address which will spend the funds.
251      * @param _addedValue The amount of tokens to increase the allowance by.
252      */
253     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
254         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
255         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256         return true;
257     }
258 
259     /**
260      * @dev Decrease the amount of tokens that an owner allowed to a spender.
261      *
262      * approve should be called when allowed[_spender] == 0. To decrement
263      * allowed value is better to use this function to avoid 2 calls (and wait until
264      * the first transaction is mined)
265      * From MonolithDAO Token.sol
266      * @param _spender The address which will spend the funds.
267      * @param _subtractedValue The amount of tokens to decrease the allowance by.
268      */
269     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
270         uint oldValue = allowed[msg.sender][_spender];
271         if (_subtractedValue > oldValue) {
272             allowed[msg.sender][_spender] = 0;
273         } else {
274             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
275         }
276         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277         return true;
278     }
279 
280 }
281 
282 
283 
284 
285 /**
286  * @title UDIAtoken
287  */
288 contract UDIAtoken is StandardToken, BurnableToken {
289     string public constant name = "UDIA";
290     string public constant symbol = "UDA";
291     uint8 public constant decimals = 18;
292 
293     uint256 public constant INITIAL_SUPPLY =6000000000000000000000000000; //To change
294 
295     /**
296      * @dev Constructor that gives msg.sender all of existing tokens.
297      */
298     function UDIAtoken() public {
299         totalSupply_ = INITIAL_SUPPLY;
300         balances[msg.sender] = totalSupply_;
301         Transfer(0x0, msg.sender, totalSupply_);
302     }
303 }