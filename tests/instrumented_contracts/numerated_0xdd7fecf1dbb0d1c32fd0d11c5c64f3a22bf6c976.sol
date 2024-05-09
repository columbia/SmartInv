1 pragma solidity ^0.4.16;
2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
3 contract TokenERC20 {
4     // Public variables of the token
5     string public name;
6     string public symbol;
7     uint8 public decimals = 8;
8     address public owner;
9     uint256 public totalSupply;
10     bool public lockIn;
11     mapping (address => bool) whitelisted;
12 	mapping (address => bool) admin;
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16     // This generates a public event on the blockchain that will notify clients
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
19     // This notifies clients about the amount burnt
20     event Burn(address indexed from, uint256 value);
21     /**
22      * Constrctor function
23      *
24      * Initializes contract with initial supply tokens to the creator of the contract
25      */
26     constructor(
27         uint256 initialSupply,
28         string tokenName,
29         string tokenSymbol,
30         address crowdsaleOwner
31     ) public {
32         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
33         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
34         name = tokenName;                                   // Set the name for display purposes
35         symbol = tokenSymbol;                               // Set the symbol for display purposes
36         lockIn = true;
37 		admin[msg.sender] = true;
38         whitelisted[msg.sender] = true;
39         admin[crowdsaleOwner]=true;
40         whitelisted[crowdsaleOwner]=true;
41         owner = crowdsaleOwner;
42     }
43     
44     function toggleLockIn() public {
45         require(msg.sender == owner);
46         lockIn = !lockIn;
47     }
48     
49     function addToWhitelist(address newAddress) public {
50         require(admin[msg.sender]);
51         whitelisted[newAddress] = true;
52     }
53 	
54 	function removeFromWhitelist(address oldaddress) public {
55 	    require(admin[msg.sender]);
56 		require(oldaddress != owner);
57 		whitelisted[oldaddress] = false;
58 	}
59 	
60 	function addToAdmin(address newAddress) public {
61 		require(admin[msg.sender]);
62 		admin[newAddress]=true;
63 	}
64 	
65 	function removeFromAdmin(address oldAddress) public {
66 		require(admin[msg.sender]);
67 		require(oldAddress != owner);
68 		admin[oldAddress]=false;
69 	}
70     /**
71      * Internal transfer, only can be called by this contract
72      */
73     function _transfer(address _from, address _to, uint _value) internal {
74         if (lockIn) {
75             require(whitelisted[_from]);
76         }
77         // Prevent transfer to 0x0 address. Use burn() instead
78         require(_to != 0x0);
79         // Check if the sender has enough
80         require(balanceOf[_from] >= _value);
81         // Check for overflows
82         require(balanceOf[_to] + _value > balanceOf[_to]);
83         // Save this for an assertion in the future
84         uint previousBalances = balanceOf[_from] + balanceOf[_to];
85         // Subtract from the sender
86         balanceOf[_from] -= _value;
87         // Add the same to the recipient
88         balanceOf[_to] += _value;
89         emit Transfer(_from, _to, _value);
90         // Asserts are used to use static analysis to find bugs in your code. They should never fail
91         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
92     }
93     /**
94      * Transfer tokens
95      *
96      * Send `_value` tokens to `_to` from your account
97      *
98      * @param _to The address of the recipient
99      * @param _value the amount to send
100      */
101     function transfer(address _to, uint256 _value) public {
102         _transfer(msg.sender, _to, _value);
103     }
104     /**
105      * Transfer tokens from other address
106      *
107      * Send `_value` tokens to `_to` on behalf of `_from`
108      *
109      * @param _from The address of the sender
110      * @param _to The address of the recipient
111      * @param _value the amount to send
112      */
113     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
114         require(_value <= allowance[_from][msg.sender]);     // Check allowance
115         allowance[_from][msg.sender] -= _value;
116         _transfer(_from, _to, _value);
117         return true;
118     }
119     /**
120      * Set allowance for other address
121      *
122      * Allows `_spender` to spend no more than `_value` tokens on your behalf
123      *
124      * @param _spender The address authorized to spend
125      * @param _value the max amount they can spend
126      */
127     function approve(address _spender, uint256 _value) public
128         returns (bool success) {
129         allowance[msg.sender][_spender] = _value;
130         emit Approval(msg.sender, _spender, _value);
131         return true;
132     }
133     /**
134      * Set allowance for other address and notify
135      *
136      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
137      *
138      * @param _spender The address authorized to spend
139      * @param _value the max amount they can spend
140      * @param _extraData some extra information to send to the approved contract
141      */
142     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
143         public
144         returns (bool success) {
145         tokenRecipient spender = tokenRecipient(_spender);
146         if (approve(_spender, _value)) {
147             spender.receiveApproval(msg.sender, _value, this, _extraData);
148             return true;
149         }
150     }
151     /**
152      * Destroy tokens
153      *
154      * Remove `_value` tokens from the system irreversibly
155      *
156      * @param _value the amount of money to burn
157      */
158     function burn(uint256 _value) public returns (bool success) {
159         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
160         balanceOf[msg.sender] -= _value;            // Subtract from the sender
161         totalSupply -= _value;                      // Updates totalSupply
162         emit Burn(msg.sender, _value);
163         return true;
164     }
165     /**
166      * Destroy tokens from other account
167      *
168      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
169      *
170      * @param _from the address of the sender
171      * @param _value the amount of money to burn
172      */
173     function burnFrom(address _from, uint256 _value) public returns (bool success) {
174         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
175         require(_value <= allowance[_from][msg.sender]);    // Check allowance
176         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
177         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
178         totalSupply -= _value;                              // Update totalSupply
179         emit Burn(_from, _value);
180         return true;
181     }
182 }