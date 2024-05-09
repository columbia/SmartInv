1 pragma solidity ^0.4.4;
2 
3 /**
4  * SafeMath
5  * Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         assert(a == b * c);
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a - b;
26         assert(b <= a);
27         assert(a == c + b);
28         return c;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         assert(a == c - b);
35         return c;
36     }
37 }
38 
39 contract Token {
40 
41     /// @return total amount of tokens
42     function totalSupply() constant returns (uint256 supply) {}
43 
44     /// @param _owner The address from which the balance will be retrieved
45     /// @return The balance
46     function balanceOf(address _owner) constant returns (uint256 balance) {}
47 
48     /// @notice send `_value` token to `_to` from `msg.sender`
49     /// @param _to The address of the recipient
50     /// @param _value The amount of token to be transferred
51     /// @return Whether the transfer was successful or not
52     function transfer(address _to, uint256 _value) returns (bool success) {}
53 
54     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
55     /// @param _from The address of the sender
56     /// @param _to The address of the recipient
57     /// @param _value The amount of token to be transferred
58     /// @return Whether the transfer was successful or not
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
60 
61     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
62     /// @param _spender The address of the account able to transfer the tokens
63     /// @param _value The amount of wei to be approved for transfer
64     /// @return Whether the approval was successful or not
65     function approve(address _spender, uint256 _value) returns (bool success) {}
66 
67     /// @param _owner The address of the account owning tokens
68     /// @param _spender The address of the account able to transfer the tokens
69     /// @return Amount of remaining tokens allowed to spent
70     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
71 
72     event Transfer(address indexed _from, address indexed _to, uint256 _value);
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74 
75 }
76 
77 contract StandardToken is Token {
78 
79     using SafeMath for uint256;
80 
81     event NewTx(address indexed from, address indexed to, uint256 value);
82 
83     function transfer(address _to, uint256 _value) returns (bool success) {
84         if (balances[msg.sender] >= _value && _value > 0) {
85             balances[msg.sender] -= _value;
86             balances[_to] += _value;
87             NewTx(msg.sender, _to, _value);
88             Transfer(msg.sender, _to, _value);
89             return true;
90         } else { return false; }
91     }
92 
93     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
94         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
95             balances[_to] += _value;
96             balances[_from] -= _value;
97             allowed[_from][msg.sender] -= _value;
98             Transfer(_from, _to, _value);
99             return true;
100         } else { return false; }
101     }
102 
103     function balanceOf(address _owner) constant returns (uint256 balance) {
104         return balances[_owner];
105     }
106 
107     function approve(address _spender, uint256 _value) returns (bool success) {
108         allowed[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110         return true;
111     }
112 
113     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
114         return allowed[_owner][_spender];
115     }
116 
117     mapping (address => uint256) balances;
118     mapping (address => mapping (address => uint256)) allowed;
119     uint256 public totalSupply;
120 }
121 
122 
123 contract MNPYToken is StandardToken {
124 
125     function () {
126         //if ether is sent to this address, send it back.
127         throw;
128     }
129 
130     /* Public variables of the MNPY token */
131 
132     string public name;
133     uint8 public decimals;
134     string public symbol;
135     string public version = 'H1.0';
136 
137     function MNPYToken(
138     ) {
139         balances[msg.sender] = 25000000000000000000000000; // 25 million with 18 decimals
140         totalSupply = 25000000000000000000000000; // 25 million with 18 decimals
141         name = "MNPY";
142         decimals = 18;
143         symbol = "MNPY";
144     }
145 
146     /* Approves and then calls the receiving contract */
147     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
148         allowed[msg.sender][_spender] = _value;
149         Approval(msg.sender, _spender, _value);
150 
151         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
152         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
153         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
154         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
155         return true;
156     }
157 }