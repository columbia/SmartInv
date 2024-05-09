1 pragma solidity ^0.4.18;
2 
3 contract Token {
4 
5     /// @param _owner The address from which the balance will be retrieved
6     /// @return The balance
7     function balanceOf(address _owner) public view returns (uint256 balance);
8 
9     /// @notice send `_value` token to `_to` from `msg.sender`
10     /// @param _to The address of the recipient
11     /// @param _value The amount of token to be transferred
12     /// @return Whether the transfer was successful or not
13     function transfer(address _to, uint256 _value) public returns (bool success);
14 
15     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
16     /// @param _from The address of the sender
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
21 
22     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
23     /// @param _spender The address of the account able to transfer the tokens
24     /// @param _value The amount of wei to be approved for transfer
25     /// @return Whether the approval was successful or not
26     function approve(address _spender, uint256 _value) public returns (bool success);
27 
28     /// @param _owner The address of the account owning tokens
29     /// @param _spender The address of the account able to transfer the tokens
30     /// @return Amount of remaining tokens allowed to spent
31     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
32 
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35     
36 }
37 
38 
39 contract StandardToken is Token {
40 
41     function transfer(address _to, uint256 _value) public returns (bool success) {
42         if (balances[msg.sender] >= _value && _value > 0) {
43             balances[msg.sender] -= _value;
44             balances[_to] += _value;
45             Transfer(msg.sender, _to, _value);
46             return true;
47         } else {return false;}
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
51         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
52             balances[_to] += _value;
53             balances[_from] -= _value;
54             allowed[_from][msg.sender] -= _value;
55             Transfer(_from, _to, _value);
56             return true;
57         } else {return false;}
58     }
59 
60     function balanceOf(address _owner) public view returns (uint256 balance) {
61         return balances[_owner];
62     }
63 
64     function approve(address _spender, uint256 _value) public returns (bool success) {
65         allowed[msg.sender][_spender] = _value;
66         Approval(msg.sender, _spender, _value);
67         return true;
68     }
69 
70     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
71       return allowed[_owner][_spender];
72     }
73 
74     mapping (address => uint256) balances;
75     mapping (address => mapping (address => uint256)) allowed;
76     uint256 public totalSupply;
77 }
78 
79 
80 contract Rivercoin is StandardToken {
81 
82     function () public {
83         //if ether is sent to this address, send it back.
84         revert();
85     }
86 
87     /* Public variables of the token */
88 
89     string public name;
90     uint8 public decimals;
91     string public symbol;
92     string public version = "1.0";
93 
94     function Rivercoin() public {
95         name = "Rivercoin";
96         decimals = 8;
97         symbol = "RVC";
98         balances[msg.sender] = 200000000 * (10 ** uint256(decimals));
99         totalSupply = 200000000 * (10 ** uint256(decimals));
100     }
101     
102 }