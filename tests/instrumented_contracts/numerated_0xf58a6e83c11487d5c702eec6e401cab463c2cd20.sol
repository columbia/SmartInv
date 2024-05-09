1 pragma solidity ^0.4.21;
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
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 
33 contract Ownable {
34     address public owner;
35 
36 
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39 
40     /**
41      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42      * account.
43      */
44     function Ownable() public {
45         owner = msg.sender;
46     }
47 
48     /**
49      * @dev Throws if called by any account other than the owner.
50      */
51     modifier onlyOwner() {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) public onlyOwner {
61         require(newOwner != address(0));
62         emit OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64     }
65 
66 }
67 
68 contract ERC20 {
69     uint256 public totalSupply;
70     function balanceOf(address who) public view returns (uint256);
71     function transfer(address to, uint256 value) public returns (bool);
72     event Transfer(address indexed from, address indexed to, uint256 value);
73     function allowance(address owner, address spender) public view returns (uint256);
74     function transferFrom(address from, address to, uint256 value) public returns (bool);
75     function approve(address spender, uint256 value) public returns (bool);
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 
80 library SafeERC20 {
81     function safeTransfer(ERC20 token, address to, uint256 value) internal {
82         assert(token.transfer(to, value));
83     }
84 
85     function safeTransferFrom(
86         ERC20 token,
87         address from,
88         address to,
89         uint256 value
90     )
91     internal
92     {
93         assert(token.transferFrom(from, to, value));
94     }
95 
96     function safeApprove(ERC20 token, address spender, uint256 value) internal {
97         assert(token.approve(spender, value));
98     }
99 }
100 
101 
102 contract StandardToken is ERC20, Ownable {
103     using SafeMath for uint256;
104 
105     mapping(address => uint256) balances;
106     mapping (address => mapping (address => uint256)) internal allowed;
107 
108     bool public transfersEnabled = false;
109 
110 
111     event Burn(address indexed burner, uint256 value);
112 
113 
114     modifier whenTransfersEnabled {
115         require(transfersEnabled || msg.sender == owner);
116         _;
117     }
118 
119     /**
120     * @dev transfer token for a specified address
121     * @param _to The address to transfer to.
122     * @param _value The amount to be transferred.
123     */
124     function transfer(address _to, uint256 _value) whenTransfersEnabled public returns (bool) {
125         return _transfer(msg.sender, _to, _value);
126     }
127 
128 
129     function _transfer(address _from, address _to, uint256 _value)  internal returns (bool) {
130         require(_to != address(0));
131         require(_value <= balances[_from]);
132 
133         // SafeMath.sub will throw if there is not enough balance.
134         balances[_from] = balances[_from].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         emit Transfer(_from, _to, _value);
137         return true;
138     }
139 
140     /**
141     * @dev Gets the balance of the specified address.
142     * @param _owner The address to query the the balance of.
143     * @return An uint256 representing the amount owned by the passed address.
144     */
145     function balanceOf(address _owner) public view returns (uint256 balance) {
146         return balances[_owner];
147     }
148 
149 
150     /**
151      * @dev Transfer tokens from one address to another
152      * @param _from address The address which you want to send tokens from
153      * @param _to address The address which you want to transfer to
154      * @param _value uint256 the amount of tokens to be transferred
155      */
156     function transferFrom(address _from, address _to, uint256 _value) whenTransfersEnabled public returns (bool) {
157         require(_value <= allowed[_from][msg.sender]);
158         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159         return _transfer(_from, _to, _value);
160     }
161 
162     /**
163      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164      *
165      * Beware that changing an allowance with this method brings the risk that someone may use both the old
166      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      * @param _spender The address which will spend the funds.
170      * @param _value The amount of tokens to be spent.
171      */
172     function approve(address _spender, uint256 _value) whenTransfersEnabled public returns (bool) {
173         allowed[msg.sender][_spender] = _value;
174         emit Approval(msg.sender, _spender, _value);
175         return true;
176     }
177 
178     /**
179      * @dev Function to check the amount of tokens that an owner allowed to a spender.
180      * @param _owner address The address which owns the funds.
181      * @param _spender address The address which will spend the funds.
182      * @return A uint256 specifying the amount of tokens still available for the spender.
183      */
184     function allowance(address _owner, address _spender)  public view returns (uint256) {
185         return allowed[_owner][_spender];
186     }
187 
188     /**
189      * @dev Increase the amount of tokens that an owner allowed to a spender.
190      *
191      * approve should be called when allowed[_spender] == 0. To increment
192      * allowed value is better to use this function to avoid 2 calls (and wait until
193      * the first transaction is mined)
194      * From MonolithDAO Token.sol
195      * @param _spender The address which will spend the funds.
196      * @param _addedValue The amount of tokens to increase the allowance by.
197      */
198     function increaseApproval(address _spender, uint _addedValue) whenTransfersEnabled  public returns (bool) {
199         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
200         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201         return true;
202     }
203 
204     /**
205      * @dev Decrease the amount of tokens that an owner allowed to a spender.
206      *
207      * approve should be called when allowed[_spender] == 0. To decrement
208      * allowed value is better to use this function to avoid 2 calls (and wait until
209      * the first transaction is mined)
210      * From MonolithDAO Token.sol
211      * @param _spender The address which will spend the funds.
212      * @param _subtractedValue The amount of tokens to decrease the allowance by.
213      */
214     function decreaseApproval(address _spender, uint _subtractedValue) whenTransfersEnabled public returns (bool) {
215         uint oldValue = allowed[msg.sender][_spender];
216         if (_subtractedValue > oldValue) {
217             allowed[msg.sender][_spender] = 0;
218         } else {
219             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220         }
221         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222         return true;
223     }
224 
225 
226     function enableTransfers() onlyOwner external {
227         transfersEnabled = true;
228     }
229 
230 
231     function burn(uint256 _value) external {
232         _burn(msg.sender, _value);
233     }
234 
235     function _burn(address _who, uint256 _value) internal {
236         require(_value <= balances[_who]);
237         // no need to require value <= totalSupply, since that would imply the
238         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
239 
240         balances[_who] = balances[_who].sub(_value);
241         totalSupply = totalSupply.sub(_value);
242         emit Burn(_who, _value);
243         emit Transfer(_who, address(0), _value);
244     }
245 
246 }
247 
248 
249 contract BNSToken is StandardToken {
250     string public constant name = "Basis Neuro System Token";
251     string public constant symbol = "BNST";
252     uint8 public constant decimals = 18;
253 
254 
255     uint256 public constant INITIAL_SUPPLY = 3000000000  * (10 ** uint256(decimals));
256 
257 
258     function BNSToken() public {
259         totalSupply = INITIAL_SUPPLY;
260         balances[msg.sender] = INITIAL_SUPPLY;
261         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
262     }
263 }