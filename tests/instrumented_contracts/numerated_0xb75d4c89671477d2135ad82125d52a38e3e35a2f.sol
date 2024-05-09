1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract CrypteloERC20 {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint256 public decimals;
10     uint256 public totalSupply;
11     uint256 public totalSupplyICO;
12     uint256 public totalSupplyPrivateSale;
13     uint256 public totalSupplyTeamTokens;
14     uint256 public totalSupplyExpansionTokens;
15 
16     // This creates an array with all balances
17     mapping (address => uint256) public balanceOf;
18     mapping (address => mapping (address => uint256)) public allowance;
19 
20     // This generates a public event on the blockchain that will notify clients
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     // This generates a public event on the blockchain that will notify clients
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 
26     // This notifies clients about the amount burnt
27     event Burn(address indexed from, uint256 value);
28 
29     /**
30      * Constructor function
31      *
32      * Initializes contract with initial supply tokens to the creator of the contract
33      */
34     function CrypteloERC20() public {
35         name = "CRL";
36         symbol = "CRL";
37         decimals = 8;
38         totalSupply = 500000000 * ( 10 ** decimals);
39         totalSupplyICO = 150000000 * ( 10 ** decimals);
40         totalSupplyPrivateSale = 100000000 * ( 10 ** decimals);
41         totalSupplyTeamTokens = 125000000 * ( 10 ** decimals);
42         totalSupplyExpansionTokens = 125000000 * ( 10 ** decimals);
43 
44         address privateW = 0x2F2Aed5Bb8D2b555C01f143Ec32F6869581b0053;
45         address ICOW = 0x163Eae60A768f12ff94d4d631B563DB04aEF7A57;
46         address companyW = 0x3AF0511735C5150f0E025B8fFfDc0bD86985DFd5;
47         address expansionW = 0x283872929a79C86efCf76198f15A3abE0856dCD7;
48 
49         balanceOf[ICOW] = totalSupplyICO ;
50         balanceOf[privateW] = totalSupplyPrivateSale;
51         balanceOf[companyW] = totalSupplyTeamTokens;
52         balanceOf[expansionW] = totalSupplyExpansionTokens;
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
64         require(balanceOf[_to] + _value >= balanceOf[_to]);
65         // Save this for an assertion in the future
66         uint previousBalances = balanceOf[_from] + balanceOf[_to];
67         // Subtract from the sender
68         balanceOf[_from] -= _value;
69         // Add the same to the recipient
70         balanceOf[_to] += _value;
71         emit Transfer(_from, _to, _value);
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
84     function transfer(address _to, uint256 _value) public returns (bool success) {
85         _transfer(msg.sender, _to, _value);
86         return true;
87     }
88 
89     /**
90      * Transfer tokens from other address
91      *
92      * Send `_value` tokens to `_to` on behalf of `_from`
93      *
94      * @param _from The address of the sender
95      * @param _to The address of the recipient
96      * @param _value the amount to send
97      */
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99         require(_value <= allowance[_from][msg.sender]);     // Check allowance
100         allowance[_from][msg.sender] -= _value;
101         _transfer(_from, _to, _value);
102         return true;
103     }
104 
105     /**
106      * Set allowance for other address
107      *
108      * Allows `_spender` to spend no more than `_value` tokens on your behalf
109      *
110      * @param _spender The address authorized to spend
111      * @param _value the max amount they can spend
112      */
113     function approve(address _spender, uint256 _value) public
114         returns (bool success) {
115         allowance[msg.sender][_spender] = _value;
116         emit Approval(msg.sender, _spender, _value);
117         return true;
118     }
119 
120     /**
121      * Set allowance for other address and notify
122      *
123      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
124      *
125      * @param _spender The address authorized to spend
126      * @param _value the max amount they can spend
127      * @param _extraData some extra information to send to the approved contract
128      */
129     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
130         public
131         returns (bool success) {
132         tokenRecipient spender = tokenRecipient(_spender);
133         if (approve(_spender, _value)) {
134             spender.receiveApproval(msg.sender, _value, this, _extraData);
135             return true;
136         }
137     }
138 
139     /**
140      * Destroy tokens
141      *
142      * Remove `_value` tokens from the system irreversibly
143      *
144      * @param _value the amount of money to burn
145      */
146     function burn(uint256 _value) public returns (bool success) {
147         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
148         balanceOf[msg.sender] -= _value;            // Subtract from the sender
149         totalSupply -= _value;                      // Updates totalSupply
150         emit Burn(msg.sender, _value);
151         return true;
152     }
153 
154     /**
155      * Destroy tokens from other account
156      *
157      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
158      *
159      * @param _from the address of the sender
160      * @param _value the amount of money to burn
161      */
162     function burnFrom(address _from, uint256 _value) public returns (bool success) {
163         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
164         require(_value <= allowance[_from][msg.sender]);    // Check allowance
165         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
166         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
167         totalSupply -= _value;                              // Update totalSupply
168         emit Burn(_from, _value);
169         return true;
170     }
171 }