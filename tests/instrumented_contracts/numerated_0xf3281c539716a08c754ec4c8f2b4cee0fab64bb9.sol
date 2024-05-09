1 pragma solidity 0.5.11;
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
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40     
41     address public owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47      * account.
48      */
49     constructor() public {
50         owner = msg.sender;
51     }
52 
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address newOwner) onlyOwner public {
67         require(newOwner != address(0));
68         emit OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70     }
71 }
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79     uint256 public totalSupply;
80     function balanceOf(address who) public view returns (uint256);
81     function transfer(address to, uint256 value) public returns (bool);
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 
86 /**
87  * @title Basic token
88  * @dev Basic version of StandardToken, with no allowances.
89  */
90 contract BasicToken is ERC20Basic {
91 
92     using SafeMath for uint256;
93 
94     mapping(address => uint256) internal balances;
95 
96     /**
97      * @dev transfer token for a specified address
98      * @param _to The address to transfer to.
99      * @param _value The amount to be transferred.
100      */
101     function transfer(address _to, uint256 _value) public returns (bool) {
102         require(_to != address(0) && _to != address(this));
103 
104         // SafeMath.sub will throw if there is not enough balance.
105         balances[msg.sender] = balances[msg.sender].sub(_value);
106         balances[_to] = balances[_to].add(_value);
107         emit Transfer(msg.sender, _to, _value);
108         return true;
109     }
110 
111     /**
112      * @dev Gets the balance of the specified address.
113      * @param _owner The address to query the the balance of.
114      * @return An uint256 representing the amount owned by the passed address.
115      */
116     function balanceOf(address _owner) public view returns (uint256 balance) {
117         return balances[_owner];
118     }
119 }
120 
121 /**
122  * @title ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/20
124  */
125 contract ERC20 is ERC20Basic {
126     function allowance(address owner, address spender) public view returns (uint256);
127     function transferFrom(address from, address to, uint256 value) public returns (bool);
128     function approve(address spender, uint256 value) public returns (bool);
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 
133 /**
134  * @title Standard ERC20 token
135  *
136  * @dev Implementation of the basic standard token.
137  * @dev https://github.com/ethereum/EIPs/issues/20
138 
139  */
140 contract StandardToken is ERC20, BasicToken {
141 
142     mapping (address => mapping (address => uint256)) internal allowed;
143 
144     /**
145      * @dev Transfer tokens from one address to another
146      * @param _from address The address which you want to send tokens from
147      * @param _to address The address which you want to transfer to
148      * @param _value uint256 the amount of tokens to be transferred
149      */
150     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
151         require(_to != address(0) && _to != address(this));
152 
153         uint256 _allowance = allowed[_from][msg.sender];
154 
155         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
156         // require (_value <= _allowance);
157 
158         balances[_from] = balances[_from].sub(_value);
159         balances[_to] = balances[_to].add(_value);
160         allowed[_from][msg.sender] = _allowance.sub(_value);
161         emit Transfer(_from, _to, _value);
162         return true;
163     }
164 
165    /**
166     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167     *
168     * Beware that changing an allowance with this method brings the risk that someone may use both the old
169     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172     * @param _spender The address which will spend the funds.
173     * @param _value The amount of tokens to be spent.
174     */
175     function approve(address _spender, uint256 _value) public returns (bool) {
176         allowed[msg.sender][_spender] = _value;
177         emit Approval(msg.sender, _spender, _value);
178         return true;
179     }
180 
181     /**
182      * @dev Function to check the amount of tokens that an owner allowed to a spender.
183      * @param _owner address The address which owns the funds.
184      * @param _spender address The address which will spend the funds.
185      * @return A uint256 specifying the amount of tokens still available for the spender.
186      */
187     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
188         return allowed[_owner][_spender];
189     }
190 
191     /**
192      * approve should be called when allowed[_spender] == 0. To increment
193      * allowed value is better to use this function to avoid 2 calls (and wait until
194      * the first transaction is mined)
195      * From MonolithDAO Token.sol
196      */
197     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
198         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
199         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200         return true;
201     }
202 
203     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
204         uint oldValue = allowed[msg.sender][_spender];
205         if (_subtractedValue > oldValue) {
206             allowed[msg.sender][_spender] = 0;
207         } else {
208             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
209         }
210         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211         return true;
212     }
213 }
214 
215 
216 /**
217  * @title Burnable Token
218  * @dev Token that can be irreversibly burned (destroyed).
219  */
220  
221 contract BurnableToken is StandardToken {
222 
223     event Burn(address indexed burner, uint256 value);
224 
225     /**
226      * @dev Burns a specific amount of tokens.
227      * @param _value The amount of token to be burned.
228      */
229     function burn(uint256 _value) public {
230         require(_value > 0);
231         require(_value <= balances[msg.sender]);
232         // no need to require value <= totalSupply, since that would imply the
233         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
234 
235         address burner = msg.sender;
236         balances[burner] = balances[burner].sub(_value);
237         totalSupply = totalSupply.sub(_value);
238         emit Burn(burner, _value);
239         emit Transfer(burner, address(0), _value);
240     }
241 }
242 
243 interface tokenRecipient { 
244     function receiveApproval(address _from, uint256 _value, bytes calldata _extraData) external;
245 }
246 
247 contract Markaccy is BurnableToken, Ownable {
248 
249     string public constant name = "Markaccy";
250     string public constant symbol = "MKCY";
251     uint public constant decimals = 18;
252     // there is no problem in using * here instead of .mul()
253     uint256 public constant initialSupply = 100000000 * (10 ** uint256(decimals));
254 
255     // Constructors
256     constructor () public {
257         totalSupply = initialSupply;
258         balances[msg.sender] = initialSupply; // Send all tokens to owner
259         emit Transfer(address(0), msg.sender, initialSupply);
260     }
261     
262     function approveAndCall(address _spender, uint256 _value, bytes calldata _extraData)
263         external
264         returns (bool success) 
265     {
266         tokenRecipient spender = tokenRecipient(_spender);
267         if (approve(_spender, _value)) {
268             spender.receiveApproval(msg.sender, _value, _extraData);
269             return true;
270         }
271     }
272     
273     function transferAnyERC20Token(address _tokenAddress, address _to, uint _amount) public onlyOwner {
274         ERC20(_tokenAddress).transfer(_to, _amount);
275     }
276 }