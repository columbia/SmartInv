1 /**
2  *Submitted for verification at Etherscan.io on 2019-12-21
3 */
4 
5 pragma solidity 0.5.11;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a * b;
14         assert(a == 0 || c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44     
45     address public owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51      * account.
52      */
53     constructor() public {
54         owner = msg.sender;
55     }
56 
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     /**
67      * @dev Allows the current owner to transfer control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function transferOwnership(address newOwner) onlyOwner public {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74     }
75 }
76 
77 /**
78  * @title ERC20Basic
79  * @dev Simpler version of ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/179
81  */
82 contract ERC20Basic {
83     uint256 public totalSupply;
84     function balanceOf(address who) public view returns (uint256);
85     function transfer(address to, uint256 value) public returns (bool);
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 
90 /**
91  * @title Basic token
92  * @dev Basic version of StandardToken, with no allowances.
93  */
94 contract BasicToken is ERC20Basic {
95 
96     using SafeMath for uint256;
97 
98     mapping(address => uint256) internal balances;
99 
100     /**
101      * @dev transfer token for a specified address
102      * @param _to The address to transfer to.
103      * @param _value The amount to be transferred.
104      */
105     function transfer(address _to, uint256 _value) public returns (bool) {
106         require(_to != address(0) && _to != address(this));
107 
108         // SafeMath.sub will throw if there is not enough balance.
109         balances[msg.sender] = balances[msg.sender].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         emit Transfer(msg.sender, _to, _value);
112         return true;
113     }
114 
115     /**
116      * @dev Gets the balance of the specified address.
117      * @param _owner The address to query the the balance of.
118      * @return An uint256 representing the amount owned by the passed address.
119      */
120     function balanceOf(address _owner) public view returns (uint256 balance) {
121         return balances[_owner];
122     }
123 }
124 
125 /**
126  * @title ERC20 interface
127  * @dev see https://github.com/ethereum/EIPs/issues/20
128  */
129 contract ERC20 is ERC20Basic {
130     function allowance(address owner, address spender) public view returns (uint256);
131     function transferFrom(address from, address to, uint256 value) public returns (bool);
132     function approve(address spender, uint256 value) public returns (bool);
133     event Approval(address indexed owner, address indexed spender, uint256 value);
134 }
135 
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
148     /**
149      * @dev Transfer tokens from one address to another
150      * @param _from address The address which you want to send tokens from
151      * @param _to address The address which you want to transfer to
152      * @param _value uint256 the amount of tokens to be transferred
153      */
154     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
155         require(_to != address(0) && _to != address(this));
156 
157         uint256 _allowance = allowed[_from][msg.sender];
158 
159         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
160         // require (_value <= _allowance);
161 
162         balances[_from] = balances[_from].sub(_value);
163         balances[_to] = balances[_to].add(_value);
164         allowed[_from][msg.sender] = _allowance.sub(_value);
165         emit Transfer(_from, _to, _value);
166         return true;
167     }
168 
169    /**
170     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171     *
172     * Beware that changing an allowance with this method brings the risk that someone may use both the old
173     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176     * @param _spender The address which will spend the funds.
177     * @param _value The amount of tokens to be spent.
178     */
179     function approve(address _spender, uint256 _value) public returns (bool) {
180         allowed[msg.sender][_spender] = _value;
181         emit Approval(msg.sender, _spender, _value);
182         return true;
183     }
184 
185     /**
186      * @dev Function to check the amount of tokens that an owner allowed to a spender.
187      * @param _owner address The address which owns the funds.
188      * @param _spender address The address which will spend the funds.
189      * @return A uint256 specifying the amount of tokens still available for the spender.
190      */
191     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
192         return allowed[_owner][_spender];
193     }
194 
195     /**
196      * approve should be called when allowed[_spender] == 0. To increment
197      * allowed value is better to use this function to avoid 2 calls (and wait until
198      * the first transaction is mined)
199      * From MonolithDAO Token.sol
200      */
201     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
202         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
203         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204         return true;
205     }
206 
207     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
208         uint oldValue = allowed[msg.sender][_spender];
209         if (_subtractedValue > oldValue) {
210             allowed[msg.sender][_spender] = 0;
211         } else {
212             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213         }
214         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217 }
218 
219 
220 /**
221  * @title Burnable Token
222  * @dev Token that can be irreversibly burned (destroyed).
223  */
224  
225 contract BurnableToken is StandardToken {
226 
227     event Burn(address indexed burner, uint256 value);
228 
229     /**
230      * @dev Burns a specific amount of tokens.
231      * @param _value The amount of token to be burned.
232      */
233     function burn(uint256 _value) public {
234         require(_value > 0);
235         require(_value <= balances[msg.sender]);
236         // no need to require value <= totalSupply, since that would imply the
237         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
238 
239         address burner = msg.sender;
240         balances[burner] = balances[burner].sub(_value);
241         totalSupply = totalSupply.sub(_value);
242         emit Burn(burner, _value);
243         emit Transfer(burner, address(0), _value);
244     }
245 }
246 
247 interface tokenRecipient { 
248     function receiveApproval(address _from, uint256 _value, bytes calldata _extraData) external;
249 }
250 
251 contract Tatcoin is BurnableToken, Ownable {
252 
253     string public constant name = "Tatcoin";
254     string public constant symbol = "TAT";
255     uint public constant decimals = 18;
256     // there is no problem in using * here instead of .mul()
257     uint256 public constant initialSupply = 200000000 * (10 ** uint256(decimals));
258 
259     // Constructors
260     constructor () public {
261         totalSupply = initialSupply;
262         balances[msg.sender] = initialSupply; // Send all tokens to owner
263         emit Transfer(address(0), msg.sender, initialSupply);
264     }
265     
266     function approveAndCall(address _spender, uint256 _value, bytes calldata _extraData)
267         external
268         returns (bool success) 
269     {
270         tokenRecipient spender = tokenRecipient(_spender);
271         if (approve(_spender, _value)) {
272             spender.receiveApproval(msg.sender, _value, _extraData);
273             return true;
274         }
275     }
276     
277     function transferAnyERC20Token(address _tokenAddress, address _to, uint _amount) public onlyOwner {
278         ERC20(_tokenAddress).transfer(_to, _amount);
279     }
280 }