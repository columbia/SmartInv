1 pragma solidity 0.5.9;
2 
3 contract DistributedEnergyCoinBase {
4     uint256                                            _supply;
5     mapping (address => uint256)                       _balances;
6     
7     event Transfer( address indexed from, address indexed to, uint256 value);
8 
9     constructor() public {    }
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
44     string  public  symbol = "CED";
45     string  public name = "CED Coin";
46     uint256  public  decimals = 8; 
47     uint256 public freezedValue = 38280000*(10**8);
48     uint256 public releaseTime = 1560902400; 
49     uint256 public latestReleaseTime = 1560902400; 
50     address public owner;
51     address public freezeOwner = address(0x01);
52 
53     struct FreezeStruct {
54         uint256 unfreezeTime;   //时间
55         uint256 unfreezeValue;  //冻结的数额
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
67         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1560927600, unfreezeValue:9570000*(10**8), freezed: true})); 
68         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1560928200, unfreezeValue:14355000*(10**8), freezed: true})); 
69         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1560928800, unfreezeValue:14355000*(10**8), freezed: true})); 
70     
71     }
72 
73 
74     function transfer(address dst, uint256 wad) public returns (bool) {
75         require (now >= releaseTime || now >= latestReleaseTime);
76 
77         return super.transfer(dst, wad);
78     }
79 
80     function distribute(address dst, uint256 wad) public returns (bool) {
81         require(msg.sender == owner);
82 
83         return super.transfer(dst, wad);
84     }
85 
86     function setRelease(uint256 _release) public {
87         require(msg.sender == owner);
88         require(_release <= latestReleaseTime);
89 
90         releaseTime = _release;
91     }
92 
93     function unfreeze(uint256 i) public {
94         require(msg.sender == owner);
95         require(i>=0 && i<unfreezeTimeMap.length);
96         require(now >= unfreezeTimeMap[i].unfreezeTime && unfreezeTimeMap[i].freezed);
97         require(_balances[freezeOwner] >= unfreezeTimeMap[i].unfreezeValue);
98 
99         _balances[freezeOwner] = sub(_balances[freezeOwner], unfreezeTimeMap[i].unfreezeValue);
100         _balances[owner] = add(_balances[owner], unfreezeTimeMap[i].unfreezeValue);
101 
102         freezedValue = sub(freezedValue, unfreezeTimeMap[i].unfreezeValue);
103         unfreezeTimeMap[i].freezed = false;
104 
105        emit Transfer(freezeOwner, owner, unfreezeTimeMap[i].unfreezeValue);
106     }
107 }