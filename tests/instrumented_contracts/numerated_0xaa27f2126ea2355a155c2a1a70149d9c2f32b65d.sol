1 pragma solidity 0.4.22;
2 /**
3  * Zigilua token contract
4  *
5  * Solidity 0.4.22 compiler
6  *
7  * @package   Zigilua
8  * @author    Roger Sei <https://www.linkedin.com/in/roger-sei/>
9  * @copyright 2018 Roger Sei
10  * @license   http://www.gnu.org/licenses/gpl.txt GPL
11  * @version   Release: GIT: 1
12  *
13  * Convention used: PHPCS
14  */
15 
16 /**
17  * ERC20 interface
18  *
19  * https://en.wikipedia.org/wiki/ERC20
20  */
21 interface ERC20
22 {
23     function allowance(address _owner, address _spender) external constant returns (uint256 remaining);
24     function approve(address _spender, uint256 _value) external returns (bool success);
25     function balanceOf(address _owner) external constant returns (uint256 balance);
26     function transfer(address _to, uint256 _value) external returns (bool success);
27     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
28     
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30     event Transfer(address indexed _from, address indexed _to, uint256 _value);
31 
32 }
33 
34 /**
35  * Standard ERC20 token
36  *
37  * @dev Implementation of the basic standard token.
38  * https://github.com/ethereum/EIPs/issues/20
39  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
40  * Adapted to 0.4.22 solidity version
41  */
42 contract StandardToken is ERC20
43 {
44     mapping (address => uint256) balances;
45     mapping (address => mapping (address => uint256)) allowed;
46     uint256 public totalSupply;
47 
48     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
49       return allowed[_owner][_spender];
50     }
51     
52     function approve(address _spender, uint256 _value) public returns (bool success) {
53         allowed[msg.sender][_spender] = _value;
54         emit Approval(msg.sender, _spender, _value);
55         return true;
56     }
57     
58     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success)
59     {
60         allowed[msg.sender][_spender] = _value;
61         emit Approval(msg.sender, _spender, _value);
62 
63         if (!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
64             revert();
65         }
66 
67         return true;
68 
69     }
70     
71     function balanceOf(address _owner) public constant returns (uint256 balance)
72     {
73         return balances[_owner];
74 
75     }
76 
77     function transfer(address _to, uint256 _value) public returns (bool success)
78     {
79         if (balances[msg.sender] >= _value && _value > 0) {
80             balances[msg.sender] -= _value;
81             balances[_to] += _value;
82             emit Transfer(msg.sender, _to, _value);
83             return true;
84         }
85 
86         return false;
87 
88     }
89 
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
91         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
92             balances[_to] += _value;
93             balances[_from] -= _value;
94             allowed[_from][msg.sender] -= _value;
95             emit Transfer(_from, _to, _value);
96             return true;
97         }
98 
99         return false;
100 
101     }
102 
103     function totalSupply() public view returns (uint256 supply) 
104     {
105         return totalSupply;
106 
107     }
108     
109 }
110 
111 /**
112  * Zigilua contract
113  *
114  * @author    Roger Sei
115  */
116 contract Zigilua is StandardToken
117 {
118     string public name;
119     uint8 public decimals;
120     string public symbol;
121     string public version = 'Z1';
122     address public zigWallet;
123 
124     uint256 private _usd;
125     uint8 private _crrStage;
126     uint private _minUSDrequired;
127     uint8[] public ZIGS_BY_STAGE = [
128                                     1,
129                                     1,
130                                     3,
131                                     5
132                                    ];
133 
134 
135     /**
136      * Constructor for Zigilua
137      */
138     function Zigilua() public
139     {
140         balances[msg.sender] = 79700000000;
141         totalSupply          = 79700000000;
142         name                 = "ZigiLua";
143         decimals             = 0;
144         symbol               = "ZGL";
145         zigWallet            = msg.sender;
146 
147         _crrStage            = 0;
148         _minUSDrequired      = 200;
149         _usd                 = 50000;
150     }
151 
152 
153     /**
154      * Payable fallback
155      *
156      * @return void
157      */
158     function () public payable
159     {
160         buy(msg.value);
161 
162     }
163 
164 
165     /**
166      * Allows to buy zigs (ZGL) from DApps
167      *
168      * @param wai {uint256} Desired amount, in wei
169      *
170      * @return {uint256[]} [wai, _usd, amount, owner balance, user balance] Useful for debugging purposes
171      */
172     function buy(uint256 wai) public payable returns (uint256[5])
173     {
174         uint256 amount = ((wai * _usd * 10 * ZIGS_BY_STAGE[_crrStage]) / (1e18));
175 
176         require(balances[zigWallet] >= amount);
177         require(amount >= (2000 * (1 / ZIGS_BY_STAGE[_crrStage])));
178 
179         balances[zigWallet]  = (balances[zigWallet] - amount);
180         balances[msg.sender] = (balances[msg.sender] + amount);
181 
182         emit Transfer(zigWallet, msg.sender, amount);
183 
184         zigWallet.transfer(msg.value);
185 
186         return ([wai, _usd, amount, balances[zigWallet], balances[msg.sender]]);
187 
188     }
189 
190 
191     /**
192      * Returns the owner balance, in zigs
193      *
194      * @return {uint256} Current owner balance
195      */
196     function getBalanceFromOwner() public view returns (uint256)
197     {
198         return balances[zigWallet];
199 
200     }
201 
202 
203     /**
204      * Returns a balance, in zigs, from a given address, identified by from
205      *
206      * @param from {address} Any given address
207      *
208      * @return {uint256} Current user balance
209      */
210     function getBalanceFrom(address from) public view returns (uint256)
211     {
212         return balances[from];
213 
214     }
215 
216 
217     /**
218      * Gets the current dollar rate, wihtout decimal
219      *
220      * @return {uint256} Returns the current dollar rate used to buy zigs
221      */
222     function getUSD() public view returns (uint256)
223     {
224         return _usd;
225 
226     }
227 
228 
229     /**
230      * Returns current ICO stage
231      *
232      * @return {uint256} 
233      */
234     function getStage() public view returns (uint256)
235     {
236         return _crrStage;
237 
238     }
239     
240     /**
241      * Defines the ICO stage, allowed to be changed only by Zigilua (owner)
242      *
243      * @param stage {uint8} Defines the ICO stage
244      *
245      * @return {bool} True if successful
246      */
247     function setStage(uint8 stage) public returns (bool)
248     {
249         require(msg.sender == zigWallet);
250 
251         _crrStage = stage;
252 
253         return true;
254 
255     }
256 
257 
258     /**
259      * Allows Zigilua to set the dollar rate
260      *
261      * @param usd {uint256} Dollar rate, in ethereum, without decimal
262      *
263      * @return {bool} True if successful
264      */
265     function setUSD(uint256 usd) public returns (bool)
266     {
267         require(msg.sender == zigWallet);
268         require(usd > 0);
269         _usd = usd;
270 
271         return true;
272 
273     }
274 
275 
276 }