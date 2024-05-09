1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function add(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a + b;
10         assert(c >= a);
11         return c;
12     }  
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20   
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a * b;
23         assert(a == 0 || c / a == b);
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 }
32 
33 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
34 
35 contract BCE {
36     
37     using SafeMath for uint256;
38     
39     // Public variables of the token
40     address public owner;
41     string public name;
42     string public symbol;
43     uint8 public decimals = 18;
44     uint256 public totalSupply;
45     uint256 public supplyLeftAtOrigin = 21000000 * 10 ** uint256(decimals);
46 
47     // This creates an array with all balances
48     mapping (address => uint256) public balanceOf;
49     mapping (address => mapping (address => uint256)) public allowance;
50 
51     // This generates a public event on the blockchain that will notify clients
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 
54     // This notifies clients about the amount burnt
55     event Burn(address indexed from, uint256 value);
56     
57     // 1 ether = 500 bitcoin ethers
58     uint256 public constant RATE = 500; 
59 
60     /**
61      * Constructor function
62      *
63      * Initializes contract with initial supply tokens to the creator of the contract
64      */
65     function BCE(
66         address sendTo,
67         uint256 initialSupply,
68         string tokenName,
69         string tokenSymbol
70     ) public {
71         owner = sendTo;
72         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
73         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
74         name = tokenName;                                   // Set the name for display purposes
75         symbol = tokenSymbol;                               // Set the symbol for display purposes
76     }
77     
78     function () public payable {
79         createTokens();
80     } 
81     
82 	function createTokens() public payable {
83 	    require(supplyLeftAtOrigin > 1000000 * 10 ** uint256(decimals)); // Security reserve = 1 Mil. Max BCE in circulation = 21 mil.
84         require(msg.value > 0);
85         uint256 tokens = msg.value.mul(RATE);
86         balanceOf[msg.sender] = balanceOf[msg.sender].add(tokens);
87         supplyLeftAtOrigin = supplyLeftAtOrigin.sub(tokens);
88         owner.transfer(msg.value);
89     } 
90     
91     function balanceOf(address _owner) public constant returns (uint256 balance){
92         return balanceOf[_owner];
93     }
94 
95     /**
96      * Internal transfer, only can be called by this contract
97      */
98     function _transfer(address _from, address _to, uint _value) internal {
99         // Prevent transfer to 0x0 address. Use burn() instead
100         require(_to != 0x0);
101         // Check if the sender has enough
102         require(balanceOf[_from] >= _value);
103         // Check for overflows
104         require(balanceOf[_to] + _value > balanceOf[_to]);
105         // Save this for an assertion in the future
106         uint previousBalances = balanceOf[_from] + balanceOf[_to];
107         // Subtract from the sender
108         balanceOf[_from] -= _value;
109         // Add the same to the recipient
110         balanceOf[_to] += _value;
111         Transfer(_from, _to, _value);
112         // Asserts are used to use static analysis to find bugs in your code. They should never fail
113         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
114     }
115 
116     /**
117      * Transfer tokens
118      *
119      * Send `_value` tokens to `_to` from your account
120      *
121      * @param _to The address of the recipient
122      * @param _value the amount to send
123      */
124     function transfer(address _to, uint256 _value) public {
125         _transfer(msg.sender, _to, _value);
126     }
127 
128     /**
129      * Transfer tokens from other address
130      *
131      * Send `_value` tokens to `_to` in behalf of `_from`
132      *
133      * @param _from The address of the sender
134      * @param _to The address of the recipient
135      * @param _value the amount to send
136      */
137     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
138         require(_value <= allowance[_from][msg.sender]);     // Check allowance
139         allowance[_from][msg.sender] -= _value;
140         _transfer(_from, _to, _value);
141         return true;
142     }
143 
144     /**
145      * Set allowance for other address
146      *
147      * Allows `_spender` to spend no more than `_value` tokens in your behalf
148      *
149      * @param _spender The address authorized to spend
150      * @param _value the max amount they can spend
151      */
152     function approve(address _spender, uint256 _value) public
153         returns (bool success) {
154         allowance[msg.sender][_spender] = _value;
155         return true;
156     }
157 
158     /**
159      * Set allowance for other address and notify
160      *
161      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
162      *
163      * @param _spender The address authorized to spend
164      * @param _value the max amount they can spend
165      * @param _extraData some extra information to send to the approved contract
166      */
167     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
168         public
169         returns (bool success) {
170         tokenRecipient spender = tokenRecipient(_spender);
171         if (approve(_spender, _value)) {
172             spender.receiveApproval(msg.sender, _value, this, _extraData);
173             return true;
174         }
175     }
176 
177     /**
178      * Destroy tokens
179      *
180      * Remove `_value` tokens from the system irreversibly
181      *
182      * @param _value the amount of money to burn
183      */
184     function burn(uint256 _value) public returns (bool success) {
185         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
186         balanceOf[msg.sender] -= _value;            // Subtract from the sender
187         totalSupply -= _value;                      // Updates totalSupply
188         Burn(msg.sender, _value);
189         return true;
190     }
191 
192     /**
193      * Destroy tokens from other account
194      *
195      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
196      *
197      * @param _from the address of the sender
198      * @param _value the amount of money to burn
199      */
200     function burnFrom(address _from, uint256 _value) public returns (bool success) {
201         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
202         require(_value <= allowance[_from][msg.sender]);    // Check allowance
203         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
204         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
205         totalSupply -= _value;                              // Update totalSupply
206         Burn(_from, _value);
207         return true;
208     }
209 }