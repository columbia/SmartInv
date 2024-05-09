1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract PEPL{
6     // Public variables
7     string public name = "PEPEPLUSH";
8     string public symbol = "PEPL";
9     uint8 public decimals = 0;
10     uint256 public totalSupply = 300;
11     bool public transferrable = false;
12     address public contract2Address;
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
25      * Constructor function
26      *
27      * Initializes contract with initial supply tokens to the creator of the contract
28      */
29     function PEPL(
30    
31     ) public {
32         totalSupply = 300 * 10 ** uint256(decimals);  
33         balanceOf[msg.sender] = totalSupply;                
34         name = "PEPEPLUSH";                                   
35         symbol = "PEPL";                               
36     }
37 
38     // set transferrable
39 
40     function set_transferrable(bool newVal) public{
41         require(msg.sender == 0x0b3F4B2e8E91cb8Ac9C394B4Fc693f0fbd27E3dB);
42         transferrable = newVal;
43     
44     }
45     
46     // set contract address
47 
48     function set_contract2address(address _address) public{
49         require(msg.sender == 0x0b3F4B2e8E91cb8Ac9C394B4Fc693f0fbd27E3dB);
50         contract2Address = _address;
51     
52     }
53     /**
54      * Internal transfer, only can be called by this contract
55      */
56     function _transfer(address _from, address _to, uint _value) internal {
57         require(_to != 0x0);
58         require(balanceOf[_from] >= _value);
59         require(balanceOf[_to] + _value > balanceOf[_to]);
60         uint previousBalances = balanceOf[_from] + balanceOf[_to];
61         balanceOf[_from] -= _value;
62         balanceOf[_to] += _value;
63         Transfer(_from, _to, _value);
64         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
65     }
66 
67     /**
68      * Transfer tokens
69      *
70      * Send `_value` tokens to `_to` from your account
71      *
72      * @param _to The address of the recipient
73      * @param _value the amount to send
74      */
75     function transfer(address _to, uint256 _value) public {
76              
77              
78             if (msg.sender == 0x0b3F4B2e8E91cb8Ac9C394B4Fc693f0fbd27E3dB)
79                 {
80                 _transfer(msg.sender, _to, _value);
81                 }
82             else if (msg.sender == contract2Address)
83                 {
84                 _transfer(msg.sender, _to, _value);
85                 }
86             else
87                 {
88                 require(transferrable);
89                 _transfer(msg.sender, _to, _value);
90                 }
91     }
92 
93   
94 
95     /**
96      * Transfer tokens from other address
97      *
98      * Send `_value` tokens to `_to` on behalf of `_from`
99      *
100      * @param _from The address of the sender
101      * @param _to The address of the recipient
102      * @param _value the amount to send
103      */
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
105         require(_value <= allowance[_from][msg.sender]);
106         allowance[_from][msg.sender] -= _value;
107         _transfer(_from, _to, _value);
108         return true;
109     }
110 
111     /**
112      * Set allowance for other address
113      *
114      * Allows `_spender` to spend no more than `_value` tokens on your behalf
115      *
116      * @param _spender The address authorized to spend
117      * @param _value the max amount they can spend
118      */
119     function approve(address _spender, uint256 _value) public
120         returns (bool success) {
121         allowance[msg.sender][_spender] = _value;
122         return true;
123     }
124 
125     /**
126      * Set allowance for other address and notify
127      *
128      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
129      *
130      * @param _spender The address authorized to spend
131      * @param _value the max amount they can spend
132      * @param _extraData some extra information to send to the approved contract
133      */
134     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
135         public
136         returns (bool success) {
137         tokenRecipient spender = tokenRecipient(_spender);
138         if (approve(_spender, _value)) {
139             spender.receiveApproval(msg.sender, _value, this, _extraData);
140             return true;
141         }
142     }
143 
144     /**
145      * Destroy tokens
146      *
147      * Remove `_value` tokens from the system irreversibly
148      *
149      * @param _value the amount of money to burn
150      */
151     function burn(uint256 _value) public returns (bool success) {
152         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
153         balanceOf[msg.sender] -= _value;            // Subtract from the sender
154         totalSupply -= _value;                      // Updates totalSupply
155         Burn(msg.sender, _value);
156         return true;
157     }
158 
159     /**
160      * Destroy tokens from other account
161      *
162      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
163      *
164      * @param _from the address of the sender
165      * @param _value the amount of money to burn
166      */
167     function burnFrom(address _from, uint256 _value) public returns (bool success) {
168         require(balanceOf[_from] >= _value);
169         require(_value <= allowance[_from][msg.sender]);
170         balanceOf[_from] -= _value;
171         allowance[_from][msg.sender] -= _value;
172         totalSupply -= _value;
173         Burn(_from, _value);
174         return true;
175     }
176 }