1 pragma solidity ^0.4.25;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract BitmallyToken {
6   
7     string public name;
8     string public symbol;
9     uint8 public decimals = 8;
10 
11     uint256 public totalSupply;
12 
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 
20     // This notifies clients about the amount burnt
21     event Burn(address indexed from, uint256 value);
22 
23 
24     function BitmallyToken(
25         uint256 initialSupply,
26         string tokenName,
27         string tokenSymbol
28     ) public {
29         totalSupply = initialSupply * 10 ** uint256(decimals);  
30         balanceOf[msg.sender] = totalSupply;                
31         name = tokenName;                                  
32         symbol = tokenSymbol;                              
33     }
34 
35     /**
36      * Internal transfer, only can be called by this contract
37      */
38     function _transfer(address _from, address _to, uint _value) internal {
39 
40         require(_to != 0x0);
41         require(balanceOf[_from] >= _value);
42         require(balanceOf[_to] + _value >= balanceOf[_to]);
43         uint previousBalances = balanceOf[_from] + balanceOf[_to];
44         balanceOf[_from] -= _value;
45         balanceOf[_to] += _value;
46         emit Transfer(_from, _to, _value);
47         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
48     }
49 
50     /**
51      * Transfer tokens
52      *
53      * Send `_value` tokens to `_to` from your account
54      *
55      * @param _to The address of the recipient
56      * @param _value the amount to send
57      */
58     function transfer(address _to, uint256 _value) public returns (bool success) {
59         _transfer(msg.sender, _to, _value);
60         return true;
61     }
62 
63     /**
64      * Transfer tokens from other address
65      *
66      * Send `_value` tokens to `_to` on behalf of `_from`
67      *
68      * @param _from The address of the sender
69      * @param _to The address of the recipient
70      * @param _value the amount to send
71      */
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         require(_value <= allowance[_from][msg.sender]);     
74         allowance[_from][msg.sender] -= _value;
75         _transfer(_from, _to, _value);
76         return true;
77     }
78 
79     /**
80      * Set allowance for other address
81      *
82      * Allows `_spender` to spend no more than `_value` tokens on your behalf
83      *
84      * @param _spender The address authorized to spend
85      * @param _value the max amount they can spend
86      */
87     function approve(address _spender, uint256 _value) public
88         returns (bool success) {
89         allowance[msg.sender][_spender] = _value;
90         emit Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     /**
95      * Set allowance for other address and notify
96      *
97      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
98      *
99      * @param _spender The address authorized to spend
100      * @param _value the max amount they can spend
101      * @param _extraData some extra information to send to the approved contract
102      */
103     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
104         public
105         returns (bool success) {
106         tokenRecipient spender = tokenRecipient(_spender);
107         if (approve(_spender, _value)) {
108             spender.receiveApproval(msg.sender, _value, this, _extraData);
109             return true;
110         }
111     }
112 
113     /**
114      * Destroy tokens
115      *
116      * Remove `_value` tokens from the system irreversibly
117      *
118      * @param _value the amount of money to burn
119      */
120     function burn(uint256 _value) public returns (bool success) {
121         require(balanceOf[msg.sender] >= _value);   
122         balanceOf[msg.sender] -= _value;            
123         totalSupply -= _value;                      
124         emit Burn(msg.sender, _value);
125         return true;
126     }
127 
128     /**
129      * Destroy tokens from other account
130      *
131      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
132      *
133      * @param _from the address of the sender
134      * @param _value the amount of money to burn
135      */
136     function burnFrom(address _from, uint256 _value) public returns (bool success) {
137         require(balanceOf[_from] >= _value);                
138         require(_value <= allowance[_from][msg.sender]);   
139         balanceOf[_from] -= _value;                         
140         allowance[_from][msg.sender] -= _value;             
141         totalSupply -= _value;                              
142         emit Burn(_from, _value);
143         return true;
144     }
145 }