1 pragma solidity ^0.5.4;
2 
3 interface IERC20 {
4 
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address who) external view returns (uint256);
8 
9     function allowance(address owner, address spender)
10     external view returns (uint256);
11 
12     function transfer(address to, uint256 value) external returns (bool);
13 
14     function approve(address spender, uint256 value)
15     external returns (bool);
16 
17     function transferFrom(address from, address to, uint256 value)
18     external returns (bool);
19 
20 }
21 
22 library SafeMath {
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27         uint256 c = a * b;
28         require(c / a == b);
29         return c;
30     }
31 
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a / b;
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         require(b <= a);
39         return a - b;
40     }
41 
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         require(c >= a);
45         return c;
46     }
47 }
48 
49 
50 contract AtisStaking {
51 	using SafeMath for uint256;
52  	address payable internal owner;
53     IERC20 internal atis = IERC20(address(0x821144518dfE9e7b44fCF4d0824e15e8390d4637));
54     uint256 constant internal MAGNITUDE = 2 ** 64;
55     uint32 constant private DROP_RATE = 3;
56     uint32 constant private PENALITY_FEE = 3;
57     uint32 constant private DROP_FREQUENCY = 48 hours;
58     uint32 constant private TIME_LOCK_FREQUENCY = 48 hours;
59     
60 
61     mapping(address => uint256) public stakedOf;
62     mapping(address => int256) private payoutsTo;
63     mapping(address => uint256) public claimedOf;
64     mapping(address => uint256) public unstakedOf;
65     mapping(address => uint256) public timeLock;
66     
67     uint256 private profitPerShare;
68     uint256 private pool;
69     uint256 private totalSupply;
70 
71     uint256 public lastDripTime  = now;
72     
73     modifier onlyOwner() {
74       require(msg.sender == owner,"NO_AUTH");
75     _;
76     }
77  
78 	constructor() public {
79 		owner = msg.sender;
80     }
81 
82 
83      modifier hasDripped(){
84         if(pool > 0 && totalSupply > 0){ 
85           uint256 cyclePassed = SafeMath.sub(now,lastDripTime)/DROP_FREQUENCY;
86          
87           uint256 dividends =  cyclePassed*((pool * DROP_RATE) / 100);
88 
89           if (dividends > pool) {
90               dividends = pool;
91           }
92 
93           profitPerShare = SafeMath.add(profitPerShare, (dividends * MAGNITUDE) / totalSupply);
94           pool = pool.sub(dividends);
95           lastDripTime = lastDripTime + (cyclePassed * DROP_FREQUENCY);
96         }
97 
98         _;
99     }
100 
101     function feed() public payable{
102         require(msg.value > 0);
103         if(pool == 0 && totalSupply > 0){//START DRIPPING
104             lastDripTime = now;
105         }
106         pool += msg.value;
107        
108     }
109 
110 
111     function stake(uint256 amount) hasDripped  public 
112     {
113         require(amount > 0);
114         uint256 currentBalance = atis.balanceOf(address(this));
115         atis.transferFrom(msg.sender, address(this), amount);
116         uint256 diff = atis.balanceOf(address(this)) - currentBalance;
117         
118         require(diff > 0);
119         
120         if(pool > 0 && totalSupply == 0){//START DRIPPING
121             lastDripTime = now;
122         }
123         totalSupply = SafeMath.add(totalSupply,diff);
124         stakedOf[msg.sender] = SafeMath.add(stakedOf[msg.sender], diff);
125         payoutsTo[msg.sender] += (int256) (profitPerShare * diff);
126     }
127 
128     function unstake(uint256 _amount) hasDripped public 
129     {
130         require(_amount <= stakedOf[msg.sender]);
131         totalSupply -= _amount;
132         stakedOf[msg.sender]= SafeMath.sub(stakedOf[msg.sender], _amount);
133         unstakedOf[msg.sender] += _amount;
134         payoutsTo[msg.sender] -= (int256) (profitPerShare * _amount);
135         timeLock[msg.sender] = now + TIME_LOCK_FREQUENCY;
136         
137     }
138 
139     function withdraw() hasDripped public 
140     {
141         require(unstakedOf[msg.sender] > 0);
142         require(timeLock[msg.sender] < now , "LOCKED");
143         uint256 amount = unstakedOf[msg.sender];
144         uint256 penality = (amount * PENALITY_FEE) / 100;
145         unstakedOf[msg.sender] = 0;
146         
147         atis.transfer(address(0xe82954Fc979A8CE3b9BBC1B19c6D6A2Aa6d240B2),penality);
148         atis.transfer(msg.sender,SafeMath.sub(amount,penality));
149     }
150 
151     function claimEarning() hasDripped public {
152         uint256 divs = dividendsOf(msg.sender);
153 
154         require(divs > 0 , "NO_DIV");
155         payoutsTo[msg.sender] += (int256) (divs * MAGNITUDE);
156         claimedOf[msg.sender] += divs;
157         msg.sender.transfer(divs);
158     }
159 
160 
161     function getGlobalInfo() public view returns (uint256 ,uint256){
162         return (pool,totalSupply);
163     }
164     
165 
166     function estimateDividendsOf(address _customerAddress) public view returns (uint256) {
167         if(pool > 0 && totalSupply > 0){
168             uint256 _profitPerShare = profitPerShare;
169             uint256 cyclePassed = SafeMath.sub(now,lastDripTime) / DROP_FREQUENCY;
170             uint256 dividends =  cyclePassed*((pool * DROP_RATE) / 100);
171     
172             if (dividends > pool) {
173                 dividends = pool;
174             }
175     
176             _profitPerShare = SafeMath.add(profitPerShare, (dividends * MAGNITUDE) / totalSupply);
177     
178             return  (uint256) ((int256) (_profitPerShare * stakedOf[_customerAddress]) - payoutsTo[_customerAddress]) / MAGNITUDE;
179             
180         }else{
181             return 0;
182         }
183     }
184 
185     function dividendsOf(address _customerAddress) public view returns (uint256) {
186         return (uint256) ((int256) (profitPerShare * stakedOf[_customerAddress]) -payoutsTo[_customerAddress]) / MAGNITUDE ;
187     }
188 }