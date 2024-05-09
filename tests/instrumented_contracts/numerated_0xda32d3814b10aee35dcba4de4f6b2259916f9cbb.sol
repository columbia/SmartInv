1 pragma solidity ^0.4.18;
2 library SafeMath {
3 
4     /**
5     * @dev Multiplies two numbers, throws on overflow.
6     */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     /**
17     * @dev Integer division of two numbers, truncating the quotient.
18     */
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21         uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return c;
24     }
25 
26     /**
27     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
28     */
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         assert(b <= a);
31         return a - b;
32     }
33 
34     /**
35     * @dev Adds two numbers, throws on overflow.
36     */
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         assert(c >= a);
40         return c;
41     }
42 }
43 
44 contract Ownable {
45     address public owner;
46 
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50 
51     /**
52      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53      * account.
54      */
55     function Ownable() public {
56         owner = msg.sender;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     /**
68      * @dev Allows the current owner to transfer control of the contract to a newOwner.
69      * @param newOwner The address to transfer ownership to.
70      */
71     function transferOwnership(address newOwner) public onlyOwner {
72         require(newOwner != address(0));
73         OwnershipTransferred(owner, newOwner);
74         owner = newOwner;
75     }
76 
77 }
78 
79 contract ERC20Basic {
80     function totalSupply() public view returns (uint256);
81     function balanceOf(address who) public view returns (uint256);
82     function transfer(address to, uint256 value) public returns (bool);
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 }
85 
86 contract BasicToken is ERC20Basic {
87     using SafeMath for uint256;
88 
89     mapping(address => uint256) balances;
90 
91     uint256 totalSupply_;
92 
93     /**
94     * @dev total number of tokens in existence
95     */
96     function totalSupply() public view returns (uint256) {
97         return totalSupply_;
98     }
99 
100     /**
101     * @dev transfer token for a specified address
102     * @param _to The address to transfer to.
103     * @param _value The amount to be transferred.
104     */
105     function transfer(address _to, uint256 _value) public returns (bool) {
106         require(_to != address(0));
107         require(_value <= balances[msg.sender]);
108 
109         // SafeMath.sub will throw if there is not enough balance.
110         balances[msg.sender] = balances[msg.sender].sub(_value);
111         balances[_to] = balances[_to].add(_value);
112         Transfer(msg.sender, _to, _value);
113         return true;
114     }
115 
116     /**
117     * @dev Gets the balance of the specified address.
118     * @param _owner The address to query the the balance of.
119     * @return An uint256 representing the amount owned by the passed address.
120     */
121     function balanceOf(address _owner) public view returns (uint256 balance) {
122         return balances[_owner];
123     }
124 
125 }
126 
127 contract BurnableToken is BasicToken {
128 
129     event Burn(address indexed burner, uint256 value);
130 
131     /**
132      * @dev Burns a specific amount of tokens.
133      * @param _value The amount of token to be burned.
134      */
135     function burn(uint256 _value) public {
136         require(_value <= balances[msg.sender]);
137         // no need to require value <= totalSupply, since that would imply the
138         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
139 
140         address burner = msg.sender;
141         balances[burner] = balances[burner].sub(_value);
142         totalSupply_ = totalSupply_.sub(_value);
143         Burn(burner, _value);
144     }
145 }
146 
147 contract ERC20 is ERC20Basic {
148     function allowance(address owner, address spender) public view returns (uint256);
149     function transferFrom(address from, address to, uint256 value) public returns (bool);
150     function approve(address spender, uint256 value) public returns (bool);
151     event Approval(address indexed owner, address indexed spender, uint256 value);
152 }
153 
154 library SafeERC20 {
155     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
156         assert(token.transfer(to, value));
157     }
158 
159     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
160         assert(token.transferFrom(from, to, value));
161     }
162 
163     function safeApprove(ERC20 token, address spender, uint256 value) internal {
164         assert(token.approve(spender, value));
165     }
166 }
167 
168 contract StandardToken is ERC20, BasicToken {
169 
170     mapping (address => mapping (address => uint256)) internal allowed;
171 
172 
173     /**
174      * @dev Transfer tokens from one address to another
175      * @param _from address The address which you want to send tokens from
176      * @param _to address The address which you want to transfer to
177      * @param _value uint256 the amount of tokens to be transferred
178      */
179     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
180         require(_to != address(0));
181         require(_value <= balances[_from]);
182         require(_value <= allowed[_from][msg.sender]);
183 
184         balances[_from] = balances[_from].sub(_value);
185         balances[_to] = balances[_to].add(_value);
186         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187         Transfer(_from, _to, _value);
188         return true;
189     }
190 
191     /**
192      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193      *
194      * Beware that changing an allowance with this method brings the risk that someone may use both the old
195      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198      * @param _spender The address which will spend the funds.
199      * @param _value The amount of tokens to be spent.
200      */
201     function approve(address _spender, uint256 _value) public returns (bool) {
202         allowed[msg.sender][_spender] = _value;
203         Approval(msg.sender, _spender, _value);
204         return true;
205     }
206 
207     /**
208      * @dev Function to check the amount of tokens that an owner allowed to a spender.
209      * @param _owner address The address which owns the funds.
210      * @param _spender address The address which will spend the funds.
211      * @return A uint256 specifying the amount of tokens still available for the spender.
212      */
213     function allowance(address _owner, address _spender) public view returns (uint256) {
214         return allowed[_owner][_spender];
215     }
216 
217     /**
218      * @dev Increase the amount of tokens that an owner allowed to a spender.
219      *
220      * approve should be called when allowed[_spender] == 0. To increment
221      * allowed value is better to use this function to avoid 2 calls (and wait until
222      * the first transaction is mined)
223      * From MonolithDAO Token.sol
224      * @param _spender The address which will spend the funds.
225      * @param _addedValue The amount of tokens to increase the allowance by.
226      */
227     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
228         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230         return true;
231     }
232 
233     /**
234      * @dev Decrease the amount of tokens that an owner allowed to a spender.
235      *
236      * approve should be called when allowed[_spender] == 0. To decrement
237      * allowed value is better to use this function to avoid 2 calls (and wait until
238      * the first transaction is mined)
239      * From MonolithDAO Token.sol
240      * @param _spender The address which will spend the funds.
241      * @param _subtractedValue The amount of tokens to decrease the allowance by.
242      */
243     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
244         uint oldValue = allowed[msg.sender][_spender];
245         if (_subtractedValue > oldValue) {
246             allowed[msg.sender][_spender] = 0;
247         } else {
248             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249         }
250         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251         return true;
252     }
253 
254 }
255 
256 contract Swap is StandardToken, BurnableToken, Ownable {
257     using SafeMath for uint;
258 
259     string constant public symbol = "SWAP";
260     string constant public name = "Swap";
261 
262     uint8 constant public decimals = 18;
263     uint256 INITIAL_SUPPLY = 1000000000e18;
264 
265     address initialWallet = 0x41AA4bF6c87F5323214333c8885C5Fb660B00A57;
266 
267     function Swap() public {
268 
269         totalSupply_ = INITIAL_SUPPLY;
270         
271         // initialFunding
272         initialFunding(initialWallet, totalSupply_);
273 
274     }
275 
276     function initialFunding(address _address, uint _amount) internal returns (bool) {
277         balances[_address] = _amount;
278         Transfer(address(0x0), _address, _amount);
279     }
280 
281 
282     function transfer(address _to, uint256 _value) public returns (bool) {
283         super.transfer(_to, _value);
284     }
285 
286     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
287         super.transferFrom(_from, _to, _value);
288     }
289     // Don't accept ETH
290     function () public payable {
291         revert();
292     }
293 
294 }