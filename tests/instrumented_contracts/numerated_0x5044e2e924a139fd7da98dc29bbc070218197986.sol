1 /* This is a single page( no imports ) version of ConsenSys ERC20 token example available at https://github.com/ConsenSys/Tokens/ */
2 
3 pragma solidity ^0.4.8;
4 
5 contract TokenTemplate {
6 
7     function () {
8         //if ether is sent to this address, send it back.
9         throw;
10     }
11 
12     /* Public variables of the token */
13 
14     /*
15     NOTE:
16     The following variables are OPTIONAL vanities. One does not have to include them.
17     They allow one to customise the token contract & in no way influences the core functionality.
18     Some wallets/interfaces might not even bother to look at this information.
19     */
20     uint256 public totalSupply;
21     string public name;                   //fancy name: eg Simon Bucks
22     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
23     string public symbol;                 //An identifier: eg SBX
24     string public version = '0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
25 
26     function TokenTemplate(
27         uint256 _initialAmount,
28         string _tokenName,
29         uint8 _decimalUnits,
30         string _tokenSymbol,
31         address _masterAddress
32         ) {
33         balances[_masterAddress] = _initialAmount;           // Give the creator all initial tokens
34         totalSupply = _initialAmount;                        // Update total supply
35         name = _tokenName;                                   // Set the name for display purposes
36         decimals = _decimalUnits;                            // Amount of decimals for display purposes
37         symbol = _tokenSymbol;                               // Set the symbol for display purposes
38     }
39 
40     /* Approves and then calls the receiving contract */
41     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
42         allowed[msg.sender][_spender] = _value;
43         Approval(msg.sender, _spender, _value);
44 
45         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
46         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
47         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
48         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
49         return true;
50     }
51 
52     function transfer(address _to, uint256 _value) returns (bool success) {
53         //Default assumes totalSupply can't be over max (2^256 - 1).
54         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
55         //Replace the if with this one instead.
56         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
57         if (balances[msg.sender] >= _value && _value > 0) {
58             balances[msg.sender] -= _value;
59             balances[_to] += _value;
60             Transfer(msg.sender, _to, _value);
61             return true;
62         } else { return false; }
63     }
64 
65     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
66         //same as above. Replace this line with the following if you want to protect against wrapping uints.
67         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
68         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
69             balances[_to] += _value;
70             balances[_from] -= _value;
71             allowed[_from][msg.sender] -= _value;
72             Transfer(_from, _to, _value);
73             return true;
74         } else { return false; }
75     }
76 
77     function balanceOf(address _owner) constant returns (uint256 balance) {
78         return balances[_owner];
79     }
80 
81     function approve(address _spender, uint256 _value) returns (bool success) {
82         allowed[msg.sender][_spender] = _value;
83         Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
88       return allowed[_owner][_spender];
89     }
90 
91     event Transfer(address indexed _from, address indexed _to, uint256 _value);
92     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93 
94     mapping (address => uint256) balances;
95     mapping (address => mapping (address => uint256)) allowed;
96 
97 }