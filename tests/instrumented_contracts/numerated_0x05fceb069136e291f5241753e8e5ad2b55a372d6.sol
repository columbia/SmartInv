1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
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
23     // This notifies clients about the amount burnt
24     event Burn(address indexed from, uint256 value);
25     
26     event Supply(uint256 supply);
27     /**
28      * Constrctor function
29      *
30      * Initializes contract with initial supply tokens to the creator of the contract
31      */
32     function CrypteloERC20() public {
33         name = "CRL";
34         symbol = "CRL";
35         decimals = 8;
36         totalSupply = 500000000;
37         totalSupplyICO = 150000000;
38         totalSupplyPrivateSale = 100000000;
39         totalSupplyTeamTokens = 125000000;
40         totalSupplyExpansionTokens = 125000000;
41         
42         address privateW = 0xc837Bf0664C67390aC8dA52168D0Bbdbfc53B03f;
43         address ICOW = 0x25814bb26Ff76E196A2D4F69EE0A6cEd0415965c;
44         address companyW = 0xA84Bff015B31e3Bc10A803F5BC5aE98e99922B68;
45         address expansionW = 0x600BeAbb79885acbE606944f54ae8bC29Ec332ef;
46         
47         balanceOf[ICOW] = totalSupplyICO * ( 10 ** decimals);
48         balanceOf[privateW] = totalSupplyPrivateSale * ( 10 ** decimals);
49         balanceOf[companyW] = totalSupplyTeamTokens * ( 10 ** decimals);
50         balanceOf[expansionW] = totalSupplyExpansionTokens * ( 10 ** decimals);
51 
52         Supply(totalSupplyICO * ( 10 ** decimals));
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
137     /**
138      * Destroy tokens
139      *
140      * Remove `_value` tokens from the system irreversibly
141      *
142      * @param _value the amount of money to burn
143      */
144     function burn(uint256 _value) public returns (bool success) {
145         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
146         balanceOf[msg.sender] -= _value;            // Subtract from the sender
147         totalSupply -= _value;                      // Updates totalSupply
148         Burn(msg.sender, _value);
149         return true;
150     }
151 
152     /**
153      * Destroy tokens from other account
154      *
155      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
156      *
157      * @param _from the address of the sender
158      * @param _value the amount of money to burn
159      */
160     function burnFrom(address _from, uint256 _value) public returns (bool success) {
161         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
162         require(_value <= allowance[_from][msg.sender]);    // Check allowance
163         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
164         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
165         totalSupply -= _value;                              // Update totalSupply
166         Burn(_from, _value);
167         return true;
168     }
169 }