1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21     * @dev Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29 
30     /**
31     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 /**
49  * @title ERC20Basic
50  * @dev Simpler version of ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/179
52  */
53 contract ERC20Basic {
54     uint256 public totalSupply;
55 
56     function balanceOf(address who) public constant returns (uint256);
57 
58     function transfer(address to, uint256 value) public returns (bool);
59 
60     event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68     using SafeMath for uint256;
69 
70     mapping(address => uint256) balances;
71 
72     /**
73     * @dev transfer token for a specified address
74     * @param _to The address to transfer to.
75     * @param _value The amount to be transferred.
76     */
77     function transfer(address _to, uint256 _value) public returns (bool) {
78         require(_to != address(0));
79 
80         // SafeMath.sub will throw if there is not enough balance.
81         balances[msg.sender] = balances[msg.sender].sub(_value);
82         balances[_to] = balances[_to].add(_value);
83         emit Transfer(msg.sender, _to, _value);
84         return true;
85     }
86 
87     /**
88     * @dev Gets the balance of the specified address.
89     * @param _owner The address to query the the balance of.
90     * @return An uint256 representing the amount owned by the passed address.
91     */
92     function balanceOf(address _owner) public constant returns (uint256 balance) {
93         return balances[_owner];
94     }
95 }
96 
97 /**
98  * @title ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/20
100  */
101 contract ERC20 is ERC20Basic {
102     function allowance(address owner, address spender) public constant returns (uint256);
103 
104     function transferFrom(address from, address to, uint256 value) public returns (bool);
105 
106     function approve(address spender, uint256 value) public returns (bool);
107 
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 /**
112  * @title Standard ERC20 token
113  *
114  * @dev Implementation of the basic standard token.
115  * @dev https://github.com/ethereum/EIPs/issues/20
116  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
117  */
118 contract StandardToken is ERC20, BasicToken {
119     mapping(address => mapping(address => uint256)) allowed;
120 
121     /**
122      * @dev Transfer tokens from one address to another
123      * @param _from address The address which you want to send tokens from
124      * @param _to address The address which you want to transfer to
125      * @param _value uint256 the amount of tokens to be transferred
126      */
127     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
128         require(_to != address(0));
129 
130         uint256 _allowance = allowed[_from][msg.sender];
131 
132         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
133         // require (_value <= _allowance);
134 
135         balances[_from] = balances[_from].sub(_value);
136         balances[_to] = balances[_to].add(_value);
137         allowed[_from][msg.sender] = _allowance.sub(_value);
138         emit Transfer(_from, _to, _value);
139         return true;
140     }
141 
142     /**
143      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
144      *
145      * Beware that changing an allowance with this method brings the risk that someone may use both the old
146      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
147      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
148      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149      * @param _spender The address which will spend the funds.
150      * @param _value The amount of tokens to be spent.
151      */
152     function approve(address _spender, uint256 _value) public returns (bool) {
153         allowed[msg.sender][_spender] = _value;
154         emit Approval(msg.sender, _spender, _value);
155         return true;
156     }
157 
158     /**
159      * @dev Function to check the amount of tokens that an owner allowed to a spender.
160      * @param _owner address The address which owns the funds.
161      * @param _spender address The address which will spend the funds.
162      * @return A uint256 specifying the amount of tokens still available for the spender.
163      */
164     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
165         return allowed[_owner][_spender];
166     }
167 
168     /**
169      * approve should be called when allowed[_spender] == 0. To increment
170      * allowed value is better to use this function to avoid 2 calls (and wait until
171      * the first transaction is mined)
172      * From MonolithDAO Token.sol
173      */
174     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
175         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
176         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177         return true;
178     }
179 
180     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
181         uint oldValue = allowed[msg.sender][_spender];
182         if (_subtractedValue > oldValue) {
183             allowed[msg.sender][_spender] = 0;
184         } else {
185             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
186         }
187         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188         return true;
189     }
190 }
191 /**
192  * @title Ownable
193  * @dev The Ownable contract has an owner address, and provides basic authorization control
194  * functions, this simplifies the implementation of "user permissions".
195  */
196 contract Ownable {
197     address internal owner;
198 
199     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
200 
201     /**
202      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
203      * account.
204      */
205     constructor() public {
206         owner = msg.sender;
207     }
208 
209     /**
210      * @dev Throws if called by any account other than the owner.
211      */
212     modifier onlyOwner() {
213         require(msg.sender == owner);
214         _;
215     }
216 
217     /**
218      * @dev Allows the current owner to transfer control of the contract to a newOwner.
219      * @param newOwner The address to transfer ownership to.
220      */
221     function transferOwnership(address newOwner) onlyOwner public returns (bool) {
222         require(newOwner != address(0x0));
223         emit OwnershipTransferred(owner, newOwner);
224         owner = newOwner;
225 
226         return true;
227     }
228 }
229 
230 /**
231  * @title Mintable token
232  * @dev Simple ERC20 Token example, with mintable token creation
233  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
234  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
235  */
236 contract MintableToken is StandardToken, Ownable {
237     event Mint(address indexed to, uint256 amount);
238 
239     /**
240      * @dev Function to mint tokens
241      * @param _to The address that will receive the minted tokens.
242      * @param _amount The amount of tokens to mint.
243      * @return A boolean that indicates if the operation was successful.
244      */
245 
246     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
247         totalSupply = SafeMath.add(totalSupply, _amount);
248         balances[_to] = balances[_to].add(_amount);
249         emit Mint(_to, _amount);
250         emit Transfer(0x0, _to, _amount);
251         return true;
252     }
253 }
254 
255 /**
256  * @title Capped token
257  * @dev Mintable token with a token cap.
258  */
259 contract CappedToken is MintableToken {
260     uint256 public cap;
261 
262     constructor(uint256 _cap) public {
263         require(_cap > 0);
264         cap = _cap;
265     }
266 
267     /**
268      * @dev Function to mint tokens
269      * @param _to The address that will receive the minted tokens.
270      * @param _amount The amount of tokens to mint.
271      * @return A boolean that indicates if the operation was successful.
272      */
273     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
274         require(totalSupply.add(_amount) <= cap);
275 
276         return super.mint(_to, _amount);
277     }
278 }
279 
280 /**
281  * @title BitNauticToken
282  * @author Carlo Vespa || Junaid Mushtaq || Hamza Yasin || Talha Yusuf
283  */
284 contract BitNauticToken is CappedToken {
285     string public constant name = "BitNautic Token";
286     string public constant symbol = "BTNT";
287     uint8 public constant decimals = 18;
288 
289     constructor()
290     CappedToken(50000000 * 10 ** uint256(decimals)) public
291     {
292 
293     }
294 }