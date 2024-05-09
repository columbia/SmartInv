1 pragma solidity ^0.4.18;
2 
3 contract TopTokenBase {
4     uint256                                            _supply;
5     mapping (address => uint256)                       _balances;
6     mapping (address => mapping (address => uint256))  _approvals;
7     
8     event Transfer( address indexed from, address indexed to, uint value);
9     event Approval( address indexed owner, address indexed spender, uint value);
10 
11     function TopTokenBase() public {
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
38         
39         _balances[src] = sub(_balances[src], wad);
40         _balances[dst] = add(_balances[dst], wad);
41         
42         Transfer(src, dst, wad);
43         
44         return true;
45     }
46 
47     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
48         assert((z = x + y) >= x);
49     }
50 
51     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
52         assert((z = x - y) <= x);
53     }
54 }
55 
56 contract TopToken is TopTokenBase {
57     string  public  symbol = "TOP";
58     string  public name = "Top.One Coin";
59     uint256  public  decimals = 18; 
60     uint public releaseTime = 1548518400;
61     address public owner;
62 
63     function TopToken() public {
64         _supply = 20*(10**8)*(10**18);
65         owner = msg.sender;
66         _balances[msg.sender] = _supply;
67     }
68 
69     function transfer(address dst, uint wad) public returns (bool) {
70         require (now >= releaseTime);
71         return super.transfer(dst, wad);
72     }
73 
74     function transferFrom( address src, address dst, uint wad ) public returns (bool) {
75         return super.transferFrom(src, dst, wad);
76     }
77 
78     function distribute(address dst, uint wad) public returns (bool) {
79         require(msg.sender == owner);
80         return super.transfer(dst, wad);
81     }
82 
83     function burn(uint128 wad) public {
84         require(msg.sender==owner);
85         _balances[msg.sender] = sub(_balances[msg.sender], wad);
86         _supply = sub(_supply, wad);
87     }
88 
89     function setRelease(uint _release) public {
90         require(msg.sender == owner);
91         releaseTime = _release;
92     }
93 
94 }