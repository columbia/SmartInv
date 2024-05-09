1 pragma solidity ^0.4.18;
2 
3 contract EIP20Interface {
4     /// @param _owner The address from which the balance will be retrieved
5     /// @return The balance
6     function balanceOf(address _owner) public view returns (uint256 balance);
7 
8     /// @notice send `_value` token to `_to` from `msg.sender`
9     /// @param _to The address of the recipient
10     /// @param _value The amount of token to be transferred
11     /// @return Whether the transfer was successful or not
12     function transfer(address _to, uint256 _value) public returns (bool success);
13 
14     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
15     /// @param _from The address of the sender
16     /// @param _to The address of the recipient
17     /// @param _value The amount of token to be transferred
18     /// @return Whether the transfer was successful or not
19     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
20 
21     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
22     /// @param _spender The address of the account able to transfer the tokens
23     /// @param _value The amount of tokens to be approved for transfer
24     /// @return Whether the approval was successful or not
25     function approve(address _spender, uint256 _value) public returns (bool success);
26 
27     /// @param _owner The address of the account owning tokens
28     /// @param _spender The address of the account able to transfer the tokens
29     /// @return Amount of remaining tokens allowed to spent
30     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
31 
32     // solhint-disable-next-line no-simple-event-func-name
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 }
36 
37 
38 contract Bitsta is EIP20Interface {
39 
40     uint256 constant private MAX_UINT256 = 2**256 - 1;
41     mapping (address => uint256) public balances;
42     mapping (address => mapping (address => uint256)) public allowed;
43     /*
44     NOTE:
45     The following variables are OPTIONAL vanities. One does not have to include them.
46     They allow one to customise the token contract & in no way influences the core functionality.
47     Some wallets/interfaces might not even bother to look at this information.
48     */
49     string constant public name = "Bitsta Token";
50     uint256 constant public decimals = 18;
51     string constant public symbol = "BXE";
52     uint256 public totalSupply;
53 
54     function Bitsta( ) public {
55         totalSupply = 425000000 * 10**decimals;
56         balances[msg.sender] = totalSupply;
57     }
58 
59     function transfer(address _to, uint256 _value) public returns (bool success) {
60         require(balances[msg.sender] >= _value);
61         balances[msg.sender] -= _value;
62         balances[_to] += _value;
63         emit Transfer(msg.sender, _to, _value);
64         return true;
65     }
66 
67     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
68         uint256 allowance = allowed[_from][msg.sender];
69         require(balances[_from] >= _value && allowance >= _value);
70         balances[_to] += _value;
71         balances[_from] -= _value;
72         if (allowance < MAX_UINT256) {
73             allowed[_from][msg.sender] -= _value;
74         }
75         emit Transfer(_from, _to, _value);
76         return true;
77     }
78 
79     function balanceOf(address _owner) public view returns (uint256 balance) {
80         return balances[_owner];
81     }
82 
83     function approve(address _spender, uint256 _value) public returns (bool success) {
84         allowed[msg.sender][_spender] = _value;
85         emit Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
90         return allowed[_owner][_spender];
91     }
92 }