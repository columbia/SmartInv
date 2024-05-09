1 pragma solidity 0.4.19;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title Ownable
28  * @dev The Ownable contract has an owner address, and provides basic authorization control
29  * functions, this simplifies the implementation of "user permissions".
30  */
31 contract Ownable {
32   address public owner;
33 
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   function Ownable() public {
43     owner = msg.sender;
44   }
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) public onlyOwner {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76     if (a == 0) {
77       return 0;
78     }
79     uint256 c = a * b;
80     assert(c / a == b);
81     return c;
82   }
83 
84   /**
85   * @dev Integer division of two numbers, truncating the quotient.
86   */
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return c;
92   }
93 
94   /**
95   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
96   */
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   /**
103   * @dev Adds two numbers, throws on overflow.
104   */
105   function add(uint256 a, uint256 b) internal pure returns (uint256) {
106     uint256 c = a + b;
107     assert(c >= a);
108     return c;
109   }
110 }
111 
112 contract MarginlessToken is ERC20, Ownable {
113     using SafeMath for uint256;
114 
115     string public constant name = "Marginless Token";
116     string public constant symbol = "MRS";
117     uint8 public constant decimals = 18;
118 
119     mapping (address => uint256) private balances;
120     mapping (address => mapping (address => uint256)) internal allowed;
121 
122     event Mint(address indexed to, uint256 amount);
123     event MintFinished();
124 
125     bool public mintingFinished = false;
126 
127     uint256 private totalSupply_;
128 
129     modifier canTransfer() {
130         require(mintingFinished);
131         _;
132     }
133 
134     /**
135     * @dev total number of tokens in existence
136     */
137     function totalSupply() public view returns (uint256) {
138         return totalSupply_;
139     }
140 
141     /**
142     * @dev transfer token for a specified address
143     * @param _to The address to transfer to.
144     * @param _value The amount to be transferred.
145     */
146     function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
147         require(_to != address(0));
148         require(_value <= balances[msg.sender]);
149 
150         // SafeMath.sub will throw if there is not enough balance.
151         balances[msg.sender] = balances[msg.sender].sub(_value);
152         balances[_to] = balances[_to].add(_value);
153         Transfer(msg.sender, _to, _value);
154         return true;
155     }
156 
157     /**
158     * @dev Gets the balance of the specified address.
159     * @param _owner The address to query the the balance of.
160     * @return An uint256 representing the amount owned by the passed address.
161     */
162     function balanceOf(address _owner) public view returns (uint256 balance) {
163         return balances[_owner];
164     }
165 
166     /**
167     * @dev Transfer tokens from one address to another
168     * @param _from address The address which you want to send tokens from
169     * @param _to address The address which you want to transfer to
170     * @param _value uint256 the amount of tokens to be transferred
171     */
172     function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
173         require(_to != address(0));
174         require(_value <= balances[_from]);
175         require(_value <= allowed[_from][msg.sender]);
176 
177         balances[_from] = balances[_from].sub(_value);
178         balances[_to] = balances[_to].add(_value);
179         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
180         Transfer(_from, _to, _value);
181         return true;
182     }
183 
184     /**
185     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186     *
187     * Beware that changing an allowance with this method brings the risk that someone may use both the old
188     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191     * @param _spender The address which will spend the funds.
192     * @param _value The amount of tokens to be spent.
193     */
194     function approve(address _spender, uint256 _value) public returns (bool) {
195         allowed[msg.sender][_spender] = _value;
196         Approval(msg.sender, _spender, _value);
197         return true;
198     }
199 
200     /**
201     * @dev Function to check the amount of tokens that an owner allowed to a spender.
202     * @param _owner address The address which owns the funds.
203     * @param _spender address The address which will spend the funds.
204     * @return A uint256 specifying the amount of tokens still available for the spender.
205     */
206     function allowance(address _owner, address _spender) public view returns (uint256) {
207         return allowed[_owner][_spender];
208     }
209 
210     /**
211     * @dev Increase the amount of tokens that an owner allowed to a spender.
212     *
213     * approve should be called when allowed[_spender] == 0. To increment
214     * allowed value is better to use this function to avoid 2 calls (and wait until
215     * the first transaction is mined)
216     * From MonolithDAO Token.sol
217     * @param _spender The address which will spend the funds.
218     * @param _addedValue The amount of tokens to increase the allowance by.
219     */
220     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
221         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
222         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223         return true;
224     }
225 
226     /**
227     * @dev Decrease the amount of tokens that an owner allowed to a spender.
228     *
229     * approve should be called when allowed[_spender] == 0. To decrement
230     * allowed value is better to use this function to avoid 2 calls (and wait until
231     * the first transaction is mined)
232     * From MonolithDAO Token.sol
233     * @param _spender The address which will spend the funds.
234     * @param _subtractedValue The amount of tokens to decrease the allowance by.
235     */
236     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
237         uint oldValue = allowed[msg.sender][_spender];
238         if (_subtractedValue > oldValue) {
239             allowed[msg.sender][_spender] = 0;
240         } else {
241             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
242         }
243         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244         return true;
245     }
246 
247     modifier canMint() {
248         require(!mintingFinished);
249         _;
250     }
251 
252     /**
253     * @dev Function to mint tokens
254     * @param _to The address that will receive the minted tokens.
255     * @param _amount The amount of tokens to mint.
256     * @return A boolean that indicates if the operation was successful.
257     */
258     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
259         totalSupply_ = totalSupply_.add(_amount);
260         balances[_to] = balances[_to].add(_amount);
261         Mint(_to, _amount);
262         Transfer(address(0), _to, _amount);
263         return true;
264     }
265 
266     /**
267     * @dev Function to stop minting new tokens.
268     * @return True if the operation was successful.
269     */
270     function finishMinting() public onlyOwner canMint returns (bool) {
271         mintingFinished = true;
272         MintFinished();
273         return true;
274     }
275 }