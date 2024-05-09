1 pragma solidity ^0.4.0;
2 contract ERC20TokenInterface {
3     function totalSupply() constant returns (uint256 supply);
4     function balanceOf(address _owner) constant public returns (uint256 balance);
5     function transfer(address _to, uint256 _value) public returns (bool success);
6     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
7     function approve(address _spender, uint256 _value) public returns (bool success);
8     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
9 
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 contract ART1 is ERC20TokenInterface {
15   string public constant name = 'ART1';
16   uint256 public constant decimals = 2;
17   string public constant symbol = 'ART1';
18   string public constant version = 'v0.0.1';
19 
20   uint256 private constant totalTokens = 277777 * (10 ** decimals);
21 
22   mapping (address => uint256) public balances;
23   mapping (address => mapping (address => uint256)) public allowed;
24 
25   event MigrationInfoSet(string newMigrationInfo);
26 
27   string public migrationInfo = "";
28 
29   address public migrationInfoSetter;
30 
31   modifier onlyFromMigrationInfoSetter {
32     if (msg.sender != migrationInfoSetter) {
33       throw;
34     }
35     _;
36   }
37 
38   function ART1(address _migrationInfoSetter) {
39     if (_migrationInfoSetter == 0) throw;
40     migrationInfoSetter = _migrationInfoSetter;
41     balances[msg.sender] = totalTokens;
42   }
43 
44   function totalSupply() constant returns (uint256) {
45     return totalTokens;
46   }
47 
48   function transfer(address _to, uint256 _value) public returns (bool) {
49     if (balances[msg.sender] >= _value) {
50       balances[msg.sender] -= _value;
51       balances[_to] += _value;
52       Transfer(msg.sender, _to, _value);
53       return true;
54     }
55     return false;
56   }
57 
58   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
59     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
60       balances[_from] -= _value;
61       allowed[_from][msg.sender] -= _value;
62       balances[_to] += _value;
63       Transfer(_from, _to, _value);
64       return true;
65     }
66     return false;
67   }
68 
69   function balanceOf(address _owner) constant public returns (uint256) {
70     return balances[_owner];
71   }
72 
73   function approve(address _spender, uint256 _value) public returns (bool) {
74     allowed[msg.sender][_spender] = _value;
75     Approval(msg.sender, _spender, _value);
76     return true;
77   }
78   function compareAndApprove(address _spender, uint256 _currentValue, uint256 _newValue) public returns(bool) {
79     if (allowed[msg.sender][_spender] != _currentValue) {
80       return false;
81     }
82     return approve(_spender, _newValue);
83   }
84   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
85     return allowed[_owner][_spender];
86   }
87   function setMigrationInfo(string _migrationInfo) onlyFromMigrationInfoSetter public {
88     migrationInfo = _migrationInfo;
89     MigrationInfoSet(_migrationInfo);
90   }
91   function changeMigrationInfoSetter(address _newMigrationInfoSetter) onlyFromMigrationInfoSetter public {
92     migrationInfoSetter = _newMigrationInfoSetter;
93   }
94 }