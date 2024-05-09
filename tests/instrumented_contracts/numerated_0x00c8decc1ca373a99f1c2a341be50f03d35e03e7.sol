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
67 contract AirdropToken is BaseToken {
68     uint256 public airAmount;
69     uint256 public airBegintime;
70     uint256 public airEndtime;
71     address public airSender;
72     uint32 public airLimitCount;
73 
74     mapping (address => uint32) public airCountOf;
75 
76     event Airdrop(address indexed from, uint32 indexed count, uint256 tokenValue);
77 
78     function airdrop() public payable {
79         require(now >= airBegintime && now <= airEndtime);
80         require(msg.value == 0);
81         if (airLimitCount > 0 && airCountOf[msg.sender] >= airLimitCount) {
82             revert();
83         }
84         _transfer(airSender, msg.sender, airAmount);
85         airCountOf[msg.sender] += 1;
86         Airdrop(msg.sender, airCountOf[msg.sender], airAmount);
87     }
88 }
89 
90 contract LockToken is BaseToken {
91     struct LockMeta {
92         uint256 amount;
93         uint256 endtime;
94     }
95     
96     mapping (address => LockMeta) public lockedAddresses;
97 
98     function _transfer(address _from, address _to, uint _value) internal {
99         require(balanceOf[_from] >= _value);
100         LockMeta storage meta = lockedAddresses[_from];
101         require(now >= meta.endtime || meta.amount <= balanceOf[_from] - _value);
102         super._transfer(_from, _to, _value);
103     }
104 }
105 
106 contract CustomToken is BaseToken, BurnToken, AirdropToken, LockToken {
107     function CustomToken() public {
108         totalSupply = 100000000000000000;
109         name = 'BitValue';
110         symbol = 'BV';
111         decimals = 8;
112         balanceOf[0xf35e3344cbb5ab8da4294b741f7e378212dc0e89] = totalSupply;
113         Transfer(address(0), 0xf35e3344cbb5ab8da4294b741f7e378212dc0e89, totalSupply);
114 
115         airAmount = 1000000000;
116         airBegintime = 1546149600;
117         airEndtime = 2177388000;
118         airSender = 0x8efc62dbf088c556503470ddbea0b797d66cf45d;
119         airLimitCount = 1;
120 
121         lockedAddresses[0x51d013c61026c2819ee7880164c5226654b2092d] = LockMeta({amount: 9000000000000000, endtime: 1551402000});
122         lockedAddresses[0x8efc62dbf088c556503470ddbea0b797d66cf45d] = LockMeta({amount: 9000000000000000, endtime: 1559350800});
123         lockedAddresses[0x061aa72cbe0e4c02bc53cd7b4edd789f9465344e] = LockMeta({amount: 9000000000000000, endtime: 1575162000});
124         lockedAddresses[0x0eb9f24e3b5a0684ee04a23cc90adfce067c4cf5] = LockMeta({amount: 9000000000000000, endtime: 1590973200});
125         lockedAddresses[0x92c5c5d223607028e519e694a16999b004e17d49] = LockMeta({amount: 9000000000000000, endtime: 1606784400});
126         lockedAddresses[0xcb9ee43e4e2096be331c5be13d0a9a38cac955dc] = LockMeta({amount: 9000000000000000, endtime: 1622509200});
127         lockedAddresses[0xba14daefca3575d5b2f0238bf04d4ba2e0bef7ac] = LockMeta({amount: 9000000000000000, endtime: 1638320400});
128         lockedAddresses[0x79e8086c0345448b6613e5700b9cae8e05d748a8] = LockMeta({amount: 9000000000000000, endtime: 1654045200});
129         lockedAddresses[0x7e1061345337f8cb320d2e08ca6de757d2382c17] = LockMeta({amount: 9000000000000000, endtime: 1669856400});
130         lockedAddresses[0xc83ae4bbd5186fcedee714cc841889a835cb97c5] = LockMeta({amount: 9000000000000000, endtime: 1685581200});
131     }
132 
133     function() public payable {
134         airdrop();
135     }
136 }