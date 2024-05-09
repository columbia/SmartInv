1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
5 }
6 
7 // ----------------------------------------------------------------------------
8 // Owned contract
9 // ----------------------------------------------------------------------------
10 contract Owned {
11     address public owner;
12     address public newOwner;
13 
14     event OwnershipTransferred(address indexed _from, address indexed _to);
15 
16     constructor() public {
17         owner = 0x9c8483a7d4ebeC3A3e768cB14e191bef2a3AC712;
18         
19     }
20 
21     modifier onlyOwner {
22         require(msg.sender == owner);
23         _;
24     }
25    
26     function transferOwnership(address _newOwner) public onlyOwner {
27         newOwner = _newOwner;
28     }
29     function acceptOwnership() public {
30         require(msg.sender == newOwner);
31         emit OwnershipTransferred(owner, newOwner);
32         owner = newOwner;
33         newOwner = address(0);
34         
35     }
36 }
37 contract YUPERToken is Owned {
38     // Public variables of the token
39     string public name;
40     string public symbol;
41     uint8 public decimals = 18;
42     // 18 decimals is the strongly suggested default, avoid changing it
43     uint256 public totalSupply;
44     address public teamOwner = 0xf9C45AD22Be5f0a5eBC9643c1BE1166A4C124C93 ;
45 
46     // This creates an array with all balances
47     mapping (address => uint256) public balanceOf;
48     mapping (address => mapping (address => uint256)) public allowance;
49 
50     // This generates a public event on the blockchain that will notify clients
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     
53     // This generates a public event on the blockchain that will notify clients
54     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 
56     // This notifies clients about the amount burnt
57     event Burn(address indexed from, uint256 value);
58 
59     /**
60      * Constructor function
61      *
62      * Initializes contract with initial supply tokens to the creator of the contract
63      */
64     constructor() public {
65         totalSupply = 23000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
66                       // Give the creator all initial tokens
67         name = "YUPER Exchange";                        // Set the name for display purposes
68         symbol = "YUPER";                               // Set the symbol for display purposes
69         
70         balanceOf[owner] = 11500000 * 10 ** uint256(decimals);
71 
72         balanceOf[teamOwner] = 11500000 * 10 ** uint256(decimals);
73         
74         
75         
76         
77     }
78   
79     /**
80      * Internal transfer, only can be called by this contract
81      */
82     function _transfer(address _from, address _to, uint _value) internal {
83         // Prevent transfer to 0x0 address. Use burn() instead
84         require(_to != address(0x0));
85         // Check if the sender has enough
86         require(balanceOf[_from] >= _value);
87         // Check for overflows
88         require(balanceOf[_to] + _value >= balanceOf[_to]);
89         // Save this for an assertion in the future
90         uint previousBalances = balanceOf[_from] + balanceOf[_to];
91         // Subtract from the sender
92         balanceOf[_from] -= _value;
93         // Add the same to the recipient
94         balanceOf[_to] += _value;
95         emit Transfer(_from, _to, _value);
96         // Asserts are used to use static analysis to find bugs in your code. They should never fail
97         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
98     }
99 
100     /**
101      * Transfer tokens
102      *
103      * Send `_value` tokens to `_to` from your account
104      *
105      * @param _to The address of the recipient
106      * @param _value the amount to send
107      */
108     function transfer(address _to, uint256 _value) public returns (bool success) {
109         _transfer(msg.sender, _to, _value);
110         return true;
111     }
112 
113     /**
114      * Transfer tokens from other address
115      *
116      * Send `_value` tokens to `_to` on behalf of `_from`
117      *
118      * @param _from The address of the sender
119      * @param _to The address of the recipient
120      * @param _value the amount to send
121      */
122     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
123         require(_value <= allowance[_from][msg.sender]);     // Check allowance
124         allowance[_from][msg.sender] -= _value;
125         _transfer(_from, _to, _value);
126         return true;
127     }
128 
129     /**
130      * Set allowance for other address
131      *
132      * Allows `_spender` to spend no more than `_value` tokens on your behalf
133      *
134      * @param _spender The address authorized to spend
135      * @param _value the max amount they can spend
136      */
137     function approve(address _spender, uint256 _value) public
138         returns (bool success) {
139         allowance[msg.sender][_spender] = _value;
140         emit Approval(msg.sender, _spender, _value);
141         return true;
142     }
143 
144     /**
145      * Set allowance for other address and notify
146      *
147      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
148      *
149      * @param _spender The address authorized to spend
150      * @param _value the max amount they can spend
151      * @param _extraData some extra information to send to the approved contract
152      */
153     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
154         public
155         returns (bool success) {
156         tokenRecipient spender = tokenRecipient(_spender);
157         if (approve(_spender, _value)) {
158             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
159             return true;
160         }
161     }
162 
163     /**
164      * Destroy tokens
165      *
166      * Remove `_value` tokens from the system irreversibly
167      *
168      * @param _value the amount of money to burn
169      */
170     function burn(uint256 _value) public returns (bool success) {
171         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
172         balanceOf[msg.sender] -= _value;            // Subtract from the sender
173         totalSupply -= _value;                      // Updates totalSupply
174         emit Burn(msg.sender, _value);
175         return true;
176     }
177     function getBalance() public view returns (uint256) {
178         return address(this).balance;
179   }
180 
181     function withdraw()  public onlyOwner{
182        
183         uint256 balance = address(this).balance;
184         msg.sender.transfer(balance);
185     }
186     
187     function () external payable  {
188         uint token  = msg.value * 100;                    
189         _transfer(owner, msg.sender, token);
190        
191     }
192 }