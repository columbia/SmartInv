1 pragma solidity ^0.4.16;
2 
3 
4 
5 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
6 
7 contract TokenTKC {
8     
9     string public name = "iTech Token";
10     string public symbol = "TKC";
11     uint256 public decimals = 18;
12     
13     uint256 public totalSupply = 100*1000*1000*(10**decimals);
14 
15     
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     
23     event Burn(address indexed from, uint256 value);
24 
25     /**
26      * Constrctor function
27      *
28      * Initializes contract with initial supply tokens to the creator of the contract
29      */
30     function TokenTKC(
31     ) public {
32         balanceOf[msg.sender] = totalSupply;                
33     }
34 
35     /**
36      * Internal transfer, only can be called by this contract
37      */
38     function _transfer(address _from, address _to, uint _value) internal {
39         
40         require(_to != 0x0);
41         
42         require(balanceOf[_from] >= _value);
43         
44         require(balanceOf[_to] + _value > balanceOf[_to]);
45         
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         
48         balanceOf[_from] -= _value;
49         
50         balanceOf[_to] += _value;
51         Transfer(_from, _to, _value);
52         
53         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
54     }
55 
56     /**
57      * Transfer tokens
58      *
59      * Send `_value` tokens to `_to` from your account
60      *
61      * @param _to The address of the recipient
62      * @param _value the amount to send
63      */
64     function transfer(address _to, uint256 _value) public {
65         _transfer(msg.sender, _to, _value);
66     }
67 
68     /**
69      * Transfer tokens from other address
70      *
71      * Send `_value` tokens to `_to` in behalf of `_from`
72      *
73      * @param _from The address of the sender
74      * @param _to The address of the recipient
75      * @param _value the amount to send
76      */
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
78         require(_value <= allowance[_from][msg.sender]);     
79         allowance[_from][msg.sender] -= _value;
80         _transfer(_from, _to, _value);
81         return true;
82     }
83 
84     /**
85      * Set allowance for other address
86      *
87      * Allows `_spender` to spend no more than `_value` tokens in your behalf
88      *
89      * @param _spender The address authorized to spend
90      * @param _value the max amount they can spend
91      */
92     function approve(address _spender, uint256 _value) public
93         returns (bool success) {
94         allowance[msg.sender][_spender] = _value;
95         return true;
96     }
97 
98     /**
99      * Set allowance for other address and notify
100      *
101      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
102      *
103      * @param _spender The address authorized to spend
104      * @param _value the max amount they can spend
105      * @param _extraData some extra information to send to the approved contract
106      */
107     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
108         public
109         returns (bool success) {
110         tokenRecipient spender = tokenRecipient(_spender);
111         if (approve(_spender, _value)) {
112             spender.receiveApproval(msg.sender, _value, this, _extraData);
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
125         require(balanceOf[msg.sender] >= _value);   
126         balanceOf[msg.sender] -= _value;            
127         totalSupply -= _value;                      
128         Burn(msg.sender, _value);
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
141         require(balanceOf[_from] >= _value);                
142         require(_value <= allowance[_from][msg.sender]);    
143         balanceOf[_from] -= _value;                         
144         allowance[_from][msg.sender] -= _value;             
145         totalSupply -= _value;                              
146         Burn(_from, _value);
147         return true;
148     }
149 }