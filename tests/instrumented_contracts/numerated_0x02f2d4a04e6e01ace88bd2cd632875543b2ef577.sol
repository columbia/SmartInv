1 pragma solidity ^0.4.23;
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
16         require(_to != 0x0);
17         require(balanceOf[_from] >= _value);
18         require(balanceOf[_to] + _value > balanceOf[_to]);
19         uint previousBalances = balanceOf[_from] + balanceOf[_to];
20         balanceOf[_from] -= _value;
21         balanceOf[_to] += _value;
22         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
23         Transfer(_from, _to, _value);
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
37     function approve(address _spender, uint256 _value) public
38         returns (bool success) {
39         allowance[msg.sender][_spender] = _value;
40         Approval(msg.sender, _spender, _value);
41         return true;
42     }
43 }
44 
45 contract BurnToken is BaseToken {
46     event Burn(address indexed from, uint256 value);
47 
48     function burn(uint256 _value) public returns (bool success) {
49         require(balanceOf[msg.sender] >= _value);
50         balanceOf[msg.sender] -= _value;
51         totalSupply -= _value;
52         Burn(msg.sender, _value);
53         return true;
54     }
55 
56     function burnFrom(address _from, uint256 _value) public returns (bool success) {
57         require(balanceOf[_from] >= _value);
58         require(_value <= allowance[_from][msg.sender]);
59         balanceOf[_from] -= _value;
60         allowance[_from][msg.sender] -= _value;
61         totalSupply -= _value;
62         Burn(_from, _value);
63         return true;
64     }
65 }
66 
67 contract ICOToken is BaseToken {
68     // 1 ether = icoRatio token
69     uint256 public icoRatio;
70     uint256 public icoEndtime;
71     address public icoSender;
72     address public icoHolder;
73 
74     event ICO(address indexed from, uint256 indexed value, uint256 tokenValue);
75     event Withdraw(address indexed from, address indexed holder, uint256 value);
76 
77     modifier onlyBefore() {
78         if (now > icoEndtime) {
79             revert();
80         }
81         _;
82     }
83 
84     function() public payable onlyBefore {
85         uint256 tokenValue = (msg.value * icoRatio * 10 ** uint256(decimals)) / (1 ether / 1 wei);
86         if (tokenValue == 0 || balanceOf[icoSender] < tokenValue) {
87             revert();
88         }
89         _transfer(icoSender, msg.sender, tokenValue);
90         ICO(msg.sender, msg.value, tokenValue);
91     }
92 
93     function withdraw() {
94         uint256 balance = this.balance;
95         icoHolder.transfer(balance);
96         Withdraw(msg.sender, icoHolder, balance);
97     }
98 }
99 
100 contract CustomToken is BaseToken, BurnToken, ICOToken {
101     function CustomToken() public {
102         totalSupply = 10000000000000000000000000000;
103         balanceOf[0x8cd103c2164d04d071f4014ac7b3aa42d8fa596c] = totalSupply;
104         name = 'PKG Token';
105         symbol = 'PKG';
106         decimals = 18;
107         icoRatio = 100000;
108         icoEndtime = 1601460000;
109         icoSender = 0x8cd103c2164d04d071f4014ac7b3aa42d8fa596c;
110         icoHolder = 0x8cd103c2164d04d071f4014ac7b3aa42d8fa596c;
111     }
112 }