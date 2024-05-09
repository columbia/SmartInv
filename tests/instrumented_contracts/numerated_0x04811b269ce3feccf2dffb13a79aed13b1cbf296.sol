1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30 
31     //Variables
32     address public owner;
33 
34     address public newOwner;
35 
36     //    Modifiers
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     /**
46      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47      * account.
48      */
49     function Ownable() public {
50         owner = msg.sender;
51     }
52 
53     /**
54      * @dev Allows the current owner to transfer control of the contract to a newOwner.
55      * @param _newOwner The address to transfer ownership to.
56      */
57 
58     function transferOwnership(address _newOwner) public onlyOwner {
59         require(_newOwner != address(0));
60         newOwner = _newOwner;
61     }
62 
63     function acceptOwnership() public {
64         if (msg.sender == newOwner) {
65             owner = newOwner;
66         }
67     }
68 }
69 
70 contract ERC20Basic {
71   uint256 public totalSupply;
72   function balanceOf(address who) public constant returns (uint256);
73   function transfer(address to, uint256 value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 contract ERC20 is ERC20Basic {
78   function allowance(address owner, address spender) public constant returns (uint256);
79   function transferFrom(address from, address to, uint256 value) public returns (bool);
80   function approve(address spender, uint256 value) public returns (bool);
81   event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89     using SafeMath for uint256;
90 
91     mapping(address => uint256) balances;
92 
93     /**
94     * @dev transfer token for a specified address
95     * @param _to The address to transfer to.
96     * @param _value The amount to be transferred.
97     */
98     function transfer(address _to, uint256 _value) public returns (bool) {
99         require(_to != address(0));
100         require(_value <= balances[msg.sender]);
101 
102         // SafeMath.sub will throw if there is not enough balance.
103         balances[msg.sender] = balances[msg.sender].sub(_value);
104         balances[_to] = balances[_to].add(_value);
105         Transfer(msg.sender, _to, _value);
106         return true;
107     }
108 
109     /**
110     * @dev Gets the balance of the specified address.
111     * @param _owner The address to query the the balance of.
112     * @return An uint256 representing the amount owned by the passed address.
113     */
114     function balanceOf(address _owner) public constant returns (uint256 balance) {
115         return balances[_owner];
116     }
117 
118 }
119 
120 contract StandardToken is ERC20, BasicToken {
121 
122   mapping (address => mapping (address => uint256)) internal allowed;
123 
124 
125   /**
126    * @dev Transfer tokens from one address to another
127    * @param _from address The address which you want to send tokens from
128    * @param _to address The address which you want to transfer to
129    * @param _value uint256 the amount of tokens to be transferred
130    */
131   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
132     require(_to != address(0));
133     require(_value <= balances[_from]);
134     require(_value <= allowed[_from][msg.sender]);
135 
136     balances[_from] = balances[_from].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
139     Transfer(_from, _to, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
145    *
146    * Beware that changing an allowance with this method brings the risk that someone may use both the old
147    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
148    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
149    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint256 _value) public returns (bool) {
154     allowed[msg.sender][_spender] = _value;
155     Approval(msg.sender, _spender, _value);
156     return true;
157   }
158 
159   /**
160    * @dev Function to check the amount of tokens that an owner allowed to a spender.
161    * @param _owner address The address which owns the funds.
162    * @param _spender address The address which will spend the funds.
163    * @return A uint256 specifying the amount of tokens still available for the spender.
164    */
165   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
166     return allowed[_owner][_spender];
167   }
168 
169   /**
170    * approve should be called when allowed[_spender] == 0. To increment
171    * allowed value is better to use this function to avoid 2 calls (and wait until
172    * the first transaction is mined)
173    * From MonolithDAO Token.sol
174    */
175   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
176     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
177     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178     return true;
179   }
180 
181   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
182     uint oldValue = allowed[msg.sender][_spender];
183     if (_subtractedValue > oldValue) {
184       allowed[msg.sender][_spender] = 0;
185     } else {
186       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
187     }
188     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192 }
193 
194 
195 contract MintableToken is StandardToken, Ownable {
196   event Mint(address indexed to, uint256 amount);
197   event MintFinished();
198 
199   bool public mintingFinished = false;
200 
201   modifier canMint() {
202     require(!mintingFinished);
203     _;
204   }
205 
206   /**
207    * @dev Function to mint tokens
208    * @param _to The address that will receive the minted tokens.
209    * @param _amount The amount of tokens to mint.
210    * @return A boolean that indicates if the operation was successful.
211    */
212   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
213     totalSupply = totalSupply.add(_amount);
214     balances[_to] = balances[_to].add(_amount);
215     Mint(_to, _amount);
216     Transfer(0x0, _to, _amount);
217     return true;
218   }
219 
220   /**
221    * @dev Function to stop minting new tokens.
222    * @return True if the operation was successful.
223    */
224   function finishMinting() onlyOwner public returns (bool) {
225     mintingFinished = true;
226     MintFinished();
227     return true;
228   }
229 }
230 
231 
232 contract LamdenTau is MintableToken {
233     string public constant name = "Lamden Tau";
234     string public constant symbol = "TAU";
235     uint8 public constant decimals = 18;
236 
237     // locks transfers until minting is over, which ends at the end of the sale
238     // thus, the behavior of this token is locked transfers during sale, and unlocked after :)
239     function transfer(address _to, uint256 _value) public returns (bool) {
240       require(mintingFinished);
241       bool success = super.transfer(_to, _value);
242       return success;
243     }
244 
245     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
246       require(mintingFinished);
247       bool success = super.transferFrom(_from, _to, _value);
248       return success;
249     }
250 }