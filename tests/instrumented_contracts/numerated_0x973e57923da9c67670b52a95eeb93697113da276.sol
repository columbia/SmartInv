1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     uint256 public totalSupply;
11 
12     function balanceOf(address who) public constant returns (uint256);
13 
14     function transfer(address to, uint256 value) public returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 
20 
21 
22 
23 
24 
25 
26 /**
27  * @title ERC20 interface
28  * @dev see https://github.com/ethereum/EIPs/issues/20
29  */
30 contract ERC20 is ERC20Basic {
31     function allowance(address owner, address spender) public constant returns (uint256);
32 
33     function transferFrom(address from, address to, uint256 value) public returns (bool);
34 
35     function approve(address spender, uint256 value) public returns (bool);
36 
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 
41 
42 
43 
44 
45 
46 
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20Basic {
53     using SafeMath for uint256;
54 
55     mapping (address => uint256) balances;
56 
57     /**
58     * @dev transfer token for a specified address
59     * @param _to The address to transfer to.
60     * @param _value The amount to be transferred.
61     */
62     function transfer(address _to, uint256 _value) public returns (bool) {
63         require(_to != address(0));
64 
65         // SafeMath.sub will throw if there is not enough balance.
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
77     function balanceOf(address _owner) public constant returns (uint256 balance) {
78         return balances[_owner];
79     }
80 
81 }
82 
83 
84 
85 
86 /**
87  * @title Ownable
88  * @dev The Ownable contract has an owner address, and provides basic authorization control
89  * functions, this simplifies the implementation of "user permissions".
90  */
91 contract Ownable {
92     address public owner;
93 
94     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
95     /**
96      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
97      * account.
98      */
99     function Ownable() {
100         owner = msg.sender;
101     }
102 
103     /**
104      * @dev Throws if called by any account other than the owner.
105      */
106     modifier onlyOwner() {
107         require(msg.sender == owner);
108         _;
109     }
110 
111     /**
112      * @dev Allows the current owner to transfer control of the contract to a newOwner.
113      * @param newOwner The address to transfer ownership to.
114      */
115     function transferOwnership(address newOwner) onlyOwner public {
116         require(newOwner != address(0));
117         OwnershipTransferred(owner, newOwner);
118         owner = newOwner;
119     }
120 
121 }
122 
123 
124 
125 
126 
127 
128 
129 
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20, BasicToken {
139 
140     mapping (address => mapping (address => uint256)) allowed;
141 
142 
143     /**
144      * @dev Transfer tokens from one address to another
145      * @param _from address The address which you want to send tokens from
146      * @param _to address The address which you want to transfer to
147      * @param _value uint256 the amount of tokens to be transferred
148      */
149     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
150         require(_to != address(0));
151 
152         uint256 _allowance = allowed[_from][msg.sender];
153 
154         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
155         // require (_value <= _allowance);
156 
157         balances[_from] = balances[_from].sub(_value);
158         balances[_to] = balances[_to].add(_value);
159         allowed[_from][msg.sender] = _allowance.sub(_value);
160         Transfer(_from, _to, _value);
161         return true;
162     }
163 
164     /**
165      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166      *
167      * Beware that changing an allowance with this method brings the risk that someone may use both the old
168      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171      * @param _spender The address which will spend the funds.
172      * @param _value The amount of tokens to be spent.
173      */
174     function approve(address _spender, uint256 _value) public returns (bool) {
175         allowed[msg.sender][_spender] = _value;
176         Approval(msg.sender, _spender, _value);
177         return true;
178     }
179 
180     /**
181      * @dev Function to check the amount of tokens that an owner allowed to a spender.
182      * @param _owner address The address which owns the funds.
183      * @param _spender address The address which will spend the funds.
184      * @return A uint256 specifying the amount of tokens still available for the spender.
185      */
186     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
187         return allowed[_owner][_spender];
188     }
189 
190     /**
191      * approve should be called when allowed[_spender] == 0. To increment
192      * allowed value is better to use this function to avoid 2 calls (and wait until
193      * the first transaction is mined)
194      * From MonolithDAO Token.sol
195      */
196     function increaseApproval(address _spender, uint _addedValue)
197     returns (bool success) {
198         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
199         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200         return true;
201     }
202 
203     function decreaseApproval(address _spender, uint _subtractedValue)
204     returns (bool success) {
205         uint oldValue = allowed[msg.sender][_spender];
206         if (_subtractedValue > oldValue) {
207             allowed[msg.sender][_spender] = 0;
208         }
209         else {
210             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211         }
212         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213         return true;
214     }
215 
216 }
217 
218 
219 
220 
221 
222 /**
223  * @title SafeMath
224  * @dev Math operations with safety checks that throw on error
225  */
226 library SafeMath {
227     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
228         uint256 c = a * b;
229         if (a != 0 && c / a != b) revert();
230         return c;
231     }
232 
233     function div(uint256 a, uint256 b) internal constant returns (uint256) {
234         // assert(b > 0); // Solidity automatically throws when dividing by 0
235         uint256 c = a / b;
236         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
237         return c;
238     }
239 
240     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
241         if (b > a) revert();
242         return a - b;
243     }
244 
245     function add(uint256 a, uint256 b) internal constant returns (uint256) {
246         uint256 c = a + b;
247         if (c < a) revert();
248         return c;
249     }
250 }
251 
252 contract VLBToken is Ownable {
253     using SafeMath for uint256;
254 
255     /**
256      * @dev ERC20 descriptor variables
257      */
258     string public constant name = "Vehicle Lifecycle Blockchain";
259     string public constant symbol = "VLB";
260     uint8 public decimals = 18;
261 
262     /**
263      * @dev the only wallet for tokens
264      */
265     address public tokensWallet;
266 
267     mapping (address => mapping (address => uint256)) allowed;
268     mapping (address => uint256) balances;
269     uint256 public totalSupply;
270 
271     event Approval(address indexed owner, address indexed spender, uint256 value);
272     event Burn(address indexed burner, uint256 value);
273     event Transfer(address indexed from, address indexed to, uint256 value);
274     event RawTransfer(address from, address to, uint256 value);
275 
276     /**
277      * @dev Contract constructor
278      */
279     function VLBToken(address _tokensWallet) public {
280         require(_tokensWallet != address(0));
281         tokensWallet = _tokensWallet;
282 
283         // 175 millions of token overall
284         totalSupply = 175 * 10 ** 24;
285 
286         // Issue crowdsale tokens
287         balances[tokensWallet] = balanceOf(tokensWallet).add(totalSupply);
288         Transfer(address(0), tokensWallet, totalSupply);
289     }
290 
291     /**
292     * @dev Gets the balance of the specified address.
293     * @param _owner The address to query the the balance of.
294     * @return An uint256 representing the amount owned by the passed address.
295     */
296     function balanceOf(address _owner) public constant returns (uint256 balance) {
297         return balances[_owner];
298     }
299 
300     /**
301     * @dev transfer token for a specified address
302     * @param _to The address to transfer to.
303     * @param _value The amount to be transferred.
304     */
305     function transfer(address _to, uint256 _value) public returns (bool) {
306         require(_to != address(0));
307 
308         // SafeMath.sub will throw if there is not enough balance.
309         balances[msg.sender] = balances[msg.sender].sub(_value);
310         balances[_to] = balances[_to].add(_value);
311         Transfer(msg.sender, _to, _value);
312         return true;
313     }
314 
315     /**
316      * @dev Transfer tokens from one address to another
317      * @param _from address The address which you want to send tokens from
318      * @param _to address The address which you want to transfer to
319      * @param _value uint256 the amount of tokens to be transferred
320      */
321     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
322         require(_to != address(0));
323 
324         uint256 _allowance = allowed[_from][msg.sender];
325 
326         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
327         // require (_value <= _allowance);
328 
329         balances[_from] = balances[_from].sub(_value);
330         balances[_to] = balances[_to].add(_value);
331         allowed[_from][msg.sender] = _allowance.sub(_value);
332         Transfer(_from, _to, _value);
333         return true;
334     }
335 
336     /**
337      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
338      *
339      * Beware that changing an allowance with this method brings the risk that someone may use both the old
340      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
341      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
342      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
343      * @param _spender The address which will spend the funds.
344      * @param _value The amount of tokens to be spent.
345      */
346     function approve(address _spender, uint256 _value) public returns (bool) {
347         allowed[msg.sender][_spender] = _value;
348         Approval(msg.sender, _spender, _value);
349         return true;
350     }
351 
352     /**
353      * @dev Function to check the amount of tokens that an owner allowed to a spender.
354      * @param _owner address The address which owns the funds.
355      * @param _spender address The address which will spend the funds.
356      * @return A uint256 specifying the amount of tokens still available for the spender.
357      */
358     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
359         return allowed[_owner][_spender];
360     }
361 
362     /**
363      * approve should be called when allowed[_spender] == 0. To increment
364      * allowed value is better to use this function to avoid 2 calls (and wait until
365      * the first transaction is mined)
366      * From MonolithDAO Token.sol
367      */
368     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
369         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
370         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
371         return true;
372     }
373 
374     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
375         uint oldValue = allowed[msg.sender][_spender];
376         if (_subtractedValue > oldValue) {
377             allowed[msg.sender][_spender] = 0;
378         } else {
379             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
380         }
381         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
382         return true;
383     }
384 
385 
386     /**
387      * @dev Burns a specific amount of tokens.
388      * @param _value The amount of token to be burned.
389      */
390     function burn(uint256 _value) public {
391         require(_value <= balances[msg.sender]);
392         // no need to require value <= totalSupply, since that would imply the
393         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
394 
395         address burner = msg.sender;
396         balances[burner] = balances[burner].sub(_value);
397         totalSupply = totalSupply.sub(_value);
398         Burn(burner, _value);
399     }
400 }