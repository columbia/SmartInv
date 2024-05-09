1 pragma solidity 0.5.9;
2 
3 contract DistributedEnergyCoinBase {
4     uint256                                            _supply;
5     mapping (address => uint256)                       _balances;
6     
7     event Transfer( address indexed from, address indexed to, uint256 value);
8 
9     constructor() public {}
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
24         emit Transfer(msg.sender, dst, wad);
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
42 contract DistributedEnergyCoin is DistributedEnergyCoinBase {
43 
44     string  public  symbol = "EDC";
45     string  public name = "EDC Coin";
46     uint256  public  decimals = 8; 
47     uint256 public freezedValue = 38280000*(10**8);
48     uint256 public releaseTime = 1560902400; 
49     uint256 public latestReleaseTime = 1560902400; // 2019-06-19
50     address public owner;
51     address public freezeOwner = address(0x01);
52 
53     struct FreezeStruct {
54         uint256 unfreezeTime;   //时间
55         uint256 unfreezeValue;  //锁仓
56         bool freezed;
57     }
58 
59     FreezeStruct[] public unfreezeTimeMap;
60     
61     constructor() public{
62         _supply = 319000000*(10**8);
63         _balances[freezeOwner] = freezedValue;
64         _balances[msg.sender] = sub(_supply,freezedValue);
65         owner = msg.sender;
66 
67         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1586995200, unfreezeValue:9570000*(10**8), freezed: true})); // 2020-04-16
68         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1618531200, unfreezeValue:14355000*(10**8), freezed: true})); // 2021-04-16
69         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1650067200, unfreezeValue:14355000*(10**8), freezed: true})); // 2022-04-16
70     }
71 
72     function transfer(address dst, uint256 wad) public returns (bool) {
73         require (now >= releaseTime || now >= latestReleaseTime);
74 
75         return super.transfer(dst, wad);
76     }
77 
78     function distribute(address dst, uint256 wad) public returns (bool) {
79         require(msg.sender == owner);
80 
81         return super.transfer(dst, wad);
82     }
83 
84     function setRelease(uint256 _release) public {
85         require(msg.sender == owner);
86         require(_release <= latestReleaseTime);
87 
88         releaseTime = _release;
89     }
90 
91     function unfreeze(uint256 i) public {
92         require(msg.sender == owner);
93         require(i>=0 && i<unfreezeTimeMap.length);
94         require(now >= unfreezeTimeMap[i].unfreezeTime && unfreezeTimeMap[i].freezed);
95         require(_balances[freezeOwner] >= unfreezeTimeMap[i].unfreezeValue);
96 
97         _balances[freezeOwner] = sub(_balances[freezeOwner], unfreezeTimeMap[i].unfreezeValue);
98         _balances[owner] = add(_balances[owner], unfreezeTimeMap[i].unfreezeValue);
99 
100         freezedValue = sub(freezedValue, unfreezeTimeMap[i].unfreezeValue);
101         unfreezeTimeMap[i].freezed = false;
102 
103         emit Transfer(freezeOwner, owner, unfreezeTimeMap[i].unfreezeValue);
104     }
105 }