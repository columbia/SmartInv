1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes  _extraData) external; 
5 }
6 
7 contract TokenIART {
8     // Public variables of the token
9     string public name;
10     string public symbol;
11     uint8 public decimals = 3;
12     // 18 decimals is the strongly suggested default, avoid changing it
13     uint256 public totalSupply;
14 
15     // This creates an array with all balances
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     // This generates a public event on the blockchain that will notify clients
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     
22     // This generates a public event on the blockchain that will notify clients
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24 
25     // This notifies clients about the amount burnt
26     event Burn(address indexed from, uint256 value);
27 
28     /**
29      * Constructor function
30      *
31      * Initializes contract with initial supply tokens to the creator of the contract
32      */
33     constructor(
34         //uint256 initialSupply,
35         //string memory tokenName,
36         //string memory tokenSymbol
37     ) public {
38         totalSupply = 100000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
39         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
40         name = "internetroad";                                   // Set the name for display purposes
41         symbol = "IART";                               // Set the symbol for display purposes
42     }
43 
44     /**
45      * Internal transfer, only can be called by this contract
46      */
47     function _transfer(address _from, address _to, uint _value) internal {
48         // Prevent transfer to 0x0 address. Use burn() instead
49         require(_to != address(0x0));
50         // Check if the sender has enough
51         require(balanceOf[_from] >= _value);
52         // Check for overflows
53         require(balanceOf[_to] + _value >= balanceOf[_to]);
54         // Save this for an assertion in the future
55         uint previousBalances = balanceOf[_from] + balanceOf[_to];
56         // Subtract from the sender
57         balanceOf[_from] -= _value;
58         // Add the same to the recipient
59         balanceOf[_to] += _value;
60         emit Transfer(_from, _to, _value);
61         // Asserts are used to use static analysis to find bugs in your code. They should never fail
62         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
63     }
64 
65     /**
66      * Transfer tokens
67      *
68      * Send `_value` tokens to `_to` from your account
69      *
70      * @param _to The address of the recipient
71      * @param _value the amount to send
72      */
73     function transfer(address _to, uint256 _value) public returns (bool success) {
74         _transfer(msg.sender, _to, _value);
75         return true;
76     }
77 
78     /**
79      * Transfer tokens from other address
80      *
81      * Send `_value` tokens to `_to` on behalf of `_from`
82      *
83      * @param _from The address of the sender
84      * @param _to The address of the recipient
85      * @param _value the amount to send
86      */
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
88         require(_value <= allowance[_from][msg.sender]);     // Check allowance
89         allowance[_from][msg.sender] -= _value;
90         _transfer(_from, _to, _value);
91         return true;
92     }
93 
94   
95 
96  
97 
98 
99    
100 }