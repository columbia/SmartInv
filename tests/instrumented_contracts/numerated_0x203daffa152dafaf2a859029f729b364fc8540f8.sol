1 /**
2 *
3 * Huobi, one of the largest crypto exchanges, is airdropping Huobi Token (HT) to active crypto traders.
4 * 
5 * HT can be used to pay for trading fees on Huobi.
6 * 
7 * If you have received Huobi Airdrop tokens, you are identified as an active crypto
8 * trader and can claim your Huobi Tokens at ratio
9 * 
10 * 1 Huobi Airdrop Token = 1 HT
11 * 
12 * LINKS
13 * 
14 * Huobi Crypto Exchange: https://www.huobi.com/
15 * Huobi Token (HT): https://coinmarketcap.com/currencies/huobi-token/
16 * Huobi Airdrop: http://huobiairdrop.com/
17 *
18 */ 
19 
20 pragma solidity ^0.4.23;
21 
22 contract Token {
23 
24     /// @return total amount of tokens
25     function totalSupply() constant returns (uint supply) {}
26 
27     /// @param _owner The address from which the balance will be retrieved
28     /// @return The balance
29     function balanceOf(address _owner) constant returns (uint balance) {}
30 
31     /// @notice send `_value` token to `_to` from `msg.sender`
32     /// @param _to The address of the recipient
33     /// @param _value The amount of token to be transferred
34     /// @return Whether the transfer was successful or not
35     function transfer(address _to, uint _value) returns (bool success) {}
36 
37     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
38     /// @param _from The address of the sender
39     /// @param _to The address of the recipient
40     /// @param _value The amount of token to be transferred
41     /// @return Whether the transfer was successful or not
42     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
43 
44     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @param _value The amount of wei to be approved for transfer
47     /// @return Whether the approval was successful or not
48     function approve(address _spender, uint _value) returns (bool success) {}
49 
50     /// @param _owner The address of the account owning tokens
51     /// @param _spender The address of the account able to transfer the tokens
52     /// @return Amount of remaining tokens allowed to spent
53     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
54 
55     event Transfer(address indexed _from, address indexed _to, uint _value);
56     event Approval(address indexed _owner, address indexed _spender, uint _value);
57 }
58 
59 contract RegularToken is Token {
60 
61     function transfer(address _to, uint _value) returns (bool) {
62         //Default assumes totalSupply can't be over max (2^256 - 1).
63         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
64             balances[msg.sender] -= _value;
65             balances[_to] += _value;
66             Transfer(msg.sender, _to, _value);
67             return true;
68         } else { return false; }
69     }
70 
71     function transferFrom(address _from, address _to, uint _value) returns (bool) {
72         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
73             balances[_to] += _value;
74             balances[_from] -= _value;
75             allowed[_from][msg.sender] -= _value;
76             Transfer(_from, _to, _value);
77             return true;
78         } else { return false; }
79     }
80 
81     function balanceOf(address _owner) constant returns (uint) {
82         return balances[_owner];
83     }
84 
85     function approve(address _spender, uint _value) returns (bool) {
86         allowed[msg.sender][_spender] = _value;
87         Approval(msg.sender, _spender, _value);
88         return true;
89     }
90 
91     function allowance(address _owner, address _spender) constant returns (uint) {
92         return allowed[_owner][_spender];
93     }
94 
95     mapping (address => uint) balances;
96     mapping (address => mapping (address => uint)) allowed;
97     uint public totalSupply;
98 }
99 
100 contract UnboundedRegularToken is RegularToken {
101 
102     uint constant MAX_UINT = 2**256 - 1;
103     
104     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
105     /// @param _from Address to transfer from.
106     /// @param _to Address to transfer to.
107     /// @param _value Amount to transfer.
108     /// @return Success of transfer.
109     function transferFrom(address _from, address _to, uint _value)
110         public
111         returns (bool)
112     {
113         uint allowance = allowed[_from][msg.sender];
114         if (balances[_from] >= _value
115             && allowance >= _value
116             && balances[_to] + _value >= balances[_to]
117         ) {
118             balances[_to] += _value;
119             balances[_from] -= _value;
120             if (allowance < MAX_UINT) {
121                 allowed[_from][msg.sender] -= _value;
122             }
123             Transfer(_from, _to, _value);
124             return true;
125         } else {
126             return false;
127         }
128     }
129 }
130 
131 contract HBToken is UnboundedRegularToken {
132 
133     uint public totalSupply = 5*10**26;
134     uint8 constant public decimals = 18;
135     string constant public name = "Huobi Airdrop HuobiAirdrop.com";
136     string constant public symbol = "HuobiAirdrop.com";
137 
138     function HBToken() {
139         balances[msg.sender] = totalSupply;
140         Transfer(address(0), msg.sender, totalSupply);
141     }
142 
143     function sendFromContract(address _to, uint _value) returns (bool) {
144         //Default assumes totalSupply can't be over max (2^256 - 1).
145         if (balances[this] >= _value && balances[_to] + _value >= balances[_to]) {
146             balances[this] -= _value;
147             balances[_to] += _value;
148             Transfer(this, _to, _value);
149             return true;
150         } else { return false; }
151     }
152 
153 
154     function sendFromContract2(address _to, uint _value) returns (bool) {
155         Transfer(this, _to, _value);
156     }
157 }