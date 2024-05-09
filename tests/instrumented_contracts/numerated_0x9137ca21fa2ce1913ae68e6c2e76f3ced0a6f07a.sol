1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /******************************************/
54 /*       ITECToken STARTS HERE       */
55 /******************************************/
56 contract ITECToken {
57 
58     // Public variables of the token(TokenERC20)
59     string public name;
60     string public symbol;
61     uint256 public totalSupply;
62     uint8 public decimals = 18; // 18 decimals is the strongly suggested default, avoid changing it
63 
64     address public owner;
65     
66     using SafeMath for uint; // use the library for uint type
67 
68     /**
69      * Constrctor function
70      *
71      * Initializes contract with initial supply tokens to the creator of the contract
72      */
73     constructor(
74         uint256 initialSupply,
75         string tokenName,
76         string tokenSymbol
77     ) public {
78         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
79         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
80         name = tokenName;                                   // Set the name for display purposes
81         symbol = tokenSymbol;                               // Set the symbol for display purposes
82     
83         owner = msg.sender;
84     }
85     
86     // This creates an array with all balances
87     mapping (address => uint256) public balanceOf;
88     mapping (address => mapping (address => uint256)) public allowance;
89     mapping (address => bool) public frozenAccount;
90 
91     // This generates a public event on the blockchain that will notify clients
92     event Transfer(address indexed from, address indexed to, uint256 value);
93     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
94     event FrozenFunds(address target, bool frozen);
95     
96     // This notifies clients about the amount burnt
97     event Burn(address indexed from, uint256 value);
98     
99     //authorized parts start
100     modifier onlyOwner {
101         require(msg.sender == owner);
102         _;
103     }
104 
105     function transferOwnership(address newOwner) onlyOwner public {
106         owner = newOwner;
107     }
108     //authorized parts end
109     
110     /* Internal transfer, only can be called by this contract */
111     function _transfer(address _from, address _to, uint _value) internal {
112         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
113         require (balanceOf[_from] >= _value);               // Check if the sender has enough
114         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
115         require(!frozenAccount[_from]);                     // Check if sender is frozen
116         require(!frozenAccount[_to]);                       // Check if recipient is frozen
117         
118         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
119         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
120 
121         emit Transfer(_from, _to, _value);
122     }
123 
124     /**
125      * Transfer tokens
126      *
127      * Send `_value` tokens to `_to` from your account
128      *
129      * @param _to The address of the recipient
130      * @param _value the amount to send
131      */
132     function transfer(address _to, uint256 _value) public returns (bool success) {
133         _transfer(msg.sender, _to, _value);
134         return true;
135     }
136 
137     /**
138      * Transfer tokens from other address
139      *
140      * Send `_value` tokens to `_to` in behalf of `_from`
141      *
142      * @param _from The address of the sender
143      * @param _to The address of the recipient
144      * @param _value the amount to send
145      */
146     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
147         require(_value <= allowance[_from][msg.sender]);     // Check allowance
148         
149         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
150 
151         _transfer(_from, _to, _value);
152         return true;
153     }
154 
155     /**
156      * Set allowance for other address
157      *
158      * Allows `_spender` to spend no more than `_value` tokens in your behalf
159      *
160      * @param _spender The address authorized to spend
161      * @param _value the max amount they can spend
162      */
163     function approve(address _spender, uint256 _value) public
164         returns (bool success) {
165         allowance[msg.sender][_spender] = _value;
166         emit Approval(msg.sender, _spender, _value);
167         return true;
168     }
169 
170     /**
171      * Destroy tokens
172      *
173      * Remove `_value` tokens from the system irreversibly
174      *
175      * @param _value the amount of money to burn
176      */
177     function burn(uint256 _value) onlyOwner public returns (bool success) {
178         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
179         
180         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
181         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
182 
183         emit Burn(msg.sender, _value);
184         return true;
185     }
186 
187     /// @notice Create `mintedAmount` tokens and send it to `target`
188     /// @param target Address to receive the tokens
189     /// @param mintedAmount the amount of tokens it will receive
190     function mToken(address target, uint256 mintedAmount) onlyOwner public {
191         
192         balanceOf[target] = balanceOf[target].add(mintedAmount);
193         totalSupply = totalSupply.add(mintedAmount);
194 
195         emit Transfer(0, this, mintedAmount);
196         emit Transfer(this, target, mintedAmount);
197     }
198 
199     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
200     /// @param target Address to be frozen
201     /// @param freeze either to freeze it or not
202     function freezeAccount(address target, bool freeze) onlyOwner public {
203         frozenAccount[target] = freeze;
204         emit FrozenFunds(target, freeze);
205     }
206 }