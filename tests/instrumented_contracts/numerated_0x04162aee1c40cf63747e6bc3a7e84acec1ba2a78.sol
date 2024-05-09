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
18         
19     }
20     
21 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }     
22 
23 
24 
25 
26     contract apecashProject is owned {
27          string public name;
28 string public symbol;
29 uint8 public decimals;
30 
31 uint public _totalSupply = 250000000000000000000000000;
32         
33         /* This creates an array with all balances */
34         mapping (address => uint256) public balanceOf;
35         uint256 public totalSupply;
36         
37             event Transfer(address indexed from, address indexed to, uint256 value);
38         // This generates a public event on the blockchain that will notify clients
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41     // This notifies clients about the amount burnt
42     event Burn(address indexed from, uint256 value);
43         
44         /* Initializes contract with initial supply tokens to the creator of the contract */
45         
46     constructor() public {
47         totalSupply = 250000000000000000000000000;  // Update total supply with the decimal amount
48         balanceOf[msg.sender] = 250000000000000000000000000;                // Give the creator all initial tokens
49         name = "ApeCash";                                   // Set the name for display purposes
50         symbol = "APE";                               // Set the symbol for display purposes
51         decimals = 18;                            // Amount of decimals for display purposes
52     }
53     
54 
55         /* Send coins */
56         function transfer(address _to, uint256 _value) public {
57         /* Check if sender has balance and for overflows */
58         require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
59 
60         /* Add and subtract new balances */
61         balanceOf[msg.sender] -= _value;
62         balanceOf[_to] += _value;
63         
64                 /* Notify anyone listening that this transfer took place */
65         emit Transfer(msg.sender, _to, _value);
66     }
67     
68       /**
69      * Internal transfer, only can be called by this contract
70      */
71     function _transfer(address _from, address _to, uint _value) internal {
72         // Prevent transfer to 0x0 address. Use burn() instead
73         require(_to != 0x0);
74         // Check if the sender has enough
75         require(balanceOf[_from] >= _value);
76         // Check for overflows
77         require(balanceOf[_to] + _value > balanceOf[_to]);
78         // Save this for an assertion in the future
79         uint previousBalances = balanceOf[_from] + balanceOf[_to];
80         // Subtract from the sender
81         balanceOf[_from] -= _value;
82         // Add the same to the recipient
83         balanceOf[_to] += _value;
84         emit Transfer(_from, _to, _value);
85         // Asserts are used to use static analysis to find bugs in your code. They should never fail
86         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
87     }
88     
89   
90     
91     }