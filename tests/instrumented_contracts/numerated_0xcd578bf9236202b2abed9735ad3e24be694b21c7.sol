1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity >=0.4.0 <0.6.0;
4 
5 contract Token {
6   /* This is a slight change to the ERC20 base standard.
7      function totalSupply() constant returns (uint256 supply);
8      is replaced with:
9      uint256 public totalSupply;
10      This automatically creates a getter function for the totalSupply.
11      This is moved to the base contract since public getter functions are not
12      currently recognised as an implementation of the matching abstract
13      function by the compiler.
14   */
15   /// total amount of tokens
16   uint256 public totalSupply;
17 
18   /// @param _owner The address from which the balance will be retrieved
19   /// @return The balance
20   function balanceOf(address _owner) public view returns (uint256 balance);
21 
22   /// @notice send `_value` token to `_to` from `msg.sender`
23   /// @param _to The address of the recipient
24   /// @param _value The amount of token to be transferred
25   /// @return Whether the transfer was successful or not
26   function transfer(address _to, uint256 _value) public returns (bool success);
27 
28   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29   /// @param _from The address of the sender
30   /// @param _to The address of the recipient
31   /// @param _value The amount of token to be transferred
32   /// @return Whether the transfer was successful or not
33   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
34 
35   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36   /// @param _spender The address of the account able to transfer the tokens
37   /// @param _value The amount of tokens to be approved for transfer
38   /// @return Whether the approval was successful or not
39   function approve(address _spender, uint256 _value) public returns (bool success);
40 
41   /// @param _owner The address of the account owning tokens
42   /// @param _spender The address of the account able to transfer the tokens
43   /// @return Amount of remaining tokens allowed to spent
44   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
45 
46   event Transfer(address indexed _from, address indexed _to, uint256 _value);
47   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 contract StandardToken is Token {
51 
52   function transfer(address _to, uint256 _value) public returns (bool success) {
53     //Default assumes totalSupply can't be over max (2^256 - 1).
54     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
55     //Replace the if with this one instead.
56     //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
57     if (balances[msg.sender] >= _value && _value > 0) {
58       balances[msg.sender] -= _value;
59       balances[_to] += _value;
60       emit Transfer(msg.sender, _to, _value);
61       return true;
62     } else { return false; }
63   }
64 
65   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
66     //same as above. Replace this line with the following if you want to protect against wrapping uints.
67     //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
68     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
69       balances[_to] += _value;
70       balances[_from] -= _value;
71       allowed[_from][msg.sender] -= _value;
72       emit Transfer(_from, _to, _value);
73       return true;
74     } else { return false; }
75   }
76 
77   function balanceOf(address _owner) public view returns (uint256 balance) {
78     return balances[_owner];
79   }
80 
81   function approve(address _spender, uint256 _value) public returns (bool success) {
82     allowed[msg.sender][_spender] = _value;
83     emit Approval(msg.sender, _spender, _value);
84     return true;
85   }
86 
87   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
88     return allowed[_owner][_spender];
89   }
90 
91   mapping (address => uint256) balances;
92   mapping (address => mapping (address => uint256)) allowed;
93 }
94 contract OmegaCoinToken is StandardToken {
95 
96   uint8 public constant decimals = 18;
97   address public owner;
98   
99   modifier isOwner() {
100     require(msg.sender == owner);
101     _;
102   }
103 
104   function setMinter(address _minterAddress, uint256 _value) public isOwner {
105     require(_minterAddress != address(0));
106     minters[_minterAddress] = _value;
107   }
108   
109   function minterLeft(address _minterAddress) view public returns (uint256 rest) {
110       return minters[_minterAddress];
111   }
112   
113   function dematerialize(uint256 _value) public {
114       if (minters[msg.sender] >= _value && _value > 0) {
115           balances[msg.sender] += _value;
116           minters[msg.sender] -= _value;
117           totalSupply += _value;
118           emit Transfer(address(0), msg.sender, _value);
119       }
120   }
121   
122   function materialize(uint256 _value) public {
123     if (minters[msg.sender] >= _value && balances[msg.sender] >= _value && _value > 0) {
124       balances[msg.sender] -= _value;
125       totalSupply -= _value;
126       emit Transfer(msg.sender, address(0), _value);
127     }
128   }
129 
130   mapping (address => uint256) minters;
131 }
132 contract OmegaUSD is OmegaCoinToken {
133 
134   string public constant name = "Omega USD";
135   string public constant symbol = "oUSD";
136   uint8 public constant decimals = 18;
137 
138   constructor() public {
139       owner = msg.sender;
140       totalSupply = 0;
141   }
142 
143 }