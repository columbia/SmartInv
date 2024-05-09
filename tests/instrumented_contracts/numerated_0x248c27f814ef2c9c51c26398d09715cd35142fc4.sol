1 pragma solidity ^0.5.0;
2 
3 
4 /*
5  * Ownable
6  *
7  * Base contract with an owner.
8  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
9  */
10 contract Ownable {
11     address public owner;
12 
13     constructor() public {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner() {
18         if (msg.sender != owner) {
19             revert();
20         }
21         _;
22     }
23 
24     function transferOwnership(address newOwner) public onlyOwner {
25         if (newOwner != address(0)) {
26             owner = newOwner;
27         }
28     }
29 
30 }
31 
32 
33 /*
34  * ERC20 interface
35  * see https://github.com/ethereum/EIPs/issues/20
36  */
37 contract ERC20 {
38     uint public totalSupply;
39 
40     function balanceOf(address who) public view returns (uint);
41 
42     function allowance(address owner, address spender) public view returns (uint);
43 
44     function transfer(address to, uint value) public returns (bool ok);
45 
46     function transferFrom(address from, address to, uint value) public returns (bool ok);
47 
48     function approve(address spender, uint value) public returns (bool ok);
49 
50     event Transfer(address indexed from, address indexed to, uint value);
51     event Approval(address indexed owner, address indexed spender, uint value);
52 }
53 
54 
55 
56 /**
57  * Math operations with safety checks
58  */
59 contract SafeMath {
60     function safeMul(uint a, uint b) internal pure returns (uint) {
61         uint c = a * b;
62         assertThat(a == 0 || c / a == b);
63         return c;
64     }
65 
66     function safeDiv(uint a, uint b) internal pure returns (uint) {
67         assertThat(b > 0);
68         uint c = a / b;
69         assertThat(a == b * c + a % b);
70         return c;
71     }
72 
73     function safeSub(uint a, uint b) internal pure returns (uint) {
74         assertThat(b <= a);
75         return a - b;
76     }
77 
78     function safeAdd(uint a, uint b) internal pure returns (uint) {
79         uint c = a + b;
80         assertThat(c >= a && c >= b);
81         return c;
82     }
83 
84     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
85         return a >= b ? a : b;
86     }
87 
88     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
89         return a < b ? a : b;
90     }
91 
92     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
93         return a >= b ? a : b;
94     }
95 
96     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
97         return a < b ? a : b;
98     }
99 
100     function assertThat(bool assertion) internal pure {
101         if (!assertion) {
102             revert();
103         }
104     }
105 }
106 
107 
108 /**
109  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
110  *
111  * Based on code by FirstBlood:
112  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
113  */
114 contract StandardToken is ERC20, SafeMath {
115 
116     string public name;
117     string public symbol;
118     uint public decimals;
119 
120     /* Actual balances of token holders */
121     mapping(address => uint) balances;
122 
123     /* approve() allowances */
124     mapping(address => mapping(address => uint)) allowed;
125 
126     /**
127      *
128      * Fix for the ERC20 short address attack
129      *
130      * http://vessenes.com/the-erc20-short-address-attack-explained/
131      */
132     modifier onlyPayloadSize(uint size) {
133         if (msg.data.length < size + 4) {
134             revert();
135         }
136         _;
137     }
138 
139     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {
140         balances[msg.sender] = safeSub(balances[msg.sender], _value);
141         balances[_to] = safeAdd(balances[_to], _value);
142         emit Transfer(msg.sender, _to, _value);
143         return true;
144     }
145 
146     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
147         uint _allowance = allowed[_from][msg.sender];
148 
149         balances[_to] = safeAdd(balances[_to], _value);
150         balances[_from] = safeSub(balances[_from], _value);
151         allowed[_from][msg.sender] = safeSub(_allowance, _value);
152         emit Transfer(_from, _to, _value);
153         return true;
154     }
155 
156     function balanceOf(address _owner) public view returns (uint balance) {
157         return balances[_owner];
158     }
159 
160     function approve(address _spender, uint _value) public returns (bool success) {
161 
162         // To change the approve amount you first have to reduce the addresses`
163         //  allowance to zero by calling `approve(_spender, 0)` if it is not
164         //  already 0 to mitigate the race condition described here:
165         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
167 
168         allowed[msg.sender][_spender] = _value;
169         emit Approval(msg.sender, _spender, _value);
170         return true;
171     }
172 
173     function allowance(address _owner, address _spender) public view returns (uint remaining) {
174         return allowed[_owner][_spender];
175     }
176 
177     /**
178    * @dev Increase the amount of tokens that an owner allowed to a spender.
179    *
180    * approve should be called when allowed[_spender] == 0. To increment
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _addedValue The amount of tokens to increase the allowance by.
186    */
187     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
188         allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);
189         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190         return true;
191     }
192 
193     /**
194      * @dev Decrease the amount of tokens that an owner allowed to a spender.
195      *
196      * approve should be called when allowed[_spender] == 0. To decrement
197      * allowed value is better to use this function to avoid 2 calls (and wait until
198      * the first transaction is mined)
199      * From MonolithDAO Token.sol
200      * @param _spender The address which will spend the funds.
201      * @param _subtractedValue The amount of tokens to decrease the allowance by.
202      */
203     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
204         uint oldValue = allowed[msg.sender][_spender];
205         if (_subtractedValue > oldValue) {
206             allowed[msg.sender][_spender] = 0;
207         } else {
208             allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);
209         }
210         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211         return true;
212     }
213 
214 }
215 
216 /**
217  * @title Freezable
218  * @dev Base contract which allows children to freeze the operations from a certain address in case of an emergency.
219  */
220 contract Freezable is Ownable {
221 
222     mapping(address => bool) internal frozenAddresses;
223 
224     modifier ifNotFrozen() {
225         require(frozenAddresses[msg.sender] == false);
226         _;
227     }
228 
229     function freezeAddress(address addr) public onlyOwner {
230         frozenAddresses[addr] = true;
231     }
232 
233     function unfreezeAddress(address addr) public onlyOwner {
234         frozenAddresses[addr] = false;
235     }
236 }
237 
238 /**
239  * @title Freezable token
240  * @dev StandardToken modified with freezable transfers.
241  **/
242 contract FreezableToken is StandardToken, Freezable {
243 
244     function transfer(address _to, uint256 _value) public ifNotFrozen returns (bool) {
245         return super.transfer(_to, _value);
246     }
247 
248     function transferFrom(address _from, address _to, uint256 _value) public ifNotFrozen returns (bool) {
249         return super.transferFrom(_from, _to, _value);
250     }
251 
252     function approve(address _spender, uint256 _value) public ifNotFrozen returns (bool) {
253         return super.approve(_spender, _value);
254     }
255 
256     function increaseApproval(address _spender, uint _addedValue) public ifNotFrozen returns (bool success) {
257         return super.increaseApproval(_spender, _addedValue);
258     }
259 
260     function decreaseApproval(address _spender, uint _subtractedValue) public ifNotFrozen returns (bool success) {
261         return super.decreaseApproval(_spender, _subtractedValue);
262     }
263 }
264 
265 /**
266  * A a standard token with an anti-theft mechanism.
267  * Is able to restore stolen funds to a new address where the corresponding private key is safe.
268  *
269  */
270 contract AntiTheftToken is FreezableToken {
271 
272     function restoreFunds(address from, address to, uint amount) public onlyOwner {
273         //can only restore stolen funds from a frozen address
274         require(frozenAddresses[from] == true);
275         require(to != address(0));
276         require(amount <= balances[from]);
277 
278         balances[from] = safeSub(balances[from], amount);
279         balances[to] = safeAdd(balances[to], amount);
280         emit Transfer(from, to, amount);
281     }
282 }
283 
284 contract BurnableToken is StandardToken {
285 
286     /** How many tokens we burned */
287     event Burned(address burner, uint burnedAmount);
288 
289     /**
290      * Burn extra tokens from a balance.
291      *
292      */
293     function burn(uint burnAmount) public {
294         address burner = msg.sender;
295         balances[burner] = safeSub(balances[burner], burnAmount);
296         totalSupply = safeSub(totalSupply, burnAmount);
297         emit Burned(burner, burnAmount);
298     }
299 }
300 
301 contract COPYLOCK is BurnableToken, AntiTheftToken {
302 
303     constructor() public {
304         symbol = "CPL";
305         name = "COPYLOCK";
306         decimals = 18;
307 
308 
309         totalSupply = 150000000 * (10 ** (18));
310         balances[msg.sender] = totalSupply;
311         emit Transfer(address(0x0), msg.sender, totalSupply);
312     }
313 
314 }