1 pragma solidity ^0.5.3;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() public view returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) public view returns (uint256 balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) public returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) public  returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38     
39 }
40 
41 contract Ownable {
42     address public owner;
43     
44     modifier onlyOwner() {
45         if (msg.sender != owner) {
46             revert();
47         }
48         _;
49     }
50     
51     constructor() public {
52         owner = msg.sender;
53     }
54     
55     function transferOwnership(address newOwner) public onlyOwner {
56         if (newOwner != address(0)) {
57             owner = newOwner;
58         }
59     }
60 }
61 
62 contract Stoppable is Ownable {
63     bool public stopped;
64     
65     constructor() public {
66         stopped = false;
67     }
68     
69     modifier stoppable() {
70         if (stopped) {
71             revert();
72         }
73         _;
74     }
75     
76     function stop() public onlyOwner {
77         stopped = true;
78     }
79     
80     function start() public onlyOwner {
81         stopped = false;
82     }
83 }
84 
85 contract StandardToken is Token, Stoppable {
86 
87     function transfer(address _to, uint256 _value) public stoppable returns (bool success) {
88         if (_value > 0 && balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
89             balances[msg.sender] -= _value;
90             balances[_to] += _value;
91             emit Transfer(msg.sender, _to, _value);
92             return true;
93         } else { return false; }
94     }
95 
96     function transferFrom(address _from, address _to, uint256 _value) public stoppable returns (bool success) {
97         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to] && _value > 0) {
98             allowed[_from][msg.sender] -= _value;
99             balances[_from] -= _value;
100             balances[_to] += _value;
101             emit Transfer(_from, _to, _value);
102             return true;
103         } else { return false; }
104     }
105 
106     function balanceOf(address _owner) public view returns (uint256 balance) {
107         return balances[_owner];
108     }
109 
110     function approve(address _spender, uint256 _value) public stoppable returns (bool success) {
111         allowed[msg.sender][_spender] = _value;
112         emit Approval(msg.sender, _spender, _value);
113         return true;
114     }
115 
116     function allowance(address _owner, address _spender) public stoppable view returns (uint256 remaining) {
117       return allowed[_owner][_spender];
118     }
119     
120     function totalSupply() public view returns (uint256 supply) {
121         return _totalSupply;
122     }
123 
124     mapping (address => uint256) balances;
125     mapping (address => mapping (address => uint256)) allowed;
126     uint256 public _totalSupply;
127 }
128 
129 
130 contract CCCToken is StandardToken {
131 
132     function () external {
133         /// If ether is sent to this address, send it back.
134         revert();
135     }
136 
137 
138     string public name = 'Coinchat Coin';
139     uint8 public decimals = 18;
140     string public symbol = 'CCC';
141     string public version = 'v201901311334';
142 
143 
144     constructor() public {
145         balances[msg.sender] = 21000000000000000000000000000;
146         _totalSupply = 21000000000000000000000000000;
147         name = "Coinchat Coin";
148         decimals = 18;
149         symbol = "CCC";
150     }
151 }