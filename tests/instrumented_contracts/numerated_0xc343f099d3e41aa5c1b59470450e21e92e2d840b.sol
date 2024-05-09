1 pragma solidity ^0.4.11;
2 
3 contract VERIME  {
4     uint public _totalSupply = 1000000000000000000000000000;
5 
6     string public constant symbol = "VME";
7     string public constant name = "Verime Mobile";
8     uint8 public constant decimals = 18;
9 
10     address public owner;
11     address public whitelistedContract;
12     bool freeTransfer = false;
13     mapping (address => uint256) balances;
14     mapping (address => mapping (address => uint256)) allowed;
15 
16     function VERIME(address _multisig) {
17         balances[_multisig] = _totalSupply;
18         owner = _multisig;
19     }
20 
21     modifier onlyOwner() {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     modifier ownerOrEnabledTransfer() {
27         require(freeTransfer || msg.sender == owner || msg.sender == whitelistedContract);
28         _;
29     }
30 
31     function enableTransfer() ownerOrEnabledTransfer() {
32         freeTransfer = true;
33     }
34 
35     function totalSupply() constant returns (uint256 totalSupply){
36         return _totalSupply;
37     }
38 
39     function balanceOf(address _owner) constant returns (uint256 balance) {
40         return balances[_owner];
41     }
42 
43     modifier onlyPayloadSize(uint size) {
44         assert(msg.data.length == size + 4);
45         _;
46     }
47 
48     function transfer(address _to, uint256 _value) ownerOrEnabledTransfer public returns (bool) {
49         require(
50         balances[msg.sender]>= _value
51         && _value > 0
52         );
53         balances[msg.sender] -= _value;
54         balances[_to] += _value;
55         Transfer(msg.sender, _to, _value);
56         return true;
57     }
58     function transferFrom(address _from, address _to, uint256 _value) ownerOrEnabledTransfer public returns (bool success) {
59         require(
60         allowed[_from][msg.sender]  >= _value
61         && balances[_from] >= _value
62         && _value > 0
63         );
64         balances[_from] -= _value;
65         balances[_to] += _value;
66         allowed[_from][msg.sender] -= _value;
67         Transfer(_from, _to, _value);
68         return true;
69     }
70     function approve(address _spender, uint256 _value) public returns (bool success) {
71         // To change the approve amount you first have to reduce the addresses`
72         //  allowance to zero by calling `approve(_spender, 0)` if it is not
73         //  already 0 to mitigate the race condition described here:
74         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75         require(_value == 0 || allowed[msg.sender][_spender] == 0);
76         allowed[msg.sender][_spender] = _value;
77         Approval(msg.sender, _spender, _value);
78         return true;
79     }
80     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
81         return allowed[_owner][_spender];
82     }
83     function changeWhitelistedContract(address newAddress) public onlyOwner returns (bool) {
84         require(newAddress != address(0));
85         whitelistedContract = newAddress;
86     }
87     function transferOwnership(address newOwner) public onlyOwner returns (bool) {
88       require(newOwner != address(0));
89       owner = newOwner;
90     }
91     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
92     event Transfer(address indexed _from, address indexed _to, uint256 _value);
93 
94 }