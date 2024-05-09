1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     uint8 public decimals = 18;
25     uint256 public totalSupply;
26     string public name = 'SuperDollar';                   
27     string public symbol= 'ISD';                 
28     string public version = 'https://www.superdollar.org';
29     address public fundsWallet = 0x632730f269b31678F6105F9a1b16cC0c09bDd9d1;
30     address public teamWallet = 0xDb3A1bF1583FB199c0aAAb11b1C98e2735402c93;
31     address public foundationWallet = 0x27Ff8115e3A98412eD11C4bAd180D55E6e3f8b0f;
32     address public investorWallet = 0x142b58d780222Da40Cd6AF348eDF0a1427CBDA9d;
33     // This creates an array with all balances
34     mapping (address => uint256) public balanceOf;
35     mapping (address => mapping (address => uint256)) public allowance;
36 
37     // This generates a public event on the blockchain that will notify clients
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41     /**
42      * Constrctor function
43      *
44      * Initializes contract with initial supply tokens to the creator of the contract
45      */
46     function TokenERC20( 
47 	) public {
48         totalSupply = 1000000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
49         balanceOf[fundsWallet] = totalSupply/100*51;        
50 	balanceOf[teamWallet] = totalSupply/100*10;		
51 	balanceOf[foundationWallet] = totalSupply/100*31;
52 	balanceOf[investorWallet] = totalSupply/100*8;	
53     }
54 
55     /**
56      * Internal transfer, only can be called by this contract
57      */
58     function _transfer(address _from, address _to, uint _value) internal {
59         // Prevent transfer to 0x0 address. Use burn() instead
60         require(_to != 0x0);
61         // Check if the sender has enough
62         require(balanceOf[_from] >= _value);
63         // Check for overflows
64         require(balanceOf[_to] + _value > balanceOf[_to]);
65         // Save this for an assertion in the future
66         uint previousBalances = balanceOf[_from] + balanceOf[_to];
67         // Subtract from the sender
68         balanceOf[_from] -= _value;
69         // Add the same to the recipient
70         balanceOf[_to] += _value;
71         Transfer(_from, _to, _value);
72         // Asserts are used to use static analysis to find bugs in your code. They should never fail
73         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
74     }
75 
76     /**
77      * Transfer tokens
78      *
79      * Send `_value` tokens to `_to` from your account
80      *
81      * @param _to The address of the recipient
82      * @param _value the amount to send
83      */
84     function transfer(address _to, uint256 _value) public {
85         _transfer(msg.sender, _to, _value);
86     }
87 
88     /**
89      * Transfer tokens from other address
90      *
91      * Send `_value` tokens to `_to` in behalf of `_from`
92      *
93      * @param _from The address of the sender
94      * @param _to The address of the recipient
95      * @param _value the amount to send
96      */
97     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
98         require(_value <= allowance[_from][msg.sender]);     // Check allowance
99         allowance[_from][msg.sender] -= _value;
100         _transfer(_from, _to, _value);
101         return true;
102     }
103 
104     /**
105      * Set allowance for other address
106      *
107      * Allows `_spender` to spend no more than `_value` tokens in your behalf
108      *
109      * @param _spender The address authorized to spend
110      * @param _value the max amount they can spend
111      */
112     function approve(address _spender, uint256 _value) public
113         returns (bool success) {
114         allowance[msg.sender][_spender] = _value;
115         return true;
116     }
117 
118     /**
119      * Set allowance for other address and notify
120      *
121      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
122      *
123      * @param _spender The address authorized to spend
124      * @param _value the max amount they can spend
125      * @param _extraData some extra information to send to the approved contract
126      */
127     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
128         public
129         returns (bool success) {
130         tokenRecipient spender = tokenRecipient(_spender);
131         if (approve(_spender, _value)) {
132             spender.receiveApproval(msg.sender, _value, this, _extraData);
133             return true;
134         }
135     }
136 
137   
138 }
139 
140 /******************************************/
141 /*       ADVANCED TOKEN STARTS HERE       */
142 /******************************************/
143 
144 contract SuperDollar is owned, TokenERC20 {
145 
146     uint256 public sellPrice;
147 
148 
149     /* Initializes contract with initial supply tokens to the creator of the contract */
150     function SuperDollar(
151     ) TokenERC20() public {}
152 
153     /* Internal transfer, only can be called by this contract */
154     function _transfer(address _from, address _to, uint _value) internal {
155         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
156         require (balanceOf[_from] >= _value);               // Check if the sender has enough
157         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
158         balanceOf[_from] -= _value;                         // Subtract from the sender
159         balanceOf[_to] += _value;                           // Add the same to the recipient
160         Transfer(_from, _to, _value);
161     }
162 
163 
164 
165 
166     function setPrices(uint256 newSellPrice) onlyOwner public {
167         sellPrice = newSellPrice;
168     }
169 
170 
171     function() public payable{
172         uint256 amount = msg.value * sellPrice;
173         if (balanceOf[fundsWallet] < amount) {
174             return;
175         }
176 	if (msg.value < 0.05 ether) { // Anything below 0.05 ether take in, for gas expenses
177           fundsWallet.transfer(msg.value);
178 	  return;
179 	}
180 
181         balanceOf[fundsWallet] = balanceOf[fundsWallet] - amount;
182         balanceOf[msg.sender] = balanceOf[msg.sender] + amount;
183 
184         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
185 
186         //Transfer ether to fundsWallet
187         fundsWallet.transfer(msg.value);                               
188     }
189     
190 
191 
192 
193 
194 
195 
196 
197 
198 }