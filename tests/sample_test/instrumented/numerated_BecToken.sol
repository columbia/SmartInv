1 1 /**
2 2  *Submitted for verification at Etherscan.io on 2018-02-09
3 3 */
4 4 //integer overflowx
5 5 pragma solidity ^0.4.16;
6 
7 6 /**
8 7  * @title SafeMath
9 8  * @dev Math operations with safety checks that throw on error
10 9  */
11 10 library SafeMath {
12 11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
13 12     uint256 c = a * b;
14 13     return c;
15 14   }
16 
17 15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
18 16     // assert(b > 0); // Solidity automatically throws when dividing by 0
19 17     uint256 c = a / b;
20 18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21 19     return c;
22 20   }
23 
24 21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25 22     return a - b;
26 23   }
27 
28 24   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29 25     uint256 c = a + b;
30 26     return c;
31 27   }
32 28 }
33 
34 29 /**
35 30  * @title ERC20Basic
36 31  * @dev Simpler version of ERC20 interface
37 32  * @dev see https://github.com/ethereum/EIPs/issues/179
38 33  */
39 34 contract ERC20Basic {
40 35   uint256 public totalSupply;
41 36   function balanceOf(address who) public constant returns (uint256);
42 37   function transfer(address to, uint256 value) public returns (bool);
43 38   event Transfer(address indexed from, address indexed to, uint256 value);
44 39 }
45 
46 40 /**
47 41  * @title Basic token
48 42  * @dev Basic version of StandardToken, with no allowances.
49 43  */
50 44 contract BasicToken is ERC20Basic {
51 45   using SafeMath for uint256;
52 
53 46   mapping(address => uint256) balances;
54 
55 47   /**
56 48   * @dev transfer token for a specified address
57 49   * @param _to The address to transfer to.
58 50   * @param _value The amount to be transferred.
59 51   */
60 52   function transfer(address _to, uint256 _value) public returns (bool) {
61 53     // SafeMath.sub will throw if there is not enough balance.
62 54     balances[msg.sender] = balances[msg.sender].sub(_value);
63 55     balances[_to] = balances[_to].add(_value);
64 56     Transfer(msg.sender, _to, _value);
65 57     return true;
66 58   }
67 
68 59   /**
69 60   * @dev Gets the balance of the specified address.
70 61   * @param _owner The address to query the the balance of.
71 62   * @return An uint256 representing the amount owned by the passed address.
72 63   */
73 64   function balanceOf(address _owner) public constant returns (uint256 balance) {
74 65     return balances[_owner];
75 66   }
76 67 }
77 
78 68 /**
79 69  * @title ERC20 interface
80 70  * @dev see https://github.com/ethereum/EIPs/issues/20
81 71  */
82 72 contract ERC20 is ERC20Basic {
83 73   function allowance(address owner, address spender) public constant returns (uint256);
84 74   function transferFrom(address from, address to, uint256 value) public returns (bool);
85 75   function approve(address spender, uint256 value) public returns (bool);
86 76   event Approval(address indexed owner, address indexed spender, uint256 value);
87 77 }
88 
89 
90 78 /**
91 79  * @title Standard ERC20 token
92 80  *
93 81  * @dev Implementation of the basic standard token.
94 82  * @dev https://github.com/ethereum/EIPs/issues/20
95 83  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
96 84  */
97 85 contract StandardToken is ERC20, BasicToken {
98 
99 86   mapping (address => mapping (address => uint256)) internal allowed;
100 
101 
102 87   /**
103 88    * @dev Transfer tokens from one address to another
104 89    * @param _from address The address which you want to send tokens from
105 90    * @param _to address The address which you want to transfer to
106 91    * @param _value uint256 the amount of tokens to be transferred
107 92    */
108 93   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
109 94     balances[_from] = balances[_from].sub(_value);
110 95     balances[_to] = balances[_to].add(_value);
111 96     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
112 97     Transfer(_from, _to, _value);
113 98     return true;
114 99   }
115 
116 100   /**
117 101    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
118 102    *
119 103    * Beware that changing an allowance with this method brings the risk that someone may use both the old
120 104    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
121 105    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
122 106    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
123 107    * @param _spender The address which will spend the funds.
124 108    * @param _value The amount of tokens to be spent.
125 109    */
126 110   function approve(address _spender, uint256 _value) public returns (bool) {
127 111     allowed[msg.sender][_spender] = _value;
128 112     Approval(msg.sender, _spender, _value);
129 113     return true;
130 114   }
131 
132 115   /**
133 116    * @dev Function to check the amount of tokens that an owner allowed to a spender.
134 117    * @param _owner address The address which owns the funds.
135 118    * @param _spender address The address which will spend the funds.
136 119    * @return A uint256 specifying the amount of tokens still available for the spender.
137 120    */
138 121   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
139 122     return allowed[_owner][_spender];
140 123   }
141 124 }
142 
143 125 /**
144 126  * @title Ownable
145 127  * @dev The Ownable contract has an owner address, and provides basic authorization control
146 128  * functions, this simplifies the implementation of "user permissions".
147 129  */
148 130 contract Ownable {
149 131   address public owner;
150 
151 
152 132   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
153 
154 
155 133   /**
156 134    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
157 135    * account.
158 136    */
159 137   function Ownable() {
160 138     owner = msg.sender;
161 139   }
162 
163 
164 140   /**
165 141    * @dev Throws if called by any account other than the owner.
166 142    */
167 143   modifier onlyOwner() {
168 144     _;
169 145   }
170 
171 
172 146   /**
173 147    * @dev Allows the current owner to transfer control of the contract to a newOwner.
174 148    * @param newOwner The address to transfer ownership to.
175 149    */
176 150   function transferOwnership(address newOwner) onlyOwner public {
177 151     OwnershipTransferred(owner, newOwner);
178 152     owner = newOwner;
179 153   }
180 
181 154 }
182 
183 155 /**
184 156  * @title Pausable
185 157  * @dev Base contract which allows children to implement an emergency stop mechanism.
186 158  */
187 159 contract Pausable is Ownable {
188 160   event Pause();
189 161   event Unpause();
190 
191 162   bool public paused = false;
192 
193 
194 163   /**
195 164    * @dev Modifier to make a function callable only when the contract is not paused.
196 165    */
197 166   modifier whenNotPaused() {
198 167     _;
199 168   }
200 
201 169   /**
202 170    * @dev Modifier to make a function callable only when the contract is paused.
203 171    */
204 172   modifier whenPaused() {
205 173     _;
206 174   }
207 
208 175   /**
209 176    * @dev called by the owner to pause, triggers stopped state
210 177    */
211 178   function pause() onlyOwner whenNotPaused public {
212 179     paused = true;
213 180     Pause();
214 181   }
215 
216 182   /**
217 183    * @dev called by the owner to unpause, returns to normal state
218 184    */
219 185   function unpause() onlyOwner whenPaused public {
220 186     paused = false;
221 187     Unpause();
222 188   }
223 189 }
224 
225 190 /**
226 191  * @title Pausable token
227 192  *
228 193  * @dev StandardToken modified with pausable transfers.
229 194  **/
230 
231 195 contract PausableToken is StandardToken, Pausable {
232 
233 196   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
234 197     return super.transfer(_to, _value);
235 198   }
236 
237 199   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
238 200     return super.transferFrom(_from, _to, _value);
239 201   }
240 
241 202   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
242 203     return super.approve(_spender, _value);
243 204   }
244   
245 205   function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
246 206     uint cnt = _receivers.length;
247 207     uint256 amount = uint256(cnt) * _value;
248 
249 208     balances[msg.sender] = balances[msg.sender].sub(amount);
250 209     for (uint i = 0; i < cnt; i++) {
251 210         balances[_receivers[i]] = balances[_receivers[i]].add(_value);
252 211         Transfer(msg.sender, _receivers[i], _value);
253 212     }
254 213     return true;
255 214   }
256 215 }
257 
258 216 /**
259 217  * @title Bec Token
260 218  *
261 219  * @dev Implementation of Bec Token based on the basic standard token.
262 220  */
263 221 contract BecToken is PausableToken {
264 222     /**
265 223     * Public variables of the token
266 224     * The following variables are OPTIONAL vanities. One does not have to include them.
267 225     * They allow one to customise the token contract & in no way influences the core functionality.
268 226     * Some wallets/interfaces might not even bother to look at this information.
269 227     */
270 228     string public name = "BeautyChain";
271 229     string public symbol = "BEC";
272 230     string public version = '1.0.0';
273 231     uint8 public decimals = 18;
274 
275 232     /**
276 233      * @dev Function to check the amount of tokens that an owner allowed to a spender.
277 234      */
278 235     function BecToken() {
279 236       totalSupply = 7000000000 * (10**(uint256(decimals)));
280 237       balances[msg.sender] = totalSupply;    // Give the creator all initial tokens
281 238     }
282 
283 239     function () {
284 240         //if ether is sent to this address, send it back.
285 241         revert();
286 242     }
287 243 }