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
49 contract StandardToken is Token {
50 
51   function transfer(address _to, uint256 _value) public returns (bool success) {
52     //Default assumes totalSupply can't be over max (2^256 - 1).
53     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
54     //Replace the if with this one instead.
55     //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
56     if (balances[msg.sender] >= _value && _value > 0) {
57       balances[msg.sender] -= _value;
58       balances[_to] += _value;
59       emit Transfer(msg.sender, _to, _value);
60       return true;
61     } else { return false; }
62   }
63 
64   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
65     //same as above. Replace this line with the following if you want to protect against wrapping uints.
66     //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
67     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
68       balances[_to] += _value;
69       balances[_from] -= _value;
70       allowed[_from][msg.sender] -= _value;
71       emit Transfer(_from, _to, _value);
72       return true;
73     } else { return false; }
74   }
75 
76   function balanceOf(address _owner) public view returns (uint256 balance) {
77     return balances[_owner];
78   }
79 
80   function approve(address _spender, uint256 _value) public returns (bool success) {
81     allowed[msg.sender][_spender] = _value;
82     emit Approval(msg.sender, _spender, _value);
83     return true;
84   }
85 
86   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
87     return allowed[_owner][_spender];
88   }
89 
90   mapping (address => uint256) balances;
91   mapping (address => mapping (address => uint256)) allowed;
92 }
93 contract KangaToken is StandardToken {
94 
95   string public constant name = "Kanga Exchange Token";
96   string public constant symbol = "KNG";
97   uint8 public constant decimals = 18;
98   address public owner;
99   
100   modifier isOwner() {
101     require(msg.sender == owner);
102     _;
103   }
104   
105   constructor() public {
106       owner = msg.sender;
107       totalSupply = 21000000* 10**18;
108       balances[owner] = totalSupply;
109   }
110 
111 }