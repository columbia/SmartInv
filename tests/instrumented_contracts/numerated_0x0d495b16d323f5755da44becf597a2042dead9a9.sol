1 /*
2 *
3 *  v1.0
4 *  
5 *  By EP Cloud Team 
6 *
7 */
8 pragma solidity 0.5.10;
9 
10 contract Ownable {
11     address public owner;
12 
13     constructor() public {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner {
18         require(msg.sender == owner, "msg.sender != owner");
19         _;
20     }
21 
22     function transferOwnership(address _newOwner) public onlyOwner {
23         owner = _newOwner;
24     }
25 }
26 
27 
28 contract Pausable is Ownable {
29   event Pause();
30   event Unpause();
31   bool public paused = false;
32 
33   modifier whenNotPaused() {
34     assert(!paused);
35     _;
36   }
37 
38   modifier whenPaused() {
39     assert(paused);
40     _;
41   }
42 
43   function pause() public onlyOwner whenNotPaused {
44     paused = true;
45     emit Pause();
46   }
47 
48   function unpause() public onlyOwner whenPaused{
49     paused = false;
50     emit Unpause();
51   }
52 }
53 
54 
55 contract TokenERC20 is Pausable {
56     // Public variables of the token
57     string public name;
58     string public symbol;
59     uint8 public decimals;
60     // 18 decimals is the strongly suggested default, avoid changing it
61     uint256 public totalSupply;
62 
63     // This creates an array with all balances
64     mapping (address => uint256) public balanceOf;
65     mapping (address => mapping (address => uint256)) public allowance;
66 
67     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
68 
69     // This generates a public event on the blockchain that will notify clients
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71 
72     /**
73      * Constrctor function
74      *
75      * Initializes contract with initial supply tokens to the creator of the contract
76      */
77     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint _totalSupply) public {
78         name = _name;
79         symbol = _symbol;
80         decimals = _decimals;
81         totalSupply = _totalSupply * 10 ** uint256(decimals);
82         balanceOf[msg.sender] = totalSupply;
83     }
84 
85     /**
86      * Transfer tokens
87      *
88      * Send `_value` tokens to `_to` from your account
89      *
90      * @param _to The address of the recipient
91      * @param _value the amount to send
92      */
93     function transfer(address _to, uint256 _value) public returns (bool success) {
94         return _transfer(msg.sender, _to, _value);
95     }
96 
97     /**
98      * Transfer tokens from other address
99      *
100      * Send `_value` tokens to `_to` in behalf of `_from`
101      *
102      * @param _from The address of the sender
103      * @param _to The address of the recipient
104      * @param _value the amount to send
105      */
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
107         // Check allowance
108         require(allowance[_from][msg.sender] >= _value, "allowance[_from][msg.sender] < _value");
109         allowance[_from][msg.sender] -= _value;
110         _transfer(_from, _to, _value);
111         return true;
112     }
113 
114     /**
115      * Set allowance for other address
116      *
117      * Allows `_spender` to spend no more than `_value` tokens in your behalf
118      *
119      * @param _spender The address authorized to spend
120      * @param _value the max amount they can spend
121      */
122     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
123         allowance[msg.sender][_spender] = _value;
124         emit Approval(msg.sender, _spender, _value);
125         return true;
126     }
127 
128     /**
129      * Internal transfer, only can be called by this contract
130      */
131     function _transfer(address _from, address _to, uint _value) internal whenNotPaused returns (bool success) {
132         // Prevent transfer to 0x0 address. Use burn() instead
133         require(_to != address(0), "_to == address(0)");
134         // Check if the sender has enough
135         require(balanceOf[_from] >= _value, "balanceOf[_from] < _value");
136         // Check for overflows
137         require(balanceOf[_to] + _value >= balanceOf[_to], "balanceOf[_to] + _value < balanceOf[_to]");
138         // Save this for an assertion in the future
139         uint previousBalances = balanceOf[_from] + balanceOf[_to];
140         // Subtract from the sender
141         balanceOf[_from] -= _value;
142         // Add the same to the recipient
143         balanceOf[_to] += _value;
144         emit Transfer(_from, _to, _value);
145         // Asserts are used to use static analysis to find bugs in your code. They should never fail
146         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
147         return true;
148     }
149 
150 }