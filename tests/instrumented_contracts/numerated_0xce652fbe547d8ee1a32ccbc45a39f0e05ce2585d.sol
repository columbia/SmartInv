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
11     address public creator;
12     bool public burnt;
13     uint public init;
14     address public Factory;
15     mapping (address => uint256) balances;
16     mapping (address => mapping (address => uint256)) allowed;
17 
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 
21     constructor() public {}
22 
23     function transfer(address _to, uint256 _value) public returns (bool success) {
24         require(balances[msg.sender] >= _value);
25         balances[msg.sender] -= _value;
26         balances[_to] += _value;
27         emit Transfer(msg.sender, _to, _value);
28         return true;
29     }
30 
31     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success) {
32         uint256 allowance = allowed[_from][msg.sender];
33         require(balances[_from] >= _value && allowance >= _value);
34         balances[_to] += _value;
35         balances[_from] -= _value;
36         if (allowance < MAX_UINT256) {
37             allowed[_from][msg.sender] -= _value;
38         }
39         emit Transfer(_from, _to, _value);
40         return true;
41     }
42 
43     function balanceOf(address _owner) public constant returns (uint256 balance) {
44         return balances[_owner];
45     }
46 
47     function approve(address _spender, uint256 _value) public returns (bool success) {
48         allowed[msg.sender][_spender] = _value;
49         emit Approval(msg.sender, _spender, _value);
50         return true;
51     }
52 
53     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
54       return allowed[_owner][_spender];
55     }
56 
57     function burn(uint _amount) public returns (uint256 remaining) {
58     	if(balances[msg.sender]>=_amount){
59     		if(totalSupply>=_amount){
60     			transfer(address(0x0), _amount);
61     			balances[address(0x0)]-=_amount;
62     			totalSupply-=_amount;
63     		}
64     	}
65         return balances[msg.sender];
66     }
67 
68     /* Approves and then calls the receiving contract */
69     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
70         allowed[msg.sender][_spender] = _value;
71         emit Approval(msg.sender, _spender, _value);
72         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
73         return true;
74     }
75 
76 
77     function init(
78         uint256 _initialAmount,
79         string _tokenName,
80         uint8 _decimalUnits,
81         string _tokenSymbol,
82         address _owner
83         ) public returns (bool){
84         if(init>0)revert();
85         balances[_owner] = _initialAmount;
86         totalSupply = _initialAmount;
87         name = _tokenName; 
88         decimals = _decimalUnits;
89         symbol = _tokenSymbol;   
90         creator=_owner;
91         Factory=msg.sender;
92         burnt=false;
93         init=1;
94         return true;
95     }
96 
97    
98 }