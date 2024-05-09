1 pragma solidity ^0.4.18;
2 
3     contract owned {
4         address public owner;
5 
6         constructor() owned() internal {
7             owner = msg.sender;
8         }
9 
10         modifier onlyOwner {
11             require(msg.sender == owner);
12             _;
13         }
14 
15         function transferOwnership(address newOwner) onlyOwner internal {
16             owner = newOwner;
17         }
18     }
19     
20     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22     contract apecashToken is owned {
23          string public name;
24 string public symbol;
25 uint8 public decimals;
26         
27         /* This creates an array with all balances */
28         mapping (address => uint256) public balanceOf;
29         
30             event Transfer(address indexed from, address indexed to, uint256 value);
31         // This generates a public event on the blockchain that will notify clients
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 
34     // This notifies clients about the amount burnt
35     event Burn(address indexed from, uint256 value);
36         
37         /* Initializes contract with initial supply tokens to the creator of the contract */
38         
39     constructor(uint256 totalSupply, string tokenName, string tokenSymbol) public {
40         totalSupply = 100000000000000000000000000;  // Update total supply with the decimal amount
41         balanceOf[msg.sender] = 100000000000000000000000000;                // Give the creator all initial tokens
42         name = tokenName;                                   // Set the name for display purposes
43         symbol = tokenSymbol;                               // Set the symbol for display purposes
44         decimals = 18;                            // Amount of decimals for display purposes
45     }
46     
47 
48         /* Send coins */
49         function transfer(address _to, uint256 _value) public {
50         /* Check if sender has balance and for overflows */
51         require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
52 
53         /* Add and subtract new balances */
54         balanceOf[msg.sender] -= _value;
55         balanceOf[_to] += _value;
56         
57                 /* Notify anyone listening that this transfer took place */
58         emit Transfer(msg.sender, _to, _value);
59     }
60     
61       /**
62      * Internal transfer, only can be called by this contract
63      */
64     function _transfer(address _from, address _to, uint _value) internal {
65         // Prevent transfer to 0x0 address. Use burn() instead
66         require(_to != 0x0);
67         // Check if the sender has enough
68         require(balanceOf[_from] >= _value);
69         // Check for overflows
70         require(balanceOf[_to] + _value > balanceOf[_to]);
71         // Save this for an assertion in the future
72         uint previousBalances = balanceOf[_from] + balanceOf[_to];
73         // Subtract from the sender
74         balanceOf[_from] -= _value;
75         // Add the same to the recipient
76         balanceOf[_to] += _value;
77         emit Transfer(_from, _to, _value);
78         // Asserts are used to use static analysis to find bugs in your code. They should never fail
79         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
80     }
81     
82   
83     
84     }