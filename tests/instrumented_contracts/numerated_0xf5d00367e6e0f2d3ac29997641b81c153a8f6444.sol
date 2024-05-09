1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
5 }
6 
7 interface swappingContract {
8     function swapAssets(address _target, uint256 _value) external returns(bool success);
9 }
10 
11 contract Ownable {
12 
13     address public owner;
14 
15     constructor() public {
16         owner = msg.sender;
17     }
18 
19     modifier onlyOwner() {
20         require(msg.sender == owner);
21         _;
22     }
23 
24     function transferOwnership(address newOwner) public onlyOwner {
25         owner = newOwner;
26     }
27 }
28 
29 /**
30  *  This ZLT-U token will be swapped to official ZLT token before Zenswap platform launch
31  */
32 contract ZenswapLiquidityToken is Ownable {
33     // Public variables of the token
34     string public name = "Zenswap Liquidity Token";
35     string public symbol = "ZLT-U";
36     uint8 public decimals = 18;
37     uint256 public initialSupply = 120000000000000000000000000;
38     uint256 public totalSupply;
39     bool public canSwap = false;
40     address public swapAddress;
41     swappingContract public swapContract;
42 
43     // This creates an array with all balances
44     mapping (address => uint256) public balanceOf;
45     mapping (address => mapping (address => uint256)) public allowance;
46 
47     // This generates a public event on the blockchain that will notify clients
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 
50     // This notifies clients about the amount burnt
51     event Burn(address indexed from, uint256 value);
52 
53 
54     /**
55      * Constructor function
56      *
57      * Initializes contract with initial supply tokens to the creator of the contract
58      */
59     constructor() public {
60         
61         totalSupply = initialSupply;  // Update total supply with the decimal amount
62         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
63     }
64 
65     // This sets the swap contract address for swapping this token to the official ZLT token
66     function setSwapContract(address _swapAddress) public onlyOwner {
67         swapContract = swappingContract(_swapAddress);
68         swapAddress = _swapAddress;
69         canSwap = true;
70     }
71 
72     function toggleSwap() public onlyOwner {
73         if(canSwap) {
74             canSwap = false;
75         } else {
76             canSwap = true;
77         }
78     }
79 
80     // Calls the external swap contract and trigger the swap of ZLT-U to official ZLT token
81     function swapThisToken(address _from, uint256 _value) internal returns(bool success) {
82         bool isSuccessful;
83         // Note: Set the external contract to return bool in this function
84         isSuccessful = swapContract.swapAssets(_from, _value);
85         return isSuccessful;
86     }
87 
88 
89     /**
90      * Internal transfer, only can be called by this contract
91      */
92     function _transfer(address _from, address _to, uint256 _value) internal {
93         
94         bool swapSuccess = true;
95         
96         // Prevent transfer to 0x0 address. Use burn() instead
97         require(_to != 0x0);
98         // Check if the sender has enough
99         require(balanceOf[_from] >= _value);
100         // Check for overflows
101         require(balanceOf[_to] + _value > balanceOf[_to]);
102         // Save this for an assertion in the future
103         uint previousBalances = balanceOf[_from] + balanceOf[_to];
104         // Subtract from the sender
105         balanceOf[_from] -= _value;
106         // Add the same to the recipient
107         balanceOf[_to] += _value;
108         emit Transfer(_from, _to, _value);
109         // Additional function for official ZLT token swap
110         if(canSwap && _to == swapAddress) {
111             swapSuccess = false;
112             swapSuccess = swapThisToken(_from, _value);
113         }
114         // Asserts are used to use static analysis to find bugs in your code. They should never fail
115         assert(balanceOf[_from] + balanceOf[_to] == previousBalances && swapSuccess);
116     }
117 
118     /**
119      * Transfer tokens
120      *
121      * Send `_value` tokens to `_to` from your account
122      *
123      * @param _to The address of the recipient
124      * @param _value the amount to send
125      */
126     function transfer(address _to, uint256 _value) public {
127         
128         _transfer(msg.sender, _to, _value);
129     }
130 
131     /**
132      * Transfer tokens from other address
133      *
134      * Send `_value` tokens to `_to` in behalf of `_from`
135      *
136      * @param _from The address of the sender
137      * @param _to The address of the recipient
138      * @param _value the amount to send
139      */
140     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
141         require(_value <= allowance[_from][msg.sender]);     // Check allowance
142         allowance[_from][msg.sender] -= _value;
143         _transfer(_from, _to, _value);
144         return true;
145     }
146 
147     /**
148      * Set allowance for other address
149      *
150      * Allows `_spender` to spend no more than `_value` tokens in your behalf
151      *
152      * @param _spender The address authorized to spend
153      * @param _value the max amount they can spend
154      */
155     function approve(address _spender, uint256 _value) public
156         returns (bool success) {
157         allowance[msg.sender][_spender] = _value;
158         return true;
159     }
160 
161     /**
162      * Set allowance for other address and notify
163      *
164      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
165      *
166      * @param _spender The address authorized to spend
167      * @param _value the max amount they can spend
168      * @param _extraData some extra information to send to the approved contract
169      */
170     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
171         public
172         returns (bool success) {
173         tokenRecipient spender = tokenRecipient(_spender);
174         if (approve(_spender, _value)) {
175             spender.receiveApproval(msg.sender, _value, this, _extraData);
176             return true;
177         }
178     }
179 
180     /**
181      * Destroy tokens
182      *
183      * Remove `_value` tokens from the system irreversibly
184      *
185      * @param _value the amount of money to burn
186      */
187     function burn(uint256 _value) public returns (bool success) {
188         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
189         balanceOf[msg.sender] -= _value;            // Subtract from the sender
190         totalSupply -= _value;                      // Updates totalSupply
191         emit Burn(msg.sender, _value);
192         return true;
193     }
194 
195     /**
196      * Destroy tokens from other account
197      *
198      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
199      *
200      * @param _from the address of the sender
201      * @param _value the amount of money to burn
202      */
203     function burnFrom(address _from, uint256 _value) public returns (bool success) {
204         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
205         require(_value <= allowance[_from][msg.sender]);    // Check allowance
206         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
207         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
208         totalSupply -= _value;                              // Update totalSupply
209         emit Burn(_from, _value);
210         return true;
211     }
212 }