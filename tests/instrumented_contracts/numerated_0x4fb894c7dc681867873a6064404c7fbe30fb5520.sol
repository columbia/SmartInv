1 pragma solidity ^0.4.15;
2 
3 contract Ownable {
4 
5     //Variables
6     address public owner;
7 
8     address public newOwner;
9 
10     //    Modifiers
11     /**
12      * @dev Throws if called by any account other than the owner.
13      */
14     modifier onlyOwner() {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     /**
20      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21      * account.
22      */
23     function Ownable() public {
24         owner = msg.sender;
25     }
26 
27     /**
28      * @dev Allows the current owner to transfer control of the contract to a newOwner.
29      * @param _newOwner The address to transfer ownership to.
30      */
31 
32     function transferOwnership(address _newOwner) public onlyOwner {
33         require(_newOwner != address(0));
34         newOwner = _newOwner;
35     }
36 
37     function acceptOwnership() public {
38         if (msg.sender == newOwner) {
39             owner = newOwner;
40         }
41     }
42 }
43 
44 library SafeMath {
45   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a * b;
47     assert(a == 0 || c / a == b);
48     return c;
49   }
50 
51   function div(uint256 a, uint256 b) internal constant returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return c;
56   }
57 
58   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function add(uint256 a, uint256 b) internal constant returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
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
84 
85 /**
86  * @title Basic token
87  * @dev Basic version of StandardToken, with no allowances.
88  */
89 contract BasicToken is ERC20Basic {
90     using SafeMath for uint256;
91 
92     mapping(address => uint256) balances;
93 
94     /**
95     * @dev transfer token for a specified address
96     * @param _to The address to transfer to.
97     * @param _value The amount to be transferred.
98     */
99     function transfer(address _to, uint256 _value) public returns (bool) {
100         require(_to != address(0));
101         require(_value <= balances[msg.sender]);
102 
103         // SafeMath.sub will throw if there is not enough balance.
104         balances[msg.sender] = balances[msg.sender].sub(_value);
105         balances[_to] = balances[_to].add(_value);
106         Transfer(msg.sender, _to, _value);
107         return true;
108     }
109 
110     /**
111     * @dev Gets the balance of the specified address.
112     * @param _owner The address to query the the balance of.
113     * @return An uint256 representing the amount owned by the passed address.
114     */
115     function balanceOf(address _owner) public constant returns (uint256 balance) {
116         return balances[_owner];
117     }
118 
119 }
120 
121 contract StandardToken is ERC20, BasicToken {
122 
123   mapping (address => mapping (address => uint256)) internal allowed;
124 
125 
126   /**
127    * @dev Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amount of tokens to be transferred
131    */
132   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[_from]);
135     require(_value <= allowed[_from][msg.sender]);
136 
137     balances[_from] = balances[_from].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140     Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
146    *
147    * Beware that changing an allowance with this method brings the risk that someone may use both the old
148    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint256 _value) public returns (bool) {
155     allowed[msg.sender][_spender] = _value;
156     Approval(msg.sender, _spender, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Function to check the amount of tokens that an owner allowed to a spender.
162    * @param _owner address The address which owns the funds.
163    * @param _spender address The address which will spend the funds.
164    * @return A uint256 specifying the amount of tokens still available for the spender.
165    */
166   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
167     return allowed[_owner][_spender];
168   }
169 
170   /**
171    * approve should be called when allowed[_spender] == 0. To increment
172    * allowed value is better to use this function to avoid 2 calls (and wait until
173    * the first transaction is mined)
174    * From MonolithDAO Token.sol
175    */
176   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
177     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
178     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179     return true;
180   }
181 
182   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
183     uint oldValue = allowed[msg.sender][_spender];
184     if (_subtractedValue > oldValue) {
185       allowed[msg.sender][_spender] = 0;
186     } else {
187       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
188     }
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193 }
194 
195 
196 contract MintableToken is StandardToken, Ownable {
197   event Mint(address indexed to, uint256 amount);
198   event MintFinished();
199 
200   bool public mintingFinished = false;
201 
202   modifier canMint() {
203     require(!mintingFinished);
204     _;
205   }
206 
207   /**
208    * @dev Function to mint tokens
209    * @param _to The address that will receive the minted tokens.
210    * @param _amount The amount of tokens to mint.
211    * @return A boolean that indicates if the operation was successful.
212    */
213   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
214     totalSupply = totalSupply.add(_amount);
215     balances[_to] = balances[_to].add(_amount);
216     Mint(_to, _amount);
217     Transfer(0x0, _to, _amount);
218     return true;
219   }
220 
221   /**
222    * @dev Function to stop minting new tokens.
223    * @return True if the operation was successful.
224    */
225   function finishMinting() onlyOwner public returns (bool) {
226     mintingFinished = true;
227     MintFinished();
228     return true;
229   }
230 }
231 
232 
233 contract Shitcoin is MintableToken {
234     string public constant name = "Shitcoin";
235     string public constant symbol = "SHIT";
236     uint8 public constant decimals = 18;
237 }