1 //created by Quanli Technology (Hong Kong) Limited; www.quan-li.com
2 pragma solidity ^0.4.24;
3 
4 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
5 
6 contract TokenERC20 {
7      address public owner; // current owner of the contract
8      uint256 public feesA = 10; 
9      address public addressA =  0x82914CFc37c46fbbb830150cF2330B80DAADa2D5;
10 
11      
12 function founder() private {  // contract's constructor function
13         owner = msg.sender;
14         }
15 function change_owner (address newOwner) public{
16         require(owner == msg.sender);
17         owner = newOwner;
18         emit Changeownerlog(newOwner);
19     }
20     
21 function setfees (uint256 _value1) public {
22       require(owner == msg.sender);
23       if (_value1>0){
24       feesA = _value1;
25       emit Setfeeslog(_value1);
26       }else {
27           
28       }
29 }
30     
31 function setaddress (address _address1) public {
32    require(owner == msg.sender);
33    addressA = _address1;
34    emit Setfeeaddrlog(_address1);
35    }
36 
37     
38     // Public variables of the token
39     string public name;
40     string public symbol;
41     uint8 public decimals = 18;
42     // 18 decimals is the strongly suggested default, avoid changing it
43     uint256 public totalSupply;
44     
45     
46     // This creates an array with all balances
47     mapping (address => uint256) public balanceOf;
48     mapping (address => mapping (address => uint256)) public allowance;
49 
50     // This generates a public event on the blockchain that will notify clients
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Fee1(address indexed from, address indexed to, uint256 value);
53     // Reissue
54     event Reissuelog(uint256 value);
55     // This notifies clients about the amount burnt
56     event Burn(address indexed from, uint256 value); 
57     //setfees
58     event Setfeeslog(uint256 fee1);
59     //setfeeaddress
60     event Setfeeaddrlog(address);
61     //changeowner
62     event Changeownerlog(address);
63         
64      /**
65      * Constrctor function
66      *
67      * Initializes contract with initial supply tokens to the creator of the contract
68      */
69     function TokenERC20(
70         uint256 initialSupply,
71         string tokenName,
72         string tokenSymbol
73     ) public {
74         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
75         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
76         name = tokenName;                                   // Set the name for display purposes
77         symbol = tokenSymbol;                               // Set the symbol for display purposes
78         owner = msg.sender;                                 // Set contract owner
79     }
80 
81     /**
82      * Internal transfer, only can be called by this contract
83      */
84     function _transfer(address _from, address _to, uint _value) internal {
85         // Prevent transfer to 0x0 address. Use burn() instead
86         require(_to != 0x0);
87         // Check if the sender has enough
88         require(balanceOf[_from] >= _value);
89         // Check for overflows
90         require(balanceOf[_to] + _value > balanceOf[_to]);
91         // Save this for an assertion in the future
92         uint previousBalances = balanceOf[_from] + balanceOf[_to];
93         // Subtract from the sender
94         balanceOf[_from] -= _value;
95         // Add the same to the recipient
96         balanceOf[_to] += _value;
97         // Asserts are used to use static analysis to find bugs in your code. They should never fail
98         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
99         
100     }
101 
102     /**
103      * Transfer tokens
104      *
105      * Send `_value` tokens to `_to` from your account
106      *
107      * @param _to The address of the recipient
108      * @param _value the amount to send
109      */
110 
111     /**
112      * Transfer tokens from other address
113      *
114      * Send `_value` tokens to `_to` on behalf of `_from`
115      *
116      * @param _from The address of the sender
117      * @param _to The address of the recipient
118      * @param _value the amount to send
119      */
120     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
121         require(_value <= allowance[_from][msg.sender]);     // Check allowance
122         allowance[_from][msg.sender] -= _value;
123         _transfer(_from, _to, _value);
124         return true;
125     }
126 
127     /**
128      * Set allowance for other address
129      *
130      * Allows `_spender` to spend no more than `_value` tokens on your behalf
131      *
132      * @param _spender The address authorized to spend
133      * @param _value the max amount they can spend
134      */
135     function approve(address _spender, uint256 _value) public
136         returns (bool success) {
137         allowance[msg.sender][_spender] = _value;
138         return true;
139     }
140 
141     /**
142      * Set allowance for other address and notify
143      *
144      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
145      *
146      * @param _spender The address authorized to spend
147      * @param _value the max amount they can spend
148      * @param _extraData some extra information to send to the approved contract
149      */
150     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
151         public
152         returns (bool success) {
153         tokenRecipient spender = tokenRecipient(_spender);
154         if (approve(_spender, _value)) {
155             spender.receiveApproval(msg.sender, _value, this, _extraData);
156             return true;
157         }
158     }
159     /**
160      * Destroy tokens
161      *
162      * Remove `_value` tokens from the system irreversibly
163      *
164      * @param _value the amount of money to burn
165      */
166     function burn(uint256 _value) public returns (bool success) {
167         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
168         balanceOf[msg.sender] -= _value;            // Subtract from the sender
169         totalSupply -= _value;                      // Updates totalSupply
170         emit Burn(msg.sender, _value);
171         return true;
172     }
173     /**
174      * Destroy tokens from other account
175      *
176      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
177      *
178      * @param _from the address of the sender
179      * @param _value the amount of money to burn
180      */
181     function burnFrom(address _from, uint256 _value) public returns (bool success) {
182         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
183         require(_value <= allowance[_from][msg.sender]);    // Check allowance
184         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
185         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
186         totalSupply -= _value;                              // Update totalSupply
187         emit Burn(_from, _value);
188         return true;
189     }
190     
191     function transfer(address _to, uint256 _value) public {
192         uint256 fees1 = (feesA *_value)/10000;
193         _value -= (fees1);
194         _transfer(msg.sender, _to, _value);
195         emit Transfer(msg.sender, _to, _value);
196         _transfer(msg.sender, addressA, fees1);
197         emit Fee1(msg.sender, addressA, fees1);
198 
199         }
200             
201 
202     function Reissue(uint256 _value) public  {
203         require(owner == msg.sender);
204         balanceOf[msg.sender] += _value;            // Add to the sender
205         totalSupply += _value;                      // Updates totalSupply
206         emit Reissuelog(_value);
207     }
208     
209 }