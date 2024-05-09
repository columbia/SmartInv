1 pragma solidity ^0.4.22;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 contract DBXCContract {
56     // Public variables of the token
57     string public name;
58     string public symbol;
59     uint8 public decimals = 18;
60     // 18 decimals is the strongly suggested default, avoid changing it
61     uint256 public totalSupply;
62 
63     // This creates an array with all balances
64     mapping (address => uint256) public balanceOf;
65     mapping (address => mapping (address => uint256)) public allowed;
66 
67     // This generates a public event on the blockchain that will notify clients
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70 
71     /**
72      * Constructor function
73      *
74      * Initializes contract with initial supply tokens to the creator of the contract
75      */
76     constructor(
77         uint256 initialSupply,
78         string tokenName,
79         string tokenSymbol
80     ) public {
81         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
82         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
83         name = tokenName;                                   // Set the name for display purposes
84         symbol = tokenSymbol;                               // Set the symbol for display purposes
85     }
86 
87     /**
88      * Internal transfer, only can be called by this contract
89      */
90     function _transfer(address _from, address _to, uint256 _value) internal {
91         // Prevent transfer to 0x0 address. Use burn() instead
92         require(_to != address(0x0));
93         // Check if the sender has enough
94         require(balanceOf[_from] >= _value);
95         // Check for overflows
96         require(balanceOf[_to] + _value >= balanceOf[_to]);
97         // Save this for an assertion in the future
98         uint previousBalances = balanceOf[_from] + balanceOf[_to];
99         // Subtract from the sender
100         balanceOf[_from] -= _value;
101         // Add the same to the recipient
102         balanceOf[_to] += _value;
103         emit Transfer(_from, _to, _value);
104         // Asserts are used to use static analysis to find bugs in your code. They should never fail
105         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
106     }
107 
108     /**
109      * Transfer tokens
110      *
111      * Send `_value` tokens to `_to` from your account
112      *
113      * @param _to The address of the recipient
114      * @param _value the amount to send
115      */
116     function transfer(address _to, uint256 _value) public returns (bool success) {
117         _transfer(msg.sender, _to, _value);
118         return true;
119     }
120 
121     /**
122      * Transfer tokens from other address
123      *
124      * Send `_value` tokens to `_to` on behalf of `_from`
125      *
126      * @param _from The address of the sender
127      * @param _to The address of the recipient
128      * @param _value the amount to send
129      */
130     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
131         require(_value <= allowed[_from][msg.sender]);     // Check allowance
132         allowed[_from][msg.sender] -= _value;
133         _transfer(_from, _to, _value);
134         return true;
135     }
136 
137     /**
138      * IncreaseApproval
139      *
140      * @param _spender The address authorized to spend
141      * @param _addedValue the added amount
142      */
143     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
144         allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender],_addedValue);
145         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146         return true;
147     }
148 
149     /**
150      * DecreaseApproval
151      *
152      * @param _spender The address authorized to spend
153      * @param _subtractedValue the subtracted amount
154      */
155     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
156         uint oldValue = allowed[msg.sender][_spender];
157         if (_subtractedValue > oldValue) {
158             allowed[msg.sender][_spender] = 0;
159         } else {
160             allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
161         }
162         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163         return true;
164     }
165 
166     /**
167      * Get allowance 
168      *
169      */
170     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
171         return allowed[_owner][_spender];
172     }
173 
174     /* Allow another contract to spend some tokens in your behalf */
175     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
176         allowed[msg.sender][_spender] = _value;     
177         tokenRecipient spender = tokenRecipient(_spender);
178         spender.receiveApproval(msg.sender, _value, this, _extraData); 
179         return true; 
180     }
181 }