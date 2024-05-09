1 pragma solidity 0.4.24;
2 
3 /**
4 * @title ERC20Basic
5 * @dev Simpler version of ERC20 interface
6 * @dev see https://github.com/ethereum/EIPs/issues/179
7 */
8 contract ERC20Basic {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16 * @title SafeMath
17 * @dev Math operations with safety checks that throw on error
18 */
19 library SafeMath {
20     /**
21     * @dev Multiplies two numbers, throws on overflow.
22     */
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27         uint256 c = a * b;
28         assert(c / a == b);
29         return c;
30     }
31 
32     /**
33     * @dev Integer division of two numbers, truncating the quotient.
34     */
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         // assert(b > 0); // Solidity automatically throws when dividing by 0
37         // uint256 c = a / b;
38         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39         return a / b;
40     }
41 
42     /**
43     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44     */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         assert(b <= a);
47         return a - b;
48     }
49 
50     /**
51     * @dev Adds two numbers, throws on overflow.
52     */
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         assert(c >= a);
56         return c;
57     }
58 }
59 
60 /**
61 * @title Basic token
62 * @dev Basic version of StandardToken, with no allowances.
63 */
64 contract BasicToken is ERC20Basic {
65     using SafeMath for uint256;
66 
67     mapping(address => uint256) balances;
68 
69     uint256 totalSupply_;
70 
71     /**
72     * @dev total number of tokens in existence
73     */
74     function totalSupply() public view returns (uint256) {
75         return totalSupply_;
76     }
77 
78     /**
79     * @dev transfer token for a specified address
80     * @param _to The address to transfer to.
81     * @param _value The amount to be transferred.
82     */
83     function transfer(address _to, uint256 _value) public returns (bool) {
84         require(_to != address(0));
85         require(_value <= balances[msg.sender]);
86 
87         balances[msg.sender] = balances[msg.sender].sub(_value);
88         balances[_to] = balances[_to].add(_value);
89         emit Transfer(msg.sender, _to, _value);
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
101 }
102 
103 /**
104 * @title ERC20 interface
105 * @dev see https://github.com/ethereum/EIPs/issues/20
106 */
107 contract ERC20 is ERC20Basic {
108     function allowance(address owner, address spender) public view returns (uint256);
109     function transferFrom(address from, address to, uint256 value) public returns (bool);
110     function approve(address spender, uint256 value) public returns (bool);
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 /**
115 * @title Standard ERC20 token
116 *
117 * @dev Implementation of the basic standard token.
118 * @dev https://github.com/ethereum/EIPs/issues/20
119 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
120 */
121 contract StandardToken is ERC20, BasicToken {
122     mapping (address => mapping (address => uint256)) internal allowed;
123 
124     /**
125     * @dev Transfer tokens from one address to another
126     * @param _from address The address which you want to send tokens from
127     * @param _to address The address which you want to transfer to
128     * @param _value uint256 the amount of tokens to be transferred
129     */
130     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
131         require(_to != address(0));
132         require(_value <= balances[_from]);
133         require(_value <= allowed[_from][msg.sender]);
134 
135         balances[_from] = balances[_from].sub(_value);
136         balances[_to] = balances[_to].add(_value);
137         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
138         emit Transfer(_from, _to, _value);
139         return true;
140     }
141 
142     /**
143     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
144     *
145     * Beware that changing an allowance with this method brings the risk that someone may use both the old
146     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
147     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
148     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149     * @param _spender The address which will spend the funds.
150     * @param _value The amount of tokens to be spent.
151     */
152     function approve(address _spender, uint256 _value) public returns (bool) {
153         allowed[msg.sender][_spender] = _value;
154         emit Approval(msg.sender, _spender, _value);
155         return true;
156     }
157 
158     /**
159     * @dev Function to check the amount of tokens that an owner allowed to a spender.
160     * @param _owner address The address which owns the funds.
161     * @param _spender address The address which will spend the funds.
162     * @return A uint256 specifying the amount of tokens still available for the spender.
163     */
164     function allowance(address _owner, address _spender) public view returns (uint256) {
165         return allowed[_owner][_spender];
166     }
167 
168     /**
169     * @dev Increase the amount of tokens that an owner allowed to a spender.
170     *
171     * approve should be called when allowed[_spender] == 0. To increment
172     * allowed value is better to use this function to avoid 2 calls (and wait until
173     * the first transaction is mined)
174     * From MonolithDAO Token.sol
175     * @param _spender The address which will spend the funds.
176     * @param _addedValue The amount of tokens to increase the allowance by.
177     */
178     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
179         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
180         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181         return true;
182     }
183 
184     /**
185     * @dev Decrease the amount of tokens that an owner allowed to a spender.
186     *
187     * approve should be called when allowed[_spender] == 0. To decrement
188     * allowed value is better to use this function to avoid 2 calls (and wait until
189     * the first transaction is mined)
190     * From MonolithDAO Token.sol
191     * @param _spender The address which will spend the funds.
192     * @param _subtractedValue The amount of tokens to decrease the allowance by.
193     */
194     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
195         uint oldValue = allowed[msg.sender][_spender];
196         if (_subtractedValue > oldValue) {
197             allowed[msg.sender][_spender] = 0;
198         } else {
199             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
200         }
201         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202         return true;
203     }
204 }
205 
206 /**
207 * @title Ownable
208 * @dev The Ownable contract has an owner address, and provides basic authorization control
209 * functions, this simplifies the implementation of "user permissions".
210 */
211 contract Ownable {
212     address public owner;
213 
214     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
215 
216     /**
217     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
218     * account.
219     */
220     constructor() public {
221         owner = msg.sender;
222     }
223 
224     /**
225     * @dev Throws if called by any account other than the owner.
226     */
227     modifier onlyOwner() {
228         require(msg.sender == owner);
229         _;
230     }
231 
232     /**
233     * @dev Allows the current owner to transfer control of the contract to a newOwner.
234     * @param newOwner The address to transfer ownership to.
235     */
236     function transferOwnership(address newOwner) public onlyOwner {
237         require(newOwner != address(0));
238         emit OwnershipTransferred(owner, newOwner);
239         owner = newOwner;
240     }
241 }
242 
243 /**
244 * @title DisciplinaToken
245 * @dev disciplina.io token contract.
246 */
247 contract DisciplinaToken is StandardToken, Ownable {
248 
249     string public constant name = "Disciplina Token";
250     string public constant symbol = "DSCP";
251     uint32 public constant decimals = 18;
252 
253     mapping (address => uint256) mintingAllowance;
254 
255     bool public mintingFinished = false;
256 
257     modifier beforeMintingFinished() {
258         require(!mintingFinished);
259         _;
260     }
261 
262     modifier afterMintingFinished() {
263         require(mintingFinished);
264         _;
265     }
266 
267     event MintingApproval(address indexed minter, uint256 amount);
268     event Mint(address indexed to, uint256 amount);
269     event MintFinished();
270 
271     /**
272     * @dev Function to mint tokens
273     * @param _to The address that will receive the minted tokens.
274     * @param _amount The amount of tokens to mint.
275     * @return A boolean that indicates if the operation was successful.
276     */
277     function mint(address _to, uint256 _amount) public beforeMintingFinished returns (bool) {
278         require(mintingAllowance[msg.sender] >= _amount);
279         totalSupply_ = totalSupply_.add(_amount);
280         balances[_to] = balances[_to].add(_amount);
281         mintingAllowance[msg.sender] = mintingAllowance[msg.sender].sub(_amount);
282         emit Mint(_to, _amount);
283         emit Transfer(address(0), _to, _amount);
284         return true;
285     }
286 
287     /**
288     * @dev Function to allow minting by a certain address
289     * @param _minter The address that will make minting requests.
290     * @param _amount The amount of tokens that _minter can mint.
291     * @return A boolean that indicates if the operation was successful.
292     */
293     function allowMint(address _minter, uint256 _amount) public onlyOwner beforeMintingFinished returns (bool) {
294         mintingAllowance[_minter] = _amount;
295         emit MintingApproval(_minter, mintingAllowance[_minter]);
296         return true;
297     }
298 
299     /**
300     * @dev Function to stop minting new tokens.
301     * @return True if the operation was successful.
302     */
303     function finishMinting() public onlyOwner beforeMintingFinished returns (bool) {
304         mintingFinished = true;
305         emit MintFinished();
306         return true;
307     }
308 
309     function transfer(address _to, uint256 _value) public afterMintingFinished returns (bool) {
310         return super.transfer(_to, _value);
311     }
312 
313     function transferFrom(address _from, address _to, uint256 _value) public afterMintingFinished returns (bool) {
314         return super.transferFrom(_from, _to, _value);
315     }
316 }