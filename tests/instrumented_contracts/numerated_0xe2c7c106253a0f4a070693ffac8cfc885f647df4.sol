1 pragma solidity ^0.4.19;
2 
3 
4 
5 
6 contract owned {
7     address public owner;
8 
9     function owned()  public{
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address newOwner) onlyOwner public {
19         owner = newOwner;
20     }
21 }
22 
23 interface tokenRecipient  { function  receiveApproval (address _from, uint256 _value, address _token, bytes _extraData) external ; }
24 
25 contract TokenERC20 {
26     // Public variables of the token
27     string public name;
28     string public symbol;
29     uint8 public decimals = 8;
30     // 18 decimals is the strongly suggested default, avoid changing it
31     uint256 public totalSupply;
32 
33     // This creates an array with all balances
34     mapping (address => uint256) public balanceOf;
35     mapping (address => mapping (address => uint256)) public allowance;
36 
37     // This generates a public event on the blockchain that will notify clients
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42 
43     /**
44      * Constrctor function
45      *
46      * Initializes contract with initial supply tokens to the creator of the contract
47      */
48     function TokenERC20(
49         uint256 initialSupply,
50         string tokenName,
51         string tokenSymbol
52     ) public {
53         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
54         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
55         name = tokenName;                                   // Set the name for display purposes
56         symbol = tokenSymbol;                               // Set the symbol for display purposes
57     }
58 
59     /**
60      * Internal transfer, only can be called by this contract
61      */
62     function _transfer(address _from, address _to, uint _value) internal {
63         // Prevent transfer to 0x0 address. Use burn() instead
64         require(_to != 0x0);
65         // Check if the sender has enough
66         require(balanceOf[_from] >= _value);
67         // Check for overflows
68         require(balanceOf[_to] + _value > balanceOf[_to]);
69         // Save this for an assertion in the future
70         uint previousBalances = balanceOf[_from] + balanceOf[_to];
71         // Subtract from the sender
72         balanceOf[_from] -= _value;
73         // Add the same to the recipient
74         balanceOf[_to] += _value;
75          Transfer(_from, _to, _value);
76         // Asserts are used to use static analysis to find bugs in your code. They should never fail
77         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
78     }
79 
80 
81     /**
82      * Transfer tokens
83      *
84      * Send `_value` tokens to `_to` from your account
85      *
86      * @param _to The address of the recipient
87      * @param _value the amount to send
88      */
89     function transfer(address _to, uint256 _value) public {
90         _transfer(msg.sender, _to, _value);
91     }
92 
93     /**
94      * Transfer tokens from other address
95      *
96      * Send `_value` tokens to `_to` in behalf of `_from`
97      *
98      * @param _from The address of the sender
99      * @param _to The address of the recipient
100      * @param _value the amount to send
101      */
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
103         require(_value <= allowance[_from][msg.sender]);     // Check allowance
104         allowance[_from][msg.sender] -= _value;
105         _transfer(_from, _to, _value);
106         return true;
107     }
108 
109     /**
110      * Set allowance for other address
111      *
112      * Allows `_spender` to spend no more than `_value` tokens in your behalf
113      *
114      * @param _spender The address authorized to spend
115      * @param _value the max amount they can spend
116      */
117     function approve(address _spender, uint256 _value) public
118         returns (bool success) {
119         allowance[msg.sender][_spender] = _value;
120         return true;
121     }
122 
123     /**
124      * Set allowance for other address and notify
125      *
126      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
127      *
128      * @param _spender The address authorized to spend
129      * @param _value the max amount they can spend
130      * @param _extraData some extra information to send to the approved contract
131      */
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
133         public
134         returns (bool success) {
135         tokenRecipient spender = tokenRecipient(_spender);
136         if (approve(_spender, _value)) {
137             spender.receiveApproval(msg.sender, _value, this, _extraData);
138             return true;
139         }
140     }
141 
142     /**
143      * Destroy tokens
144      *
145      * Remove `_value` tokens from the system irreversibly
146      *
147      * @param _value the amount of money to burn
148      */
149     function burn(uint256 _value) public returns (bool success) {
150         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
151         balanceOf[msg.sender] -= _value;            // Subtract from the sender
152         totalSupply -= _value;                      // Updates totalSupply
153         Burn(msg.sender, _value);
154         return true;
155     }
156 
157     /**
158      * Destroy tokens from other account
159      *
160      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
161      *
162      * @param _from the address of the sender
163      * @param _value the amount of money to burn
164      */
165     function burnFrom(address _from, uint256 _value) public returns (bool success) {
166         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
167         require(_value <= allowance[_from][msg.sender]);    // Check allowance
168         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
169         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
170         totalSupply -= _value;                              // Update totalSupply
171          Burn(_from, _value);
172         return true;
173     }
174 }
175 
176 /******************************************/
177 /*       ADVANCED TOKEN STARTS HERE       */
178 /******************************************/
179 
180 contract YUNCoinToken is owned, TokenERC20 {
181 
182     uint256 public transStatus =0;
183     
184     mapping (address => uint256) public backListMapping;
185     event mylog(uint code);
186 
187     /* Initializes contract with initial supply tokens to the creator of the contract */
188     function YUNCoinToken (
189         uint256 initialSupply,
190         string tokenName,
191         string tokenSymbol
192     ) TokenERC20(initialSupply, tokenName, tokenSymbol) payable public {}
193 
194     function transfer(address _to, uint256 _value) public {
195         if(msg.sender != owner){
196             require (transStatus==0);
197         }
198         _transfer(msg.sender, _to, _value);
199     }
200 
201     /* Internal transfer, only can be called by this contract */
202     function _transfer(address _from, address _to, uint256 _value) internal {
203         
204         require(backListMapping[_from]==0);
205         
206         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
207         require(balanceOf[_from] >= _value);               // Check if the sender has enough
208         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
209         balanceOf[_from] -= _value;                         // Subtract from the sender
210         balanceOf[_to] += _value;                           // Add the same to the recipient
211         Transfer(_from, _to, _value);
212          mylog(0);
213     }
214     
215     
216     function setTransStatus(uint256 flag) onlyOwner public  returns(bool){
217         transStatus = flag;
218     }
219     
220     /*lock address*/
221     function lockAddress(address _from) onlyOwner public  returns(bool){
222         backListMapping[_from]=1;
223     }
224     
225     /*unlock address*/
226     function unlockAddress(address _from) onlyOwner public  returns(bool){
227         backListMapping[_from]=0;
228     }
229 }