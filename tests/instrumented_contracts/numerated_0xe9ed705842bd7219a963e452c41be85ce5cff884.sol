1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         assert(a == b * c);
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a - b;
26         assert(b <= a);
27         assert(a == c + b);
28         return c;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         assert(a == c - b);
35         return c;
36     }
37 }
38 
39 interface tokenRecipient {
40     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
41 }
42 
43 contract JoyTubeToken {
44 
45     // Public variables of the token
46     string public name = 'JoyTube Token';
47 
48     string public symbol = 'JTT';
49 
50     uint8 public decimals = 18;
51 
52     uint256 public totalSupply = 30 * (10 ** 8) * (10 ** uint256(decimals));     //30 * (10 ** 8) * (10 ** uint256(decimals));
53 
54     address public issueContractAddress;
55     address public owner;
56 
57     // This creates an array with all balances
58     mapping (address => uint256) public balanceOf;
59 
60     mapping (address => mapping (address => uint256)) public allowance;
61 
62     // This generates a public event on the blockchain that will notify clients
63     event Transfer(address indexed from, address indexed to, uint256 value);
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65     // This notifies clients about the amount burnt
66     event Burn(address indexed from, uint256 value);
67     event Issue(uint256 amount);
68 
69     /**
70      * Constrctor function
71      *
72      * Initializes contract with initial supply tokens to the creator of the contract
73      */
74     function JoyTubeToken() public {
75         owner = msg.sender;
76         balanceOf[owner] = totalSupply;
77         // create new issue contract
78         // issueContractAddress = new JoyTubeTokenIssue(address(this));
79         issueContractAddress = address(this);
80     }
81 
82     /**
83      * issue new token
84      *
85      * Initializes contract with initial supply tokens to the creator of the contract
86      */
87     function issue(uint256 amount) public {
88         require(msg.sender == issueContractAddress);
89         balanceOf[owner] = SafeMath.add(balanceOf[owner], amount);
90         totalSupply = SafeMath.add(totalSupply, amount);
91         Issue(amount);
92     }
93 
94     /**
95       * @dev Gets the balance of the specified address.
96       * @param _owner The address to query the the balance of.
97       * @return An uint256 representing the amount owned by the passed address.
98       */
99     function balanceOf(address _owner) public view returns (uint256 balance) {
100         return balanceOf[_owner];
101     }
102 
103     /**
104       * Internal transfer, only can be called by this contract
105       */
106     function _transfer(address _from, address _to, uint _value) internal {
107         // Prevent transfer to 0x0 address. Use burn() instead
108         require(_to != 0x0);
109         // Check if the sender has enough
110         require(balanceOf[_from] >= _value);
111         // Check for overflows
112         require(balanceOf[_to] + _value > balanceOf[_to]);
113         // Save this for an assertion in the future
114         uint previousBalances = balanceOf[_from] + balanceOf[_to];
115         // Subtract from the sender
116         balanceOf[_from] -= _value;
117         // Add the same to the recipient
118         balanceOf[_to] += _value;
119         Transfer(_from, _to, _value);
120         // Asserts are used to use static analysis to find bugs in your code. They should never fail
121         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
122     }
123 
124     /**
125      * Transfer tokens
126      *
127      * Send `_value` tokens to `_to` from your account
128      *
129      * @param _to The address of the recipient
130      * @param _value the amount to send
131      */
132     function transfer(address _to, uint256 _value) public returns (bool success){
133         _transfer(msg.sender, _to, _value);
134         return true;
135     }
136 
137     /**
138      * Transfer tokens from other address
139      *
140      * Send `_value` tokens to `_to` in behalf of `_from`
141      *
142      * @param _from The address of the sender
143      * @param _to The address of the recipient
144      * @param _value the amount to send
145      */
146     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
147         require(_value <= allowance[_from][msg.sender]);
148         // Check allowance
149         allowance[_from][msg.sender] -= _value;
150         _transfer(_from, _to, _value);
151         return true;
152     }
153 
154     /**
155      * Set allowance for other address
156      *
157      * Allows `_spender` to spend no more than `_value` tokens in your behalf
158      *
159      * @param _spender The address authorized to spend
160      * @param _value the max amount they can spend
161      */
162     function approve(address _spender, uint256 _value) public returns (bool success) {
163         require(_value <= balanceOf[msg.sender]);
164         allowance[msg.sender][_spender] = _value;
165         Approval(msg.sender, _spender, _value);
166         return true;
167     }
168 
169     /**
170      * Set allowance for other address and notify
171      *
172      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
173      *
174      * @param _spender The address authorized to spend
175      * @param _value the max amount they can spend
176      * @param _extraData some extra information to send to the approved contract
177      */
178     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
179         tokenRecipient spender = tokenRecipient(_spender);
180         if (approve(_spender, _value)) {
181             spender.receiveApproval(msg.sender, _value, this, _extraData);
182             return true;
183         }
184     }
185 
186     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
187         return allowance[_owner][_spender];
188     }
189 }