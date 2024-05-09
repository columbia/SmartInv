1 pragma solidity ^0.4.13; 
2 
3 contract owned {
4     address public owner;
5     function owned() {
6         owner = msg.sender;
7     }
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12 
13     function transferOwnership(address newOwner) onlyOwner {
14         owner = newOwner;
15     }
16   }
17 contract tokenRecipient {
18      function receiveApproval(address from, uint256 value, address token, bytes extraData); 
19 }
20 contract token {
21     /*Public variables of the token */
22     string public name; string public symbol; uint8 public decimals; uint256 public totalSupply;
23     /* This creates an array with all balances */
24     mapping (address => uint256) public balanceOf;
25     mapping (address => mapping (address => uint256)) public allowance;
26     /* This generates a public event on the blockchain that will notify clients */
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     /* This notifies clients about the amount burnt */
29     event Burn(address indexed from, uint256 value);
30     /* Initializes contract with initial supply tokens to the creator of the contract */
31     function token() {
32     balanceOf[msg.sender] = 10000000000000000; 
33     totalSupply = 10000000000000000; 
34     name = "BCB"; 
35     symbol =  "฿";
36     decimals = 8; 
37     }
38     /* Internal transfer, only can be called by this contract */
39     function _transfer(address _from, address _to, uint _value) internal {
40         require (_to != 0x0); 
41         require (balanceOf[_from] > _value); 
42         require (balanceOf[_to] + _value > balanceOf[_to]); 
43         balanceOf[_from] -= _value; 
44         balanceOf[_to] += _value; 
45         Transfer(_from, _to, _value);
46     }
47 
48     function transfer(address _to, uint256 _value) {
49         _transfer(msg.sender, _to, _value);
50     }
51 
52     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
53         require (_value < allowance[_from][msg.sender]); 
54         allowance[_from][msg.sender] -= _value;
55         _transfer(_from, _to, _value);
56         return true;
57     }
58 
59     function approve(address _spender, uint256 _value)
60         returns (bool success) {
61         allowance[msg.sender][_spender] = _value;
62         return true;
63     }
64 
65     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
66         returns (bool success) {
67         tokenRecipient spender = tokenRecipient(_spender);
68         if (approve(_spender, _value)) {
69         spender.receiveApproval(msg.sender, _value, this, _extraData);
70         return true;
71         }
72     }
73     /// @notice Remove `_value` tokens from the system irreversibly
74     /// @param _value the amount of money to burn
75     function burn(uint256 _value) returns (bool success) {
76         require (balanceOf[msg.sender] > _value); // Check if the sender has enough
77         balanceOf[msg.sender] -= _value; // Subtract from the sender
78         totalSupply -= _value; // Updates totalSupply
79         Burn(msg.sender, _value);
80         return true;
81     }
82 
83     function burnFrom(address _from, uint256 _value) returns (bool success) {
84         require(balanceOf[_from] >= _value); // Check if the targeted balance is enough
85         require(_value <= allowance[_from][msg.sender]); // Check allowance
86         balanceOf[_from] -= _value; // Subtract from the targeted balance
87         allowance[_from][msg.sender] -= _value; // Subtract from the sender's allowance
88         totalSupply -= _value; // Update totalSupply
89         Burn(_from, _value);
90         return true;
91       }
92    }
93 
94 contract BcbToken is owned, token {
95     mapping (address => bool) public frozenAccount;
96     /* This generates a public event on the blockchain that will notify clients */
97     event FrozenFunds(address target, bool frozen);
98   
99 
100 
101     function _transfer(address _from, address _to, uint _value) internal {
102         require (_to != 0x0); 
103      
104         require(msg.sender != _to);
105         require (balanceOf[_from] > _value); // Check if the sender has enough
106         require (balanceOf[_to] + _value > balanceOf[_to]); 
107         require(!frozenAccount[_from]); // Check if sender is frozen
108         require(!frozenAccount[_to]); // Check if recipient is frozen
109         balanceOf[_from] -= _value; // Subtract from the sender
110         balanceOf[_to] += _value; // Add the same to the recipient
111         Transfer(_from, _to, _value);
112     }
113 
114     function freezeAccount(address target, bool freeze) onlyOwner {
115         frozenAccount[target] = freeze;
116         FrozenFunds(target, freeze);
117     }
118     }