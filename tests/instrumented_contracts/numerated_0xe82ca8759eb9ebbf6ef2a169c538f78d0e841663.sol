1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         // assert(b > 0); // Solidity automatically throws when dividing by 0
14         uint256 c = a / b;
15         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16         return c;
17     }
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Ownable {
30     address public owner;
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32     constructor () public {
33         owner = msg.sender;
34     }
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39     function transferOwnership(address newOwner) public onlyOwner {
40         require(newOwner != address(0));
41         emit OwnershipTransferred(owner, newOwner);
42         owner = newOwner;
43     }
44 }
45 
46 contract ERC20Basic {
47     function totalSupply() public view returns (uint256);
48     function balanceOf(address who) public view returns (uint256);
49     function transfer(address to, uint256 value) public returns (bool);
50 
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 contract ERC20 is ERC20Basic {
55     function allowance(address owner, address spender) public view returns (uint256);
56     function transferFrom(address from, address to, uint256 value) public returns (bool);
57     function approve(address spender, uint256 value) public returns (bool);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 contract BasicToken is ERC20Basic{
62     using SafeMath for uint256;
63     mapping(address => uint256) balances;
64     uint256 internal totalSupply_;
65     /**
66      * @dev total number of tokens in existence
67      */
68     function totalSupply() public view returns (uint256) {
69         return totalSupply_;
70     }
71 
72     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
73         require(_to != address(0));
74         require(_from != address(0));
75         require(_value != 0);
76         require(_value <= balances[_from]);
77         // SafeMath.sub will throw if there is not enough balance.
78         balances[_from] = balances[_from].sub(_value);
79         balances[_to] = balances[_to].add(_value);
80         emit Transfer(_from, _to, _value);
81         return true;
82     }
83 
84     /**
85     * @dev transfer token for a specified address
86     * @param _to The address to transfer to.
87     * @param _value The amount to be transferred.
88      */
89 
90     function transfer(address _to, uint256 _value) public returns (bool) {
91         return _transfer(msg.sender, _to, _value);
92     }
93     /**
94      * @dev Gets the balance of the specified address.
95      * @param _owner The address to query the the balance of.
96      * @return An uint256 representing the amount owned by the passed address.
97      */
98     function balanceOf(address _owner) public view returns (uint256 balance) {
99         return balances[_owner];
100     }
101 }
102 contract StandardToken is ERC20, BasicToken {
103     mapping(address => mapping(address => uint256)) internal allowed;
104 
105     /**
106      * @dev Transfer tokens from one address to another
107      * @param _from address The address which you want to send tokens from
108      * @param _to address The address which you want to transfer to
109      * @param _value uint256 the amount of tokens to be transferred
110      */
111     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112         require(_value <= allowed[_from][msg.sender]);
113         _transfer(_from, _to, _value);
114         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
115         return true;
116     }
117 
118     /**
119     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
120     *
121     * Beware that changing an allowance with this method brings the risk that someone may use both the old
122     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
123     * race condition is to first reduce the spenders allowance to 0 and set the desired value afterwards:
124     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125     * @param _spender The address which will spend the funds.
126     * @param _value The amount of tokens to be spent.
127      */
128 
129     function approve(address _spender, uint256 _value) public returns (bool) {
130         require(_spender != address(0));
131         allowed[msg.sender][_spender] = _value;
132         emit Approval(msg.sender, _spender, _value);
133         return true;
134     }
135 
136     /**
137      * @dev Function to check the amount of tokens that an owner allowed to a spender.
138      * @param _owner address The address which owns the funds.
139      * @param _spender address The address which will spend the funds.
140      * @return A uint256 specifying the amount of tokens still available for the spender.
141      */
142     function allowance(address _owner, address _spender) public view returns (uint256) {
143         return allowed[_owner][_spender];
144     }
145     /**
146      * @dev Increase the amount of tokens that an owner allowed to a spender.
147      *
148      * approve should be called when allowed[_spender] == 0. To increment
149      * allowed value is better to use this function to avoid 2 calls (and wait until
150      * the first transaction is mined)
151      * From MonolithDAO Token.sol
152      * @param _spender The address which will spend the funds.
153      * @param _addedValue The amount of tokens to increase the allowance by.
154      */
155     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
156         require(_spender != address(0));
157         require(_addedValue != 0);
158         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160         return true;
161     }
162     /**
163      * @dev Decrease the amount of tokens that an owner allowed to a spender.
164      * approve should be called when allowed[_spender] == 0. To decrement
165      * allowed value is better to use this function to avoid 2 calls (and wait until
166      * the first transaction is mined)
167      * From MonolithDAO Token.sol
168      * @param _spender The address which will spend the funds.
169      * @param _subtractedValue The amount of tokens to decrease the allowance by.
170      */
171     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
172         require(_spender != address(0));
173         require(_subtractedValue != 0);
174         uint oldValue = allowed[msg.sender][_spender];
175         if (_subtractedValue > oldValue) {
176             allowed[msg.sender][_spender] = 0;
177         } else {
178             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
179         }
180         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181         return true;
182     }
183 }
184 
185 contract BurnableToken is StandardToken {
186     event Burn(address indexed burner, uint256 value);
187     /**
188     * @dev Burns a specific amount of tokens.
189     * @param _value The amount of token to be burned.
190     */
191     function burn(uint256 _value) public {
192         require(_value <= balances[msg.sender]);
193         require(_value != 0);
194         // no need to require value <= totalSupply, since that would imply the
195         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
196         balances[msg.sender] = balances[msg.sender].sub(_value);
197         totalSupply_ = totalSupply_.sub(_value);
198         emit Transfer(msg.sender, address(0), _value);
199         emit Burn(msg.sender, _value);
200     }
201 }
202 
203 contract ISTCoin is BurnableToken, Ownable {
204     string public constant name = "ISTCoin";
205     string public constant symbol = "IST";
206     uint8 public constant decimals = 8;
207 
208     bool public unFreeze = false;
209     mapping (address => bool) public frozenAccount;
210 
211     modifier notFrozen(address sender) {
212         require(!frozenAccount[sender] || unFreeze);
213         _;
214     }
215 
216     event FrozenFunds(address target, bool frozen);
217     event FreezeAll(bool flag);
218     event AccountFrozenError();
219 
220     uint256 public constant INITIAL_SUPPLY = 200000000 * (10 ** uint256(decimals));
221     constructor () public {
222         totalSupply_ = INITIAL_SUPPLY;
223         balances[msg.sender] = INITIAL_SUPPLY;
224         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
225     }
226 
227     function freezeAccount(address target, bool freeze) public onlyOwner {
228         frozenAccount[target] = freeze;
229         emit FrozenFunds(target, freeze);
230     }
231 
232     // unfreeze all accounts
233     function unFreezeAll(bool flag) public onlyOwner {
234         unFreeze = flag;
235         emit FreezeAll(flag);
236     }
237 
238     function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns (bool) {
239         return super.transfer(_to, _value);
240     }
241 
242     function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {
243         return super.transferFrom(_from, _to, _value);
244     }
245 
246     function approve(address _spender, uint256 _value) public notFrozen(msg.sender) returns (bool) {
247         return super.approve(_spender, _value);
248     }
249 }