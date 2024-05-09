1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 contract Ownable {
52     address public owner;
53 
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61     function Ownable() public {
62         owner = msg.sender;
63     }
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68     modifier onlyOwner() {
69         require(msg.sender == owner);
70         _;
71     }
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77     function transferOwnership(address newOwner) public onlyOwner {
78         require(newOwner != address(0));
79         OwnershipTransferred(owner, newOwner);
80         owner = newOwner;
81     }
82 
83 }
84 
85 
86 contract ERC20Basic {
87     function totalSupply() public view returns (uint256);
88     function balanceOf(address who) public view returns (uint256);
89     function transfer(address to, uint256 value) public returns (bool);
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 
94 contract ERC20 is ERC20Basic {
95     function allowance(address owner, address spender) public view returns (uint256);
96     function transferFrom(address from, address to, uint256 value) public returns (bool);
97     function approve(address spender, uint256 value) public returns (bool);
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 
102 contract BasicToken is ERC20Basic {
103     using SafeMath for uint256;
104 
105     mapping(address => uint256) balances;
106 
107     uint256 totalSupply_;
108 
109   /**
110   * @dev total number of tokens in existence
111   */
112     function totalSupply() public view returns (uint256) {
113         return totalSupply_;
114     }
115 
116   /**
117   * @dev transfer token for a specified address
118   * @param _to The address to transfer to.
119   * @param _value The amount to be transferred.
120   */
121     function transfer(address _to, uint256 _value) public returns (bool) {
122         require(_to != address(0));
123         require(_value <= balances[msg.sender]);
124 
125     // SafeMath.sub will throw if there is not enough balance.
126         balances[msg.sender] = balances[msg.sender].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         Transfer(msg.sender, _to, _value);
129         return true;
130     }
131 
132   /**
133   * @dev Gets the balance of the specified address.
134   * @param _owner The address to query the the balance of.
135   * @return An uint256 representing the amount owned by the passed address.
136   */
137     function balanceOf(address _owner) public view returns (uint256 balance) {
138         return balances[_owner];
139     }
140 
141 }
142 
143 
144 contract StandardToken is ERC20, BasicToken {
145 
146     string public name = "ME Token";
147     string public symbol = "MET";
148     uint8 public decimals = 18;
149     mapping (address => mapping (address => uint256)) internal allowed;
150 
151   /**
152    * @dev Transfer tokens from one address to another
153    * @param _from address The address which you want to send tokens from
154    * @param _to address The address which you want to transfer to
155    * @param _value uint256 the amount of tokens to be transferred
156    */
157     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158         require(_to != address(0));
159         require(_value <= balances[_from]);
160         require(_value <= allowed[_from][msg.sender]);
161 
162         balances[_from] = balances[_from].sub(_value);
163         balances[_to] = balances[_to].add(_value);
164         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165         Transfer(_from, _to, _value);
166         return true;
167     }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    *
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179     function approve(address _spender, uint256 _value) public returns (bool) {
180         allowed[msg.sender][_spender] = _value;
181         Approval(msg.sender, _spender, _value);
182         return true;
183     }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifying the amount of tokens still available for the spender.
190    */
191     function allowance(address _owner, address _spender) public view returns (uint256) {
192         return allowed[_owner][_spender];
193     }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _addedValue The amount of tokens to increase the allowance by.
204    */
205     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
206         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
207         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208         return true;
209     }
210 
211   /**
212    * @dev Decrease the amount of tokens that an owner allowed to a spender.
213    *
214    * approve should be called when allowed[_spender] == 0. To decrement
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param _spender The address which will spend the funds.
219    * @param _subtractedValue The amount of tokens to decrease the allowance by.
220    */
221     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
222         uint oldValue = allowed[msg.sender][_spender];
223         if (_subtractedValue > oldValue) {
224             allowed[msg.sender][_spender] = 0;
225         } else {
226             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
227         }
228         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229         return true;
230     }
231 
232 }
233 
234 
235 contract MintableToken is StandardToken, Ownable {
236     event Mint(address indexed to, uint256 amount);
237     event MintFinished();
238 
239     bool public mintingFinished = false;
240 
241     modifier canMint() {
242         require(!mintingFinished);
243         _;
244     }
245 
246   /**
247    * @dev Function to mint tokens
248    * @param _to The address that will receive the minted tokens.
249    * @param _amount The amount of tokens to mint.
250    * @return A boolean that indicates if the operation was successful.
251    */
252     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
253         totalSupply_ = totalSupply_.add(_amount);
254         balances[_to] = balances[_to].add(_amount);
255         Mint(_to, _amount);
256         Transfer(address(0), _to, _amount);
257         return true;
258     }
259 
260   /**
261    * @dev Function to stop minting new tokens.
262    * @return True if the operation was successful.
263    */
264     function finishMinting() public onlyOwner canMint returns (bool) {
265         mintingFinished = true;
266         MintFinished();
267         return true;
268     }
269 }