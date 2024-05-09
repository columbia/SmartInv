1 pragma solidity ^0.4.11;
2 
3 contract Token {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract StandardToken is Token {
15     modifier onlyPayloadSize(uint numwords) {
16         assert(msg.data.length == numwords * 32 + 4);
17         _;
18     }
19 
20     function transfer(address _to, uint256 _value) onlyPayloadSize(2) returns (bool success) {
21         if (balances[msg.sender] >= _value && _value > 0) {
22             balances[msg.sender] -= _value;
23             balances[_to] += _value;
24             Transfer(msg.sender, _to, _value);
25             return true;
26         } else {
27             return false;
28         }
29     }
30 
31     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) returns (bool success) {
32         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
33             balances[_to] += _value;
34             balances[_from] -= _value;
35             allowed[_from][msg.sender] -= _value;
36             Transfer(_from, _to, _value);
37             return true;
38         } else {
39             return false;
40         }
41     }
42 
43     function balanceOf(address _owner) constant returns (uint256 balance) {
44         return balances[_owner];
45     }
46 
47     function approve(address _spender, uint256 _value) onlyPayloadSize(2) returns (bool success) {
48         require(_value == 0 || allowed[msg.sender][_spender] == 0);
49 
50         allowed[msg.sender][_spender] = _value;
51         Approval(msg.sender, _spender, _value);
52         return true;
53     }
54 
55     function allowance(address _owner, address _spender) constant onlyPayloadSize(2) returns (uint256 remaining) {
56         return allowed[_owner][_spender];
57     }
58 
59     mapping (address => uint256) balances;
60 
61     mapping (address => mapping (address => uint256)) allowed;
62 }
63 
64 contract SolarEclipseToken is StandardToken {
65     uint8 public decimals = 18;
66     string public name = 'Solar Eclipse Token';
67     address owner;
68     string public symbol = 'SET';
69 
70     uint startTime = 1503330410; // Aug 21, 2017 at 15:46:50 UTC
71     uint endTime = 1503349461; // Aug 21, 2017 at 21:04:21 UTC
72 
73     uint metersInAstronomicalUnit = 149597870700;
74     uint milesInAstronomicalUnit = 92955807;
75     uint speedOfLightInMetersPerSecond = 299792458;
76 
77     uint public totalSupplyCap = metersInAstronomicalUnit * 1 ether;
78     uint public tokensPerETH = milesInAstronomicalUnit;
79 
80     uint public ownerTokens = speedOfLightInMetersPerSecond * 10 ether;
81 
82     function ownerWithdraw() {
83         if (msg.sender != owner) revert(); // revert if not owner
84 
85         owner.transfer(this.balance); // send contract balance to owner
86     }
87 
88     function () payable {
89         if (now < startTime) revert(); // revert if solar eclipse has not started
90         if (now > endTime) revert(); // revert if solar eclipse has ended
91         if (totalSupply >= totalSupplyCap) revert(); // revert if totalSupplyCap has been exhausted
92 
93         uint tokensIssued = msg.value * tokensPerETH;
94 
95         if (totalSupply + tokensIssued > totalSupplyCap) {
96             tokensIssued = totalSupplyCap - totalSupply; // ensure supply is capped
97         }
98 
99         totalSupply += tokensIssued;
100         balances[msg.sender] += tokensIssued; // transfer tokens to contributor
101     }
102 
103     function SolarEclipseToken() {
104         owner = msg.sender;
105         totalSupply = ownerTokens;
106         balances[owner] = ownerTokens;
107     }
108 }