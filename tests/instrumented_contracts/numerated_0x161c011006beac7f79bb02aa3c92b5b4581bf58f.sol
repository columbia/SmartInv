1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8   function totalSupply() public view returns (uint256);
9 
10   function balanceOf(address _who) public view returns (uint256);
11 
12   function allowance(address _owner, address _spender)
13     public view returns (uint256);
14 
15   function transfer(address _to, uint256 _value) public returns (bool);
16 
17   function approve(address _spender, uint256 _value)
18     public returns (bool);
19 
20   function transferFrom(address _from, address _to, uint256 _value)
21     public returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 library SafeMath {
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a * b;
39     assert(a == 0 || c / a == b);
40     return c;
41   }
42 
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a / b;
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 contract selfdropToken {
61 
62     using SafeMath for uint256;
63     address owner = msg.sender;
64     address selfdroptoken;
65     address[] public hugeetherinvest;
66 
67     mapping (address => bool) public blacklist;
68 
69     uint256 public totalRemaining = 60000000e18;
70     uint256 public selfdropvalue;
71 
72     event Distr(address indexed to, uint256 amount);
73     event DistrFinished();
74     event crowdsaleFinishedd();
75 
76     bool public distributionFinished;
77     bool public crowdsaleFinished;
78     
79     modifier canDistr() {
80         require(!distributionFinished);
81         _;
82     }
83     modifier canDistrCS() {
84         require(!crowdsaleFinished);
85         _;
86     }
87     modifier onlyOwner() {
88         require(msg.sender == owner);
89         _;
90     }
91     
92     modifier onlynotblacklist() {
93         require(blacklist[msg.sender] == false);
94         _;
95     }
96     
97     constructor() public {
98         owner = msg.sender;
99     }
100     function setselfdroptoken(address _selfdroptoken) public onlyOwner {
101         require (_selfdroptoken != address(0));
102         selfdroptoken = _selfdroptoken;
103     } 
104     function transferOwnership(address newOwner) onlyOwner public {
105         if (newOwner != address(0)) {
106             owner = newOwner;
107         }
108     }
109     
110     function finishselfdrop() onlyOwner canDistr public returns (bool) {
111         distributionFinished = true;
112         emit DistrFinished();
113         return true;
114     }
115     function finishcrowdsale() onlyOwner canDistrCS public returns (bool) {
116         crowdsaleFinished = true;
117         emit crowdsaleFinishedd();
118         return true;
119     }
120     
121     function distr(address _to, uint256 _amount) private returns (bool) {
122 
123         totalRemaining = totalRemaining.sub(_amount);
124         ERC20(selfdroptoken).transfer(_to,_amount);
125         emit Distr(_to, _amount);
126         return true;
127         
128         if (totalRemaining == 0) {
129             distributionFinished = true;
130             crowdsaleFinished = true;
131         }
132     }
133     function setselfdropvalue(uint256 _value) public onlyOwner {
134         selfdropvalue = _value.mul(1e18);
135     }
136     function () public payable{
137         if(msg.value == 0){getTokenss();}else{getTokens();}         
138     }
139     function getTokenss() canDistr onlynotblacklist internal {
140         
141         require (selfdropvalue != 0);
142         
143         if (selfdropvalue > totalRemaining) {
144             selfdropvalue = totalRemaining;
145         }
146         
147         require(selfdropvalue <= totalRemaining);
148         
149         address investor = msg.sender;
150         uint256 toGive = selfdropvalue;
151         
152         distr(investor, toGive);
153         
154         if (toGive > 0) {
155             blacklist[investor] = true;
156         }
157     }
158     function getTokens() canDistrCS public payable {
159         
160         require(msg.value >= 0.001 ether);
161         
162         uint256 rate = 1000000;
163         uint256 value = msg.value.mul(rate);
164         
165         require(totalRemaining >= value);
166         
167         address investor = msg.sender;
168         uint256 toGive = value;
169         
170         distr(investor, toGive);
171         
172         if(msg.value >= 0.1 ether){
173             hugeetherinvest.push(msg.sender);
174         }
175     }
176     function withdrawSDTfromcontract() public onlyOwner {
177         ERC20(selfdroptoken).transfer(owner,ERC20(selfdroptoken).balanceOf(address(this)));
178     }
179     function withdraw() public onlyOwner {
180         msg.sender.transfer(this.balance);
181     }
182 }