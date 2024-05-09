1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3  
4 library SafeMath {
5     function add(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function sub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function mul(uint a, uint b) internal pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function div(uint a, uint b) internal pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23  
24 contract CheckinContract {
25  
26     struct Checkin {
27         string id;
28         string userId;
29         uint likeCount; 
30         uint likeValue;
31         uint reportCount;
32         string businessId;
33         address[] likers;
34         address[] reporters;
35         string businessName;
36         string username;
37         string comment;
38         uint timestamp;
39         bool confirmed;
40     }
41     
42     mapping (address => mapping(bytes32 => Checkin)) public checkins;
43     
44       
45    
46 }
47 
48 contract ERC20Interface {
49     function totalSupply() public view returns (uint);
50     function balanceOf(address tokenOwner) public view returns (uint balance);
51     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
52     function transfer(address to, uint tokens) public returns (bool success);
53     function approve(address spender, uint tokens) public returns (bool success);
54     function transferFrom(address from, address to, uint tokens) public returns (bool success);
55 
56     event Transfer(address indexed from, address indexed to, uint tokens);
57     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
58 }
59 
60 contract ApproveAndCallFallBack {
61     function receiveApproval(
62         address from,
63         uint256 tokens,
64         address token,
65         bytes memory data
66         ) public;
67 }
68 
69 contract Owned {
70     address public owner;
71     address public newOwner;
72 
73     event OwnershipTransferred(address indexed _from, address indexed _to);
74 
75     constructor() public {
76         owner = msg.sender;
77     }
78 
79     modifier onlyOwner {
80         require(msg.sender == owner);
81         _;
82     }
83 
84     function transferOwnership(address _newOwner) public onlyOwner {
85         newOwner = _newOwner;
86     }
87     function acceptOwnership() public {
88         require(msg.sender == newOwner);
89         emit OwnershipTransferred(owner, newOwner);
90         owner = newOwner;
91         newOwner = address(0);
92     }
93 }
94 
95 contract DropinToken is ERC20Interface, Owned,CheckinContract {
96     using SafeMath for uint;
97     function convert(string memory key) public returns (bytes32 ret) {
98         if (bytes(key).length > 32) {
99         revert();
100         }
101 
102         assembly {
103         ret := mload(add(key, 32))
104         }
105     }
106     
107     function addUser(address add) public onlyOwner{
108         balances[msg.sender]=balances[msg.sender].sub(1e18);
109         balances[add]=balances[add].add(1e18);
110     }
111     
112     string public symbol;
113     string public  name;
114     uint8 public decimals;
115     uint _totalSupply;
116 
117     mapping(address => uint) balances;
118     mapping(address => mapping(address => uint)) allowed;
119  
120     constructor() public {
121         symbol = "YTPx";
122         name = "Youtopin Token";
123         decimals = 18;
124         _totalSupply = 1000000000 * 10**uint(decimals);
125         balances[owner] = _totalSupply;
126         emit Transfer(address(0), owner, _totalSupply);
127     }
128 
129     function totalSupply() public view returns (uint) {
130         return _totalSupply.sub(balances[address(0)]);
131     }
132  
133     function balanceOf(
134         address tokenOwner
135         ) public view returns (uint balance) {
136         return balances[tokenOwner];
137     }
138 
139     function transfer(
140         address to, 
141         uint tokens
142         ) public returns (bool success) {
143         balances[msg.sender] = balances[msg.sender].sub(tokens);
144         balances[to] = balances[to].add(tokens);
145         emit Transfer(msg.sender, to, tokens);
146         return true;
147     }
148  
149     function approve(
150         address spender, 
151         uint tokens
152         ) public returns (bool success) {
153         allowed[msg.sender][spender] = tokens;
154         emit Approval(msg.sender, spender, tokens);
155         return true;
156     }
157  
158     function transferFrom(
159         address from, 
160         address to, 
161         uint tokens
162         ) public returns (bool success) {
163         balances[from] = balances[from].sub(tokens);
164         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
165         balances[to] = balances[to].add(tokens);
166         emit Transfer(from, to, tokens);
167         return true;
168     }
169  
170     function allowance(
171         address tokenOwner, 
172         address spender
173         ) public view returns (uint remaining) {
174         return allowed[tokenOwner][spender];
175     }
176  
177     function approveAndCall(
178         address spender, 
179         uint tokens, 
180         bytes memory data
181         ) public returns (bool success) {
182         allowed[msg.sender][spender] = tokens;
183         emit Approval(msg.sender, spender, tokens);
184         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
185         return true;
186     }
187  
188     function () external payable {
189         revert();
190     }
191  
192     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
193         return ERC20Interface(tokenAddress).transfer(owner, tokens);
194     }
195      
196     function like(
197         address checkinOwner,
198         string memory checkinId,
199         uint likeValue
200         ) public {
201         checkins[checkinOwner][convert(checkinId)].likers.push(msg.sender);
202         checkins[checkinOwner][convert(checkinId)].likeCount = checkins[checkinOwner][convert(checkinId)].likeCount.add(1);
203         checkins[checkinOwner][convert(checkinId)].likeValue = checkins[checkinOwner][convert(checkinId)].likeValue.add(likeValue);
204     
205         balances[msg.sender] = balances[msg.sender].sub(5e15);
206         balances[owner] = balances[owner].add(5e15);
207         emit Transfer(msg.sender,owner,5e15);
208         
209          if(checkins[checkinOwner][convert(checkinId)].reportCount.add(checkins[checkinOwner][convert(checkinId)].likeCount)>9){
210             confirmValidation(checkinOwner,checkinId);
211         }
212 
213      }
214 
215     function report(
216         address checkinOwner,
217         string memory checkinId,
218         uint reportValue
219         )public {
220         checkins[checkinOwner][convert(checkinId)].reporters.push(msg.sender);
221         checkins[checkinOwner][convert(checkinId)].reportCount = checkins[checkinOwner][convert(checkinId)].reportCount.add(1);
222         balances[owner] = balances[owner].add(5e15);
223         balances[msg.sender] = balances[msg.sender].sub(5e15);
224         emit Transfer(msg.sender,owner,5e15);
225         if(checkins[checkinOwner][convert(checkinId)].reportCount.add(checkins[checkinOwner][convert(checkinId)].likeCount)>9){
226             confirmValidation(checkinOwner,checkinId);
227         }
228 
229     }
230     
231     function addCheckin(
232         string memory id,
233         string memory userId,
234         string memory businessId,
235         string memory businessName,
236         string memory username,
237         string memory comment
238         ) public {
239 
240         Checkin storage checkin = checkins[msg.sender][convert(id)];
241         checkin.id = id;
242         checkin.userId = userId;
243         checkin.likeCount = 0;
244         checkin.likeValue = 0;
245         checkin.reportCount = 0;
246         checkin.businessId = businessId;
247         checkin.businessName = businessName;
248         checkin.username = username;
249         checkin.comment = comment;
250         checkin.timestamp = now;
251  
252         balances[owner] = balances[owner].add(5e16);
253         balances[msg.sender] = balances[msg.sender].sub(5e16);
254         emit Transfer(msg.sender,owner,5e16);
255 
256     }
257     
258     function confirmValidation(
259         address checkinOwner,
260         string memory checkinId
261         ) public {
262         Checkin memory checkin = checkins[checkinOwner][convert(checkinId)];
263         assert(!checkin.confirmed);
264         assert(checkin.reportCount.add(checkin.likeCount)>9);
265         if( checkin.reportCount*100 / checkin.likeCount >20){
266             
267             uint total = checkin.reportCount.add(checkin.likeCount).mul(5e15).add(5e16);
268             uint share = total.div(checkin.reportCount);
269             for(uint8 index = 0 ; index < checkin.reporters.length ; index++){
270                 balances[checkin.reporters[index]] =balances[checkin.reporters[index]].add(share);
271                 emit Transfer(owner,checkin.reporters[index],share);
272 
273             }
274             balances[owner] = balances[owner].sub(total);
275         }else{
276             uint total = checkin.reportCount.add(checkin.likeCount).mul(5e15).add(10e16);
277             uint checkinerShare = total.mul(6).div(10);
278             uint likersShare = total.sub(checkinerShare);
279             uint share = likersShare.div(checkin.likeCount);
280             balances[checkinOwner] = balances[checkinOwner].add(checkinerShare);
281             emit Transfer(owner,checkinOwner,checkinerShare);
282             for(uint8 i = 0;i<checkin.likers.length;i++){
283                 balances[checkin.likers[i]] = balances[checkin.likers[i]].add(share);
284                 emit Transfer(owner,checkin.likers[i],share);
285 
286             }
287             balances[owner] = balances[owner].sub(total);
288         }
289         checkins[checkinOwner][convert(checkinId)].confirmed = true;
290     }
291 }