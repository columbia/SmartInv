1 pragma solidity ^0.4.14;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal constant returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 /**
36  * @title ERC20Basic
37  * @dev Simpler version of ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/179
39  */
40 contract ERC20Basic {
41     uint256 public totalSupply;
42 
43     function balanceOf(address who) constant returns (uint256);
44 
45     function transfer(address to, uint256 value) returns (bool);
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 
51 /**
52  * @title Basic token
53  * @dev Basic version of StandardToken, with no allowances.
54  */
55 contract BasicToken is ERC20Basic {
56     using SafeMath for uint256;
57 
58     mapping (address => uint256) balances;
59 
60     /**
61     * @dev transfer token for a specified address
62     * @param _to The address to transfer to.
63     * @param _value The amount to be transferred.
64     */
65     function transfer(address _to, uint256 _value) returns (bool) {
66         balances[msg.sender] = balances[msg.sender].sub(_value);
67         balances[_to] = balances[_to].add(_value);
68         Transfer(msg.sender, _to, _value);
69         return true;
70     }
71 
72     /**
73     * @dev Gets the balance of the specified address.
74     * @param _owner The address to query the the balance of.
75     * @return An uint256 representing the amount owned by the passed address.
76     */
77     function balanceOf(address _owner) constant returns (uint256 balance) {
78         return balances[_owner];
79     }
80 
81 }
82 
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89     function allowance(address owner, address spender) constant returns (uint256);
90 
91     function transferFrom(address from, address to, uint256 value) returns (bool);
92 
93     function approve(address spender, uint256 value) returns (bool);
94 
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * @dev https://github.com/ethereum/EIPs/issues/20
104  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
105  */
106 contract StandardToken is ERC20, BasicToken {
107 
108     mapping (address => mapping (address => uint256)) allowed;
109 
110 
111     /**
112      * @dev Transfer tokens from one address to another
113      * @param _from address The address which you want to send tokens from
114      * @param _to address The address which you want to transfer to
115      * @param _value uint256 the amout of tokens to be transfered
116      */
117     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
118         var _allowance = allowed[_from][msg.sender];
119 
120         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
121         // require (_value <= _allowance);
122 
123         balances[_to] = balances[_to].add(_value);
124         balances[_from] = balances[_from].sub(_value);
125         allowed[_from][msg.sender] = _allowance.sub(_value);
126         Transfer(_from, _to, _value);
127         return true;
128     }
129 
130     /**
131      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
132      * @param _spender The address which will spend the funds.
133      * @param _value The amount of tokens to be spent.
134      */
135     function approve(address _spender, uint256 _value) returns (bool) {
136 
137         // To change the approve amount you first have to reduce the addresses`
138         //  allowance to zero by calling `approve(_spender, 0)` if it is not
139         //  already 0 to mitigate the race condition described here:
140         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
142 
143         allowed[msg.sender][_spender] = _value;
144         Approval(msg.sender, _spender, _value);
145         return true;
146     }
147 
148     /**
149      * @dev Function to check the amount of tokens that an owner allowed to a spender.
150      * @param _owner address The address which owns the funds.
151      * @param _spender address The address which will spend the funds.
152      * @return A uint256 specifing the amount of tokens still available for the spender.
153      */
154     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
155         return allowed[_owner][_spender];
156     }
157 
158 }
159 
160 
161 /**
162  * @title Ownable
163  * @dev The Ownable contract has an owner address, and provides basic authorization control
164  * functions, this simplifies the implementation of "user permissions".
165  */
166 contract Ownable {
167     address public owner;
168 
169 
170     /**
171      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
172      * account.
173      */
174     function Ownable() {
175         owner = msg.sender;
176     }
177 
178 
179     /**
180      * @dev Throws if called by any account other than the owner.
181      */
182     modifier onlyOwner() {
183         require(msg.sender == owner);
184         _;
185     }
186 
187 
188     /**
189      * @dev Allows the current owner to transfer control of the contract to a newOwner.
190      * @param newOwner The address to transfer ownership to.
191      */
192     function transferOwnership(address newOwner) onlyOwner {
193         require(newOwner != address(0));
194         owner = newOwner;
195     }
196 
197 }
198 
199 
200 /**
201  * @title Mintable token
202  * @dev Simple ERC20 Token example, with mintable token creation
203  */
204 
205 contract MintableToken is StandardToken, Ownable {
206     event Mint(address indexed to, uint256 amount);
207 
208     event MintFinished();
209 
210     address public minter;
211 
212     bool public mintingFinished = false;
213 
214     function MintableToken(){
215         minter = msg.sender;
216     }
217 
218     /**
219     * @dev Throws if called by any account other than the minter.
220     */
221     modifier onlyMinter() {
222         require(msg.sender == minter);
223         _;
224     }
225 
226     function setMinter(address value) onlyOwner {
227         require(value != address(0));
228         minter = value;
229     }
230 
231     modifier canMint() {
232         require(!mintingFinished);
233         _;
234     }
235 
236     /**
237      * @dev Function to mint tokens
238      * @param _to The address that will recieve the minted tokens.
239      * @param _amount The amount of tokens to mint.
240      * @return A boolean that indicates if the operation was successful.
241      */
242     function mint(address _to, uint256 _amount) onlyMinter canMint returns (bool) {
243         totalSupply = totalSupply.add(_amount);
244         balances[_to] = balances[_to].add(_amount);
245         Mint(_to, _amount);
246         return true;
247     }
248 
249     /**
250      * @dev Function to stop minting new tokens.
251      * @return True if the operation was successful.
252      */
253     function finishMinting() onlyOwner returns (bool) {
254         mintingFinished = true;
255         MintFinished();
256         return true;
257     }
258 
259 }
260 
261 contract CryptoSlotsCoin is MintableToken {
262     string constant public standard = 'ERC20 Token';
263 
264     string constant public name = "CryptoSlots Coin";
265 
266     string constant public symbol = "SPIN";
267 
268     uint8 constant public decimals = 18;
269 
270 }