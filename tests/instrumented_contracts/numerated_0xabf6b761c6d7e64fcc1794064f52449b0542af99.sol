1 pragma solidity ^0.4.18;
2 
3 contract MeetTokenBase {
4     uint256                                            _supply;
5     mapping (address => uint256)                       _balances;
6     mapping (address => mapping (address => uint256))  _approvals;
7     
8     event Transfer( address indexed from, address indexed to, uint value);
9     event Approval( address indexed owner, address indexed spender, uint value);
10 
11     function MeetTokenBase() public {
12         
13     }
14     
15     function totalSupply() public view returns (uint256) {
16         return _supply;
17     }
18     function balanceOf(address src) public view returns (uint256) {
19         return _balances[src];
20     }
21     function allowance(address src, address guy) public view returns (uint256) {
22         return _approvals[src][guy];
23     }
24     
25     function transfer(address dst, uint wad) public returns (bool) {
26         assert(_balances[msg.sender] >= wad);
27         
28         _balances[msg.sender] = sub(_balances[msg.sender], wad);
29         _balances[dst] = add(_balances[dst], wad);
30         
31         Transfer(msg.sender, dst, wad);
32         
33         return true;
34     }
35     
36     function transferFrom(address src, address dst, uint wad) public returns (bool) {
37         assert(_balances[src] >= wad);
38         assert(_approvals[src][msg.sender] >= wad);
39         
40         _balances[src] = sub(_balances[src], wad);
41         _balances[dst] = add(_balances[dst], wad);
42         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
43 
44         Transfer(src, dst, wad);
45         
46         return true;
47     }
48 
49     function approve(address guy, uint256 wad) public returns (bool) {
50         _approvals[msg.sender][guy] = wad;
51         
52         Approval(msg.sender, guy, wad);
53         
54         return true;
55     }
56 
57     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
58         assert((z = x + y) >= x);
59     }
60 
61     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
62         assert((z = x - y) <= x);
63     }
64 }
65 
66 contract MeetToken is MeetTokenBase {
67     string  public  symbol = "MEET";
68     string  public name = "MeetOne Coin";
69     uint256  public  decimals = 18; 
70     address public owner;
71 
72     function MeetToken() public {
73         _supply = 10*(10**8)*(10**18);
74         owner = msg.sender;
75         _balances[msg.sender] = _supply;
76     }
77 
78     function transfer(address dst, uint wad) public returns (bool) {
79         return super.transfer(dst, wad);
80     }
81 
82     function transferFrom( address src, address dst, uint wad ) public returns (bool) {
83         return super.transferFrom(src, dst, wad);
84     }
85 
86     function approve(address guy, uint wad) public returns (bool) {
87         return super.approve(guy, wad);
88     }
89 
90     function burn(uint128 wad) public {
91         require(msg.sender==owner);
92         _balances[msg.sender] = sub(_balances[msg.sender], wad);
93         _supply = sub(_supply, wad);
94     }
95 }