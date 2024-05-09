1 pragma solidity 0.4.20;
2 
3 contract TopTokenBase {
4     uint256                                            _supply;
5     mapping (address => uint256)                       _balances;
6     
7     event Transfer( address indexed from, address indexed to, uint256 value);
8 
9     function TopTokenBase() public {    }
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
42 contract TopToken is TopTokenBase {
43     string  public  symbol = "TOP";
44     string  public name = "Top.One Coin";
45     uint256  public  decimals = 18; 
46     uint256 public freezedValue = 640000000*(10**18);
47     uint256 public eachUnfreezeValue = 160000000*(10**18);
48     uint256 public releaseTime = 1525017600; 
49     uint256 public latestReleaseTime = 1525017600; // Apr/30/2018
50     address public owner;
51 
52     struct FreezeStruct {
53         uint256 unfreezeTime;
54         bool freezed;
55     }
56 
57     FreezeStruct[] public unfreezeTimeMap;
58 
59     function TopToken() public {
60         _supply = 20*(10**8)*(10**18);
61         _balances[0x01] = freezedValue;
62         _balances[msg.sender] = sub(_supply,freezedValue);
63         owner = msg.sender;
64 
65         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1554048000, freezed: true})); // Apr/01/2019
66         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1585670400, freezed: true})); // Apr/01/2020
67         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1617206400, freezed: true})); // Apr/01/2021
68         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1648742400, freezed: true})); // Apr/01/2022
69     }
70 
71     function transfer(address dst, uint256 wad) public returns (bool) {
72         require (now >= releaseTime || now >= latestReleaseTime);
73 
74         return super.transfer(dst, wad);
75     }
76 
77     function distribute(address dst, uint256 wad) public returns (bool) {
78         require(msg.sender == owner);
79 
80         return super.transfer(dst, wad);
81     }
82 
83     function setRelease(uint256 _release) public {
84         require(msg.sender == owner);
85         require(_release <= latestReleaseTime);
86 
87         releaseTime = _release;
88     }
89 
90     function unfreeze(uint256 i) public {
91         require(msg.sender == owner);
92         require(i>=0 && i<unfreezeTimeMap.length);
93         require(now >= unfreezeTimeMap[i].unfreezeTime && unfreezeTimeMap[i].freezed);
94         require(_balances[0x01] >= eachUnfreezeValue);
95 
96         _balances[0x01] = sub(_balances[0x01], eachUnfreezeValue);
97         _balances[owner] = add(_balances[owner], eachUnfreezeValue);
98 
99         freezedValue = sub(freezedValue, eachUnfreezeValue);
100         unfreezeTimeMap[i].freezed = false;
101 
102         Transfer(0x01, owner, eachUnfreezeValue);
103     }
104 }