1 pragma solidity ^0.4.24;
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
26     function transfer(address _to, uint256 _value) public {
27         _transfer(msg.sender, _to, _value);
28     }
29 
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
31         require(_value <= allowance[_from][msg.sender]);
32         allowance[_from][msg.sender] -= _value;
33         _transfer(_from, _to, _value);
34         return true;
35     }
36 
37     function approve(address _spender, uint256 _value) public returns (bool success) {
38         allowance[msg.sender][_spender] = _value;
39         emit Approval(msg.sender, _spender, _value);
40         return true;
41     }
42 }
43 
44 contract BurnToken is BaseToken {
45     event Burn(address indexed from, uint256 value);
46 
47     function burn(uint256 _value) public returns (bool success) {
48         require(balanceOf[msg.sender] >= _value);
49         balanceOf[msg.sender] -= _value;
50         totalSupply -= _value;
51         emit Burn(msg.sender, _value);
52         return true;
53     }
54 
55     function burnFrom(address _from, uint256 _value) public returns (bool success) {
56         require(balanceOf[_from] >= _value);
57         require(_value <= allowance[_from][msg.sender]);
58         balanceOf[_from] -= _value;
59         allowance[_from][msg.sender] -= _value;
60         totalSupply -= _value;
61         emit Burn(_from, _value);
62         return true;
63     }
64 }
65 
66 contract ICOToken is BaseToken {
67     // 1 ether = icoRatio token
68     uint256 public icoRatio;
69     uint256 public icoEndtime;
70     address public icoSender;
71     address public icoHolder;
72 
73     event ICO(address indexed from, uint256 indexed value, uint256 tokenValue);
74     event Withdraw(address indexed from, address indexed holder, uint256 value);
75 
76     modifier onlyBefore() {
77         if (now > icoEndtime) {
78             revert();
79         }
80         _;
81     }
82 
83     function() public payable onlyBefore {
84         uint256 tokenValue = (msg.value * icoRatio * 10 ** uint256(decimals)) / (1 ether / 1 wei);
85         if (tokenValue == 0 || balanceOf[icoSender] < tokenValue) {
86             revert();
87         }
88         _transfer(icoSender, msg.sender, tokenValue);
89         emit ICO(msg.sender, msg.value, tokenValue);
90     }
91 
92     function withdraw() public{
93         uint256 balance = address(this).balance;
94         icoHolder.transfer(balance);
95         emit Withdraw(msg.sender, icoHolder, balance);
96     }
97 }
98 
99 contract CustomToken is BaseToken, BurnToken, ICOToken {
100     constructor(address icoAddress) public {
101         totalSupply = 210000000000000000;
102         balanceOf[msg.sender] = totalSupply;
103         name = 'VPEToken';
104         symbol = 'VPE';
105         decimals = 8;
106         icoRatio = 10000;
107         icoEndtime = 1559318400;
108         icoSender = icoAddress;
109         icoHolder = icoAddress;
110     }
111 }