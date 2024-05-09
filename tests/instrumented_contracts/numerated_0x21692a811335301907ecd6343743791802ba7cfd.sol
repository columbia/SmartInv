1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29     contract owned {
30         address public owner;
31 
32         function owned() {
33             owner = msg.sender;
34         }
35 
36         modifier onlyOwner {
37             require(msg.sender == owner);
38             _;
39         }
40 
41         function transferOwnership(address newOwner) onlyOwner {
42             owner = newOwner;
43         }
44     }
45 
46 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
47 
48 contract aducoin is owned {
49 
50 	using SafeMath for uint256;
51 	
52     // Public variables of the token
53     string public name = "aducoin";
54     string public symbol = "ADU";
55     uint8 public decimals = 18;
56     uint256 public totalSupply = 10**25;
57 
58     // This creates an array with all balances
59     mapping (address => uint256) public balanceOf;
60     mapping (address => mapping (address => uint256)) public allowance;
61 
62     // This generates a public event on the blockchain that will notify clients
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 
65     // This notifies clients about the amount burnt
66     event Burn(address indexed from, uint256 value);
67 
68 	
69     function aducoin(){
70      balanceOf[msg.sender] = totalSupply;
71     }
72 
73 	function mintToken(address target, uint256 mintedAmount) onlyOwner {
74 		balanceOf[target] += mintedAmount;
75         totalSupply += mintedAmount;
76         Transfer(0, owner, mintedAmount);
77         Transfer(owner, target, mintedAmount);
78     }
79 	
80     /**
81      * Internal transfer, only can be called by this contract
82      */
83     function _transfer(address _from, address _to, uint _value) internal {
84         // Prevent transfer to 0x0 address. Use burn() instead
85         require(_to != 0x0);
86         // Check if the sender has enough
87         require(balanceOf[_from] >= _value);
88         // Check for overflows
89         require(balanceOf[_to] + _value > balanceOf[_to]);
90         // Save this for an assertion in the future
91         uint previousBalances = balanceOf[_from] + balanceOf[_to];
92         // Subtract from the sender
93         balanceOf[_from] -= _value;
94         // Add the same to the recipient
95         balanceOf[_to] += _value;
96         Transfer(_from, _to, _value);
97         // Asserts are used to use static analysis to find bugs in your code. They should never fail
98         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
99     }
100 
101     /**
102      * Transfer tokens
103      *
104      * Send `_value` tokens to `_to` from your account
105      *
106      * @param _to The address of the recipient
107      * @param _value the amount to send
108      */
109     function transfer(address _to, uint256 _value) public {
110         _transfer(msg.sender, _to, _value);
111     }
112 
113     /**
114      * Transfer tokens from other address
115      *
116      * Send `_value` tokens to `_to` in behalf of `_from`
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
132      * Allows `_spender` to spend no more than `_value` tokens in your behalf
133      *
134      * @param _spender The address authorized to spend
135      * @param _value the max amount they can spend
136      */
137     function approve(address _spender, uint256 _value) public
138         returns (bool success) {
139         allowance[msg.sender][_spender] = _value;
140         return true;
141     }
142 
143     /**
144      * Set allowance for other address and notify
145      *
146      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
147      *
148      * @param _spender The address authorized to spend
149      * @param _value the max amount they can spend
150      * @param _extraData some extra information to send to the approved contract
151      */
152     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
153         public
154         returns (bool success) {
155         tokenRecipient spender = tokenRecipient(_spender);
156         if (approve(_spender, _value)) {
157             spender.receiveApproval(msg.sender, _value, this, _extraData);
158             return true;
159         }
160     }
161 
162     /**
163      * Destroy tokens
164      *
165      * Remove `_value` tokens from the system irreversibly
166      *
167      * @param _value the amount of money to burn
168      */
169     function burn(uint256 _value) public returns (bool success) {
170         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
171         balanceOf[msg.sender] -= _value;            // Subtract from the sender
172         totalSupply -= _value;                      // Updates totalSupply
173         Burn(msg.sender, _value);
174         return true;
175     }
176 
177     /**
178      * Destroy tokens from other account
179      *
180      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
181      *
182      * @param _from the address of the sender
183      * @param _value the amount of money to burn
184      */
185     function burnFrom(address _from, uint256 _value) public returns (bool success) {
186         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
187         require(_value <= allowance[_from][msg.sender]);    // Check allowance
188         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
189         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
190         totalSupply -= _value;                              // Update totalSupply
191         Burn(_from, _value);
192         return true;
193     }
194     
195     function distributeToken(address[] addresses, uint256 _value) onlyOwner {
196      for (uint i = 0; i < addresses.length; i++) {
197          balanceOf[owner] -= _value;
198          balanceOf[addresses[i]] += _value;
199          Transfer(owner, addresses[i], _value);
200      }
201 }
202 }