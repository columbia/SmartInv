1 pragma solidity 0.4.21;
2 
3 contract MeetOneTokenBase {
4     uint256                                            _supply;
5     mapping (address => uint256)                       _balances;
6     
7     event Transfer( address indexed from, address indexed to, uint256 value);
8 
9     function MeetOneTokenBase() public {    }
10     
11     function totalSupply() public view returns (uint256) {
12         return _supply;
13     }
14     function balanceOf(address src) public view returns (uint256) {
15         return _balances[src];
16     }
17     
18     function transfer(address dst, uint256 wad) public returns (bool) {
19         require(dst != address(0));
20         require(_balances[msg.sender] >= wad);
21         
22         _balances[msg.sender] = sub(_balances[msg.sender], wad);
23         _balances[dst] = add(_balances[dst], wad);
24         
25         emit Transfer(msg.sender, dst, wad);
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
43 contract MeetOneToken is MeetOneTokenBase {
44     string  public  symbol = "MEET.ONE";
45     string  public name = "MEET.ONE";
46     uint256  public  decimals = 18; 
47     uint256 public freezedValue = 25*(10**8)*(10**18);
48     uint256 public eachUnfreezeValue = 625000000*(10**18);
49     address public owner;
50 
51     struct FreezeStruct {
52         uint256 unfreezeTime;
53         bool freezed;
54     }
55 
56     FreezeStruct[] public unfreezeTimeMap;
57 
58     function MeetOneToken() public {
59         _supply = 100*(10**8)*(10**18);
60         _balances[0x01] = freezedValue;
61         _balances[msg.sender] = sub(_supply,freezedValue);
62         owner = msg.sender;
63 
64         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1559318400, freezed: true})); // JUN/01/2019
65         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1590940800, freezed: true})); // JUN/01/2020
66         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1622476800, freezed: true})); // JUN/01/2021
67         unfreezeTimeMap.push(FreezeStruct({unfreezeTime:1654012800, freezed: true})); // JUN/01/2022
68     }
69 
70     function transfer(address dst, uint256 wad) public returns (bool) {
71         return super.transfer(dst, wad);
72     }
73 
74     function unfreeze(uint256 i) public {
75         require(msg.sender == owner);
76         require(i>=0 && i<unfreezeTimeMap.length);
77         require(now >= unfreezeTimeMap[i].unfreezeTime && unfreezeTimeMap[i].freezed);
78         require(_balances[0x01] >= eachUnfreezeValue);
79 
80         _balances[0x01] = sub(_balances[0x01], eachUnfreezeValue);
81         _balances[owner] = add(_balances[owner], eachUnfreezeValue);
82 
83         freezedValue = sub(freezedValue, eachUnfreezeValue);
84         unfreezeTimeMap[i].freezed = false;
85 
86         emit Transfer(0x01, owner, eachUnfreezeValue);
87     }
88 }