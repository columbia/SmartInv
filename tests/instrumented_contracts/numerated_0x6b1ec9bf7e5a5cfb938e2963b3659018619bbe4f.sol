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
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 
28 /**
29  * @title Ownable
30  * @dev The Ownable contract has an owner address, and provides basic authorization control
31  * functions, this simplifies the implementation of "user permissions".
32  */
33 contract Ownable {
34   address public owner;
35 
36 
37   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39 
40   /**
41    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42    * account.
43    */
44   function Ownable() public {
45     owner = msg.sender;
46   }
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56   /**
57    * @dev Allows the current owner to transfer control of the contract to a newOwner.
58    * @param newOwner The address to transfer ownership to.
59    */
60   function transferOwnership(address newOwner) public onlyOwner {
61     require(newOwner != address(0));
62     OwnershipTransferred(owner, newOwner);
63     owner = newOwner;
64   }
65 
66 }
67 
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, throws on overflow.
77   */
78   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79     if (a == 0) {
80       return 0;
81     }
82     uint256 c = a * b;
83     assert(c / a == b);
84     return c;
85   }
86 
87   /**
88   * @dev Integer division of two numbers, truncating the quotient.
89   */
90   function div(uint256 a, uint256 b) internal pure returns (uint256) {
91     // assert(b > 0); // Solidity automatically throws when dividing by 0
92     uint256 c = a / b;
93     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94     return c;
95   }
96 
97   /**
98   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
99   */
100   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101     assert(b <= a);
102     return a - b;
103   }
104 
105   /**
106   * @dev Adds two numbers, throws on overflow.
107   */
108   function add(uint256 a, uint256 b) internal pure returns (uint256) {
109     uint256 c = a + b;
110     assert(c >= a);
111     return c;
112   }
113 }
114 
115 
116 contract DiceGameToken is ERC20, Ownable {
117     using SafeMath for uint256;
118 
119     string public constant name = "DiceGame Token";
120     string public constant symbol = "DICE";
121     uint8 public constant decimals = 18;
122 
123     mapping (address => uint256) private balances;
124     mapping (address => mapping (address => uint256)) internal allowed;
125 
126     event Mint(address indexed to, uint256 amount);
127     event MintFinished();
128 
129     bool public mintingFinished = false;
130 
131     uint256 private totalSupply_;
132 
133     modifier canTransfer() {
134         require(mintingFinished);
135         _;
136     }
137 
138     /**
139     * @dev total number of tokens in existence
140     */
141     function totalSupply() public view returns (uint256) {
142         return totalSupply_;
143     }
144 
145     /**
146     * @dev transfer token for a specified address
147     * @param _to The address to transfer to.
148     * @param _value The amount to be transferred.
149     */
150     function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
151         require(_to != address(0));
152         require(_value <= balances[msg.sender]);
153 
154         // SafeMath.sub will throw if there is not enough balance.
155         balances[msg.sender] = balances[msg.sender].sub(_value);
156         balances[_to] = balances[_to].add(_value);
157         Transfer(msg.sender, _to, _value);
158         return true;
159     }
160 
161     /**
162     * @dev Gets the balance of the specified address.
163     * @param _owner The address to query the the balance of.
164     * @return An uint256 representing the amount owned by the passed address.
165     */
166     function balanceOf(address _owner) public view returns (uint256 balance) {
167         return balances[_owner];
168     }
169 
170     /**
171     * @dev Transfer tokens from one address to another
172     * @param _from address The address which you want to send tokens from
173     * @param _to address The address which you want to transfer to
174     * @param _value uint256 the amount of tokens to be transferred
175     */
176     function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
177         require(_to != address(0));
178         require(_value <= balances[_from]);
179         require(_value <= allowed[_from][msg.sender]);
180 
181         balances[_from] = balances[_from].sub(_value);
182         balances[_to] = balances[_to].add(_value);
183         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184         Transfer(_from, _to, _value);
185         return true;
186     }
187 
188     /**
189     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190     *
191     * Beware that changing an allowance with this method brings the risk that someone may use both the old
192     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195     * @param _spender The address which will spend the funds.
196     * @param _value The amount of tokens to be spent.
197     */
198     function approve(address _spender, uint256 _value) public returns (bool) {
199         allowed[msg.sender][_spender] = _value;
200         Approval(msg.sender, _spender, _value);
201         return true;
202     }
203 
204     /**
205     * @dev Function to check the amount of tokens that an owner allowed to a spender.
206     * @param _owner address The address which owns the funds.
207     * @param _spender address The address which will spend the funds.
208     * @return A uint256 specifying the amount of tokens still available for the spender.
209     */
210     function allowance(address _owner, address _spender) public view returns (uint256) {
211         return allowed[_owner][_spender];
212     }
213 
214     /**
215     * @dev Increase the amount of tokens that an owner allowed to a spender.
216     *
217     * approve should be called when allowed[_spender] == 0. To increment
218     * allowed value is better to use this function to avoid 2 calls (and wait until
219     * the first transaction is mined)
220     * From MonolithDAO Token.sol
221     * @param _spender The address which will spend the funds.
222     * @param _addedValue The amount of tokens to increase the allowance by.
223     */
224     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
225         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
226         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227         return true;
228     }
229 
230     /**
231     * @dev Decrease the amount of tokens that an owner allowed to a spender.
232     *
233     * approve should be called when allowed[_spender] == 0. To decrement
234     * allowed value is better to use this function to avoid 2 calls (and wait until
235     * the first transaction is mined)
236     * From MonolithDAO Token.sol
237     * @param _spender The address which will spend the funds.
238     * @param _subtractedValue The amount of tokens to decrease the allowance by.
239     */
240     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
241         uint oldValue = allowed[msg.sender][_spender];
242         if (_subtractedValue > oldValue) {
243             allowed[msg.sender][_spender] = 0;
244         } else {
245             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246         }
247         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248         return true;
249     }
250 
251     modifier canMint() {
252         require(!mintingFinished);
253         _;
254     }
255 
256     /**
257     * @dev Function to mint tokens
258     * @param _to The address that will receive the minted tokens.
259     * @param _amount The amount of tokens to mint.
260     * @return A boolean that indicates if the operation was successful.
261     */
262     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
263         totalSupply_ = totalSupply_.add(_amount);
264         balances[_to] = balances[_to].add(_amount);
265         Mint(_to, _amount);
266         Transfer(address(0), _to, _amount);
267         return true;
268     }
269 
270     /**
271     * @dev Function to stop minting new tokens.
272     * @return True if the operation was successful.
273     */
274     function finishMinting() public onlyOwner canMint returns (bool) {
275         mintingFinished = true;
276         MintFinished();
277         return true;
278     }
279 }