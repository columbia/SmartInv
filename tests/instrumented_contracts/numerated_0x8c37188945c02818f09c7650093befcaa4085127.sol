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
26     function transfer(address _to, uint256 _value) public returns (bool success) {
27         _transfer(msg.sender, _to, _value);
28         return true;
29     }
30 
31     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
32         require(_value <= allowance[_from][msg.sender]);
33         allowance[_from][msg.sender] -= _value;
34         _transfer(_from, _to, _value);
35         return true;
36     }
37 
38     function approve(address _spender, uint256 _value) public returns (bool success) {
39         allowance[msg.sender][_spender] = _value;
40         Approval(msg.sender, _spender, _value);
41         return true;
42     }
43 }
44 
45 contract AirdropToken is BaseToken {
46     uint256 public airAmount;
47     uint256 public airBegintime;
48     uint256 public airEndtime;
49     address public airSender;
50     uint32 public airLimitCount;
51 
52     mapping (address => uint32) public airCountOf;
53 
54     event Airdrop(address indexed from, uint32 indexed count, uint256 tokenValue);
55 
56     function airdrop() public payable {
57         require(now >= airBegintime && now <= airEndtime);
58         require(msg.value == 0);
59         if (airLimitCount > 0 && airCountOf[msg.sender] >= airLimitCount) {
60             revert();
61         }
62         _transfer(airSender, msg.sender, airAmount);
63         airCountOf[msg.sender] += 1;
64         Airdrop(msg.sender, airCountOf[msg.sender], airAmount);
65     }
66 }
67 
68 contract ICOToken is BaseToken {
69     // 1 ether = icoRatio token
70     uint256 public icoRatio;
71     uint256 public icoBegintime;
72     uint256 public icoEndtime;
73     address public icoSender;
74     address public icoHolder;
75 
76     event ICO(address indexed from, uint256 indexed value, uint256 tokenValue);
77     event Withdraw(address indexed from, address indexed holder, uint256 value);
78 
79     function ico() public payable {
80         require(now >= icoBegintime && now <= icoEndtime);
81         uint256 tokenValue = (msg.value * icoRatio * 10 ** uint256(decimals)) / (1 ether / 1 wei);
82         if (tokenValue == 0 || balanceOf[icoSender] < tokenValue) {
83             revert();
84         }
85         _transfer(icoSender, msg.sender, tokenValue);
86         ICO(msg.sender, msg.value, tokenValue);
87     }
88 
89     function withdraw() public {
90         uint256 balance = this.balance;
91         icoHolder.transfer(balance);
92         Withdraw(msg.sender, icoHolder, balance);
93     }
94 }
95 
96 contract CustomToken is BaseToken, AirdropToken, ICOToken {
97     function CustomToken() public {
98         totalSupply = 12000000000000000000000000000;
99         name = 'Fantasy';
100         symbol = 'FT';
101         decimals = 18;
102         balanceOf[0xa06ea172c01d7551d66f0df294eabd8d6c5822be] = totalSupply;
103         Transfer(address(0), 0xa06ea172c01d7551d66f0df294eabd8d6c5822be, totalSupply);
104 
105         airAmount = 5000000000000000000000;
106         airBegintime = 1520312400;
107         airEndtime = 1609390800;
108         airSender = 0xa06ea172c01d7551d66f0df294eabd8d6c5822be;
109         airLimitCount = 1;
110 
111         icoRatio = 200000;
112         icoBegintime = 1520312400;
113         icoEndtime = 1924923600;
114         icoSender = 0xa06ea172c01d7551d66f0df294eabd8d6c5822be;
115         icoHolder = 0xa06ea172c01d7551d66f0df294eabd8d6c5822be;
116     }
117 
118     function() public payable {
119         if (msg.value == 0) {
120             airdrop();
121         } else {
122             ico();
123         }
124     }
125 }