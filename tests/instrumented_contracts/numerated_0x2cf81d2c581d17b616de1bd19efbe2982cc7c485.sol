1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 
39 }
40 
41 contract StandardToken is Token {
42 
43     function transfer(address _to, uint256 _value) returns (bool success) {
44         //Default assumes totalSupply can't be over max (2^256 - 1).
45         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
46         //Replace the if with this one instead.
47         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
48         if (balances[msg.sender] >= _value && _value > 0) {
49             balances[msg.sender] -= _value;
50             balances[_to] += _value;
51             Transfer(msg.sender, _to, _value);
52             return true;
53         } else { return false; }
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
57         //same as above. Replace this line with the following if you want to protect against wrapping uints.
58         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
59         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60             balances[_to] += _value;
61             balances[_from] -= _value;
62             allowed[_from][msg.sender] -= _value;
63             Transfer(_from, _to, _value);
64             return true;
65         } else { return false; }
66     }
67 
68 
69     function approve(address _spender, uint256 _value) returns (bool success) {
70         allowed[msg.sender][_spender] = _value;
71         Approval(msg.sender, _spender, _value);
72         return true;
73     }
74 
75     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
76       return allowed[_owner][_spender];
77     }
78 
79     mapping (address => uint256) balances;
80     mapping (address => mapping (address => uint256)) allowed;
81     uint256 public totalSupply;
82 }
83 
84 contract PancaCoin is StandardToken { 
85     
86     address owner = msg.sender;
87     string public constant name = "PancaCoin";
88     string public constant symbol = "PANCA";
89     uint public constant decimals = 2;
90     uint256 public totalSupply = 1000000000e2;
91     uint256 public totalDistributed;
92     uint256 public constant requestMinimum = 1 ether / 1000; // 0.01 Ether
93     uint256 public tokensPerEth = 1000000e2;
94     uint public target0drop = 2000;
95     
96     event Airdrop(address indexed _owner, uint _amount, uint _balance);
97     event Burn(address indexed burner, uint256 value);
98     event TokensPerEthUpdated(uint _tokensPerEth);
99     modifier Dev {
100         require(msg.sender == owner);
101         _;
102     }
103 
104     function Distribute(address _participant, uint _amount) Dev internal {
105 
106         require( _amount > 0 );      
107         require( totalDistributed < totalSupply );
108         balances[_participant] = balances[_participant] + (_amount);
109         totalDistributed = totalDistributed + (_amount);
110 
111         // log
112         emit Airdrop(_participant, _amount, balances[_participant]);
113         emit Transfer(address(0), _participant, _amount);
114     }
115     
116     function DistributeAirdrop(address _participant, uint _amount) Dev external {        
117         Distribute(_participant, _amount);
118     }
119 
120     function DistributeAirdropMultiple(address[] _addresses, uint _amount) Dev external {        
121         for (uint i = 0; i < _addresses.length; i++) Distribute(_addresses[i], _amount);
122     }
123 
124     function updateTokensPerEth(uint _tokensPerEth) Dev public  {        
125         tokensPerEth = _tokensPerEth;
126         emit TokensPerEthUpdated(_tokensPerEth);
127     }
128 
129 
130     function burn(uint256 _value) Dev public {
131         require(_value <= balances[msg.sender]);
132         address burner = msg.sender;
133         balances[burner] = (_value);
134         totalSupply = totalSupply-(_value);
135         totalDistributed = totalDistributed-(_value);
136         emit Burn(burner, _value);
137     }
138     
139 
140     function approve(address _spender, uint256 _value) public returns (bool success) {
141         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
142         allowed[msg.sender][_spender] = _value;
143         emit Approval(msg.sender, _spender, _value);
144         return true;
145     }
146     
147     function allowance(address _owner, address _spender) constant public returns (uint256) {
148         return allowed[_owner][_spender];
149     }
150     
151 
152     function withdraw(uint256 _wdamount) Dev public {
153         uint256 wantAmount = _wdamount;
154         owner.transfer(wantAmount);
155     }
156 
157 
158 }