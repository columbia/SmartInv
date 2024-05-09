1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract TokenERC20 {
6      address public owner; // current owner of the contract
7      uint256 public feesA = 1; 
8      uint256 public feesB = 1; 
9      uint256 public feesC = 1; 
10      uint256 public feesD = 1; 
11      address public addressA = 0xC61994B01607Ed7351e1D4FEE93fb0e661ceE39c;
12      address public addressB = 0x821D44F1d04936e8b95D2FFAE91DFDD6E6EA39F9;
13      address public addressC = 0xf193c2EC62466fd338710afab04574E7Eeb6C0e2;
14      address public addressD = 0x3105889390F894F8ee1d3f8f75E2c4dde57735bA;
15      
16 function founder() private {  // contract's constructor function
17         owner = msg.sender;
18         }
19 function change_owner (address newOwner) public{
20         require(owner == msg.sender);
21         owner = newOwner;
22         emit Changeownerlog(newOwner);
23     }
24     
25 function setfees (uint256 _value1, uint256 _value2, uint256 _value3, uint256 _value4) public {
26       require(owner == msg.sender);
27       if (_value1>0 && _value2>0 && _value3>0 &&_value4>0){
28       feesA = _value1;
29       feesB = _value2;
30       feesC = _value3;
31       feesD = _value4;
32       emit Setfeeslog(_value1,_value2,_value3,_value4);
33       }else {
34           
35       }
36 }
37     
38 function setaddress (address _address1, address _address2, address _address3, address _address4) public {
39    require(owner == msg.sender);
40    addressA = _address1;
41    addressB = _address2;
42    addressC = _address3;
43    addressD = _address4;
44    emit Setfeeaddrlog(_address1,_address2,_address3,_address4);
45    }
46 
47     
48     // Public variables of the token
49     string public name;
50     string public symbol;
51     uint8 public decimals = 18;
52     // 18 decimals is the strongly suggested default, avoid changing it
53     uint256 public totalSupply;
54     
55     
56     // This creates an array with all balances
57     mapping (address => uint256) public balanceOf;
58     mapping (address => mapping (address => uint256)) public allowance;
59 
60     // This generates a public event on the blockchain that will notify clients
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Fee1(address indexed from, address indexed to, uint256 value);
63     event Fee2(address indexed from, address indexed to, uint256 value);
64     event Fee3(address indexed from, address indexed to, uint256 value);
65     event Fee4(address indexed from, address indexed to, uint256 value);
66     // Reissue
67     event Reissuelog(uint256 value);
68     // This notifies clients about the amount burnt
69     event Burn(address indexed from, uint256 value); 
70     //setfees
71     event Setfeeslog(uint256 fee1,uint256 fee2,uint256 fee3,uint256 fee4);
72     //setfeeaddress
73     event Setfeeaddrlog(address,address,address,address);
74     //changeowner
75     event Changeownerlog(address);
76         
77      /**
78      * Constrctor function
79      *
80      * Initializes contract with initial supply tokens to the creator of the contract
81      */
82     function TokenERC20(
83         uint256 initialSupply,
84         string tokenName,
85         string tokenSymbol
86     ) public {
87         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
88         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
89         name = tokenName;                                   // Set the name for display purposes
90         symbol = tokenSymbol;                               // Set the symbol for display purposes
91         owner = msg.sender;                                 // Set contract owner
92     }
93 
94     /**
95      * Internal transfer, only can be called by this contract
96      */
97     function _transfer(address _from, address _to, uint _value) internal {
98         // Prevent transfer to 0x0 address. Use burn() instead
99         require(_to != 0x0);
100         // Check if the sender has enough
101         require(balanceOf[_from] >= _value);
102         // Check for overflows
103         require(balanceOf[_to] + _value > balanceOf[_to]);
104         // Save this for an assertion in the future
105         uint previousBalances = balanceOf[_from] + balanceOf[_to];
106         // Subtract from the sender
107         balanceOf[_from] -= _value;
108         // Add the same to the recipient
109         balanceOf[_to] += _value;
110         // Asserts are used to use static analysis to find bugs in your code. They should never fail
111         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
112         
113     }
114 
115     /**
116      * Transfer tokens
117      *
118      * Send `_value` tokens to `_to` from your account
119      *
120      * @param _to The address of the recipient
121      * @param _value the amount to send
122      */
123 
124     /**
125      * Transfer tokens from other address
126      *
127      * Send `_value` tokens to `_to` on behalf of `_from`
128      *
129      * @param _from The address of the sender
130      * @param _to The address of the recipient
131      * @param _value the amount to send
132      */
133     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
134         require(_value <= allowance[_from][msg.sender]);     // Check allowance
135         allowance[_from][msg.sender] -= _value;
136         _transfer(_from, _to, _value);
137         return true;
138     }
139 
140     /**
141      * Set allowance for other address
142      *
143      * Allows `_spender` to spend no more than `_value` tokens on your behalf
144      *
145      * @param _spender The address authorized to spend
146      * @param _value the max amount they can spend
147      */
148     function approve(address _spender, uint256 _value) public
149         returns (bool success) {
150         allowance[msg.sender][_spender] = _value;
151         return true;
152     }
153 
154     /**
155      * Set allowance for other address and notify
156      *
157      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
158      *
159      * @param _spender The address authorized to spend
160      * @param _value the max amount they can spend
161      * @param _extraData some extra information to send to the approved contract
162      */
163     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
164         public
165         returns (bool success) {
166         tokenRecipient spender = tokenRecipient(_spender);
167         if (approve(_spender, _value)) {
168             spender.receiveApproval(msg.sender, _value, this, _extraData);
169             return true;
170         }
171     }
172     /**
173      * Destroy tokens
174      *
175      * Remove `_value` tokens from the system irreversibly
176      *
177      * @param _value the amount of money to burn
178      */
179     function burn(uint256 _value) public returns (bool success) {
180         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
181         balanceOf[msg.sender] -= _value;            // Subtract from the sender
182         totalSupply -= _value;                      // Updates totalSupply
183         emit Burn(msg.sender, _value);
184         return true;
185     }
186     /**
187      * Destroy tokens from other account
188      *
189      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
190      *
191      * @param _from the address of the sender
192      * @param _value the amount of money to burn
193      */
194     function burnFrom(address _from, uint256 _value) public returns (bool success) {
195         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
196         require(_value <= allowance[_from][msg.sender]);    // Check allowance
197         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
198         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
199         totalSupply -= _value;                              // Update totalSupply
200         emit Burn(_from, _value);
201         return true;
202     }
203     
204     function transfer(address _to, uint256 _value) public {
205         uint256 fees1 = (feesA *_value)/10000;
206         uint256 fees2 = (feesB *_value)/10000;
207         uint256 fees3 = (feesC *_value)/10000;
208         uint256 fees4 = (feesD *_value)/10000;
209         _value -= (fees1+fees2+fees3+fees4);
210         _transfer(msg.sender, _to, _value);
211         emit Transfer(msg.sender, _to, _value);
212         _transfer(msg.sender, addressA, fees1);
213         emit Fee1(msg.sender, addressA, fees1);
214         _transfer(msg.sender, addressB, fees2);
215         emit Fee2(msg.sender, addressB, fees2);
216         _transfer(msg.sender, addressC, fees3);
217         emit Fee3(msg.sender, addressC, fees3);
218         _transfer(msg.sender, addressD, fees4);
219         emit Fee4(msg.sender, addressD, fees4);
220         }
221             
222 
223     function Reissue(uint256 _value) public  {
224         require(owner == msg.sender);
225         balanceOf[msg.sender] += _value;            // Add to the sender
226         totalSupply += _value;                      // Updates totalSupply
227         emit Reissuelog(_value);
228     }
229     
230 }