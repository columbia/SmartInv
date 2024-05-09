1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 
35 
36 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
37 
38 contract AmeriCoin {
39     using SafeMath for uint256;
40     string public constant _myTokeName = 'AmeriCoin';
41     string public constant _mySymbol = 'USA';
42     uint public constant _myinitialSupply = 326971209;
43     uint8 public constant _myDecimal = 18;
44     // Public variables of the token
45     string public name;
46     string public symbol;
47     uint8 public decimals;
48     // 18 decimals is the strongly suggested default, avoid changing it
49     uint256 public totalSupply;
50 
51     // This creates an array with all balances
52     mapping (address => uint256) public balanceOf;
53     mapping (address => mapping (address => uint256)) public allowance;
54 
55     // This generates a public event on the blockchain that will notify clients
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 
58     // This notifies clients about the amount burnt
59     event Burn(address indexed from, uint256 value);
60 
61     /**
62      * Constructor function
63      *
64      * Initializes contract with initial supply tokens to the creator of the contract
65      */
66     function AmeriCoin(
67 
68     ) public {
69         totalSupply = _myinitialSupply * (10 ** uint256(_myDecimal));  // Update total supply with the decimal amount
70         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
71         name = _myTokeName;                                   // Set the name for display purposes
72         symbol = _mySymbol;                               // Set the symbol for display purposes
73     }
74 
75     /**
76      * Internal transfer, only can be called by this contract
77      */
78     function _transfer(address _from, address _to, uint _value) internal {
79         // Prevent transfer to 0x0 address. Use burn() instead
80         require(_to != 0x0);
81         // Check if the sender has enough
82         require(balanceOf[_from] >= _value);
83         // Check for overflows
84         require(balanceOf[_to] + _value > balanceOf[_to]);
85         // Save this for an assertion in the future
86         uint previousBalances = balanceOf[_from] + balanceOf[_to];
87         // Subtract from the sender
88         balanceOf[_from] -= _value;
89         // Add the same to the recipient
90         balanceOf[_to] += _value;
91         Transfer(_from, _to, _value);
92         // Asserts are used to use static analysis to find bugs in your code. They should never fail
93         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
94     }
95 
96     /**
97      * Transfer tokens
98      *
99      * Send `_value` tokens to `_to` from your account
100      *
101      * @param _to The address of the recipient
102      * @param _value the amount to send
103      */
104     function transfer(address _to, uint256 _value) public returns (bool) {
105         require(_to != address(0));
106         require(_value <= balanceOf[msg.sender]);
107 
108         // SafeMath.sub will throw if there is not enough balance.
109         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
110         balanceOf[_to] = balanceOf[_to].add(_value);
111         Transfer(msg.sender, _to, _value);
112         return true;
113     }
114 
115     /**
116      * Transfer tokens from other address
117      *
118      * Send `_value` tokens to `_to` in behalf of `_from`
119      *
120      * @param _from The address of the sender
121      * @param _to The address of the recipient
122      * @param _value the amount to send
123      */
124     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
125         require(_to != address(0));
126         require(_value <= balanceOf[_from]);
127         require(_value <= allowance[_from][msg.sender]);
128 
129         balanceOf[_from] = balanceOf[_from].sub(_value);
130         balanceOf[_to] = balanceOf[_to].add(_value);
131         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
132         Transfer(_from, _to, _value);
133         return true;
134     }
135 
136     /**
137      * Set allowance for other address
138      *
139      * Allows `_spender` to spend no more than `_value` tokens in your behalf
140      *
141      * @param _spender The address authorized to spend
142      * @param _value the max amount they can spend
143      */
144     function approve(address _spender, uint256 _value) public
145         returns (bool success) {
146         allowance[msg.sender][_spender] = _value;
147         return true;
148     }
149 
150     /**
151      * Set allowance for other address and notify
152      *
153      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
154      *
155      * @param _spender The address authorized to spend
156      * @param _value the max amount they can spend
157      * @param _extraData some extra information to send to the approved contract
158      */
159     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
160         public
161         returns (bool success) {
162         tokenRecipient spender = tokenRecipient(_spender);
163         if (approve(_spender, _value)) {
164             spender.receiveApproval(msg.sender, _value, this, _extraData);
165             return true;
166         }
167     }
168 
169     
170     
171 }