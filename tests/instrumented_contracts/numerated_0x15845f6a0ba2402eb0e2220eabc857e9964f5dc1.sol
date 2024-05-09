1 pragma solidity >=0.5.0 <0.6.0;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract TokenVesting {
11     event Released(uint256 amount);
12     event Revoked();
13     event AddPartner(address _partner);
14     event RevokeVoting(bool _revokecable);
15     
16     address public beneficiary;
17     uint256 public times;
18     uint256 public releaseStart;
19     uint256 public interval;
20     
21     address public owner;
22 
23     mapping (address => uint256) public released;
24     mapping (address => uint256) public revoked;
25 
26     struct RevokeVote{
27         address partner;
28         bool vote;
29     }
30 
31     mapping (address => RevokeVote) partnerRevokeVote;
32     
33     uint256 public partnerCount = 0;
34     uint256 public voteAgreeCount = 0;
35     
36     constructor(address _beneficiary,  uint256 _times, uint256 _releaseStart, uint256 _interval, address[5] memory _partners) public {
37         require(_beneficiary != address(0));
38         require(_releaseStart > now);
39         require(_times > 0);
40         require(_interval > 0);
41         
42         beneficiary = _beneficiary;
43         times = _times;
44         releaseStart = _releaseStart;
45         interval = _interval;
46         
47         owner = msg.sender;
48         
49         for(uint i=0;i<_partners.length;i++){
50             addPartner(_partners[i]);
51         }
52     }
53 
54     function addPartner(address _partner) private {
55         require(_partner != address(0));
56         if(partnerRevokeVote[_partner].partner != _partner){
57             partnerRevokeVote[_partner] = RevokeVote({
58                 partner : _partner,
59                 vote : false
60             });
61             partnerCount++;
62         }
63         // emit AddPartner(_partner);
64     }
65 
66     function revokeVoting(bool _revokecable) public {
67         require(isPartners(msg.sender));
68         bool revokeVoted = partnerRevokeVote[msg.sender].vote;
69         if(revokeVoted != _revokecable){
70             if(_revokecable){
71                 voteAgreeCount++;
72             } else {
73                 voteAgreeCount--;
74             }
75             partnerRevokeVote[msg.sender].vote = _revokecable;
76         }
77         emit RevokeVoting(_revokecable);
78     }
79 
80     function isPartners(address _voter) private view returns(bool){
81         if(partnerRevokeVote[_voter].partner == _voter){
82             return true;
83         }
84         return false;
85     }
86 
87     function isRevocable() public view returns(bool) {
88         if(voteAgreeCount >= (partnerCount/2)+1){
89             return true;
90         }
91         return false;
92     }
93 
94     function release(ERC20Basic _token) public {
95         require(msg.sender == owner || isPartners(msg.sender));
96         uint256 _unreleased = releasableAmount(_token);
97         require(_unreleased > 0);
98         released[address(_token)] = released[address(_token)] + _unreleased;
99         _token.transfer(beneficiary, _unreleased);
100         emit Released(_unreleased);
101     }
102 
103     function revoke(ERC20Basic _token) public {
104         require(msg.sender == owner || isPartners(msg.sender));
105         require(isRevocable());
106         uint256 _balance = _token.balanceOf(address(this));
107         revoked[address(_token)] = revoked[address(_token)] + _balance;
108         _token.transfer(beneficiary, _balance);
109         emit Revoked();
110     }
111 
112     function releasableAmount(ERC20Basic _token) public view returns (uint256) {
113         uint256 _currentBalance = _token.balanceOf(address(this));
114         uint256 _totalBalance = _currentBalance + released[address(_token)];
115         uint256 _revoked = revoked[address(_token)];
116 
117         if (now < releaseStart) {
118             return 0;
119         } else if ((now >= releaseStart + interval * (times-1)) || _revoked > 0) {
120             return _currentBalance;
121         } else {
122             uint256 _count = _totalBalance / times;
123             uint256 _currentTimes = (((now - releaseStart) / interval) + 1);
124             uint256 _vestedAmount =  _currentTimes * _count;
125             return _vestedAmount - released[address(_token)];
126         }
127     }
128 }