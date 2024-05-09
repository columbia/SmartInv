1 pragma solidity 0.4.19;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint _value) returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint _value);
37     event Approval(address indexed _owner, address indexed _spender, uint _value);
38     event Burn(address indexed _from, uint _value);
39 }
40 
41 contract RegularToken is Token {
42 
43     function transfer(address _to, uint _value) returns (bool) {
44         //Default assumes totalSupply can't be over max (2^256 - 1).
45         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
46             balances[msg.sender] -= _value;
47             balances[_to] += _value;
48             Transfer(msg.sender, _to, _value);
49             return true;
50         } else { return false; }
51     }
52 
53     function transferFrom(address _from, address _to, uint _value) returns (bool) {
54         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
55             balances[_to] += _value;
56             balances[_from] -= _value;
57             allowed[_from][msg.sender] -= _value;
58             Transfer(_from, _to, _value);
59             return true;
60         } else { return false; }
61     }
62 
63     function balanceOf(address _owner) constant returns (uint) {
64         return balances[_owner];
65     }
66 
67     function approve(address _spender, uint _value) returns (bool) {
68         allowed[msg.sender][_spender] = _value;
69         Approval(msg.sender, _spender, _value);
70         return true;
71     }
72 
73     function allowance(address _owner, address _spender) constant returns (uint) {
74         return allowed[_owner][_spender];
75     }
76 
77     mapping (address => uint) balances;
78     mapping (address => mapping (address => uint)) allowed;
79     uint public totalSupply;
80 }
81 
82 contract BGGToken is RegularToken {
83 
84     uint public totalSupply = 10**28;
85     uint8 constant public decimals = 18;
86     string constant public name = "BGGToken";
87     string constant public symbol = "BGG";
88 
89     function BGGToken() {
90         balances[msg.sender] = totalSupply;
91         Transfer(address(0), msg.sender, totalSupply);
92     }
93 }