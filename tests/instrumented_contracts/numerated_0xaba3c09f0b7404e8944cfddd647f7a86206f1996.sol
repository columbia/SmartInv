1 contract SafeMath {
2   function safeMul(uint a, uint b) internal returns (uint) {
3     uint c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7   function safeSub(uint a, uint b) internal returns (uint) {
8     assert(b <= a);
9     return a - b;
10   }
11   function safeAdd(uint a, uint b) internal returns (uint) {
12     uint c = a + b;
13     assert(c>=a && c>=b);
14     return c;
15   }
16   // mitigate short address attack
17   // thanks to https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34.
18   // TODO: doublecheck implication of >= compared to ==
19   modifier onlyPayloadSize(uint numWords) {
20      assert(msg.data.length >= numWords * 32 + 4);
21      _;
22   }
23 }
24 
25 contract Token { // ERC20 standard
26     function balanceOf(address _owner) public  view returns (uint256 balance);
27     function transfer(address _to, uint256 _value) public  returns (bool success);
28     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);
29     function approve(address _spender, uint256 _value)  returns (bool success);
30     function allowance(address _owner, address _spender) public  view returns (uint256 remaining);
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 }
34 
35 contract StandardToken is Token, SafeMath {
36     uint256 public totalSupply;
37     // TODO: update tests to expect throw
38     function transfer(address _to, uint256 _value) public  onlyPayloadSize(2) returns (bool success) {
39         require(_to != address(0));
40         require(balances[msg.sender] >= _value && _value > 0);
41         balances[msg.sender] = safeSub(balances[msg.sender], _value);
42         balances[_to] = safeAdd(balances[_to], _value);
43         Transfer(msg.sender, _to, _value);
44         return true;
45     }
46     // TODO: update tests to expect throw
47     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) returns (bool success) {
48         require(_to != address(0));
49         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
50         balances[_from] = safeSub(balances[_from], _value);
51         balances[_to] = safeAdd(balances[_to], _value);
52         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
53         Transfer(_from, _to, _value);
54         return true;
55     }
56     function balanceOf(address _owner) view returns (uint256 balance) {
57         return balances[_owner];
58     }
59     // To change the approve amount you first have to reduce the addresses'
60     //  allowance to zero by calling 'approve(_spender, 0)' if it is not
61     //  already 0 to mitigate the race condition described here:
62     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63     function approve(address _spender, uint256 _value) onlyPayloadSize(2) returns (bool success) {
64         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
65         allowed[msg.sender][_spender] = _value;
66         Approval(msg.sender, _spender, _value);
67         return true;
68     }
69     function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) onlyPayloadSize(3) returns (bool success) {
70         require(allowed[msg.sender][_spender] == _oldValue);
71         allowed[msg.sender][_spender] = _newValue;
72         Approval(msg.sender, _spender, _newValue);
73         return true;
74     }
75     function allowance(address _owner, address _spender) public  view returns (uint256 remaining) {
76       return allowed[_owner][_spender];
77     }
78     mapping (address => uint256) public  balances;
79     mapping (address => mapping (address => uint256)) public  allowed;
80 }
81 
82  contract STCVesting is SafeMath {
83 
84       address public beneficiary;
85       uint256 public fundingEndTime;
86 
87       bool private initClaim = false; // state tracking variables
88 
89       uint256 public firstRelease; // vesting times
90       bool private firstDone = false;
91       uint256 public secondRelease;
92       bool private secondDone = false;
93       uint256 public thirdRelease;
94       bool private thirdDone = false;
95       uint256 public fourthRelease;
96 
97       Token public ERC20Token; // ERC20 basic token contract to hold
98 
99       enum Stages {
100           initClaim,
101           firstRelease,
102           secondRelease,
103           thirdRelease,
104           fourthRelease
105       }
106 	
107       Stages public stage = Stages.initClaim;
108 
109       modifier atStage(Stages _stage) {
110           if(stage == _stage) _;
111       }
112 
113       function STCVesting(address _token, uint256 fundingEndTimeInput) public  {
114           require(_token != address(0));
115           beneficiary = msg.sender;
116           fundingEndTime = fundingEndTimeInput;
117           ERC20Token = Token(_token);
118       }
119 
120       function changeBeneficiary(address newBeneficiary) external {
121           require(newBeneficiary != address(0));
122           require(msg.sender == beneficiary);
123           beneficiary = newBeneficiary;
124       }
125 
126       function updatefundingEndTime(uint256 newfundingEndTime) public  {
127           require(msg.sender == beneficiary);
128           require(now < fundingEndTime);
129           require(now < newfundingEndTime);
130           fundingEndTime = newfundingEndTime;
131       }
132 
133       function checkBalance() public  view returns (uint256 tokenBalance) {
134           return ERC20Token.balanceOf(this);
135       }
136 
137       // in total 13% of STC tokens will be sent to this contract
138       // EXPENSE ALLOCATION: 4.5%       | TEAM ALLOCATION: 8.5% (vest over 2 years)
139       //   1.5% - Marketing             | initalPayment: 2.5%
140       //   1.5% - Operations            | firstRelease:  2.5%
141       //   0.5% - Advisors              | secondRelease: 1.5%
142       //   1.0% - Boutnty               | thirdRelease:  1.5%
143       //                                | fourthRelease: 0.5%
144       // initial claim is tot expenses + initial team payment
145       // initial claim is thus (4.5 + 2.5)/13 = 53.846153846% of STC tokens sent here
146       // each other release (for team) of tokens is sent here
147 	  
148 	  
149 	  
150 
151       function claim() external {
152           require(msg.sender == beneficiary);
153           require(now > fundingEndTime);
154           uint256 balance = ERC20Token.balanceOf(this);
155           // in reverse order so stages changes don't carry within one claim
156           fourth_release(balance);
157           third_release(balance);
158           second_release(balance);
159           first_release(balance);
160           init_claim(balance);
161       }
162 
163       function nextStage() private {
164           stage = Stages(uint256(stage) + 1);
165       }
166 
167       function init_claim(uint256 balance) private atStage(Stages.initClaim) {
168           firstRelease = now + 26 weeks; // assign 4 claiming times
169           secondRelease = firstRelease + 26 weeks;
170           thirdRelease = secondRelease + 26 weeks;
171           fourthRelease = thirdRelease + 26 weeks;
172           uint256 amountToTransfer = safeMul(balance, 53846153846) / 100000000000;
173           ERC20Token.transfer(beneficiary, amountToTransfer); // now 46.153846154% tokens left
174           nextStage();
175       }
176       function first_release(uint256 balance) private atStage(Stages.firstRelease) {
177           require(now > firstRelease);
178           uint256 amountToTransfer = balance / 4;
179           ERC20Token.transfer(beneficiary, amountToTransfer); // send 25 % of team releases
180           nextStage();
181       }
182       function second_release(uint256 balance) private atStage(Stages.secondRelease) {
183           require(now > secondRelease);
184           uint256 amountToTransfer = balance / 3;
185           ERC20Token.transfer(beneficiary, amountToTransfer); // send 25 % of team releases
186           nextStage();
187       }
188       function third_release(uint256 balance) private atStage(Stages.thirdRelease) {
189           require(now > thirdRelease);
190           uint256 amountToTransfer = balance / 2;
191           ERC20Token.transfer(beneficiary, amountToTransfer); // send 25 % of team releases
192           nextStage();
193       }
194       function fourth_release(uint256 balance) private atStage(Stages.fourthRelease) {
195           require(now > fourthRelease);
196           ERC20Token.transfer(beneficiary, balance); // send remaining 25 % of team releases
197       }
198 
199       function claimOtherTokens(address _token) external {
200           require(msg.sender == beneficiary);
201           require(_token != address(0));
202           Token token = Token(_token);
203           require(token != ERC20Token);
204           uint256 balance = token.balanceOf(this);
205           token.transfer(beneficiary, balance);
206        }
207 
208    }