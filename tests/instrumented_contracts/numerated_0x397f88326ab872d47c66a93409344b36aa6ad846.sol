1 pragma solidity ^0.5.2;
2 
3 contract VirtuDollar {
4     // ERC20 standard specs
5     string public name = "Virtu Dollar";
6     string public symbol = "V$";
7     string public standard = "Virtu Dollar v1.0";
8     uint8 public decimals = 18;
9 
10     // VirtuDollar total supply which is publicly visible on the ethereum blockchain.
11     uint256 public VDollars;
12 
13     // Map for owner addresses that holds the balances.
14     mapping( address => uint256) public balanceOf;
15 
16     // Map for owner addresses that holds the allowed addresses and remaining allowance
17     mapping(address => mapping(address => uint256)) public allowance;
18 
19     // Virtu dollar owner identity
20     address owner;
21 
22     // The smart contract will start initially with a zero total supply
23     constructor(uint256 _initialSupply) public {
24         // Initiate the owner
25         owner = msg.sender;
26         // Update the owner balance
27         balanceOf[owner] = _initialSupply * 10 ** uint256(decimals);
28         // Mint the initial virtu dollar supply
29         VDollars = balanceOf[owner];
30     }
31 
32     // Implementing the ERC 20 transfer function
33     function transfer (address _to, uint256 _value) public returns (bool success) {
34         // Require the value to be already present in the balance
35         require(balanceOf[msg.sender] >= _value);
36         // Decrement the balance of the sender
37         balanceOf[msg.sender] -= _value;
38         // Increment the balance of the recipient
39         balanceOf[_to] += _value;
40         // Fire the Transfer event
41         emit Transfer(msg.sender, _to, _value);
42         // Return the success flag
43         return true;
44     }
45 
46     // Implementing the ERC 20 transfer event
47     event Transfer(
48         address indexed _from,
49         address indexed _to,
50         uint256 _value
51     );
52 
53     // Implementing the ERC 20 delegated transfer function
54     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
55         // Checking the value is available in the balance
56         require(_value <= balanceOf[_from]);
57         // Checking the value is allowed
58         require(_value <= allowance[_from][msg.sender]);
59         // Performing the transfer
60         balanceOf[_from] -= _value;
61         balanceOf[_to] += _value;
62         // Decrementing the allowance
63         allowance[_from][msg.sender] -= _value;
64         // Firing the transfer event
65         emit Transfer(_from, _to, _value);
66         // Returning the success flag
67         return true;
68     }
69 
70     // Implementing the ERC 20 approval event
71     event Approval(
72         address indexed _owner,
73         address indexed _spender,
74         uint256 _value
75     );
76 
77     // Impelmenting the ERC 20 approve function
78     function approve(address _spender, uint256 _value) public returns (bool success) {
79         // Setting the allowance to the new amount
80         allowance[msg.sender][_spender] = _value;
81         // Firing the approval event
82         emit Approval(msg.sender, _spender, _value);
83         // Returning the success flag
84         return true;
85     }
86 
87     // Implementing the Burn event
88     event Burn (
89         address indexed _from,
90         uint256 _value
91     );
92 
93     // Implementing the burn function
94     function burn (uint256 _value) public returns (bool success) {
95         // Checking the owner has enough balance
96         require(balanceOf[msg.sender] >= _value);
97         // Decrementing the balance
98         balanceOf[msg.sender] -= _value;
99         // Burning the tokens
100         VDollars -= _value;
101         // Firing the burn event
102         emit Burn(msg.sender, _value);
103         // Returning the success flag
104         return true;
105     }
106 
107     // Implementing the delegated burn function
108     function burnFrom (address _from, uint256 _value) public returns (bool success) {
109         // Check if the owner has enough balance
110         require(balanceOf[_from] >= _value);
111         // Check if the spender has enough allowance
112         require(allowance[_from][msg.sender] >= _value);
113         // Decrement the owner balance
114         balanceOf[_from] -= _value;
115         // Decrement the allowance value
116         allowance[_from][msg.sender] -= _value;
117         // Burn the tokens
118         VDollars -= _value;
119         // Fire the burn event
120         emit Burn(_from, _value);
121         // Returning the success flag
122         return true;
123     }
124 
125     // Implementing the Mint event
126     event Mint(
127         address indexed _from,
128         uint256 _value
129     );
130 
131     // Implementing the mint function
132     function mint (uint256 _value) public returns (bool success) {
133         // Checking the owner is the owner of the coin
134         require(msg.sender == owner);
135         // Incrementing the owner balance
136         balanceOf[owner] += _value;
137         // Minting the tokens
138         VDollars += _value;
139         // Firing the mint event
140         emit Mint(msg.sender, _value);
141         // Returning the success flag
142         return true;
143     }
144 }