1 pragma solidity ^0.4.16;
2 
3 contract ERC20TokenInterface {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
10 
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 contract MigrationRecipientV1Interface {
16     function migrateTokensV1(address _owner, uint256 _balance) public;
17 }
18 
19 contract MainToken is ERC20TokenInterface, MigrationRecipientV1Interface {
20     string public name = "Swag";
21     string public symbol = "SWAG";
22     uint8 public decimals = 0;
23     string public version = '1';
24     mapping (address => uint256) balances;
25     address migrateToAddress = 0x0;
26     address[] migrationSources;
27 
28     function MainToken() public {
29         migrationSources.push(msg.sender);
30     }
31 
32     function balanceOf(address _owner) public constant returns (uint256 balance) {
33         return balances[_owner];
34     }
35 
36     function transfer(address _to, uint256 _value) public onlyIfNotMigrating returns (bool success) {
37         if (balances[msg.sender] >= _value && _value > 0) {
38             balances[msg.sender] -= _value;
39             balances[_to] += _value;
40             Transfer(msg.sender, _to, _value);
41             return true;
42         } else {
43             return false; // Insufficient balance or negative value
44         }
45     }
46 
47     // Migrate tokens to a new version of the contract
48     function migrateMyTokens() public onlyIfMigrating {
49         var balance = balances[msg.sender];
50         if (balance > 0) {
51             totalSupply -= balance;
52             balances[msg.sender] = 0;
53             MigrationRecipientV1Interface(migrateToAddress).migrateTokensV1(msg.sender, balance);
54         }
55     }
56 
57     // Receive tokens from an older version of the token contract
58     function migrateTokensV1(address _owner, uint256 _value) public migrationSourcesOnly {
59         totalSupply += _value;
60         balances[_owner] += _value;
61         Transfer(0x0, _owner, _value);
62     }
63 
64     function setMigrateToAddress(address _to) public migrationSourcesOnly {
65         migrateToAddress = _to;
66     }
67 
68     function setOtherMigrationSources(address[] _otherMigrationSources) public migrationSourcesOnly {
69         migrationSources = _otherMigrationSources;
70         migrationSources.push(msg.sender);
71     }
72 
73     function airdrop(address[] _targets, uint256 _value) public migrationSourcesOnly {
74         totalSupply += _targets.length * _value;
75         for (uint256 i = 0; i < _targets.length; i++) {
76             address target = _targets[i];
77             balances[target] += _value;
78             Transfer(0x0, target, _value);
79         }
80     }
81 
82     function () public {
83     }
84 
85     modifier onlyIfMigrating() {
86         require(migrateToAddress != 0x0);
87         _;
88     }
89 
90     modifier onlyIfNotMigrating() {
91         require(migrateToAddress == 0x0);
92         _;
93     }
94 
95     modifier migrationSourcesOnly() {
96         require(arrayContainsAddress256(migrationSources, msg.sender));
97         _;
98     }
99 
100     // "addresses" may not be longer than 256
101     function arrayContainsAddress256(address[] addresses, address value) internal pure returns (bool) {
102         for (uint8 i = 0; i < addresses.length; i++) {
103             if (addresses[i] == value) {
104                 return true;
105             }
106         }
107         return false;
108     }
109 
110     // Allowances are intentionally not supported.
111     // These are only here to implement the ERC20 interface.
112     function approve(address, uint256) public returns (bool) {
113         return false;
114     }
115 
116     function allowance(address, address) public constant returns (uint256) {
117         return 0;
118     }
119 
120     function transferFrom(address, address, uint256) public returns (bool) {
121         return false;
122     }
123 }