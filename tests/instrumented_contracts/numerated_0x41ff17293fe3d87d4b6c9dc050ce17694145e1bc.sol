1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10 
11     address public owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     function Ownable() {
20         owner = msg.sender;
21     }
22 
23     /**
24      * @dev Throws if called by any account other than the owner.
25      */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     /**
32      * @dev Allows the current owner to transfer control of the contract to a newOwner.
33      * @param newOwner The address to transfer ownership to.
34      */
35     function transferOwnership(address newOwner) public onlyOwner {
36         require(newOwner != address(0));
37         OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39     }
40 
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 
48 library SafeMath {
49 
50     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
51         uint256 c = a * b;
52         assert(a == 0 || c / a == b);
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal constant returns (uint256) {
57         // assert(b > 0); // Solidity automatically throws when dividing by 0
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60         return c;
61     }
62 
63     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
64         assert(b <= a);
65         return a - b;
66     }
67 
68     function add(uint256 a, uint256 b) internal constant returns (uint256) {
69         uint256 c = a + b;
70         assert(c >= a);
71         return c;
72     }
73 }
74 
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/179
80  */
81 contract ERC20Basic {
82     uint256 public totalSupply;
83 
84     function balanceOf(address who) public constant returns (uint256);
85 
86     function transfer(address to, uint256 value) public returns (bool);
87 
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 /**
92  * @title Basic token
93  * @dev Basic version of StandardToken, with no allowances.
94  */
95 contract BasicToken is ERC20Basic {
96     using SafeMath for uint256;
97 
98     mapping (address => uint256) public balances;
99 
100     bool public endICO = false;
101     uint256 public dateEndIco;
102 
103     event TransferStart();
104 
105     modifier canTransfer() {
106         require(endICO);
107         require(dateEndIco + (3 weeks) > now);
108         _;
109     }
110 
111     /**
112     * @dev transfer token for a specified address
113     * @param _to The address to transfer to.
114     * @param _value The amount to be transferred.
115     */
116     function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
117         require(_to != address(0));
118 
119         // SafeMath.sub will throw if there is not enough balance.
120         balances[msg.sender] = balances[msg.sender].sub(_value);
121         balances[_to] = balances[_to].add(_value);
122         Transfer(msg.sender, _to, _value);
123         return true;
124     }
125 
126     /**
127     * @dev Gets the balance of the specified address.
128     * @param _owner The address to query the the balance of.
129     * @return An uint256 representing the amount owned by the passed address.
130     */
131     function balanceOf(address _owner) public constant returns (uint256 balance) {
132         return balances[_owner];
133     }
134 
135     function finishICO() internal returns (bool) {
136         endICO = true;
137         dateEndIco = now;
138         TransferStart();
139         return true;
140     }
141 
142 }
143 
144 
145 
146 
147 /** @title ERC20 interface
148 * @dev see https://github.com/ethereum/EIPs/issues/20
149 */
150 
151 contract ERC20 is ERC20Basic {
152     function allowance(address owner, address spender) public constant returns (uint256);
153 
154     function transferFrom(address from, address to, uint256 value) public returns (bool);
155 
156     function approve(address spender, uint256 value) public returns (bool);
157 
158     event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 
162 
163 contract TokenRecipient {
164     function receiveApproval(address _from, uint _value, address _tknAddress, bytes _extraData);
165 }
166 
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood:
174  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  */
176 contract StandardToken is ERC20, BasicToken {
177 
178     mapping (address => mapping (address => uint256)) allowed;
179 
180     /**
181     * @dev Transfer tokens from one address to another
182     * @param _from address The address which you want to send tokens from
183     * @param _to address The address which you want to transfer to
184     * @param _value uint256 the amount of tokens to be transferred
185     */
186     function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
187         require(_to != address(0));
188 
189         uint256 _allowance = allowed[_from][msg.sender];
190 
191         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
192         // require (_value <= _allowance);
193 
194         balances[_from] = balances[_from].sub(_value);
195         balances[_to] = balances[_to].add(_value);
196         allowed[_from][msg.sender] = _allowance.sub(_value);
197         Transfer(_from, _to, _value);
198         return true;
199     }
200 
201     /**
202      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
203      *
204      * Beware that changing an allowance with this method brings the risk that someone may use both the old
205      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      * @param _spender The address which will spend the funds.
209      * @param _value The amount of tokens to be spent.
210      */
211     function approve(address _spender, uint256 _value) public canTransfer returns (bool) {
212         allowed[msg.sender][_spender] = _value;
213         Approval(msg.sender, _spender, _value);
214         return true;
215     }
216 
217     /**
218     * Set allowance for other address and notify
219     *
220     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
221     *
222     * @param _spender The address authorized to spend
223     * @param _value the max amount they can spend
224     * @param _extraData some extra information to send to the approved contract
225     */
226     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public
227     canTransfer returns (bool success) {
228         TokenRecipient spender = TokenRecipient(_spender);
229         if (approve(_spender, _value)) {
230             spender.receiveApproval(msg.sender, _value, this, _extraData);
231             return true;
232         }
233     }
234 
235     /**
236     * @dev Function to check the amount of tokens that an owner allowed to a spender.
237     * @param _owner address The address which owns the funds.
238     * @param _spender address The address which will spend the funds.
239     * @return A uint256 specifying the amount of tokens still available for the spender.
240     */
241     function allowance(address _owner, address _spender) public canTransfer constant returns (uint256 remaining) {
242         return allowed[_owner][_spender];
243     }
244 
245     /**
246     * approve should be called when allowed[_spender] == 0. To increment
247     * allowed value is better to use this function to avoid 2 calls (and wait until
248     * the first transaction is mined)
249     * From MonolithDAO Token.sol
250     */
251     function increaseApproval(address _spender, uint _addedValue) public canTransfer returns (bool success) {
252         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
253         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254         return true;
255     }
256 
257     function decreaseApproval(address _spender, uint _subtractedValue) public canTransfer returns (bool success) {
258         uint oldValue = allowed[msg.sender][_spender];
259         if (_subtractedValue > oldValue) {
260             allowed[msg.sender][_spender] = 0;
261         } else {
262             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
263         }
264         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265         return true;
266     }
267 
268 }
269 
270 
271 /**
272 * @title Mintable token
273 * @dev Simple ERC20 Token example, with mintable token creation
274 * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
275 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
276 */
277 contract MintableToken is StandardToken, Ownable {
278 
279     event Mint(address indexed to, uint256 amount);
280 
281     event MintFinished();
282 
283     bool public mintingFinished = false;
284 
285     modifier canMint() {
286         require(!mintingFinished);
287         _;
288     }
289 
290     /**
291      * @dev Function to mint tokens
292      * @param _to The address that will receive the minted tokens.
293      * @param _amount The amount of tokens to mint.
294      * @return A boolean that indicates if the operation was successful.
295      */
296     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
297         totalSupply = totalSupply.add(_amount);
298         balances[_to] = balances[_to].add(_amount);
299         Mint(_to, _amount);
300         Transfer(0x0, _to, _amount);
301         return true;
302     }
303 
304     /**
305     * @dev Function to stop minting new tokens.
306     * @return True if the operation was successful.
307     */
308     function finishMinting() public onlyOwner returns (bool) {
309         mintingFinished = true;
310         finishICO();
311         MintFinished();
312         return true;
313     }
314 
315 }
316 
317 
318 /**
319  * @title SampleCrowdsaleToken
320  * @dev Very simple ERC20 Token that can be minted.
321  * It is meant to be used in a crowdsale contract.
322  */
323 contract NOUSToken is MintableToken {
324 
325     string public constant name = "NOUSTOKEN";
326 
327     string public constant symbol = "NST";
328 
329     uint32 public constant decimals = 18;
330 
331 }