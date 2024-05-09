1 pragma solidity >=0.4.22 <0.7.0;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
4 
5 contract TokenERC20 {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Burn(address indexed from, uint256 value);
15 
16     /**
17      * Initialization construct
18      */
19     constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
20         totalSupply = initialSupply * 10 ** uint256(decimals);  
21         balanceOf[msg.sender] = totalSupply;                
22         name = tokenName;                                   
23         symbol = tokenSymbol;                               
24     }
25 
26     /**
27      * Internal implementation of token transfer
28      */
29     function _transfer(address _from, address _to, uint _value) internal {
30         require(_to != address(0x0));
31         require(balanceOf[_from] >= _value);
32         require(balanceOf[_to] + _value > balanceOf[_to]);
33         uint previousBalances = balanceOf[_from] + balanceOf[_to];
34         // Subtract from the sender
35         balanceOf[_from] -= _value;
36         // Add the same to the recipient
37         balanceOf[_to] += _value;
38         emit Transfer(_from, _to, _value);
39         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
40     }
41 
42     /**
43      *  
44      * @param _to Recipient address
45      * @param _value Transfer amount
46      */
47     function transfer(address _to, uint256 _value) public {
48         _transfer(msg.sender, _to, _value);
49     }
50 
51     /**
52      * Transfer of token transactions between accounts
53      * @param _from Sender address
54      * @param _to Transfer address
55      * @param _value Transfer amount
56      */
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         require(_value <= allowance[_from][msg.sender]);     // Check allowance
59         allowance[_from][msg.sender] -= _value;
60         _transfer(_from, _to, _value);
61         return true;
62     }
63 
64     /**
65      *
66      * @param _spender The address authorized to spend
67      * @param _value the max amount they can spend
68      */
69     function approve(address _spender, uint256 _value) public
70         returns (bool success) {
71         allowance[msg.sender][_spender] = _value;
72         return true;
73     }
74 
75     /**
76      * @param _spender Authorized address (contract)
77      * @param _value The maximum number of tokens that can be spent
78      * @param _extraData Additional data sent to the contract
79      */
80     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
81         public
82         returns (bool success) {
83         tokenRecipient spender = tokenRecipient(_spender);
84         if (approve(_spender, _value)) {
85             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
86             return true;
87         }
88     }
89 
90     /**
91      * Destroy the specified tokens in the creator account
92      */
93     function burn(uint256 _value) public returns (bool success) {
94         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
95         balanceOf[msg.sender] -= _value;            // Subtract from the sender
96         totalSupply -= _value;                      // Updates totalSupply
97         emit Burn(msg.sender, _value);
98         return true;
99     }
100 
101     /**
102      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
103      * @param _from the address of the sender
104      * @param _value the amount of money to burn
105      */
106     function burnFrom(address _from, uint256 _value) public returns (bool success) {
107         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
108         require(_value <= allowance[_from][msg.sender]);    // Check allowance
109         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
110         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
111         totalSupply -= _value;                              // Update totalSupply
112         emit Burn(_from, _value);
113         return true;
114     }
115 }