1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 
6 contract SafeMath {  
7     uint256 constant public MAX_UINT256 =0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
8 
9   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b > 0);
17     uint256 c = a / b;
18     assert(a == b * c + a % b);
19     return c;
20   }
21   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract MITToken is SafeMath{
34     // Public variables of the token
35     string public name;
36     string public symbol;
37     uint8 public decimals = 18;
38     // 18 decimals is the strongly suggested default, avoid changing it
39     uint256 public totalSupply;
40     address public owner;
41 
42     // This creates an array with all balances
43     mapping (address => uint256) public balanceOf;
44     mapping (address => mapping (address => uint256)) public allowance;
45     
46     mapping(uint => Holder) public lockholders;
47     uint public lockholderNumber;
48     struct Holder {
49           address eth_address;
50           uint exp_time;
51          
52       }
53     
54     // This generates a public event on the blockchain that will notify clients
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 
57     // This notifies clients about the amount burnt
58     event Burn(address indexed from, uint256 value);
59 
60     /**
61      * Constructor function
62      *
63      * Initializes contract with initial supply tokens to the creator of the contract
64      */
65   constructor () public {
66         totalSupply = 10000000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
67         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
68         name = "Mundellian Infrastructure Technology";                                   // Set the name for display purposes
69         symbol = "MIT";                               // Set the symbol for display purposes
70         
71          owner = msg.sender;
72     }
73   
74     /**
75      * Internal transfer, only can be called by this contract
76      */
77     function _transfer(address _from, address _to, uint _value) internal {
78         // Prevent transfer to 0x0 address. Use burn() instead
79         require(_to != 0x0);
80         
81         require(validHolder(_from));
82         
83         // Check if the sender has enough
84         require(balanceOf[_from] >= _value);
85         // Check for overflows
86         require(balanceOf[_to] <= MAX_UINT256 - _value);
87         require(balanceOf[_to] + _value >= balanceOf[_to]);
88         // Save this for an assertion in the future
89         uint previousBalances = balanceOf[_from] + balanceOf[_to];
90         // Subtract from the sender
91         balanceOf[_from] = safeSub(balanceOf[_from], _value);
92         // Add the same to the recipient
93         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
94         emit Transfer(_from, _to, _value);
95         // Asserts are used to use static analysis to find bugs in your code. They should never fail
96         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
97     }
98 
99     /**
100      * Transfer tokens
101      *
102      * Send `_value` tokens to `_to` from your account
103      *
104      * @param _to The address of the recipient
105      * @param _value the amount to send
106      */
107     function transfer(address _to, uint256 _value) public {
108         _transfer(msg.sender, _to, _value);
109     }
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
159 
160     /**
161      * Destroy tokens
162      *
163      * Remove `_value` tokens from the system irreversibly
164      *
165      * @param _value the amount of money to burn
166      */
167     function burn(uint256 _value) public returns (bool success) {
168         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
169         balanceOf[msg.sender] -= _value;            // Subtract from the sender
170         totalSupply -= _value;                      // Updates totalSupply
171         emit Burn(msg.sender, _value);
172         return true;
173     }
174 
175     /**
176      * Destroy tokens from other account
177      *
178      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
179      *
180      * @param _from the address of the sender
181      * @param _value the amount of money to burn
182      */
183     function burnFrom(address _from, uint256 _value) public returns (bool success) {
184         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
185         require(_value <= allowance[_from][msg.sender]);    // Check allowance
186         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
187         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
188         totalSupply -= _value;                              // Update totalSupply
189         emit Burn(_from, _value);
190         return true;
191     }
192     
193 function _lockToken(address addr,uint expireTime) public payable returns (bool) {
194     require(msg.sender == owner);
195     for(uint i = 0; i < lockholderNumber; i++) {
196       if (lockholders[i].eth_address == addr) {
197           lockholders[i].exp_time = expireTime;
198         return true;
199       }
200     }
201     lockholders[lockholderNumber]=Holder(addr,expireTime);
202     lockholderNumber++;
203     return true;
204   }
205   
206 function _unlockToken(address addr) public payable returns (bool){
207     require(msg.sender == owner);
208     for(uint i = 0; i < lockholderNumber; i++) {
209       if (lockholders[i].eth_address == addr) {
210           delete lockholders[i];
211         return true;
212       }
213     }
214     return true;
215   }
216   
217   function validHolder(address addr) public constant returns (bool) {
218     for(uint i = 0; i < lockholderNumber; i++) {
219       if (lockholders[i].eth_address == addr && now <lockholders[i].exp_time) {
220         return false;
221       }
222     }
223     return true;
224   }
225 }