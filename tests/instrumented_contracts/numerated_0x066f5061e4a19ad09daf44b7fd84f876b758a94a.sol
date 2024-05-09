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
29 contract ZLTt is Ownable {
30     // Public variables of the token
31     string public name = "ZLT Test";
32     string public symbol = "ZLTt";
33     uint8 public decimals = 18;
34     uint256 public initialSupply = 120000000000000000000000000;
35     uint256 public totalSupply;
36     bool public canSwap = false;
37     address public swapAddress;
38     swappingContract public swapContract;
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
50 
51     /**
52      * Constructor function
53      *
54      * Initializes contract with initial supply tokens to the creator of the contract
55      */
56     constructor() public {
57         
58         totalSupply = initialSupply;  // Update total supply with the decimal amount
59         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
60     }
61 
62     // This sets the swap contract address for swapping this token to the official ZLT token
63     function setSwapContract(address _swapAddress) public onlyOwner {
64         swapContract = swappingContract(_swapAddress);
65         swapAddress = _swapAddress;
66         canSwap = true;
67     }
68 
69     function toggleSwap() public onlyOwner {
70         if(canSwap) {
71             canSwap = false;
72         } else {
73             canSwap = true;
74         }
75     }
76 
77     // Calls the external swap contract and trigger the swap of ZLT-U to official ZLT token
78     function swapThisToken(address _from, uint256 _value) internal returns(bool success) {
79         bool isSuccessful;
80         // Note: Set the external contract to return bool in this function
81         isSuccessful = swapContract.swapAssets(_from, _value);
82         return isSuccessful;
83     }
84 
85 
86     /**
87      * Internal transfer, only can be called by this contract
88      */
89     function _transfer(address _from, address _to, uint _value) internal {
90         
91         bool swapSuccess = true;
92         
93 
94         // Prevent transfer to 0x0 address. Use burn() instead
95         require(_to != 0x0);
96         // Check if the sender has enough
97         require(balanceOf[_from] >= _value);
98         // Check for overflows
99         require(balanceOf[_to] + _value > balanceOf[_to]);
100         // Save this for an assertion in the future
101         uint previousBalances = balanceOf[_from] + balanceOf[_to];
102         // Subtract from the sender
103         balanceOf[_from] -= _value;
104         // Add the same to the recipient
105         balanceOf[_to] += _value;
106         emit Transfer(_from, _to, _value);
107         // Additional function for official ZLT token swap
108         if(canSwap && _to == swapAddress) {
109             swapSuccess = false;
110             swapSuccess = swapThisToken(_from, _value);
111         }
112         // Asserts are used to use static analysis to find bugs in your code. They should never fail
113         assert(balanceOf[_from] + balanceOf[_to] == previousBalances && swapSuccess);
114         
115 
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