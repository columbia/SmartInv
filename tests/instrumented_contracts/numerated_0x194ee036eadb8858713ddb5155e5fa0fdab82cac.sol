1 pragma solidity 0.4.19;
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
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55     function totalSupply() public view returns (uint256);
56 
57     function balanceOf(address who) public view returns (uint256);
58 
59     function transfer(address to, uint256 value) public returns (bool);
60 
61     event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 
65 
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72     function allowance(address owner, address spender) public view returns (uint256);
73 
74     function transferFrom(address from, address to, uint256 value) public returns (bool);
75 
76     function approve(address spender, uint256 value) public returns (bool);
77 
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances.
84  */
85 contract BasicToken is ERC20Basic {
86     using SafeMath for uint256;
87 
88     mapping(address => uint256) balances;
89 
90     uint256 totalSupply_;
91 
92     /**
93     * @dev total number of tokens in existence
94     */
95     function totalSupply() public view returns (uint256) {
96         return totalSupply_;
97     }
98 
99     function transfer(address _to, uint256 _value) public returns (bool) {
100         require(_to != address(0));
101         require(_value <= balances[msg.sender]);
102 
103         // SafeMath.sub will throw if there is not enough balance.
104         balances[msg.sender] = balances[msg.sender].sub(_value);
105         balances[_to] = balances[_to].add(_value);
106         Transfer(msg.sender, _to, _value);
107         return true;
108     }
109 
110     function balanceOf(address _owner) public view returns (uint256 balance) {
111         return balances[_owner];
112     }
113 
114 }
115 
116 /**
117  * @title Ownable
118  * @dev The Ownable contract has an owner address, and provides basic authorization control
119  * functions, this simplifies the implementation of "user permissions".
120  */
121 contract Ownable {
122     address public owner;
123 
124 
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127 
128     /**
129      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
130      * account.
131      */
132     function Ownable() public {
133         owner = msg.sender;
134     }
135 
136     /**
137      * @dev Throws if called by any account other than the owner.
138      */
139     modifier onlyOwner() {
140         require(msg.sender == owner);
141         _;
142     }
143 
144     /**
145      * @dev Allows the current owner to transfer control of the contract to a newOwner.
146      * @param newOwner The address to transfer ownership to.
147      */
148     function transferOwnership(address newOwner) public onlyOwner {
149         require(newOwner != address(0));
150         OwnershipTransferred(owner, newOwner);
151         owner = newOwner;
152     }
153 
154 }
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * @dev https://github.com/ethereum/EIPs/issues/20
161  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165     mapping(address => mapping(address => uint256)) internal allowed;
166 
167 
168     /**
169      * @dev Transfer tokens from one address to another
170      * @param _from address The address which you want to send tokens from
171      * @param _to address The address which you want to transfer to
172      * @param _value uint256 the amount of tokens to be transferred
173      */
174     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
175         require(_to != address(0));
176         require(_value <= balances[_from]);
177         require(_value <= allowed[_from][msg.sender]);
178 
179         balances[_from] = balances[_from].sub(_value);
180         balances[_to] = balances[_to].add(_value);
181         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182         Transfer(_from, _to, _value);
183         return true;
184     }
185 
186     /**
187      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188      *
189      * Beware that changing an allowance with this method brings the risk that someone may use both the old
190      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193      * @param _spender The address which will spend the funds.
194      * @param _value The amount of tokens to be spent.
195      */
196     function approve(address _spender, uint256 _value) public returns (bool) {
197         allowed[msg.sender][_spender] = _value;
198         Approval(msg.sender, _spender, _value);
199         return true;
200     }
201 
202     /**
203      * @dev Function to check the amount of tokens that an owner allowed to a spender.
204      * @param _owner address The address which owns the funds.
205      * @param _spender address The address which will spend the funds.
206      * @return A uint256 specifying the amount of tokens still available for the spender.
207      */
208     function allowance(address _owner, address _spender) public view returns (uint256) {
209         return allowed[_owner][_spender];
210     }
211 
212     /**
213      * @dev Increase the amount of tokens that an owner allowed to a spender.
214      *
215      * approve should be called when allowed[_spender] == 0. To increment
216      * allowed value is better to use this function to avoid 2 calls (and wait until
217      * the first transaction is mined)
218      * From MonolithDAO Token.sol
219      * @param _spender The address which will spend the funds.
220      * @param _addedValue The amount of tokens to increase the allowance by.
221      */
222     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
223         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
224         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225         return true;
226     }
227 
228     /**
229      * @dev Decrease the amount of tokens that an owner allowed to a spender.
230      *
231      * approve should be called when allowed[_spender] == 0. To decrement
232      * allowed value is better to use this function to avoid 2 calls (and wait until
233      * the first transaction is mined)
234      * From MonolithDAO Token.sol
235      * @param _spender The address which will spend the funds.
236      * @param _subtractedValue The amount of tokens to decrease the allowance by.
237      */
238     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
239         uint oldValue = allowed[msg.sender][_spender];
240         if (_subtractedValue > oldValue) {
241             allowed[msg.sender][_spender] = 0;
242         } else {
243             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
244         }
245         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246         return true;
247     }
248 
249 }
250 
251 contract MintableToken is StandardToken, Ownable {
252     event Mint(address indexed to, uint256 amount);
253     event MintFinished();
254 
255     bool public mintingFinished = false;
256 
257 
258     modifier canMint() {
259         require(!mintingFinished);
260         _;
261     }
262 
263     /**
264      * @dev Function to mint tokens
265      * @param _to The address that will receive the minted tokens.
266      * @param _amount The amount of tokens to mint.
267      * @return A boolean that indicates if the operation was successful.
268      */
269     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
270         totalSupply_ = totalSupply_.add(_amount);
271         balances[_to] = balances[_to].add(_amount);
272         Mint(_to, _amount);
273         Transfer(address(0), _to, _amount);
274         return true;
275     }
276 
277     /**
278      * @dev Function to stop minting new tokens.
279      * @return True if the operation was successful.
280      */
281     function finishMinting() onlyOwner canMint public returns (bool) {
282         mintingFinished = true;
283         MintFinished();
284         return true;
285     }
286 }
287 
288 
289 /**
290  * @title SimpleToken
291  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
292  * Note they can later distribute these tokens as they wish using `transfer` and other
293  * `StandardToken` functions.
294  */
295 contract WifiBonusCoin is StandardToken {
296 
297     string public constant name    = "World Wifi Bonus";
298     string public constant symbol  = "WifiB";
299     uint8 public constant decimals = 0;
300 
301     uint256 public constant INITIAL_SUPPLY = 300000000; // * (10 ** uint256(decimals));
302 
303     /**
304      * @dev Constructor that gives msg.sender all of existing tokens.
305      */
306     function WifiBonusCoin() public {
307         totalSupply_ = INITIAL_SUPPLY;
308         balances[msg.sender] = INITIAL_SUPPLY;
309         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
310     }
311 }