1 /**
2  *Submitted for verification at Etherscan.io on 2018-02-03
3 */
4 
5 pragma solidity ^0.4.18;
6 
7 
8 interface tokenRecipient {
9     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
10 }
11 
12 contract VCFundToken {
13 
14     // Public variables of the token
15     string public name = 'VCFund Token';
16 
17     string public symbol = 'VCF';
18 
19     uint8 public decimals = 18;
20 
21     uint256 public totalSupply = 21 * 10 ** 26;
22 
23     address public owner;
24 
25     // This creates an array with all balances
26     mapping (address => uint256) public balanceOf;
27 
28     mapping (address => mapping (address => uint256)) public allowance;
29 
30     // This generates a public event on the blockchain that will notify clients
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33     // This notifies clients about the amount burnt
34     event Burn(address indexed from, uint256 value);
35     event Issue(uint256 amount);
36 
37     /**
38      * Constrctor function
39      *
40      * Initializes contract with initial supply tokens to the creator of the contract
41      */
42     function VCFundToken() public {
43         balanceOf[msg.sender] = totalSupply;
44     }
45 
46     /**
47       * @dev Gets the balance of the specified address.
48       * @param _owner The address to query the the balance of.
49       * @return An uint256 representing the amount owned by the passed address.
50       */
51     function balanceOf(address _owner) public view returns (uint256 balance) {
52         return balanceOf[_owner];
53     }
54 
55     /**
56       * Internal transfer, only can be called by this contract
57       */
58     function _transfer(address _from, address _to, uint _value) internal {
59         // Prevent transfer to 0x0 address. Use burn() instead
60         require(_to != 0x0);
61         // Check if the sender has enough
62         require(balanceOf[_from] >= _value);
63         // Check for overflows
64         require(balanceOf[_to] + _value > balanceOf[_to]);
65         // Save this for an assertion in the future
66         uint previousBalances = balanceOf[_from] + balanceOf[_to];
67         // Subtract from the sender
68         balanceOf[_from] -= _value;
69         // Add the same to the recipient
70         balanceOf[_to] += _value;
71         Transfer(_from, _to, _value);
72         // Asserts are used to use static analysis to find bugs in your code. They should never fail
73         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
74     }
75 
76     /**
77      * Transfer tokens
78      *
79      * Send `_value` tokens to `_to` from your account
80      *
81      * @param _to The address of the recipient
82      * @param _value the amount to send
83      */
84     function transfer(address _to, uint256 _value) public returns (bool success){
85         _transfer(msg.sender, _to, _value);
86         return true;
87     }
88 
89     /**
90      * Transfer tokens from other address
91      *
92      * Send `_value` tokens to `_to` in behalf of `_from`
93      *
94      * @param _from The address of the sender
95      * @param _to The address of the recipient
96      * @param _value the amount to send
97      */
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99         require(_value <= allowance[_from][msg.sender]);
100         // Check allowance
101         allowance[_from][msg.sender] -= _value;
102         _transfer(_from, _to, _value);
103         return true;
104     }
105 
106     /**
107      * Set allowance for other address
108      *
109      * Allows `_spender` to spend no more than `_value` tokens in your behalf
110      *
111      * @param _spender The address authorized to spend
112      * @param _value the max amount they can spend
113      */
114     function approve(address _spender, uint256 _value) public returns (bool success) {
115         require(_value <= balanceOf[msg.sender]);
116         allowance[msg.sender][_spender] = _value;
117         Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     /**
122      * Set allowance for other address and notify
123      *
124      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
125      *
126      * @param _spender The address authorized to spend
127      * @param _value the max amount they can spend
128      * @param _extraData some extra information to send to the approved contract
129      */
130     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
131         tokenRecipient spender = tokenRecipient(_spender);
132         if (approve(_spender, _value)) {
133             spender.receiveApproval(msg.sender, _value, this, _extraData);
134             return true;
135         }
136     }
137 
138     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
139         return allowance[_owner][_spender];
140     }
141 
142     /**
143      * Destroy tokens
144      *
145      * Remove `_value` tokens from the system irreversibly
146      *
147      * @param _value the amount of money to burn
148      */
149     function burn(uint256 _value) public returns (bool success) {
150         require(balanceOf[msg.sender] >= _value);
151         // Check if the sender has enough
152         balanceOf[msg.sender] -= _value;
153         // Subtract from the sender
154         totalSupply -= _value;
155         // Updates totalSupply
156         Burn(msg.sender, _value);
157         return true;
158     }
159 
160     /**
161      * Destroy tokens from other account
162      *
163      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
164      *
165      * @param _from the address of the sender
166      * @param _value the amount of money to burn
167      */
168     function burnFrom(address _from, uint256 _value) public returns (bool success) {
169         require(balanceOf[_from] >= _value);
170         // Check if the targeted balance is enough
171         require(_value <= allowance[_from][msg.sender]);
172         // Check allowance
173         balanceOf[_from] -= _value;
174         // Subtract from the targeted balance
175         allowance[_from][msg.sender] -= _value;
176         // Subtract from the sender's allowance
177         totalSupply -= _value;
178         // Update totalSupply
179         Burn(_from, _value);
180         return true;
181     }
182 
183 }