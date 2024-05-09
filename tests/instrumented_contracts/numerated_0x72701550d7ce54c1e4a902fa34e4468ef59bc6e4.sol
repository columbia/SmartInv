1 pragma solidity ^0.5.12;
2 
3 library address_make_payable {
4    function make_payable(address x) internal pure returns (address payable) {
5       return address(uint160(x));
6    }
7 }
8 
9 contract owned {
10     
11     using address_make_payable for address;
12      
13     address payable public owner;
14 
15     constructor()  public{
16         owner = msg.sender;
17     }
18 
19     modifier onlyOwner {
20         require(msg.sender == owner);
21         _;
22     }
23 
24     function transferOwnership(address newOwner) onlyOwner public {
25         address payable addr = address(newOwner).make_payable();
26         owner = addr;
27     }
28 }
29 
30 interface tokenRecipient  { function  receiveApproval (address  _from, uint256  _value, address  _token, bytes calldata _extraData) external ; }
31 
32 contract TokenERC20 {
33     // Public variables of the token
34     string public name;
35     string public symbol;
36     uint8 public decimals = 8;
37     // 18 decimals is the strongly suggested default, avoid changing it
38     uint256 public totalSupply;
39 
40     // This creates an array with all balances
41     mapping (address => uint256) public balanceOf;
42     mapping (address => mapping (address => uint256)) public allowance;
43 
44     // This generates a public event on the blockchain that will notify clients
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47     // This notifies clients about the amount burnt
48     event Burn(address indexed from, uint256 value);
49 
50     /**
51      * Constrctor function
52      *
53      * Initializes contract with initial supply tokens to the creator of the contract
54      */
55     constructor(
56         uint256 initialSupply,
57          string memory tokenName,
58          string memory tokenSymbol
59     ) public {
60         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
61         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
62         name = tokenName;                                   // Set the name for display purposes
63         symbol = tokenSymbol;                               // Set the symbol for display purposes
64     }
65 
66     /**
67      * Internal transfer, only can be called by this contract
68      */
69     function _transfer(address _from, address _to, uint _value) internal {
70         // Prevent transfer to 0x0 address. Use burn() instead
71         //require(_to != 0x0);
72         assert(_to != address(0x0));
73         // Check if the sender has enough
74         require(balanceOf[_from] >= _value);
75         // Check for overflows
76         require(balanceOf[_to] + _value > balanceOf[_to]);
77         // Save this for an assertion in the future
78         uint previousBalances = balanceOf[_from] + balanceOf[_to];
79         // Subtract from the sender
80         balanceOf[_from] -= _value;
81         // Add the same to the recipient
82         balanceOf[_to] += _value;
83         emit Transfer(_from, _to, _value);
84         // Asserts are used to use static analysis to find bugs in your code. They should never fail
85         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
86     }
87 
88 
89     /**
90      * Transfer tokens
91      *
92      * Send `_value` tokens to `_to` from your account
93      *
94      * @param _to The address of the recipient
95      * @param _value the amount to send
96      */
97     function transfer(address _to, uint256 _value) public {
98         _transfer(msg.sender, _to, _value);
99     }
100 
101     /**
102      * Transfer tokens from other address
103      *
104      * Send `_value` tokens to `_to` in behalf of `_from`
105      *
106      * @param _from The address of the sender
107      * @param _to The address of the recipient
108      * @param _value the amount to send
109      */
110     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
111         require(_value <= allowance[_from][msg.sender]);     // Check allowance
112         allowance[_from][msg.sender] -= _value;
113         _transfer(_from, _to, _value);
114         return true;
115     }
116 
117     /**
118      * Set allowance for other address
119      *
120      * Allows `_spender` to spend no more than `_value` tokens in your behalf
121      *
122      * @param _spender The address authorized to spend
123      * @param _value the max amount they can spend
124      */
125     function approve(address _spender, uint256 _value) public
126         returns (bool success) {
127         allowance[msg.sender][_spender] = _value;
128         return true;
129     }
130 
131     /**
132      * Set allowance for other address and notify
133      *
134      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
135      *
136      * @param _spender The address authorized to spend
137      * @param _value the max amount they can spend
138      * @param _extraData some extra information to send to the approved contract
139      */
140     function approveAndCall(address _spender, uint256  _value, bytes memory _extraData)
141         public
142         returns (bool success) {
143         tokenRecipient spender = tokenRecipient(_spender);
144         if (approve(_spender, _value)) {
145             spender.receiveApproval(msg.sender, _value, address(this),  _extraData);
146             return true;
147         }
148     }
149 
150     /**
151      * Destroy tokens
152      *
153      * Remove `_value` tokens from the system irreversibly
154      *
155      * @param _value the amount of money to burn
156      */
157     function burn(uint256 _value) public returns (bool success) {
158         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
159         balanceOf[msg.sender] -= _value;            // Subtract from the sender
160         totalSupply -= _value;                      // Updates totalSupply
161         emit Burn(msg.sender, _value);
162         return true;
163     }
164 
165     /**
166      * Destroy tokens from other account
167      *
168      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
169      *
170      * @param _from the address of the sender
171      * @param _value the amount of money to burn
172      */
173     function burnFrom(address _from, uint256 _value) public returns (bool success) {
174         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
175         require(_value <= allowance[_from][msg.sender]);    // Check allowance
176         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
177         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
178         totalSupply -= _value;                              // Update totalSupply
179         emit Burn(_from, _value);
180         return true;
181     }
182 }
183 
184 /******************************************/
185 /*       ADVANCED TOKEN STARTS HERE       */
186 /******************************************/
187 
188 contract ACPEToken is owned, TokenERC20 {
189 
190 
191 
192     event mylog(uint code);
193 
194     /* Initializes contract with initial supply tokens to the creator of the contract */
195     constructor(
196         uint256 initialSupply,
197         string memory tokenName,
198         string memory tokenSymbol
199     ) TokenERC20(initialSupply, tokenName, tokenSymbol) payable public {}
200 
201     function transfer(address _to, uint256 _value) public {
202      
203         _transfer(msg.sender, _to, _value);
204     }
205 
206     /* Internal transfer, only can be called by this contract */
207     function _transfer(address _from, address _to, uint256 _value) internal {
208         assert(_to != address(0x0));
209         //require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
210         require(balanceOf[_from] >= _value);               // Check if the sender has enough
211         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
212         balanceOf[_from] -= _value;                         // Subtract from the sender
213         balanceOf[_to] += _value;                           // Add the same to the recipient
214         emit Transfer(_from, _to, _value);
215         emit mylog(0);
216     }
217  
218 }