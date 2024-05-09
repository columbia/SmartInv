1 pragma solidity ^0.4.24;
2 
3 /**
4 * @dev SafeMath
5 **/
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 
33 /**
34 * @dev ERC20Basic Interface
35 **/
36 contract ERC20Basic {
37     //ERC20 interface
38 
39 
40     //returns the total token supply
41     function totalSupply() public view returns(uint256);
42     //returns the account balance of another account with address
43     function balanceOf(address _owner) public view returns (uint256);
44     //transfer token, must fire Transfer even
45     //this function used for widthdraw
46     function transfer(address _to, uint256 _value) public returns (bool);
47     //transfer token from _from, _to
48     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
49     //allows _spender to withdraw from your account up the _value
50     function approve(address _spender, uint256 _value) public returns (bool);
51     //returns the amount which _spender is still allowed
52     function allowance(address owner, address spender) public view returns (uint256);
53     uint256 totalSupply_;
54 
55     event Transfer(address indexed _from, address indexed _to, uint256 _value);
56     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
57 
58 
59 }
60 
61 /**
62 * @dev StandardToken Interface Function Description
63 **/
64 contract StandardToken is ERC20Basic {
65     using SafeMath for uint256;
66 
67     mapping(address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;
69 
70     /**
71     * @dev return totalSupply
72     */
73     function totalSupply() public view returns (uint256) {
74         return totalSupply_;
75     }
76 
77     /**
78     * @dev transfer token for a specified address
79     * @param _to The address to transfer to.
80     * @param _value The amount to be transferred.
81     */
82     function transfer(address _to, uint256 _value) public returns (bool) {
83         balances[msg.sender] = balances[msg.sender].sub(_value);
84         balances[_to] = balances[_to].add(_value);
85         emit Transfer(msg.sender, _to, _value);
86         return true;
87     }
88 
89     /**
90     * @dev Gets the balance of the specified address.
91     * @param _owner The address to query the the balance of.
92     * @return An uint256 representing the amount owned by the passed address.
93     */
94     function balanceOf(address _owner) public view returns (uint256) {
95         return balances[_owner];
96     }
97 
98     /**
99      * @dev Transfer tokens from one address to another
100      * @param _from address The address which you want to send tokens from
101      * @param _to address The address which you want to transfer to
102      * @param _value uint256 the amout of tokens to be transfered
103      */
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
105         uint _allowance = allowed[_from][msg.sender];
106 
107         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
108         // require (_value <= _allowance);
109 
110         balances[_to] = balances[_to].add(_value);
111         balances[_from] = balances[_from].sub(_value);
112         allowed[_from][msg.sender] = _allowance.sub(_value);
113         emit Transfer(_from, _to, _value);
114         return true;
115     }
116 
117     /**
118      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
119      * @param _spender The address which will spend the funds.
120      * @param _value The amount of tokens to be spent.
121      */
122     function approve(address _spender, uint256 _value) public returns (bool) {
123 
124         // To change the approve amount you first have to reduce the addresses`
125         //  allowance to zero by calling `approve(_spender, 0)` if it is not
126         //  already 0 to mitigate the race condition described here:
127         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
129 
130         allowed[msg.sender][_spender] = _value;
131         emit Approval(msg.sender, _spender, _value);
132         return true;
133     }
134 
135     /**
136      * @dev Function to check the amount of tokens that an owner allowed to a spender.
137      * @param _owner address The address which owns the funds.
138      * @param _spender address The address which will spend the funds.
139      * @return A uint256 specifing the amount of tokens still available for the spender.
140      */
141     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
142         return allowed[_owner][_spender];
143     }
144 
145 }
146 
147 
148 /**
149 * @dev Ownable
150 **/
151 contract Ownable {
152     address public owner;
153 
154 
155     /**
156      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
157      * account.
158      */
159     constructor() public {
160         owner = msg.sender;
161     }
162 
163 
164     /**
165      * @dev Throws if called by any account other than the owner.
166      */
167     modifier onlyOwner() {
168         require(msg.sender == owner);
169         _;
170     }
171 
172     /**
173      * @dev Allows the current owner to transfer control of the contract to a newOwner.
174      * @param newOwner The address to transfer ownership to.
175      */
176     function transferOwnership(address newOwner) public onlyOwner {
177         require(newOwner != address(0));
178         owner = newOwner;
179     }
180 }
181 
182 /**
183 * @dev MintableToken
184 **/
185 contract MintableToken is StandardToken, Ownable {
186     event Mint(address indexed to, uint256 amount);
187     event MintFinished();
188 
189     bool public mintingFinished = false;
190 
191 
192     modifier canMint() {
193         require(!mintingFinished);
194         _;
195     }
196 
197     /**
198      * @dev Function to mint tokens
199      * @param _to The address that will recieve the minted tokens.
200      * @param _amount The amount of tokens to mint.
201      * @return A boolean that indicates if the operation was successful.
202      */
203     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
204         totalSupply_ = totalSupply_.add(_amount);
205         balances[_to] = balances[_to].add(_amount);
206         emit Mint(_to, _amount);
207         emit Transfer(address(0), _to, _amount);
208         return true;
209     }
210 
211     /**
212      * @dev Function to stop minting new tokens.
213      * @return True if the operation was successful.
214      */
215     function finishMinting() public onlyOwner returns (bool) {
216         mintingFinished = true;
217         emit MintFinished();
218         return true;
219     }
220 }
221 
222 
223 
224 /**
225  * @title SimpleToken
226  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
227  * Note they can later distribute these tokens as they wish using `transfer` and other
228  * `ERC20` functions.
229  */
230 contract GlobalPayCoin is MintableToken {
231 
232     string public constant name = "Global Pay Coin";
233     string public constant symbol = "GPC";
234     uint8 public constant decimals = 18;
235 
236     uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
237 
238     /**
239      * @dev Constructor that gives msg.sender all of existing tokens.
240      */
241     constructor(address _owner) public {
242         mint(_owner, INITIAL_SUPPLY);
243         transferOwnership(_owner);
244     }
245 
246     /**
247     * @dev transfer token for a specified address
248     * @param _to The address to transfer to.
249     * @param _value The amount to be transferred.
250     */
251     function transferGasByOwner(address _from, address _to, uint256 _value) public onlyOwner returns (bool) {
252         balances[_from] = balances[_from].sub(_value);
253         balances[_to] = balances[_to].add(_value);
254         emit Transfer(msg.sender, _to, _value);
255         return true;
256     }
257 }