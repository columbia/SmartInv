1 pragma solidity 0.4.20;
2 
3 contract IPXTokenBase {
4     uint256                                            _supply;
5     mapping (address => uint256)                       _balances;
6     
7     event Transfer( address indexed from, address indexed to, uint256 value);
8 
9     function IPXTokenBase() public {    }
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
42 contract IPXToken is IPXTokenBase {
43     string  public  symbol = "IPX";
44     string  public name = "InterPlanetary X";
45     uint256  public  decimals = 18; 
46     uint256 public freezedValue = 4*(10**8)*(10**18);
47     uint256 public eachUnfreezeValue = 4*(10**7)*(10**18);
48     address public owner;
49     address public freezeAddress;
50     bool public freezed;
51 
52     struct FreezeStruct {
53         uint256 unfreezeTime;
54         uint idx;
55     }
56 
57     FreezeStruct[] public unfreezeTimeMap;
58 
59     function IPXToken() public {
60         _supply = 2*(10**9)*(10**18);
61         _balances[msg.sender] = _supply;
62         owner = msg.sender;
63 
64         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1533052800, idx: 1})); // Aug/01/2018
65         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1535731200, idx: 2})); // Sep/01/2018
66         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1538323200, idx: 3})); // Oct/01/2018
67         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1541001600, idx: 4})); // Nov/01/2018
68         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1543593600, idx: 5})); // Dec/01/2018
69         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1546272000, idx: 6})); // Jan/01/2019
70         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1548950400, idx: 7})); // Feb/01/2019
71         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1551369600, idx: 8})); // Mar/01/2019
72         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1554048000, idx: 9})); // Apr/01/2019
73         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1556640000, idx: 10})); // May/01/2019
74     }
75 
76     function transfer(address dst, uint256 wad) public returns (bool) {
77         assert(checkFreezeValue(wad));
78         return super.transfer(dst, wad);
79     }
80 
81     function checkFreezeValue(uint256 wad) internal view returns(bool) {
82         if ( msg.sender == freezeAddress ) {
83             for ( uint i = 0; i<unfreezeTimeMap.length; i++ ) {
84                 uint idx = unfreezeTimeMap[i].idx;
85                 uint256 unfreezeTime = unfreezeTimeMap[i].unfreezeTime;
86                 if ( now<unfreezeTime ) {
87                     uint256 shouldFreezedValue = freezedValue - (idx-1)*eachUnfreezeValue;
88                     if (sub(_balances[msg.sender], wad) < shouldFreezedValue) {
89                         return false;
90                     }
91                 }
92             }
93         }
94         return true;
95     }
96 
97     function freeze(address freezeAddr) public returns (bool) {
98         require(msg.sender == owner);
99         require(freezed == false);
100         freezeAddress = freezeAddr;
101         freezed = true;
102         return super.transfer(freezeAddr, freezedValue);
103     }
104 }