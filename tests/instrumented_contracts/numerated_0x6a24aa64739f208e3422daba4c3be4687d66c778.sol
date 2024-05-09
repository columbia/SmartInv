1 pragma solidity ^0.4.24;
2 
3 ////////////////////
4 // STANDARD TOKEN //
5 ////////////////////
6 
7 contract Token {
8 
9     uint256 public totalSupply;
10 
11     /// @param _owner The address from which the balance will be retrieved
12     function balanceOf(address _owner) constant public returns (uint256 balance);
13 
14     /// @notice send `_value` token to `_to` from `msg.sender`
15     /// @param _to The address of the recipient
16     /// @param _value The amount of token to be transferred
17     /// @return Whether the transfer was successful or not
18     function transfer(address _to, uint256 _value) public returns (bool success);
19 
20     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
21     /// @param _from The address of the sender
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
26 
27     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
28     /// @param _spender The address of the account able to transfer the tokens
29     /// @param _value The amount of wei to be approved for transfer
30     /// @return Whether the approval was successful or not
31     function approve(address _spender, uint256 _value) public returns (bool success);
32 
33     /// @param _owner The address of the account owning tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @return Amount of remaining tokens allowed to spent
36     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
37 
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 }
41 
42 
43 /*  ERC 20 token */
44 contract StandardToken is Token {
45 
46     function transfer(address _to, uint256 _value) public returns (bool success) {
47         if (balances[msg.sender] >= _value && _value > 0) {
48             balances[msg.sender] -= _value;
49             balances[_to] += _value;
50             emit Transfer(msg.sender, _to, _value);
51             return true;
52         } else { return false; }
53     }
54 
55     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
56         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
57             balances[_to] += _value;
58             balances[_from] -= _value;
59             allowed[_from][msg.sender] -= _value;
60             emit Transfer(_from, _to, _value);
61             return true;
62         } else { return false; }
63     }
64 
65     function balanceOf(address _owner) constant public returns (uint256 balance) {
66         return balances[_owner];
67     }
68 
69     function approve(address _spender, uint256 _value) public returns (bool success) {
70         allowed[msg.sender][_spender] = _value;
71         emit Approval(msg.sender, _spender, _value);
72         return true;
73     }
74 
75     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
76       return allowed[_owner][_spender];
77     }
78 
79     mapping (address => uint256) balances;
80     mapping (address => mapping (address => uint256)) allowed;
81 }
82 
83 
84 /////////////////////
85 // BPPToken START //
86 ////////////////////
87 
88 contract BPPToken is StandardToken {
89 
90     function () public {
91         //if ether is sent to this address, send it back.
92        revert();
93     }
94 
95     /* Public variables of the token */
96     string public name;
97     uint8 public decimals; 
98     string public symbol;
99     string public version = '1.0';
100     
101     constructor() public {
102         name = 'Bpp';
103         decimals = 18;
104         symbol = 'BPP';
105         totalSupply = 21000000000 * 10 ** uint256(decimals);
106         balances[msg.sender] = totalSupply;
107     }
108 
109     /* Approves and then calls the receiving contract */
110     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
111         allowed[msg.sender][_spender] = _value;
112         emit Approval(msg.sender, _spender, _value);
113 
114         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
115         return true;
116     }
117 }