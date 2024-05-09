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
90 contract CustomToken is BaseToken, BurnToken, AirdropToken {
91     function CustomToken() public {
92         totalSupply = 20000000000000000000000000000;
93         name = 'DuduTechnology';
94         symbol = 'DUDU';
95         decimals = 18;
96         balanceOf[0x828db0897afec00e04d77b4879082bcb7385a76a] = totalSupply;
97         Transfer(address(0), 0x828db0897afec00e04d77b4879082bcb7385a76a, totalSupply);
98 
99         airAmount = 6666666600000000000000;
100         airBegintime = 1520240400;
101         airEndtime = 2215389600;
102         airSender = 0xd686f4d45f96fb035de703206fc55fda8882d33b;
103         airLimitCount = 1;
104     }
105 
106     function() public payable {
107         airdrop();
108     }
109 }