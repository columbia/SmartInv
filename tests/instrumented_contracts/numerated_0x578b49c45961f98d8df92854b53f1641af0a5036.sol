1 pragma solidity ^0.4.23;
2 
3 //import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
4 //import "zeppelin-solidity/contracts/math/SafeMath.sol";
5 
6 
7 pragma solidity ^0.4.23;
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15     /**
16     * @dev Multiplies two numbers, throws on overflow.
17     */
18     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
19         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
20         // benefit is lost if 'b' is also tested.
21         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
22         if (a == 0) {
23             return 0;
24         }
25 
26         c = a * b;
27         assert(c / a == b);
28         return c;
29     }
30 
31     /**
32     * @dev Integer division of two numbers, truncating the quotient.
33     */
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         // uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return a / b;
39     }
40 
41     /**
42     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         assert(b <= a);
46         return a - b;
47     }
48 
49     /**
50     * @dev Adds two numbers, throws on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
53         c = a + b;
54         assert(c >= a);
55         return c;
56     }
57 }
58 
59 
60 /**
61  * @title ERC20Basic
62  * @dev Simpler version of ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/179
64  */
65 contract ERC20Basic {
66     function totalSupply() public view returns (uint256);
67     function balanceOf(address who) public view returns (uint256);
68     function transfer(address to, uint256 value) public returns (bool);
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 }
71 
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 contract ERC20 is ERC20Basic {
78     function allowance(address owner, address spender) public view returns (uint256);
79     function transferFrom(address from, address to, uint256 value)  public returns (bool);
80     function approve(address spender, uint256 value) public returns (bool);
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 
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
99     /**
100     * @dev transfer token for a specified address
101     * @param _to The address to transfer to.
102     * @param _value The amount to be transferred.
103     */
104     function transfer(address _to, uint256 _value) public returns (bool) {
105         require(_to != address(0));
106         require(_value <= balances[msg.sender]);
107 
108         balances[msg.sender] = balances[msg.sender].sub(_value);
109         balances[_to] = balances[_to].add(_value);
110         emit Transfer(msg.sender, _to, _value);
111         return true;
112     }
113 
114     /**
115     * @dev Gets the balance of the specified address.
116     * @param _owner The address to query the the balance of.
117     * @return An uint256 representing the amount owned by the passed address.
118     */
119     function balanceOf(address _owner) public view returns (uint256) {
120         return balances[_owner];
121     }
122 }
123 
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134     mapping (address => mapping (address => uint256)) internal allowed;
135 
136 
137     /**
138      * @dev Transfer tokens from one address to another
139      * @param _from address The address which you want to send tokens from
140      * @param _to address The address which you want to transfer to
141      * @param _value uint256 the amount of tokens to be transferred
142      */
143     function transferFrom(
144         address _from,
145         address _to,
146         uint256 _value
147     )
148     public
149     returns (bool)
150     {
151         require(_to != address(0));
152         require(_value <= balances[_from]);
153         require(_value <= allowed[_from][msg.sender]);
154 
155         balances[_from] = balances[_from].sub(_value);
156         balances[_to] = balances[_to].add(_value);
157         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158         emit Transfer(_from, _to, _value);
159         return true;
160     }
161 
162     /**
163      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164      *
165      * Beware that changing an allowance with this method brings the risk that someone may use both the old
166      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      * @param _spender The address which will spend the funds.
170      * @param _value The amount of tokens to be spent.
171      */
172     function approve(address _spender, uint256 _value) public returns (bool) {
173         allowed[msg.sender][_spender] = _value;
174         emit Approval(msg.sender, _spender, _value);
175         return true;
176     }
177 
178     /**
179      * @dev Function to check the amount of tokens that an owner allowed to a spender.
180      * @param _owner address The address which owns the funds.
181      * @param _spender address The address which will spend the funds.
182      * @return A uint256 specifying the amount of tokens still available for the spender.
183      */
184     function allowance(
185         address _owner,
186         address _spender
187     )
188     public
189     view
190     returns (uint256)
191     {
192         return allowed[_owner][_spender];
193     }
194 
195     /**
196      * @dev Increase the amount of tokens that an owner allowed to a spender.
197      *
198      * approve should be called when allowed[_spender] == 0. To increment
199      * allowed value is better to use this function to avoid 2 calls (and wait until
200      * the first transaction is mined)
201      * From MonolithDAO Token.sol
202      * @param _spender The address which will spend the funds.
203      * @param _addedValue The amount of tokens to increase the allowance by.
204      */
205     function increaseApproval(
206         address _spender,
207         uint _addedValue
208     )
209     public
210     returns (bool)
211     {
212         allowed[msg.sender][_spender] = (
213         allowed[msg.sender][_spender].add(_addedValue));
214         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217 
218     /**
219      * @dev Decrease the amount of tokens that an owner allowed to a spender.
220      *
221      * approve should be called when allowed[_spender] == 0. To decrement
222      * allowed value is better to use this function to avoid 2 calls (and wait until
223      * the first transaction is mined)
224      * From MonolithDAO Token.sol
225      * @param _spender The address which will spend the funds.
226      * @param _subtractedValue The amount of tokens to decrease the allowance by.
227      */
228     function decreaseApproval(
229         address _spender,
230         uint _subtractedValue
231     )
232     public
233     returns (bool)
234     {
235         uint oldValue = allowed[msg.sender][_spender];
236         if (_subtractedValue > oldValue) {
237             allowed[msg.sender][_spender] = 0;
238         } else {
239             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240         }
241         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242         return true;
243     }
244 }
245 
246 
247 /**
248  * @title Ownable
249  * @dev The Ownable contract has an owner address, and provides basic authorization control
250  * functions, this simplifies the implementation of "user permissions".
251  */
252 contract Ownable {
253     address public owner;
254 
255     event OwnershipRenounced(address indexed previousOwner);
256     event OwnershipTransferred(
257         address indexed previousOwner,
258         address indexed newOwner
259     );
260 
261 
262     /**
263      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
264      * account.
265      */
266     constructor() public {
267         owner = msg.sender;
268     }
269 
270     /**
271      * @dev Throws if called by any account other than the owner.
272      */
273     modifier onlyOwner() {
274         require(msg.sender == owner);
275         _;
276     }
277 
278     /**
279      * @dev Allows the current owner to relinquish control of the contract.
280      */
281 //    function renounceOwnership() public onlyOwner {
282 //        emit OwnershipRenounced(owner);
283 //        owner = address(0);
284 //    }
285 
286     /**
287      * @dev Allows the current owner to transfer control of the contract to a newOwner.
288      * @param _newOwner The address to transfer ownership to.
289      */
290     function transferOwnership(address _newOwner) public onlyOwner {
291         _transferOwnership(_newOwner);
292     }
293 
294     /**
295      * @dev Transfers control of the contract to a newOwner.
296      * @param _newOwner The address to transfer ownership to.
297      */
298     function _transferOwnership(address _newOwner) internal {
299         require(_newOwner != address(0));
300         emit OwnershipTransferred(owner, _newOwner);
301         owner = _newOwner;
302     }
303 }
304 
305 
306 contract LinkaToken is StandardToken, Ownable {
307     using SafeMath for uint256;
308 
309     uint256 public initialSupply;
310     string public name;
311     string public symbol;
312     uint8 public decimals = 18;
313 
314     constructor(uint256 _initialSupply, string _name, string _symbol) public {
315         initialSupply = _initialSupply;
316         name = _name;
317         symbol = _symbol;
318 
319         totalSupply_ = initialSupply.mul(10 ** uint(decimals));
320         balances[msg.sender] = totalSupply_;
321     }
322 }