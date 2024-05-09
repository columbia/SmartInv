1 pragma solidity >=0.4.22 <0.6.0;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
28 
29 contract TokenERC20 {
30     // Public variables of the token
31     using SafeMath for uint256;
32     string public name;
33     string public symbol;
34     uint8 public decimals = 18;
35     // 18 decimals is the strongly suggested default, avoid changing it
36     uint256 public totalSupply;
37 
38     // This creates an array with all balances
39     mapping (address => uint256) public balanceOf;
40     mapping (address => mapping (address => uint256)) public allowance;
41 
42     // This generates a public event on the blockchain that will notify clients
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     
45     // This generates a public event on the blockchain that will notify clients
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 
48     // This notifies clients about the amount burnt
49     event Burn(address indexed from, uint256 value);
50 
51     /**
52      * Constrctor function
53      *
54      * Initializes contract with initial supply tokens to the creator of the contract
55      */
56     constructor(
57         uint256 initialSupply,
58         string memory tokenName,
59         string memory tokenSymbol
60     ) public {
61         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
62         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
63         name = tokenName;                                       // Set the name for display purposes
64         symbol = tokenSymbol;                                   // Set the symbol for display purposes
65     }
66 
67     /**
68      * Internal transfer, only can be called by this contract
69      */
70     function _transfer(address _from, address _to, uint _value) internal {
71         // Prevent transfer to 0x0 address. Use burn() instead
72         require(_to != address(0x0));
73         // Check if the sender has enough
74         require(balanceOf[_from] >= _value);
75         // Check for overflows
76         require(balanceOf[_to] + _value > balanceOf[_to]);
77         // Save this for an assertion in the future
78         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
79         // Subtract from the sender
80         balanceOf[_from] = balanceOf[_from].sub(_value);
81         // Add the same to the recipient
82         balanceOf[_to] = balanceOf[_to].add(_value);
83         emit Transfer(_from, _to, _value);
84         // Asserts are used to use static analysis to find bugs in your code. They should never fail
85         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
86     }
87 
88     /**
89      * Transfer tokens
90      *
91      * Send `_value` tokens to `_to` from your account
92      *
93      * @param _to The address of the recipient
94      * @param _value the amount to send
95      */
96     function transfer(address _to, uint256 _value) public returns (bool success) {
97         _transfer(msg.sender, _to, _value);
98         return true;
99     }
100 
101     /**
102      * Transfer tokens from other address
103      *
104      * Send `_value` tokens to `_to` in behalf of `_from`
105      *
106      * @param _from The address of the sender
107      * @param _to The address of the recipient
108      * @param _value the amount to send
109      */
110     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
111         require(_value <= allowance[_from][msg.sender]);     // Check allowance
112         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
113         _transfer(_from, _to, _value);
114         return true;
115     }
116 
117     /**
118      * Set allowance for other address
119      *
120      * Allows `_spender` to spend no more than `_value` tokens in your behalf
121      *
122      * @param _spender The address authorized to spend
123      * @param _value the max amount they can spend
124      */
125     function approve(address _spender, uint256 _value) public
126         returns (bool success) {
127         allowance[msg.sender][_spender] = _value;
128         emit Approval(msg.sender, _spender, _value);
129         return true;
130     }
131 
132     /**
133      * Set allowance for other address and notify
134      *
135      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
136      *
137      * @param _spender The address authorized to spend
138      * @param _value the max amount they can spend
139      * @param _extraData some extra information to send to the approved contract
140      */
141     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
142         public
143         returns (bool success) {
144         tokenRecipient spender = tokenRecipient(_spender);
145         if (approve(_spender, _value)) {
146             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
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
160         balanceOf[msg.sender] =balanceOf[msg.sender].sub(_value);            // Subtract from the sender
161         totalSupply =totalSupply.sub(_value);                      // Updates totalSupply
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
177         balanceOf[_from] =balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
178         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
179         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
180         emit Burn(_from, _value);
181         return true;
182     }
183 }