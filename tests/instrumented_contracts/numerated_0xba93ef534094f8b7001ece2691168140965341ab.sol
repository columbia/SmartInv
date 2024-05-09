1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         require(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         require(b > 0);
16         uint256 c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         require(b <= a);
22         uint256 c = a - b;
23         return c;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a);
29         return c;
30     }
31 
32     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b != 0);
34         return a % b;
35     }
36 }
37 
38 contract Ownable {
39     address public owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     modifier onlyOwner() {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function transferOwnership(address newOwner) public onlyOwner {
49         require(newOwner != address(0));
50         emit OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52     }
53 
54     function renounceOwnership() public onlyOwner {
55         emit OwnershipTransferred(owner, address(0));
56         owner = address(0);
57     }
58 }
59 
60 contract Pausable is Ownable {
61     bool public paused;
62     
63     event Paused(address account);
64     event Unpaused(address account);
65 
66     constructor() internal {
67         paused = false;
68     }
69 
70     modifier whenNotPaused() {
71         require(!paused);
72         _;
73     }
74 
75     modifier whenPaused() {
76         require(paused);
77         _;
78     }
79 
80     function pause() public onlyOwner whenNotPaused {
81         paused = true;
82         emit Paused(msg.sender);
83     }
84 
85     function unpause() public onlyOwner whenPaused {
86         paused = false;
87         emit Unpaused(msg.sender);
88     }
89 }
90 
91 contract BaseToken is Pausable {
92     using SafeMath for uint256;
93 
94     string constant public name = 'Beauty bakery lott';
95     string constant public symbol = 'LOTT';
96     uint8 constant public decimals = 18;
97     uint256 public totalSupply =  5000000000*10**uint256(decimals);
98 
99     mapping (address => uint256) public balanceOf;
100     mapping (address => mapping (address => uint256)) public allowance;
101 
102     event Transfer(address indexed from, address indexed to, uint256 value);
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 
105     function _transfer(address from, address to, uint value) internal {
106         require(to != address(0));
107         balanceOf[from] = balanceOf[from].sub(value);
108         balanceOf[to] = balanceOf[to].add(value);
109         emit Transfer(from, to, value);
110     }
111 
112 
113     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
114         _transfer(msg.sender, to, value);
115         return true;
116     }
117 
118     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
119         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
120         _transfer(from, to, value);
121         return true;
122     }
123 
124     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
125         require(spender != address(0));
126         allowance[msg.sender][spender] = value;
127         emit Approval(msg.sender, spender, value);
128         return true;
129     }
130 
131     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
132         require(spender != address(0));
133         allowance[msg.sender][spender] = allowance[msg.sender][spender].add(addedValue);
134         emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
135         return true;
136     }
137 
138     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
139         require(spender != address(0));
140         allowance[msg.sender][spender] = allowance[msg.sender][spender].sub(subtractedValue);
141         emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
142         return true;
143     }
144 }
145 
146 
147 
148 
149 contract LockToken is BaseToken {
150 
151     struct LockItem {
152         uint256 endtime;
153         uint256 remain;
154     }
155 
156     struct LockMeta {
157         uint8 lockType;
158         LockItem[] lockItems;
159     }
160 
161     mapping (address => LockMeta) public lockData;
162 
163     event Lock(address indexed lockAddress, uint8 indexed lockType, uint256[] endtimeList, uint256[] remainList);
164 
165     function _transfer(address from, address to, uint value) internal {
166         uint8 lockType = lockData[from].lockType;
167         if (lockType != 0) {
168             uint256 remain = balanceOf[from].sub(value);
169             uint256 length = lockData[from].lockItems.length;
170             for (uint256 i = 0; i < length; i++) {
171                 LockItem storage item = lockData[from].lockItems[i];
172                 if (block.timestamp < item.endtime && remain < item.remain) {
173                     revert();
174                 }
175             }
176         }
177         super._transfer(from, to, value);
178     }
179 
180     function lock(address lockAddress, uint8 lockType, uint256[] endtimeList, uint256[] remainList) public onlyOwner returns (bool) {
181         require(lockAddress != address(0));
182         require(lockType == 0 || lockType == 1 || lockType == 2);
183         require(lockData[lockAddress].lockType != 1);
184 
185         lockData[lockAddress].lockItems.length = 0;
186 
187         lockData[lockAddress].lockType = lockType;
188         if (lockType == 0) {
189             emit Lock(lockAddress, lockType, endtimeList, remainList);
190             return true;
191         }
192 
193         require(endtimeList.length == remainList.length);
194         uint256 length = endtimeList.length;
195         require(length > 0 && length <= 12);
196         uint256 thisEndtime = endtimeList[0];
197         uint256 thisRemain = remainList[0];
198         lockData[lockAddress].lockItems.push(LockItem({endtime: thisEndtime, remain: thisRemain}));
199         for (uint256 i = 1; i < length; i++) {
200             require(endtimeList[i] > thisEndtime && remainList[i] < thisRemain);
201             lockData[lockAddress].lockItems.push(LockItem({endtime: endtimeList[i], remain: remainList[i]}));
202             thisEndtime = endtimeList[i];
203             thisRemain = remainList[i];
204         }
205 
206         emit Lock(lockAddress, lockType, endtimeList, remainList);
207         return true;
208     }
209 }
210 
211 
212 
213 
214 contract CustomToken is BaseToken, LockToken {
215     constructor() public {
216         balanceOf[msg.sender] = totalSupply;
217         emit Transfer(address(0), msg.sender, totalSupply);
218 
219         owner = msg.sender;
220         
221     }
222 
223     function() public payable {
224        revert();
225     }
226 }