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
11     bool public burnt;
12     uint public init;
13     mapping (address => uint256) balances;
14     mapping (address => mapping (address => uint256)) allowed;
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 
19     constructor() public {}
20 
21     function transfer(address _to, uint256 _value) public returns (bool success) {
22         require(balances[msg.sender] >= _value);
23         balances[msg.sender] -= _value;
24         balances[_to] += _value;
25         emit Transfer(msg.sender, _to, _value);
26         return true;
27     }
28 
29     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success) {
30         uint256 allowance = allowed[_from][msg.sender];
31         require(balances[_from] >= _value && allowance >= _value);
32         balances[_to] += _value;
33         balances[_from] -= _value;
34         if (allowance < MAX_UINT256) {
35             allowed[_from][msg.sender] -= _value;
36         }
37         emit Transfer(_from, _to, _value);
38         return true;
39     }
40 
41     function balanceOf(address _owner) public constant returns (uint256 balance) {
42         return balances[_owner];
43     }
44 
45     function approve(address _spender, uint256 _value) public returns (bool success) {
46         allowed[msg.sender][_spender] = _value;
47         emit Approval(msg.sender, _spender, _value);
48         return true;
49     }
50 
51     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
52       return allowed[_owner][_spender];
53     }
54 
55     function burn(uint _amount) public returns (uint256 remaining) {
56     	if(balances[msg.sender]>=_amount){
57     		if(totalSupply>=_amount){
58     			transfer(address(0x0), _amount);
59     			balances[address(0x0)]-=_amount;
60     			totalSupply-=_amount;
61     		}
62     	}
63         return balances[msg.sender];
64     }
65 
66     /* Approves and then calls the receiving contract */
67     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
68         allowed[msg.sender][_spender] = _value;
69         emit Approval(msg.sender, _spender, _value);
70         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
71         return true;
72     }
73 
74 
75     function init(
76         uint256 _initialAmount,
77         string _tokenName,
78         uint8 _decimalUnits,
79         string _tokenSymbol
80         ) public returns (bool){
81         if(init>0)revert();
82         balances[msg.sender] = _initialAmount;
83         totalSupply = _initialAmount;
84         name = _tokenName; 
85         decimals = _decimalUnits;
86         symbol = _tokenSymbol;
87         burnt=false;
88         init=1;
89         return true;
90     }
91 
92    
93 }