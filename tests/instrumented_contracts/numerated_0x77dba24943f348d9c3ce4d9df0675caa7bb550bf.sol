1 pragma solidity 0.5.10;
2 
3 contract Ownable {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner, "msg.sender != owner");
12         _;
13     }
14 
15     function transferOwnership(address _newOwner) public onlyOwner {
16         owner = _newOwner;
17     }
18 }
19 
20 
21 contract Pausable is Ownable {
22   event Pause();
23   event Unpause();
24   bool public paused = false;
25 
26   modifier whenNotPaused() {
27     assert(!paused);
28     _;
29   }
30 
31   modifier whenPaused() {
32     assert(paused);
33     _;
34   }
35 
36   function pause() public onlyOwner whenNotPaused {
37     paused = true;
38     emit Pause();
39   }
40 
41   function unpause() public onlyOwner whenPaused{
42     paused = false;
43     emit Unpause();
44   }
45 }
46 
47 
48 contract TokenERC20 is Pausable {
49     // Public variables of the token
50     string public name;
51     string public symbol;
52     uint8 public decimals;
53     // 18 decimals is the strongly suggested default, avoid changing it
54     uint256 public totalSupply;
55 
56     // This creates an array with all balances
57     mapping (address => uint256) public balanceOf;
58     mapping (address => mapping (address => uint256)) public allowance;
59 
60     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
61 
62     // This generates a public event on the blockchain that will notify clients
63     event Transfer(address indexed _from, address indexed _to, uint256 _value);
64 
65     /**
66      * Constrctor function
67      *
68      * Initializes contract with initial supply tokens to the creator of the contract
69      */
70     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint _totalSupply) public {
71         name = _name;
72         symbol = _symbol;
73         decimals = _decimals;
74         totalSupply = _totalSupply * 10 ** uint256(decimals);
75         balanceOf[msg.sender] = totalSupply;
76     }
77 
78     /**
79      * Transfer tokens
80      *
81      * Send `_value` tokens to `_to` from your account
82      *
83      * @param _to The address of the recipient
84      * @param _value the amount to send
85      */
86     function transfer(address _to, uint256 _value) public returns (bool success) {
87         return _transfer(msg.sender, _to, _value);
88     }
89 
90     /**
91      * Transfer tokens from other address
92      *
93      * Send `_value` tokens to `_to` in behalf of `_from`
94      *
95      * @param _from The address of the sender
96      * @param _to The address of the recipient
97      * @param _value the amount to send
98      */
99     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
100         // Check allowance
101         require(allowance[_from][msg.sender] >= _value, "allowance[_from][msg.sender] < _value");
102         allowance[_from][msg.sender] -= _value;
103         _transfer(_from, _to, _value);
104         return true;
105     }
106 
107     /**
108      * Set allowance for other address
109      *
110      * Allows `_spender` to spend no more than `_value` tokens in your behalf
111      *
112      * @param _spender The address authorized to spend
113      * @param _value the max amount they can spend
114      */
115     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
116         allowance[msg.sender][_spender] = _value;
117         emit Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     /**
122      * Internal transfer, only can be called by this contract
123      */
124     function _transfer(address _from, address _to, uint _value) internal whenNotPaused returns (bool success) {
125         // Prevent transfer to 0x0 address. Use burn() instead
126         require(_to != address(0), "_to == address(0)");
127         // Check if the sender has enough
128         require(balanceOf[_from] >= _value, "balanceOf[_from] < _value");
129         // Check for overflows
130         require(balanceOf[_to] + _value >= balanceOf[_to], "balanceOf[_to] + _value < balanceOf[_to]");
131         // Save this for an assertion in the future
132         uint previousBalances = balanceOf[_from] + balanceOf[_to];
133         // Subtract from the sender
134         balanceOf[_from] -= _value;
135         // Add the same to the recipient
136         balanceOf[_to] += _value;
137         emit Transfer(_from, _to, _value);
138         // Asserts are used to use static analysis to find bugs in your code. They should never fail
139         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
140         return true;
141     }
142 
143 }