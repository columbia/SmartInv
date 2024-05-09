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
60 // requires 133,650,000 BAT deposited here
61 contract BATSafe {
62   mapping (address => uint256) allocations;
63   uint256 public unlockDate;
64   address public BAT;
65   uint256 public constant exponent = 10**18;
66 
67   function BATSafe(address _BAT) {
68     BAT = _BAT;
69     unlockDate = now + 6 * 30 days;
70     allocations[0xe0f6EF3D61255d1Bd7ad66987D2fBB3FE5Ee8Ea4] = 16000000;
71     allocations[0xCB25966330044310ecD09634ea6B1f4190d5B10D] = 16000000;
72     allocations[0xFf8e2295EF4Ad0db7aFaDC13743c227Bb0e82838] = 16000000;
73     allocations[0x9Dc920118672c04645Eb2831A70d2aA1ccBF330c] = 16000000;
74     allocations[0xb9FE2d16eBAD02Ba3A6f61F64e8506F1C80cec07] = 8000000;
75     allocations[0x92C9304e826451a3Af0fc9f4d36Ae59920F80b0f] = 8000000;
76     allocations[0x5cAe9Bc0C527f95CC6558D32EC5B931ad7328088] = 8000000;
77     allocations[0xF94BE6b93432b39Bc1637FDD656740758736d935] = 4000000;
78     allocations[0x4Fb65030536103EA718Fa37A3E05c76aDB3C5447] = 4000000;
79     allocations[0x216C83DD2383e44cb9914C05aCd019dde429F201] = 2250000;
80     allocations[0x460599DC0A5AF7b4bef0ee6fdDA23DBF8CC6cA70] = 2000000;
81     allocations[0x06BdBDcCBeC95937b742c0EADf7B2f50c4f325C0] = 2000000;
82     allocations[0x6eED129DD60251c7C839Bf0D161199a3A3FED959] = 2000000;
83     allocations[0xAF6929A04651FE2fDa8eBBD18A6ed89ba6F7bb3b] = 2000000;
84     allocations[0x74019652e7Bfe06e055f1424E8F695d85c5AdDDa] = 2000000;
85     allocations[0x77D325161984D3A5835cfEB5dB4E6CF998904a84] = 2000000;
86     allocations[0x7b28547b78e425AbaE8f472e2A77021e9b19B5ad] = 2000000;
87     allocations[0xFF6Cb8161A55DB05F9B41F34F5A8B3dc1F1E1A7e] = 2000000;
88     allocations[0x016078A5e18D9a2A4698e8623744556F09a9Ca15] = 2000000;
89     allocations[0x5A471480d72D6a6Da75b7546D740F95387174c2D] = 2000000;
90     allocations[0xb46De0168c02246C0C1C4Cf562E9003cBf01CdD7] = 2000000;
91     allocations[0x9bbBD666B714C84764B1aE4012DD177526E63fB4] = 2000000;
92     allocations[0xC6aD53B70d2cCEf579D0CC4a22Ed18a62ADD33b6] = 2000000;
93     allocations[0x398aD5ed756C42758B33c4Ae36162E5C0cE787cE] = 2000000;
94     allocations[0x4b93f57953D685F7241699a87F2464fA8B1b9bD9] = 2000000;
95     allocations[0xFCdFdD838bAf60E53EAc5d86F3234854f7e0DDee] = 2000000;
96     allocations[0x98949388D6c5e9B91a1F30e33595A5E6127036bE] = 2000000;
97     allocations[0x7A5c1A532a89B50c84f9fFd7f915093f5C637081] = 700000;
98     allocations[0x2cb8457Adde40aa7298C19Fa94426B94317C2744] = 700000;
99   }
100 
101   function unlock() external {
102     if(now < unlockDate) throw;
103     uint256 entitled = allocations[msg.sender];
104     allocations[msg.sender] = 0;
105     if(!StandardToken(BAT).transfer(msg.sender, entitled * exponent)) throw;
106   }
107 
108 }