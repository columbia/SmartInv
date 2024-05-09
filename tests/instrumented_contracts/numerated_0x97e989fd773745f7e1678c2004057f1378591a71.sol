1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-06
3 */
4 
5 pragma solidity ^0.4.16;
6 interface tokenRecipient {  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
7 contract TokenERC20 {
8     // Public variables of the token
9     string public name;
10     string public symbol;
11     uint8 public decimals = 8;
12     address public owner;
13     uint256 public totalSupply;
14     bool public lockIn;
15     mapping (address => bool) whitelisted;
16 	mapping (address => bool) admin;
17     // This creates an array with all balances
18     mapping (address => uint256) public balanceOf;
19     mapping (address => mapping (address => uint256)) public allowance;
20     // This generates a public event on the blockchain that will notify clients
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
23     // This notifies clients about the amount burnt
24     event Burn(address indexed from, uint256 value);
25     /**
26      * Constrctor function
27      *
28      * Initializes contract with initial supply tokens to the creator of the contract
29      */
30     constructor(
31         uint256 initialSupply,
32         string tokenName,
33         string tokenSymbol,
34         address crowdsaleOwner
35     ) public {
36         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
37         balanceOf[crowdsaleOwner] = totalSupply;                // Give the creator all initial tokens
38         name = tokenName;                                   // Set the name for display purposes
39         symbol = tokenSymbol;                               // Set the symbol for display purposes
40         lockIn = false;
41 		admin[msg.sender] = true;
42         whitelisted[msg.sender] = true;
43         owner = crowdsaleOwner;
44 		admin[crowdsaleOwner] = true;
45     }
46     
47     function toggleLockIn() public {
48         require(admin[msg.sender]);
49         lockIn = !lockIn;
50     }
51     
52     function addToWhitelist(address newAddress) public {
53         require(admin[msg.sender]);
54         whitelisted[newAddress] = true;
55     }
56 	
57 	function removeFromWhitelist(address oldaddress) public {
58 	    require(admin[msg.sender]);
59 		require(oldaddress != owner);
60 		whitelisted[oldaddress] = false;
61 	}
62 	
63 	function addToAdmin(address newAddress) public {
64 		require(admin[msg.sender]);
65 		admin[newAddress]=true;
66 	}
67 	
68 	function removeFromAdmin(address oldAddress) public {
69 		require(admin[msg.sender]);
70 		require(oldAddress != owner);
71 		admin[oldAddress]=false;
72 	}
73     /**
74      * Internal transfer, only can be called by this contract
75      */
76     function _transfer(address _from, address _to, uint _value) internal {
77         if (lockIn) {
78             require(whitelisted[_from]);
79         }
80         // Prevent transfer to 0x0 address. Use burn() instead
81         require(_to != 0x0);
82         // Check if the sender has enough
83         require(balanceOf[_from] >= _value);
84         // Check for overflows
85         require(balanceOf[_to] + _value > balanceOf[_to]);
86         // Save this for an assertion in the future
87         uint previousBalances = balanceOf[_from] + balanceOf[_to];
88         // Subtract from the sender
89         balanceOf[_from] -= _value;
90         // Add the same to the recipient
91         balanceOf[_to] += _value;
92         emit Transfer(_from, _to, _value);
93         
94         // Asserts are used to use static analysis to find bugs in your code. They should never fail
95         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
96     }
97     /**
98      * Transfer tokens
99      *
100      * Send `_value` tokens to `_to` from your account
101      *
102      * @param _to The address of the recipient
103      * @param _value the amount to send
104      */
105     function transfer(address _to, uint256 _value) public {
106         _transfer(msg.sender, _to, _value);
107     }
108     /**
109      * Transfer tokens from other address
110      *
111      * Send `_value` tokens to `_to` on behalf of `_from`
112      *
113      * @param _from The address of the sender
114      * @param _to The address of the recipient
115      * @param _value the amount to send
116      */
117     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
118         require(_value <= allowance[_from][msg.sender]);     // Check allowance
119         allowance[_from][msg.sender] -= _value;
120         _transfer(_from, _to, _value);
121         return true;
122     }
123     /**
124      * Set allowance for other address
125      *
126      * Allows `_spender` to spend no more than `_value` tokens on your behalf
127      *
128      * @param _spender The address authorized to spend
129      * @param _value the max amount they can spend
130      */
131     function approve(address _spender, uint256 _value) public
132         returns (bool success) {
133         allowance[msg.sender][_spender] = _value;
134         emit Approval(msg.sender, _spender, _value);
135         return true;
136     }
137     /**
138      * Set allowance for other address and notify
139      *
140      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
141      *
142      * @param _spender The address authorized to spend
143      * @param _value the max amount they can spend
144      * @param _extraData some extra information to send to the approved contract
145      */
146     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
147         public
148         returns (bool success) {
149         tokenRecipient spender = tokenRecipient(_spender);
150         if (approve(_spender, _value)) {
151             spender.receiveApproval(msg.sender, _value, this, _extraData);
152             return true;
153         }
154     }
155     /**
156      * Destroy tokens
157      *
158      * Remove `_value` tokens from the system irreversibly
159      *
160      * @param _value the amount of money to burn
161      */
162     function burn(uint256 _value) public returns (bool success) {
163         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
164         balanceOf[msg.sender] -= _value;            // Subtract from the sender
165         totalSupply -= _value;                      // Updates totalSupply
166         emit Burn(msg.sender, _value);
167         return true;
168     }
169     /**
170      * Destroy tokens from other account
171      *
172      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
173      *
174      * @param _from the address of the sender
175      * @param _value the amount of money to burn
176      */
177     function burnFrom(address _from, uint256 _value) public returns (bool success) {
178         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
179         require(_value <= allowance[_from][msg.sender]);    // Check allowance
180         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
181         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
182         totalSupply -= _value;                              // Update totalSupply
183         emit Burn(_from, _value);
184         return true;
185     }
186 }