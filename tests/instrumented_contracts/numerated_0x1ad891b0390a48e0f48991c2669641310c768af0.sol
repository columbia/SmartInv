1 pragma solidity 0.4.20;
2 
3 contract nistTokenBase {
4     uint256                                            _supply;
5     mapping (address => uint256)                       _balances;
6     
7     event Transfer( address indexed from, address indexed to, uint256 value);
8 
9     function nistTokenBase() public {    }
10     
11     function totalSupply() public view returns (uint256) {
12         return _supply;
13     }
14     function balanceOf(address src) public view returns (uint256) {
15         return _balances[src];
16     }
17     
18     
19     function transfer(address dst, uint256 wad) public returns (bool) {
20         require(_balances[msg.sender] >= wad);
21         
22         _balances[msg.sender] = sub(_balances[msg.sender], wad);
23         _balances[dst] = add(_balances[dst], wad);
24         
25         Transfer(msg.sender, dst, wad);
26         
27         return true;
28     }
29     
30     function add(uint256 x, uint256 y) internal pure returns (uint256) {
31         uint256 z = x + y;
32         require(z >= x && z>=y);
33         return z;
34     }
35 
36     function sub(uint256 x, uint256 y) internal pure returns (uint256) {
37         uint256 z = x - y;
38         require(x >= y && z <= x);
39         return z;
40     }
41 }
42 
43 contract nistToken is nistTokenBase {
44     string  public  symbol = "nist";
45     string  public name = "NIST";
46     uint256  public  decimals = 18; 
47     uint256 public freezedValue = 640000000*(10**18);
48     uint256 public eachUnfreezeValue = 160000000*(10**18);
49     uint256 public releaseTime = 1543800600; 
50     uint256 public latestReleaseTime = 1543800600; // Apr/30/2018
51     address public owner;
52 
53     struct FreezeStruct {
54         uint256 unfreezeTime;
55         bool freezed;
56     }
57 
58     FreezeStruct[] public unfreezeTimeMap;
59     
60     
61     modifier onlyOwner {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     function transferOwnership(address newOwner) onlyOwner public {
67         if (newOwner != address(0)) {
68             owner = newOwner;
69         }
70     }
71 
72     function nistToken() public {
73         _supply = 20*(10**8)*(10**18);
74         _balances[0x01] = freezedValue;
75         _balances[msg.sender] = sub(_supply,freezedValue);
76         owner = msg.sender;
77 
78         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1543804200, freezed: true})); // 2018/11/28 22:15:00
79         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1543805300, freezed: true})); // 2018/11/28 22:25:00
80         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1543806400, freezed: true})); // 2018/11/28 22:30:00
81         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1543807500, freezed: true})); // 2018/11/28 22:30:10
82     }
83 
84     function transfer(address dst, uint256 wad) public returns (bool) {
85         require (now >= releaseTime || now >= latestReleaseTime);
86 
87         return super.transfer(dst, wad);
88     }
89 
90     function distribute(address dst, uint256 wad) public returns (bool) {
91         require(msg.sender == owner);
92 
93         return super.transfer(dst, wad);
94     }
95 
96     function setRelease(uint256 _release) public {
97         require(msg.sender == owner);
98         require(_release <= latestReleaseTime);
99 
100         releaseTime = _release;
101     }
102 
103     function unfreeze(uint256 i) public {
104         require(msg.sender == owner);
105         require(i>=0 && i<unfreezeTimeMap.length);
106         require(now >= unfreezeTimeMap[i].unfreezeTime && unfreezeTimeMap[i].freezed);
107         require(_balances[0x01] >= eachUnfreezeValue);
108 
109         _balances[0x01] = sub(_balances[0x01], eachUnfreezeValue);
110         _balances[owner] = add(_balances[owner], eachUnfreezeValue);
111 
112         freezedValue = sub(freezedValue, eachUnfreezeValue);
113         unfreezeTimeMap[i].freezed = false;
114 
115         Transfer(0x01, owner, eachUnfreezeValue);
116     }
117 }