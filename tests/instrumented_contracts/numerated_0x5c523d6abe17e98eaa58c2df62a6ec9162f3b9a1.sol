1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(
13         address indexed previousOwner,
14         address indexed newOwner
15     );
16 
17 
18     /**
19      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20      * account.
21      */
22     constructor() public {
23         owner = msg.sender;
24     }
25 
26     /**
27      * @dev Throws if called by any account other than the owner.
28      */
29     modifier onlyOwner() {
30         require(msg.sender == owner);
31         _;
32     }
33 
34     /**
35      * @dev Allows the current owner to transfer control of the contract to a newOwner.
36      * @param _newOwner The address to transfer ownership to.
37      */
38     function transferOwnership(address _newOwner) public onlyOwner {
39         _transferOwnership(_newOwner);
40     }
41 
42     /**
43      * @dev Transfers control of the contract to a newOwner.
44      * @param _newOwner The address to transfer ownership to.
45      */
46     function _transferOwnership(address _newOwner) internal {
47         require(_newOwner != address(0));
48         emit OwnershipTransferred(owner, _newOwner);
49         owner = _newOwner;
50     }
51 }
52 
53 /**
54  * @title SafeMath
55  * @dev Math operations with safety checks that throw on error
56  */
57 library SafeMath {
58 
59     /**
60     * @dev Multiplies two numbers, throws on overflow.
61     */
62     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
63         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
64         // benefit is lost if 'b' is also tested.
65         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
66         if (a == 0) {
67             return 0;
68         }
69 
70         c = a * b;
71         assert(c / a == b);
72         return c;
73     }
74 
75     /**
76     * @dev Integer division of two numbers, truncating the quotient.
77     */
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {
79         // assert(b > 0); // Solidity automatically throws when dividing by 0
80         // uint256 c = a / b;
81         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
82         return a / b;
83     }
84 
85     /**
86     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
87     */
88     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89         assert(b <= a);
90         return a - b;
91     }
92 
93     /**
94     * @dev Adds two numbers, throws on overflow.
95     */
96     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
97         c = a + b;
98         assert(c >= a);
99         return c;
100     }
101 }
102 
103 /**
104  * @title ERC20Basic
105  * @dev Simpler version of ERC20 interface
106  * See https://github.com/ethereum/EIPs/issues/179
107  */
108 contract ERC20Basic {
109     function totalSupply() public view returns (uint256);
110     function balanceOf(address who) public view returns (uint256);
111     function transfer(address to, uint256 value) public returns (bool);
112     event Transfer(address indexed from, address indexed to, uint256 value);
113 }
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120     function allowance(address owner, address spender)
121     public view returns (uint256);
122 
123     function transferFrom(address from, address to, uint256 value)
124     public returns (bool);
125 
126     function approve(address spender, uint256 value) public returns (bool);
127     event Approval(
128         address indexed owner,
129         address indexed spender,
130         uint256 value
131     );
132 }
133 
134 /**
135  * @title Basic token
136  * @dev Basic version of StandardToken, with no allowances.
137  */
138 contract BasicToken is ERC20Basic {
139     using SafeMath for uint256;
140 
141     mapping(address => uint256) balances;
142 
143     uint256 totalSupply_;
144 
145     /**
146     * @dev Total number of tokens in existence
147     */
148     function totalSupply() public view returns (uint256) {
149         return totalSupply_;
150     }
151 
152     /**
153     * @dev Transfer token for a specified address
154     * @param _to The address to transfer to.
155     * @param _value The amount to be transferred.
156     */
157     function transfer(address _to, uint256 _value) public returns (bool) {
158         require(_value <= balances[msg.sender]);
159         require(_to != address(0));
160 
161         balances[msg.sender] = balances[msg.sender].sub(_value);
162         balances[_to] = balances[_to].add(_value);
163         emit Transfer(msg.sender, _to, _value);
164         return true;
165     }
166 
167     /**
168     * @dev Gets the balance of the specified address.
169     * @param _owner The address to query the the balance of.
170     * @return An uint256 representing the amount owned by the passed address.
171     */
172     function balanceOf(address _owner) public view returns (uint256) {
173         return balances[_owner];
174     }
175 
176 }
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * https://github.com/ethereum/EIPs/issues/20
183  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  */
185 contract StandardToken is ERC20, BasicToken {
186 
187     mapping (address => mapping (address => uint256)) internal allowed;
188 
189 
190     /**
191      * @dev Transfer tokens from one address to another
192      * @param _from address The address which you want to send tokens from
193      * @param _to address The address which you want to transfer to
194      * @param _value uint256 the amount of tokens to be transferred
195      */
196     function transferFrom(
197         address _from,
198         address _to,
199         uint256 _value
200     )
201     public
202     returns (bool)
203     {
204         require(_value <= balances[_from]);
205         require(_value <= allowed[_from][msg.sender]);
206         require(_to != address(0));
207 
208         balances[_from] = balances[_from].sub(_value);
209         balances[_to] = balances[_to].add(_value);
210         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
211         emit Transfer(_from, _to, _value);
212         return true;
213     }
214 
215     /**
216      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217      * Beware that changing an allowance with this method brings the risk that someone may use both the old
218      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221      * @param _spender The address which will spend the funds.
222      * @param _value The amount of tokens to be spent.
223      */
224     function approve(address _spender, uint256 _value) public returns (bool) {
225         allowed[msg.sender][_spender] = _value;
226         emit Approval(msg.sender, _spender, _value);
227         return true;
228     }
229 
230     /**
231      * @dev Function to check the amount of tokens that an owner allowed to a spender.
232      * @param _owner address The address which owns the funds.
233      * @param _spender address The address which will spend the funds.
234      * @return A uint256 specifying the amount of tokens still available for the spender.
235      */
236     function allowance(
237         address _owner,
238         address _spender
239     )
240     public
241     view
242     returns (uint256)
243     {
244         return allowed[_owner][_spender];
245     }
246 
247     /**
248      * @dev Increase the amount of tokens that an owner allowed to a spender.
249      * approve should be called when allowed[_spender] == 0. To increment
250      * allowed value is better to use this function to avoid 2 calls (and wait until
251      * the first transaction is mined)
252      * From MonolithDAO Token.sol
253      * @param _spender The address which will spend the funds.
254      * @param _addedValue The amount of tokens to increase the allowance by.
255      */
256     function increaseApproval(
257         address _spender,
258         uint256 _addedValue
259     )
260     public
261     returns (bool)
262     {
263         allowed[msg.sender][_spender] = (
264         allowed[msg.sender][_spender].add(_addedValue));
265         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266         return true;
267     }
268 
269     /**
270      * @dev Decrease the amount of tokens that an owner allowed to a spender.
271      * approve should be called when allowed[_spender] == 0. To decrement
272      * allowed value is better to use this function to avoid 2 calls (and wait until
273      * the first transaction is mined)
274      * From MonolithDAO Token.sol
275      * @param _spender The address which will spend the funds.
276      * @param _subtractedValue The amount of tokens to decrease the allowance by.
277      */
278     function decreaseApproval(
279         address _spender,
280         uint256 _subtractedValue
281     )
282     public
283     returns (bool)
284     {
285         uint256 oldValue = allowed[msg.sender][_spender];
286         if (_subtractedValue >= oldValue) {
287             allowed[msg.sender][_spender] = 0;
288         } else {
289             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
290         }
291         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
292         return true;
293     }
294 
295 }
296 
297 contract BlockchainToken is StandardToken, Ownable {
298 
299     string public constant name = 'Blockchain Token 2.0';
300 
301     string public constant symbol = 'BCT';
302 
303     uint32 public constant decimals = 18;
304 
305     /**
306      *  how many USD cents for 1 * 10^18 token
307      */
308     uint public price = 210;
309 
310     function setPrice(uint _price) onlyOwner public {
311         price = _price;
312     }
313 
314     uint256 public INITIAL_SUPPLY = 21000000 * 1 ether;
315 
316     /**
317    * @dev Constructor that gives msg.sender all of existing tokens.
318    */
319     constructor() public {
320         totalSupply_ = INITIAL_SUPPLY;
321         balances[msg.sender] = INITIAL_SUPPLY;
322         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
323     }
324 
325 }