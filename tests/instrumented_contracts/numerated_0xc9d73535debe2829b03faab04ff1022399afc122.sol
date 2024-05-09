1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
5 }
6 
7 
8 contract Ownable {
9     address  _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     constructor () internal {
14         _owner = msg.sender;
15         emit OwnershipTransferred(address(0), _owner);
16     }
17 
18     function owner() public view returns (address) {
19         return _owner;
20     }
21 
22     modifier onlyOwner() {
23         require(isOwner());
24         _;
25     }
26 
27     function isOwner() public view returns (bool) {
28         return msg.sender == _owner;
29     }
30 
31     function renounceOwnership() public onlyOwner {
32         emit OwnershipTransferred(_owner, address(0));
33         _owner = address(0);
34     }
35 
36     function transferOwnership(address newOwner) public onlyOwner {
37         _transferOwnership(newOwner);
38     }
39 
40     function _transferOwnership(address newOwner) internal {
41         require(newOwner != address(0));
42         emit OwnershipTransferred(_owner, newOwner);
43         _owner = newOwner;
44     }
45 }
46 
47 
48 
49 contract TAN is Ownable {
50     // Public variables of the token
51     string public name;
52     string public symbol;
53     uint8 public decimals = 8;
54     // 18 decimals is the strongly suggested default, avoid changing it
55     uint256 public totalSupply;
56 
57     // This creates an array with all balances
58     mapping (address => uint256) public balanceOf;
59     mapping (address => mapping (address => uint256)) public allowance;
60 
61     // This generates a public event on the blockchain that will notify clients
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     
64     // This generates a public event on the blockchain that will notify clients
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66 
67     // This notifies clients about the amount burnt
68     event Burn(address indexed from, uint256 value);
69 
70     /**
71      * Constructor function
72      *
73      * Initializes contract with initial supply tokens to the creator of the contract
74      */
75     constructor(
76         
77     ) public {
78         totalSupply = 1200000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
79         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
80         name = "TANTECH";                                   // Set the name for display purposes
81         symbol = "TAN";                               // Set the symbol for display purposes
82     }
83 
84     /**
85      * Internal transfer, only can be called by this contract
86      */
87     function _transfer(address _from, address _to, uint _value) internal {
88         // Prevent transfer to 0x0 address. Use burn() instead
89         require(_to != address(0x0));
90         // Check if the sender has enough
91         require(balanceOf[_from] >= _value);
92         // Check for overflows
93         require(balanceOf[_to] + _value >= balanceOf[_to]);
94         // Save this for an assertion in the future
95         uint previousBalances = balanceOf[_from] + balanceOf[_to];
96         // Subtract from the sender
97         balanceOf[_from] -= _value;
98         // Add the same to the recipient
99         balanceOf[_to] += _value;
100         emit Transfer(_from, _to, _value);
101         // Asserts are used to use static analysis to find bugs in your code. They should never fail
102         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
103     }
104 
105     /**
106      * Transfer tokens
107      *
108      * Send `_value` tokens to `_to` from your account
109      *
110      * @param _to The address of the recipient
111      * @param _value the amount to send
112      */
113     function transfer(address _to, uint256 _value) public returns (bool success) {
114         _transfer(msg.sender, _to, _value);
115         return true;
116     }
117 
118     /**
119      * Transfer tokens from other address
120      *
121      * Send `_value` tokens to `_to` on behalf of `_from`
122      *
123      * @param _from The address of the sender
124      * @param _to The address of the recipient
125      * @param _value the amount to send
126      */
127     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
128         require(_value <= allowance[_from][msg.sender]);     // Check allowance
129         allowance[_from][msg.sender] -= _value;
130         _transfer(_from, _to, _value);
131         return true;
132     }
133 
134     /**
135      * Set allowance for other address
136      *
137      * Allows `_spender` to spend no more than `_value` tokens on your behalf
138      *
139      * @param _spender The address authorized to spend
140      * @param _value the max amount they can spend
141      */
142     function approve(address _spender, uint256 _value) public
143         returns (bool success) {
144         allowance[msg.sender][_spender] = _value;
145         emit Approval(msg.sender, _spender, _value);
146         return true;
147     }
148 
149     /**
150      * Set allowance for other address and notify
151      *
152      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
153      *
154      * @param _spender The address authorized to spend
155      * @param _value the max amount they can spend
156      * @param _extraData some extra information to send to the approved contract
157      */
158     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
159         public
160         returns (bool success) {
161         tokenRecipient spender = tokenRecipient(_spender);
162         if (approve(_spender, _value)) {
163             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
164             return true;
165         }
166     }
167 
168     /**
169      * Destroy tokens
170      *
171      * Remove `_value` tokens from the system irreversibly
172      *
173      * @param _value the amount of money to burn
174      */
175     function burn(uint256 _value) public returns (bool success) {
176         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
177         balanceOf[msg.sender] -= _value;            // Subtract from the sender
178         totalSupply -= _value;                      // Updates totalSupply
179         emit Burn(msg.sender, _value);
180         return true;
181     }
182 
183     /**
184      * Destroy tokens from other account
185      *
186      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
187      *
188      * @param _from the address of the sender
189      * @param _value the amount of money to burn
190      */
191     function burnFrom(address _from, uint256 _value) public returns (bool success) {
192         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
193         require(_value <= allowance[_from][msg.sender]);    // Check allowance
194         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
195         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
196         totalSupply -= _value;                              // Update totalSupply
197         emit Burn(_from, _value);
198         return true;
199     }
200     
201     function mint(uint _amount) public onlyOwner{
202         uint _toBeAdded = _amount * 10 ** uint256(decimals);
203         require((totalSupply + _toBeAdded) < 3000000000 * 10 ** uint256(decimals));
204         totalSupply = totalSupply+_toBeAdded;
205         balanceOf[_owner] = balanceOf[_owner] + _toBeAdded;
206     }
207 }