1 pragma solidity ^0.4.11;
2 
3 contract KittyClub99 {
4 
5 // The purpose of Kitty Club is to acknowledge all of the
6 // OG bad-asses who helped CK survive/grow during its infancy
7 
8 // Without you, CK wouldn't be where it is today
9 // The CAT coin will be sent to community heroes, influential players, developers, etc
10 // Only 99 CAT coins will ever be minted
11 
12 // You can not buy your way into the initial invitation of Kitty Club. You must be invited.
13 // Years in the future, we will know what path CK has taken. Assuming CK becomes a worldwide sensation,
14 // CAT coin could signify Kitty Club membership and may be required for entrance into exclusive yacht parties...who knows?
15 
16 // Your initial invitation CAT coin is 100% yours. Feel free to sell it, gift it, send to 0x00
17 // Know that if you do any of these things, you will not be reinvited
18 // As of 11/11/2018, this is a silly project. If CK doesn't succeed, it will be an utterly meaningless token.
19 // If it does succeed however... See you in the Maldives ;)
20 
21 
22     string public name = "Kitty Club est. 11/11/2018";      //  token name
23     string public symbol = "CAT";           //  token symbol
24     uint256 public decimals = 0;            //  token digit
25 
26     mapping (address => uint256) public balanceOf;
27     mapping (address => mapping (address => uint256)) public allowance;
28 
29     uint256 public totalSupply = 0;
30     bool public stopped = false;
31 
32     uint256 constant valueFounder = 99;  // rarer than founders!
33     address owner = 0x0;
34 
35     modifier isOwner {
36         assert(owner == msg.sender);
37         _;
38     }
39 
40     modifier isRunning {
41         assert (!stopped);
42         _;
43     }
44 
45     modifier validAddress {
46         assert(0x0 != msg.sender);
47         _;
48     }
49 
50     function KittyClub99(address _addressFounder) {
51         owner = msg.sender;
52         totalSupply = valueFounder;
53         balanceOf[_addressFounder] = valueFounder;
54         Transfer(0x0, _addressFounder, valueFounder);
55     }
56 
57     function transfer(address _to, uint256 _value) isRunning validAddress returns (bool success) {
58         require(balanceOf[msg.sender] >= _value);
59         require(balanceOf[_to] + _value >= balanceOf[_to]);
60         balanceOf[msg.sender] -= _value;
61         balanceOf[_to] += _value;
62         Transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) isRunning validAddress returns (bool success) {
67         require(balanceOf[_from] >= _value);
68         require(balanceOf[_to] + _value >= balanceOf[_to]);
69         require(allowance[_from][msg.sender] >= _value);
70         balanceOf[_to] += _value;
71         balanceOf[_from] -= _value;
72         allowance[_from][msg.sender] -= _value;
73         Transfer(_from, _to, _value);
74         return true;
75     }
76 
77     function approve(address _spender, uint256 _value) isRunning validAddress returns (bool success) {
78         require(_value == 0 || allowance[msg.sender][_spender] == 0);
79         allowance[msg.sender][_spender] = _value;
80         Approval(msg.sender, _spender, _value);
81         return true;
82     }
83 
84     function stop() isOwner {
85         stopped = true;
86     }
87 
88     function start() isOwner {
89         stopped = false;
90     }
91 
92     function setName(string _name) isOwner {
93         name = _name;
94     }
95 
96     function burn(uint256 _value) {
97         require(balanceOf[msg.sender] >= _value);
98         balanceOf[msg.sender] -= _value;
99         balanceOf[0x0] += _value;
100         Transfer(msg.sender, 0x0, _value);
101     }
102 
103     event Transfer(address indexed _from, address indexed _to, uint256 _value);
104     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
105 }