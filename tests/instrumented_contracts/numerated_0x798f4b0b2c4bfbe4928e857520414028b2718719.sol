1 pragma solidity ^0.4.17;
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
102     /**
103     * @dev Transfers tokens to a specified address.
104     * @param _to The address to transfer to.
105     * @param _value The amount to be transferred.
106     */
107     function transfer(address _to, uint256 _value) public returns (bool) {
108         balances[msg.sender] = balances[msg.sender].sub(_value);
109         balances[_to] = balances[_to].add(_value);
110         Transfer(msg.sender, _to, _value);
111         return true;
112     }
113     
114     /**
115     * @dev Gets the balance of the specified address.
116     * @param _owner The address to query the balance of.
117     */
118     function balanceOf(address _owner)public constant returns (uint256 balance) {
119         return balances[_owner];
120     }
121 }
122 
123 /**
124  * @title Standard ERC20 token
125  * @dev Implementation of the basic standard token.
126  * @dev https://github.com/ethereum/EIPs/issues/20
127  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
128  */
129 contract StandardToken is ERC20, BasicToken {
130 
131     mapping (address => mapping (address => uint256)) allowed;
132     
133     /**
134     * @dev Transfers tokens from one address to another.
135     * @param _from The address which you want to send tokens from.
136     * @param _to The address which you want to transfer to.
137     * @param _value The amount of tokens to be transfered.
138     */
139     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
140         require(_value <= allowed[_from][msg.sender]);
141         var _allowance = allowed[_from][msg.sender];
142         balances[_to] = balances[_to].add(_value);
143         balances[_from] = balances[_from].sub(_value);
144         allowed[_from][msg.sender] = _allowance.sub(_value);
145         Transfer(_from, _to, _value);
146         return true;
147     }
148     
149     /**
150     * @dev Approves the passed address to spend the specified amount of tokens on behalf of msg.sender.
151     * @param _spender The address which will spend the funds.
152     * @param _value The amount of tokens to be spent.
153     */
154     function approve(address _spender, uint256 _value) public returns (bool) {
155         require((_value > 0)&&(_value <= balances[msg.sender]));
156         allowed[msg.sender][_spender] = _value;
157         Approval(msg.sender, _spender, _value);
158         return true;
159     }
160     
161     /**
162     * @dev Function to check the amount of tokens that an owner allowed to a spender.
163     * @param _owner The address which owns the funds.
164     * @param _spender The address which will spend the funds.
165     */
166     function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
167         return allowed[_owner][_spender];
168     }
169 }
170 
171 /**
172  * @title Mintable token
173  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
174  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
175  */
176 contract MintableToken is StandardToken {
177     
178     event Mint(address indexed to, uint256 amount);
179     
180     event MintFinished();
181 
182     bool public mintingFinished = false;
183     
184     /**
185     * @dev Throws if called when minting is finished.
186     */
187     modifier canMint() {
188         require(!mintingFinished);
189         _;
190     }
191     
192     /**
193     * @dev Function to mint tokens
194     * @param _to The address that will recieve the minted tokens.
195     * @param _amount The amount of tokens to mint.
196     */
197     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
198         totalSupply = totalSupply.add(_amount);
199         balances[_to] = balances[_to].add(_amount);
200         Mint(_to, _amount);
201         return true;
202     }
203     
204     /**
205     * @dev Function to stop minting new tokens.
206     */
207     function finishMinting() public onlyOwner returns (bool) {
208         mintingFinished = true;
209         MintFinished();
210         return true;
211     }
212 }
213 
214 /**
215  * @title Burnable Token
216  * @dev Token that can be irreversibly burned (destroyed).
217  */
218 contract BurnableToken is MintableToken {
219     
220     using SafeMath for uint;
221     
222     /**
223     * @dev Burns a specific amount of tokens.
224     * @param _value The amount of token to be burned.
225     */
226     function burn(uint _value) public returns (bool success) {
227         require((_value > 0) && (_value <= balances[msg.sender]));
228         balances[msg.sender] = balances[msg.sender].sub(_value);
229         totalSupply = totalSupply.sub(_value);
230         Burn(msg.sender, _value);
231         return true;
232     }
233  
234     /**
235     * @dev Burns a specific amount of tokens from another address.
236     * @param _value The amount of tokens to be burned.
237     * @param _from The address which you want to burn tokens from.
238     */
239     function burnFrom(address _from, uint _value) public returns (bool success) {
240         require((balances[_from] > _value) && (_value <= allowed[_from][msg.sender]));
241         var _allowance = allowed[_from][msg.sender];
242         balances[_from] = balances[_from].sub(_value);
243         totalSupply = totalSupply.sub(_value);
244         allowed[_from][msg.sender] = _allowance.sub(_value);
245         Burn(_from, _value);
246         return true;
247     }
248 
249     event Burn(address indexed burner, uint indexed value);
250 }
251 
252 /**
253  * @title SimpleTokenCoin
254  * @dev SimpleToken is a standard ERC20 token with some additional functionality
255  */
256 contract BitcoinCityCoin is BurnableToken {
257     
258     string public constant name = "Bitcoin City";
259     
260     string public constant symbol = "BCKEY";
261     
262     uint32 public constant decimals = 8;
263     
264     address private contractAddress;
265     
266     
267     /**
268     * @dev The SimpleTokenCoin constructor mints tokens to four addresses.
269     */
270     function BitcoinCityCoin()public {
271        balances[0xb2DeC9309Ca7047a6257fC83a95fcFc23Ab821DC] = 500000000 * 10**decimals;
272     }
273     
274     
275      /**
276     * @dev Sets the address of approveAndCall contract.
277     * @param _address The address of approveAndCall contract.
278     */
279     function setContractAddress (address _address) public onlyOwner {
280         contractAddress = _address;
281     }
282     
283     /**
284      * @dev Token owner can approve for spender to execute another function.
285      * @param tokens Amount of tokens to execute function.
286      * @param data Additional data.
287      */
288     function approveAndCall(uint tokens, bytes data) public returns (bool success) {
289         approve(contractAddress, tokens);
290         ApproveAndCallFallBack(contractAddress).receiveApproval(msg.sender, tokens, data);
291         return true;
292     }
293 }
294 
295 interface ApproveAndCallFallBack { function receiveApproval(address from, uint256 tokens, bytes data) external; }