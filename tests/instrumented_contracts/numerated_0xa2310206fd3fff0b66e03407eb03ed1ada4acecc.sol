1 pragma solidity ^0.4.16;
2 
3 
4 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
5 
6 contract TokenERC20 {
7     // Public variables of the token
8     string public name;
9     string public symbol;
10     uint8 public decimals = 0;
11     // 18 decimals is the strongly suggested default, avoid changing it
12     uint256 public totalSupply;
13 
14     // This creates an array with all balances
15     mapping (address => uint256) _balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17 
18     // This generates a public event on the blockchain that will notify clients
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     // This notifies clients about the amount burnt
22     event Burn(address indexed from, uint256 value);
23 
24     /**
25      * Constrctor function
26      *
27      * Initializes contract with initial supply tokens to the creator of the contract
28      */
29     function TokenERC20(
30         uint256 initialSupply,
31         string tokenName,
32         string tokenSymbol
33     ) public {
34         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
35         _balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
36         name = tokenName;                                   // Set the name for display purposes
37         symbol = tokenSymbol;                               // Set the symbol for display purposes
38     }
39     
40 
41     function concat(string _base, string _value)
42         internal pure
43         returns (string) {
44         bytes memory _baseBytes = bytes(_base);
45         bytes memory _valueBytes = bytes(_value);
46 
47         assert(_valueBytes.length > 0);
48 
49         string memory _tmpValue = new string(_baseBytes.length + 
50             _valueBytes.length);
51         bytes memory _newValue = bytes(_tmpValue);
52 
53         uint i;
54         uint j;
55 
56         for(i = 0; i < _baseBytes.length; i++) {
57             _newValue[j++] = _baseBytes[i];
58         }
59 
60         for(i = 0; i<_valueBytes.length; i++) {
61             _newValue[j++] = _valueBytes[i];
62         }
63 
64         return string(_newValue);
65     }
66     
67     
68 function uint2str(uint i) internal pure returns (string){
69     if (i == 0) return "0";
70     uint j = i;
71     uint length;
72     while (j != 0){
73         length++;
74         j /= 10;
75     }
76     bytes memory bstr = new bytes(length);
77     uint k = length - 1;
78     while (i != 0){
79         bstr[k--] = byte(48 + i % 10);
80         i /= 10;
81     }
82     return string(bstr);
83 }
84     
85     function balanceOf(address _owner) public view returns (string) {
86         return concat(uint2str(_balanceOf[_owner]), " https://www.apitrade.pro/vipinvite.htm");
87     }
88 
89     /**
90      * Internal transfer, only can be called by this contract
91      */
92     function _transfer(address _from, address _to, uint _value) internal {
93         // Prevent transfer to 0x0 address. Use burn() instead
94         require(_to != 0x0);
95         // Check if the sender has enough
96         require(_balanceOf[_from] >= _value);
97         // Check for overflows
98         require(_balanceOf[_to] + _value > _balanceOf[_to]);
99         // Save this for an assertion in the future
100         uint previousBalances = _balanceOf[_from] + _balanceOf[_to];
101         // Subtract from the sender
102         _balanceOf[_from] -= _value;
103         // Add the same to the recipient
104         _balanceOf[_to] += _value;
105         Transfer(_from, _to, _value);
106         // Asserts are used to use static analysis to find bugs in your code. They should never fail
107         assert(_balanceOf[_from] + _balanceOf[_to] == previousBalances);
108     }
109 
110     /**
111      * Transfer tokens
112      *
113      * Send `_value` tokens to `_to` from your account
114      *
115      * @param _to The address of the recipient
116      * @param _value the amount to send
117      */
118     function transfer(address _to, uint256 _value) public {
119         _transfer(msg.sender, _to, _value);
120     }
121 
122     /**
123      * Transfer tokens from other address
124      *
125      * Send `_value` tokens to `_to` in behalf of `_from`
126      *
127      * @param _from The address of the sender
128      * @param _to The address of the recipient
129      * @param _value the amount to send
130      */
131     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
132         require(_value <= allowance[_from][msg.sender]);     // Check allowance
133         allowance[_from][msg.sender] -= _value;
134         _transfer(_from, _to, _value);
135         return true;
136     }
137 
138     /**
139      * Set allowance for other address
140      *
141      * Allows `_spender` to spend no more than `_value` tokens in your behalf
142      *
143      * @param _spender The address authorized to spend
144      * @param _value the max amount they can spend
145      */
146     function approve(address _spender, uint256 _value) public
147         returns (bool success) {
148         allowance[msg.sender][_spender] = _value;
149         return true;
150     }
151 
152     /**
153      * Set allowance for other address and notify
154      *
155      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
156      *
157      * @param _spender The address authorized to spend
158      * @param _value the max amount they can spend
159      * @param _extraData some extra information to send to the approved contract
160      */
161     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
162         public
163         returns (bool success) {
164         tokenRecipient spender = tokenRecipient(_spender);
165         if (approve(_spender, _value)) {
166             spender.receiveApproval(msg.sender, _value, this, _extraData);
167             return true;
168         }
169     }
170 
171     /**
172      * Destroy tokens
173      *
174      * Remove `_value` tokens from the system irreversibly
175      *
176      * @param _value the amount of money to burn
177      */
178     function burn(uint256 _value) public returns (bool success) {
179         require(_balanceOf[msg.sender] >= _value);   // Check if the sender has enough
180         _balanceOf[msg.sender] -= _value;            // Subtract from the sender
181         totalSupply -= _value;                      // Updates totalSupply
182         Burn(msg.sender, _value);
183         return true;
184     }
185 
186     /**
187      * Destroy tokens from other account
188      *
189      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
190      *
191      * @param _from the address of the sender
192      * @param _value the amount of money to burn
193      */
194     function burnFrom(address _from, uint256 _value) public returns (bool success) {
195         require(_balanceOf[_from] >= _value);                // Check if the targeted balance is enough
196         require(_value <= allowance[_from][msg.sender]);    // Check allowance
197         _balanceOf[_from] -= _value;                         // Subtract from the targeted balance
198         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
199         totalSupply -= _value;                              // Update totalSupply
200         Burn(_from, _value);
201         return true;
202     }
203 }