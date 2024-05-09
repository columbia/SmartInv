1 pragma solidity ^0.5.1;
2 
3 contract Owned {
4     modifier onlyOwner() {
5         require(msg.sender==owner);
6         _;
7     }
8     address payable owner;
9     address payable newOwner;
10     function changeOwner(address payable _newOwner) public onlyOwner {
11         newOwner=_newOwner;
12     }
13     function acceptOwnership() public {
14         if (msg.sender==newOwner) {
15             owner=newOwner;
16         }
17     }
18 }
19 
20 contract ERC20 {
21     function balanceOf(address _owner) view public returns (uint256 balance);
22     function transfer(address _to, uint256 _value) public returns (bool success);
23 }
24 
25 contract SmartWebLock is Owned{
26     string public domain;
27     uint8 public fee;
28     uint256 public unlock;
29     uint8 public bonus;
30     address public token;
31     uint8 public tokens;
32     address payable payee;
33     mapping (address=>uint) unlocks;
34     mapping (address=>address payable) refs;
35     mapping (address=>uint256) balances;
36     event Bonus(address indexed _user, uint256 _amount);
37         
38     constructor() public{
39         domain = 'videoblog.io';
40         fee = 2;
41         unlock = 100000000000000000;
42         bonus = 49;
43         token = 0xCD8aAC9972dc4Ddc48d700bc0710C0f5223fBCfa;
44         tokens = 100;
45         payee = 0x574c4DB1E399859753A09D65b6C5586429663701;
46         owner = msg.sender;
47     }
48     
49     function changeTokens (uint8 _tokens) public returns (bool success){
50         require(_tokens>0 && msg.sender==payee);
51         tokens=_tokens;
52         return true;
53     }
54     
55     function changeBonus (uint8 _bonus) public returns (bool success){
56         require (_bonus>0 && _bonus<100-fee && msg.sender==payee);
57         bonus=_bonus;
58         return true;
59     }
60     
61     function changeUnlock(uint256 _unlock) public returns (bool success){
62         require(_unlock>0 && msg.sender==payee);
63         unlock = _unlock;
64         return true;
65     }
66     
67     function changeRef(address _user, address payable _ref) public returns (bool success){
68         require(_ref!=address(0x0) && refs[_user]!=_ref && msg.sender==payee);
69         refs[_user] = _ref;
70         return true;
71     }
72     
73     function changeFee (uint8 _fee) onlyOwner public returns (bool success){
74         require (_fee>0 && _fee<10);
75         fee=_fee;
76         return true;
77     }
78     
79     function setRef(address payable _ref) public returns (bool success){
80         require (_ref!=address(0x0) && refs[msg.sender]==address(0x0) && _ref!=msg.sender);
81         refs[msg.sender] = _ref;
82         return true;
83     }
84     
85     function getBalance(address _user) view public returns (uint256 balance){
86         return balances[_user];
87     }
88     
89     function getUnlock(address _user) view public returns (uint timestamp){
90         return unlocks[_user];
91     }
92     
93     function getRef(address _user) view public returns (address ref){
94         return refs[_user];
95     }
96     
97     function unLock(uint256 _amount) private{
98         balances[msg.sender]+=_amount;
99         if (balances[msg.sender]>=unlock) {
100             unlocks[msg.sender] = block.timestamp;
101             uint256 payout = 0;
102             if (refs[msg.sender]!=address(0x0) && bonus>0) {
103                 payout = bonus*_amount/100;
104                 refs[msg.sender].transfer(payout);
105                 emit Bonus(refs[msg.sender],payout);
106             }
107             uint256 deduct = _amount*fee/100;
108             owner.transfer(deduct);
109             payee.transfer(_amount-payout-deduct);
110             if (ERC20(token).balanceOf(address(this))>=tokens) ERC20(token).transfer(msg.sender, tokens);
111         }
112     }
113     
114     function () payable external {
115         require(msg.value>0);
116         unLock(msg.value);
117     }
118 }