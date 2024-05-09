1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-14
3 */
4 
5 pragma solidity ^0.5.2;
6 /* version:0.5.7+commit.6da8b019.Emscripten.clang */
7 
8 library SafeMath {
9     /**
10      * @dev Multiplies two unsigned integers, reverts on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27      * 
28      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two unsigned integers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 
70 
71 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
72 
73 contract TokenERC20 {
74     // Public variables of the token
75     string public name;
76     string public symbol;
77     uint8 public decimals=18;
78     // 18 decimals is the strongly suggested default, avoid changing it
79     uint256 public totalSupply;
80 
81     // This creates an array with all balances
82     mapping (address => uint256) public balanceOf;
83     mapping (address => mapping (address => uint256)) public allowance;
84 
85     // This generates a public event on the blockchain that will notify clients
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     // This notifies clients about the amount burnt
89     event Burn(address indexed from, uint256 value);
90 
91     /**
92      * Constructor function
93      *
94      * Initializes contract with initial supply tokens to the creator of the contract
95      */
96     constructor() public
97     {
98         uint256 initialSupply =2000000000;  // (09.10.04)
99         string memory tokenName ="PRINCIPAL PROTECTED COIN";     //  
100         string memory tokenSymbol="PPC";    //  
101    
102         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
103         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
104         name = tokenName;                                   // Set the name for display purposes
105         symbol = tokenSymbol;                               // Set the symbol for display purposes
106     }
107 
108     /**
109      * Internal transfer, only can be called by this contract
110      */
111     function _transfer(address _from, address _to, uint _value) internal {
112         // Prevent transfer to 0x0 address. Use burn() instead
113         require(_to != address(0));
114         // Check if the sender has enough
115         require(balanceOf[_from] >= _value);
116         // Check for overflows
117         require(balanceOf[_to] + _value >= balanceOf[_to]);
118         // Save this for an assertion in the future
119         uint previousBalances = balanceOf[_from] + balanceOf[_to];
120         // Subtract from the sender
121         balanceOf[_from] -= _value;
122         // Add the same to the recipient
123         balanceOf[_to] += _value;
124         emit Transfer(_from, _to, _value);
125         // Asserts are used to use static analysis to find bugs in your code. They should never fail
126         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
127     }
128 
129     /**
130      * Transfer tokens
131      *
132      * Send `_value` tokens to `_to` from your account
133      *
134      * @param _to The address of the recipient
135      * @param _value the amount to send
136      */
137     function transfer(address _to, uint256 _value) public {
138         _transfer(msg.sender, _to, _value);
139     }
140 
141     /**
142      * Transfer tokens from other address
143      *
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
159      *
160      * Allows `_spender` to spend no more than `_value` tokens on your behalf
161      *
162      * @param _spender The address authorized to spend
163      * @param _value the max amount they can spend
164      */
165     function approve(address _spender, uint256 _value) public
166         returns (bool success) {
167         allowance[msg.sender][_spender] = _value;
168         return true;
169     }
170 
171     /**
172      * Set allowance for other address and notify
173      *
174      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
175      *
176      * @param _spender The address authorized to spend
177      * @param _value the max amount they can spend
178      * @param _extraData some extra information to send to the approved contract
179      */
180     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
181         public
182         returns (bool success) {
183         tokenRecipient spender = tokenRecipient(_spender);
184         if (approve(_spender, _value)) {
185             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
186             return true;
187         }
188     }
189 
190     /**
191      * Destroy tokens
192      *
193      * Remove `_value` tokens from the system irreversibly
194      *
195      * @param _value the amount of money to burn
196      */
197     function burn(uint256 _value) public returns (bool success) {
198         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
199         balanceOf[msg.sender] -= _value;            // Subtract from the sender
200         totalSupply -= _value;                      // Updates totalSupply
201         emit Burn(msg.sender, _value);
202         return true;
203     }
204 
205     /**
206      * Destroy tokens from other account
207      *
208      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
209      *
210      * @param _from the address of the sender
211      * @param _value the amount of money to burn
212      */
213     function burnFrom(address _from, uint256 _value) public returns (bool success) {
214         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
215         require(_value <= allowance[_from][msg.sender]);    // Check allowance
216         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
217         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
218         totalSupply -= _value;                              // Update totalSupply
219         emit Burn(_from, _value);
220         return true;
221     }
222 }