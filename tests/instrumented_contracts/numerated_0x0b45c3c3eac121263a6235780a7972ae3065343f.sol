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
45 contract ICOToken is BaseToken {
46     // 1 ether = icoRatio token
47     uint256 public icoRatio;
48     uint256 public icoBegintime;
49     uint256 public icoEndtime;
50     address public icoSender;
51     address public icoHolder;
52 
53     event ICO(address indexed from, uint256 indexed value, uint256 tokenValue);
54     event Withdraw(address indexed from, address indexed holder, uint256 value);
55 
56     function ico() public payable {
57         require(now >= icoBegintime && now <= icoEndtime);
58         uint256 tokenValue = (msg.value * icoRatio * 10 ** uint256(decimals)) / (1 ether / 1 wei);
59         if (tokenValue == 0 || balanceOf[icoSender] < tokenValue) {
60             revert();
61         }
62         _transfer(icoSender, msg.sender, tokenValue);
63         ICO(msg.sender, msg.value, tokenValue);
64     }
65 
66     function withdraw() public {
67         uint256 balance = this.balance;
68         icoHolder.transfer(balance);
69         Withdraw(msg.sender, icoHolder, balance);
70     }
71 }
72 
73 contract LockToken is BaseToken {
74     struct LockMeta {
75         uint256 amount;
76         uint256 endtime;
77     }
78     
79     mapping (address => LockMeta) public lockedAddresses;
80 
81     function _transfer(address _from, address _to, uint _value) internal {
82         require(balanceOf[_from] >= _value);
83         LockMeta storage meta = lockedAddresses[_from];
84         require(now >= meta.endtime || meta.amount <= balanceOf[_from] - _value);
85         super._transfer(_from, _to, _value);
86     }
87 }
88 
89 contract CustomToken is BaseToken, ICOToken, LockToken {
90     function CustomToken() public {
91         totalSupply = 2100000000000000000000000000;
92         name = 'ekkoblockTokens';
93         symbol = 'ebkc';
94         decimals = 18;
95         balanceOf[0x1a5e273c23518af490ca89d31c23dadd9f3df3a5] = totalSupply;
96         Transfer(address(0), 0x1a5e273c23518af490ca89d31c23dadd9f3df3a5, totalSupply);
97 
98         icoRatio = 2000;
99         icoBegintime = 1525104000;
100         icoEndtime = 1546185600;
101         icoSender = 0xce2f76a6b7d3fa0a2e47161536f34db869710b70;
102         icoHolder = 0xce2f76a6b7d3fa0a2e47161536f34db869710b70;
103 
104         lockedAddresses[0xfb955f286e3366409b6cf1ee858648609c65fc2c] = LockMeta({amount: 630000000000000000000000000, endtime: 1556640000});
105     }
106 
107     function() public payable {
108         ico();
109     }
110 }