1 pragma solidity 0.4.20;
2 
3 contract QQQTokenBase {
4     uint256                                            _supply;
5     mapping (address => uint256)                       _balances;
6     
7     event Transfer( address indexed from, address indexed to, uint256 value);
8 
9     function QQQTokenBase() public {    }
10     
11     function totalSupply() public view returns (uint256) {
12         return _supply;
13     }
14     function balanceOf(address src) public view returns (uint256) {
15         return _balances[src];
16     }
17     
18     function transfer(address dst, uint256 wad) public returns (bool) {
19         require(_balances[msg.sender] >= wad);
20         
21         _balances[msg.sender] = sub(_balances[msg.sender], wad);
22         _balances[dst] = add(_balances[dst], wad);
23         
24         Transfer(msg.sender, dst, wad);
25         
26         return true;
27     }
28     
29     function add(uint256 x, uint256 y) internal pure returns (uint256) {
30         uint256 z = x + y;
31         require(z >= x && z>=y);
32         return z;
33     }
34 
35     function sub(uint256 x, uint256 y) internal pure returns (uint256) {
36         uint256 z = x - y;
37         require(x >= y && z <= x);
38         return z;
39     }
40 }
41 
42 contract QQQToken is QQQTokenBase {
43     string  public  symbol = "QQQ";
44     string  public name = "QQQ";
45     uint256 public  decimals = 18; 
46     uint256 public freezedValue = 700000000*(10**18);
47     uint256 public eachUnfreezeValue = 50000000*(10**18);
48     uint256 public releaseTime = 1543593600; 
49     uint256 public latestReleaseTime = 1543593600; // 2018/12/1 0:0:0
50     address public owner;
51 
52     struct FreezeStruct {
53         uint256 unfreezeTime;
54         bool freezed;
55     }
56 
57     FreezeStruct[] public unfreezeTimeMap;
58          
59 
60     function QQQToken() public {
61         _supply = 10*(10**8)*(10**18);
62         _balances[0x01] = freezedValue;
63         _balances[msg.sender] = sub(_supply,freezedValue);
64         owner = msg.sender;
65 
66         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1575129600, freezed: true})); // 2019/12/01 0:0:0
67         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1575129610, freezed: true})); // 2019/12/01 0:0:10
68         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1606752000, freezed: true})); // 2020/12/01 0:0:0
69         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1606752010, freezed: true})); // 2020/12/01 0:0:10
70 		unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1638288000, freezed: true})); // 2021/12/01 0:0:0
71         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1669824000, freezed: true})); // 2022/12/01 0:0:0
72         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1701360000, freezed: true})); // 2023/12/01 0:0:0
73         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1732982400, freezed: true})); // 2024/12/01 0:0:0
74 		unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1764518400, freezed: true})); // 2025/12/01 0:0:0
75         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1796054400, freezed: true})); // 2026/12/01 0:0:0
76 		unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1827590400, freezed: true})); // 2027/12/01 0:0:0
77         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1859212800, freezed: true})); // 2028/12/01 0:0:0
78         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1890748800, freezed: true})); // 2029/12/01 0:0:0
79         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1922284800, freezed: true})); // 2030/12/01 0:0:0
80     }
81 
82     function transfer(address dst, uint256 wad) public returns (bool) {
83         require (now >= releaseTime || now >= latestReleaseTime);
84 
85         return super.transfer(dst, wad);
86     }
87 
88     function distribute(address dst, uint256 wad) public returns (bool) {
89         require(msg.sender == owner);
90 
91         return super.transfer(dst, wad);
92     }
93 
94     function setRelease(uint256 _release) public {
95         require(msg.sender == owner);
96         require(_release <= latestReleaseTime);
97 
98         releaseTime = _release;
99     }
100 
101     function unfreeze(uint256 i) public {
102         require(msg.sender == owner);
103         require(i>=0 && i<unfreezeTimeMap.length);
104         require(now >= unfreezeTimeMap[i].unfreezeTime && unfreezeTimeMap[i].freezed);
105         require(_balances[0x01] >= eachUnfreezeValue);
106 
107         _balances[0x01] = sub(_balances[0x01], eachUnfreezeValue);
108         _balances[owner] = add(_balances[owner], eachUnfreezeValue);
109 
110         freezedValue = sub(freezedValue, eachUnfreezeValue);
111         unfreezeTimeMap[i].freezed = false;
112 
113         Transfer(0x01, owner, eachUnfreezeValue);
114     }
115 	
116 	modifier onlyOwner {
117         require(msg.sender == owner);
118         _;
119     }
120 
121     function transferOwnership(address newOwner) onlyOwner public {
122         if (newOwner != address(0)) {
123             owner = newOwner;
124         }
125     }
126 	
127 }