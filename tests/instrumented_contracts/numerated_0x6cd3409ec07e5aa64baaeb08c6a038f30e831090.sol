1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43 
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48     /**
49      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50      * account.
51      */
52     function Ownable() public {
53         owner = msg.sender;
54     }
55 
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64 
65 
66     /**
67      * @dev Allows the current owner to transfer control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function transferOwnership(address newOwner) public onlyOwner {
71         require(newOwner != address(0));
72         OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74     }
75 
76 }
77 
78 /**
79  * @title Destructible
80  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
81  */
82 contract Destructible is Ownable {
83 
84   function Destructible() public payable { }
85 
86   /**
87    * @dev Transfers the current balance to the owner and terminates the contract.
88    */
89   function destroy() onlyOwner public {
90     selfdestruct(owner);
91   }
92 
93   function destroyAndSend(address _recipient) onlyOwner public {
94     selfdestruct(_recipient);
95   }
96 }
97 
98 /**
99  * @title ERC20Basic
100  * @dev Simpler version of ERC20 interface
101  * @dev see https://github.com/ethereum/EIPs/issues/179
102  */
103 contract ERC20Basic {
104     uint256 public totalSupply;
105     function balanceOf(address who) public view returns (uint256);
106     function transfer(address to, uint256 value) public returns (bool);
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 }
109 
110 
111 
112 /**
113  * @title ERC20 interface
114  * @dev see https://github.com/ethereum/EIPs/issues/20
115  */
116 contract ERC20 is ERC20Basic {
117     function allowance(address owner, address spender) public view returns (uint256);
118     function transferFrom(address from, address to, uint256 value) public returns (bool);
119     function approve(address spender, uint256 value) public returns (bool);
120     event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 
124 
125 /**
126  * @title Basic token
127  * @dev Basic version of StandardToken, with no allowances.
128  */
129 contract BasicToken is ERC20Basic {
130     using SafeMath for uint256;
131 
132     mapping(address => uint256) public balances;
133 
134     /**
135     * @dev transfer token for a specified address
136     * @param _to The address to transfer to.
137     * @param _value The amount to be transferred.
138     */
139     function transfer(address _to, uint256 _value) public returns (bool) {
140         require(_to != address(0));
141         require(_value <= balances[msg.sender]);
142 
143         // SafeMath.sub will throw if there is not enough balance.
144         balances[msg.sender] = balances[msg.sender].sub(_value);
145         balances[_to] = balances[_to].add(_value);
146         Transfer(msg.sender, _to, _value);
147         return true;
148     }
149 
150     /**
151     * @dev Gets the balance of the specified address.
152     * @param _owner The address to query the the balance of.
153     * @return An uint256 representing the amount owned by the passed address.
154     */
155     function balanceOf(address _owner) public view returns (uint256 balance) {
156         return balances[_owner];
157     }
158 
159 }
160 
161 
162 
163 /**
164  * @title Standard ERC20 token
165  *
166  * @dev Implementation of the basic standard token.
167  * @dev https://github.com/ethereum/EIPs/issues/20
168  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
169  */
170 contract StandardToken is ERC20, BasicToken {
171 
172     mapping (address => mapping (address => uint256)) internal allowed;
173 
174 
175     /**
176      * @dev Transfer tokens from one address to another
177      * @param _from address The address which you want to send tokens from
178      * @param _to address The address which you want to transfer to
179      * @param _value uint256 the amount of tokens to be transferred
180      */
181     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
182         require(_to != address(0));
183         require(_value <= balances[_from]);
184         require(_value <= allowed[_from][msg.sender]);
185 
186         balances[_from] = balances[_from].sub(_value);
187         balances[_to] = balances[_to].add(_value);
188         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189         Transfer(_from, _to, _value);
190         return true;
191     }
192 
193     /**
194      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195      *
196      * Beware that changing an allowance with this method brings the risk that someone may use both the old
197      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
198      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
199      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200      * @param _spender The address which will spend the funds.
201      * @param _value The amount of tokens to be spent.
202      */
203     function approve(address _spender, uint256 _value) public returns (bool) {
204         allowed[msg.sender][_spender] = _value;
205         Approval(msg.sender, _spender, _value);
206         return true;
207     }
208 
209     /**
210      * @dev Function to check the amount of tokens that an owner allowed to a spender.
211      * @param _owner address The address which owns the funds.
212      * @param _spender address The address which will spend the funds.
213      * @return A uint256 specifying the amount of tokens still available for the spender.
214      */
215     function allowance(address _owner, address _spender) public view returns (uint256) {
216         return allowed[_owner][_spender];
217     }
218 
219     /**
220      * approve should be called when allowed[_spender] == 0. To increment
221      * allowed value is better to use this function to avoid 2 calls (and wait until
222      * the first transaction is mined)
223      * From MonolithDAO Token.sol
224      */
225     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
226         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
227         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228         return true;
229     }
230 
231     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
232         uint oldValue = allowed[msg.sender][_spender];
233         if (_subtractedValue > oldValue) {
234             allowed[msg.sender][_spender] = 0;
235         } else {
236             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237         }
238         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239         return true;
240     }
241 
242 }
243 
244 
245 /**
246  * @title KryptoroToken
247  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
248  * Note they can later distribute these tokens as they wish using `transfer` and other
249  * `StandardToken` functions.
250  */
251 contract KryptoroToken is StandardToken, Destructible {
252 
253     string public constant name = "KRYPTORO Coin";
254     string public constant symbol = "KTO";
255     uint8 public constant decimals = 18;
256 
257     uint256 public constant INITIAL_SUPPLY = 100 * 1000000 * (10 ** uint256(decimals));
258 
259     /**
260     * @dev Constructor that gives msg.sender all of existing tokens.
261     */
262     function KryptoroToken() public {
263         totalSupply = INITIAL_SUPPLY;
264         balances[msg.sender] = INITIAL_SUPPLY;
265     }
266 }