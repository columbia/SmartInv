1 /*
2 
3 Verification submitted to etherscan.io by Noel Maersk
4 Source with full comments: https://gist.github.com/alexvandesande/3abc9f741471e08a6356#file-unicorn-meat-token
5 
6 */
7 
8     contract owned {
9         address public owner;
10 
11         function owned() {
12             owner = msg.sender;
13         }
14 
15         modifier onlyOwner {
16             if (msg.sender != owner) throw;
17             _
18         }
19 
20         function transferOwnership(address newOwner) onlyOwner {
21             owner = newOwner;
22         }
23     }
24     
25     contract tokenRecipient { 
26         function receiveApproval(address _from, uint256 _value, address _token); 
27     }
28 
29     contract MyToken is owned { 
30         /* Public variables of the token */
31         string public name;
32         string public symbol;
33         uint8 public decimals;
34         uint256 public totalSupply;
35 
36         /* This creates an array with all balances */
37         mapping (address => uint256) public balanceOf;
38         mapping (address => bool) public frozenAccount; 
39         mapping (address => mapping (address => uint256)) public allowance;
40         mapping (address => mapping (address => uint256)) public spentAllowance;
41 
42         /* This generates a public event on the blockchain that will notify clients */
43         event Transfer(address indexed from, address indexed to, uint256 value);
44         event FrozenFunds(address target, bool frozen);
45 
46         /* Initializes contract with initial supply tokens to the creator of the contract */
47         function MyToken(
48             uint256 initialSupply, 
49             string tokenName, 
50             uint8 decimalUnits, 
51             string tokenSymbol, 
52             address centralMinter 
53         ) { 
54             if(centralMinter != 0 ) owner = msg.sender;         // Sets the minter
55             balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens                    
56             name = tokenName;                                   // Set the name for display purposes     
57             symbol = tokenSymbol;                               // Set the symbol for display purposes    
58             decimals = decimalUnits;                            // Amount of decimals for display purposes
59             totalSupply = initialSupply; 
60         }
61 
62         /* Send coins */
63         function transfer(address _to, uint256 _value) {
64             if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough   
65             if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
66             if (frozenAccount[msg.sender]) throw;                // Check if frozen
67             balanceOf[msg.sender] -= _value;                     // Subtract from the sender
68             balanceOf[_to] += _value;                            // Add the same to the recipient            
69             Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
70         }
71 
72         /* Allow another contract to spend some tokens in your behalf */
73         function approveAndCall(address _spender, uint256 _value) returns (bool success) {
74             allowance[msg.sender][_spender] = _value;  
75             tokenRecipient spender = tokenRecipient(_spender);
76             spender.receiveApproval(msg.sender, _value, this); 
77             return true;         
78         }
79 
80         /* A contract attempts to get the coins */
81         function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
82             if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough   
83             if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
84             if (spentAllowance[_from][msg.sender] + _value > allowance[_from][msg.sender]) throw;   // Check allowance
85             balanceOf[_from] -= _value;                          // Subtract from the sender
86             balanceOf[_to] += _value;                            // Add the same to the recipient            
87             spentAllowance[_from][msg.sender] += _value;
88             Transfer(_from, _to, _value); 
89             return true;
90         } 
91 
92         /* This unnamed function is called whenever someone tries to send ether to it */
93         function () {
94             throw;     // Prevents accidental sending of ether
95         }
96         
97         function mintToken(address target, uint256 mintedAmount) onlyOwner {
98             balanceOf[target] += mintedAmount; 
99             totalSupply += mintedAmount; 
100             Transfer(0, owner, mintedAmount);
101             Transfer(owner, target, mintedAmount);
102         }
103 
104         function freezeAccount(address target, bool freeze) onlyOwner {
105             frozenAccount[target] = freeze;
106             FrozenFunds(target, freeze);
107         }
108 }