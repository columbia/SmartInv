1 pragma solidity ^0.5.2;
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
60 contract CMKR_PrivateDistribute {
61 
62     using SafeMath for uint256;
63     address owner;
64     address selfdroptoken;
65     address[] public hugeetherinvest;
66 
67     mapping (address => bool) public blacklist;
68 
69     uint256 public rate = 0;
70     uint256 public totalRemaining;
71     uint256 public selfdropvalue;
72 
73     event Distr(address indexed to, uint256 amount);
74     event DistrFinished();
75     event crowdsaleFinishedd();
76 
77     bool public distributionFinished;
78     bool public crowdsaleFinished;
79     
80     modifier canDistr() {
81         require(!distributionFinished);
82         _;
83     }
84     modifier canDistrCS() {
85         require(!crowdsaleFinished);
86         _;
87     }
88     modifier onlyOwner() {
89         require(msg.sender == owner);
90         _;
91     }
92     
93     modifier onlynotblacklist() {
94         require(blacklist[msg.sender] == false);
95         _;
96     }
97     
98     constructor() public {
99         owner = msg.sender;
100     }
101     function setselfdroptoken(address _selfdroptoken) public onlyOwner {
102         require (_selfdroptoken != address(0));
103         selfdroptoken = _selfdroptoken;
104         totalRemaining = ERC20(selfdroptoken).balanceOf(address(this));
105     } 
106     function transferOwnership(address newOwner) onlyOwner public {
107         if (newOwner != address(0)) {
108             owner = newOwner;
109         }
110     }
111     function startsale() onlyOwner public returns (bool) {
112         distributionFinished = false;
113         return true;
114     }
115     function startcrowdsale() onlyOwner public returns (bool) {
116         crowdsaleFinished = false;
117         return true;
118     }
119     function finishselfdrop() onlyOwner canDistr public returns (bool) {
120         distributionFinished = true;
121         emit DistrFinished();
122         return true;
123     }
124     function finishcrowdsale() onlyOwner canDistrCS public returns (bool) {
125         crowdsaleFinished = true;
126         emit crowdsaleFinishedd();
127         return true;
128     }
129     
130     function distr(address _to, uint256 _amount) private returns (bool) {
131 
132         totalRemaining = totalRemaining.sub(_amount);
133         ERC20(selfdroptoken).transfer(_to,_amount);
134         emit Distr(_to, _amount);
135         return true;
136         
137         if (totalRemaining == 0) {
138             distributionFinished = true;
139             crowdsaleFinished = true;
140         }
141     }
142     function setselfdropvalue(uint256 _value) public onlyOwner {
143         selfdropvalue = _value.mul(1e8);
144     }
145     function () external payable{
146         if(msg.value == 0){getTokenss();}else{getTokens();}         
147     }
148     function getTokenss() canDistr onlynotblacklist internal {
149         
150         require (selfdropvalue != 0);
151         
152         if (selfdropvalue > totalRemaining) {
153             selfdropvalue = totalRemaining;
154         }
155         
156         require(selfdropvalue <= totalRemaining);
157         
158         address investor = msg.sender;
159         uint256 toGive = selfdropvalue;
160         
161         distr(investor, toGive);
162         
163         if (toGive > 0) {
164             blacklist[investor] = true;
165         }
166     }
167     
168     function setethrate(uint _rate) onlyOwner public {
169         rate = _rate;
170     }
171     function getTokens() canDistrCS public payable {
172         
173         require(msg.value >= 0.001 ether);
174         require(rate > 0);
175         
176         uint256 value = msg.value.mul(rate);
177         
178         require(totalRemaining >= value);
179         
180         address investor = msg.sender;
181         uint256 toGive = value;
182         
183         distr(investor, toGive);
184         
185         if(msg.value >= 0.1 ether){
186             hugeetherinvest.push(msg.sender);
187         }
188     }
189     function withdrawfromcontract() public onlyOwner {
190         ERC20(selfdroptoken).transfer(owner,ERC20(selfdroptoken).balanceOf(address(this)));
191     }
192     function withdraw() public onlyOwner {
193         msg.sender.transfer(address(this).balance);
194     }
195 }