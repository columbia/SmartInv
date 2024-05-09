1 contract owned {
2     address public owner;
3 
4     function owned() public {
5         owner = msg.sender;
6     }
7 
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12 
13     function transferOwnership(address newOwner) onlyOwner public {
14         owner = newOwner;
15     }
16 }
17 
18 contract Shaycoin is owned {
19     // Public variables of the token
20     string public name;
21     string public symbol;
22     uint256 public decimals = 18; // 18 decimals is the strongly suggested default, avoid changing it
23     uint256 public totalSupply;
24     uint256 public donations = 0;
25 
26     uint256 public price = 200000000000000;
27 
28     // This creates an array with all balances
29     mapping (address => uint256) public balanceOf;
30     mapping (uint256 => address) public depositIndex;
31     mapping (address => bool) public depositBool;
32     uint256 public indexTracker = 0;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     /**
38      * Constructor function
39      *
40      * Initializes contract with initial supply tokens to the contract
41      */
42     function Shaycoin(
43         uint256 initialSupply,
44         string tokenName,
45         string tokenSymbol
46     ) public {
47         totalSupply = initialSupply * 10 ** decimals;  // Update total supply with the decimal amount
48         balanceOf[this] = totalSupply;                // Give the contract all initial tokens
49         name = tokenName;                                   // Set the name for display purposes
50         symbol = tokenSymbol;                               // Set the symbol for display purposes
51     }
52 
53     /* Internal transfer, only can be called by this contract */
54     function _transfer(address _from, address _to, uint256 _value) internal {
55         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
56         require (balanceOf[_from] >= _value);               // Check if the sender has enough
57         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
58         balanceOf[_from] -= _value;                         // Subtract from the sender
59         balanceOf[_to] += _value;                           // Add the same to the recipient
60         if (_to != address(this) && !depositBool[_to]) {
61            depositIndex[indexTracker] = _to;
62            depositBool[_to] = true;
63            indexTracker += 1;
64         }
65         Transfer(_from, _to, _value);
66     }
67 
68     /// @notice Buy tokens from contract by sending ether
69     function buy() payable public {
70         uint256 amount = 10 ** decimals * msg.value / price;               // calculates the amount
71         if (amount > balanceOf[this]) {
72             totalSupply += amount - balanceOf[this];
73             balanceOf[this] = amount;
74         }
75         _transfer(this, msg.sender, amount);                                        // makes the transfers       
76     }
77 
78     /// @notice Sell `amount` tokens to contract
79     /// @param amount amount of tokens to be sold
80     function sell(uint256 amount) public {
81         require(this.balance >= amount * price / 10 ** decimals);      // checks if the contract has enough ether to buy
82         _transfer(msg.sender, this, amount);                                    // makes the transfers
83         msg.sender.transfer(amount * price / 10 ** decimals);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
84     }
85 
86     function donate() payable public {
87         donations += msg.value;
88     }
89 
90     function collectDonations() onlyOwner public {
91         owner.transfer(donations);
92         donations = 0;
93     }
94 
95     /* Function to recover the funds on the contract */
96     function killAndRefund() onlyOwner public {
97         for (uint256 i = 0; i < indexTracker; i++) {
98             depositIndex[i].transfer(balanceOf[depositIndex[i]] * price / 10 ** decimals);
99         }
100         selfdestruct(owner);
101     }
102 
103     /**
104      * Transfer tokens
105      *
106      * Send `_value` tokens to `_to` from your account
107      *
108      * @param _to The address of the recipient
109      * @param _value the amount to send
110      */
111     function transfer(address _to, uint256 _value) public {
112         _transfer(msg.sender, _to, _value);
113     }
114 
115  }