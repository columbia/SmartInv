1 pragma solidity ^0.4.0;
2 
3 /**
4  * ERC-20 Token Interface
5  *
6  * https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9 
10   /// @return total amount of tokens
11   function totalSupply() constant returns (uint256 supply) {}
12 
13   /// @param _owner The address from which the balance will be retrieved
14   /// @return The balance
15   function balanceOf(address _owner) constant returns (uint256 balance) {}
16 
17   /// @notice send `_value` token to `_to` from `msg.sender`
18   /// @param _to The address of the recipient
19   /// @param _value The amount of token to be transferred
20   /// @return Whether the transfer was successful or not
21   function transfer(address _to, uint256 _value) returns (bool success) {}
22 
23   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
24   /// @param _from The address of the sender
25   /// @param _to The address of the recipient
26   /// @param _value The amount of token to be transferred
27   /// @return Whether the transfer was successful or not
28   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
29 
30   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
31   /// @param _spender The address of the account able to transfer the tokens
32   /// @param _value The amount of wei to be approved for transfer
33   /// @return Whether the approval was successful or not
34   function approve(address _spender, uint256 _value) returns (bool success) {}
35 
36   /// @param _owner The address of the account owning tokens
37   /// @param _spender The address of the account able to transfer the tokens
38   /// @return Amount of remaining tokens allowed to spent
39   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
40 
41   event Transfer(address indexed _from, address indexed _to, uint256 _value);
42   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 
44 }
45 
46 /**
47  * Standard ERC-20 token
48  */
49  contract StandardToken is ERC20 {
50 
51   uint256 public totalSupply;
52   mapping(address => uint256) balances;
53   mapping (address => mapping (address => uint256)) allowed;
54 
55 
56   function balanceOf(address _owner) constant returns (uint256 balance) {
57     return balances[_owner];
58   }
59 
60   function transfer(address _to, uint256 _value) returns (bool success) {
61     if (balances[msg.sender] >= _value && _value > 0) {
62       balances[msg.sender] -= _value;
63       balances[_to] += _value;
64       Transfer(msg.sender, _to, _value);
65       return true;
66     } else {
67       return false;
68     }
69   }
70 
71   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
72     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
73       balances[_to] += _value;
74       balances[_from] -= _value;
75       allowed[_from][msg.sender] -= _value;
76       Transfer(_from, _to, _value);
77       return true;
78     } else {
79       return false;
80     }
81   }
82 
83   function approve(address _spender, uint256 _value) returns (bool success) {
84     allowed[msg.sender][_spender] = _value;
85     Approval(msg.sender, _spender, _value);
86     return true;
87   }
88 
89   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
90     return allowed[_owner][_spender];
91   }
92 }
93 
94 
95 contract TST is StandardToken {
96     string public name = 'Test Standard Token';
97     string public symbol = 'TST';
98     uint public decimals = 18;
99 
100     function showMeTheMoney(address _to, uint256 _value) {
101         totalSupply += _value;
102         balances[_to] += _value;
103         Transfer(0, _to, _value);
104     }
105 }