1 pragma solidity 0.4.25;
2 /**
3  * AladdinEX Token v0.1
4  *
5  * This product is protected under license. Any unauthorized copy, modification, or use without
6  * express written consent from the creators is prohibited.
7  *
8  * AladdinEX Foundation © 2019
9  */
10 contract Token {
11 
12     /// @return total amount of tokens
13     function totalSupply() constant returns (uint supply) {}
14 
15     /// @param _owner The address from which the balance will be retrieved
16     /// @return The balance
17     function balanceOf(address _owner) constant returns (uint balance) {}
18 
19     /// @notice send `_value` token to `_to` from `msg.sender`
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transfer(address _to, uint _value) returns (bool success) {}
24 
25     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
26     /// @param _from The address of the sender
27     /// @param _to The address of the recipient
28     /// @param _value The amount of token to be transferred
29     /// @return Whether the transfer was successful or not
30     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
31 
32     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @param _value The amount of wei to be approved for transfer
35     /// @return Whether the approval was successful or not
36     function approve(address _spender, uint _value) returns (bool success) {}
37 
38     /// @param _owner The address of the account owning tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @return Amount of remaining tokens allowed to spent
41     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
42 
43     event Transfer(address indexed _from, address indexed _to, uint _value);
44     event Approval(address indexed _owner, address indexed _spender, uint _value);
45 }
46 
47 contract RegularToken is Token {
48 
49     function transfer(address _to, uint _value) public returns (bool) {
50         //Default assumes totalSupply can't be over max (2^256 - 1).
51         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
52             balances[msg.sender] -= _value;
53             balances[_to] += _value;
54             emit Transfer(msg.sender, _to, _value);
55             return true;
56         } else { return false; }
57     }
58 
59     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
60         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
61             balances[_to] += _value;
62             balances[_from] -= _value;
63             allowed[_from][msg.sender] -= _value;
64             emit Transfer(_from, _to, _value);
65             return true;
66         } else { return false; }
67     }
68 
69     function balanceOf(address _owner) public view returns (uint) {
70         return balances[_owner];
71     }
72 
73     function approve(address _spender, uint _value) public returns (bool) {
74         allowed[msg.sender][_spender] = _value;
75         emit Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     function allowance(address _owner, address _spender) public view returns (uint) {
80         return allowed[_owner][_spender];
81     }
82 
83     mapping (address => uint) balances;
84     mapping (address => mapping (address => uint)) allowed;
85     uint public totalSupply;
86 }
87 
88 contract UnboundedRegularToken is RegularToken {
89 
90     uint constant MAX_UINT = 2**256 - 1;
91 
92     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
93     /// @param _from Address to transfer from.
94     /// @param _to Address to transfer to.
95     /// @param _value Amount to transfer.
96     /// @return Success of transfer.
97     function transferFrom(address _from, address _to, uint _value)
98     public
99     returns (bool)
100     {
101         uint allowance = allowed[_from][msg.sender];
102         if (balances[_from] >= _value
103         && allowance >= _value
104         && balances[_to] + _value >= balances[_to]
105         ) {
106             balances[_to] += _value;
107             balances[_from] -= _value;
108             if (allowance < MAX_UINT) {
109                 allowed[_from][msg.sender] -= _value;
110             }
111             emit Transfer(_from, _to, _value);
112             return true;
113         } else {
114             return false;
115         }
116     }
117 }
118 
119 contract AladdinEXToken is UnboundedRegularToken {
120 
121     uint public totalSupply = 2100000000 ether;
122     uint8 constant public decimals = 18;
123     string constant public name = "AladdinEX Token";
124     string constant public symbol = "ALDT";
125 
126     constructor() public {
127         balances[msg.sender] = totalSupply;
128         emit Transfer(address(0), msg.sender, totalSupply);
129     }
130 }