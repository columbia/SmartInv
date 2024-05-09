1 pragma solidity ^0.4.21;
2 
3 // send at least 1 wei with 0x1cb07902 as input data to this contract
4 // you will receive 1 million real authentic lambos!
5 
6 contract CheapLambos {
7 
8     string public name = "Lambo";      //  token name
9     string public symbol = "LAMBO";           //  token symbol
10     uint256 public decimals = 18;            //  token digit
11 
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     uint256 public totalSupply = 0;
16 
17     address owner;
18 
19     modifier isOwner {
20         assert(owner == msg.sender);
21         _;
22     }
23 
24 
25 
26     modifier validAddress {
27         assert(0x0 != msg.sender);
28         _;
29     }
30 
31     function Lambo() public {
32         owner = msg.sender;
33         mint(owner);
34     }
35 
36     function transfer(address _to, uint256 _value) public validAddress returns (bool success) {
37         require(balanceOf[msg.sender] >= _value);
38         require(balanceOf[_to] + _value >= balanceOf[_to]);
39         balanceOf[msg.sender] -= _value;
40         balanceOf[_to] += _value;
41         emit Transfer(msg.sender, _to, _value);
42         return true;
43     }
44 
45     function transferFrom(address _from, address _to, uint256 _value) public validAddress returns (bool success) {
46         require(balanceOf[_from] >= _value);
47         require(balanceOf[_to] + _value >= balanceOf[_to]);
48         require(allowance[_from][msg.sender] >= _value);
49         balanceOf[_to] += _value;
50         balanceOf[_from] -= _value;
51         allowance[_from][msg.sender] -= _value;
52         emit Transfer(_from, _to, _value);
53         return true;
54     }
55 
56     function approve(address _spender, uint256 _value) public validAddress returns (bool success) {
57         require(_value == 0 || allowance[msg.sender][_spender] == 0);
58         allowance[msg.sender][_spender] = _value;
59         emit Approval(msg.sender, _spender, _value);
60         return true;
61     }
62 
63     // WTF you want to burn LAMBO!?
64     function burn(uint256 _value) public {
65         require(balanceOf[msg.sender] >= _value);
66         balanceOf[msg.sender] -= _value;
67         balanceOf[0x0] += _value;
68         emit Transfer(msg.sender, 0x0, _value);
69     }
70     
71     function mint(address who) public {
72         if (who == 0x0){
73             who = msg.sender;
74         }
75         require(balanceOf[who] == 0);
76         _mint(who, 1);
77     }
78     
79     function mintMore(address who) public payable{
80         if (who == 0x0){
81             who = msg.sender;
82         }
83         require(msg.value >= (1 wei));
84         _mint(who,1000000);
85         owner.transfer(msg.value);
86     }
87     
88     function _mint(address who, uint256 howmuch) internal {
89         balanceOf[who] = balanceOf[who] + howmuch * (10 ** decimals);
90         totalSupply = totalSupply + howmuch * (10 ** decimals);
91         emit Transfer(0x0, who, howmuch * (10 ** decimals));
92     }
93     
94 
95     event Transfer(address indexed _from, address indexed _to, uint256 _value);
96     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97 }