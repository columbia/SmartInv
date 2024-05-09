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
60 contract BaseToken is Ownable {
61     using SafeMath for uint256;
62 
63     string constant public name = 'BHTX';
64     string constant public symbol = 'BHTX';
65     uint8 constant public decimals = 18;
66     uint256 public totalSupply = 1e27;
67     uint256 constant public _totalLimit = 1e32;
68 
69     mapping (address => uint256) public balanceOf;
70     mapping (address => mapping (address => uint256)) public allowance;
71 
72     event Transfer(address indexed from, address indexed to, uint256 value);
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 
75     function _transfer(address from, address to, uint value) internal {
76         require(to != address(0));
77         balanceOf[from] = balanceOf[from].sub(value);
78         balanceOf[to] = balanceOf[to].add(value);
79         emit Transfer(from, to, value);
80     }
81 
82     function _mint(address account, uint256 value) internal {
83         require(account != address(0));
84         totalSupply = totalSupply.add(value);
85         require(_totalLimit >= totalSupply);
86         balanceOf[account] = balanceOf[account].add(value);
87         emit Transfer(address(0), account, value);
88     }
89 
90     function transfer(address to, uint256 value) public returns (bool) {
91         _transfer(msg.sender, to, value);
92         return true;
93     }
94 
95     function transferFrom(address from, address to, uint256 value) public returns (bool) {
96         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
97         _transfer(from, to, value);
98         return true;
99     }
100 
101     function approve(address spender, uint256 value) public returns (bool) {
102         require(spender != address(0));
103         allowance[msg.sender][spender] = value;
104         emit Approval(msg.sender, spender, value);
105         return true;
106     }
107 
108     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
109         require(spender != address(0));
110         allowance[msg.sender][spender] = allowance[msg.sender][spender].add(addedValue);
111         emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
112         return true;
113     }
114 
115     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
116         require(spender != address(0));
117         allowance[msg.sender][spender] = allowance[msg.sender][spender].sub(subtractedValue);
118         emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
119         return true;
120     }
121 }
122 
123 contract LockToken is BaseToken {
124 
125     struct LockItem {
126         uint256 endtime;
127         uint256 remain;
128     }
129 
130     struct LockMeta {
131         uint8 lockType;
132         LockItem[] lockItems;
133     }
134 
135     mapping (address => LockMeta) public lockData;
136 
137     event Lock(address indexed lockAddress, uint8 indexed lockType, uint256[] endtimeList, uint256[] remainList);
138 
139     function _transfer(address from, address to, uint value) internal {
140         uint8 lockType = lockData[from].lockType;
141         if (lockType != 0) {
142             uint256 remain = balanceOf[from].sub(value);
143             uint256 length = lockData[from].lockItems.length;
144             for (uint256 i = 0; i < length; i++) {
145                 LockItem storage item = lockData[from].lockItems[i];
146                 if (block.timestamp < item.endtime && remain < item.remain) {
147                     revert();
148                 }
149             }
150         }
151         super._transfer(from, to, value);
152     }
153 
154     function lock(address lockAddress, uint8 lockType, uint256[] endtimeList, uint256[] remainList) public onlyOwner returns (bool) {
155         require(lockAddress != address(0));
156         require(lockType == 0 || lockType == 1 || lockType == 2);
157         require(lockData[lockAddress].lockType != 1);
158 
159         lockData[lockAddress].lockItems.length = 0;
160 
161         lockData[lockAddress].lockType = lockType;
162         if (lockType == 0) {
163             emit Lock(lockAddress, lockType, endtimeList, remainList);
164             return true;
165         }
166 
167         require(endtimeList.length == remainList.length);
168         uint256 length = endtimeList.length;
169         require(length > 0 && length <= 12);
170         uint256 thisEndtime = endtimeList[0];
171         uint256 thisRemain = remainList[0];
172         lockData[lockAddress].lockItems.push(LockItem({endtime: thisEndtime, remain: thisRemain}));
173         for (uint256 i = 1; i < length; i++) {
174             require(endtimeList[i] > thisEndtime && remainList[i] < thisRemain);
175             lockData[lockAddress].lockItems.push(LockItem({endtime: endtimeList[i], remain: remainList[i]}));
176             thisEndtime = endtimeList[i];
177             thisRemain = remainList[i];
178         }
179 
180         emit Lock(lockAddress, lockType, endtimeList, remainList);
181         return true;
182     }
183 }
184 
185 contract CustomToken is BaseToken, LockToken {
186     constructor() public {
187         balanceOf[0x69AD4582F25a5bAE004d4ceC3E5311bd8602AEB1] = totalSupply;
188         emit Transfer(address(0), 0x69AD4582F25a5bAE004d4ceC3E5311bd8602AEB1, totalSupply);
189 
190         owner = 0x69AD4582F25a5bAE004d4ceC3E5311bd8602AEB1;
191     }
192 }