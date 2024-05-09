1 pragma solidity ^0.4.24;
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
36 interface IERC20 {
37     
38     function totalSupply() external view returns (uint256);
39     function balanceOf(address account) external view returns (uint256);
40     function transfer(address recipient, uint256 amount) external returns (bool);
41     function allowance(address owner, address spender) external view returns (uint256);
42     function approve(address spender, uint256 amount) external returns (bool);
43     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
44     
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 contract owned {
50     address public owner;
51 
52     constructor() public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address newOwner) onlyOwner public {
62         owner = newOwner;
63     }
64 }
65 
66 contract ERC20CompatibleToken is owned, IERC20 {
67     using SafeMath for uint;
68     
69     // Public variables of the token
70     string public name;
71     string public symbol;
72     uint8 public decimals = 18;
73     uint256 public totalSupply;
74     
75     mapping(address => uint) balances; // List of user balances.
76     
77     event Transfer(address indexed from, address indexed to, uint value);
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79     mapping (address => mapping (address => uint256)) internal allowed;
80     mapping (address => bool) public frozenAccount;
81     
82     /**
83     * Constrctor function
84     *
85     * Initializes contract with initial supply tokens to the creator of the contract
86     */
87     constructor(
88       uint256 initialSupply,
89       string memory tokenName,
90       string memory tokenSymbol, 
91       address owner
92     ) public {
93         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
94         balances[owner] = totalSupply;                    // Give the creator all initial tokens
95         name = tokenName;                                       // Set the name for display purposes
96         symbol = tokenSymbol;                                   // Set the symbol for display purposes
97     }
98   
99     function totalSupply() public view returns (uint256) {
100             return totalSupply;
101         }
102       
103     /**
104      * @dev Returns balance of the `_owner`.
105      *
106      * @param _owner   The address whose balance will be returned.
107      * @return balance Balance of the `_owner`.
108      */
109     function balanceOf(address _owner) public constant returns (uint balance) {
110         return balances[_owner];
111     }
112     
113     
114     /**
115      * @dev Transfer the specified amount of tokens to the specified address.
116      *
117      * @param _to    Receiver address.
118      * @param _value Amount of tokens that will be transferred.
119      */
120     function transfer(address _to, uint _value) public {
121         require(!frozenAccount[msg.sender]);                    // Check if sender is frozen
122         require(!frozenAccount[_to]);                           // Check if recipient is frozen
123 
124         balances[msg.sender] = balances[msg.sender].sub(_value);
125         balances[_to] = balances[_to].add(_value);
126         
127         emit Transfer(msg.sender, _to, _value);
128         return ;
129     }
130 
131 
132    
133   
134   
135     /**
136     * @dev Function to check the amount of tokens that an owner allowed to a spender.
137     * @param _owner address The address which owns the funds.
138     * @param _spender address The address which will spend the funds.
139     * @return A uint256 specifying the amount of tokens still available for the spender.
140     */
141     function allowance(address _owner, address _spender) public view returns (uint256) {
142         return allowed[_owner][_spender];
143     }
144 
145     /**
146     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147     *
148     * @param _spender The address which will spend the funds.
149     * @param _value The amount of tokens to be spent.
150     */
151     function approve(address _spender, uint256 _value) public returns (bool) {
152         allowed[msg.sender][_spender] = _value;
153         emit Approval(msg.sender, _spender, _value);
154         return true;
155     }
156 
157     /**
158     * @dev Transfer tokens from one address to another
159     * @param _from address The address which you want to send tokens from
160     * @param _to address The address which you want to transfer to
161     * @param _value uint256 the amount of tokens to be transferred
162     */
163     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
164         
165         require(_value <= balances[_from]);
166         require(_value <= allowed[_from][msg.sender]);
167     
168         require(!frozenAccount[_from]);                         // Check if sender is frozen
169         require(!frozenAccount[_to]);                           // Check if recipient is frozen
170         
171         balances[_from] = balances[_from].sub(_value);
172         balances[_to] = balances[_to].add(_value);
173         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174         
175         emit Transfer(_from, _to, _value);
176         return true;
177     }
178 
179     /**
180     * approve should be called when allowed[_spender] == 0. To increment
181     * allowed value is better to use this function to avoid 2 calls (and wait until
182     * the first transaction is mined)
183     * From MonolithDAO Token.sol
184     */
185     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
186         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
187         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188         return true;
189     }
190     
191     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
192         uint oldValue = allowed[msg.sender][_spender];
193         if (_subtractedValue > oldValue) {
194             allowed[msg.sender][_spender] = 0;
195         } else {
196             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
197         }
198         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199         return true;
200     }
201     
202     /* This generates a public event on the blockchain that will notify clients */
203     event FrozenFunds(address target, bool frozen);
204     
205     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
206     /// @param target Address to be frozen
207     /// @param freeze either to freeze it or not
208     function freezeAccount(address target, bool freeze) onlyOwner public {
209         frozenAccount[target] = freeze;
210         emit FrozenFunds(target, freeze);
211     }
212 
213 }
214 
215 
216 /**
217  * @title Mango Coin Main Contract
218  * @dev Reference implementation of the ERC223 standard token.
219  */
220 contract MangoCoin is owned,  ERC20CompatibleToken {
221     using SafeMath for uint;
222 
223     mapping (address => bool) public frozenAccount;
224 
225     /* Initializes contract with initial supply tokens to the creator of the contract */
226     constructor(
227         uint256 initialSupply,
228         string memory tokenName,
229         string memory tokenSymbol, 
230         address owner
231     ) ERC20CompatibleToken(initialSupply, tokenName, tokenSymbol, owner) public {}
232 
233 
234 
235     
236     /* This generates a public event on the blockchain that will notify clients */
237     event FrozenFunds(address target, bool frozen);
238 
239     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
240     /// @param target Address to be frozen
241     /// @param freeze either to freeze it or not
242     function freezeAccount(address target, bool freeze) onlyOwner public {
243         frozenAccount[target] = freeze;
244         emit FrozenFunds(target, freeze);
245         return ;
246     }
247 
248 }