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
44     // 18 decimals is the strongly suggested default, avoid changing it
45     uint256 public totalSupply;
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
82     /*function BCEToken() public {
83         balanceOf[msg.sender] = totalSupply;
84         owner = msg.sender;
85     } */
86     
87 	function createTokens() public payable {
88 	    require(totalSupply > 0); // Max Bitcoin Ethers in circulation = 21 mil. 
89         require(msg.value > 0);
90         uint256 tokens = msg.value.mul(RATE);
91         balanceOf[msg.sender] = balanceOf[msg.sender].add(tokens);
92         totalSupply = totalSupply.sub(tokens);
93         owner.transfer(msg.value);
94     } 
95     
96     function balanceOf(address _owner) public constant returns (uint256 balance){
97         return balanceOf[_owner];
98     }
99 
100     /**
101      * Internal transfer, only can be called by this contract
102      */
103     function _transfer(address _from, address _to, uint _value) internal {
104         // Prevent transfer to 0x0 address. Use burn() instead
105         require(_to != 0x0);
106         // Check if the sender has enough
107         require(balanceOf[_from] >= _value);
108         // Check for overflows
109         require(balanceOf[_to] + _value > balanceOf[_to]);
110         // Save this for an assertion in the future
111         uint previousBalances = balanceOf[_from] + balanceOf[_to];
112         // Subtract from the sender
113         balanceOf[_from] -= _value;
114         // Add the same to the recipient
115         balanceOf[_to] += _value;
116         Transfer(_from, _to, _value);
117         // Asserts are used to use static analysis to find bugs in your code. They should never fail
118         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
119     }
120 
121     /**
122      * Transfer tokens
123      *
124      * Send `_value` tokens to `_to` from your account
125      *
126      * @param _to The address of the recipient
127      * @param _value the amount to send
128      */
129     function transfer(address _to, uint256 _value) public {
130         _transfer(msg.sender, _to, _value);
131     }
132 
133     /**
134      * Transfer tokens from other address
135      *
136      * Send `_value` tokens to `_to` in behalf of `_from`
137      *
138      * @param _from The address of the sender
139      * @param _to The address of the recipient
140      * @param _value the amount to send
141      */
142     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
143         require(_value <= allowance[_from][msg.sender]);     // Check allowance
144         allowance[_from][msg.sender] -= _value;
145         _transfer(_from, _to, _value);
146         return true;
147     }
148 
149     /**
150      * Set allowance for other address
151      *
152      * Allows `_spender` to spend no more than `_value` tokens in your behalf
153      *
154      * @param _spender The address authorized to spend
155      * @param _value the max amount they can spend
156      */
157     function approve(address _spender, uint256 _value) public
158         returns (bool success) {
159         allowance[msg.sender][_spender] = _value;
160         return true;
161     }
162 
163     /**
164      * Set allowance for other address and notify
165      *
166      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
167      *
168      * @param _spender The address authorized to spend
169      * @param _value the max amount they can spend
170      * @param _extraData some extra information to send to the approved contract
171      */
172     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
173         public
174         returns (bool success) {
175         tokenRecipient spender = tokenRecipient(_spender);
176         if (approve(_spender, _value)) {
177             spender.receiveApproval(msg.sender, _value, this, _extraData);
178             return true;
179         }
180     }
181 
182     /**
183      * Destroy tokens
184      *
185      * Remove `_value` tokens from the system irreversibly
186      *
187      * @param _value the amount of money to burn
188      */
189     function burn(uint256 _value) public returns (bool success) {
190         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
191         balanceOf[msg.sender] -= _value;            // Subtract from the sender
192         totalSupply -= _value;                      // Updates totalSupply
193         Burn(msg.sender, _value);
194         return true;
195     }
196 
197     /**
198      * Destroy tokens from other account
199      *
200      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
201      *
202      * @param _from the address of the sender
203      * @param _value the amount of money to burn
204      */
205     function burnFrom(address _from, uint256 _value) public returns (bool success) {
206         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
207         require(_value <= allowance[_from][msg.sender]);    // Check allowance
208         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
209         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
210         totalSupply -= _value;                              // Update totalSupply
211         Burn(_from, _value);
212         return true;
213     }
214 }