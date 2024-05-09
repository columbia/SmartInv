1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     function Ownable() public {
20         owner = msg.sender;
21     }
22 
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32 
33     /**
34      * @dev Allows the current owner to transfer control of the contract to a newOwner.
35      * @param newOwner The address to transfer ownership to.
36      */
37     function transferOwnership(address newOwner) public onlyOwner {
38         require(newOwner != address(0));
39         OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 
43 }
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54         uint256 c = a * b;
55         assert(c / a == b);
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         // assert(b > 0); // Solidity automatically throws when dividing by 0
61         uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63         return c;
64     }
65 
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         assert(b <= a);
68         return a - b;
69     }
70 
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         assert(c >= a);
74         return c;
75     }
76 }
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84     uint256 public totalSupply;
85     function balanceOf(address who) public view returns (uint256);
86     function transfer(address to, uint256 value) public returns (bool);
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95     function allowance(address owner, address spender) public view returns (uint256);
96     function transferFrom(address from, address to, uint256 value) public returns (bool);
97     function approve(address spender, uint256 value) public returns (bool);
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is ERC20Basic {
106     using SafeMath for uint256;
107 
108     mapping(address => uint256) balances;
109 
110     /**
111     * @dev transfer token for a specified address
112     * @param _to The address to transfer to.
113     * @param _value The amount to be transferred.
114     */
115     function transfer(address _to, uint256 _value) public returns (bool) {
116         require(_to != address(0));
117         require(_value <= balances[msg.sender]);
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
131     function balanceOf(address _owner) public view returns (uint256 balance) {
132         return balances[_owner];
133     }
134 
135 }
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * @dev https://github.com/ethereum/EIPs/issues/20
142  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146     mapping (address => mapping (address => uint256)) internal allowed;
147 
148 
149     /**
150      * @dev Transfer tokens from one address to another
151      * @param _from address The address which you want to send tokens from
152      * @param _to address The address which you want to transfer to
153      * @param _value uint256 the amount of tokens to be transferred
154      */
155     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156         require(_to != address(0));
157         require(_value <= balances[_from]);
158         require(_value <= allowed[_from][msg.sender]);
159 
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163         Transfer(_from, _to, _value);
164         return true;
165     }
166 
167     /**
168      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169      *
170      * Beware that changing an allowance with this method brings the risk that someone may use both the old
171      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174      * @param _spender The address which will spend the funds.
175      * @param _value The amount of tokens to be spent.
176      */
177     function approve(address _spender, uint256 _value) public returns (bool) {
178         allowed[msg.sender][_spender] = _value;
179         Approval(msg.sender, _spender, _value);
180         return true;
181     }
182 
183     /**
184      * @dev Function to check the amount of tokens that an owner allowed to a spender.
185      * @param _owner address The address which owns the funds.
186      * @param _spender address The address which will spend the funds.
187      * @return A uint256 specifying the amount of tokens still available for the spender.
188      */
189     function allowance(address _owner, address _spender) public view returns (uint256) {
190         return allowed[_owner][_spender];
191     }
192 
193     /**
194      * approve should be called when allowed[_spender] == 0. To increment
195      * allowed value is better to use this function to avoid 2 calls (and wait until
196      * the first transaction is mined)
197      * From MonolithDAO Token.sol
198      */
199     function increaseApproval (address _spender, uint _addedValue) public returns (bool) {
200         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202         return true;
203     }
204 
205     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool) {
206         uint oldValue = allowed[msg.sender][_spender];
207         if (_subtractedValue > oldValue) {
208             allowed[msg.sender][_spender] = 0;
209         } else {
210             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211         }
212         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213         return true;
214     }
215 
216 }
217 
218 /**
219  * @title Burnable Token
220  * @dev Token that can be irreversibly burned (destroyed).
221  */
222 contract BurnableToken is StandardToken {
223 
224     event Burn(address indexed burner, uint256 value);
225 
226     /**
227      * @dev Burns a specific amount of tokens.
228      * @param _value The amount of token to be burned.
229      */
230     function burn(uint256 _value) public {
231         require(_value <= balances[msg.sender]);
232         // no need to require value <= totalSupply, since that would imply the
233         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
234 
235         address burner = msg.sender;
236         balances[burner] = balances[burner].sub(_value);
237         totalSupply = totalSupply.sub(_value);
238         Burn(burner, _value);
239     }
240 }
241 
242 contract UniversalCoin is BurnableToken, Ownable {
243 
244     string constant public name = "UniversalCoin";
245     string constant public symbol = "UNV";
246     uint256 constant public decimals = 6;
247     uint256 constant public airdropReserve = 2400000000E6; // 2.4 bln tokens reserved for airdrops;
248     uint256 constant public pool = 32000000000E6;
249 
250     function UniversalCoin(address uniFoundation) public {
251         totalSupply = 40000000000E6; // 40 bln tokens
252         balances[uniFoundation] = 5600000000E6; // 5.6 bln tokens reserved for Universal foundation
253         balances[owner] = pool + airdropReserve; // 40 bln - airdrop - foundation reserve
254     }
255 
256 }