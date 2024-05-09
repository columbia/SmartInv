1 /**
2  *Submitted for verification at Etherscan.io on 2019-12-03
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2018-02-27
7 */
8 
9 pragma solidity 0.4.19;
10 
11 contract Token {
12 
13     /// @return total amount of tokens
14     function totalSupply() constant returns (uint supply) {}
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) constant returns (uint balance) {}
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint _value) returns (bool success) {}
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
32 
33     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of wei to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint _value) returns (bool success) {}
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
43 
44     event Transfer(address indexed _from, address indexed _to, uint _value);
45     event Approval(address indexed _owner, address indexed _spender, uint _value);
46 }
47 
48 contract RegularToken is Token {
49 
50     function transfer(address _to, uint _value) returns (bool) {
51         //Default assumes totalSupply can't be over max (2^256 - 1).
52         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
53             balances[msg.sender] -= _value;
54             balances[_to] += _value;
55             Transfer(msg.sender, _to, _value);
56             return true;
57         } else { return false; }
58     }
59 
60     function transferFrom(address _from, address _to, uint _value) returns (bool) {
61         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
62             balances[_to] += _value;
63             balances[_from] -= _value;
64             allowed[_from][msg.sender] -= _value;
65             Transfer(_from, _to, _value);
66             return true;
67         } else { return false; }
68     }
69 
70     function balanceOf(address _owner) constant returns (uint) {
71         return balances[_owner];
72     }
73 
74     function approve(address _spender, uint _value) returns (bool) {
75         allowed[msg.sender][_spender] = _value;
76         Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) constant returns (uint) {
81         return allowed[_owner][_spender];
82     }
83 
84     mapping (address => uint) balances;
85     mapping (address => mapping (address => uint)) allowed;
86     uint public totalSupply;
87 }
88 
89 contract UnboundedRegularToken is RegularToken {
90 
91     uint constant MAX_UINT = 2**256 - 1;
92     
93     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
94     /// @param _from Address to transfer from.
95     /// @param _to Address to transfer to.
96     /// @param _value Amount to transfer.
97     /// @return Success of transfer.
98     function transferFrom(address _from, address _to, uint _value)
99         public
100         returns (bool)
101     {
102         uint allowance = allowed[_from][msg.sender];
103         if (balances[_from] >= _value
104             && allowance >= _value
105             && balances[_to] + _value >= balances[_to]
106         ) {
107             balances[_to] += _value;
108             balances[_from] -= _value;
109             if (allowance < MAX_UINT) {
110                 allowed[_from][msg.sender] -= _value;
111             }
112             Transfer(_from, _to, _value);
113             return true;
114         } else {
115             return false;
116         }
117     }
118 }
119 
120 contract TDBCion is UnboundedRegularToken {
121 
122     uint public totalSupply = 21000000*10**18;
123     uint8 constant public decimals = 18;
124     string constant public name = "TDBCion";
125     string constant public symbol = "TDB";
126 
127     function TDBCion() {
128         balances[msg.sender] = totalSupply;
129         Transfer(address(0), msg.sender, totalSupply);
130     }
131 }