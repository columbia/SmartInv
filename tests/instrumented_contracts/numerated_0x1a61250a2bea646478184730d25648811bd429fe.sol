1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract MERIDIANERC20 {
6 
7     string public name = "Meridian";
8     string public symbol = "MDN";
9     uint8 public decimals = 8;
10 
11     uint256 public totalSupply = 51000000;
12     uint256 public initialSupply = 51000000;
13 
14 
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17 
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21 
22     event Burn(address indexed from, uint256 value);
23 
24     /**
25      * Constrctor function
26      *
27      * Initializes contract with initial supply tokens to the creator of the contract
28      */
29     function MERIDIANERC20
30       (string tokenName, string tokenSymbol) 
31         public {
32         totalSupply = initialSupply * 10 ** uint256(decimals);  
33         balanceOf[msg.sender] = totalSupply;                
34         name = tokenName ="Meridian";                                   
35         symbol = tokenSymbol ="MDN";                             
36     }
37 
38     /**
39      * Internal transfer, only can be called by this contract
40      */
41     function _transfer(address _from, address _to, uint _value) internal {
42         // Prevent transfer to 0x0 address. Use burn() instead
43         require(_to != 0x0);
44         require(balanceOf[_from] >= _value);
45         require(balanceOf[_to] + _value > balanceOf[_to]);
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         balanceOf[_from] -= _value;
48         balanceOf[_to] += _value;
49         Transfer(_from, _to, _value);
50         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
51     }
52 
53     /**
54      * Transfer tokens
55      *
56      * Send `_value` tokens to `_to` from your account
57      *
58      * @param _to The address of the recipient
59      * @param _value the amount to send
60      */
61     function transfer(address _to, uint256 _value) public {
62         _transfer(msg.sender, _to, _value);
63     }
64 
65     /**
66      * Transfer tokens from other address
67      *
68      * Send `_value` tokens to `_to` in behalf of `_from`
69      *
70      * @param _from The address of the sender
71      * @param _to The address of the recipient
72      * @param _value the amount to send
73      */
74     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
75         require(_value <= allowance[_from][msg.sender]);     // Check allowance
76         allowance[_from][msg.sender] -= _value;
77         _transfer(_from, _to, _value);
78         return true;
79     }
80 
81     /**
82      * Set allowance for other address
83      *
84      * Allows `_spender` to spend no more than `_value` tokens in your behalf
85      *
86      * @param _spender The address authorized to spend
87      * @param _value the max amount they can spend
88      */
89     function approve(address _spender, uint256 _value) public
90         returns (bool success) {
91         allowance[msg.sender][_spender] = _value;
92         return true;
93     }
94 
95     /**
96      * Set allowance for other address and notify
97      *
98      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
99      *
100      * @param _spender The address authorized to spend
101      * @param _value the max amount they can spend
102      * @param _extraData some extra information to send to the approved contract
103      */
104     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
105         public
106         returns (bool success) {
107         tokenRecipient spender = tokenRecipient(_spender);
108         if (approve(_spender, _value)) {
109             spender.receiveApproval(msg.sender, _value, this, _extraData);
110             return true;
111         }
112     }
113 
114     /**
115      * Destroy tokens
116      *
117      * Remove `_value` tokens from the system irreversibly
118      *
119      * @param _value the amount of money to burn
120      */
121     function burn(uint256 _value) public returns (bool success) {
122         require(balanceOf[msg.sender] >= _value);   
123         balanceOf[msg.sender] -= _value;            
124         totalSupply -= _value;                      
125         Burn(msg.sender, _value);
126         return true;
127     }
128 
129 }