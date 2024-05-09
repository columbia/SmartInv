1 pragma solidity ^0.4.25;
2 
3 contract Ownable {
4     address public owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     constructor() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner() {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) public onlyOwner {
18         require(newOwner != address(0));
19         emit OwnershipTransferred(owner, newOwner);
20         owner = newOwner;
21     }
22 }
23 
24 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
25 
26 contract Sugma is Ownable {
27     // Public variables of the token
28     string public name;
29     string public symbol;
30     uint8 public decimals = 18;
31     // 18 decimals is the strongly suggested default, avoid changing it
32     uint256 public totalSupply;
33 
34     // This creates an array with all balances
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     // This generates a public event on the blockchain that will notify clients
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 
41     // This generates a public event on the blockchain that will notify clients
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 
44     // This notifies clients about the amount burnt
45     event Burn(address indexed from, uint256 value);
46 
47 
48     /**
49      * Constructor function
50      *
51      * Initializes contract with initial supply tokens to the creator of the contract
52      */
53 
54     constructor() public {
55         totalSupply = 600000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
56         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
57         name = 'Soraix Test Token';                                   // Set the name for display purposes
58         symbol = 'SRXT';                               // Set the symbol for display purposes
59         emit Transfer(address(0), msg.sender, totalSupply); // Minting event notification
60     }
61 
62     /**
63      * Internal transfer, only can be called by this contract
64      */
65     function _transfer(address _from, address _to, uint _value) internal {
66         // Prevent transfer to 0x0 address. Use burn() instead
67         require(_to != address(0x0));
68         // Check if the sender has enough
69         require(balanceOf[_from] >= _value);
70         // Check for overflows
71         require(balanceOf[_to] + _value > balanceOf[_to]);
72         // Save this for an assertion in the future
73         uint previousBalances = balanceOf[_from] + balanceOf[_to];
74         // Subtract from the sender
75         balanceOf[_from] -= _value;
76         // Add the same to the recipient
77         balanceOf[_to] += _value;
78         emit Transfer(_from, _to, _value);
79         // Asserts are used to use static analysis to find bugs in your code. They should never fail
80         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
81     }
82 
83     /**
84      * Transfer tokens
85      *
86      * Send `_value` tokens to `_to` from your account
87      *
88      * @param _to The address of the recipient
89      * @param _value the amount to send
90      */
91     function transfer(address _to, uint256 _value) public returns (bool success) {
92         _transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     /**
97      * Transfer tokens from other address
98      *
99      * Send `_value` tokens to `_to` on behalf of `_from`
100      *
101      * @param _from The address of the sender
102      * @param _to The address of the recipient
103      * @param _value the amount to send
104      */
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
106         require(_value <= allowance[_from][msg.sender]);     // Check allowance
107         allowance[_from][msg.sender] -= _value;
108         _transfer(_from, _to, _value);
109         return true;
110     }
111 
112     /**
113      * Set allowance for other address
114      *
115      * Beware that changing an allowance with this method brings the risk that someone may use both the old
116      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
117      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
118      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
119      *
120      * Allows `_spender` to spend no more than `_value` tokens on your behalf
121      *
122      * @param _spender The address authorized to spend
123      * @param _value the max amount they can spend
124      */
125     function approve(address _spender, uint256 _value) public returns (bool success) {
126         allowance[msg.sender][_spender] = _value;
127         emit Approval(msg.sender, _spender, _value);
128         return true;
129     }
130 
131     /**
132      * Set allowance for other address and notify
133      *
134      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
135      *
136      * @param _spender The address authorized to spend
137      * @param _value the max amount they can spend
138      * @param _extraData some extra information to send to the approved contract
139      */
140     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
141         tokenRecipient spender = tokenRecipient(_spender);
142         if (approve(_spender, _value)) {
143             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
144             return true;
145         }
146     }
147 
148     /**
149      * Destroy tokens
150      *
151      * Remove `_value` tokens from the system irreversibly
152      *
153      * @param _value the amount of money to burn
154      */
155     function burn(uint256 _value) public returns (bool success) {
156         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
157         balanceOf[msg.sender] -= _value;            // Subtract from the sender
158         totalSupply -= _value;                      // Updates totalSupply
159         emit Burn(msg.sender, _value);
160         return true;
161     }
162 
163     /**
164      * Destroy tokens from other account
165      *
166      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
167      *
168      * @param _from the address of the sender
169      * @param _value the amount of money to burn
170      */
171     function burnFrom(address _from, uint256 _value) public returns (bool success) {
172         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
173         require(_value <= allowance[_from][msg.sender]);    // Check allowance
174         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
175         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
176         totalSupply -= _value;                              // Update totalSupply
177         emit Burn(_from, _value);
178         return true;
179     }
180 }