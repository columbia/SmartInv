1 pragma solidity 0.4.21;
2 
3 /**
4 * @title SafeMath by OpenZeppelin (commit: 5daaf60)
5 * @dev Math operations with safety checks that throw on error
6 */
7 library SafeMath {
8     /**
9     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
10     */
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         assert(b <= a);
13         return a - b;
14     }
15 
16     /**
17     * @dev Adds two numbers, throws on overflow.
18     */
19     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 }
25 
26 contract TokenERC20 {
27     string public name;
28     string public symbol;
29     uint256 public totalSupply;
30     uint8 public decimals = 18;
31 
32     mapping (address => uint256) balances;
33     mapping (address => mapping (address => uint256)) allowed;
34 
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37     event Burn(address indexed _from, uint256 _value);
38 
39     /**
40      * Constructor function
41      *
42      * Initializes contract with initial supply tokens assigned to the creator of the contract
43      */
44     function TokenERC20(
45         uint256 initialSupply,
46         string tokenName,
47         string tokenSymbol
48     ) 
49     public 
50     {
51         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
52         balances[msg.sender] = totalSupply;                     // Give the creator all initial tokens
53         name = tokenName;                                       // Set the name for display purposes
54         symbol = tokenSymbol;                                   // Set the symbol for display purposes
55     }
56 
57     /**
58      * Transfer tokens
59      * Send `_value` tokens to `_to` from your account
60      * @param _to The address of the recipient
61      * @param _value the amount to send
62      */
63     function transfer(address _to, uint256 _value) public returns (bool success) {
64         require(_to != address(0));
65         require(balances[msg.sender] >= _value);
66         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
67         balances[_to] = SafeMath.add(balances[_to], _value);
68         emit Transfer(msg.sender, _to, _value);
69         return true;
70     }
71 
72     /**
73      * Transfer tokens from other address
74      * Send `_value` tokens to `_to` on behalf of `_from`
75      * @param _from The address of the sender
76      * @param _to The address of the recipient
77      * @param _value the amount to send
78      */
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
80         require(_to != address(0));
81         require(_value <= balances[_from]);
82         require(_value <= allowed[_from][msg.sender]);        
83         balances[_to] = SafeMath.add(balances[_to], _value);
84         balances[_from] = SafeMath.sub(balances[_from], _value);
85         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
86         emit Transfer(_from, _to, _value);
87         return true;
88     }
89 
90     /**
91      * Set allowance for other address
92      * Allows `_spender` to spend no more than `_value` tokens on your behalf
93      * @param _spender The address authorized to spend
94      * @param _value the max amount they can spend
95      */
96     function approve(address _spender, uint256 _value) public returns (bool success) {
97         // To prevent attack vectors problem discussed in the following comment
98         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
99         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
100         
101         allowed[msg.sender][_spender] = _value;
102         emit Approval(msg.sender, _spender, _value);
103         return true;
104     }
105 
106     /**
107      * Destroy tokens
108      * Remove `_value` tokens from the system irreversibly
109      * @param _value the amount of money to burn
110      */
111     function burn(uint256 _value) public returns (bool success) {
112         require(balances[msg.sender] >= _value);   // Check if the sender has enough
113         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value); // Subtract from the sender
114         totalSupply = SafeMath.sub(totalSupply, _value);                     // Updates totalSupply
115         emit Burn(msg.sender, _value);
116         return true;
117     }
118 
119     // ------- View functions -------
120 
121     /**
122     * @dev Gets the balance of the specified address.
123     * @param _owner The address to query the the balance of.
124     * @return An uint256 representing the amount owned by the passed address.
125     */
126     function balanceOf(address _owner) public view returns (uint256 balance) {
127         return balances[_owner];
128     }   
129 
130     /**
131     * @dev Function to check the amount of tokens that an owner allowed to a spender.
132     * @param _owner address The address which owns the funds.
133     * @param _spender address The address which will spend the funds.
134     * @return A uint256 specifying the amount of tokens still available for the spender.
135     */
136     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
137         return allowed[_owner][_spender];
138     }
139 }