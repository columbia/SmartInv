1 1 pragma solidity ^0.4.4;
2 
3 2 contract Token {
4 
5 3     function totalSupply() constant returns (uint256 supply) {}
6 4     function balanceOf(address _owner) constant returns (uint256 balance) {}
7 
8 5     function transfer(address _to, uint256 _value) returns (bool success) {}
9 
10 6     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
11 
12   
13 7     function approve(address _spender, uint256 _value) returns (bool success) {}
14 
15 
16 8     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
17 
18 9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19 10     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 11 }
21 
22 
23 
24 12 contract StandardToken is Token {
25 
26 13     function transfer(address _to, uint256 _value) returns (bool success) {
27    
28 14         if (balances[msg.sender] >= _value && _value > 0) {
29 15             balances[msg.sender] -= _value;
30 16             balances[_to] += _value;
31 17             Transfer(msg.sender, _to, _value);
32 18             return true;
33 19         } else { return false; }
34 20     }
35 
36 21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
37    
38 22         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
39 23             balances[_to] += _value;
40 24             balances[_from] -= _value;
41 25             allowed[_from][msg.sender] -= _value;
42 26             Transfer(_from, _to, _value);
43 27             return true;
44 28         } else { return false; }
45 29     }
46 
47 30     function balanceOf(address _owner) constant returns (uint256 balance) {
48 31         return balances[_owner];
49 32     }
50 
51 33     function approve(address _spender, uint256 _value) returns (bool success) {
52 34         allowed[msg.sender][_spender] = _value;
53 35         Approval(msg.sender, _spender, _value);
54 36         return true;
55 37     }
56 
57 38     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
58 39         return allowed[_owner][_spender];
59 40     }
60 
61 41     mapping (address => uint256) balances;
62 42     mapping (address => mapping (address => uint256)) allowed;
63 43     uint256 public totalSupply;
64 44 }
65 
66 45 contract ERC20Token is StandardToken {
67 
68 46     function () {
69 47         //if ether is sent to this address, send it back.
70 48         throw;
71 49     }
72 
73 50     /* Public variables of the token */
74 51     string public name;                   //Name of the token
75 52     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals
76 53     string public symbol;                 //An identifier: eg AXM
77 54     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
78 
79 
80 
81 55 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
82 
83 56     function ERC20Token(
84 57         ) {
85 58         balances[msg.sender] = 85000000000000;               // Give the creator all initial tokens (100000 for example)
86 59         totalSupply = 85000000000000;                        // Update total supply (100000 for example)
87 60         name = "GAIN CHAIN";                                   // Set the name for display purposes
88 61         decimals = 8;                            // Amount of decimals
89 62         symbol = "GAIN";                               // Set the symbol for display purposes
90 63     }
91 
92 
93 64     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
94 65         allowed[msg.sender][_spender] = _value;
95 66         Approval(msg.sender, _spender, _value);
96 
97 67         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
98 68         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
99 69         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
100 70         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
101 71         return true;
102 72     }