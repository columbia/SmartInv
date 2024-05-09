1 pragma solidity 0.5.9;
2 
3 contract DistributedEnergyCoinBase {
4     uint256                                            _supply;
5     mapping (address => uint256)                       _balances;
6     
7     event Transfer( address indexed from, address indexed to, uint256 value);
8     
9     function totalSupply() public view returns (uint256) {
10         return _supply;
11     }
12     function balanceOf(address src) public view returns (uint256) {
13         return _balances[src];
14     }
15     
16     function transfer(address dst, uint256 wad) public returns (bool) {
17         require(_balances[msg.sender] >= wad);
18         
19         _balances[msg.sender] = sub(_balances[msg.sender], wad);
20         _balances[dst] = add(_balances[dst], wad);
21         
22         emit Transfer(msg.sender, dst, wad);
23         
24         return true;
25     }
26     
27     function add(uint256 x, uint256 y) internal pure returns (uint256) {
28         uint256 z = x + y;
29         require(z >= x && z>=y);
30         return z;
31     }
32 
33     function sub(uint256 x, uint256 y) internal pure returns (uint256) {
34         uint256 z = x - y;
35         require(x >= y && z <= x);
36         return z;
37     }
38 }
39 
40 contract DistributedEnergyCoin is DistributedEnergyCoinBase {
41 
42     string  public  symbol = "DEC";
43     string  public name = "Distributed Energy Coin";
44     uint256  public  decimals = 8; 
45     uint256 public freezedValue = 38280000*(10**8);
46     address public owner;
47     address public freezeOwner = address(0x01);
48 
49     struct FreezeStruct {
50         uint256 unfreezeTime;   //时间
51         uint256 unfreezeValue;  //锁仓
52         bool freezed;
53     }
54 
55     FreezeStruct[] public unfreezeTimeMap;
56     
57     constructor() public{
58         _supply = 319000000*(10**8);
59         _balances[freezeOwner] = freezedValue;
60         _balances[msg.sender] = sub(_supply,freezedValue);
61         owner = msg.sender;
62 
63         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1586995200, unfreezeValue:9570000*(10**8), freezed: true})); // 2020-04-16
64         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1618531200, unfreezeValue:14355000*(10**8), freezed: true})); // 2021-04-16
65         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1650067200, unfreezeValue:14355000*(10**8), freezed: true})); // 2022-04-16
66     }
67 
68     function transfer(address dst, uint256 wad) public returns (bool) {
69         return super.transfer(dst, wad);
70     }
71 
72     function distribute(address dst, uint256 wad) public returns (bool) {
73         require(msg.sender == owner);
74 
75         return super.transfer(dst, wad);
76     }
77 
78     function unfreeze(uint256 i) public {
79         require(msg.sender == owner);
80         require(i>=0 && i<unfreezeTimeMap.length);
81         require(now >= unfreezeTimeMap[i].unfreezeTime && unfreezeTimeMap[i].freezed);
82         require(_balances[freezeOwner] >= unfreezeTimeMap[i].unfreezeValue);
83 
84         _balances[freezeOwner] = sub(_balances[freezeOwner], unfreezeTimeMap[i].unfreezeValue);
85         _balances[owner] = add(_balances[owner], unfreezeTimeMap[i].unfreezeValue);
86 
87         freezedValue = sub(freezedValue, unfreezeTimeMap[i].unfreezeValue);
88         unfreezeTimeMap[i].freezed = false;
89 
90         emit Transfer(freezeOwner, owner, unfreezeTimeMap[i].unfreezeValue);
91     }
92 }