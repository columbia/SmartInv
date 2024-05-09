1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5 /**
6 * @dev Multiplies two numbers, throws on overflow.
7 */
8 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9 if (a == 0) {
10 return 0;
11 }
12 uint256 c = a * b;
13 assert(c / a == b);
14 return c;
15 }
16 
17 /**
18 * @dev Integer division of two numbers, truncating the quotient.
19 */
20 function div(uint256 a, uint256 b) internal pure returns (uint256) {
21 // assert(b > 0); // Solidity automatically throws when dividing by 0
22 uint256 c = a / b;
23 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24 return c;
25 }
26 
27 /**
28 * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29 */
30 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31 assert(b <= a);
32 return a - b;
33 }
34 
35 /**
36 * @dev Adds two numbers, throws on overflow.
37 */
38 function add(uint256 a, uint256 b) internal pure returns (uint256) {
39 uint256 c = a + b;
40 assert(c >= a);
41 return c;
42 }
43 }
44 
45 contract Ownable {
46 address public owner;
47 
48 
49 event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52 /**
53 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54 * account.
55 */
56 function Ownable() public {
57 owner = msg.sender;
58 }
59 
60 /**
61 * @dev Throws if called by any account other than the owner.
62 */
63 modifier onlyOwner() {
64 require(msg.sender == owner);
65 _;
66 }
67 
68 /**
69 * @dev Allows the current owner to transfer control of the contract to a newOwner.
70 * @param newOwner The address to transfer ownership to.
71 */
72 function transferOwnership(address newOwner) public onlyOwner {
73 require(newOwner != address(0));
74 OwnershipTransferred(owner, newOwner);
75 owner = newOwner;
76 }
77 
78 }
79 
80 contract ERC20Basic {
81 function totalSupply() public view returns (uint256);
82 function balanceOf(address who) public view returns (uint256);
83 function transfer(address to, uint256 value) public returns (bool);
84 event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 contract BasicToken is ERC20Basic {
88 using SafeMath for uint256;
89 
90 mapping(address => uint256) balances;
91 
92 uint256 totalSupply_;
93 
94 /**
95 * @dev total number of tokens in existence
96 */
97 function totalSupply() public view returns (uint256) {
98 return totalSupply_;
99 }
100 
101 
102 /**
103 * @dev transfer token for a specified address
104 * @param _to The address to transfer to.
105 * @param _value The amount to be transferred.
106 */
107 function transfer(address _to, uint256 _value) public returns (bool) {
108 require(_to != address(0));
109 require(_value <= balances[msg.sender]);
110 
111 // SafeMath.sub will throw if there is not enough balance.
112 balances[msg.sender] = balances[msg.sender].sub(_value);
113 balances[_to] = balances[_to].add(_value);
114 Transfer(msg.sender, _to, _value);
115 return true;
116 }
117 
118 /**
119 * @dev Gets the balance of the specified address.
120 * @param _owner The address to query the the balance of.
121 * @return An uint256 representing the amount owned by the passed address.
122 */
123 function balanceOf(address _owner) public view returns (uint256 balance) {
124 return balances[_owner];
125 }
126 
127 
128 }
129 
130 contract BurnableToken is BasicToken {
131 
132 event Burn(address indexed burner, uint256 value);
133 
134 /**
135 * @dev Burns a specific amount of tokens.
136 * @param _value The amount of token to be burned.
137 */
138 function burn(uint256 _value) public {
139 require(_value <= balances[msg.sender]);
140 // no need to require value <= totalSupply, since that would imply the
141 // sender's balance is greater than the totalSupply, which *should* be an assertion failure
142 
143 address burner = msg.sender;
144 balances[burner] = balances[burner].sub(_value);
145 totalSupply_ = totalSupply_.sub(_value);
146 Burn(burner, _value);
147 }
148 }
149 
150 contract ERC20 is ERC20Basic {
151 function allowance(address owner, address spender) public view returns (uint256);
152 function transferFrom(address from, address to, uint256 value) public returns (bool);
153 function approve(address spender, uint256 value) public returns (bool);
154 event Approval(address indexed owner, address indexed spender, uint256 value);
155 }
156 
157 library SafeERC20 {
158 function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
159 assert(token.transfer(to, value));
160 }
161 
162 function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
163 assert(token.transferFrom(from, to, value));
164 }
165 
166 function safeApprove(ERC20 token, address spender, uint256 value) internal {
167 assert(token.approve(spender, value));
168 }
169 }
170 
171 contract StandardToken is ERC20, BasicToken {
172 
173 mapping (address => mapping (address => uint256)) internal allowed;
174 
175 
176 /**
177 * @dev Transfer tokens from one address to another
178 * @param _from address The address which you want to send tokens from
179 * @param _to address The address which you want to transfer to
180 * @param _value uint256 the amount of tokens to be transferred
181 */
182 function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
183 require(_to != address(0));
184 require(_value <= balances[_from]);
185 require(_value <= allowed[_from][msg.sender]);
186 
187 balances[_from] = balances[_from].sub(_value);
188 balances[_to] = balances[_to].add(_value);
189 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190 Transfer(_from, _to, _value);
191 return true;
192 }
193 
194 /**
195 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196 *
197 * Beware that changing an allowance with this method brings the risk that someone may use both the old
198 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201 * @param _spender The address which will spend the funds.
202 * @param _value The amount of tokens to be spent.
203 */
204 function approve(address _spender, uint256 _value) public returns (bool) {
205 allowed[msg.sender][_spender] = _value;
206 Approval(msg.sender, _spender, _value);
207 return true;
208 }
209 
210 /**
211 * @dev Function to check the amount of tokens that an owner allowed to a spender.
212 * @param _owner address The address which owns the funds.
213 * @param _spender address The address which will spend the funds.
214 * @return A uint256 specifying the amount of tokens still available for the spender.
215 */
216 function allowance(address _owner, address _spender) public view returns (uint256) {
217 return allowed[_owner][_spender];
218 }
219 
220 /**
221 * @dev Increase the amount of tokens that an owner allowed to a spender.
222 *
223 * approve should be called when allowed[_spender] == 0. To increment
224 * allowed value is better to use this function to avoid 2 calls (and wait until
225 * the first transaction is mined)
226 * From MonolithDAO Token.sol
227 * @param _spender The address which will spend the funds.
228 * @param _addedValue The amount of tokens to increase the allowance by.
229 */
230 function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
231 allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
232 Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233 return true;
234 }
235 
236 /**
237 * @dev Decrease the amount of tokens that an owner allowed to a spender.
238 *
239 * approve should be called when allowed[_spender] == 0. To decrement
240 * allowed value is better to use this function to avoid 2 calls (and wait until
241 * the first transaction is mined)
242 * From MonolithDAO Token.sol
243 * @param _spender The address which will spend the funds.
244 * @param _subtractedValue The amount of tokens to decrease the allowance by.
245 */
246 function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
247 uint oldValue = allowed[msg.sender][_spender];
248 if (_subtractedValue > oldValue) {
249 allowed[msg.sender][_spender] = 0;
250 } else {
251 allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252 }
253 Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254 return true;
255 }
256 
257 }
258 
259 contract KickSportsManager is StandardToken, BurnableToken, Ownable {
260 using SafeMath for uint;
261 
262 string constant public symbol = "KICK";
263 string constant public name = "KickSportsManager";
264 
265 uint8 constant public decimals = 18;
266 uint256 INITIAL_SUPPLY = 133442442e18;
267 
268 uint constant ITSStartTime = 1528396200; //  Friday , June 8, 2018 
269 uint constant ITSEndTime = 1530297000; // Saturday, June 30, 2018
270 
271 
272 address company = 0xbC1c8FF768FBA957a23b2d26309eEa01c8000f89;
273 address team = 0x878990bc1fec7d079514a27dc525333e380b65af;
274 
275 address crowdsale = 0x2Eb0084CEFF13352340Cd16A40137f357bd18ae4;
276 address bounty = 0x607c27B884a99d79e388cbb7a0f514D1E4F77EbF;
277 
278 address reserve = 0xE6a7C077e007F04b01B99a358fbE2b23b6315FB2;
279 
280 uint constant companyTokens = 13344244e18;
281 uint constant teamTokens =  13344244e18;
282 uint constant crowdsaleTokens = 26688488e18;
283 uint constant bountyTokens = 13344244e18;
284 uint constant reserveTokens = 38698308e18;
285 
286 function KickSportsManager() public {
287 
288 totalSupply_ = INITIAL_SUPPLY;
289 
290 // InitialDistribution
291 preSale(company, companyTokens);
292 preSale(team, teamTokens);
293 preSale(crowdsale, crowdsaleTokens);
294 preSale(bounty, bountyTokens);
295 preSale(reserve, reserveTokens);
296 // Private Pre-Sale
297 preSale(0x2D35c7B8128949B0a771EB3e4B9c3D50B7f7A7F4, 6672122e18);
298 
299 
300 }
301 
302 function preSale(address _address, uint _amount) internal returns (bool) {
303 balances[_address] = _amount;
304 Transfer(address(0x0), _address, _amount);
305 }
306 
307 
308 
309 function transfer(address _to, uint256 _value) returns (bool success) {
310 
311 balances[0x2Eb0084CEFF13352340Cd16A40137f357bd18ae4] = balances[0x2Eb0084CEFF13352340Cd16A40137f357bd18ae4].sub(_value);
312 balances[_to] = balances[_to].add(_value);
313 Transfer(address(crowdsale), _to, _value);
314 
315 return true;
316 }
317 
318 function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
319 
320 balances[_from] = balances[_from].sub(_value);
321 balances[_to] = balances[_to].add(_value);
322 Transfer(_from, _to, _value);
323 return true;
324 }
325 
326 
327 }