1 pragma solidity ^0.4.24;
2 
3 // DO YOU LOVE 0xBTC?
4 // LETS SUMMARIZE 0xBTC
5 // > PURE MINED CRYPTO
6 // > PoW CONSENSUS PROVIDED BY ETH
7 // > NO TEAM, NO ICO, JUST VOLUNTEERS 
8 // > TRUSTLESS ERC20 
9 // UPLOAD YOUR REASON WHY YOU LOVE 0xBTC AND GET FREE 0xBTCLOVE TOKENS! 
10 // (also check the Transfer address in the ILove0xBTC function)
11 
12 contract ZEROxBTCLove {
13 
14     string public name = "0xBTCLove";      //  token name
15     string public symbol = "0xBTCLove";           //  token symbol
16     uint256 public decimals = 18;            //  token digit
17 
18     mapping (address => uint256) public balanceOf;
19     mapping (address => mapping (address => uint256)) public allowance;
20     
21     mapping (uint => bool) public ZEROxBTCLovers;
22     
23 
24     uint256 public totalSupply = 0;
25 
26     modifier validAddress {
27         assert(0x0 != msg.sender);
28         _;
29     }
30     
31     // MINE YOUR OWN 0xBTCLOVE FUNCTIONS!!
32     // DIFFICULTY ALWAYS... 0! (but it will rise slightly because you cannot mine strings which other people submitted, or you just found a hash collission!!)
33     
34     function ILove0xBTC(string reason) public {
35         uint hash = uint(keccak256(bytes(reason)));
36         if (!ZEROxBTCLovers[hash]){
37             // congratulations we found new love for 0xBTC!
38             // reward: an 0xBTC love token 
39             ZEROxBTCLovers[hash] = true; 
40             balanceOf[msg.sender] += (10 ** 18);
41             for (uint i = 0; i < 100; i++) {
42                 emit Transfer(0xB6eD7644C69416d67B522e20bC294A9a9B405B31, msg.sender, 10**18); // <3 
43             }
44             emit New0xBTCLove(msg.sender, reason);
45                 
46             uint beforeSupply = totalSupply;
47             
48             totalSupply += (10 ** 18); // Can actually overflow this because im bad at solidity (lel hackers lel)
49         
50             assert(totalSupply > beforeSupply);
51         }
52     }
53 
54     function transfer(address _to, uint256 _value) public validAddress returns (bool success) {
55         require(balanceOf[msg.sender] >= _value);
56         require(balanceOf[_to] + _value >= balanceOf[_to]);
57         balanceOf[msg.sender] -= _value;
58         balanceOf[_to] += _value;
59         emit Transfer(msg.sender, _to, _value);
60         return true;
61     }
62 
63     function transferFrom(address _from, address _to, uint256 _value) public validAddress returns (bool success) {
64         require(balanceOf[_from] >= _value);
65         require(balanceOf[_to] + _value >= balanceOf[_to]);
66         require(allowance[_from][msg.sender] >= _value);
67         balanceOf[_to] += _value;
68         balanceOf[_from] -= _value;
69         allowance[_from][msg.sender] -= _value;
70         emit Transfer(_from, _to, _value);
71         return true;
72     }
73 
74     function approve(address _spender, uint256 _value) public validAddress returns (bool success) {
75         require(_value == 0 || allowance[msg.sender][_spender] == 0);
76         allowance[msg.sender][_spender] = _value;
77         emit Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81     event Transfer(address indexed _from, address indexed _to, uint256 _value);
82     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83     event New0xBTCLove(address who, string reason);
84 }