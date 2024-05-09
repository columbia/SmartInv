1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     uint256 public totalSupply;
10     function balanceOf(address who) public constant returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
21         uint256 c = a * b;
22         assert(a == 0 || c / a == b);
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal constant returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     function add(uint256 a, uint256 b) internal constant returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50     using SafeMath for uint256;
51 
52     mapping(address => uint256) balances;
53 
54     /**
55     * @dev transfer token for a specified address
56     * @param _to The address to transfer to.
57     * @param _value The amount to be transferred.
58     */
59     function transfer(address _to, uint256 _value) public returns (bool) {
60         require(_to != address(0));
61         require(_value <= balances[msg.sender]);
62 
63         // SafeMath.sub will throw if there is not enough balance.
64         balances[msg.sender] = balances[msg.sender].sub(_value);
65         balances[_to] = balances[_to].add(_value);
66         Transfer(msg.sender, _to, _value);
67         return true;
68     }
69 
70     /**
71     * @dev Gets the balance of the specified address.
72     * @param _owner The address to query the the balance of.
73     * @return An uint256 representing the amount owned by the passed address.
74     */
75     function balanceOf(address _owner) public constant returns (uint256 balance) {
76         return balances[_owner];
77     }
78 
79 }
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 contract ERC20 is ERC20Basic {
86     function allowance(address owner, address spender) public constant returns (uint256);
87     function transferFrom(address from, address to, uint256 value) public returns (bool);
88     function approve(address spender, uint256 value) public returns (bool);
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101     mapping (address => mapping (address => uint256)) internal allowed;
102 
103 
104     /**
105      * @dev Transfer tokens from one address to another
106      * @param _from address The address which you want to send tokens from
107      * @param _to address The address which you want to transfer to
108      * @param _value uint256 the amount of tokens to be transferred
109      */
110     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111         require(_to != address(0));
112         require(_value <= balances[_from]);
113         require(_value <= allowed[_from][msg.sender]);
114 
115         balances[_from] = balances[_from].sub(_value);
116         balances[_to] = balances[_to].add(_value);
117         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118         Transfer(_from, _to, _value);
119         return true;
120     }
121 
122     /**
123      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
124      *
125      * Beware that changing an allowance with this method brings the risk that someone may use both the old
126      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
127      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
128      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129      * @param _spender The address which will spend the funds.
130      * @param _value The amount of tokens to be spent.
131      */
132     function approve(address _spender, uint256 _value) public returns (bool) {
133         allowed[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135         return true;
136     }
137 
138     /**
139      * @dev Function to check the amount of tokens that an owner allowed to a spender.
140      * @param _owner address The address which owns the funds.
141      * @param _spender address The address which will spend the funds.
142      * @return A uint256 specifying the amount of tokens still available for the spender.
143      */
144     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
145         return allowed[_owner][_spender];
146     }
147 
148     /**
149      * approve should be called when allowed[_spender] == 0. To increment
150      * allowed value is better to use this function to avoid 2 calls (and wait until
151      * the first transaction is mined)
152      * From MonolithDAO Token.sol
153      */
154     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
155         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
156         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157         return true;
158     }
159 
160     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
161         uint oldValue = allowed[msg.sender][_spender];
162         if (_subtractedValue > oldValue) {
163             allowed[msg.sender][_spender] = 0;
164         } else {
165             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
166         }
167         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168         return true;
169     }
170 
171 }
172 
173 
174 /**
175  * @title Ownable
176  * @dev The Ownable contract has an owner address, and provides basic authorization control
177  * functions, this simplifies the implementation of "user permissions".
178  */
179 contract Ownable {
180     address public owner;
181 
182 
183     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
184 
185 
186     /**
187      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
188      * account.
189      */
190     function Ownable() {
191         owner = msg.sender;
192     }
193 
194 
195     /**
196      * @dev Throws if called by any account other than the owner.
197      */
198     modifier onlyOwner() {
199         require(msg.sender == owner);
200         _;
201     }
202 
203 
204     /**
205      * @dev Allows the current owner to transfer control of the contract to a newOwner.
206      * @param newOwner The address to transfer ownership to.
207      */
208     function transferOwnership(address newOwner) onlyOwner public {
209         require(newOwner != address(0));
210         OwnershipTransferred(owner, newOwner);
211         owner = newOwner;
212     }
213 
214 }
215 
216 contract PynToken is StandardToken, Ownable {
217 
218     string public constant name = "Paycentos Token";
219     string public constant symbol = "PYN";
220     uint256 public constant decimals = 18;
221     uint256 public totalSupply = 450000000 * (uint256(10) ** decimals);
222 
223     mapping(address => bool) public specialAccounts;
224 
225     function PynToken(address wallet) public {
226         balances[wallet] = totalSupply;
227         specialAccounts[wallet]=true;
228         Transfer(0x0, wallet, totalSupply);
229     }
230 
231     function addSpecialAccount(address account) external onlyOwner {
232         specialAccounts[account] = true;
233     }
234 
235     bool public firstSaleComplete;
236 
237     function markFirstSaleComplete() public {
238         if (specialAccounts[msg.sender]) {
239             firstSaleComplete = true;
240         }
241     }
242 
243     function isOpen() public constant returns (bool) {
244         return firstSaleComplete || specialAccounts[msg.sender];
245     }
246 
247     function transfer(address _to, uint _value) public returns (bool) {
248         return isOpen() && super.transfer(_to, _value);
249     }
250 
251     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
252         return isOpen() && super.transferFrom(_from, _to, _value);
253     }
254 
255 
256     event Burn(address indexed burner, uint256 value);
257 
258     /**
259      * @dev Burns a specific amount of tokens.
260      * @param _value The amount of token to be burned.
261      */
262     function burn(uint256 _value) public {
263         require(_value >= 0);
264         require(_value <= balances[msg.sender]);
265         // no need to require value <= totalSupply, since that would imply the
266         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
267 
268         address burner = msg.sender;
269         balances[burner] = balances[burner].sub(_value);
270         totalSupply = totalSupply.sub(_value);
271         Burn(burner, _value);
272     }
273 
274 }