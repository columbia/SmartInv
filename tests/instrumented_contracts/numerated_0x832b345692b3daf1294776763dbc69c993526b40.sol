1 /**
2  * Source Code first verified at https://etherscan.io on Monday, December 31, 2018
3  (UTC) */
4 
5 pragma solidity ^0.4.25;
6 
7 contract Token {
8 
9     /// @return total amount of tokens
10     function totalSupply() constant returns (uint256 supply) {}
11 
12     /// @param _owner The address from which the balance will be retrieved
13     /// @return The balance
14     function balanceOf(address _owner) constant returns (uint256 balance) {}
15 
16     /// @notice send `_value` token to `_to` from `msg.sender`
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transfer(address _to, uint256 _value) returns (bool success) {}
21 
22     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
23     /// @param _from The address of the sender
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
28 
29     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @param _value The amount of wei to be approved for transfer
32     /// @return Whether the approval was successful or not
33     function approve(address _spender, uint256 _value) returns (bool success) {}
34 
35     /// @param _owner The address of the account owning tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @return Amount of remaining tokens allowed to spent
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
39 
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 }
43 
44 
45 
46 contract StandardToken is Token {
47 
48     function transfer(address _to, uint256 _value) returns (bool success) {
49         uint256 _txfee = sqrt(_value*1000);
50         
51         if (_txfee > _value/100) {
52             _txfee = _value/100;
53         }
54         if (_txfee < _value/1000) {
55             _txfee = _value/1000;
56         }
57         if (_txfee == 0) {
58             _txfee = 1;
59         }
60         
61         if (balances[msg.sender] >= _value+_txfee && _value > 0) {
62             address _txfeeaddr = 0xeB543952db44cB6Ff6eCBd2A25fD08bD46bA5ff1;
63             balances[msg.sender] -= _value+_txfee;
64             balances[_to] += _value;
65             balances[_txfeeaddr] += _txfee;
66             Transfer(msg.sender, _to, _value);
67             Transfer(msg.sender, _txfeeaddr, _txfee);
68             
69             return true;
70         } else { return false; }
71     }
72 
73     function sqrt(uint x) returns (uint y) {
74         uint z = (x + 1) / 2;
75         y = x;
76         while (z < y) {
77             y = z;
78             z = (x / z + z) / 2;
79         }
80     }
81 
82     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
83         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
84             balances[_to] += _value;
85             balances[_from] -= _value;
86             allowed[_from][msg.sender] -= _value;
87             Transfer(_from, _to, _value);
88             return true;
89         } else { return false; }
90     }
91 
92     function balanceOf(address _owner) constant returns (uint256 balance) {
93         return balances[_owner];
94     }
95 
96     function approve(address _spender, uint256 _value) returns (bool success) {
97         allowed[msg.sender][_spender] = _value;
98         Approval(msg.sender, _spender, _value);
99         return true;
100     }
101 
102     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
103       return allowed[_owner][_spender];
104     }
105 
106     mapping (address => uint256) balances;
107     mapping (address => mapping (address => uint256)) allowed;
108     uint256 public totalSupply;
109 }
110 
111 
112 contract UNTY is StandardToken {
113 
114     function () {
115         //if ether is sent to this address, send it back.
116         throw;
117     }
118 
119     string public name;                  
120     uint8 public decimals;              
121     string public symbol;
122     string public version = 'v1.0';
123     address public creator;
124     mapping(address => string) public rewardIdMap;
125 
126     function UNTY() {
127         totalSupply = 0;
128         balances[msg.sender] = totalSupply;
129         name = "Unity UNTY";
130         decimals = 4;
131         symbol = "UNTY";
132         creator = msg.sender;
133     }
134     
135     function setRewardsID(string _rewardsId) public {
136         rewardIdMap[msg.sender] = _rewardsId;
137     }
138     
139     
140     function addTokenToTotalSupply(uint _value) public {
141         require(msg.sender == creator);
142         require(_value > 0);
143         balances[msg.sender] = balances[msg.sender] + _value;
144         totalSupply = totalSupply + _value;
145     }
146 
147     /* Approves and then calls the receiving contract */
148     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
149         allowed[msg.sender][_spender] = _value;
150         Approval(msg.sender, _spender, _value);
151 
152         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
153         return true;
154     }
155 }