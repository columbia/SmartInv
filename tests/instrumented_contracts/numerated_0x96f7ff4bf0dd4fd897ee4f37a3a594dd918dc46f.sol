1 pragma solidity ^0.4.25;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
5 }
6 
7 contract PDAToken {
8     // Public variables of the token
9     string public name = "CurrencyExCoin";
10     string public symbol = "ATM";
11     // 18 decimals is the strongly suggested default, avoid changing it
12     uint8 public decimals = 18;
13 
14     uint256 private initialSupply=70000000000;
15 
16     uint256 public totalSupply;
17 
18     // This creates an array with all balances
19     mapping(address => uint256) public balanceOf;
20     mapping(address => mapping(address => uint256)) public allowance;
21 
22     // This generates a public event on the blockchain that will notify clients
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 
25     // This generates a public event on the blockchain that will notify clients
26     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
27 
28     // This notifies clients about the amount burnt
29     event Burn(address indexed from, uint256 value);
30 
31     /**
32      * Constructor function
33      *
34      * Initializes contract with initial supply tokens to the creator of the contract
35      */
36     constructor() public {
37         totalSupply = initialSupply * 10 ** uint256(decimals);
38         // Update total supply with the decimal amount
39         balanceOf[msg.sender] = totalSupply;
40         // Give the creator all initial tokens
41 
42     }
43 
44     /**
45      * Internal transfer, only can be called by this contract
46      */
47     function _transfer(address _from, address _to, uint _value) internal {
48         // Prevent transfer to 0x0 address. Use burn() instead
49         require(_to != address(0x0));
50         // Check if the sender has enough
51         require(balanceOf[_from] >= _value);
52         // Check for overflows
53         require(balanceOf[_to] + _value >= balanceOf[_to]);
54         // Save this for an assertion in the future
55         uint previousBalances = balanceOf[_from] + balanceOf[_to];
56         // Subtract from the sender
57         balanceOf[_from] -= _value;
58         // Add the same to the recipient
59         balanceOf[_to] += _value;
60         emit Transfer(_from, _to, _value);
61         // Asserts are used to use static analysis to find bugs in your code. They should never fail
62         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
63     }
64 
65     /**
66      * Transfer tokens
67      *
68      * Send `_value` tokens to `_to` from your account
69      *
70      * @param _to The address of the recipient
71      * @param _value the amount to send
72      */
73     function transfer(address _to, uint256 _value) public returns (bool success) {
74         _transfer(msg.sender, _to, _value);
75         return true;
76     }
77 
78     /**
79      * Transfer tokens from other address
80      *
81      * Send `_value` tokens to `_to` on behalf of `_from`
82      *
83      * @param _from The address of the sender
84      * @param _to The address of the recipient
85      * @param _value the amount to send
86      */
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
88         require(_value <= allowance[_from][msg.sender]);
89         // Check allowance
90         allowance[_from][msg.sender] -= _value;
91         _transfer(_from, _to, _value);
92         return true;
93     }
94 
95     /**
96      * Set allowance for other address
97      *
98      * Allows `_spender` to spend no more than `_value` tokens on your behalf
99      *
100      * @param _spender The address authorized to spend
101      * @param _value the max amount they can spend
102      */
103     function approve(address _spender, uint256 _value) public
104     returns (bool success) {
105         allowance[msg.sender][_spender] = _value;
106         emit Approval(msg.sender, _spender, _value);
107         return true;
108     }
109 
110     /**
111      * Set allowance for other address and notify
112      *
113      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
114      *
115      * @param _spender The address authorized to spend
116      * @param _value the max amount they can spend
117      * @param _extraData some extra information to send to the approved contract
118      */
119     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
120     public
121     returns (bool success) {
122         tokenRecipient spender = tokenRecipient(_spender);
123         if (approve(_spender, _value)) {
124             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
125             return true;
126         }
127         return false;
128     }
129 
130     /**
131      * Destroy tokens
132      *
133      * Remove `_value` tokens from the system irreversibly
134      *
135      * @param _value the amount of money to burn
136      */
137     function burn(uint256 _value) public returns (bool success) {
138         require(balanceOf[msg.sender] >= _value);
139         // Check if the sender has enough
140         balanceOf[msg.sender] -= _value;
141         // Subtract from the sender
142         totalSupply -= _value;
143         // Updates totalSupply
144         emit Burn(msg.sender, _value);
145         return true;
146     }
147 
148     /**
149      * Destroy tokens from other account
150      *
151      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
152      *
153      * @param _from the address of the sender
154      * @param _value the amount of money to burn
155      */
156     function burnFrom(address _from, uint256 _value) public returns (bool success) {
157         require(balanceOf[_from] >= _value);
158         // Check if the targeted balance is enough
159         require(_value <= allowance[_from][msg.sender]);
160         // Check allowance
161         balanceOf[_from] -= _value;
162         // Subtract from the targeted balance
163         allowance[_from][msg.sender] -= _value;
164         // Subtract from the sender's allowance
165         totalSupply -= _value;
166         // Update totalSupply
167         emit Burn(_from, _value);
168         return true;
169     }
170 }