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
70     uint256 public icoBegintime;
71     uint256 public icoEndtime;
72     address public icoSender;
73     address public icoHolder;
74 
75     event ICO(address indexed from, uint256 indexed value, uint256 tokenValue);
76     event Withdraw(address indexed from, address indexed holder, uint256 value);
77 
78     function ico() public payable {
79         require(now >= icoBegintime && now <= icoEndtime);
80         uint256 tokenValue = (msg.value * icoRatio * 10 ** uint256(decimals)) / (1 ether / 1 wei);
81         if (tokenValue == 0 || balanceOf[icoSender] < tokenValue) {
82             revert();
83         }
84         _transfer(icoSender, msg.sender, tokenValue);
85         ICO(msg.sender, msg.value, tokenValue);
86     }
87 
88     function withdraw() public {
89         uint256 balance = this.balance;
90         icoHolder.transfer(balance);
91         Withdraw(msg.sender, icoHolder, balance);
92     }
93 }
94 
95 contract LockToken is BaseToken {
96     struct LockMeta {
97         uint256 amount;
98         uint256 endtime;
99     }
100     
101     mapping (address => LockMeta) public lockedAddresses;
102 
103     function _transfer(address _from, address _to, uint _value) internal {
104         require(balanceOf[_from] >= _value);
105         LockMeta storage meta = lockedAddresses[_from];
106         require(now >= meta.endtime || meta.amount <= balanceOf[_from] - _value);
107         super._transfer(_from, _to, _value);
108     }
109 }
110 
111 contract CustomToken is BaseToken, BurnToken, ICOToken, LockToken {
112     function CustomToken() public {
113         totalSupply = 100000000000000000000000000000;
114         name = 'ArtpolloToken';
115         symbol = 'APT';
116         decimals = 18;
117         balanceOf[0x8665e102b2c4d22da6a391537c3dfbcc6799e90a] = totalSupply;
118         Transfer(address(0), 0x8665e102b2c4d22da6a391537c3dfbcc6799e90a, totalSupply);
119 
120         icoRatio = 200000;
121         icoBegintime = 1523066400;
122         icoEndtime = 1538924400;
123         icoSender = 0xaa0a590d0a151bc9444b52c299ea8e8ede3e9cd3;
124         icoHolder = 0xaa0a590d0a151bc9444b52c299ea8e8ede3e9cd3;
125 
126         lockedAddresses[0x3c1441b6e64af12083ca86012d66bc79e5e51de6] = LockMeta({amount: 10000000000000000000000000000, endtime: 1617811200});
127         lockedAddresses[0xe0f1345bf1c581e610b847c135f96bd152102d2f] = LockMeta({amount: 10000000000000000000000000000, endtime: 1617811200});
128         lockedAddresses[0xac06238c9a64b2d455ee101fd0c415662e43ba2c] = LockMeta({amount: 10000000000000000000000000000, endtime: 1617811200});
129         lockedAddresses[0xe6bd6f2de6a830d3fafdc79a2b9932692e9be53e] = LockMeta({amount: 10000000000000000000000000000, endtime: 1617811200});
130     }
131 
132     function() public payable {
133         ico();
134     }
135 }