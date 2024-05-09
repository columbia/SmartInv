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
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that throw on error
49  */
50 library SafeMath {
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55         uint256 c = a * b;
56         assert(c / a == b);
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         // assert(b > 0); // Solidity automatically throws when dividing by 0
62         uint256 c = a / b;
63         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64         return c;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         assert(b <= a);
69         return a - b;
70     }
71 
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         assert(c >= a);
75         return c;
76     }
77 }
78 
79 /**
80  * @title ERC20Basic
81  * @dev Simpler version of ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/179
83  */
84 contract ERC20Basic {
85     uint256 public totalSupply;
86     function balanceOf(address who) public view returns (uint256);
87     function transfer(address to, uint256 value) public returns (bool);
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 
92 
93 /**
94  * @title ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/20
96  */
97 contract ERC20 is ERC20Basic {
98     function allowance(address owner, address spender) public view returns (uint256);
99     function transferFrom(address from, address to, uint256 value) public returns (bool);
100     function approve(address spender, uint256 value) public returns (bool);
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 
105 
106 /**
107  * @title Basic token
108  * @dev Basic version of StandardToken, with no allowances.
109  */
110 contract BasicToken is ERC20Basic {
111     using SafeMath for uint256;
112 
113     mapping(address => uint256) public balances;
114 
115     /**
116     * @dev transfer token for a specified address
117     * @param _to The address to transfer to.
118     * @param _value The amount to be transferred.
119     */
120     function transfer(address _to, uint256 _value) public returns (bool) {
121         require(_to != address(0));
122         require(_value <= balances[msg.sender]);
123 
124         // SafeMath.sub will throw if there is not enough balance.
125         balances[msg.sender] = balances[msg.sender].sub(_value);
126         balances[_to] = balances[_to].add(_value);
127         Transfer(msg.sender, _to, _value);
128         return true;
129     }
130 
131     /**
132     * @dev Gets the balance of the specified address.
133     * @param _owner The address to query the the balance of.
134     * @return An uint256 representing the amount owned by the passed address.
135     */
136     function balanceOf(address _owner) public view returns (uint256 balance) {
137         return balances[_owner];
138     }
139 
140 }
141 
142 
143 
144 /**
145  * @title Standard ERC20 token
146  *
147  * @dev Implementation of the basic standard token.
148  * @dev https://github.com/ethereum/EIPs/issues/20
149  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
150  */
151 contract StandardToken is ERC20, BasicToken {
152 
153     mapping (address => mapping (address => uint256)) internal allowed;
154 
155 
156     /**
157      * @dev Transfer tokens from one address to another
158      * @param _from address The address which you want to send tokens from
159      * @param _to address The address which you want to transfer to
160      * @param _value uint256 the amount of tokens to be transferred
161      */
162     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
163         require(_to != address(0));
164         require(_value <= balances[_from]);
165         require(_value <= allowed[_from][msg.sender]);
166 
167         balances[_from] = balances[_from].sub(_value);
168         balances[_to] = balances[_to].add(_value);
169         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170         Transfer(_from, _to, _value);
171         return true;
172     }
173 
174     /**
175      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176      *
177      * Beware that changing an allowance with this method brings the risk that someone may use both the old
178      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181      * @param _spender The address which will spend the funds.
182      * @param _value The amount of tokens to be spent.
183      */
184     function approve(address _spender, uint256 _value) public returns (bool) {
185         allowed[msg.sender][_spender] = _value;
186         Approval(msg.sender, _spender, _value);
187         return true;
188     }
189 
190     /**
191      * @dev Function to check the amount of tokens that an owner allowed to a spender.
192      * @param _owner address The address which owns the funds.
193      * @param _spender address The address which will spend the funds.
194      * @return A uint256 specifying the amount of tokens still available for the spender.
195      */
196     function allowance(address _owner, address _spender) public view returns (uint256) {
197         return allowed[_owner][_spender];
198     }
199 
200     /**
201      * approve should be called when allowed[_spender] == 0. To increment
202      * allowed value is better to use this function to avoid 2 calls (and wait until
203      * the first transaction is mined)
204      * From MonolithDAO Token.sol
205      */
206     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
207         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
208         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209         return true;
210     }
211 
212     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
213         uint oldValue = allowed[msg.sender][_spender];
214         if (_subtractedValue > oldValue) {
215             allowed[msg.sender][_spender] = 0;
216         } else {
217             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
218         }
219         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220         return true;
221     }
222 
223 }
224 
225 /**
226  * @title Burnable Token
227  * @dev Token that can be irreversibly burned (destroyed).
228  */
229 contract BurnableToken is StandardToken {
230 
231     event Burn(address indexed burner, uint256 value);
232 
233     /**
234      * @dev Burns a specific amount of tokens.
235      * @param _value The amount of token to be burned.
236      */
237     function burn(uint256 _value) public {
238         require(_value > 0);
239         require(_value <= balances[msg.sender]);
240         // no need to require value <= totalSupply, since that would imply the
241         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
242 
243         address burner = msg.sender;
244         balances[burner] = balances[burner].sub(_value);
245         totalSupply = totalSupply.sub(_value);
246         Burn(burner, _value);
247     }
248 }
249 
250 /**
251  * @title CABoxToken
252  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
253  * Note they can later distribute these tokens as they wish using `transfer` and other
254  * `StandardToken` functions.
255  */
256 contract CABoxToken is BurnableToken, Ownable {
257 
258     string public constant name = "CABox";
259     string public constant symbol = "CAB";
260     uint8 public constant decimals = 18;
261     
262     uint256 public constant INITIAL_SUPPLY = 999 * 1000000 * (10 ** uint256(decimals));
263 
264     /**
265      * @dev Constructor that gives msg.sender all of existing tokens.
266      */
267     function CABoxToken() public {
268         totalSupply = INITIAL_SUPPLY;
269         balances[msg.sender] = INITIAL_SUPPLY;
270     }
271 }