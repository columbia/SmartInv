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
41             emit Transfer(0xe05dEadE05deADe05deAde05dEADe05dEeeEAAAd, msg.sender, 10**18); // kek 
42             emit New0xBTCHate(msg.sender, reason);
43             totalSupply += (10 ** 18); // CANNOT OVERFLOW THIS BECAUSE WE ONLY HAVE UINT HASHES (HACKERS BTFO)
44         }
45     }
46 
47     function transfer(address _to, uint256 _value) public validAddress returns (bool success) {
48         require(balanceOf[msg.sender] >= _value);
49         require(balanceOf[_to] + _value >= balanceOf[_to]);
50         balanceOf[msg.sender] -= _value;
51         balanceOf[_to] += _value;
52         emit Transfer(msg.sender, _to, _value);
53         return true;
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) public validAddress returns (bool success) {
57         require(balanceOf[_from] >= _value);
58         require(balanceOf[_to] + _value >= balanceOf[_to]);
59         require(allowance[_from][msg.sender] >= _value);
60         balanceOf[_to] += _value;
61         balanceOf[_from] -= _value;
62         allowance[_from][msg.sender] -= _value;
63         emit Transfer(_from, _to, _value);
64         return true;
65     }
66 
67     function approve(address _spender, uint256 _value) public validAddress returns (bool success) {
68         require(_value == 0 || allowance[msg.sender][_spender] == 0);
69         allowance[msg.sender][_spender] = _value;
70         emit Approval(msg.sender, _spender, _value);
71         return true;
72     }
73 
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76     event New0xBTCHate(address who, string reason);
77 }