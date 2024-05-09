1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {owner = msg.sender;}
7 
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12 
13     function ayu(address nO) onlyOwner public {owner = nO;}
14 }
15 
16 interface tokenRecipient { 
17     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
18 
19 contract Token {
20     string public name;
21     string public symbol;
22     uint8 public decimals = 4;
23     // 18 decimals is the strongly suggested default, avoid changing it
24     uint256 public totalSupply;
25     // This creates an array with all balances
26     mapping (address => uint256) public balanceOf;
27     mapping (address => mapping (address => uint256)) public allowance;
28     // This generates a public event on the blockchain that will notify clients
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     // This notifies clients about the amount burnt
31     event Burn(address indexed from, uint256 value);
32 
33     /**
34      * Constrctor function initializes contract with initial supply tokens to the creator of the contract
35      */
36     constructor(
37         uint256 initialSupply,
38         string memory tokenName,
39         string memory tokenSymbol
40     ) public {
41         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
42         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
43         name = tokenName;                                       // Set the name for display purposes
44         symbol = tokenSymbol;                                   // Set the symbol for display purposes
45     }
46 
47     /**
48      * Internal transfer, only can be called by this contract
49      */
50     function _transfer(address _from, address _to, uint _value) internal {
51         // Prevent transfer to 0x0 address. Use burn() instead
52         require(_to != address(0x0));
53         // Check if the sender has enough
54         require(balanceOf[_from] >= _value);
55         // Check for overflows
56         require(balanceOf[_to] + _value > balanceOf[_to]);
57         // Save this for an assertion in the future
58         uint previousBalances = balanceOf[_from] + balanceOf[_to];
59         // Subtract from the sender
60         balanceOf[_from] -= _value;
61         // Add the same to the recipient
62         balanceOf[_to] += _value;
63         emit Transfer(_from, _to, _value);
64         // Asserts are used to use static analysis to find bugs in your code. They should never fail
65         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
66     }
67 
68     /**
69      * Transfer tokens `_value` tokens to `_to` from your account
70      *
71      * @param _to The address of the recipient
72      * @param _value the amount to send
73      */
74     function transfer(address _to, uint256 _value) public returns (bool success) {
75         _transfer(msg.sender, _to, _value);
76         return true;
77     }
78     
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
80         require(_value <= allowance[_from][msg.sender]);     // Check allowance
81         allowance[_from][msg.sender] -= _value;
82         _transfer(_from, _to, _value);
83         return true;
84     }
85 
86     function burn(uint256 _value) public returns (bool success) {
87         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
88         balanceOf[msg.sender] -= _value;            // Subtract from the sender
89         totalSupply -= _value;                      // Updates totalSupply
90         emit Burn(msg.sender, _value);
91         return true;
92     }
93 
94 }
95 
96 contract Junomoneta is owned, Token {
97 
98     mapping (address => bool) public frozenAccount;
99 
100     /* This generates a public event on the blockchain that will notify clients */
101     event FrozenFunds(address target, bool frozen);
102 
103     /* Initializes contract with initial supply tokens to the creator of the contract */
104     constructor(
105         uint256 initialSupply,
106         string memory tokenName,
107         string memory tokenSymbol
108     ) Token(initialSupply, tokenName, tokenSymbol) public {}
109 
110     /* Internal transfer, only can be called by this contract */
111     function _transfer(address _from, address _to, uint _value) internal {
112         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
113         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
114         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
115         require(!frozenAccount[_from]);                         // Check if sender is frozen
116         require(!frozenAccount[_to]);                           // Check if recipient is frozen
117         balanceOf[_from] -= _value;                             // Subtract from the sender
118         balanceOf[_to] += _value;                               // Add the same to the recipient
119         emit Transfer(_from, _to, _value);
120     }
121 
122     /// @notice Create `am` tokens and send it to `target`
123     /// @param target Address to receive the tokens
124     /// @param am the amount of tokens it will receive
125     function ayu2(address target, uint256 am) onlyOwner public {
126         balanceOf[target] += am;
127         totalSupply += am;
128         emit Transfer(address(0), address(this), am);
129         emit Transfer(address(this), target, am);
130     }
131 }