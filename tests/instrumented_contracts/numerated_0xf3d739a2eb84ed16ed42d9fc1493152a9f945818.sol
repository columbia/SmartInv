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
13     uint256 public start_time = 1547209085;
14     uint256 public current_time = 1547209085;
15 
16 
17     event OwnershipTransferred(address indexed _from, address indexed _to);
18 
19     constructor() public {
20         owner = 0xf9C45AD22Be5f0a5eBC9643c1BE1166A4C124C93;
21     }
22 
23     modifier onlyOwner {
24         require(msg.sender == owner);
25         _;
26     }
27     modifier onlyAfter(uint _time) {
28         require(now >= _time);
29         _;
30     }
31     function transferOwnership(address _newOwner) public onlyOwner {
32         newOwner = _newOwner;
33     }
34     function acceptOwnership() public {
35         require(msg.sender == newOwner);
36         emit OwnershipTransferred(owner, newOwner);
37         owner = newOwner;
38         newOwner = address(0);
39         
40     }
41 }
42 contract TokenERC20 is Owned {
43     // Public variables of the token
44     string public name;
45     string public symbol;
46     uint8 public decimals = 18;
47     // 18 decimals is the strongly suggested default, avoid changing it
48     uint256 public totalSupply;
49     address public teamOwner = 0x9c8483a7d4ebeC3A3e768cB14e191bef2a3AC712;
50 
51     // This creates an array with all balances
52     mapping (address => uint256) public balanceOf;
53     mapping (address => mapping (address => uint256)) public allowance;
54 
55     // This generates a public event on the blockchain that will notify clients
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     
58     // This generates a public event on the blockchain that will notify clients
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 
61     // This notifies clients about the amount burnt
62     event Burn(address indexed from, uint256 value);
63 
64     /**
65      * Constructor function
66      *
67      * Initializes contract with initial supply tokens to the creator of the contract
68      */
69     constructor() public {
70         totalSupply = 1000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
71                       // Give the creator all initial tokens
72         name = "AUMKII Token";                                   // Set the name for display purposes
73         symbol = "AUMKII";                               // Set the symbol for display purposes
74         
75         balanceOf[owner] = 400 * 10 ** uint256(decimals);
76 
77         balanceOf[teamOwner] = 600 * 10 ** uint256(decimals);
78         
79         
80         
81         
82     }
83   
84     function setTime(uint _time) public onlyOwner{
85         current_time = _time;
86     }
87      function buyVestedToken(address _from, address _to, uint _value, uint period) internal {
88          require(msg.sender != address(0x0));
89          require(_value >= 1);
90          
91         // Check if the sender has enough
92         require(balanceOf[_from] >= _value);
93         // Check for overflows
94         require(balanceOf[_to] + _value >= balanceOf[_to]);
95         // Save this for an assertion in the future
96         uint previousBalances = balanceOf[_from] + balanceOf[_to];
97         
98         // Subtract from the sender
99         balanceOf[_from] -= _value;
100         // Add the same to the recipient
101         balanceOf[_to] += _value;
102 
103         emit Transfer(_from, _to, _value);
104         // Asserts are used to use static analysis to find bugs in your code. They should never fail
105         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
106      }
107 
108     /**
109      * Internal transfer, only can be called by this contract
110      */
111     function _transfer(address _from, address _to, uint _value) internal {
112         // Prevent transfer to 0x0 address. Use burn() instead
113         require(_to != address(0x0));
114         // Check if the sender has enough
115         require(balanceOf[_from] >= _value);
116         // Check for overflows
117         require(balanceOf[_to] + _value >= balanceOf[_to]);
118         // Save this for an assertion in the future
119         uint previousBalances = balanceOf[_from] + balanceOf[_to];
120         // Subtract from the sender
121         balanceOf[_from] -= _value;
122         // Add the same to the recipient
123         balanceOf[_to] += _value;
124         emit Transfer(_from, _to, _value);
125         // Asserts are used to use static analysis to find bugs in your code. They should never fail
126         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
127     }
128 
129     /**
130      * Transfer tokens
131      *
132      * Send `_value` tokens to `_to` from your account
133      *
134      * @param _to The address of the recipient
135      * @param _value the amount to send
136      */
137     function transfer(address _to, uint256 _value) public returns (bool success) {
138         _transfer(msg.sender, _to, _value);
139         return true;
140     }
141 
142     /**
143      * Transfer tokens from other address
144      *
145      * Send `_value` tokens to `_to` on behalf of `_from`
146      *
147      * @param _from The address of the sender
148      * @param _to The address of the recipient
149      * @param _value the amount to send
150      */
151     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
152         require(_value <= allowance[_from][msg.sender]);     // Check allowance
153         allowance[_from][msg.sender] -= _value;
154         _transfer(_from, _to, _value);
155         return true;
156     }
157 
158     /**
159      * Set allowance for other address
160      *
161      * Allows `_spender` to spend no more than `_value` tokens on your behalf
162      *
163      * @param _spender The address authorized to spend
164      * @param _value the max amount they can spend
165      */
166     function approve(address _spender, uint256 _value) public
167         returns (bool success) {
168         allowance[msg.sender][_spender] = _value;
169         emit Approval(msg.sender, _spender, _value);
170         return true;
171     }
172 
173     /**
174      * Set allowance for other address and notify
175      *
176      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
177      *
178      * @param _spender The address authorized to spend
179      * @param _value the max amount they can spend
180      * @param _extraData some extra information to send to the approved contract
181      */
182     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
183         public
184         returns (bool success) {
185         tokenRecipient spender = tokenRecipient(_spender);
186         if (approve(_spender, _value)) {
187             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
188             return true;
189         }
190     }
191 
192     /**
193      * Destroy tokens
194      *
195      * Remove `_value` tokens from the system irreversibly
196      *
197      * @param _value the amount of money to burn
198      */
199     function burn(uint256 _value) public returns (bool success) {
200         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
201         balanceOf[msg.sender] -= _value;            // Subtract from the sender
202         totalSupply -= _value;                      // Updates totalSupply
203         emit Burn(msg.sender, _value);
204         return true;
205     }
206     function getBalance() public view returns (uint256) {
207         return address(this).balance;
208   }
209 
210     
211     function withdraw()  public onlyOwner{
212        
213         uint256 balance = address(this).balance;
214         msg.sender.transfer(balance);
215     }
216     
217     function () external payable  {
218         uint token  = msg.value * 1000;                    // CaLcuLaTeS the AmOunT
219       
220         _transfer(owner, msg.sender, token);
221        
222     }
223 
224     
225 
226 }