1 pragma solidity ^0.4.23;
2 
3 contract ParyToken {
4     /* ERC20 Public variables of the token */
5     string public constant version = 'Pary 0.1';
6     string public name;
7     string public symbol;
8     uint8 public decimals;
9     uint256 public totalSupply;
10 
11     /* ERC20 This creates an array with all balances */
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15 
16     /* store the block number when a withdrawal has been requested*/
17     mapping (address => withdrawalRequest) public withdrawalRequests;
18     struct withdrawalRequest {
19     uint sinceTime;
20     uint256 amount;
21     }
22 
23     uint256 public constant initialSupply = 100000000;
24 
25     /**
26      * ERC20 events these generate a public event on the blockchain that will notify clients
27     */
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 
31     event Deposited(address indexed by, uint256 amount);
32 
33     /**
34      * Initializes contract with initial supply tokens to the creator of the contract
35      * In our case, there's no initial supply. Tokens will be created as ether is sent
36      * to the fall-back function. Then tokens are burned when ether is withdrawn.
37      */
38     function ParyToken(
39     string tokenName,
40     uint8 decimalUnits,
41     string tokenSymbol
42     ) {
43 
44         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens (0 in this case)
45         totalSupply = initialSupply * 1000000000000000000;  // Update total supply (0 in this case)
46         name = tokenName;                                   // Set the name for display purposes
47         symbol = tokenSymbol;                               // Set the symbol for display purposes
48         decimals = decimalUnits;                            // Amount of decimals for display purposes
49     }
50 
51   
52     modifier notPendingWithdrawal {
53         if (withdrawalRequests[msg.sender].sinceTime > 0) throw;
54         _;
55     }
56 
57 
58     function transfer(address _to, uint256 _value) notPendingWithdrawal {
59         if (balanceOf[msg.sender] < _value) throw;           
60         if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
61         if (withdrawalRequests[_to].sinceTime > 0) throw;   
62         balanceOf[msg.sender] -= _value;                     
63         balanceOf[_to] += _value;                          
64         Transfer(msg.sender, _to, _value);               
65     }
66 
67  
68     function approve(address _spender, uint256 _value) notPendingWithdrawal
69     returns (bool success) {
70         if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) throw;
71         allowance[msg.sender][_spender] = _value;
72         Approval(msg.sender, _spender, _value);
73         return true;                                      // we must return a bool as part of the ERC20
74     }
75 
76 
77     /**
78      * ERC-20 Approves and then calls the receiving contract
79     */
80     function approveAndCall(address _spender, uint256 _value, bytes _extraData) notPendingWithdrawal
81     returns (bool success) {
82 
83         if (!approve(_spender, _value)) return false;
84 
85         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
86             throw;
87         }
88         return true;
89     }
90 
91   
92     function transferFrom(address _from, address _to, uint256 _value)
93     returns (bool success) {
94         // on the behalf of _from
95         if (withdrawalRequests[_from].sinceTime > 0) throw;   
96         if (withdrawalRequests[_to].sinceTime > 0) throw;     
97         if (balanceOf[_from] < _value) throw;                 
98         if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
99         if (_value > allowance[_from][msg.sender]) throw;     
100         balanceOf[_from] -= _value;                           
101         balanceOf[_to] += _value;                            
102         allowance[_from][msg.sender] -= _value;
103         Transfer(_from, _to, _value);
104         return true;
105     }
106 
107     /**
108      * Fallback function when sending ether to the contract
109      * Gas use: 65051
110     */
111     function () payable notPendingWithdrawal {
112         uint256 amount = msg.value;         // amount that was sent
113         if (amount == 0) throw;             // need to send some ETH
114         balanceOf[msg.sender] += amount;    // mint new tokens
115         totalSupply += amount;              // track the supply
116         Transfer(0, msg.sender, amount);    // notify of the event
117         Deposited(msg.sender, amount);
118     }
119 }