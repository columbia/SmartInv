1 pragma solidity ^0.5.10;
2 
3 library SafeMath {
4     /**
5      * @dev Multiplies two numbers, throws on overflow.
6      */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15     /**
16      * @dev Integer division of two numbers, truncating the quotient.
17      */
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a / b;
20         return c;
21     }
22     /**
23      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
24      */
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29     /**
30      * @dev Adds two numbers, throws on overflow.
31      */
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 }
38 
39 contract Ownable {
40     address public owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43     event OwnershipRenounced(address indexed previousOwner);
44 
45     constructor() public {
46         owner = msg.sender;
47     }
48 
49     modifier onlyOwner() {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     /**
55      * @dev Allows the current owner to transfer control of the contract to a newOwner.
56      * @param newOwner The address to transfer ownership to.
57      */
58     function transferOwnerShip(address newOwner) public onlyOwner {
59         require(newOwner != address(0));
60         emit OwnershipTransferred(owner, newOwner);
61         owner = newOwner;
62     }
63 
64     /**
65      * @dev Allows the current owner to relinquish control of the contract.
66      */
67     function renounceOwnerShip() public onlyOwner {
68         emit OwnershipRenounced(owner);
69         owner = address(0);
70     }
71 }
72 
73 interface tokenRecipient {
74     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
75 }
76 
77 contract TokenERC20 is Ownable {
78     using SafeMath for uint256;
79 
80     string public name;
81     string public symbol;
82     uint8 public decimals = 18;
83     uint256 public totalSupply;
84 
85     // This creates an array with all balances
86     mapping (address => uint256) public balanceOf;
87     mapping (address => mapping (address => uint256)) public allowance;
88 
89     // This generates a public event on the blockchain that will notify clients
90     event Transfer(address indexed _from, address indexed _to, uint256 _value);
91     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
92     // This notifies clients about the amount burnt
93     event Burn(address indexed from, uint256 value);
94 
95     /**
96      * Constructor function
97      * Initializes contract with initial supply tokens to the creator of the contract
98      */
99     constructor (uint256 _initialSupply, string memory _tokenName, string memory _tokenSymbol) public {
100         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
101         balanceOf[msg.sender] = totalSupply;                	 // Give the creator all initial tokens
102         name = _tokenName;                                   	 // Set the name for display purposes
103         symbol = _tokenSymbol;                               	 // Set the symbol for display purposes
104     }
105 
106     /**
107      * Internal transfer, only can be called by this contract
108      *
109      * @param _from The address of the sender
110      * @param _to The address of the recipient
111      * @param _value the amount to send
112      */
113     function _transfer(address _from, address _to, uint _value) internal {
114         // Prevent transfer to 0x0 address
115         require(_to != address(0x0));
116         // Check if the sender has enough
117         require(balanceOf[_from] >= _value);
118         // Check for overflows
119         require(balanceOf[_to] + _value > balanceOf[_to]);
120         // Save this for an assertion in the future
121         uint previousBalances = balanceOf[_from] + balanceOf[_to];
122         // Subtract from the sender
123         balanceOf[_from] -= _value;
124         // Add the same to the recipient
125         balanceOf[_to] += _value;
126         emit Transfer(_from, _to, _value);
127         // Asserts are used to use static analysis to find bugs in your code. They should never fail
128         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
129     }
130 
131     /**
132      * Transfer tokens
133      * Send `_value` tokens to `_to` from your account
134      *
135      * @param _to The address of the recipient
136      * @param _value the amount to send
137      */
138     function transfer(address _to, uint256 _value) public {
139         _transfer(msg.sender, _to, _value);
140     }
141 
142     /**
143      * Transfer tokens from other address
144      * Send `_value` tokens to `_to` on behalf of `_from`
145      *
146      * @param _from The address of the sender
147      * @param _to The address of the recipient
148      * @param _value the amount to send
149      */
150     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
151         require(_value <= allowance[_from][msg.sender]);     // Check allowance
152         allowance[_from][msg.sender] -= _value;
153         _transfer(_from, _to, _value);
154         return true;
155     }
156 
157     /**
158      * Set allowance for other address
159      * Allows `_spender` to spend no more than `_value` tokens on your behalf
160      *
161      * @param _spender The address authorized to spend
162      * @param _value the max amount they can spend
163      */
164     function approve(address _spender, uint256 _value) public returns (bool success) {
165         allowance[msg.sender][_spender] = _value;
166         emit Approval(msg.sender, _spender, _value);
167         return true;
168     }
169 
170     /**
171      * Set allowance for other address and notify
172      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
173      *
174      * @param _spender The address authorized to spend
175      * @param _value the max amount they can spend
176      * @param _extraData some extra information to send to the approved contract
177      */
178     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
179         tokenRecipient spender = tokenRecipient(_spender);
180         if (approve(_spender, _value)) {
181             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
182             return true;
183         }
184     }
185 
186     /**
187      * Destroy tokens
188      * Remove `_value` tokens from the system irreversibly
189      *
190      * @param _value the amount of money to burn
191      */
192     function burn(uint256 _value) public returns (bool success) {
193         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
194         balanceOf[msg.sender] -= _value;            // Subtract from the sender
195         totalSupply -= _value;                      // Updates totalSupply
196         emit Burn(msg.sender, _value);
197         return true;
198     }
199 
200     /**
201      * Destroy tokens from other account
202      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
203      *
204      * @param _from the address of the sender
205      * @param _value the amount of money to burn
206      */
207     function burnFrom(address _from, uint256 _value) public returns (bool success) {
208         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
209         require(_value <= allowance[_from][msg.sender]);    // Check allowance
210         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
211         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
212         totalSupply -= _value;                              // Update totalSupply
213         emit Burn(_from, _value);
214         return true;
215     }
216 }