1 pragma solidity ^0.4.21;
2 
3 contract Lambo {
4 
5     string public name = "Lambo";      //  token name
6     string public symbol = "LAMBO";           //  token symbol
7     uint256 public decimals = 18;            //  token digit
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     uint256 public totalSupply = 0;
13 
14     address owner;
15 
16     modifier isOwner {
17         assert(owner == msg.sender);
18         _;
19     }
20 
21 
22 
23     modifier validAddress {
24         assert(0x0 != msg.sender);
25         _;
26     }
27 
28     function Lambo() public {
29         owner = msg.sender;
30         mint(owner);
31     }
32 
33     function transfer(address _to, uint256 _value) public validAddress returns (bool success) {
34         require(balanceOf[msg.sender] >= _value);
35         require(balanceOf[_to] + _value >= balanceOf[_to]);
36         balanceOf[msg.sender] -= _value;
37         balanceOf[_to] += _value;
38         emit Transfer(msg.sender, _to, _value);
39         return true;
40     }
41 
42     function transferFrom(address _from, address _to, uint256 _value) public validAddress returns (bool success) {
43         require(balanceOf[_from] >= _value);
44         require(balanceOf[_to] + _value >= balanceOf[_to]);
45         require(allowance[_from][msg.sender] >= _value);
46         balanceOf[_to] += _value;
47         balanceOf[_from] -= _value;
48         allowance[_from][msg.sender] -= _value;
49         emit Transfer(_from, _to, _value);
50         return true;
51     }
52 
53     function approve(address _spender, uint256 _value) public validAddress returns (bool success) {
54         require(_value == 0 || allowance[msg.sender][_spender] == 0);
55         allowance[msg.sender][_spender] = _value;
56         emit Approval(msg.sender, _spender, _value);
57         return true;
58     }
59 
60     // WTF you want to burn LAMBO!?
61     function burn(uint256 _value) public {
62         require(balanceOf[msg.sender] >= _value);
63         balanceOf[msg.sender] -= _value;
64         balanceOf[0x0] += _value;
65         emit Transfer(msg.sender, 0x0, _value);
66     }
67     
68     function mint(address who) public {
69         if (who == 0x0){
70             who = msg.sender;
71         }
72         require(balanceOf[who] == 0);
73         _mint(who, 1);
74     }
75     
76     function mintMore(address who) public payable{
77         if (who == 0x0){
78             who = msg.sender;
79         }
80         require(msg.value >= (1 finney));
81         _mint(who,3);
82         owner.transfer(msg.value);
83     }
84     
85     function _mint(address who, uint256 howmuch) internal {
86         balanceOf[who] = balanceOf[who] + howmuch * (10 ** decimals);
87         totalSupply = totalSupply + howmuch * (10 ** decimals);
88         emit Transfer(0x0, who, howmuch * (10 ** decimals));
89     }
90     
91 
92     event Transfer(address indexed _from, address indexed _to, uint256 _value);
93     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
94 }