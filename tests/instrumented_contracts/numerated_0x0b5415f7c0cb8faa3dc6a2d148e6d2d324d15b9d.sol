1 pragma solidity ^0.5.8;
2 
3 
4 
5 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
6 
7 contract ContractTokenERC20 {
8     // Public variables of the token
9     string public name;
10     string public symbol;
11     uint8 public decimals = 18;
12     // 18 decimals is the strongly suggested default, avoid changing it
13     uint256 public totalSupply;
14 
15     // This creates an array with all balances
16     mapping (address => uint256) public balanceOf;
17 
18     // This generates a public event on the blockchain that will notify clients
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     /**
22      * Constrctor function
23      *
24      * Initializes contract with initial supply tokens to the creator of the contract
25      */
26     constructor(
27         uint256 initialSupply,
28         string memory tokenName,
29         string memory tokenSymbol
30     ) public {
31         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
32         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
33         name = tokenName;                                       // Set the name for display purposes
34         symbol = tokenSymbol;                                   // Set the symbol for display purposes
35     }
36 
37     /**
38      * Internal transfer, only can be called by this contract
39      */
40     function _transfer(address _from, address _to, uint _value) internal {
41         // Prevent transfer to 0x0 address. Use burn() instead
42         require(_to != address(0x0));
43         // Check if the sender has enough
44         require(balanceOf[_from] >= _value);
45         // Check for overflows
46         require(balanceOf[_to] + _value > balanceOf[_to]);
47         // Save this for an assertion in the future
48         uint previousBalances = balanceOf[_from] + balanceOf[_to];
49         // Subtract from the sender
50         balanceOf[_from] -= _value;
51         // Add the same to the recipient
52         balanceOf[_to] += _value;
53         emit Transfer(_from, _to, _value);
54         // Asserts are used to use static analysis to find bugs in your code. They should never fail
55         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
56     }
57 
58     /**
59      * Transfer tokens
60      *
61      * Send `_value` tokens to `_to` from your account
62      *
63      * @param _to The address of the recipient
64      * @param _value the amount to send
65      */
66     function transfer(address _to, uint256 _value) public returns (bool success) {
67         _transfer(msg.sender, _to, _value);
68         return true;
69     }
70 
71 
72 
73 
74 }
75 
76 /******************************************/
77 /*       ADVANCED TOKEN STARTS HERE       */
78 /******************************************/
79 
80 contract TSPToken is ContractTokenERC20 {
81 
82 
83 
84     /* Initializes contract with initial supply tokens to the creator of the contract */
85     constructor(
86         uint256 initialSupply,
87         string memory tokenName,
88         string memory tokenSymbol
89     ) ContractTokenERC20(initialSupply, tokenName, tokenSymbol) public {}
90 
91     /* Internal transfer, only can be called by this contract */
92     function _transfer(address _from, address _to, uint _value) internal {
93         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
94         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
95         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
96         balanceOf[_from] -= _value;                             // Subtract from the sender
97         balanceOf[_to] += _value;                               // Add the same to the recipient
98         emit Transfer(_from, _to, _value);
99     }
100     
101 }