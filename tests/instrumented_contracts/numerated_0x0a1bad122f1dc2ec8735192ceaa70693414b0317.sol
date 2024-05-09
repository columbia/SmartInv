1 pragma solidity ^0.4.10;
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
14 
15 /*  ERC 20 token */
16 contract StandardToken is Token {
17 
18     function transfer(address _to, uint256 _value) returns (bool success) {
19       if (balances[msg.sender] >= _value && _value > 0) {
20         balances[msg.sender] -= _value;
21         balances[_to] += _value;
22         Transfer(msg.sender, _to, _value);
23         return true;
24       } else {
25         return false;
26       }
27     }
28 
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
30       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
31         balances[_to] += _value;
32         balances[_from] -= _value;
33         allowed[_from][msg.sender] -= _value;
34         Transfer(_from, _to, _value);
35         return true;
36       } else {
37         return false;
38       }
39     }
40 
41     function balanceOf(address _owner) constant returns (uint256 balance) {
42         return balances[_owner];
43     }
44 
45     function approve(address _spender, uint256 _value) returns (bool success) {
46         allowed[msg.sender][_spender] = _value;
47         Approval(msg.sender, _spender, _value);
48         return true;
49     }
50 
51     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
52       return allowed[_owner][_spender];
53     }
54 
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57 }
58 
59 
60 // requires 5,050,000 BAT deposited here
61 contract BATSafe {
62   mapping (address => uint256) allocations;
63   uint256 public unlockDate;
64   address public BAT;
65   uint256 public constant exponent = 10**18;
66 
67   function BATSafe(address _BAT) {
68     BAT = _BAT;
69     unlockDate = now + 6 * 31 days;
70     allocations[0x29940Eec1d3E79e4E20574bB69f4bDF382E60E8A] = 1250000;
71     allocations[0x16733a097bC4aE65356083e2919D9aAD32b9106D] = 800000;
72     allocations[0xB228d4dEe3fD0667F0161FeF769ad44d8F433Bc9] = 200000;
73     allocations[0x245B07814af3d708538D9A1f183450197F0FEBdd] = 200000;
74     allocations[0xb29458e5CaaCc3963D286Eb357CEf0734ff22504] = 200000;
75     allocations[0x31cC98831574d37966b05f9BE44bc14CA303FcCD] = 200000;
76     allocations[0x24f430377A8497cFaD9Ea2839941D6248c3d5275] = 200000;
77     allocations[0x7C350e02319eC6703B120160C3B712821A661f62] = 200000;
78     allocations[0x0DBaC4B5C00C8aAe3c030878c51524C6ED3d2a51] = 200000;
79     allocations[0xdFEb81B6c32c808D53914Ad1A462d6b6439E4230] = 200000;
80     allocations[0xE4d59Aa22c99051BC25e51CDC844d851A0C72aAD] = 200000;
81     allocations[0x76C12809FA051F5edf2a864de8890C26BFb952c2] = 200000;
82     allocations[0xC6204459C59D8e498284337012fc023b7680E7a3] = 200000;
83     allocations[0x92b79d1A09Dde9F5b5Ada7aDE3fe8eB1e56a4D79] = 200000;
84     allocations[0xEE575340dAbE28f989d9521CEb8ca92c4Cd76047] = 200000;
85     allocations[0xb3C7372Bf84D1f13C602b1Fe76A9Ea9B415Be908] = 200000;
86     allocations[0x2761B6a570dB5175668Bd622F0248E6c32b158B7] = 200000;
87   }
88 
89   function unlock() external {
90     if(now < unlockDate) throw;
91     uint256 entitled = allocations[msg.sender];
92     allocations[msg.sender] = 0;
93     if(!StandardToken(BAT).transfer(msg.sender, entitled * exponent)) throw;
94   }
95 
96 }