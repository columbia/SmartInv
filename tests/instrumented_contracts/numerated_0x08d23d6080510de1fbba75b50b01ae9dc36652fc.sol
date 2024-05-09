1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-15
3 */
4 
5 pragma solidity 0.4.19;
6 
7 contract Token {
8 
9     /// @return total amount of tokens
10     function totalSupply() constant returns (uint supply) {}
11 
12     /// @param _owner The address from which the balance will be retrieved
13     /// @return The balance
14     function balanceOf(address _owner) constant returns (uint balance) {}
15 
16     /// @notice send `_value` token to `_to` from `msg.sender`
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transfer(address _to, uint _value) returns (bool success) {}
21 
22     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
23     /// @param _from The address of the sender
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
28 
29     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @param _value The amount of wei to be approved for transfer
32     /// @return Whether the approval was successful or not
33     function approve(address _spender, uint _value) returns (bool success) {}
34 
35     /// @param _owner The address of the account owning tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @return Amount of remaining tokens allowed to spent
38     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
39 
40     event Transfer(address indexed _from, address indexed _to, uint _value);
41     event Approval(address indexed _owner, address indexed _spender, uint _value);
42 }
43 
44 contract RegularToken is Token {
45 
46     function transfer(address _to, uint _value) returns (bool) {
47         //Default assumes totalSupply can't be over max (2^256 - 1).
48         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
49             balances[msg.sender] -= _value;
50             balances[_to] += _value;
51             Transfer(msg.sender, _to, _value);
52             return true;
53         } else { return false; }
54     }
55 
56     function transferFrom(address _from, address _to, uint _value) returns (bool) {
57         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
58             balances[_to] += _value;
59             balances[_from] -= _value;
60             allowed[_from][msg.sender] -= _value;
61             Transfer(_from, _to, _value);
62             return true;
63         } else { return false; }
64     }
65 
66     function balanceOf(address _owner) constant returns (uint) {
67         return balances[_owner];
68     }
69 
70     function approve(address _spender, uint _value) returns (bool) {
71         allowed[msg.sender][_spender] = _value;
72         Approval(msg.sender, _spender, _value);
73         return true;
74     }
75 
76     function allowance(address _owner, address _spender) constant returns (uint) {
77         return allowed[_owner][_spender];
78     }
79 
80     mapping (address => uint) balances;
81     mapping (address => mapping (address => uint)) allowed;
82     uint public totalSupply;
83 }
84 
85 contract UnboundedRegularToken is RegularToken {
86 
87     uint constant MAX_UINT = 2**256 - 1;
88     
89     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
90     /// @param _from Address to transfer from.
91     /// @param _to Address to transfer to.
92     /// @param _value Amount to transfer.
93     /// @return Success of transfer.
94     function transferFrom(address _from, address _to, uint _value)
95         public
96         returns (bool)
97     {
98         uint allowance = allowed[_from][msg.sender];
99         if (balances[_from] >= _value
100             && allowance >= _value
101             && balances[_to] + _value >= balances[_to]
102         ) {
103             balances[_to] += _value;
104             balances[_from] -= _value;
105             if (allowance < MAX_UINT) {
106                 allowed[_from][msg.sender] -= _value;
107             }
108             Transfer(_from, _to, _value);
109             return true;
110         } else {
111             return false;
112         }
113     }
114 }
115 
116 contract EDHToken is UnboundedRegularToken {
117 
118     uint public totalSupply = 19*10**25;
119     uint8 constant public decimals = 18;
120     string constant public name = "EDHToken";
121     string constant public symbol = "EDH";
122 
123     function EDHToken() {
124         balances[msg.sender] = totalSupply;
125         Transfer(address(0), msg.sender, totalSupply);
126     }
127 }