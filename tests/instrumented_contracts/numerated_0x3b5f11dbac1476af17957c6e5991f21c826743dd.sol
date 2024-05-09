1 pragma solidity ^0.4.8;
2 
3 contract Token {
4 
5     // @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     // @param _owner The address from which the balance will be retrieved
9     // @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     // @notice send `_value` token to `_to` from `msg.sender`
13     // @param _to The address of the recipient
14     // @param _value The amount of token to be transferred
15     // @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     // @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     // @param _from The address of the sender
20     // @param _to The address of the recipient
21     // @param _value The amount of token to be transferred
22     // @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     // @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     // @param _spender The address of the account able to transfer the tokens
27     // @param _value The amount of wei to be approved for transfer
28     // @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     // @param _owner The address of the account owning tokens
32     // @param _spender The address of the account able to transfer the tokens
33     // @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 }
39 
40 
41 
42 contract StandardToken is Token {
43 
44     function transfer(address _to, uint256 _value) returns (bool success) {
45         //Default assumes totalSupply can't be over max (2^256 - 1).
46         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
47         //Replace the if with this one instead.
48         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
49         if (balances[msg.sender] >= _value && _value > 0) {
50             balances[msg.sender] -= _value;
51             balances[_to] += _value;
52             Transfer(msg.sender, _to, _value);
53             return true;
54         } else { return false; }
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
58         //same as above. Replace this line with the following if you want to protect against wrapping uints.
59         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
60         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
61             balances[_to] += _value;
62             balances[_from] -= _value;
63             allowed[_from][msg.sender] -= _value;
64             Transfer(_from, _to, _value);
65             return true;
66         } else { return false; }
67     }
68 
69     function balanceOf(address _owner) constant returns (uint256 balance) {
70         return balances[_owner];
71     }
72 
73     function approve(address _spender, uint256 _value) returns (bool success) {
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
80       return allowed[_owner][_spender];
81     }
82 
83     mapping (address => uint256) balances;
84     mapping (address => mapping (address => uint256)) allowed;
85     uint256 public totalSupply;
86 }
87 
88 
89 contract BaconCoin is StandardToken {
90 
91 	string public name = "BaconCoin";
92 	string public symbol = "BAK";
93 	uint public decimals = 8;
94 	uint public INITIAL_SUPPLY = 2200000000 * (10 ** decimals);
95 
96 	function BaconCoin() public {
97 		totalSupply = INITIAL_SUPPLY;
98 		balances[msg.sender] = INITIAL_SUPPLY;
99 	}
100 
101     /* Approves and then calls the receiving contract */
102     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
103         allowed[msg.sender][_spender] = _value;
104         Approval(msg.sender, _spender, _value);
105 
106         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
107         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
108         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
109         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
110         return true;
111     }
112 }