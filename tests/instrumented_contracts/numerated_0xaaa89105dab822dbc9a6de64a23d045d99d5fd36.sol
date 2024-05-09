1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46     uint256 public totalSupply;
47     function balanceOf(address who) public view returns (uint256);
48     function transfer(address to, uint256 value) public returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 
53 
54 /**
55  * @title ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/20
57  */
58 contract ERC20 is ERC20Basic {
59     function allowance(address owner, address spender) public view returns (uint256);
60     function transferFrom(address from, address to, uint256 value) public returns (bool);
61     function approve(address spender, uint256 value) public returns (bool);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 
66 
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances.
71  */
72 contract BasicToken is ERC20Basic {
73     using SafeMath for uint256;
74 
75     mapping(address => uint256) balances;
76 
77     /**
78     * @dev transfer token for a specified address
79     * @param _to The address to transfer to.
80     * @param _value The amount to be transferred.
81     */
82     function transfer(address _to, uint256 _value) public returns (bool) {
83         require(_to != address(0));
84         require(_value <= balances[msg.sender]);
85 
86         // SafeMath.sub will throw if there is not enough balance.
87         balances[msg.sender] = balances[msg.sender].sub(_value);
88         balances[_to] = balances[_to].add(_value);
89         Transfer(msg.sender, _to, _value);
90         return true;
91     }
92 
93     /**
94     * @dev Gets the balance of the specified address.
95     * @param _owner The address to query the the balance of.
96     * @return An uint256 representing the amount owned by the passed address.
97     */
98     function balanceOf(address _owner) public view returns (uint256 balance) {
99         return balances[_owner];
100     }
101 
102 }
103 
104 
105 
106 /**
107  * @title Standard ERC20 token
108  *
109  * @dev Implementation of the basic standard token.
110  * @dev https://github.com/ethereum/EIPs/issues/20
111  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
112  */
113 contract StandardToken is ERC20, BasicToken {
114 
115     mapping (address => mapping (address => uint256)) internal allowed;
116 
117 
118     /**
119      * @dev Transfer tokens from one address to another
120      * @param _from address The address which you want to send tokens from
121      * @param _to address The address which you want to transfer to
122      * @param _value uint256 the amount of tokens to be transferred
123      */
124     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
125         require(_to != address(0));
126         require(_value <= balances[_from]);
127         require(_value <= allowed[_from][msg.sender]);
128 
129         balances[_from] = balances[_from].sub(_value);
130         balances[_to] = balances[_to].add(_value);
131         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
132         Transfer(_from, _to, _value);
133         return true;
134     }
135 
136     /**
137      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
138      *
139      * Beware that changing an allowance with this method brings the risk that someone may use both the old
140      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
141      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
142      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143      * @param _spender The address which will spend the funds.
144      * @param _value The amount of tokens to be spent.
145      */
146     function approve(address _spender, uint256 _value) public returns (bool) {
147         allowed[msg.sender][_spender] = _value;
148         Approval(msg.sender, _spender, _value);
149         return true;
150     }
151 
152     /**
153      * @dev Function to check the amount of tokens that an owner allowed to a spender.
154      * @param _owner address The address which owns the funds.
155      * @param _spender address The address which will spend the funds.
156      * @return A uint256 specifying the amount of tokens still available for the spender.
157      */
158     function allowance(address _owner, address _spender) public view returns (uint256) {
159         return allowed[_owner][_spender];
160     }
161 
162     /**
163      * approve should be called when allowed[_spender] == 0. To increment
164      * allowed value is better to use this function to avoid 2 calls (and wait until
165      * the first transaction is mined)
166      * From MonolithDAO Token.sol
167      */
168     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
169         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
170         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171         return true;
172     }
173 
174     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
175         uint oldValue = allowed[msg.sender][_spender];
176         if (_subtractedValue > oldValue) {
177             allowed[msg.sender][_spender] = 0;
178         } else {
179             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
180         }
181         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182         return true;
183     }
184 
185 }
186 
187 
188 /**
189  * @title Burnable Token
190  * @dev Token that can be irreversibly burned (destroyed).
191  */
192 contract BurnableToken is StandardToken {
193 
194     event Burn(address indexed burner, uint256 value);
195 
196     /**
197      * @dev Burns a specific amount of tokens.
198      * @param _value The amount of token to be burned.
199      */
200     function burn(uint256 _value) public {
201         require(_value > 0);
202         require(_value <= balances[msg.sender]);
203         // no need to require value <= totalSupply, since that would imply the
204         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
205 
206         address burner = msg.sender;
207         balances[burner] = balances[burner].sub(_value);
208         totalSupply = totalSupply.sub(_value);
209         Burn(burner, _value);
210     }
211 }
212 
213 
214 
215 /**
216  * @title Ownable
217  * @dev The Ownable contract has an owner address, and provides basic authorization control
218  * functions, this simplifies the implementation of "user permissions".
219  */
220 contract Ownable {
221     address public owner;
222 
223 
224     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225 
226 
227     /**
228      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
229      * account.
230      */
231     function Ownable() public {
232         owner = msg.sender;
233     }
234 
235 
236     /**
237      * @dev Throws if called by any account other than the owner.
238      */
239     modifier onlyOwner() {
240         require(msg.sender == owner);
241         _;
242     }
243 
244 
245     /**
246      * @dev Allows the current owner to transfer control of the contract to a newOwner.
247      * @param newOwner The address to transfer ownership to.
248      */
249     function transferOwnership(address newOwner) public onlyOwner {
250         require(newOwner != address(0));
251         OwnershipTransferred(owner, newOwner);
252         owner = newOwner;
253     }
254 
255 }
256 
257 
258 
259 /**
260  * @title Mintable token
261  * @dev Simple ERC20 Token example, with mintable token creation
262  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
263  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
264  */
265 
266 contract MintableToken is StandardToken, Ownable {
267     event Mint(address indexed to, uint256 amount);
268     event MintFinished();
269 
270     bool public mintingFinished = false;
271 
272 
273     modifier canMint() {
274         require(!mintingFinished);
275         _;
276     }
277 
278     /**
279      * @dev Function to mint tokens
280      * @param _to The address that will receive the minted tokens.
281      * @param _amount The amount of tokens to mint.
282      * @return A boolean that indicates if the operation was successful.
283      */
284     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
285         totalSupply = totalSupply.add(_amount);
286         balances[_to] = balances[_to].add(_amount);
287         Mint(_to, _amount);
288         Transfer(address(0), _to, _amount);
289         return true;
290     }
291 
292     /**
293      * @dev Function to stop minting new tokens.
294      * @return True if the operation was successful.
295      */
296     function finishMinting() onlyOwner canMint public returns (bool) {
297         mintingFinished = true;
298         MintFinished();
299         return true;
300     }
301 }
302 
303 
304 
305 contract HireGoToken is MintableToken, BurnableToken {
306 
307     string public constant name = "HireGo";
308     string public constant symbol = "HGO";
309     uint32 public constant decimals = 18;
310 
311     function HireGoToken() public {
312         totalSupply = 100000000E18;  //100m
313         balances[owner] = totalSupply; // Add all tokens to issuer balance (crowdsale in this case)
314     }
315 
316 }