1 pragma solidity ^0.4.25;
2 
3 interface HourglassInterface {
4     function buy(address _playerAddress) payable external returns(uint256);
5     function sell(uint256 _amountOfTokens) external;
6     function reinvest() external;
7     function withdraw() external;
8     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
9     function balanceOf(address _customerAddress) view external returns(uint256);
10     function myDividends(bool _includeReferralBonus) external view returns(uint256);
11 }
12 
13 contract StrongHandsManager {
14     
15     event CreatedStrongHand(address indexed owner, address indexed strongHand);
16     
17     mapping (address => address) public strongHands;
18     
19     function isStrongHand()
20         public
21         view
22         returns (bool)
23     {
24         return strongHands[msg.sender] != address(0);
25     }
26     
27     function myStrongHand()
28         external
29         view
30         returns (address)
31     {  
32         require(isStrongHand(), "You are not a Stronghand");
33         
34         return strongHands[msg.sender];
35     }
36     
37     function create(uint256 _unlockAfterNDays)
38         public
39     {
40         require(!isStrongHand(), "You already became a Stronghand");
41         require(_unlockAfterNDays > 0);
42         
43         address owner = msg.sender;
44     
45         strongHands[owner] = new StrongHand(owner, _unlockAfterNDays);
46         
47         emit CreatedStrongHand(owner, strongHands[owner]);
48     }
49 }
50 
51 contract StrongHand {
52 
53     HourglassInterface constant p3dContract = HourglassInterface(0x1EB2acB92624DA2e601EEb77e2508b32E49012ef);
54     
55     address public owner;
56     
57     uint256 public creationDate;
58     
59     uint256 public unlockAfterNDays;
60     
61     modifier timeLocked()
62     {
63         require(now >= creationDate + unlockAfterNDays * 1 days);
64         _;
65     }
66     
67     modifier onlyOwner()
68     {
69         require(msg.sender == owner);
70         _;
71     }
72     
73     constructor(address _owner, uint256 _unlockAfterNDays)
74         public
75     {
76         owner = _owner;
77         unlockAfterNDays =_unlockAfterNDays;
78         
79         creationDate = now;
80     }
81     
82     function() public payable {}
83     
84     function isLocked()
85         public
86         view
87         returns(bool)
88     {
89         return now < creationDate + unlockAfterNDays * 1 days;
90     }
91     
92     function lockedUntil()
93         external
94         view
95         returns(uint256)
96     {
97         return creationDate + unlockAfterNDays * 1 days;
98     }
99     
100     function extendLock(uint256 _howManyDays)
101         external
102         onlyOwner
103     {
104         uint256 newLockTime = unlockAfterNDays + _howManyDays;
105         
106         require(newLockTime > unlockAfterNDays);
107         
108         unlockAfterNDays = newLockTime;
109     }
110     
111     //safety functions
112     
113     function withdraw()
114         external
115         onlyOwner
116     {
117         owner.transfer(address(this).balance);
118     }
119     
120     function buyWithBalance()
121         external
122         onlyOwner
123     {
124        p3dContract.buy.value(address(this).balance)(0x1EB2acB92624DA2e601EEb77e2508b32E49012ef);
125     }
126     
127     //P3D functions
128     
129     function balanceOf()
130         external
131         view
132         returns(uint256)
133     {
134         return p3dContract.balanceOf(address(this));
135     }
136     
137     function dividendsOf()
138         external
139         view
140         returns(uint256)
141     {
142         return p3dContract.myDividends(true);
143     }
144     
145     function buy()
146         external
147         payable
148         onlyOwner
149     {
150         p3dContract.buy.value(msg.value)(0x1EB2acB92624DA2e601EEb77e2508b32E49012ef);
151     }
152     
153     function reinvest()
154         external
155         onlyOwner
156     {
157         p3dContract.reinvest();
158     }
159 
160     function withdrawDividends()
161         external
162         onlyOwner
163     {
164         p3dContract.withdraw();
165         
166         owner.transfer(address(this).balance);
167     }
168     
169     function sell(uint256 _amount)
170         external
171         timeLocked
172         onlyOwner
173     {
174         p3dContract.sell(_amount);
175         
176         owner.transfer(address(this).balance);
177     }
178     
179     function transfer(address _toAddress, uint256 _amountOfTokens)
180         external
181         timeLocked
182         onlyOwner
183         returns(bool)
184     {
185         return p3dContract.transfer(_toAddress, _amountOfTokens);
186     }
187 }