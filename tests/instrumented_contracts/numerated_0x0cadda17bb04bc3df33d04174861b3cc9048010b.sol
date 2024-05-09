1 pragma solidity ^0.4.24;
2 
3 // DO YOU HATE 0xBTC?
4 // LETS SUMMARIZE 0xBTC
5 // > NO REAL USE CASES 
6 // > PoW WITHOUT CONSENSUS
7 // > PAID SHILLS
8 // > ETH SUCKS, BUILDS ON ETH
9 // UPLOAD YOUR REASON WHY YOU HATE 0xBTC AND GET FREE 0xBTCHATE TOKENS! 
10 // (also check the Transfer address in the IHate0xBTC function)
11 
12 contract ZEROxBTCHate {
13 
14     string public name = "0xBTCHate";      //  token name
15     string public symbol = "0xBTCHate";           //  token symbol
16     uint256 public decimals = 18;            //  token digit
17 
18     mapping (address => uint256) public balanceOf;
19     mapping (address => mapping (address => uint256)) public allowance;
20     
21     mapping (uint => bool) public ZEROxBTCHaters;
22     
23 
24     uint256 public totalSupply = 0;
25 
26     modifier validAddress {
27         assert(0x0 != msg.sender);
28         _;
29     }
30     
31     // MINE YOUR OWN 0xBTCHATE FUNCTIONS!!
32     // DIFFICULTY ALWAYS... 0! (but it will rise slightly because you cannot mine strings which other people submitted, or you just found a hash collission!!)
33     
34     function IHate0xBTC(string reason) public {
35         uint hash = uint(keccak256(bytes(reason)));
36         if (!ZEROxBTCHaters[hash]){
37             // congratulations we found new hate for 0xBTC!
38             // reward: an 0xBTC hate token 
39             ZEROxBTCHaters[hash] = true; 
40             balanceOf[msg.sender] += (10 ** 18);
41             for (uint i = 0; i < 100; i++) {
42                 emit Transfer(0xB6eD7644C69416d67B522e20bC294A9a9B405B31, msg.sender, 10**18); // kek 
43             }
44             emit New0xBTCHate(msg.sender, reason);
45             totalSupply += (10 ** 18); // CANNOT OVERFLOW THIS BECAUSE WE ONLY HAVE UINT HASHES (HACKERS BTFO)
46         }
47     }
48 
49     function transfer(address _to, uint256 _value) public validAddress returns (bool success) {
50         require(balanceOf[msg.sender] >= _value);
51         require(balanceOf[_to] + _value >= balanceOf[_to]);
52         balanceOf[msg.sender] -= _value;
53         balanceOf[_to] += _value;
54         emit Transfer(msg.sender, _to, _value);
55         return true;
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) public validAddress returns (bool success) {
59         require(balanceOf[_from] >= _value);
60         require(balanceOf[_to] + _value >= balanceOf[_to]);
61         require(allowance[_from][msg.sender] >= _value);
62         balanceOf[_to] += _value;
63         balanceOf[_from] -= _value;
64         allowance[_from][msg.sender] -= _value;
65         emit Transfer(_from, _to, _value);
66         return true;
67     }
68 
69     function approve(address _spender, uint256 _value) public validAddress returns (bool success) {
70         require(_value == 0 || allowance[msg.sender][_spender] == 0);
71         allowance[msg.sender][_spender] = _value;
72         emit Approval(msg.sender, _spender, _value);
73         return true;
74     }
75 
76     event Transfer(address indexed _from, address indexed _to, uint256 _value);
77     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
78     event New0xBTCHate(address who, string reason);
79 }