1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
5 }
6 
7 contract RareAssetsCoin {
8     string public name = 'RareAssetsCoin';
9     string public symbol = 'RRAC';
10     uint8 public decimals = 0;
11     uint256 public totalSupply = 100000000;
12 
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 
20     event Burn(address indexed from, uint256 value);
21 
22     constructor(
23         uint256 initialSupply,
24         string memory tokenName,
25         string memory tokenSymbol
26     ) public {
27         totalSupply = initialSupply * 10 ** uint256(decimals);  
28         balanceOf[msg.sender] = totalSupply;                
29         name = tokenName;                                   
30         symbol = tokenSymbol;                               
31     }
32 
33     /**
34      * Internal transfer, only can be called by this contract
35      */
36     function _transfer(address _from, address _to, uint _value) internal {
37         // Prevent transfer to 0x0 address. Use burn() instead
38         require(_to != address(0x0));
39         // Check if the sender has enough
40         require(balanceOf[_from] >= _value);
41         // Check for overflows
42         require(balanceOf[_to] + _value >= balanceOf[_to]);
43         // Save this for an assertion in the future
44         uint previousBalances = balanceOf[_from] + balanceOf[_to];
45         // Subtract from the sender
46         balanceOf[_from] -= _value;
47         // Add the same to the recipient
48         balanceOf[_to] += _value;
49         emit Transfer(_from, _to, _value);
50         // Asserts are used to use static analysis to find bugs in your code. They should never fail
51         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52     }
53 
54     /**
55      * Transfer tokens
56      *
57      * Send `_value` tokens to `_to` from your account
58      *
59      * @param _to The address of the recipient
60      * @param _value the amount to send
61      */
62     function transfer(address _to, uint256 _value) public returns (bool success) {
63         _transfer(msg.sender, _to, _value);
64         return true;
65     }
66 
67     /**
68      * Transfer tokens from other address
69      *
70      * Send `_value` tokens to `_to` on behalf of `_from`
71      *
72      * @param _from The address of the sender
73      * @param _to The address of the recipient
74      * @param _value the amount to send
75      */
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77         require(_value <= allowance[_from][msg.sender]);     // Check allowance
78         allowance[_from][msg.sender] -= _value;
79         _transfer(_from, _to, _value);
80         return true;
81     }
82 
83     /**
84      * Set allowance for other address
85      *
86      * Allows `_spender` to spend no more than `_value` tokens on your behalf
87      *
88      * @param _spender The address authorized to spend
89      * @param _value the max amount they can spend
90      */
91     function approve(address _spender, uint256 _value) public
92         returns (bool success) {
93         allowance[msg.sender][_spender] = _value;
94         emit Approval(msg.sender, _spender, _value);
95         return true;
96     }
97 
98     /**
99      * Set allowance for other address and notify
100      *
101      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
102      *
103      * @param _spender The address authorized to spend
104      * @param _value the max amount they can spend
105      * @param _extraData some extra information to send to the approved contract
106      */
107     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
108         public
109         returns (bool success) {
110         tokenRecipient spender = tokenRecipient(_spender);
111         if (approve(_spender, _value)) {
112             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
113             return true;
114         }
115     }
116 
117     /**
118      * Destroy tokens
119      *
120      * Remove `_value` tokens from the system irreversibly
121      *
122      * @param _value the amount of money to burn
123      */
124     function burn(uint256 _value) public returns (bool success) {
125         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
126         balanceOf[msg.sender] -= _value;            // Subtract from the sender
127         totalSupply -= _value;                      // Updates totalSupply
128         emit Burn(msg.sender, _value);
129         return true;
130     }
131 
132     /**
133      * Destroy tokens from other account
134      *
135      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
136      *
137      * @param _from the address of the sender
138      * @param _value the amount of money to burn
139      */
140     function burnFrom(address _from, uint256 _value) public returns (bool success) {
141         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
142         require(_value <= allowance[_from][msg.sender]);    // Check allowance
143         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
144         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
145         totalSupply -= _value;                              // Update totalSupply
146         emit Burn(_from, _value);
147         return true;
148     }
149 }