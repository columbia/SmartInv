1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     
10     address public owner;
11 
12     /**
13     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14     * account.
15     */
16     function Ownable()public {
17         owner = msg.sender;
18     }
19     
20     /**
21     * @dev Throws if called by any account other than the owner.
22     */
23     modifier onlyOwner() {
24         require(msg.sender == owner);
25         _;
26     }
27    
28     /**
29     * @dev Allows the current owner to transfer control of the contract to a newOwner.
30     * @param newOwner The address to transfer ownership to.
31     */
32     function transferOwnership(address newOwner)public onlyOwner {
33         require(newOwner != address(0));      
34         owner = newOwner;
35     }
36 }
37 
38 /**
39 * @title ERC20Basic
40 * @dev Simpler version of ERC20 interface
41 * @dev https://github.com/ethereum/EIPs/issues/179
42 */
43 contract ERC20Basic is Ownable {
44     uint256 public totalSupply;
45     function balanceOf(address who) public constant returns (uint256);
46     function transfer(address to, uint256 value)public returns (bool);
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 /**
51 * @title ERC20 interface
52 * @dev https://github.com/ethereum/EIPs/issues/20
53 */
54 contract ERC20 is ERC20Basic {
55     function allowance(address owner, address spender)public constant returns (uint256);
56     function transferFrom(address from, address to, uint256 value)public returns(bool);
57     function approve(address spender, uint256 value)public returns (bool);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 /**
62 * @title SafeMath
63 * @dev Math operations with safety checks that throw on error
64 */
65 library SafeMath {
66     
67     function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
68         uint256 c = a * b;
69         assert(a == 0 || c / a == b);
70         return c;
71     }
72     
73     function div(uint256 a, uint256 b) internal pure  returns (uint256) {
74         // assert(b > 0); // Solidity automatically throws when dividing by 0
75         uint256 c = a / b;
76         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77         return c;
78     }
79     
80     function sub(uint256 a, uint256 b) internal pure  returns (uint256) {
81         assert(b <= a);
82         return a - b;
83     }
84     
85     function add(uint256 a, uint256 b) internal pure  returns (uint256) {
86         uint256 c = a + b;
87         assert(c >= a);
88         return c;
89     }
90 }
91 
92 /**
93  * @title Basic token
94  * @dev Basic version of StandardToken, with no allowances. 
95  */
96 contract BasicToken is ERC20Basic {
97     
98     using SafeMath for uint256;
99     
100     mapping(address => uint256) balances;
101 
102     bool public freeze = false;
103     
104     address contractICOAddress;
105     
106     function setContractICOAddress(address ICOAddress) public onlyOwner {
107         contractICOAddress = ICOAddress;
108     }
109 
110     /**
111     * @dev Changes the value of freeze variable.
112     */
113     function freezeToken()public onlyOwner {
114         freeze = !freeze;
115     }
116     
117     /**
118     * @dev Throws if called when contract is frozen.
119     */
120     modifier isNotFrozen(){
121         require(!freeze || msg.sender == contractICOAddress);
122         _;
123     }
124 
125     /**
126     * @dev Transfers tokens to a specified address.
127     * @param _to The address to transfer to.
128     * @param _value The amount to be transferred.
129     */
130     function transfer(address _to, uint256 _value) isNotFrozen public returns (bool) {
131         balances[msg.sender] = balances[msg.sender].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133         Transfer(msg.sender, _to, _value);
134         return true;
135     }
136     
137     /**
138     * @dev Gets the balance of the specified address.
139     * @param _owner The address to query the balance of.
140     */
141     function balanceOf(address _owner)public constant returns (uint256 balance) {
142         return balances[_owner];
143     }
144 }
145 
146 /**
147  * @title Standard ERC20 token
148  * @dev Implementation of the basic standard token.
149  * @dev https://github.com/ethereum/EIPs/issues/20
150  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract StandardToken is ERC20, BasicToken {
153 
154     mapping (address => mapping (address => uint256)) allowed;
155     
156     /**
157     * @dev Transfers tokens from one address to another.
158     * @param _from The address which you want to send tokens from.
159     * @param _to The address which you want to transfer to.
160     * @param _value The amount of tokens to be transfered.
161     */
162     function transferFrom(address _from, address _to, uint256 _value) isNotFrozen public returns(bool) {
163         require(_value <= allowed[_from][msg.sender]);
164         var _allowance = allowed[_from][msg.sender];
165         balances[_to] = balances[_to].add(_value);
166         balances[_from] = balances[_from].sub(_value);
167         allowed[_from][msg.sender] = _allowance.sub(_value);
168         Transfer(_from, _to, _value);
169         return true;
170     }
171     
172     /**
173     * @dev Approves the passed address to spend the specified amount of tokens on behalf of msg.sender.
174     * @param _spender The address which will spend the funds.
175     * @param _value The amount of tokens to be spent.
176     */
177     function approve(address _spender, uint256 _value) isNotFrozen public returns (bool) {
178         require((_value > 0)&&(_value <= balances[msg.sender]));
179         allowed[msg.sender][_spender] = _value;
180         Approval(msg.sender, _spender, _value);
181         return true;
182     }
183     
184     /**
185     * @dev Function to check the amount of tokens that an owner allowed to a spender.
186     * @param _owner The address which owns the funds.
187     * @param _spender The address which will spend the funds.
188     */
189     function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
190         return allowed[_owner][_spender];
191     }
192 }
193 
194 /**
195  * @title Mintable token
196  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
197  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
198  */
199 contract MintableToken is StandardToken {
200     
201     event Mint(address indexed to, uint256 amount);
202     
203     event MintFinished();
204 
205     bool public mintingFinished = false;
206     
207     /**
208     * @dev Throws if called when minting is finished.
209     */
210     modifier canMint() {
211         require(!mintingFinished);
212         _;
213     }
214     
215     /**
216     * @dev Function to mint tokens
217     * @param _to The address that will recieve the minted tokens.
218     * @param _amount The amount of tokens to mint.
219     */
220     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
221         totalSupply = totalSupply.add(_amount);
222         balances[_to] = balances[_to].add(_amount);
223         Mint(_to, _amount);
224         return true;
225     }
226     
227     /**
228     * @dev Function to stop minting new tokens.
229     */
230     function finishMinting() public onlyOwner returns (bool) {
231         mintingFinished = true;
232         MintFinished();
233         return true;
234     }
235 }
236 
237 /**
238  * @title Burnable Token
239  * @dev Token that can be irreversibly burned (destroyed).
240  */
241 contract BurnableToken is MintableToken {
242     
243     using SafeMath for uint;
244     
245     /**
246     * @dev Burns a specific amount of tokens.
247     * @param _value The amount of token to be burned.
248     */
249     function burn(uint _value) isNotFrozen public returns (bool success) {
250         require((_value > 0) && (_value <= balances[msg.sender]));
251         balances[msg.sender] = balances[msg.sender].sub(_value);
252         totalSupply = totalSupply.sub(_value);
253         Burn(msg.sender, _value);
254         return true;
255     }
256  
257     event Burn(address indexed burner, uint indexed value);
258 }
259 
260 /**
261  * @title SimpleTokenCoin
262  * @dev SimpleToken is a standard ERC20 token with some additional functionality
263  */
264 contract BitcoinCityCoin is BurnableToken {
265     
266     string public constant name = "Bitcoin City";
267     
268     string public constant symbol = "BCKEY";
269     
270     uint32 public constant decimals = 8;
271     
272     address private contractAddress;
273     
274     
275     /**
276     * @dev The BitcoinCityCoin constructor mints tokens to four address.
277     */
278     function BitcoinCityCoin() public {
279        mint(msg.sender, 500000000 * 10**8);
280     }
281     
282     
283      /**
284     * @dev Sets the address of approveAndCall contract.
285     * @param _address The address of approveAndCall contract.
286     */
287     function setContractAddress (address _address) public onlyOwner {
288         contractAddress = _address;
289     }
290     
291     /**
292      * @dev Token owner can approve for spender to execute another function.
293      * @param tokens Amount of tokens to execute function.
294      * @param data Additional data.
295      */
296     function approveAndCall(uint tokens, bytes data) isNotFrozen public returns (bool success) {
297         approve(contractAddress, tokens);
298         ApproveAndCallFallBack(contractAddress).receiveApproval(msg.sender, tokens, data);
299         return true;
300     }
301 }
302 
303 interface ApproveAndCallFallBack { function receiveApproval(address from, uint256 tokens, bytes data) external; }