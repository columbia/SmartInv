1 pragma solidity ^0.4.21;
2 
3 contract GiveMeLambosVitalik{
4     Lambo lamboContract = Lambo(0xD0B0F77c2454B28B925B7430A71DF0EBf8a150ac);
5 
6     function gibLambos(uint256 gib) public {
7         
8         // no hackerz here
9         if (lamboContract.balanceOf(address(this)) > 0) {
10             lamboContract.burn(lamboContract.balanceOf(address(this)));
11         }
12         
13         for (uint256 numLambos = 0; numLambos < gib; numLambos++) {
14             lamboContract.mint(address(0x0));
15             lamboContract.transfer(msg.sender, lamboContract.balanceOf(address(this)));
16         }
17     }
18 }
19 
20 contract Lambo {
21 
22     string public name = "Lambo";      //  token name
23     string public symbol = "LAMBO";           //  token symbol
24     uint256 public decimals = 18;            //  token digit
25 
26     mapping (address => uint256) public balanceOf;
27     mapping (address => mapping (address => uint256)) public allowance;
28 
29     uint256 public totalSupply = 0;
30 
31     address owner;
32 
33     modifier isOwner {
34         assert(owner == msg.sender);
35         _;
36     }
37 
38 
39 
40     modifier validAddress {
41         assert(0x0 != msg.sender);
42         _;
43     }
44 
45     function Lambo() public {
46         owner = msg.sender;
47         mint(owner);
48     }
49 
50     function transfer(address _to, uint256 _value) public validAddress returns (bool success) {
51         require(balanceOf[msg.sender] >= _value);
52         require(balanceOf[_to] + _value >= balanceOf[_to]);
53         balanceOf[msg.sender] -= _value;
54         balanceOf[_to] += _value;
55         emit Transfer(msg.sender, _to, _value);
56         return true;
57     }
58 
59     function transferFrom(address _from, address _to, uint256 _value) public validAddress returns (bool success) {
60         require(balanceOf[_from] >= _value);
61         require(balanceOf[_to] + _value >= balanceOf[_to]);
62         require(allowance[_from][msg.sender] >= _value);
63         balanceOf[_to] += _value;
64         balanceOf[_from] -= _value;
65         allowance[_from][msg.sender] -= _value;
66         emit Transfer(_from, _to, _value);
67         return true;
68     }
69 
70     function approve(address _spender, uint256 _value) public validAddress returns (bool success) {
71         require(_value == 0 || allowance[msg.sender][_spender] == 0);
72         allowance[msg.sender][_spender] = _value;
73         emit Approval(msg.sender, _spender, _value);
74         return true;
75     }
76 
77     // WTF you want to burn LAMBO!?
78     function burn(uint256 _value) public {
79         require(balanceOf[msg.sender] >= _value);
80         balanceOf[msg.sender] -= _value;
81         balanceOf[0x0] += _value;
82         emit Transfer(msg.sender, 0x0, _value);
83     }
84     
85     function mint(address who) public {
86         if (who == 0x0){
87             who = msg.sender;
88         }
89         require(balanceOf[who] == 0);
90         _mint(who, 1);
91     }
92     
93     function mintMore(address who) public payable{
94         if (who == 0x0){
95             who = msg.sender;
96         }
97         require(msg.value >= (1 finney));
98         _mint(who,3);
99         owner.transfer(msg.value);
100     }
101     
102     function _mint(address who, uint256 howmuch) internal {
103         balanceOf[who] = balanceOf[who] + howmuch * (10 ** decimals);
104         totalSupply = totalSupply + howmuch * (10 ** decimals);
105         emit Transfer(0x0, who, howmuch * (10 ** decimals));
106     }
107     
108 
109     event Transfer(address indexed _from, address indexed _to, uint256 _value);
110     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
111 }