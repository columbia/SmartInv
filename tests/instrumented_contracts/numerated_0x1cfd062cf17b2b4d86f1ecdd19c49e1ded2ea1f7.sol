1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract IntelligentETH {
35     using SafeMath for uint256;
36     // Public variables of the token
37     string public name;
38     string public symbol;
39     uint8 public decimals = 0;
40     // 18 decimals is the strongly suggested default, avoid changing it
41     uint256 public totalSupply;
42 
43     // This creates an array with all balances
44     mapping (address => uint256) public balanceOf;
45     mapping (address => mapping (address => uint256)) public allowance;
46 
47     // This generates a public event on the blockchain that will notify clients
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 
50     // This notifies clients about the amount burnt
51     event Burn(address indexed from, uint256 value);
52 
53     /**
54      * Constructor function
55      *
56      * Initializes contract with initial supply tokens to the creator of the contract
57      */
58     constructor(
59         uint256 initialSupply,
60         string tokenName,
61         string tokenSymbol
62     ) public {
63         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
64         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
65         name = tokenName;                                   // Set the name for display purposes
66         symbol = tokenSymbol;                               // Set the symbol for display purposes
67     }
68 
69     /**
70      * Internal transfer, only can be called by this contract
71      */
72     function _transfer(address _from, address _to, uint256 _value) internal {
73         // Prevent transfer to 0x0 address. Use burn() instead
74         require(_to != 0x0);
75         // Check if the sender has enough
76         require(balanceOf[_from] >= _value);
77         // Check for overflows
78         require(balanceOf[_to].add(_value) >= balanceOf[_to]);
79         // Save this for an assertion in the future
80         uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
81         // Subtract from the sender
82         balanceOf[_from] = balanceOf[_from].sub(_value);
83         // Add the same to the recipient
84         balanceOf[_to] = balanceOf[_to].add(_value);
85         emit Transfer(_from, _to, _value);
86         // Asserts are used to use static analysis to find bugs in your code. They should never fail
87         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
88     }
89 
90     /**
91      * Transfer tokens
92      *
93      * Send `_value` tokens to `_to` from your account
94      *
95      * @param _to The address of the recipient
96      * @param _value the amount to send
97      */
98     function transfer(address _to, uint256 _value) public {
99         _transfer(msg.sender, _to, _value);
100     }
101 
102     /**
103      * Transfer tokens from other address
104      *
105      * Send `_value` tokens to `_to` on behalf of `_from`
106      *
107      * @param _from The address of the sender
108      * @param _to The address of the recipient
109      * @param _value the amount to send
110      */
111     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
112         require(_value <= allowance[_from][msg.sender]);     // Check allowance
113         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
114         _transfer(_from, _to, _value);
115         return true;
116     }
117 
118     /**
119      * Set allowance for other address
120      *
121      * Allows `_spender` to spend no more than `_value` tokens on your behalf
122      *
123      * @param _spender The address authorized to spend
124      * @param _value the max amount they can spend
125      */
126     function approve(address _spender, uint256 _value) public
127         returns (bool success) {
128         allowance[msg.sender][_spender] = _value;
129         return true;
130     }
131 
132     /**
133      * Set allowance for other address and notify
134      *
135      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
136      *
137      * @param _spender The address authorized to spend
138      * @param _value the max amount they can spend
139      * @param _extraData some extra information to send to the approved contract
140      */
141     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
142         public
143         returns (bool success) {
144         tokenRecipient spender = tokenRecipient(_spender);
145         if (approve(_spender, _value)) {
146             spender.receiveApproval(msg.sender, _value, this, _extraData);
147             return true;
148         }
149     }
150 
151     /**
152      * Destroy tokens
153      *
154      * Remove `_value` tokens from the system irreversibly
155      *
156      * @param _value the amount of money to burn
157      */
158     function burn(uint256 _value) public returns (bool success) {
159         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
160         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
161         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
162         emit Burn(msg.sender, _value);
163         return true;
164     }
165 
166     /**
167      * Destroy tokens from other account
168      *
169      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
170      *
171      * @param _from the address of the sender
172      * @param _value the amount of money to burn
173      */
174     function burnFrom(address _from, uint256 _value) public returns (bool success) {
175         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
176         require(_value <= allowance[_from][msg.sender]);    // Check allowance
177         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
178         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
179         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
180         emit Burn(_from, _value);
181         return true;
182     }
183 }