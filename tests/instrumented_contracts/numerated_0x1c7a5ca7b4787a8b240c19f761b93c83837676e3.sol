1 pragma solidity ^0.4.25;
2 
3 // The Chrysanthemum at Old Home
4 // A Chinese ink painting of an impression of old Japanese temple, in Kyoto, painted by Mu-Yi Chen.
5 // A famous Taiwanese artist of Lingnan School, born in 1949.
6 // Created: Year 2010
7 // Size: 32x96 cm
8 // Artist: MuYiChen
9 
10 contract Token {
11 
12     /// @return total amount of tokens
13     function totalSupply() constant returns (uint256 supply) {}
14 
15     /// @param _owner The address from which the balance will be retrieved
16     /// @return The balance
17     function balanceOf(address _owner) constant returns (uint256 balance) {}
18 
19     /// @notice send `_value` token to `_to` from `msg.sender`
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transfer(address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
26     /// @param _from The address of the sender
27     /// @param _to The address of the recipient
28     /// @param _value The amount of token to be transferred
29     /// @return Whether the transfer was successful or not
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
31 
32     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @param _value The amount of wei to be approved for transfer
35     /// @return Whether the approval was successful or not
36     function approve(address _spender, uint256 _value) returns (bool success) {}
37 
38     /// @param _owner The address of the account owning tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @return Amount of remaining tokens allowed to spent
41     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
42 
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45     
46 }
47 
48 contract StandardToken is Token {
49 
50     function transfer(address _to, uint256 _value) returns (bool success) {
51         //Default assumes totalSupply can't be over max (2^256 - 1).
52         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
53         //Replace the if with this one instead.
54         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
55         if (balances[msg.sender] >= _value && _value > 0) {
56             balances[msg.sender] -= _value;
57             balances[_to] += _value;
58             Transfer(msg.sender, _to, _value);
59             return true;
60         } else { return false; }
61     }
62 
63     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
64         //same as above. Replace this line with the following if you want to protect against wrapping uints.
65         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
66         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
67             balances[_to] += _value;
68             balances[_from] -= _value;
69             allowed[_from][msg.sender] -= _value;
70             Transfer(_from, _to, _value);
71             return true;
72         } else { return false; }
73     }
74 
75     function balanceOf(address _owner) constant returns (uint256 balance) {
76         return balances[_owner];
77     }
78 
79     function approve(address _spender, uint256 _value) returns (bool success) {
80         allowed[msg.sender][_spender] = _value;
81         Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86       return allowed[_owner][_spender];
87     }
88 
89     mapping (address => uint256) balances;
90     mapping (address => mapping (address => uint256)) allowed;
91     uint256 public totalSupply;
92 }
93 
94 contract Art_MuYiChen_No2 is StandardToken {
95     function () {
96         //if ether is sent to this address, send it back.
97         throw;
98     }
99 
100     /* Public variables of the token */
101 
102     /*
103     NOTE:
104     The following variables are OPTIONAL vanities. One does not have to include them.
105     They allow one to customise the token contract & in no way influences the core functionality.
106     Some wallets/interfaces might not even bother to look at this information.
107     */
108     string public name;
109     uint8 public decimals;
110     string public symbol;
111 
112     function Art_MuYiChen_No2(
113         ) {
114         name = "Art.MuYiChen.No2";
115         symbol = "MYChen.2";
116         decimals = 8;
117         totalSupply = 4410;
118         balances[msg.sender] = 441000000000;
119     }
120     
121     function getIssuer() public view returns(string) { return "LIN, FANG-PAN"; }
122     function getImage() public view returns(string) { return "https://swarm-gateways.net/bzz:/7c44b84838f56dbfabbeb940e3812973f08623eb0b56b8b8c5722badd5248768/"; }
123     function getArtist() public view returns(string) { return "MuYiChen"; }
124 
125     /* Approves and then calls the receiving contract */
126     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
127         allowed[msg.sender][_spender] = _value;
128         Approval(msg.sender, _spender, _value);
129 
130         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
131         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
132         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
133         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
134         return true;
135     }
136 }