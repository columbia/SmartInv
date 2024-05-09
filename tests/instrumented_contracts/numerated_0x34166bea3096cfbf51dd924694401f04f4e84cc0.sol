1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.18;
4 
5 
6 contract EIP20Interface {
7     
8     /// total amount of tokens
9     uint256 public totalSupply;
10 
11     /// @param _owner The address from which the balance will be retrieved
12     /// @return The balance
13     function balanceOf(address _owner) public view returns (uint256 balance);
14 
15     /// @notice send `_value` token to `_to` from `msg.sender`
16     /// @param _to The address of the recipient
17     /// @param _value The amount of token to be transferred
18     /// @return Whether the transfer was successful or not
19     function transfer(address _to, uint256 _value) public returns (bool success);
20 
21     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
22     /// @param _from The address of the sender
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
27 
28     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
29     /// @param _spender The address of the account able to transfer the tokens
30     /// @param _value The amount of tokens to be approved for transfer
31     /// @return Whether the approval was successful or not
32     function approve(address _spender, uint256 _value) public returns (bool success);
33 
34     /// @param _owner The address of the account owning tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @return Amount of remaining tokens allowed to spent
37     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
38 
39     // solhint-disable-next-line no-simple-event-func-name  
40     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 }
43 
44 /*
45 Implements EIP20 token standard: https://github.com/ethereum/EIPs/issues/20
46 .*/
47 
48 contract LydianCoin is EIP20Interface {
49 
50     uint256 constant private MAX_UINT256 = 2**256 - 1;
51     mapping (address => uint256) public balances;
52     mapping (address => mapping (address => uint256)) public allowed;
53    
54     string public name = "LydianCoin";                 
55     uint8 public decimals = 8;                //Decimals.
56     string public symbol = "LDN";                 
57     uint256 initialAmount = 40000000000000000;
58     
59     function LydianCoin(
60     ) public {
61         balances[0x899B8d6a1D410A6dc15F7066e54231348ec38eeD] = initialAmount;               // Give the creator all initial tokens
62                                      
63     }
64 
65     function transfer(address _to, uint256 _value) public returns (bool success) {
66         require(balances[msg.sender] >= _value);
67         balances[msg.sender] -= _value;
68         balances[_to] += _value;
69         Transfer(msg.sender, _to, _value);
70         return true;
71     }
72 
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
74         uint256 allowance = allowed[_from][msg.sender];
75         require(balances[_from] >= _value && allowance >= _value);
76         balances[_to] += _value;
77         balances[_from] -= _value;
78         if (allowance < MAX_UINT256) {
79             allowed[_from][msg.sender] -= _value;
80         }
81         Transfer(_from, _to, _value);
82         return true;
83     }
84 
85     function balanceOf(address _owner) public view returns (uint256 balance) {
86         return balances[_owner];
87     }
88 
89     function approve(address _spender, uint256 _value) public returns (bool success) {
90         allowed[msg.sender][_spender] = _value;
91         Approval(msg.sender, _spender, _value);
92         return true;
93     }
94 
95     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
96         return allowed[_owner][_spender];
97     }   
98 }