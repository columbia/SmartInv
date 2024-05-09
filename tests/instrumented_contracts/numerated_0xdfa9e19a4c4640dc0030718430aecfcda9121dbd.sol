1 pragma solidity ^0.4.26;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract BKC {
6   
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10   
11     uint256 public totalSupply;
12 
13   
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16     
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Burn(address indexed from, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 
21     constructor (uint256 initialSupply, string tokenName, string tokenSymbol) public {
22         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
23         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
24         name = tokenName;                                       // Set the name for display purposes
25         symbol = tokenSymbol;                                   // Set the symbol for display purposes
26     }
27 
28     /**
29       * @dev total number of tokens issued
30     */
31     function totalSupply() public view returns (uint256) {
32         return totalSupply;
33     }
34     
35     /**
36       * @dev Gets the balance of the specified address.
37       * @param _owner The address to query the the balance of.
38       * @return An uint256 representing the amount owned by the passed address.
39     */
40     function _balanceOf(address _owner) public view returns (uint256 balance) {
41         return balanceOf[_owner];
42     }
43     
44     function _transfer(address _from, address _to, uint _value) internal {
45         require(_to != 0x0);
46         require(balanceOf[_from] >= _value);
47         require(balanceOf[_to] + _value > balanceOf[_to]);
48         uint previousBalances = balanceOf[_from] + balanceOf[_to];
49         balanceOf[_from] -= _value;
50         balanceOf[_to] += _value;
51         emit Transfer(_from, _to, _value);
52         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
53     }
54     
55     /**
56       * @dev transfer token for a specified address
57       * @param _to The address to transfer to.
58       * @param _value The amount to be transferred.
59     */
60     function transfer(address _to, uint256 _value) public {
61         _transfer(msg.sender, _to, _value);
62     }
63     
64     /**
65        * @dev Transfer tokens from one address to another
66        * @param _from address The address which you want to send tokens from
67        * @param _to address The address which you want to transfer to
68        * @param _value uint256 the amount of tokens to be transferred
69     */
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
71         require(_value <= allowance[_from][msg.sender]);     // Check allowance
72         allowance[_from][msg.sender] -= _value;
73         _transfer(_from, _to, _value);
74         return true;
75     }
76     
77     /**
78        * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
79        * @param _spender The address which will spend the funds.
80        * @param _value The amount of tokens to be spent.
81     */
82     function approve(address _spender, uint256 _value) public
83         returns (bool success) {
84         allowance[msg.sender][_spender] = _value;
85         emit Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
90         public
91         returns (bool success) {
92         tokenRecipient spender = tokenRecipient(_spender);
93         if (approve(_spender, _value)) {
94             spender.receiveApproval(msg.sender, _value, this, _extraData);
95             return true;
96         }
97     }
98     
99     /**
100        * @dev Function to check the amount of tokens that an owner allowed to a spender.
101        * @param _owner address The address which owns the funds.
102        * @param _spender address The address which will spend the funds.
103        * @return A uint256 specifying the amount of tokens still available for the spender.
104     */
105     function _allowance(address _owner, address _spender) public view returns (uint256) {
106         return allowance[_owner][_spender];
107     }
108 
109     function burn(uint256 _value) public returns (bool success) {
110         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
111         balanceOf[msg.sender] -= _value;            // Subtract from the sender
112         totalSupply -= _value;                      // Updates totalSupply
113         emit Burn(msg.sender, _value);
114         return true;
115     }
116 
117 
118     function burnFrom(address _from, uint256 _value) public returns (bool success) {
119         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
120         require(_value <= allowance[_from][msg.sender]);    // Check allowance
121         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
122         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
123         totalSupply -= _value;                              // Update totalSupply
124         emit Burn(_from, _value);
125         return true;
126     }
127 }