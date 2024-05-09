1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-16
3 */
4 
5 pragma solidity ^0.5.2;
6 
7 /**
8  * @title ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/20
10  */
11 contract ERC20 {
12   function totalSupply() public view returns (uint256);
13 
14   function balanceOf(address _who) public view returns (uint256);
15 
16   function allowance(address _owner, address _spender)
17     public view returns (uint256);
18 
19   function transfer(address _to, uint256 _value) public returns (bool);
20 
21   function approve(address _spender, uint256 _value)
22     public returns (bool);
23 
24   function transferFrom(address _from, address _to, uint256 _value)
25     public returns (bool);
26 
27   event Transfer(
28     address indexed from,
29     address indexed to,
30     uint256 value
31   );
32 
33   event Approval(
34     address indexed owner,
35     address indexed spender,
36     uint256 value
37   );
38 }
39 
40 library SafeMath {
41   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a * b;
43     assert(a == 0 || c / a == b);
44     return c;
45   }
46 
47   function div(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a / b;
49     return c;
50   }
51 
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   function add(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a + b;
59     assert(c >= a);
60     return c;
61   }
62 }
63 
64 contract SourceCodeToken_PrivateSale {
65 
66     using SafeMath for uint256;
67     address owner;
68     address selfdroptoken;
69     address[] public hugeetherinvest;
70 
71     mapping (address => bool) public blacklist;
72 
73     uint256 public rate = 0;
74     uint256 public totalRemaining;
75     uint256 public selfdropvalue;
76 
77     event Distr(address indexed to, uint256 amount);
78     event DistrFinished();
79     event crowdsaleFinishedd();
80 
81     bool public distributionFinished;
82     bool public crowdsaleFinished;
83     
84     modifier canDistr() {
85         require(!distributionFinished);
86         _;
87     }
88     modifier canDistrCS() {
89         require(!crowdsaleFinished);
90         _;
91     }
92     modifier onlyOwner() {
93         require(msg.sender == owner);
94         _;
95     }
96     
97     modifier onlynotblacklist() {
98         require(blacklist[msg.sender] == false);
99         _;
100     }
101     
102     constructor() public {
103         owner = msg.sender;
104     }
105     function setselfdroptoken(address _selfdroptoken) public onlyOwner {
106         require (_selfdroptoken != address(0));
107         selfdroptoken = _selfdroptoken;
108         totalRemaining = ERC20(selfdroptoken).balanceOf(address(this));
109     } 
110     function transferOwnership(address newOwner) onlyOwner public {
111         if (newOwner != address(0)) {
112             owner = newOwner;
113         }
114     }
115     function startsale() onlyOwner public returns (bool) {
116         distributionFinished = false;
117         return true;
118     }
119     function startcrowdsale() onlyOwner public returns (bool) {
120         crowdsaleFinished = false;
121         return true;
122     }
123     function finishselfdrop() onlyOwner canDistr public returns (bool) {
124         distributionFinished = true;
125         emit DistrFinished();
126         return true;
127     }
128     function finishcrowdsale() onlyOwner canDistrCS public returns (bool) {
129         crowdsaleFinished = true;
130         emit crowdsaleFinishedd();
131         return true;
132     }
133     
134     function distr(address _to, uint256 _amount) private returns (bool) {
135 
136         totalRemaining = totalRemaining.sub(_amount);
137         ERC20(selfdroptoken).transfer(_to,_amount);
138         emit Distr(_to, _amount);
139         return true;
140         
141         if (totalRemaining == 0) {
142             distributionFinished = true;
143             crowdsaleFinished = true;
144         }
145     }
146     function setselfdropvalue(uint256 _value) public onlyOwner {
147         selfdropvalue = _value.mul(1e4);
148     }
149     function () external payable{
150         if(msg.value == 0){getTokenss();}else{getTokens();}         
151     }
152     function getTokenss() canDistr onlynotblacklist internal {
153         
154         require (selfdropvalue != 0);
155         
156         if (selfdropvalue > totalRemaining) {
157             selfdropvalue = totalRemaining;
158         }
159         
160         require(selfdropvalue <= totalRemaining);
161         
162         address investor = msg.sender;
163         uint256 toGive = selfdropvalue;
164         
165         distr(investor, toGive);
166         
167         if (toGive > 0) {
168             blacklist[investor] = true;
169         }
170     }
171     
172     function setethrate(uint _rate) onlyOwner public {
173         rate = _rate;
174     }
175     function getTokens() canDistrCS public payable {
176         
177         require(msg.value >= 0.05 ether);
178         require(rate > 0);
179         
180         uint256 value = msg.value.mul(rate);
181         
182         require(totalRemaining >= value);
183         
184         address investor = msg.sender;
185         uint256 toGive = value;
186         
187         distr(investor, toGive);
188         
189         if(msg.value >= 0.1 ether){
190             hugeetherinvest.push(msg.sender);
191         }
192     }
193     function withdrawfromcontract() public onlyOwner {
194         ERC20(selfdroptoken).transfer(owner,ERC20(selfdroptoken).balanceOf(address(this)));
195     }
196     function withdraw() public onlyOwner {
197         msg.sender.transfer(address(this).balance);
198     }
199 }