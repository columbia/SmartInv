1 pragma solidity ^0.4.25;
2 
3 contract FloodToken {
4 
5     uint256 constant MAX_UINT256 = 2**256 - 1;
6     uint256 public totalSupply;
7     string public name;
8     uint8 public decimals;
9     string public symbol;
10     string public version = 'FLOOD0.1';
11     uint public init;
12     mapping (address => uint256) balances;
13     mapping (address => mapping (address => uint256)) allowed;
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 
18     constructor() public {}
19 
20     function transfer(address _to, uint256 _value) public returns (bool success) {
21         require(balances[msg.sender] >= _value);
22         balances[msg.sender] -= _value;
23         balances[_to] += _value;
24         emit Transfer(msg.sender, _to, _value);
25         return true;
26     }
27 
28     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success) {
29         uint256 allowance = allowed[_from][msg.sender];
30         require(balances[_from] >= _value && allowance >= _value);
31         balances[_to] += _value;
32         balances[_from] -= _value;
33         if (allowance < MAX_UINT256) {
34             allowed[_from][msg.sender] -= _value;
35         }
36         emit Transfer(_from, _to, _value);
37         return true;
38     }
39 
40     function balanceOf(address _owner) public constant returns (uint256 balance) {
41         return balances[_owner];
42     }
43 
44     function approve(address _spender, uint256 _value) public returns (bool success) {
45         allowed[msg.sender][_spender] = _value;
46         emit Approval(msg.sender, _spender, _value);
47         return true;
48     }
49 
50     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
51       return allowed[_owner][_spender];
52     }
53 
54     function burn(uint _amount) public returns (uint256 remaining) {
55     	if(balances[msg.sender]>=_amount){
56     		if(totalSupply>=_amount){
57     			transfer(address(0x0), _amount);
58     			balances[address(0x0)]-=_amount;
59     			totalSupply-=_amount;
60     		}
61     	}
62         return balances[msg.sender];
63     }
64 
65     /* Approves and then calls the receiving contract */
66     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
67         allowed[msg.sender][_spender] = _value;
68         emit Approval(msg.sender, _spender, _value);
69         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
70         return true;
71     }
72 
73 
74     function init(
75         uint256 _initialAmount,
76         string _tokenName,
77         uint8 _decimalUnits,
78         string _tokenSymbol
79         ) public returns (bool){
80         if(init>0)revert();
81         balances[msg.sender] = _initialAmount;
82         totalSupply = _initialAmount;
83         name = _tokenName; 
84         decimals = _decimalUnits;
85         symbol = _tokenSymbol;
86         init=1;
87         return true;
88     }
89 
90    
91 }