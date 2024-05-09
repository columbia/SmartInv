1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract touristoken {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 0;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     event Burn(address indexed from, uint256 value);
17 
18     /**
19      * Constructor function
20      *
21      * Initializes contract with initial supply tokens to the creator of the contract
22      */
23     function TokenERC20(
24         uint256 initialSupply,
25         string tokenName,
26         string tokenSymbol
27     ) public {
28         totalSupply = 7000000000;  
29         balanceOf[msg.sender] = totalSupply;                
30         name = "touristoken";                                   
31         symbol = "TOU";                               
32     }
33 
34     /**
35      * Internal transfer, only can be called by this contract
36      */
37     function _transfer(address _from, address _to, uint _value) internal {
38         require(_to != 0x0);
39         require(balanceOf[_from] >= _value);
40         require(balanceOf[_to] + _value >= balanceOf[_to]);
41         uint previousBalances = balanceOf[_from] + balanceOf[_to];
42         balanceOf[_from] -= _value;
43         balanceOf[_to] += _value;
44        Transfer(_from, _to, _value);
45         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
46     }
47 
48     /**
49      * Transfer tokens
50      *
51      * Send `_value` tokens to `_to` from your account
52      *
53      * @param _to The address of the recipient
54      * @param _value the amount to send
55      */
56     function transfer(address _to, uint256 _value) public {
57         _transfer(msg.sender, _to, _value);
58     }
59 
60     /**
61      * Transfer tokens from other address
62      *
63      * Send `_value` tokens to `_to` on behalf of `_from`
64      *
65      * @param _from The address of the sender
66      * @param _to The address of the recipient
67      * @param _value the amount to send
68      */
69     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
70         require(_value <= allowance[_from][msg.sender]);    
71         allowance[_from][msg.sender] -= _value;
72         _transfer(_from, _to, _value);
73         return true;
74     }
75 
76     /**
77      * Set allowance for other address
78      *
79      * Allows `_spender` to spend no more than `_value` tokens on your behalf
80      *
81      * @param _spender The address authorized to spend
82      * @param _value the max amount they can spend
83      */
84     function approve(address _spender, uint256 _value) public
85         returns (bool success) {
86         allowance[msg.sender][_spender] = _value;
87         return true;
88     }
89 
90     /**
91      * Set allowance for other address and notify
92      *
93      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
94      *
95      * @param _spender The address authorized to spend
96      * @param _value the max amount they can spend
97      * @param _extraData some extra information to send to the approved contract
98      */
99     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
100         public
101         returns (bool success) {
102         tokenRecipient spender = tokenRecipient(_spender);
103         if (approve(_spender, _value)) {
104             spender.receiveApproval(msg.sender, _value, this, _extraData);
105             return true;
106         }
107     }
108 
109     /**
110      * Destroy tokens
111      *
112      * Remove `_value` tokens from the system irreversibly
113      *
114      * @param _value the amount of money to burn
115      */
116     function burn(uint256 _value) public returns (bool success) {
117         require(balanceOf[msg.sender] >= _value);   
118         balanceOf[msg.sender] -= _value;            
119         totalSupply -= _value;                      
120          Burn(msg.sender, _value);
121         return true;
122     }
123 
124     /**
125      * Destroy tokens from other account
126      *
127      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
128      *
129      * @param _from the address of the sender
130      * @param _value the amount of money to burn
131      */
132     function burnFrom(address _from, uint256 _value) public returns (bool success) {
133         require(balanceOf[_from] >= _value);                
134         require(_value <= allowance[_from][msg.sender]);    
135         balanceOf[_from] -= _value;                         
136         allowance[_from][msg.sender] -= _value;             
137         totalSupply -= _value;                              
138         Burn(_from, _value);
139         return true;
140     }
141 }