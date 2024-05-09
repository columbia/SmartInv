1 pragma solidity ^0.5.7;
2 
3 /* NASH TOKEN FIRST EDITION
4 THE NEW WORLD BLOCKCHAIN PROJECT
5 CREATED 2019-04-18 BY DAO DRIVER ETHEREUM (c)*/
6 
7 library SafeMath {
8     
9     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
10         if (a == 0) {
11             return 0;
12         }
13         c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns(uint256) {
19         return a / b;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
28         c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract owned {
35     
36     address payable internal owner;
37     address payable internal newOwner;
38     address payable internal found;
39     address payable internal feedr;
40     
41     modifier onlyOwner {
42         require(owner == msg.sender);
43         _;
44     }
45 
46     function changeOwner(address payable _owner) onlyOwner public {
47         require(_owner != address(0));
48         newOwner = _owner;
49     }
50 
51     function confirmOwner() public {
52         require(newOwner == msg.sender);
53         owner = newOwner;
54         delete newOwner;
55     }
56 }
57 
58 contract ERC20Basic {
59     modifier onlyPayloadSize(uint size) {
60         require(msg.data.length >= size + 4);
61         _;
62     }
63     function totalSupply() public view returns(uint256);
64     function balanceOf(address who) public view returns(uint256);
65     function transfer(address payable to, uint256 value) public returns(bool);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 contract ERC20 is ERC20Basic {
70     function allowance(address owner, address spender) public view returns(uint256);
71     function transferFrom(address payable from, address payable to, uint256 value) public returns(bool);
72     function approve(address spender, uint256 value) public returns(bool);
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 contract TokenBasic is ERC20Basic, owned {
77     using SafeMath for uint256;
78     mapping(address => uint256) internal balances;
79     uint256 internal totalSupply_;
80     uint256 internal activeSupply_;
81     mapping(uint256 => uint256) public sum_;
82     mapping(address => uint256) public pdat_;
83     uint256 public pnr_;
84 
85     function totalSupply() public view returns(uint256) {
86         return totalSupply_;
87     }
88 
89     function activeSupply() public view returns(uint256) {
90         return activeSupply_;
91     }
92 
93     function transfer(address payable _to, uint256 _value) public onlyPayloadSize(2 * 32) returns(bool) {
94         require(_to != address(0));
95         require(_value <= balances[msg.sender]);
96         require(_to != found);
97         uint256 div1 = 0;
98         uint256 div2 = 0;
99         if (msg.sender != found) {
100             if (pdat_[msg.sender] < pnr_) {
101                 for (uint256 i = pnr_; i >= pdat_[msg.sender]; i = i.sub(1)) {
102                     div1 = div1.add(sum_[i].mul(balances[msg.sender]));
103                 }
104             }
105         }
106         if (pdat_[_to] < pnr_ && balances[_to] > 0) {
107             for (uint256 i = pnr_; i >= pdat_[_to]; i = i.sub(1)) {
108                 div2 = div2.add(sum_[i].mul(balances[_to]));
109             }
110         }
111         
112         balances[msg.sender] = balances[msg.sender].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         
115         pdat_[_to] = pnr_;
116         
117         emit Transfer(msg.sender, _to, _value);
118         
119         if (msg.sender == found) {
120             activeSupply_ = activeSupply_.add(_value);
121         } else {
122             pdat_[msg.sender] = pnr_;
123             if (div1 > 0) {
124                 msg.sender.transfer(div1);
125             }
126         }
127         if (div2 > 0) {
128             _to.transfer(div2);
129         }
130         return true;
131     }
132 
133     function balanceOf(address _owner) public view returns(uint256) {
134         return balances[_owner];
135     }
136 }
137 
138 contract TokenStandard is ERC20, TokenBasic {
139     
140     mapping(address => mapping(address => uint256)) internal allowed;
141 
142     function transferFrom(address payable _from, address payable _to, uint256 _value) public onlyPayloadSize(3 * 32) returns(bool) {
143         require(_to != address(0));
144         require(_to != found);
145         require(_value <= balances[_from]);
146         require(_value <= allowed[_from][msg.sender]);
147         uint256 div1 = 0;
148         uint256 div2 = 0;
149         if (_from != found) {
150             if (pdat_[_from] < pnr_) {
151                 for (uint256 i = pnr_; i >= pdat_[_from]; i = i.sub(1)) {
152                     div1 = div1.add(sum_[i].mul(balances[_from]));
153                 }
154             }
155         }
156         if (pdat_[_to] < pnr_ && balances[_to] > 0) {
157             for (uint256 i = pnr_; i >= pdat_[_to]; i = i.sub(1)) {
158                 div2 = div2.add(sum_[i].mul(balances[_to]));
159             }
160         }
161         
162         balances[_from] = balances[_from].sub(_value);
163         balances[_to] = balances[_to].add(_value);
164         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165         
166         pdat_[_to] = pnr_;
167         
168         emit Transfer(_from, _to, _value);
169         if (_from == found) {
170             activeSupply_ = activeSupply_.add(_value);
171         } else {
172             pdat_[_from] = pnr_;
173             if (div1 > 0) {
174                 _from.transfer(div1);
175             }
176         }
177         if (div2 > 0) {
178             _to.transfer(div2);
179         }
180         return true;
181     }
182 
183     function approve(address _spender, uint256 _value) public returns(bool) {
184         allowed[msg.sender][_spender] = _value;
185         emit Approval(msg.sender, _spender, _value);
186         return true;
187     }
188 
189     function allowance(address _owner, address _spender) public view returns(uint256) {
190         return allowed[_owner][_spender];
191     }
192 
193     function increaseApproval(address _spender, uint _addrdedValue) public returns(bool) {
194         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addrdedValue);
195         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196         return true;
197     }
198 
199     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
200         uint oldValue = allowed[msg.sender][_spender];
201         if (_subtractedValue > oldValue) {
202             allowed[msg.sender][_spender] = 0;
203         } else {
204             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205         }
206         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207         return true;
208     }
209 }
210 
211 contract ANASH is TokenStandard {
212     string public constant name = "NASH TOKEN";
213     string public constant symbol = "NASH";
214     uint8 public constant decimals = 18;
215     uint256 internal constant premined = 2 * 10 ** 26;
216 
217     function() payable external {
218         if (feedr == msg.sender) {
219             require(msg.value >= 10 ** 16);
220             sum_[pnr_] = msg.value.div(activeSupply_);
221             pnr_ = pnr_.add(1);
222         } else {
223             require(balances[msg.sender] > 0);
224             uint256 div1 = 0;
225             if (pdat_[msg.sender] < pnr_) {
226                 for (uint256 i = pnr_; i >= pdat_[msg.sender]; i = i.sub(1)) {
227                     div1 = div1.add(sum_[i].mul(balances[msg.sender]));
228                 }
229             }
230             pdat_[msg.sender] = pnr_;
231             div1 = div1.add(msg.value);
232             if (div1 > 0) {
233                 msg.sender.transfer(div1);
234             }
235         }
236     }
237     constructor() public {
238         pnr_ = 1;
239         owner = msg.sender;
240         found = 0xfB538A7365d47183692E1866fC0b32308F15BAFD;
241         feedr = 0xCebaa747868135CC4a0d9A4f982849161f3a4CE7;
242         totalSupply_ = premined;
243         activeSupply_ = 0;
244         balances[found] = balances[found].add(premined);
245         emit Transfer(address(0), found, premined);
246     }
247 }