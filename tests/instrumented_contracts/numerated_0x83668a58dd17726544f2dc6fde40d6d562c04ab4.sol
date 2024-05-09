1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
5 }
6 
7 contract Interacting {
8     address private owner = msg.sender;
9     
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14     
15     function sendEther(address _to) external payable onlyOwner {
16         require(_to.call.value(msg.value)(''));
17     }
18     
19     function callMethod(address _contract, bytes _extraData) external payable onlyOwner {
20         require(_contract.call.value(msg.value)(_extraData));
21     }
22     
23     function withdrawEther(address _to) external onlyOwner {
24         _to.transfer(address(this).balance);
25     }
26     
27     function () external payable {
28         
29     }
30 }
31 
32 contract RGT {
33     string public name = 'RGT';
34     string public symbol = 'RGT';
35     uint8 public decimals = 18;
36     uint public k = 10 ** uint(decimals);
37     uint public k1000 = k / 1000;
38     uint public totalSupply = 1000000000 * k;
39 
40     // This creates an array with all balances
41     mapping (address => uint256) public balanceOf;
42     mapping (address => mapping (address => uint256)) public allowance;
43     mapping (address => address) public contracts;
44 
45     // This generates a public event on the blockchain that will notify clients
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     
48     // This generates a public event on the blockchain that will notify clients
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 
51     // This notifies clients about the amount burnt
52     event Burn(address indexed from, uint256 value);
53 
54     /**
55      * Constructor function
56      *
57      * Initializes contract with initial supply tokens to the creator of the contract
58      */
59     constructor() public {
60         balanceOf[msg.sender] = totalSupply;
61     }
62 
63     /**
64      * Internal transfer, only can be called by this contract
65      */
66     function _transfer(address _from, address _to, uint _value) internal {
67         // Prevent transfer to 0x0 address. Use burn() instead
68         require(_to != address(0x0));
69         // Check if the sender has enough
70         require(balanceOf[_from] >= _value);
71         // Check for overflows
72         require(balanceOf[_to] + _value >= balanceOf[_to]);
73         // Save this for an assertion in the future
74         uint previousBalances = balanceOf[_from] + balanceOf[_to];
75         // Subtract from the sender
76         balanceOf[_from] -= _value;
77         // Add the same to the recipient
78         balanceOf[_to] += _value;
79         emit Transfer(_from, _to, _value);
80         // Asserts are used to use static analysis to find bugs in your code. They should never fail
81         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
82     }
83 
84     /**
85      * Transfer tokens
86      *
87      * Send `_value` tokens to `_to` from your account
88      *
89      * @param _to The address of the recipient
90      * @param _value the amount to send
91      */
92     function transfer(address _to, uint256 _value) public returns (bool success) {
93         _transfer(msg.sender, _to, _value);
94         return true;
95     }
96 
97     /**
98      * Transfer tokens from other address
99      *
100      * Send `_value` tokens to `_to` on behalf of `_from`
101      *
102      * @param _from The address of the sender
103      * @param _to The address of the recipient
104      * @param _value the amount to send
105      */
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
107         require(_value <= allowance[_from][msg.sender]);     // Check allowance
108         allowance[_from][msg.sender] -= _value;
109         _transfer(_from, _to, _value);
110         return true;
111     }
112 
113     /**
114      * Set allowance for other address
115      *
116      * Allows `_spender` to spend no more than `_value` tokens on your behalf
117      *
118      * @param _spender The address authorized to spend
119      * @param _value the max amount they can spend
120      */
121     function approve(address _spender, uint256 _value) public
122         returns (bool success) {
123         allowance[msg.sender][_spender] = _value;
124         emit Approval(msg.sender, _spender, _value);
125         return true;
126     }
127 
128     /**
129      * Set allowance for other address and notify
130      *
131      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
132      *
133      * @param _spender The address authorized to spend
134      * @param _value the max amount they can spend
135      * @param _extraData some extra information to send to the approved contract
136      */
137     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
138         public
139         returns (bool success) {
140         tokenRecipient spender = tokenRecipient(_spender);
141         if (approve(_spender, _value)) {
142             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
143             return true;
144         }
145     }
146 
147     /**
148      * Destroy tokens
149      *
150      * Remove `_value` tokens from the system irreversibly
151      *
152      * @param _value the amount of money to burn
153      */
154     function burn(uint256 _value) public returns (bool success) {
155         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
156         balanceOf[msg.sender] -= _value;            // Subtract from the sender
157         totalSupply -= _value;                      // Updates totalSupply
158         emit Burn(msg.sender, _value);
159         return true;
160     }
161 
162     /**
163      * Destroy tokens from other account
164      *
165      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
166      *
167      * @param _from the address of the sender
168      * @param _value the amount of money to burn
169      */
170     function burnFrom(address _from, uint256 _value) public returns (bool success) {
171         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
172         require(_value <= allowance[_from][msg.sender]);    // Check allowance
173         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
174         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
175         totalSupply -= _value;                              // Update totalSupply
176         emit Burn(_from, _value);
177         return true;
178     }
179     
180     function mint(uint _amount) internal {
181         _amount = (_amount + 40000) * k1000 * (1 + balanceOf[msg.sender] * 99 / totalSupply);
182         balanceOf[msg.sender] += _amount;
183         totalSupply += _amount;
184         require(totalSupply >= _amount);
185         emit Transfer(address(0), address(this), _amount);
186         emit Transfer(address(this), msg.sender, _amount);
187     }
188     
189     modifier createOwnContractIfNeeded {
190         if (contracts[msg.sender] == 0x0) {
191             contracts[msg.sender] = new Interacting();
192         }
193         _;
194     }
195     
196     function sendEther(address _to) external payable createOwnContractIfNeeded {
197         uint gas = gasleft();
198         Interacting(contracts[msg.sender]).sendEther.value(msg.value)(_to);
199         mint(gas - gasleft());
200     }
201     
202     function callMethod(address _contract, bytes _extraData) external payable createOwnContractIfNeeded {
203         uint gas = gasleft();
204         Interacting(contracts[msg.sender]).callMethod.value(msg.value)(_contract, _extraData);
205         mint(gas - gasleft());
206     }
207     
208     function withdrawEther() external payable createOwnContractIfNeeded {
209         Interacting(contracts[msg.sender]).withdrawEther(msg.sender);
210     }
211     
212     function () external payable createOwnContractIfNeeded {
213         require(msg.value == 0);
214         mint(0);
215     }
216 }