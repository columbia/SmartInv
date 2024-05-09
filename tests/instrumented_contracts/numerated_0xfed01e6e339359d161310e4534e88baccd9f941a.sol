1 pragma solidity ^0.4.19;
2 
3 contract BaseToken {
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public totalSupply;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 
15     function _transfer(address _from, address _to, uint _value) internal {
16         require(_to != address(0));
17         require(balanceOf[_from] >= _value);
18         require(balanceOf[_to] + _value > balanceOf[_to]);
19         uint previousBalances = balanceOf[_from] + balanceOf[_to];
20         balanceOf[_from] -= _value;
21         balanceOf[_to] += _value;
22         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
23         emit Transfer(_from, _to, _value);
24     }
25 
26     function transfer(address _to, uint256 _value) public returns (bool success) {
27         _transfer(msg.sender, _to, _value);
28         return true;
29     }
30 
31     // function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
32     //     require(_value <= allowance[_from][msg.sender]);
33     //     allowance[_from][msg.sender] -= _value;
34     //     _transfer(_from, _to, _value);
35     //     return true;
36     // }
37 
38     // function approve(address _spender, uint256 _value) public returns (bool success) {
39     //     allowance[msg.sender][_spender] = _value;
40     //     emit Approval(msg.sender, _spender, _value);
41     //     return true;
42     // }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50   constructor() public {
51     owner = msg.sender;
52   }
53 
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   function transferOwnership(address newOwner) public onlyOwner {
60     require(newOwner != address(0));
61     emit OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 }
65 
66 contract AirdropToken is BaseToken, Ownable {
67     // uint256 public airAmount;
68     address public airSender;
69     // uint32 public airLimitCount;
70     // bool public airState;
71 
72     // mapping (address => uint32) public airCountOf;
73 
74     // event Airdrop(address indexed from, uint32 indexed count, uint256 tokenValue);
75 
76     // function setAirState(bool _state) public onlyOwner {
77     //     airState = _state;
78     // }
79 
80     // function setAirAmount(uint256 _amount) public onlyOwner {
81     //     airAmount = _amount;
82     // }
83 
84     // function setAirLimitCount(uint32 _count) public onlyOwner {
85     //     airLimitCount = _count;
86     // }
87 
88     // function setAirSender(address _sender) public onlyOwner {
89     //     airSender = _sender;
90     // }
91 
92     // function airdrop() public payable {
93     //     require(airState == true);
94     //     require(msg.value == 0);
95     //     if (airLimitCount > 0 && airCountOf[msg.sender] >= airLimitCount) {
96     //         revert();
97     //     }
98     //     _transfer(airSender, msg.sender, airAmount);
99     //     airCountOf[msg.sender] += 1;
100     //     emit Airdrop(msg.sender, airCountOf[msg.sender], airAmount);
101     // }
102 
103     function airdropToAdresses(address[] _tos, uint _amount) public onlyOwner {
104         uint total = _amount * _tos.length;
105         require(total >= _amount && balanceOf[airSender] >= total);
106         balanceOf[airSender] -= total;
107         for (uint i = 0; i < _tos.length; i++) {
108             balanceOf[_tos[i]] += _amount;
109             emit Transfer(airSender, _tos[i], _amount);
110         }
111     }
112 }
113 
114 contract CustomToken is BaseToken, AirdropToken {
115     constructor() public {
116         totalSupply = 10000000000000000000000000000;
117         name = 'T0703';
118         symbol = 'T0703';
119         decimals = 18;
120         balanceOf[msg.sender] = totalSupply;
121         emit Transfer(address(0), address(msg.sender), totalSupply);
122 
123         // airAmount = 500000000000000000000;
124         // airState = false;
125         airSender = msg.sender;
126         // airLimitCount = 2;
127     }
128 
129     function() public payable {
130         // airdrop();
131     }
132 }