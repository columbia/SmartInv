1 pragma solidity ^0.4.0;
2 
3 contract ContractToken {
4     function balanceOf(address _owner) public constant returns (uint256);
5     function transfer(address _to, uint256 _value) public returns (bool);
6 }
7 
8 contract ERC20Token {
9 
10   uint256 public totalSupply;
11   function balanceOf(address who) public constant returns (uint256);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
14   function approve(address _spender, uint256 _value) returns (bool success) {}
15 }
16 
17 contract ERC20 is ERC20Token {
18   function allowance(address owner, address spender) public constant returns (uint256);
19   event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 contract MDL is ERC20 {
23     
24     function name() public constant returns (string) { 
25         return "MDL Talent Hub"; 
26     }
27     function symbol() public constant returns (string) { 
28         return "MDL"; 
29     }
30     function decimals() public constant returns (uint8) { 
31         return 8; 
32     }
33     
34     address owner = msg.sender;
35     mapping (address => uint256) balances;
36     mapping (address => mapping (address => uint256)) allowed;
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40     uint256 public totalSupply = 1000000000 * 10**8;
41 
42     function MDL() public {
43         owner = msg.sender;
44         balances[msg.sender] = totalSupply;
45     }
46 
47     modifier onlyOwner { 
48         require(msg.sender == owner);
49         _;
50     }
51 
52     function airdropMDL(address[] addresses, uint256 _value) onlyOwner public {
53          for (uint i = 0; i < addresses.length; i++) {
54              balances[owner] -= _value;
55              balances[addresses[i]] += _value;
56              emit Transfer(owner, addresses[i], _value);
57          }
58     }
59     
60     
61     function balanceOf(address _owner) constant public returns (uint256) {
62 	 return balances[_owner];
63     }
64     
65     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
66         allowed[msg.sender][_spender] = _value;
67         emit Approval(msg.sender, _spender, _value);
68         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
69         return true;
70     }
71     
72     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
73 
74          if (balances[_from] >= _amount
75              && allowed[_from][msg.sender] >= _amount
76              && _amount > 0
77              && balances[_to] + _amount > balances[_to]) {
78              balances[_from] -= _amount;
79              allowed[_from][msg.sender] -= _amount;
80              balances[_to] += _amount;
81              Transfer(_from, _to, _amount);
82              return true;
83          } else {
84             return false;
85          }
86     }
87     
88     function approve(address _spender, uint256 _value) public returns (bool success) {
89         // mitigates the ERC20 spend/approval race condition
90         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
91         
92         allowed[msg.sender][_spender] = _value;
93         
94         Approval(msg.sender, _spender, _value);
95         return true;
96     }
97     
98     function allowance(address _owner, address _spender) constant public returns (uint256) {
99         return allowed[_owner][_spender];
100     }
101 
102     function withdrawContractTokens(address _tokenContract) public returns (bool) {
103         require(msg.sender == owner);
104         ContractToken token = ContractToken(_tokenContract);
105         uint256 amount = token.balanceOf(address(this));
106         return token.transfer(owner, amount);
107     }
108 
109 
110 }