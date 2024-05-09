1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39     function totalSupply() public view returns (uint256);
40     function balanceOf(address who) public view returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50     function allowance(address owner, address spender) public view returns (uint256);
51     function transferFrom(address from, address to, uint256 value) public returns (bool);
52     function approve(address spender, uint256 value) public returns (bool);
53 
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63     address public owner;
64 
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
81     function transferOwnership(address newOwner) onlyOwner public {
82         require(newOwner != address(0));
83 
84         OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86     }
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 }
90 
91 /**
92  * @title Pausable
93  * @dev Base contract which allows children to implement an emergency stop mechanism.
94  */
95 contract Pausable is Ownable {
96 
97     bool public paused = false;
98 
99     modifier running {
100         require(!paused);
101         _;
102     }
103 
104     function pause() onlyOwner public {
105         paused = true;
106     }
107 
108     function start() onlyOwner public {
109         paused = false;
110     }
111 }
112 
113 /**
114  * @title Basic token
115  * @dev Basic version of StandardToken, with no allowances.
116  */
117 contract BasicToken is ERC20Basic {
118     using SafeMath for uint256;
119 
120     mapping(address => uint256) balances;
121 
122     uint256 totalSupply_;
123 
124     /**
125     * @dev total number of tokens in existence
126     */
127     function totalSupply() public view returns (uint256) {
128         return totalSupply_;
129     }
130 
131     /**
132     * @dev transfer token for a specified address
133     * @param _to The address to transfer to.
134     * @param _value The amount to be transferred.
135     */
136     function transfer(address _to, uint256 _value) public returns (bool) {
137         require(_to != address(0));                                 //Prevent transfer to 0x0 address. Use burn() instead
138         require(_value > 0 && _value <= balances[msg.sender]);      // Check for balance
139         require(balances[_to].add(_value) > balances[_to]);         // Check for overflows
140 
141         balances[msg.sender] = balances[msg.sender].sub(_value);
142         balances[_to] = balances[_to].add(_value);
143         Transfer(msg.sender, _to, _value);
144         return true;
145     }
146 
147     /**
148     * @dev Gets the balance of the specified address.
149     * @param _owner The address to query the the balance of.
150     * @return An uint256 representing the amount owned by the passed address.
151     */
152     function balanceOf(address _owner) public view returns (uint256 balance) {
153         return balances[_owner];
154     }
155 }
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken, Pausable {
165 
166     mapping (address => mapping (address => uint256)) internal allowed;
167     mapping (address => bool) public frozen;
168 
169     function transfer(address _to, uint256 _value) public running returns (bool) {
170         require(!frozen[_to] && !frozen[msg.sender]);
171         return super.transfer(_to, _value);
172     }
173     /**
174     * @dev Transfer tokens from one address to another
175     * @param _from address The address which you want to send tokens from
176     * @param _to address The address which you want to transfer to
177     * @param _value uint256 the amount of tokens to be transferred
178     */
179     function transferFrom(address _from, address _to, uint256 _value) public running returns (bool) {
180         require(_to != address(0));
181         require(!frozen[_to] && !frozen[_from]);
182         require(_value <= balances[_from]);
183         require(_value > 0 && _value <= allowed[_from][msg.sender]);
184         require(balances[_to].add(_value) > balances[_to]);
185 
186         balances[_from] = balances[_from].sub(_value);
187         balances[_to] = balances[_to].add(_value);
188         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189         Transfer(_from, _to, _value);
190         return true;
191     }
192 
193     /**
194     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195     *
196     * Beware that changing an allowance with this method brings the risk that someone may use both the old
197     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
198     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
199     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200     * @param _spender The address which will spend the funds.
201     * @param _value The amount of tokens to be spent.
202     */
203     function approve(address _spender, uint256 _value) public running returns (bool) {
204         require(!frozen[_spender] && !frozen[msg.sender]);
205 
206         allowed[msg.sender][_spender] = _value;
207         Approval(msg.sender, _spender, _value);
208         return true;
209     }
210 
211     /**
212     * @dev Function to check the amount of tokens that an owner allowed to a spender.
213     * @param _owner address The address which owns the funds.
214     * @param _spender address The address which will spend the funds.
215     * @return A uint256 specifying the amount of tokens still available for the spender.
216     */
217     function allowance(address _owner, address _spender) public view returns (uint256) {
218         return allowed[_owner][_spender];
219     }
220 
221     function burn(uint256 _value) public running onlyOwner returns (bool) {
222         require(_value > 0);
223         require(balances[msg.sender] > _value);
224         
225         balances[msg.sender] = balances[msg.sender].sub(_value);
226         totalSupply_ = totalSupply_.sub(_value);
227         Burn(msg.sender, _value);
228         return true;
229     }
230 
231     function mint(uint256 _value) public running onlyOwner returns (bool) {
232         require(_value > 0);
233         require(balances[msg.sender].add(_value) > balances[msg.sender]);
234         require(totalSupply_.add(_value) > totalSupply_);
235 
236         balances[msg.sender] = balances[msg.sender].add(_value);
237         totalSupply_ = totalSupply_.add(_value);
238         return true;
239     }
240 
241     function lock(address _addr) public running onlyOwner returns (bool) {
242         require(_addr != address(0));
243 
244         frozen[_addr] = true;
245         Frozen(_addr, true);
246         return true;
247     }
248 
249     function unlock(address _addr) public running onlyOwner returns (bool) {
250         require(_addr != address(0));
251         require(frozen[_addr]);
252 
253         frozen[_addr] = false;
254         Frozen(_addr, false);
255         return true;
256     }
257 
258     event Burn(address indexed from, uint256 value);
259     event Frozen(address indexed target, bool status);
260 }
261 
262 /**
263  * @title BBEToken
264  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
265  * Note they can later distribute these tokens as they wish using `transfer` and other
266  * `StandardToken` functions.
267  */
268 contract BbeCoin is StandardToken {
269 
270     string public constant name = "BbeCoin";
271     string public constant symbol = "BBE";
272     uint8 public constant decimals = 18;
273 
274     uint256 public constant INITIAL_SUPPLY = 12 * (10 ** 8) * (10 ** uint256(decimals));
275 
276     /**
277     * @dev Constructor that gives msg.sender all of existing tokens.
278     */
279     function BbeCoin() public {
280         totalSupply_ = INITIAL_SUPPLY;
281         balances[msg.sender] = INITIAL_SUPPLY;
282         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
283     }
284 }