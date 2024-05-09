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
67 contract LockToken is BaseToken {
68     struct LockMeta {
69         uint256 amount;
70         uint256 endtime;
71     }
72     
73     mapping (address => LockMeta) public lockedAddresses;
74 
75     function _transfer(address _from, address _to, uint _value) internal {
76         require(balanceOf[_from] >= _value);
77         LockMeta storage meta = lockedAddresses[_from];
78         require(now >= meta.endtime || meta.amount <= balanceOf[_from] - _value);
79         super._transfer(_from, _to, _value);
80     }
81 }
82 
83 contract CustomToken is BaseToken, BurnToken, LockToken {
84     function CustomToken() public {
85         totalSupply = 1000000000000000000000000000;
86         name = 'BtonCoin';
87         symbol = 'TON';
88         decimals = 18;
89         balanceOf[0xddf091e5f385aba4a2054ef1235a12908a0a8943] = totalSupply;
90         Transfer(address(0), 0xddf091e5f385aba4a2054ef1235a12908a0a8943, totalSupply);
91 
92         lockedAddresses[0xe2b012b781c6d75e12f3ac601f087bbfec2cbc48] = LockMeta({amount: 30000000000000000000000000, endtime: 1582992000});
93         lockedAddresses[0xa591b18831e6967dd2a12d1e71f3be70e24d2bbf] = LockMeta({amount: 60000000000000000000000000, endtime: 1614528000});
94         lockedAddresses[0x542b823064d62904fac2f616d30a3423d02f6168] = LockMeta({amount: 60000000000000000000000000, endtime: 1646064000});
95         lockedAddresses[0x44c73469fb6fc14529536b961d7eacdf1bbf4a57] = LockMeta({amount: 75000000000000000000000000, endtime: 1677600000});
96         lockedAddresses[0x96714f5a4f09455bde78fbb143a9da41ef43cd9a] = LockMeta({amount: 75000000000000000000000000, endtime: 1709222400});
97     }
98 }