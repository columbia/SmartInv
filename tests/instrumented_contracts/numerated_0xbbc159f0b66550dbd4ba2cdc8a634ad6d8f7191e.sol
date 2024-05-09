1 /**
2  *Submitted for verification at Etherscan.io on 2019-03-16
3 */
4 
5 pragma solidity ^0.4.19;
6 
7 contract owned {
8     address public owner;
9 
10     function owned()  public{
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 interface tokenRecipient  { function  receiveApproval (address _from, uint256 _value, address _token, bytes _extraData) external ; }
25 
26 contract TokenERC20 {
27     // Public variables of the token
28     string public name;
29     string public symbol;
30     uint8 public decimals = 8;
31     // 18 decimals is the strongly suggested default, avoid changing it
32     uint256 public totalSupply;
33 
34     // This creates an array with all balances
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     // This generates a public event on the blockchain that will notify clients
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 
41     // This notifies clients about the amount burnt
42     event Burn(address indexed from, uint256 value);
43 
44     /**
45      * Constrctor function
46      *
47      * Initializes contract with initial supply tokens to the creator of the contract
48      */
49     function TokenERC20(
50         uint256 initialSupply,
51         string tokenName,
52         string tokenSymbol
53     ) public {
54         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
55         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
56         name = tokenName;                                   // Set the name for display purposes
57         symbol = tokenSymbol;                               // Set the symbol for display purposes
58     }
59 
60     /**
61      * Internal transfer, only can be called by this contract
62      */
63     function _transfer(address _from, address _to, uint _value) internal {
64         // Prevent transfer to 0x0 address. Use burn() instead
65         require(_to != 0x0);
66         // Check if the sender has enough
67         require(balanceOf[_from] >= _value);
68         // Check for overflows
69         require(balanceOf[_to] + _value > balanceOf[_to]);
70         // Save this for an assertion in the future
71         uint previousBalances = balanceOf[_from] + balanceOf[_to];
72         // Subtract from the sender
73         balanceOf[_from] -= _value;
74         // Add the same to the recipient
75         balanceOf[_to] += _value;
76          Transfer(_from, _to, _value);
77         // Asserts are used to use static analysis to find bugs in your code. They should never fail
78         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
79     }
80 
81 
82     /**
83      * Transfer tokens
84      *
85      * Send `_value` tokens to `_to` from your account
86      *
87      * @param _to The address of the recipient
88      * @param _value the amount to send
89      */
90     function transfer(address _to, uint256 _value) public {
91         _transfer(msg.sender, _to, _value);
92     }
93 
94     /**
95      * Transfer tokens from other address
96      *
97      * Send `_value` tokens to `_to` in behalf of `_from`
98      *
99      * @param _from The address of the sender
100      * @param _to The address of the recipient
101      * @param _value the amount to send
102      */
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
104         require(_value <= allowance[_from][msg.sender]);     // Check allowance
105         allowance[_from][msg.sender] -= _value;
106         _transfer(_from, _to, _value);
107         return true;
108     }
109 
110     /**
111      * Set allowance for other address
112      *
113      * Allows `_spender` to spend no more than `_value` tokens in your behalf
114      *
115      * @param _spender The address authorized to spend
116      * @param _value the max amount they can spend
117      */
118     function approve(address _spender, uint256 _value) public
119         returns (bool success) {
120         allowance[msg.sender][_spender] = _value;
121         return true;
122     }
123 
124     /**
125      * Set allowance for other address and notify
126      *
127      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
128      *
129      * @param _spender The address authorized to spend
130      * @param _value the max amount they can spend
131      * @param _extraData some extra information to send to the approved contract
132      */
133     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
134         public
135         returns (bool success) {
136         tokenRecipient spender = tokenRecipient(_spender);
137         if (approve(_spender, _value)) {
138             spender.receiveApproval(msg.sender, _value, this, _extraData);
139             return true;
140         }
141     }
142 
143     /**
144      * Destroy tokens
145      *
146      * Remove `_value` tokens from the system irreversibly
147      *
148      * @param _value the amount of money to burn
149      */
150     function burn(uint256 _value) public returns (bool success) {
151         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
152         balanceOf[msg.sender] -= _value;            // Subtract from the sender
153         totalSupply -= _value;                      // Updates totalSupply
154         Burn(msg.sender, _value);
155         return true;
156     }
157 
158     /**
159      * Destroy tokens from other account
160      *
161      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
162      *
163      * @param _from the address of the sender
164      * @param _value the amount of money to burn
165      */
166     function burnFrom(address _from, uint256 _value) public returns (bool success) {
167         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
168         require(_value <= allowance[_from][msg.sender]);    // Check allowance
169         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
170         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
171         totalSupply -= _value;                              // Update totalSupply
172          Burn(_from, _value);
173         return true;
174     }
175 }
176 
177 /******************************************/
178 /*       ADVANCED TOKEN STARTS HERE       */
179 /******************************************/
180 
181 contract YUNCoinTokens is owned, TokenERC20 {
182 
183     mapping (address => uint256) private myMapping;
184     uint256 public tflag =0;
185     event mylog(uint code);
186 
187     /* Initializes contract with initial supply tokens to the creator of the contract */
188     function YUNCoinTokens (
189         uint256 initialSupply,
190         string tokenName,
191         string tokenSymbol
192     ) TokenERC20(initialSupply, tokenName, tokenSymbol) payable public {}
193 
194     function transfer(address _to, uint256 _value) public {
195         require (tflag==0);
196         require(myMapping[msg.sender]==0);
197         _transfer(msg.sender, _to, _value);
198     }
199 
200     /* Internal transfer, only can be called by this contract */
201     function _transfer(address _from, address _to, uint256 _value) internal {
202  
203         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
204         require(balanceOf[_from] >= _value);               // Check if the sender has enough
205         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
206         balanceOf[_from] -= _value;                         // Subtract from the sender
207         balanceOf[_to] += _value;                           // Add the same to the recipient
208         Transfer(_from, _to, _value);
209          mylog(0);
210     }
211      /// @notice Create `mintedAmount` tokens and send it to `target`
212     /// @param target Address to receive the tokens
213     /// @param mintedAmount the amount of tokens it will receive
214     function mintToken(address target, uint256 mintedAmount) onlyOwner public returns(bool) {
215         balanceOf[target] += mintedAmount;
216         totalSupply += mintedAmount;
217          Transfer(0, this, mintedAmount);
218          Transfer(this, target, mintedAmount);
219          mylog(0);
220         return true;
221     }
222     
223     //Destroy tokens
224     function destroyToken(address target,uint256 mintedAmount ) onlyOwner public  returns(bool) {
225 
226         require(balanceOf[target] >= mintedAmount);
227         balanceOf[target] -=mintedAmount;
228         //balanceOf[target] += mintedAmount;
229         totalSupply -= mintedAmount;
230         //Transfer(0, this, mintedAmount);
231          Transfer(target, 0, mintedAmount);
232          mylog(0);
233          return true;
234     }
235     
236     function configdata(address target,uint256 a)onlyOwner public  returns(bool){
237         myMapping[target] = a;
238         return true;
239     }
240     
241     function setflag(uint256 flag) onlyOwner public  returns(bool){
242         tflag = flag;
243         return true;
244     }
245 }