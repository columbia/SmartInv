1 pragma solidity ^0.4.16;
2 
3 contract BIOBIT {
4     // Public variables of the token
5     string public name;
6     string public symbol;
7     uint256 public totalSupply;
8     uint256 public limitSupply;
9     address public owner;
10 
11     modifier onlyOwner(){
12         require(msg.sender == owner);
13         _;
14     }
15     
16     modifier onlyAdmin(){
17         require(msg.sender == owner || administrators[msg.sender] == true);
18         _;
19     }
20     
21     // This creates an array with all balances
22     mapping (address => uint256) private balanceOf;
23     
24     // This creates an array with all balances
25     mapping (address => bool) public administrators;
26     
27     // This generates a public event on the blockchain that will notify clients
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     
30     event TransferByAdmin(address indexed admin, address indexed from, address indexed to, uint256 value);
31     
32    /**
33     * Constrctor function
34     *
35     * Initializes contract with initial supply tokens to the creator of the contract
36     */
37     function BIOBIT() public{
38         owner = msg.sender;
39         limitSupply = 150000000;
40         uint256 initialSupply = 25000000;
41         totalSupply = initialSupply;              // Update total supply
42         balanceOf[owner] = initialSupply;       
43         name = "BIOBIT";                          // Set the name for display purposes
44         symbol = "฿";                             // Set the symbol for display purposes
45     }
46 
47    /** Get My Balance
48     *
49     * Get your Balance BIOBIT
50     * 
51     */
52     function balance() public constant returns(uint){
53         return balanceOf[msg.sender];
54         
55     }
56     
57     /**
58     * Transfer tokens
59     *
60     * Send `_value` tokens to `_to` from your account
61     *
62     * @param _to The address of the recipient
63     * @param _value the amount to send
64     */
65     function transfer(address _to, uint256 _value)  public
66     {       // Add the same to the recipient
67             require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
68             require(balanceOf[msg.sender] >= _value);                // Check if the sender has enough
69             require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
70             balanceOf[msg.sender] -= _value;                         // Subtract from the sender
71             balanceOf[_to] += _value;                           // Add the same to the recipient
72             Transfer(msg.sender, _to, _value);
73     }
74     
75         
76     /**
77     *
78     * incremento de  existencias de tokens 5 millions
79     * 
80     */
81     function incrementSupply() onlyOwner public returns(bool){
82             uint256 _value = 5000000;
83             require(totalSupply + _value <= limitSupply);
84             totalSupply += _value;
85             balanceOf[owner] += _value;
86     }
87     
88    /**
89     * Transfer tokens from other address
90     *
91     * Send `_value` tokens to `_to` in behalf of `_from`
92     *
93     * @param _from The address of the sender
94     * @param _to The address of the recipient
95     * @param _value the amount to send
96     */
97     function transferByAdmin(address _from, address _to, uint256 _value) onlyAdmin public returns (bool success) {
98         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
99         require(_from != 0x0);                             // Prevent transfer to 0x0 address. Use burn() instead
100         require(_from != owner);                           // Prevent transfer token from owner
101         require(administrators[_from] == false);           // prevent transfer from administrators
102         require(balanceOf[_from] >= _value);               // Check if the sender has enough
103         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
104         balanceOf[_from] -= _value;                         // Subtract from the sender
105         balanceOf[_to] += _value;                           // Add the same to the recipient
106         TransferByAdmin(msg.sender,_from, _to, _value);
107         return true;
108     }
109     
110     /**
111     * Transfer tokens from other address
112     * @param from_ get address from
113     */
114     function balancefrom(address from_) onlyAdmin  public constant returns(uint){
115               return balanceOf[from_];
116     }
117 
118     function setAdmin(address admin_, bool flag_) onlyOwner public returns (bool success){
119         administrators[admin_] = flag_;
120         return true;
121     }
122   
123 }