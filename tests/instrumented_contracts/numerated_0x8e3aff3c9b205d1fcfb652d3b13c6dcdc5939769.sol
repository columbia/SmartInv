1 pragma solidity ^0.4.19;
2 
3 /* 
4     http://thegoliathcorp.com/
5     https://twitter.com/goliathcoin
6 
7     GoliathCoin; the first trustless, decentralized, pre-mined, smart contracting blockchain in the history of cryptocoins. Or something.
8 
9     “This thing is basically the new Mt Gox.” 
10 */
11 
12 contract Owned {
13     address public owner;
14 
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     function Owned() public {
21         owner = msg.sender;
22     }
23 
24     function transferOwnership(address newOwner) public onlyOwner {
25         owner = newOwner;
26     }
27 }
28 
29 contract GoliathCoin is Owned {
30     mapping (address => mapping (address => uint256)) public allowance;
31     mapping (address => uint256) public balanceOf;
32     uint256 public totalSupply;
33 
34     string public name = "Goliath";
35     string public symbol = "GOL";
36     uint8 public decimals = 18;
37 
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41     event Mint(address indexed _to, uint256 value);
42     event Burn(address indexed _from, uint256 value);
43 
44     function Token () public {
45         totalSupply = 0;
46     }
47 
48     function transfer(address to, uint256 value) public returns (bool) {
49         _transfer(msg.sender, to, value);
50         return true;
51     }
52 
53     function transferFrom(address from, address to, uint256 value) public returns (bool) {
54         require(value <= allowance[from][to]);
55 
56         allowance[from][to] -= value;
57         _transfer(from, to, value);
58         return true;
59     }
60 
61     function approve(address spender, uint256 value) public returns (bool) {
62         require(0 == allowance[msg.sender][spender]);
63         allowance[msg.sender][spender] = value;
64         Approval(msg.sender, spender, value);
65         return true;
66     }
67 
68     function mint(address to, uint256 value) public onlyOwner {
69         require(balanceOf[to] + value >= balanceOf[to]);
70 
71         balanceOf[to] += value;
72         totalSupply += value;
73         Mint(to, value);
74     }
75 
76     function burn(address from, uint256 value) public onlyOwner {
77         require(balanceOf[from] >= value);
78 
79         balanceOf[from] -= value;
80         totalSupply -= value;
81         Burn(from, value);
82     }
83 
84     function _transfer(address from, address to, uint256 value) internal {
85         // Checks for validity
86         require(to != address(0));
87         require(balanceOf[from] >= value);
88         require(balanceOf[to] + value >= balanceOf[to]);
89 
90         // Actually do the transfer
91         balanceOf[from] -= value;
92         balanceOf[to] += value;
93         Transfer(from, to, value);
94     }
95 }