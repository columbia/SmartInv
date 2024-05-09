1 // Most of the code taken from
2 // https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/StandardToken.sol
3 
4 contract TokenInterface {
5 
6     /// @return total amount of tokens
7     function totalSupply() constant returns (uint256 supply) {}
8 
9     /// @param _owner The address from which the balance will be retrieved
10     /// @return The balance
11     function balanceOf(address _owner) constant returns (uint256 balance) {}
12 
13     /// @notice send `_value` token to `_to` from `msg.sender`
14     /// @param _to The address of the recipient
15     /// @param _value The amount of token to be transferred
16     /// @return Whether the transfer was successful or not
17     function transfer(address _to, uint256 _value) returns (bool success) {}
18 
19     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
20     /// @param _from The address of the sender
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
25 
26     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
27     /// @param _spender The address of the account able to transfer the tokens
28     /// @param _value The amount of wei to be approved for transfer
29     /// @return Whether the approval was successful or not
30     function approve(address _spender, uint256 _value) returns (bool success) {}
31 
32     /// @param _owner The address of the account owning tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @return Amount of remaining tokens allowed to spent
35     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
36 
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 }
40 
41 contract HashToken is TokenInterface {
42 
43     mapping (address => uint256) balances;
44     mapping (address => mapping (address => uint256)) allowed;
45     uint256 public totalSupply;
46 
47     bytes32 public prev_hash;
48     uint public max_value;
49 
50     // Meta info
51     string public name;
52     uint8 public decimals;
53     string public symbol;
54     
55     function HashToken() {
56         prev_hash = sha3(block.blockhash(block.number));
57         max_value = 2 ** 255;
58         // Meta info
59         name = 'HashToken';
60         decimals = 16;
61         symbol = 'HTK';
62     }
63 
64     function transfer(address _to, uint256 _value) returns (bool success) {
65         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
66             balances[msg.sender] -= _value;
67             balances[_to] += _value;
68             Transfer(msg.sender, _to, _value);
69             return true;
70         } else { return false; }
71     }
72 
73     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
74         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
75             balances[_to] += _value;
76             balances[_from] -= _value;
77             allowed[_from][msg.sender] -= _value;
78             Transfer(_from, _to, _value);
79             return true;
80         } else { return false; }
81     }
82 
83     function balanceOf(address _owner) constant returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87     function approve(address _spender, uint256 _value) returns (bool success) {
88         allowed[msg.sender][_spender] = _value;
89         Approval(msg.sender, _spender, _value);
90         return true;
91     }
92 
93     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
94       return allowed[_owner][_spender];
95     }
96 
97     event Mint(address indexed minter);
98 
99     function mint(bytes32 value) {
100         if (uint(sha3(value, prev_hash)) > max_value) {
101             throw;
102         }
103         balances[msg.sender] += 10 ** 16;
104         prev_hash = sha3(block.blockhash(block.number), prev_hash);
105         // increase the difficulty
106         max_value -=  max_value / 100;
107         Mint(msg.sender);
108     }
109 }