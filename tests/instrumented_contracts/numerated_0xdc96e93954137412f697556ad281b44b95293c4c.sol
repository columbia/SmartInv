1 pragma solidity ^0.5.8;
2 
3 contract BK_Token {
4 
5     struct Event {
6         address event_address;
7         uint8 max_member;
8         uint8 member_count;
9     }
10 
11     //Basic Token Info
12     uint256 public constant totalSupply=1000000;
13     string public constant name = "BK_Token";
14     string public constant symbol = "BKT";
15     string public constant description = "A Peer to Peer Training Area For Investigators";
16     //Decimals are taken from the totalSupply (if i.e. 1000 totalSupply, with decimmals
17     //at 3, then the real supply is 1.000 tokens), so for no partial tokens, decimals must be 0
18     uint32 public constant decimals = 0;
19 
20     //Event related variables
21     Event[8] public Events;
22     address public coin_address;
23 
24     //Contract deployer address from constructor()
25     address public owner;
26 
27     event Transfer(
28         address indexed _from,
29         address indexed _to,
30         uint256 _value);
31 
32     event Approval(
33         address indexed _owner,
34         address indexed _spender,
35         uint256 _value);
36 
37     //ERC20 and individual mappings
38     mapping(address => uint256) public balanceOf;
39     mapping(address => mapping(address => uint256)) public allowance;
40     mapping(address => mapping(address => bool)) public event_mapping;
41     mapping(address => bool) public coin_purchased;
42 
43     //Modifier to allow some functions to be run only by the deployer of the contract
44     modifier onlyOwner() {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     constructor() public {
50         //balanceOf[_address]=totalSupply;
51         balanceOf[msg.sender]=totalSupply;
52 		owner = msg.sender;
53     }
54 
55     function transfer(address _to, uint256 _value) public returns (bool success){
56         require(_value <= balanceOf[msg.sender]);
57 
58         balanceOf[msg.sender] -= _value;
59         balanceOf[_to] += _value;
60 
61         emit Transfer(msg.sender, _to, _value);
62 
63         for (uint x=0;x < 8;x++) {
64             if (_to == Events[x].event_address) {
65                 if (_value == 1 && Events[x].member_count < Events[x].max_member && event_mapping[Events[x].event_address][msg.sender] == false) {
66                     event_mapping[Events[x].event_address][msg.sender] = true;
67                     Events[x].member_count += 1;
68                 }
69                 else {
70                     balanceOf[_to] -= _value;
71                     balanceOf[msg.sender] += _value;
72                 }
73             }
74         }
75 
76          if (_to == coin_address){
77             if (_value == 1 && coin_purchased[msg.sender] == false){
78                      coin_purchased[msg.sender] = true;
79                  }
80             else {
81              balanceOf[_to] -= _value;
82              balanceOf[msg.sender] += _value;
83              }
84          }
85 
86         return true;
87     }
88 
89     function approve(address _spender, uint256 _value) public returns (bool success){
90         allowance[msg.sender][_spender] = _value;
91         emit Approval(msg.sender, _spender, _value);
92         return true;
93     }
94 
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
96         require(_value <= balanceOf[_from]);
97         require(_value <= allowance[_from][msg.sender]);
98         balanceOf[_from] -= _value;
99         balanceOf[_to] += _value;
100         allowance[_from][msg.sender] -= _value;
101         emit Transfer(_from, _to, _value);
102         return true;
103     }
104     //Event creation only by contract owner (see modifier)
105     function create_event(uint8 _max_member, address _event_address, uint256 _pos) public onlyOwner {
106         Events[_pos].event_address = _event_address;
107         Events[_pos].max_member = _max_member;
108         Events[_pos].member_count = 0;
109     }
110 
111     //Coin address setting only by contract owner (see modifier)
112     function set_coin_address(address _coin_address) public onlyOwner {
113         coin_address = _coin_address;
114     }
115 
116 }