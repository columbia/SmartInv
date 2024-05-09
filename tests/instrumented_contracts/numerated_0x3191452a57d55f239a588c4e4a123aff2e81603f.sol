1 pragma solidity ^0.4.16;
2 contract Token {
3     /// @return total amount of tokens
4     function totalSupply() constant returns (uint256 supply) {}
5 
6     /// @param _owner The address from which the balance will be retrieved
7     /// @return The balance
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10     /// @notice send `_value` token to `_to` from `msg.sender`
11     /// @param _to The address of the recipient
12     /// @param _value The amount of token to be transferred
13     /// @return Whether the transfer was successful or not
14     function transfer(address _to, uint256 _value) returns (bool success) {}
15 
16     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
17     /// @param _from The address of the sender
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
22 
23     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
24     /// @param _spender The address of the account able to transfer the tokens
25     /// @param _value The amount of wei to be approved for transfer
26     /// @return Whether the approval was successful or not
27     function approve(address _spender, uint256 _value) returns (bool success) {}
28 
29     /// @param _owner The address of the account owning tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @return Amount of remaining tokens allowed to spent
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
33 	
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36     
37 }
38 
39 
40 contract StandardToken is Token {
41     function transfer(address _to, uint256 _value) returns (bool success) {
42         if (balances[msg.sender] >= _value && _value > 0) {
43             balances[msg.sender] -= _value;
44             balances[_to] += _value;
45             Transfer(msg.sender, _to, _value);
46             return true;
47         } else { return false; }
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
51         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
52             balances[_to] += _value;
53             balances[_from] -= _value;
54             allowed[_from][msg.sender] -= _value;
55             Transfer(_from, _to, _value);
56             return true;
57         } else { return false; }
58     }
59 
60     function balanceOf(address _owner) constant returns (uint256 balance) {
61         return balances[_owner];
62     }
63 
64     function approve(address _spender, uint256 _value) returns (bool success) {
65         allowed[msg.sender][_spender] = _value;
66         Approval(msg.sender, _spender, _value);
67         return true;
68     }
69 
70     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
71       return allowed[_owner][_spender];
72     }
73 
74     mapping (address => uint256) balances;
75     mapping (address => mapping (address => uint256)) allowed;
76     uint256 public totalSupply;
77 }
78 
79 
80 contract EthereumDeluxe is StandardToken {
81 
82     function () {
83         //if ether is sent to this address, send it back.
84         throw;
85     }
86 
87     /* Public variables of the token */
88     string public name;                   
89     uint8 public decimals;                
90     string public symbol;                 
91     string public version = 'H1.0';       
92 
93     function EthereumDeluxe() {
94 		totalSupply = 7000000000000000000000000;    					
95         balances[msg.sender] = totalSupply;               										
96         name = "Ethereum Deluxe";                                   
97         decimals = 18;                            
98         symbol = "ETHDX";                               
99     }
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