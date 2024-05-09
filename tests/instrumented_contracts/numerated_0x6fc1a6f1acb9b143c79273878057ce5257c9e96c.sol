1 pragma solidity 0.4.23;
2 
3 contract Asset {
4     event Transfer(address indexed from, address indexed to, uint256 value);
5     event Approval(address indexed owner, address indexed spender, uint256 value);
6 
7     function totalSupply() public view returns (uint256 supply);
8     function balanceOf(address _owner) public view returns (uint256 balance);
9     function transfer(address _to, uint256 _value) public returns (bool success);
10     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
11     function approve(address _spender, uint256 _value) public returns (bool success);
12     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
13 }
14 
15 contract Owned {
16     bool public isConstructedOwned;
17     address public contractOwner;
18     address public pendingContractOwner;
19 
20     constructor() public {
21         constructOwned();
22     }
23 
24     function constructOwned() public returns(bool) {
25         if (isConstructedOwned) {
26             return false;
27         }
28         isConstructedOwned = true;
29         contractOwner = msg.sender;
30         return true;
31     }
32 
33     modifier onlyContractOwner() {
34         if (contractOwner == msg.sender) {
35             _;
36         }
37     }
38 
39     function changeContractOwnership(address _to) public onlyContractOwner() returns(bool) {
40         pendingContractOwner = _to;
41         return true;
42     }
43 
44     function claimContractOwnership() public returns(bool) {
45         if (pendingContractOwner != msg.sender) {
46             return false;
47         }
48         contractOwner = pendingContractOwner;
49         delete pendingContractOwner;
50         return true;
51     }
52 
53     function forceChangeContractOwnership(address _to) public onlyContractOwner() returns(bool) {
54         contractOwner = _to;
55         return true;
56     }
57 }
58 
59 contract Graceful {
60     event Error(bytes32 message);
61 
62     // Only for functions that return bool success before any changes made.
63     function _softRequire(bool _condition, bytes32 _message) internal {
64         if (_condition) {
65             return;
66         }
67         emit Error(_message);
68         bool result = false;
69         assembly {
70             return(result, 32)
71         }
72     }
73 
74     // Generic substitution for require().
75     function _hardRequire(bool _condition, bytes32 _message) internal pure {
76         if (_condition) {
77             return;
78         }
79         assembly {
80             revert(_message, 32)
81         }
82     }
83 
84     function _not(bool _condition) internal pure returns(bool) {
85         return !_condition;
86     }
87 }
88 
89 contract ERC20MigrationTestable is Graceful, Owned {
90     Asset public oldToken;
91     Asset public newToken;
92 
93     event Migrated(address user, uint value);
94 
95     constructor(Asset _oldToken, Asset _newToken) public {
96         require(address(_oldToken) != 0x0);
97         require(address(_newToken) != 0x0);
98 
99         oldToken = _oldToken;
100         newToken = _newToken;
101     }
102 
103     function migrate(uint _value) public returns(bool) {
104         _softRequire(oldToken.transferFrom(msg.sender, address(this), _value), 'Old token transfer failed');
105         _hardRequire(newToken.transfer(msg.sender, _value), 'New token transfer failed');
106         emit Migrated(msg.sender, _value);
107         return true;
108     }
109 
110     function migrateAll() public returns(bool) {
111         return migrate(oldToken.balanceOf(msg.sender));
112     }
113 
114     function withdrawAllFundsFromContract() public onlyContractOwner() returns(bool) {
115         msg.sender.transfer(address(this).balance);
116         return true;
117     }
118 
119     function withdrawAllTokensFromContract(Asset _contract) public onlyContractOwner() returns(bool) {
120         return _contract.transfer(msg.sender, _contract.balanceOf(address(this)));
121     }
122 }